import 'package:flutter/cupertino.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../providers/tasks_provider.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late final DateTime _today;
  late DateTime _selectedDate;
  late DateTime _focusedMonth;

  @override
  void initState() {
    super.initState();
    _today = _dateOnly(DateTime.now());
    _selectedDate = _today;
    _focusedMonth = DateTime(_today.year, _today.month, 1);
  }

  @override
  Widget build(BuildContext context) {
    final tasksProvider = context.watch<TasksProvider>();
    final selectedTasks = tasksProvider.tasksForDate(_selectedDate);
    final firstDay = _today;
    final lastDay = DateTime(2050, 12, 31);
    final monthStart = DateTime(_focusedMonth.year, _focusedMonth.month, 1);
    final daysInMonth = DateTime(
      _focusedMonth.year,
      _focusedMonth.month + 1,
      0,
    ).day;
    final firstWeekdayOffset = monthStart.weekday % 7; // Sunday start
    final totalCells = ((firstWeekdayOffset + daysInMonth) / 7).ceil() * 7;
    final canGoPrev = DateTime(
      monthStart.year,
      monthStart.month,
      1,
    ).isAfter(DateTime(firstDay.year, firstDay.month, 1));
    final canGoNext = DateTime(
      monthStart.year,
      monthStart.month,
      1,
    ).isBefore(DateTime(lastDay.year, lastDay.month, 1));

    return CupertinoPageScaffold(
      child: CustomScrollView(
        slivers: [
          CupertinoSliverNavigationBar(
            largeTitle: Text(DateFormat('MMMM yyyy').format(_focusedMonth)),
            trailing: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                CupertinoButton(
                  padding: EdgeInsets.zero,
                  onPressed: canGoPrev ? _goToPreviousMonth : null,
                  child: Icon(
                    CupertinoIcons.chevron_left,
                    color: canGoPrev
                        ? CupertinoColors.systemBlue
                        : CupertinoColors.systemGrey3,
                  ),
                ),
                CupertinoButton(
                  padding: EdgeInsets.zero,
                  onPressed: canGoNext ? _goToNextMonth : null,
                  child: Icon(
                    CupertinoIcons.chevron_right,
                    color: canGoNext
                        ? CupertinoColors.systemBlue
                        : CupertinoColors.systemGrey3,
                  ),
                ),
              ],
            ),
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(16, 8, 16, 12),
              child: Column(
                children: [
                  const _WeekdayHeader(),
                  const SizedBox(height: 10),
                  GridView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 7,
                          mainAxisSpacing: 6,
                          crossAxisSpacing: 6,
                          childAspectRatio: 1,
                        ),
                    itemCount: totalCells,
                    itemBuilder: (context, index) {
                      final dayNumber = index - firstWeekdayOffset + 1;
                      final date = DateTime(
                        _focusedMonth.year,
                        _focusedMonth.month,
                        dayNumber,
                      );
                      final isOutOfMonth = date.month != _focusedMonth.month;
                      final isToday = _isSameDay(date, _today);
                      final isSelected = _isSameDay(date, _selectedDate);
                      final isDisabled =
                          date.isBefore(firstDay) || date.isAfter(lastDay);
                      final hasEvent = tasksProvider.hasTasks(date);

                      return _DayCell(
                        date: date,
                        isOutOfMonth: isOutOfMonth,
                        isToday: isToday,
                        isSelected: isSelected,
                        isDisabled: isDisabled,
                        hasEvent: hasEvent,
                        onTap: () {
                          if (isDisabled) {
                            return;
                          }
                          setState(() {
                            _selectedDate = _dateOnly(date);
                            _focusedMonth = DateTime(date.year, date.month, 1);
                          });
                        },
                      );
                    },
                  ),
                ],
              ),
            ),
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(16, 0, 16, 24),
              child: CupertinoListSection.insetGrouped(
                header: Text(DateFormat.yMMMMd().format(_selectedDate)),
                children: selectedTasks.isEmpty
                    ? const [
                        CupertinoListTile(
                          title: Text('No events for this day'),
                        ),
                      ]
                    : selectedTasks
                          .map(
                            (task) => CupertinoListTile(
                              title: Text(task),
                              leading: const Icon(
                                CupertinoIcons.circle_filled,
                                size: 10,
                                color: CupertinoColors.systemBlue,
                              ),
                            ),
                          )
                          .toList(),
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _goToPreviousMonth() {
    setState(() {
      _focusedMonth = DateTime(_focusedMonth.year, _focusedMonth.month - 1, 1);
    });
  }

  void _goToNextMonth() {
    setState(() {
      _focusedMonth = DateTime(_focusedMonth.year, _focusedMonth.month + 1, 1);
    });
  }

  DateTime _dateOnly(DateTime date) {
    return DateTime(date.year, date.month, date.day);
  }

  bool _isSameDay(DateTime a, DateTime b) {
    return a.year == b.year && a.month == b.month && a.day == b.day;
  }
}

