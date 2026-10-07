import 'dart:async';
import 'dart:math' as math;
import 'dart:ui' as ui;

import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';

import '../../theme.dart';
import '../motion.dart';
import '../theme_transition.dart';

/// The glyphs that drift up near the pointer. Edit freely; each entry is
/// drawn as one piece of text in Geist Mono.
const codeSymbols = [
  '{',
  '}',
  '<',
  '/>',
  '(',
  ')',
  '[',
  ']',
  ';',
  '=>',
  '#',
  '//',
  '&&',
  '::',
];

/// Everything behind the page, fixed to the viewport:
///
/// 1. A faint dot grid (ink at 7%), painted once into a cached layer. On
///    touch devices that layer drifts slowly (a transform, no repaint).
/// 2. Code symbols, in the theme's symbol colour (terracotta, a few in ink
///    on the light page). With a mouse, a few appear around the pointer,
///    fade in over 120ms, hold 150ms and ease out over 900ms, over a soft
///    accent glow that follows the pointer; the ticker runs only while
///    something is visible. On touch, and with reduced motion, a sparse fixed
///    scatter is painted into the grid layer instead (drifting with it on
///    touch, static and fainter with reduced motion).
/// 3. In dark mode, a few stars in the side margins, clear of the text
///    column, twinkling very slowly at about 8 frames a second.
///
/// No layer takes pointer events or appears in the semantics tree. Where text
/// overlaps the strongest symbol on the glow, every text colour still clears
/// 4.5:1 in both themes; the opacities live in theme.dart.
/// Everything pauses while the tab is hidden.
class PageBackground extends StatefulWidget {
  const PageBackground({
    super.key,
    required this.textColumnWidth,
    required this.child,
  });

  /// Width of the centred text column; stars stay outside it.
  final double textColumnWidth;
  final Widget child;

  static const spacing = 24.0;
  static const radius = 1.0;
  static const dotAlpha = 0.07;

  /// Glyph size of the code symbols.
  static const symbolSize = 20.0;

  /// Radius of the glow under the pointer.
  static const glowRadius = 160.0;

  /// The fixed scatter (touch, reduced motion) as a fraction of the theme's
  /// peak symbol opacity.
  static const scatterScale = 0.7;
  static const reducedScatterScale = 0.5;

  @override
  State<PageBackground> createState() => _PageBackgroundState();
}

