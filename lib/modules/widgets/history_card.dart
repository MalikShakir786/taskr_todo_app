import 'package:flutter/material.dart';

import '../../models/deleted_item.dart';

class HistoryCard extends StatefulWidget {
  final DeletedItem deleted;
  final String timeAgo;
  final Color priorityColor;
  final VoidCallback onRestore;
  final VoidCallback onRemovePermanently;

  const HistoryCard({
    super.key,
    required this.deleted,
    required this.timeAgo,
    required this.priorityColor,
    required this.onRestore,
    required this.onRemovePermanently,
  });

  @override
  State<HistoryCard> createState() => HistoryCardState();
}

class HistoryCardState extends State<HistoryCard>
    with SingleTickerProviderStateMixin {
  late AnimationController _ctrl;
  late Animation<double> _anim;

  @override
  void initState() {
    super.initState();
    _ctrl = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 300));
    _anim = CurvedAnimation(parent: _ctrl, curve: Curves.easeOut);
    _ctrl.forward();
  }

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final item = widget.deleted.item;

    return FadeTransition(
      opacity: _anim,
      child: Container(
        margin: const EdgeInsets.only(bottom: 10),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: const Color(0xFF13131A),
          borderRadius: BorderRadius.circular(14),
          border: Border.all(
            color: const Color(0xFFFF4F5E).withOpacity(0.08),
          ),
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.only(top: 4),
              child: Container(
                width: 8,
                height: 8,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: widget.priorityColor.withOpacity(0.5),
                ),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    item.title ?? '',
                    style: const TextStyle(
                      color: Colors.white38,
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      decoration: TextDecoration.lineThrough,
                      decorationColor: Colors.white24,
                    ),
                  ),
                  if (item.description != null) ...[
                    const SizedBox(height: 3),
                    Text(
                      item.description!,
                      style: const TextStyle(
                          color: Colors.white24, fontSize: 11),
                    ),
                  ],
                  const SizedBox(height: 6),
                  Row(
                    children: [
                      const Icon(Icons.access_time_rounded,
                          color: Colors.white24, size: 11),
                      const SizedBox(width: 4),
                      Text(
                        'deleted ${widget.timeAgo}',
                        style: const TextStyle(
                          color: Colors.white24,
                          fontSize: 10,
                          fontFamily: 'Courier',
                          letterSpacing: 0.5,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(width: 8),
            Column(
              children: [
                GestureDetector(
                  onTap: widget.onRestore,
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 10, vertical: 6),
                    decoration: BoxDecoration(
                      color: const Color(0xFF4FFFB0).withOpacity(0.1),
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(
                        color: const Color(0xFF4FFFB0).withOpacity(0.25),
                      ),
                    ),
                    child: const Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(Icons.restore_rounded,
                            color: Color(0xFF4FFFB0), size: 13),
                        SizedBox(width: 4),
                        Text(
                          'RESTORE',
                          style: TextStyle(
                            color: Color(0xFF4FFFB0),
                            fontSize: 9,
                            fontWeight: FontWeight.w800,
                            letterSpacing: 1.2,
                            fontFamily: 'Courier',
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 6),
                GestureDetector(
                  onTap: widget.onRemovePermanently,
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 10, vertical: 6),
                    decoration: BoxDecoration(
                      color: const Color(0xFFFF4F5E).withOpacity(0.08),
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(
                        color: const Color(0xFFFF4F5E).withOpacity(0.2),
                      ),
                    ),
                    child: const Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(Icons.delete_forever_rounded,
                            color: Color(0xFFFF4F5E), size: 13),
                        SizedBox(width: 4),
                        Text(
                          'PURGE',
                          style: TextStyle(
                            color: Color(0xFFFF4F5E),
                            fontSize: 9,
                            fontWeight: FontWeight.w800,
                            letterSpacing: 1.2,
                            fontFamily: 'Courier',
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
