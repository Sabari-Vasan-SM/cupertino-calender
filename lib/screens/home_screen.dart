import 'package:flutter/cupertino.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../providers/tasks_provider.dart';
import '../widgets/glass_background.dart';
import '../widgets/glass_panel.dart';

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
    final topInset = MediaQuery.of(context).padding.top;

    return CupertinoPageScaffold(
      child: Stack(
        children: [
          const Positioned.fill(child: GlassBackground()),
          CustomScrollView(
            slivers: [
              SliverToBoxAdapter(
                child: Padding(
                  padding: EdgeInsets.fromLTRB(16, topInset + 12, 16, 8),
                  child: GlassPanel(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 12,
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          DateFormat('MMMM yyyy').format(_focusedMonth),
                          style: const TextStyle(
                            fontSize: 26,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        Row(
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
                      ],
                    ),
                  ),
                ),
              ),
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(16, 8, 16, 12),
                  child: GlassPanel(
                    padding: const EdgeInsets.fromLTRB(12, 12, 12, 16),
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
                            final isOutOfMonth =
                                date.month != _focusedMonth.month;
                            final isToday = _isSameDay(date, _today);
                            final isSelected = _isSameDay(date, _selectedDate);
                            final isDisabled =
                                date.isBefore(firstDay) ||
                                date.isAfter(lastDay);
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
                                  _focusedMonth = DateTime(
                                    date.year,
                                    date.month,
                                    1,
                                  );
                                });
                              },
                            );
                          },
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(16, 0, 16, 24),
                  child: GlassPanel(
                    padding: const EdgeInsets.only(top: 4, bottom: 4),
                    child: CupertinoListSection.insetGrouped(
                      backgroundColor: CupertinoColors.transparent,
                      separatorColor: CupertinoColors.separator,
                      header: Text(DateFormat.yMMMMd().format(_selectedDate)),
                      children: selectedTasks.isEmpty
                          ? const [
                              CupertinoListTile(
                                backgroundColor: CupertinoColors.transparent,
                                title: Text('No events for this day'),
                              ),
                            ]
                          : selectedTasks
                                .map(
                                  (task) => CupertinoListTile(
                                    backgroundColor:
                                        CupertinoColors.transparent,
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
              ),
            ],
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
                  style: TextStyle(
                    fontWeight: FontWeight.w600,
                    color: label == 'S'
                        ? CupertinoColors.systemRed
                        : CupertinoColors.systemGrey,
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
    } else if (isOutOfMonth) {
      textColor = CupertinoColors.secondaryLabel.resolveFrom(context);
    } else if (isToday || isSelected) {
      textColor = CupertinoColors.systemBlue;
    } else if (date.weekday == DateTime.sunday) {
      textColor = CupertinoColors.systemRed;
    } else {
      textColor = CupertinoColors.label.resolveFrom(context);
    }

    final bool showSelectionBorder = (isSelected || isToday) && !isDisabled;

    return CupertinoButton(
      padding: EdgeInsets.zero,
      minimumSize: 0,
      onPressed: isDisabled ? null : onTap,
      child: Container(
        decoration: BoxDecoration(
          border: Border.all(
            color: showSelectionBorder
                ? CupertinoColors.systemBlue
                : CupertinoColors.separator,
            width: showSelectionBorder ? 1.2 : 0.5,
          ),
          borderRadius: BorderRadius.circular(10),
        ),
        child: LayoutBuilder(
          builder: (context, constraints) {
            final cellSize = constraints.maxHeight;
            final circleSize = (cellSize * 0.55).clamp(26.0, 34.0);
            final gap = (cellSize * 0.08).clamp(2.0, 5.0);
            final dotSize = (cellSize * 0.1).clamp(4.0, 6.0);

            return Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    width: circleSize,
                    height: circleSize,
                    alignment: Alignment.center,
                    decoration: const BoxDecoration(
                      color: CupertinoColors.transparent,
                      shape: BoxShape.circle,
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
                  SizedBox(height: gap),
                  if (hasEvent)
                    Container(
                      width: dotSize,
                      height: dotSize,
                      decoration: const BoxDecoration(
                        color: CupertinoColors.systemBlue,
                        shape: BoxShape.circle,
                      ),
                    )
                  else
                    SizedBox(height: dotSize),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}