class _WeekdayHeader extends StatelessWidget {
  const _WeekdayHeader();

  @override
  Widget build(BuildContext context) {
    const labels = ['S', 'M', 'T', 'W', 'T', 'F', 'S'];

    return Row(
      children: labels
          .map(
            (label) => Expanded(
              child: Center(
                child: Text(
                  label,
                  style: const TextStyle(
                    fontWeight: FontWeight.w600,
                    color: CupertinoColors.systemGrey,
                    letterSpacing: 0.4,
                  ),
                ),
              ),
            ),
          )
          .toList(),
    );
  }
}

class _DayCell extends StatelessWidget {
  const _DayCell({
    required this.date,
    required this.isOutOfMonth,
    required this.isToday,
    required this.isSelected,
    required this.isDisabled,
    required this.hasEvent,
    required this.onTap,
  });

  final DateTime date;
  final bool isOutOfMonth;
  final bool isToday;
  final bool isSelected;
  final bool isDisabled;
  final bool hasEvent;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final Color textColor;
    if (isDisabled) {
      textColor = CupertinoColors.tertiaryLabel.resolveFrom(context);
    } else if (isToday) {
      textColor = CupertinoColors.white;
    } else if (isOutOfMonth) {
      textColor = CupertinoColors.secondaryLabel.resolveFrom(context);
    } else {
      textColor = CupertinoColors.label.resolveFrom(context);
    }

    final bool showSelectionRing = isSelected && !isToday;

    return CupertinoButton(
      padding: EdgeInsets.zero,
      minSize: 0,
      onPressed: isDisabled ? null : onTap,
      child: Container(
        decoration: BoxDecoration(
          border: Border.all(color: CupertinoColors.separator, width: 0.5),
          borderRadius: BorderRadius.circular(10),
        ),
        child: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 34,
                height: 34,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: isToday
                      ? CupertinoColors.systemBlue
                      : (isSelected
                            ? CupertinoColors.systemBlue.withOpacity(0.12)
                            : CupertinoColors.transparent),
                  shape: BoxShape.circle,
                  border: showSelectionRing
                      ? Border.all(
                          color: CupertinoColors.systemBlue,
                          width: 1.5,
                        )
                      : null,
                ),
                child: Text(
                  '${date.day}',
                  style: TextStyle(
                    color: textColor,
                    fontWeight: isOutOfMonth
                        ? FontWeight.w400
                        : FontWeight.w600,
                    fontSize: 15,
                  ),
                ),
              ),
              const SizedBox(height: 5),
              if (hasEvent)
                Container(
                  width: 6,
                  height: 6,
                  decoration: const BoxDecoration(
                    color: CupertinoColors.systemBlue,
                    shape: BoxShape.circle,
                  ),
                )
              else
                const SizedBox(height: 6),
            ],
          ),
        ),
      ),
    );
  }
}
