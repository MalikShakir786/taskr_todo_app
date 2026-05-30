import 'package:flutter/material.dart';
import 'package:my_todo/models/task_item.dart';

import '../../constants/app_enums.dart';

class TodoCard extends StatefulWidget {
  final TaskItem item;
  final VoidCallback onToggle;
  final VoidCallback onDelete;

  const TodoCard({
    super.key,
    required this.item,
    required this.onToggle,
    required this.onDelete,
  });

  @override
  State<TodoCard> createState() => TodoCardState();
}

class TodoCardState extends State<TodoCard>
    with SingleTickerProviderStateMixin {
  late AnimationController _ctrl;
  late Animation<double> _fadeAnim;
  bool _showActions = false;

  @override
  void initState() {
    super.initState();
    _ctrl = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 350));
    _fadeAnim = CurvedAnimation(parent: _ctrl, curve: Curves.easeOut);
    _ctrl.forward();
  }

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final item = widget.item;

    return FadeTransition(
      opacity: _fadeAnim,
      child: Dismissible(
        key: ValueKey(item.id),
        direction: DismissDirection.endToStart,
        confirmDismiss: (_) async {
          widget.onDelete();
          return false;
        },
        background: Container(
          margin: const EdgeInsets.only(bottom: 12),
          decoration: BoxDecoration(
            color: const Color(0xFFFF4F5E).withAlpha(20),
            borderRadius: BorderRadius.circular(16),
          ),
          alignment: Alignment.centerRight,
          padding: const EdgeInsets.only(right: 24),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: const [
              Icon(Icons.delete_outline_rounded,
                  color: Color(0xFFFF4F5E), size: 22),
              SizedBox(height: 4),
              Text(
                'DELETE',
                style: TextStyle(
                  color: Color(0xFFFF4F5E),
                  fontSize: 9,
                  fontWeight: FontWeight.w800,
                  letterSpacing: 1.5,
                  fontFamily: 'Courier',
                ),
              ),
            ],
          ),
        ),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 250),
          margin: const EdgeInsets.only(bottom: 12),
          decoration: BoxDecoration(
            color: item.isDone.value
                ? const Color(0xFF0F0F15)
                : const Color(0xFF13131A),
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: _showActions
                  ? const Color(0xFFFF4F5E).withAlpha(50)
                  : item.isDone.value
                  ? Colors.white.withAlpha(10)
                  : Priority.fromId(item.priority ?? 2).color,
              width: 1,
            ),
          ),
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(18, 16, 14, 16),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      width: 3,
                      height: item.description != null ? 48 : 20,
                      decoration: BoxDecoration(
                        color: item.isDone.value ? Colors.white12 : Priority.fromId(item.priority ?? 2).color,
                        borderRadius: BorderRadius.circular(2),
                      ),
                    ),
                    const SizedBox(width: 14),
                    Expanded(
                      child: GestureDetector(
                        onTap: widget.onToggle,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              item.title ?? '',
                              style: TextStyle(
                                color: item.isDone.value
                                    ? Colors.white24
                                    : Colors.white,
                                fontSize: 15,
                                fontWeight: FontWeight.w600,
                                decoration: item.isDone.value
                                    ? TextDecoration.lineThrough
                                    : null,
                                decorationColor: Colors.white24,
                                letterSpacing: 0.3,
                              ),
                            ),
                            if (item.description != null) ...[
                              const SizedBox(height: 5),
                              Text(
                                item.description!,
                                style: TextStyle(
                                  color: item.isDone.value
                                      ? Colors.white12
                                      : Colors.white38,
                                  fontSize: 12,
                                  letterSpacing: 0.2,
                                ),
                              ),
                            ],
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        GestureDetector(
                          onTap: widget.onToggle,
                          child: AnimatedContainer(
                            duration: const Duration(milliseconds: 250),
                            width: 24,
                            height: 24,
                            decoration: BoxDecoration(
                              color: item.isDone.value
                                  ? const Color(0xFF4FFFB0)
                                  : Colors.transparent,
                              border: Border.all(
                                color: item.isDone.value
                                    ? const Color(0xFF4FFFB0)
                                    : Colors.white24,
                                width: 1.5,
                              ),
                              borderRadius: BorderRadius.circular(7),
                            ),
                            child: item.isDone.value
                                ? const Icon(Icons.check_rounded,
                                color: Color(0xFF0A0A0F), size: 16)
                                : null,
                          ),
                        ),
                        const SizedBox(height: 8),
                        GestureDetector(
                          onTap: () =>
                              setState(() => _showActions = !_showActions),
                          child: AnimatedContainer(
                            duration: const Duration(milliseconds: 200),
                            width: 24,
                            height: 24,
                            decoration: BoxDecoration(
                              color: _showActions
                                  ? const Color(0xFFFF4F5E).withAlpha(30)
                                  : Colors.transparent,
                              borderRadius: BorderRadius.circular(6),
                            ),
                            child: Icon(
                              _showActions
                                  ? Icons.close_rounded
                                  : Icons.more_horiz_rounded,
                              color: _showActions
                                  ? const Color(0xFFFF4F5E)
                                  : Colors.white24,
                              size: 16,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              AnimatedSize(
                duration: const Duration(milliseconds: 220),
                curve: Curves.easeInOut,
                child: _showActions
                    ? Container(
                  decoration: BoxDecoration(
                    border: Border(
                      top: BorderSide(
                        color: Colors.white.withAlpha(10),
                      ),
                    ),
                  ),
                  child: Row(
                    children: [
                      Padding(
                        padding:
                        const EdgeInsets.fromLTRB(18, 10, 0, 10),
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 8, vertical: 4),
                          decoration: BoxDecoration(
                            color: Priority.fromId(item.priority ?? 2).color.withAlpha(20),
                            borderRadius: BorderRadius.circular(6),
                            border: Border.all(
                              color: Priority.fromId(item.priority ?? 2).color.withAlpha(50),
                            ),
                          ),
                          child: Text(
                            '● ${Priority.fromId(item.priority ?? 2).label}',
                            style: TextStyle(
                              color: Priority.fromId(item.priority ?? 2).color,
                              fontSize: 10,
                              fontWeight: FontWeight.w700,
                              letterSpacing: 1,
                              fontFamily: 'Courier',
                            ),
                          ),
                        ),
                      ),
                      const Spacer(),
                      GestureDetector(
                        onTap: () {
                          setState(() => _showActions = false);
                          widget.onDelete();
                        },
                        child: Container(
                          margin:
                          const EdgeInsets.fromLTRB(0, 8, 14, 8),
                          padding: const EdgeInsets.symmetric(
                              horizontal: 14, vertical: 7),
                          decoration: BoxDecoration(
                            color: const Color(0xFFFF4F5E)
                                .withAlpha(20),
                            borderRadius: BorderRadius.circular(8),
                            border: Border.all(
                              color: const Color(0xFFFF4F5E)
                                  .withAlpha(10),
                            ),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: const [
                              Icon(Icons.delete_outline_rounded,
                                  color: Color(0xFFFF4F5E), size: 14),
                              SizedBox(width: 5),
                              Text(
                                'DELETE',
                                style: TextStyle(
                                  color: Color(0xFFFF4F5E),
                                  fontSize: 10,
                                  fontWeight: FontWeight.w800,
                                  letterSpacing: 1.5,
                                  fontFamily: 'Courier',
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                )
                    : const SizedBox.shrink(),
              ),
            ],
          ),
        ),
      ),
    );
  }
}