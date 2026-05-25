import 'package:design_system/design_system.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../new_piece/presentation/widgets/new_piece_sheet.dart';
import '../providers/month_pieces_provider.dart';
import '../widgets/info_card.dart';
import '../widgets/month_grid.dart';

const _monthsLong = [
  'January',
  'February',
  'March',
  'April',
  'May',
  'June',
  'July',
  'August',
  'September',
  'October',
  'November',
  'December',
];

const _weekdayShort = ['Sun', 'Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat'];

class CalendarPage extends ConsumerStatefulWidget {
  const CalendarPage({super.key});

  @override
  ConsumerState<CalendarPage> createState() => _CalendarPageState();
}

class _CalendarPageState extends ConsumerState<CalendarPage> {
  late DateTime _visibleMonth;
  DateTime? _selectedDate;

  @override
  void initState() {
    super.initState();

    final now = DateTime.now();
    _visibleMonth = DateTime(now.year, now.month);
    _selectedDate = DateTime(now.year, now.month, now.day);

    // Warm the neighbors so the first prev/next tap renders without a spinner.
    WidgetsBinding.instance.addPostFrameCallback((_) => _prefetchNeighbors());
  }

  /// Fire-and-forget reads of the ±1 months. `ref.read(.future)` kicks the
  /// HTTP request off without subscribing; `keepAlive: true` on the
  /// provider keeps the result cached for later tap.
  void _prefetchNeighbors() {
    if (!mounted) return;
    final prev = DateTime(_visibleMonth.year, _visibleMonth.month - 1);
    final next = DateTime(_visibleMonth.year, _visibleMonth.month + 1);
    ref.read(monthPiecesProvider(year: prev.year, month: prev.month).future);
    ref.read(monthPiecesProvider(year: next.year, month: next.month).future);
  }

  void _prev() {
    setState(() {
      _visibleMonth = DateTime(_visibleMonth.year, _visibleMonth.month - 1);
    });
    _prefetchNeighbors();
  }

  void _next() {
    setState(() {
      _visibleMonth = DateTime(_visibleMonth.year, _visibleMonth.month + 1);
    });
    _prefetchNeighbors();
  }

  void _jumpToToday() {
    final now = DateTime.now();
    setState(() {
      _visibleMonth = DateTime(now.year, now.month);
      _selectedDate = DateTime(now.year, now.month, now.day);
    });
    _prefetchNeighbors();
  }

  void _onCellTap(DateTime cellDate, bool inCurrentMonth, dynamic piece) {
    if (!inCurrentMonth) {
      setState(() {
        _visibleMonth = DateTime(cellDate.year, cellDate.month);
        _selectedDate = cellDate;
      });
      _prefetchNeighbors();
      return;
    }

    setState(() => _selectedDate = cellDate);

    if (piece != null) {
      context.push('/piece/${piece.id}');
    } else {
      // NewPieceSheet invalidates the matching monthPieces entry on save.
      showNewPieceSheet(context, forDate: cellDate);
    }
  }

  @override
  Widget build(BuildContext context) {
    final colors = context.wdsColors;
    final spacing = context.wdsSpacing;
    final monthLabel =
        '${_monthsLong[_visibleMonth.month - 1]} ${_visibleMonth.year}';
    final asyncMap = ref.watch(
      monthPiecesProvider(year: _visibleMonth.year, month: _visibleMonth.month),
    );

    return Scaffold(
      backgroundColor: colors.backgroundNormalNormal,
      appBar: AppBar(
        title: Row(
          children: [
            IconButton(
              onPressed: _prev,
              icon: const Icon(Icons.chevron_left),
              tooltip: 'Previous Month',
            ),
            Expanded(
              child: Center(
                child: WdsText(monthLabel, style: WdsTextStyle.heading1),
              ),
            ),
            IconButton(
              onPressed: _next,
              icon: const Icon(Icons.chevron_right),
              tooltip: 'Next Month',
            ),
          ],
        ),
        actions: [
          TextButton(onPressed: _jumpToToday, child: const Text('Today')),
        ],
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: EdgeInsets.all(spacing.componentXl),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Row(
                children: [
                  for (final name in _weekdayShort)
                    Expanded(
                      child: Padding(
                        padding: EdgeInsets.symmetric(
                          vertical: spacing.componentSm,
                        ),
                        child: Center(
                          child: WdsText(
                            name,
                            style: WdsTextStyle.caption1,
                            color: WdsTextColor.alternative,
                          ),
                        ),
                      ),
                    ),
                ],
              ),
              asyncMap.when(
                loading: () => const SizedBox(
                  height: 280,
                  child: Center(child: WdsSpinner()),
                ),
                error: (e, _) => Padding(
                  padding: EdgeInsets.all(spacing.componentLg),
                  child: WdsText(
                    'Failed to load month: $e',
                    style: WdsTextStyle.body2,
                    color: WdsTextColor.alternative,
                  ),
                ),
                data: (piecesByDate) => MonthGrid(
                  visibleMonth: _visibleMonth,
                  selectedDate: _selectedDate,
                  piecesByDate: piecesByDate,
                  onCellTap: _onCellTap,
                ),
              ),
              SizedBox(height: spacing.componentXl),
              const CalendarInfoCard(),
            ],
          ),
        ),
      ),
    );
  }
}
