import 'package:flutter/material.dart';
import 'package:url_launcher/link.dart';

import '../../theme.dart';

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
  final IconData? icon;
  final bool primary;

  @override
  Widget build(BuildContext context) {
    return Link(
      uri: Uri.parse(url),
      target: _targetFor(url),
      builder: (context, followLink) {
        final text = Text(label);
        if (primary) {
          return icon == null
              ? FilledButton(onPressed: followLink, child: text)
              : FilledButton.icon(
                  onPressed: followLink,
                  icon: Icon(icon, size: 18),
                  label: text,
                );
        }
        return icon == null
            ? OutlinedButton(onPressed: followLink, child: text)
            : OutlinedButton.icon(
                onPressed: followLink,
                icon: Icon(icon, size: 18),
                label: text,
              );
      },
    );
  }
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
          TextButton(onPressed: followLink, child: Text('$label ↗')),
    );
  }
}

class SectionHeader extends StatelessWidget {
  const SectionHeader({super.key, required this.eyebrow, required this.title});

  final String eyebrow;
  final String title;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 28),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(eyebrow.toUpperCase(), style: AppText.eyebrow),
          const SizedBox(height: 8),
          Semantics(
            header: true,
            headingLevel: 2,
            child: Text(title, style: AppText.sectionTitle),
          ),
        ],
      ),
    );
  }
}

class TagList extends StatelessWidget {
  const TagList(this.items, {super.key});

  final List<String> items;

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: 6,
      runSpacing: 6,
      children: [
        for (final item in items)
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 4),
            decoration: BoxDecoration(
              color: AppColors.paper,
              border: Border.all(color: AppColors.line),
              borderRadius: BorderRadius.circular(6),
            ),
            child: Text(
              item,
              style: AppText.label.copyWith(color: AppColors.inkSoft),
            ),
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
                    decoration: const BoxDecoration(
                      color: AppColors.accent,
                      shape: BoxShape.circle,
                    ),
                  ),
                ),
                Expanded(child: Text(item, style: AppText.body)),
              ],
            ),
          ),
      ],
    );
  }
}

class Panel extends StatelessWidget {
  const Panel({super.key, required this.child, this.color});

  final Widget child;
  final Color? color;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(isCompact(context) ? 18 : 24),
      decoration: BoxDecoration(
        color: color ?? AppColors.surface,
        border: Border.all(color: AppColors.line),
        borderRadius: BorderRadius.circular(12),
      ),
      child: child,
    );
  }
}
