import 'package:flutter/material.dart';

import '../../constants/app_constants.dart';
import '../../models/todo_item.dart';

class AddTodoSheet extends StatefulWidget {
  const AddTodoSheet({super.key});

  @override
  State<AddTodoSheet> createState() => _AddTodoSheetState();
}

class _AddTodoSheetState extends State<AddTodoSheet> {
  final _titleCtrl = TextEditingController();
  final _noteCtrl = TextEditingController();
  Priority _priority = Priority.medium;

  @override
  void dispose() {
    _titleCtrl.dispose();
    _noteCtrl.dispose();
    super.dispose();
  }

  void _submit() {
    if (_titleCtrl.text.trim().isEmpty) return;
    Navigator.pop(
      context,
      TodoItem(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        title: _titleCtrl.text.trim(),
        note: _noteCtrl.text.trim().isEmpty ? null : _noteCtrl.text.trim(),
        priority: _priority,
        createdAt: DateTime.now(),
      ),
    );
  }

  Color _priorityColor(Priority p) {
    switch (p) {
      case Priority.high:
        return const Color(0xFFFF4F5E);
      case Priority.medium:
        return const Color(0xFFFFB347);
      case Priority.low:
        return const Color(0xFF4FFFB0);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(16),
      padding: EdgeInsets.only(
        left: 24,
        right: 24,
        top: 28,
        bottom: MediaQuery.of(context).viewInsets.bottom + 28,
      ),
      decoration: BoxDecoration(
        color: const Color(0xFF13131A),
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: Colors.white.withOpacity(0.07)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Center(
            child: Container(
              width: 36,
              height: 4,
              decoration: BoxDecoration(
                color: Colors.white12,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
          ),
          const SizedBox(height: 24),
          const Text(
            'NEW TASK',
            style: TextStyle(
              color: Color(0xFFE8FF47),
              fontSize: 11,
              fontWeight: FontWeight.w800,
              letterSpacing: 4,
              fontFamily: 'Courier',
            ),
          ),
          const SizedBox(height: 16),
          TextField(
            controller: _titleCtrl,
            autofocus: true,
            style: const TextStyle(
                color: Colors.white,
                fontSize: 18,
                fontWeight: FontWeight.w600),
            decoration: const InputDecoration(
              hintText: 'What needs to be done?',
              hintStyle: TextStyle(color: Colors.white24, fontSize: 18),
              border: InputBorder.none,
            ),
            onSubmitted: (_) => _submit(),
          ),
          Container(height: 1, color: Colors.white12),
          const SizedBox(height: 16),
          TextField(
            controller: _noteCtrl,
            style: const TextStyle(color: Colors.white54, fontSize: 14),
            decoration: const InputDecoration(
              hintText: 'Add a note (optional)',
              hintStyle: TextStyle(color: Colors.white12, fontSize: 14),
              border: InputBorder.none,
              isDense: true,
            ),
          ),
          const SizedBox(height: 24),
          Row(
            children: [
              const Text(
                'PRIORITY',
                style: TextStyle(
                  color: Colors.white24,
                  fontSize: 10,
                  letterSpacing: 2,
                  fontFamily: 'Courier',
                ),
              ),
              const SizedBox(width: 16),
              ...Priority.values.map((p) {
                final selected = _priority == p;
                final color = _priorityColor(p);
                return GestureDetector(
                  onTap: () => setState(() => _priority = p),
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 180),
                    margin: const EdgeInsets.only(right: 10),
                    padding: const EdgeInsets.symmetric(
                        horizontal: 14, vertical: 7),
                    decoration: BoxDecoration(
                      color: selected
                          ? color.withOpacity(0.15)
                          : Colors.transparent,
                      borderRadius: BorderRadius.circular(8),
                      border:
                      Border.all(color: selected ? color : Colors.white12),
                    ),
                    child: Text(
                      p.name.toUpperCase(),
                      style: TextStyle(
                        color: selected ? color : Colors.white24,
                        fontSize: 10,
                        letterSpacing: 1.5,
                        fontWeight: FontWeight.w700,
                        fontFamily: 'Courier',
                      ),
                    ),
                  ),
                );
              }),
            ],
          ),
          const SizedBox(height: 28),
          GestureDetector(
            onTap: _submit,
            child: Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(vertical: 16),
              decoration: BoxDecoration(
                color: const Color(0xFFE8FF47),
                borderRadius: BorderRadius.circular(14),
              ),
              child: const Center(
                child: Text(
                  'ADD TASK',
                  style: TextStyle(
                    color: Color(0xFF0A0A0F),
                    fontSize: 13,
                    fontWeight: FontWeight.w900,
                    letterSpacing: 3,
                    fontFamily: 'Courier',
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}