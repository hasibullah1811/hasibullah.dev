import 'package:flutter/material.dart';
import 'package:url_launcher/link.dart';

import '../../theme.dart';
import '../motion.dart';

bool isCompact(BuildContext context) => MediaQuery.sizeOf(context).width < 600;

/// The one spacing scale. Every gap on the page is one of these.
abstract final class Space {
  static const xs = 4.0;
  static const s = 8.0;
  static const m = 12.0;
  static const l = 16.0;
  static const xl = 24.0;
  static const xxl = 32.0;
  static const xxxl = 48.0;

  /// Between sections: compact, then wide screens.
  static const section = 96.0;
  static const sectionWide = 128.0;
}

/// The one set of corner radii.
abstract final class Radii {
  /// Cards and images.
  static const card = 12.0;

  /// Tags, chips and buttons.
  static const small = 6.0;
}

/// Body text never runs wider than this (about 65–75 characters).
const bodyMaxWidth = 640.0;

/// Caps [child] at [bodyMaxWidth].
class Measure extends StatelessWidget {
  const Measure({super.key, required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) => ConstrainedBox(
    constraints: const BoxConstraints(maxWidth: bodyMaxWidth),
    child: child,
  );
}

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

/// Section label, then the heading. Static: the whole section fades in
/// once, from the page.
class SectionHeader extends StatelessWidget {
  const SectionHeader({super.key, required this.eyebrow, required this.title});

  final String eyebrow;
  final String title;

  @override
  Widget build(BuildContext context) {
    final text = AppText.of(context);
    return Padding(
      padding: const EdgeInsets.only(bottom: Space.xxl),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(eyebrow.toUpperCase(), style: text.eyebrow),
          const SizedBox(height: Space.s),
          Semantics(
            header: true,
            headingLevel: 2,
            child: Text(
              title,
              style: isCompact(context)
                  ? text.sectionTitle.copyWith(fontSize: 26)
                  : text.sectionTitle,
            ),
          ),
        ],
      ),
    );
  }
}

/// A small uppercase label above a group of rows.
class GroupLabel extends StatelessWidget {
  const GroupLabel(this.label, {super.key});

  final String label;

  @override
  Widget build(BuildContext context) => Padding(
    padding: const EdgeInsets.only(bottom: Space.s),
    child: Text(label.toUpperCase(), style: AppText.of(context).label),
  );
}

/// A text toggle such as "Details" or "Abstract". Closed by default; the
/// owner keeps the state and shows the content below.
class DisclosureButton extends StatelessWidget {
  const DisclosureButton({
    super.key,
    required this.label,
    required this.open,
    required this.onPressed,
  });

  final String label;
  final bool open;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return Semantics(
      expanded: open,
      child: TextButton.icon(
        onPressed: onPressed,
        iconAlignment: IconAlignment.end,
        icon: AnimatedRotation(
          turns: open ? 0.5 : 0,
          duration: Motion.reduced(context) ? Duration.zero : Motion.hover,
          child: const Icon(Icons.expand_more_rounded, size: 18),
        ),
        label: Text(label),
      ),
    );
  }
}

/// Content under a [DisclosureButton]. Takes no space while closed.
class Disclosed extends StatelessWidget {
  const Disclosed({super.key, required this.open, required this.child});

  final bool open;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return AnimatedSize(
      duration: Motion.reduced(context) ? Duration.zero : Motion.hover,
      curve: Motion.curve,
      alignment: Alignment.topLeft,
      child: open
          ? Padding(
              padding: const EdgeInsets.only(top: Space.xs, bottom: Space.s),
              child: Measure(child: child),
            )
          : const SizedBox(width: double.infinity),
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
              borderRadius: BorderRadius.circular(Radii.small),
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

/// The one card style: opaque surface, hairline border, no shadow. Opaque,
/// so text on it never sits on the background dots or symbols.
class AppCard extends StatelessWidget {
  const AppCard({super.key, required this.child, this.padding, this.color});

  final Widget child;

  /// Defaults to [defaultPadding].
  final EdgeInsetsGeometry? padding;

  /// Defaults to the theme's surface.
  final Color? color;

  static EdgeInsets defaultPadding(BuildContext context) =>
      EdgeInsets.all(isCompact(context) ? Space.l : Space.xl);

  @override
  Widget build(BuildContext context) {
    final c = AppColors.of(context);
    return Container(
      width: double.infinity,
      padding: padding ?? defaultPadding(context),
      decoration: BoxDecoration(
        color: color ?? c.surface,
        border: Border.all(color: c.line),
        borderRadius: BorderRadius.circular(Radii.card),
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
    this.gap = Space.m,
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