class _PageBackgroundState extends State<PageBackground>
    with TickerProviderStateMixin {
  late final AnimationController _drift = AnimationController(
    vsync: this,
    duration: const Duration(seconds: 60),
  );
  late final Ticker _ticker = createTicker(_tick);
  final _field = _SymbolField();
  final _sky = ValueNotifier<double>(0);
  final _random = math.Random();
  late final AppLifecycleListener _lifecycle;
  Timer? _twinkle;

  bool _reduced = false;
  bool _dark = false;
  Offset? _lastSpawn;
  Duration _lastSpawnAt = Duration.zero;
  final _clock = Stopwatch()..start();

  // Mobile browsers report a touch platform; a real mouse turns drift off.
  bool _touch =
      defaultTargetPlatform == TargetPlatform.android ||
      defaultTargetPlatform == TargetPlatform.iOS;

  _GlyphAtlas? _atlas;
  int _fontGeneration = 0;

  static const _maxAlive = 5;
  static const _minTravel = 80.0;
  static const _minGap = 56.0;
  static const _minInterval = Duration(milliseconds: 140);

  @override
  void initState() {
    super.initState();
    _lifecycle = AppLifecycleListener(onStateChange: (_) => _updateMotion());
    // Fonts load after the first frame on the web; re-rasterise the glyphs
    // once Geist Mono arrives.
    PaintingBinding.instance.systemFonts.addListener(_onFonts);
  }

  void _onFonts() {
    if (!mounted) return;
    setState(() => _fontGeneration++);
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _reduced = Motion.reduced(context);
    _dark = AppColors.of(context).isDark;
    _updateMotion();
  }

  bool get _visible {
    final state = WidgetsBinding.instance.lifecycleState;
    return state != AppLifecycleState.hidden &&
        state != AppLifecycleState.paused;
  }

  void _updateMotion() {
    final visible = _visible;
    final drift = _touch && !_reduced && visible;
    if (drift && !_drift.isAnimating) {
      _drift.repeat();
    } else if (!drift && _drift.isAnimating) {
      _drift.stop();
    }

    if (!visible || _reduced) _clearSymbols();

    final twinkle = _dark && !_reduced && visible;
    if (twinkle && _twinkle == null) {
      _twinkle = Timer.periodic(const Duration(milliseconds: 125), (_) {
        _sky.value = _clock.elapsedMilliseconds / 1000;
      });
    } else if (!twinkle && _twinkle != null) {
      _twinkle!.cancel();
      _twinkle = null;
    }
  }

  void _clearSymbols() {
    if (_ticker.isActive) _ticker.stop();
    if (_field.symbols.isNotEmpty || _field.glowAt != null) {
      _field.symbols.clear();
      _field.glowAt = null;
      _field.changed();
    }
  }

  _GlyphAtlas _glyphs(AppColors colors, double pixelRatio) {
    final atlas = _atlas;
    if (atlas != null &&
        atlas.color == colors.symbolColor &&
        atlas.inkColor == colors.ink &&
        atlas.pixelRatio == pixelRatio &&
        atlas.fontGeneration == _fontGeneration) {
      return atlas;
    }
    final next = _GlyphAtlas(
      color: colors.symbolColor,
      inkColor: colors.ink,
      pixelRatio: pixelRatio,
      fontGeneration: _fontGeneration,
    );
    _atlas = next;
    // The old image may still be referenced by this frame's painters.
    if (atlas != null) {
      SchedulerBinding.instance.addPostFrameCallback((_) => atlas.dispose());
    }
    return next;
  }

  void _onHover(PointerHoverEvent event) {
    if (_reduced) return;
    if (_touch) {
      setState(() => _touch = false);
      _updateMotion();
    }
    final now = _clock.elapsed;
    final p = event.localPosition;
    _field.now = now;
    if (_field.glowAt == null) _field.glowStart = now;
    _field.glowAt = p;
    _field.glowLast = now;
    if (!_ticker.isActive) _ticker.start();

    final last = _lastSpawn;
    if (last != null && (p - last).distance < _minTravel) return;
    if (now - _lastSpawnAt < _minInterval) return;
    if (_field.symbols.length >= _maxAlive) return;

    final angle = _random.nextDouble() * 2 * math.pi;
    final distance = 30 + _random.nextDouble() * 34;
    final centre = p + Offset(math.cos(angle), math.sin(angle)) * distance;
    for (final s in _field.symbols) {
      if ((s.centre - centre).distance < _minGap) return;
    }
    _lastSpawn = p;
    _lastSpawnAt = now;
    _field.symbols.add(
      _Symbol(
        glyph: _random.nextInt(codeSymbols.length),
        ink: _random.nextInt(4) == 0,
        centre: centre,
        born: now,
      ),
    );
  }

  void _tick(Duration _) {
    final now = _clock.elapsed;
    _field.now = now;
    _field.symbols.removeWhere((s) => now - s.born >= _Fade.life);
    if (_field.glowAt != null && now - _field.glowLast >= _Fade.life) {
      _field.glowAt = null;
    }
    // One last repaint to clear what was visible, then stop.
    if (_field.symbols.isEmpty && _field.glowAt == null) _ticker.stop();
    _field.changed();
  }

  @override
  void dispose() {
    PaintingBinding.instance.systemFonts.removeListener(_onFonts);
    _lifecycle.dispose();
    _twinkle?.cancel();
    _ticker.dispose();
    _drift.dispose();
    _field.dispose();
    _sky.dispose();
    _atlas?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final colors = AppColors.of(context);
    final pixelRatio = MediaQuery.devicePixelRatioOf(context);
    final scatter = _touch || _reduced;
    final scatterScale = _reduced
        ? PageBackground.reducedScatterScale
        : PageBackground.scatterScale;
    final atlas = _glyphs(colors, pixelRatio);
    final starsIn = ThemeTransitionScope.starsOf(context);

    return MouseRegion(
      opaque: false,
      onHover: _onHover,
      child: Stack(
        children: [
          Positioned.fill(
            child: IgnorePointer(
              child: ExcludeSemantics(
                child: ClipRect(
                  child: AnimatedBuilder(
                    animation: _drift,
                    builder: (context, child) {
                      // Rests one grid step up and left, and loops less than
                      // half a step around that, so the oversized layer
                      // never shows an edge.
                      final a = _drift.value * 2 * math.pi;
                      const step = PageBackground.spacing;
                      return Transform.translate(
                        offset: Offset(
                          step / 2 * math.sin(a) - step,
                          step / 4 * math.sin(2 * a) - step,
                        ),
                        child: child,
                      );
                    },
                    child: OverflowBox(
                      alignment: Alignment.topLeft,
                      maxWidth: double.infinity,
                      maxHeight: double.infinity,
                      child: LayoutBuilder(
                        builder: (context, _) {
                          final size = MediaQuery.sizeOf(context);
                          return RepaintBoundary(
                            child: CustomPaint(
                              size: Size(
                                size.width + PageBackground.spacing * 2,
                                size.height + PageBackground.spacing * 2,
                              ),
                              painter: _GridPainter(
                                dot: colors.ink.withValues(
                                  alpha: PageBackground.dotAlpha,
                                ),
                                atlas: scatter ? atlas : null,
                                symbolAlpha:
                                    colors.symbolPeakOpacity * scatterScale,
                                inkAlpha:
                                    colors.symbolInkPeakOpacity * scatterScale,
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
          if (colors.isDark)
            Positioned.fill(
              child: IgnorePointer(
                child: ExcludeSemantics(
                  child: RepaintBoundary(
                    child: CustomPaint(
                      painter: _NightSkyPainter(
                        time: _sky,
                        fadeIn: starsIn,
                        color: colors.ink,
                        textColumnWidth: widget.textColumnWidth,
                        gutter: MediaQuery.sizeOf(context).width < 600
                            ? 20
                            : 32,
                      ),
                    ),
                  ),
                ),
              ),
            ),
          if (!scatter)
            Positioned.fill(
              child: IgnorePointer(
                child: ExcludeSemantics(
                  child: RepaintBoundary(
                    child: CustomPaint(
                      painter: _SymbolPainter(
                        field: _field,
                        atlas: atlas,
                        alpha: colors.symbolPeakOpacity,
                        inkAlpha: colors.symbolInkPeakOpacity,
                        glow: colors.symbolGlowColor,
                      ),
                    ),
                  ),
                ),
              ),
            ),
          widget.child,
        ],
      ),
    );
  }
}

class _Symbol {
  _Symbol({
    required this.glyph,
    required this.ink,
    required this.centre,
    required this.born,
  });

  final int glyph;

  /// Drawn in ink rather than the symbol colour, where the theme has ink
  /// symbols.
  final bool ink;
  final Offset centre;
  final Duration born;
}

class _SymbolField extends ChangeNotifier {
  final symbols = <_Symbol>[];
  Duration now = Duration.zero;

  /// The pointer, while its glow is visible.
  Offset? glowAt;
  Duration glowStart = Duration.zero;
  Duration glowLast = Duration.zero;

  void changed() => notifyListeners();
}

/// The shared envelope of a symbol and of the glow: in over 120ms, hold
/// 150ms, then ease out over 900ms.
abstract final class _Fade {
  static const fadeIn = Duration(milliseconds: 120);
  static const hold = Duration(milliseconds: 150);
  static const fadeOut = Duration(milliseconds: 900);
  static const life = Duration(milliseconds: 1170); // the three together

  /// 0 to 1 over [fadeIn], [elapsed] after the start.
  static double rise(Duration elapsed) =>
      (elapsed.inMicroseconds / fadeIn.inMicroseconds).clamp(0.0, 1.0);

  /// 1 for [hold], then down to 0 over [fadeOut], [elapsed] after the end of
  /// the rise (or the last pointer move).
  static double fall(Duration elapsed) {
    final t = ((elapsed - hold).inMicroseconds / fadeOut.inMicroseconds).clamp(
      0.0,
      1.0,
    );
    return 1 - Curves.easeOut.transform(t);
  }

  static double symbol(Duration age) =>
      age < fadeIn ? rise(age) : fall(age - fadeIn);
}

/// Every symbol rasterised once, side by side, into one small image. Painting
/// a symbol is then a single drawImageRect with an alpha, with no text
/// layout per frame.
class _GlyphAtlas {
  factory _GlyphAtlas({
    required Color color,
    required Color inkColor,
    required double pixelRatio,
    required int fontGeneration,
  }) {
    const gap = 4.0;
    const rowHeight = PageBackground.symbolSize + gap;
    final recorder = ui.PictureRecorder();
    final canvas = Canvas(recorder)..scale(pixelRatio);
    final sizes = <Size>[];
    // The symbol colour on the first row, ink on the second.
    final sources = <Rect>[];
    var width = 0.0;
    for (final (row, tone) in [color, inkColor].indexed) {
      var x = 0.0;
      final y = row * rowHeight;
      for (final symbol in codeSymbols) {
        final painter = TextPainter(
          text: TextSpan(
            text: symbol,
            style: TextStyle(
              fontFamily: AppFonts.mono,
              fontSize: PageBackground.symbolSize,
              height: 1,
              color: tone,
            ),
          ),
          textDirection: TextDirection.ltr,
        )..layout();
        painter.paint(canvas, Offset(x, y));
        final size = painter.size;
        if (row == 0) sizes.add(size);
        sources.add(
          Rect.fromLTWH(
            x * pixelRatio,
            y * pixelRatio,
            size.width * pixelRatio,
            size.height * pixelRatio,
          ),
        );
        x += size.width + gap;
        painter.dispose();
      }
      width = math.max(width, x);
    }
    final picture = recorder.endRecording();
    final image = picture.toImageSync(
      math.max(1, (width * pixelRatio).ceil()),
      (rowHeight * 2 * pixelRatio).ceil(),
    );
    picture.dispose();
    return _GlyphAtlas._(
      image: image,
      sizes: sizes,
      sources: sources,
      color: color,
      inkColor: inkColor,
      pixelRatio: pixelRatio,
      fontGeneration: fontGeneration,
    );
  }

  _GlyphAtlas._({
    required this.image,
    required this.sizes,
    required this.sources,
    required this.color,
    required this.inkColor,
    required this.pixelRatio,
    required this.fontGeneration,
  });

  final ui.Image image;
  final List<Size> sizes;
  final List<Rect> sources;
  final Color color;
  final Color inkColor;
  final double pixelRatio;
  final int fontGeneration;

  final _paint = Paint()..filterQuality = FilterQuality.low;

  void draw(
    Canvas canvas,
    int glyph,
    Offset centre,
    double alpha, {
    bool ink = false,
  }) {
    final size = sizes[glyph];
    canvas.drawImageRect(
      image,
      sources[ink ? codeSymbols.length + glyph : glyph],
      Rect.fromCenter(center: centre, width: size.width, height: size.height),
      _paint..color = Color.fromRGBO(0, 0, 0, alpha),
    );
  }

  void dispose() => image.dispose();
}

class _GridPainter extends CustomPainter {
  _GridPainter({
    required this.dot,
    required this.atlas,
    required this.symbolAlpha,
    required this.inkAlpha,
  });

  final Color dot;

  /// Draws the fixed symbol scatter when set.
  final _GlyphAtlas? atlas;
  final double symbolAlpha;

  /// Alpha of the scatter's ink symbols; 0 for none.
  final double inkAlpha;

  @override
  void paint(Canvas canvas, Size size) {
    const step = PageBackground.spacing;
    final points = <Offset>[];
    for (var y = step / 2; y < size.height; y += step) {
      for (var x = step / 2; x < size.width; x += step) {
        points.add(Offset(x, y));
      }
    }
    // One draw call for the whole grid.
    canvas.drawPoints(
      ui.PointMode.points,
      points,
      Paint()
        ..color = dot
        ..strokeWidth = PageBackground.radius * 2
        ..strokeCap = StrokeCap.round,
    );

    final atlas = this.atlas;
    if (atlas == null) return;
    // About one symbol per 150px cell, a quarter of cells filled, placed
    // between grid dots. Seeded, so the layout is stable across repaints.
    const cell = 150.0;
    final random = math.Random(7);
    for (var y = 0.0; y < size.height; y += cell) {
      for (var x = 0.0; x < size.width; x += cell) {
        final fill = random.nextDouble() < 0.25;
        final glyph = random.nextInt(codeSymbols.length);
        final dx = (1 + random.nextInt(4)) * step;
        final dy = (1 + random.nextInt(4)) * step;
        final ink = inkAlpha > 0 && random.nextInt(4) == 0;
        if (fill) {
          atlas.draw(
            canvas,
            glyph,
            Offset(x + dx, y + dy),
            ink ? inkAlpha : symbolAlpha,
            ink: ink,
          );
        }
      }
    }
  }

  @override
  bool shouldRepaint(_GridPainter old) =>
      old.dot != dot ||
      old.atlas != atlas ||
      old.symbolAlpha != symbolAlpha ||
      old.inkAlpha != inkAlpha;
}

class _SymbolPainter extends CustomPainter {
  _SymbolPainter({
    required this.field,
    required this.atlas,
    required this.alpha,
    required this.inkAlpha,
    required this.glow,
  }) : super(repaint: field);

  final _SymbolField field;
  final _GlyphAtlas atlas;
  final double alpha;
  final double inkAlpha;

  /// Centre colour of the glow under the pointer.
  final Color glow;

  // Built once per painter (per theme), centred on the origin and moved with
  // a translate, so a frame allocates nothing.
  late final _glowPaint = Paint()
    ..shader = ui.Gradient.radial(
      Offset.zero,
      PageBackground.glowRadius,
      [glow, glow.withValues(alpha: glow.a * 0.35), glow.withValues(alpha: 0)],
      const [0, 0.45, 1],
    );

  @override
  void paint(Canvas canvas, Size size) {
    final now = field.now;
    final glowAt = field.glowAt;
    if (glowAt != null) {
      final strength = math.min(
        _Fade.rise(now - field.glowStart),
        _Fade.fall(now - field.glowLast),
      );
      if (strength > 0) {
        canvas
          ..save()
          ..translate(glowAt.dx, glowAt.dy)
          ..drawCircle(
            Offset.zero,
            PageBackground.glowRadius,
            _glowPaint..color = Color.fromRGBO(0, 0, 0, strength),
          )
          ..restore();
      }
    }
    for (final symbol in field.symbols) {
      final age = now - symbol.born;
      final strength = _Fade.symbol(age);
      if (strength <= 0) continue;
      final ink = symbol.ink && inkAlpha > 0;
      // Rising 12px over its life.
      final rise =
          12 * (age.inMicroseconds / _Fade.life.inMicroseconds).clamp(0.0, 1.0);
      atlas.draw(
        canvas,
        symbol.glyph,
        symbol.centre - Offset(0, rise),
        (ink ? inkAlpha : alpha) * strength,
        ink: ink,
      );
    }
  }

  @override
  bool shouldRepaint(_SymbolPainter old) =>
      old.field != field ||
      old.atlas != atlas ||
      old.alpha != alpha ||
      old.inkAlpha != inkAlpha ||
      old.glow != glow;
}

class _Star {
  const _Star(this.position, this.radius, this.alpha, this.period, this.phase);

  final Offset position;
  final double radius;
  final double alpha;
  final double period;
  final double phase;
}

/// A few faint stars in the margins either side of the text column.
class _NightSkyPainter extends CustomPainter {
  _NightSkyPainter({
    required this.time,
    required this.fadeIn,
    required this.color,
    required this.textColumnWidth,
    required this.gutter,
  }) : super(repaint: Listenable.merge([time, fadeIn]));

  final ValueListenable<double> time;
  final Animation<double> fadeIn;
  final Color color;
  final double textColumnWidth;
  final double gutter;

  Size? _laidOutFor;
  List<_Star> _stars = const [];

  List<_Star> _layout(Size size) {
    // Text never comes closer than the column's own padding.
    final margin = math.max(0.0, (size.width - textColumnWidth) / 2) + gutter;
    final band = margin - 14;
    if (band < 4) return const [];
    final wide = band > 60;
    final random = math.Random(11);
    final perSide = (size.height / (wide ? 70 : 150)).floor();
    return [
      for (var side = 0; side < 2; side++)
        for (var i = 0; i < perSide; i++)
          () {
            final x = 6 + random.nextDouble() * (band - 6);
            return _Star(
              Offset(
                side == 0 ? x : size.width - x,
                random.nextDouble() * size.height,
              ),
              0.6 + random.nextDouble() * (wide ? 0.8 : 0.4),
              0.25 + random.nextDouble() * 0.3,
              6 + random.nextDouble() * 5,
              random.nextDouble() * 2 * math.pi,
            );
          }(),
    ];
  }

  @override
  void paint(Canvas canvas, Size size) {
    if (_laidOutFor != size) {
      _stars = _layout(size);
      _laidOutFor = size;
    }
    final fade = fadeIn.value;
    if (fade <= 0 || _stars.isEmpty) return;
    final now = time.value;
    final paint = Paint();
    for (final star in _stars) {
      final twinkle =
          0.65 + 0.35 * math.sin(now * 2 * math.pi / star.period + star.phase);
      canvas.drawCircle(
        star.position,
        star.radius,
        paint..color = color.withValues(alpha: star.alpha * twinkle * fade),
      );
    }
  }

  @override
  bool shouldRepaint(_NightSkyPainter old) =>
      old.color != color ||
      old.textColumnWidth != textColumnWidth ||
      old.gutter != gutter ||
      old.time != time ||
      old.fadeIn != fadeIn;
}
