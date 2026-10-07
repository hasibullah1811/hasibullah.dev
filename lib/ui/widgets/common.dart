import 'package:flutter/material.dart';
import 'package:url_launcher/link.dart';

import '../../theme.dart';
import '../motion.dart';

bool isCompact(BuildContext context) => MediaQuery.sizeOf(context).width < 600;

// Links are built on url_launcher's [Link], so on the web each one is a real
// <a href> (middle-click, copy link, screen-reader "link") wrapped in a
// focusable Material button for keyboard users.
LinkTarget _targetFor(String url) =>
    url.startsWith('mailto:') ? LinkTarget.self : LinkTarget.blank;

class LinkButton extends StatelessWidget {
  const LinkButton({
    super.key,
    required this.label,
    required this.url,
    this.icon,
    this.primary = false,
  });

  final String label;
  final String url;

  /// Usually an [Icon] or a brand icon at size 16–18.
  final Widget? icon;
  final bool primary;

  @override
  Widget build(BuildContext context) {
    return Link(
      uri: Uri.parse(url),
      target: _targetFor(url),
      builder: (context, followLink) {
        final text = Text(label);
        final icon = this.icon;
        if (primary) {
          return icon == null
              ? FilledButton(onPressed: followLink, child: text)
              : FilledButton.icon(
                  onPressed: followLink,
                  icon: icon,
                  label: text,
                );
        }
        return icon == null
            ? OutlinedButton(onPressed: followLink, child: text)
            : OutlinedButton.icon(
                onPressed: followLink,
                icon: icon,
                label: text,
              );
      },
    );
  }
}

/// A text button whose underline draws in on hover and keyboard focus.
class UnderlineButton extends StatefulWidget {
  const UnderlineButton({
    super.key,
    required this.label,
    required this.onPressed,
    this.style,
  });

  final String label;
  final VoidCallback? onPressed;
  final ButtonStyle? style;

  @override
  State<UnderlineButton> createState() => _UnderlineButtonState();
}

class _UnderlineButtonState extends State<UnderlineButton> {
  bool _hovered = false;
  bool _focused = false;

  @override
  Widget build(BuildContext context) {
    final active = _hovered || _focused;
    return TextButton(
      style: widget.style,
      onPressed: widget.onPressed,
      onHover: (value) => setState(() => _hovered = value),
      onFocusChange: (value) => setState(() => _focused = value),
      child: Builder(
        builder: (context) {
          // The button's foreground colour, so the line matches the text.
          final color =
              DefaultTextStyle.of(context).style.color ??
              AppColors.of(context).accent;
          return TweenAnimationBuilder<double>(
            tween: Tween(end: active ? 1 : 0),
            duration: Motion.reduced(context) ? Duration.zero : Motion.hover,
            curve: Motion.curve,
            builder: (context, t, child) => CustomPaint(
              foregroundPainter: _UnderlinePainter(t, color),
              child: child,
            ),
            child: Padding(
              padding: const EdgeInsets.only(bottom: 3),
              child: Text(widget.label),
            ),
          );
        },
      ),
    );
  }
}

class _UnderlinePainter extends CustomPainter {
  _UnderlinePainter(this.t, this.color);

  final double t;
  final Color color;

  @override
  void paint(Canvas canvas, Size size) {
    if (t <= 0) return;
    canvas.drawRect(
      Rect.fromLTWH(0, size.height - 1.5, size.width * t, 1.5),
      Paint()..color = color,
    );
  }

  @override
  bool shouldRepaint(_UnderlinePainter old) => old.t != t || old.color != color;
}

class InlineLink extends StatelessWidget {
  const InlineLink({super.key, required this.label, required this.url});

  final String label;
  final String url;

  @override
  Widget build(BuildContext context) {
    return Link(
      uri: Uri.parse(url),
      target: _targetFor(url),
      builder: (context, followLink) =>
          UnderlineButton(label: '$label ↗', onPressed: followLink),
    );
  }
}

/// Section label with an accent rule that draws in, then the heading.
/// The whole header fades and rises as it scrolls into view.
class SectionHeader extends StatelessWidget {
  const SectionHeader({super.key, required this.eyebrow, required this.title});

  final String eyebrow;
  final String title;

  @override
  Widget build(BuildContext context) {
    final text = AppText.of(context);
    return Padding(
      padding: const EdgeInsets.only(bottom: 28),
      child: ScrollReveal(
        duration: Motion.draw + Motion.reveal,
        builder: (context, reveal) => Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            IntrinsicWidth(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Text(eyebrow.toUpperCase(), style: text.eyebrow),
                  const SizedBox(height: 6),
                  DrawLine(progress: reveal, start: 0.3),
                ],
              ),
            ),
            const SizedBox(height: 10),
            Semantics(
              header: true,
              headingLevel: 2,
              child: Text(title, style: text.sectionTitle),
            ),
          ],
        ),
      ),
    );
  }
}

class TagList extends StatelessWidget {
  const TagList(this.items, {super.key});

  final List<String> items;

