import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:my_todo/modules/controllers/todo_api_controller.dart';
import 'package:my_todo/utils/utils.dart';

import '../../models/todo_item.dart';
import '../controllers/todo_controller.dart';
import '../widgets/add_todo_sheet.dart';
import '../widgets/ring_painter.dart';
import '../widgets/todo_card.dart';
import 'delete_history_page.dart';

class TodoHomePage extends StatefulWidget {
  const TodoHomePage({super.key});

  @override
  State<TodoHomePage> createState() => _TodoHomePageState();
}

class _TodoHomePageState extends State<TodoHomePage>
    with TickerProviderStateMixin {
  final TodoApiController _ctrl = Get.put(TodoApiController());
  late AnimationController _fabAnimCtrl;
  late Animation<double> _fabAnim;

  @override
  void initState() {
    super.initState();
    _fabAnimCtrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 400),
    );
    _fabAnim = CurvedAnimation(parent: _fabAnimCtrl, curve: Curves.elasticOut);
    Future.delayed(const Duration(milliseconds: 300), () {
      if (mounted) _fabAnimCtrl.forward();
    });

    WidgetsBinding.instance.addPostFrameCallback((_) {
      _ctrl.fetchTasks();
    });
  }

  @override
  void dispose() {
    _fabAnimCtrl.dispose();
    super.dispose();
  }

  void _addTodo() async {
    final result = await showModalBottomSheet<TodoItem>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => const AddTodoSheet(),
    );
    if (result != null) {
      _ctrl.addTask(result);
    }
  }

  void _openHistory() {
    Get.to(
          () => DeleteHistoryPage(),
      transition: Transition.rightToLeft,
      duration: const Duration(milliseconds: 300),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0A0A0F),
      body: Stack(
        children: [
          Positioned(
            top: -80,
            right: -60,
            child: Container(
              width: 220,
              height: 220,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: RadialGradient(colors: [
                  const Color(0xFFE8FF47).withOpacity(0.07),
                  Colors.transparent,
                ]),
              ),
            ),
          ),
          Positioned(
            bottom: 100,
            left: -90,
            child: Container(
              width: 260,
              height: 260,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: RadialGradient(colors: [
                  const Color(0xFFFF4F5E).withOpacity(0.05),
                  Colors.transparent,
                ]),
              ),
            ),
          ),
          SafeArea(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildHeader(),
                _buildStats(),
                _buildFilterTabs(),
                Expanded(
                  child: _buildTodoList()
                ),
              ],
            ),
          ),
        ],
      ),
      floatingActionButton: ScaleTransition(
        scale: _fabAnim,
        child: _buildFAB(),
      ),
    );
  }

  Widget _buildHeader() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(24, 24, 24, 0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              RichText(
                text: const TextSpan(children: [
                  TextSpan(
                    text: 'TASK',
                    style: TextStyle(
                      fontFamily: 'Courier',
                      fontSize: 36,
                      fontWeight: FontWeight.w900,
                      color: Colors.white,
                      letterSpacing: 4,
                    ),
                  ),
                  TextSpan(
                    text: 'R',
                    style: TextStyle(
                      fontFamily: 'Courier',
                      fontSize: 36,
                      fontWeight: FontWeight.w900,
                      color: Color(0xFFE8FF47),
                      letterSpacing: 4,
                    ),
                  ),
                ]),
              ),
              Text(
                _greeting(),
                style: const TextStyle(
                  color: Colors.white38,
                  fontSize: 13,
                  letterSpacing: 1.5,
                  fontFamily: 'Courier',
                ),
              ),
            ],
          ),
          Row(
            children: [
              Obx(() =>
                  GestureDetector(
                    onTap: _openHistory,
                    child: Stack(
                      clipBehavior: Clip.none,
                      children: [
                        Container(
                          width: 44,
                          height: 44,
                          decoration: BoxDecoration(
                            color: const Color(0xFF13131A),
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(
                              color: _ctrl.deleteHistory.isNotEmpty
                                  ? const Color(0xFFFF4F5E).withOpacity(0.3)
                                  : Colors.white12,
                            ),
                          ),
                          child: const Icon(
                            Icons.history_rounded,
                            color: Colors.white54,
                            size: 20,
                          ),
                        ),
                        if (_ctrl.deleteHistory.isNotEmpty)
                          Positioned(
                            top: -4,
                            right: -4,
                            child: Container(
                              padding: const EdgeInsets.all(4),
                              decoration: const BoxDecoration(
                                color: Color(0xFFFF4F5E),
                                shape: BoxShape.circle,
                              ),
                              child: Text(
                                '${_ctrl.deleteHistory.length > 9 ? '9+' : _ctrl
                                    .deleteHistory.length}',
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 9,
                                  fontWeight: FontWeight.w900,
                                  fontFamily: 'Courier',
                                ),
                              ),
                            ),
                          ),
                      ],
                    ),
                  )),
              const SizedBox(width: 12),
              Obx(() => _buildProgressRing()),
            ],
          ),
        ],
      ),
    );
  }

  String _greeting() {
    final h = DateTime
        .now()
        .hour;
    if (h < 12) return 'GOOD MORNING';
    if (h < 17) return 'GOOD AFTERNOON';
    return 'GOOD EVENING';
  }

  Widget _buildProgressRing() {
    final total = _ctrl.tasks.length;
    final done = _ctrl.doneCount;
    final progress = total == 0 ? 0.0 : done / total;

    return SizedBox(
      width: 56,
      height: 56,
      child: Stack(
        alignment: Alignment.center,
        children: [
          CustomPaint(
            size: const Size(56, 56),
            painter: RingPainter(progress: progress),
          ),
          Text(
            '${(progress * 100).round()}%',
            style: const TextStyle(
              color: Color(0xFFE8FF47),
              fontSize: 11,
              fontWeight: FontWeight.bold,
              fontFamily: 'Courier',
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStats() {
    return Obx(() =>
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Padding(
            padding: const EdgeInsets.fromLTRB(24, 20, 24, 0),
            child: Row(
              children: [
                _statChip(
                    '${_ctrl.activeCount}', 'ACTIVE', const Color(0xFFE8FF47)),
                const SizedBox(width: 12),
                _statChip(
                    '${_ctrl.doneCount}', 'DONE', const Color(0xFF4FFFB0)),
                const SizedBox(width: 12),
                _statChip(
                    '${_ctrl.tasks.length}', 'TOTAL', Colors.white30),
                const SizedBox(width: 12),
                _statChip('${_ctrl.deleteHistory.length}', 'DELETED',
                    const Color(0xFFFF4F5E)),
              ],
            ),
          ),
        ));
  }

  Widget _statChip(String value, String label, Color accent) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
      decoration: BoxDecoration(
        color: const Color(0xFF13131A),
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: accent.withOpacity(0.2), width: 1),
      ),
      child: Row(
        children: [
          Text(
            value,
            style: TextStyle(
              color: accent,
              fontSize: 18,
              fontWeight: FontWeight.w900,
              fontFamily: 'Courier',
            ),
          ),
          const SizedBox(width: 6),
          Text(
            label,
            style: const TextStyle(
              color: Colors.white38,
              fontSize: 10,
              letterSpacing: 1.5,
              fontFamily: 'Courier',
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFilterTabs() {
    const labels = ['ALL', 'ACTIVE', 'DONE'];
    return Obx(() =>
        Padding(
          padding: const EdgeInsets.fromLTRB(24, 24, 24, 8),
          child: Row(
            children: List.generate(3, (i) {
              final selected = _ctrl.selectedFilter.value == i;
              return GestureDetector(
                onTap: () => _ctrl.setFilter(i),
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 200),
                  margin: const EdgeInsets.only(right: 10),
                  padding:
                  const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  decoration: BoxDecoration(
                    color: selected
                        ? const Color(0xFFE8FF47)
                        : const Color(0xFF13131A),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    labels[i],
                    style: TextStyle(
                      color: selected
                          ? const Color(0xFF0A0A0F)
                          : Colors.white38,
                      fontSize: 11,
                      fontWeight: FontWeight.w800,
                      letterSpacing: 2,
                      fontFamily: 'Courier',
                    ),
                  ),
                ),
              );
            }),
          ),
        ));
  }

  Widget _buildTodoList() {
    return Obx(() {
      if(_ctrl.isLoading.value){
        return Utils.apiLoader;
      } else if(_ctrl.tasks.isEmpty){
        return Center(
          child: Text('No Tasks Found',
          style: TextStyle(
            fontSize: 15,
            color: Colors.white
          ),
          ),
        );
      }
      return ListView.builder(
        padding: EdgeInsets.fromLTRB(24, 8, 24, 120),
        itemCount: _ctrl.tasks.length,
        itemBuilder: (ctx, i) {
          return TodoCard(
            key: ValueKey(_ctrl.tasks[i].id),
            item: _ctrl.tasks[i],
            onToggle: () => _ctrl.toggleDone(_ctrl.tasks[i]),
            onDelete: () => _ctrl.deleteTodo(_ctrl.tasks[i]),
          );
        },
      );
    });
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            '✦',
            style: TextStyle(
              fontSize: 48,
              color: Colors.white.withOpacity(0.1),
            ),
          ),
          const SizedBox(height: 16),
          Text(
            'NO TASKS HERE',
            style: TextStyle(
              color: Colors.white.withOpacity(0.15),
              fontSize: 13,
              letterSpacing: 4,
              fontFamily: 'Courier',
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFAB() {
    return GestureDetector(
      onTap: _addTodo,
      child: Container(
        width: 60,
        height: 60,
        decoration: BoxDecoration(
          color: const Color(0xFFE8FF47),
          borderRadius: BorderRadius.circular(18),
          boxShadow: [
            BoxShadow(
              color: const Color(0xFFE8FF47).withOpacity(0.4),
              blurRadius: 20,
              spreadRadius: 2,
            ),
          ],
        ),
        child: const Icon(Icons.add_rounded,
            color: Color(0xFF0A0A0F), size: 30),
      ),
    );
  }
}