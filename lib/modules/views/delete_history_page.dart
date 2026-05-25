import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../constants/app_constants.dart';
import '../controllers/todo_controller.dart';
import '../widgets/history_card.dart';

class DeleteHistoryPage extends StatelessWidget {
  DeleteHistoryPage({super.key});

  final TodoController _ctrl = Get.find();

  void _confirmClearAll(BuildContext context) {
    Get.dialog(
      Dialog(
        backgroundColor: const Color(0xFF13131A),
        shape:
        RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'CLEAR ALL?',
                style: TextStyle(
                  color: Color(0xFFFF4F5E),
                  fontSize: 14,
                  fontWeight: FontWeight.w900,
                  letterSpacing: 3,
                  fontFamily: 'Courier',
                ),
              ),
              const SizedBox(height: 12),
              const Text(
                'This will permanently erase all deleted task history. This cannot be undone.',
                style: TextStyle(
                  color: Colors.white54,
                  fontSize: 13,
                  height: 1.5,
                ),
              ),
              const SizedBox(height: 24),
              Row(
                children: [
                  Expanded(
                    child: GestureDetector(
                      onTap: () => Get.back(),
                      child: Container(
                        padding: const EdgeInsets.symmetric(vertical: 13),
                        decoration: BoxDecoration(
                          color: Colors.white10,
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: const Center(
                          child: Text(
                            'CANCEL',
                            style: TextStyle(
                              color: Colors.white54,
                              fontSize: 11,
                              fontWeight: FontWeight.w800,
                              letterSpacing: 2,
                              fontFamily: 'Courier',
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: GestureDetector(
                      onTap: () {
                        Get.back();
                        _ctrl.clearAllHistory();
                        Get.back();
                      },
                      child: Container(
                        padding: const EdgeInsets.symmetric(vertical: 13),
                        decoration: BoxDecoration(
                          color: const Color(0xFFFF4F5E),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: const Center(
                          child: Text(
                            'CLEAR',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 11,
                              fontWeight: FontWeight.w900,
                              letterSpacing: 2,
                              fontFamily: 'Courier',
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  String _timeAgo(DateTime dt) {
    final diff = DateTime.now().difference(dt);
    if (diff.inSeconds < 60) return 'just now';
    if (diff.inMinutes < 60) return '${diff.inMinutes}m ago';
    if (diff.inHours < 24) return '${diff.inHours}h ago';
    return '${diff.inDays}d ago';
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
    return Scaffold(
      backgroundColor: const Color(0xFF0A0A0F),
      body: Stack(
        children: [
          Positioned(
            top: -60,
            left: -60,
            child: Container(
              width: 200,
              height: 200,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: RadialGradient(colors: [
                  const Color(0xFFFF4F5E).withOpacity(0.06),
                  Colors.transparent,
                ]),
              ),
            ),
          ),
          SafeArea(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Obx(() => Padding(
                  padding: const EdgeInsets.fromLTRB(24, 24, 24, 0),
                  child: Row(
                    children: [
                      GestureDetector(
                        onTap: () => Get.back(),
                        child: Container(
                          width: 40,
                          height: 40,
                          decoration: BoxDecoration(
                            color: const Color(0xFF13131A),
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(color: Colors.white12),
                          ),
                          child: const Icon(Icons.arrow_back_rounded,
                              color: Colors.white54, size: 18),
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            RichText(
                              text: const TextSpan(children: [
                                TextSpan(
                                  text: 'DELETE ',
                                  style: TextStyle(
                                    fontFamily: 'Courier',
                                    fontSize: 22,
                                    fontWeight: FontWeight.w900,
                                    color: Colors.white,
                                    letterSpacing: 3,
                                  ),
                                ),
                                TextSpan(
                                  text: 'HISTORY',
                                  style: TextStyle(
                                    fontFamily: 'Courier',
                                    fontSize: 22,
                                    fontWeight: FontWeight.w900,
                                    color: Color(0xFFFF4F5E),
                                    letterSpacing: 3,
                                  ),
                                ),
                              ]),
                            ),
                            Text(
                              '${_ctrl.deleteHistory.length} DELETED TASK${_ctrl.deleteHistory.length == 1 ? '' : 'S'}',
                              style: const TextStyle(
                                color: Colors.white24,
                                fontSize: 10,
                                letterSpacing: 2,
                                fontFamily: 'Courier',
                              ),
                            ),
                          ],
                        ),
                      ),
                      if (_ctrl.deleteHistory.isNotEmpty)
                        GestureDetector(
                          onTap: () => _confirmClearAll(context),
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 12, vertical: 8),
                            decoration: BoxDecoration(
                              color: const Color(0xFFFF4F5E)
                                  .withOpacity(0.1),
                              borderRadius: BorderRadius.circular(10),
                              border: Border.all(
                                color: const Color(0xFFFF4F5E)
                                    .withOpacity(0.25),
                              ),
                            ),
                            child: const Text(
                              'CLEAR ALL',
                              style: TextStyle(
                                color: Color(0xFFFF4F5E),
                                fontSize: 9,
                                fontWeight: FontWeight.w900,
                                letterSpacing: 1.5,
                                fontFamily: 'Courier',
                              ),
                            ),
                          ),
                        ),
                    ],
                  ),
                )),
                const SizedBox(height: 8),
                Container(
                  margin:
                  const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
                  height: 1,
                  color: Colors.white.withOpacity(0.06),
                ),
                Expanded(
                  child: Obx(() => _ctrl.deleteHistory.isEmpty
                      ? _buildEmptyHistory()
                      : ListView.builder(
                    padding: const EdgeInsets.fromLTRB(24, 0, 24, 40),
                    itemCount: _ctrl.deleteHistory.length,
                    itemBuilder: (ctx, i) {
                      final d = _ctrl.deleteHistory[i];
                      return HistoryCard(
                        key: ValueKey(
                            d.item.id + d.deletedAt.toString()),
                        deleted: d,
                        timeAgo: _timeAgo(d.deletedAt),
                        priorityColor: _priorityColor(d.item.priority),
                        onRestore: () => _ctrl.restoreFromHistory(d),
                        onRemovePermanently: () =>
                            _ctrl.removePermanently(d),
                      );
                    },
                  )),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyHistory() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.auto_delete_outlined,
            size: 48,
            color: Colors.white.withOpacity(0.08),
          ),
          const SizedBox(height: 16),
          Text(
            'NO DELETED TASKS',
            style: TextStyle(
              color: Colors.white.withOpacity(0.15),
              fontSize: 13,
              letterSpacing: 4,
              fontFamily: 'Courier',
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'deleted tasks will appear here',
            style: TextStyle(
              color: Colors.white.withOpacity(0.1),
              fontSize: 11,
              letterSpacing: 1,
              fontFamily: 'Courier',
            ),
          ),
        ],
      ),
    );
  }
}