  @override
  Widget build(BuildContext context) {
    final c = AppColors.of(context);
    final label = AppText.of(context).label.copyWith(color: c.inkSoft);
    return Wrap(
      spacing: 6,
      runSpacing: 6,
      children: [
        for (final item in items)
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 4),
            decoration: BoxDecoration(
              color: c.tint,
              borderRadius: BorderRadius.circular(6),
            ),
            child: Text(item, style: label),
          ),
      ],
    );
  }
}

class BulletList extends StatelessWidget {
  const BulletList(this.items, {super.key});

  final List<String> items;

  @override
  Widget build(BuildContext context) {
    final c = AppColors.of(context);
    final body = AppText.of(context).body;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        for (final item in items)
          Padding(
            padding: const EdgeInsets.only(bottom: 8),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.only(top: 10, right: 12),
                  child: Container(
                    width: 5,
                    height: 5,
                    decoration: BoxDecoration(
                      color: c.accent,
                      shape: BoxShape.circle,
                    ),
                  ),
                ),
                Expanded(child: Text(item, style: body)),
              ],
            ),
          ),
      ],
    );
  }
}

/// A card that lifts slightly on hover. Opaque, so text on it never sits on
/// the background dots or symbols. Light cards gain a soft shadow on hover;
/// dark cards only a stronger border.
///
/// Every card on the site uses [LiftCard.defaultPadding] and
/// [LiftCard.radius] unless it is a feature card.
class LiftCard extends StatefulWidget {
  const LiftCard({
    super.key,
    required this.child,
    this.padding,
    this.borderColor,
  });

  final Widget child;

  /// Defaults to [defaultPadding].
  final EdgeInsetsGeometry? padding;

  static const radius = 12.0;

  static EdgeInsets defaultPadding(BuildContext context) =>
      EdgeInsets.all(isCompact(context) ? 16 : 18);
  final Color? borderColor;

  @override
  State<LiftCard> createState() => _LiftCardState();
}

class _LiftCardState extends State<LiftCard> {
  bool _hovered = false;

  @override
  Widget build(BuildContext context) {
    final c = AppColors.of(context);
    final rest = widget.borderColor ?? c.line;
    final noShadow = c.hoverShadow.withValues(alpha: 0);
    // Only the hover amount animates. Colours come straight from the theme,
    // so a theme switch doesn't start an animation in every card at once.
    return MouseRegion(
      onEnter: (_) => setState(() => _hovered = true),
      onExit: (_) => setState(() => _hovered = false),
      child: TweenAnimationBuilder<double>(
        tween: Tween(end: _hovered ? 1 : 0),
        duration: Motion.reduced(context) ? Duration.zero : Motion.hover,
        curve: Motion.curve,
        builder: (context, t, child) => Container(
          width: double.infinity,
          transform: Matrix4.translationValues(0, -Motion.lift * t, 0),
          padding: widget.padding ?? LiftCard.defaultPadding(context),
          decoration: BoxDecoration(
            color: c.surface,
            borderRadius: BorderRadius.circular(LiftCard.radius),
            border: Border.all(color: Color.lerp(rest, c.lineStrong, t)!),
            boxShadow: [
              BoxShadow(
                color: Color.lerp(noShadow, c.hoverShadow, t)!,
                blurRadius: 18,
                offset: const Offset(0, 8),
              ),
            ],
          ),
          child: child,
        ),
        child: widget.child,
      ),
    );
  }
}

class Panel extends StatelessWidget {
  const Panel({super.key, required this.child, this.color});

  final Widget child;
  final Color? color;

  @override
  Widget build(BuildContext context) {
    final c = AppColors.of(context);
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(isCompact(context) ? 18 : 24),
      decoration: BoxDecoration(
        color: color ?? c.surface,
        border: Border.all(color: c.line),
        borderRadius: BorderRadius.circular(LiftCard.radius),
      ),
      child: child,
    );
  }
}

/// Lays [children] out [columns] to a row, every cell the same width and
/// every cell in a row the same height. A short last row keeps the same
/// cell width. Starts flush with the content column's left edge.
class EqualGrid extends StatelessWidget {
  const EqualGrid({
    super.key,
    required this.columns,
    required this.children,
    this.gap = 12,
  });

  final int columns;
  final List<Widget> children;
  final double gap;

  @override
  Widget build(BuildContext context) {
    if (columns <= 1) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          for (final (i, child) in children.indexed) ...[
            if (i > 0) SizedBox(height: gap),
            child,
          ],
        ],
      );
    }
    final rows = <Widget>[];
    for (var start = 0; start < children.length; start += columns) {
      if (start > 0) rows.add(SizedBox(height: gap));
      rows.add(
        IntrinsicHeight(
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              for (var i = start; i < start + columns; i++) ...[
                if (i > start) SizedBox(width: gap),
                Expanded(
                  child: i < children.length
                      ? children[i]
                      : const SizedBox.shrink(),
                ),
              ],
            ],
          ),
        ),
      );
    }
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: rows,
    );
  }
}
