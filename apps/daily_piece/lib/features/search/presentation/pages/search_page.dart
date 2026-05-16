import 'dart:async';

import 'package:design_system/design_system.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../providers/search_providers.dart';
import '../widgets/result_card.dart';

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

class SearchPage extends ConsumerStatefulWidget {
  const SearchPage({super.key});

  @override
  ConsumerState<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends ConsumerState<SearchPage> {
  final _queryCtrl = TextEditingController();
  SearchFilter _filter = const SearchFilter();
  Timer? _debounce;

  @override
  void initState() {
    super.initState();

    _queryCtrl.addListener(_onQueryChanged);
  }

  @override
  void dispose() {
    _debounce?.cancel();
    _queryCtrl
      ..removeListener(_onQueryChanged)
      ..dispose();

    super.dispose();
  }

  void _onQueryChanged() {
    _debounce?.cancel();
    _debounce = Timer(const Duration(milliseconds: 300), () {
      final next = _queryCtrl.text.trim();
      if (next == _filter.query) return;
      setState(() {
        _filter = SearchFilter(
          query: next,
          year: _filter.year,
          month: _filter.month,
        );
      });
    });
  }

  void _selectMonth({int? year, int? month}) {
    setState(() {
      _filter = SearchFilter(
        query: _filter.query,
        year: year,
        month: month,
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    final colors = context.wdsColors;
    final spacing = context.wdsSpacing;
    final monthsAsync = ref.watch(pieceMonthsProvider);
    final resultsAsync = ref.watch(searchResultsProvider(filter: _filter));

    return Scaffold(
      backgroundColor: colors.backgroundNormalNormal,
      appBar: AppBar(title: const Text('Search')),
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Padding(
              padding: EdgeInsets.fromLTRB(
                spacing.componentXl,
                spacing.componentMd,
                spacing.componentXl,
                spacing.componentSm,
              ),
              child: WdsTextField(
                controller: _queryCtrl,
                placeholder: 'Search captions...',
              ),
            ),
            SizedBox(
              height: 40,
              child: monthsAsync.when(
                loading: () => const SizedBox.shrink(),
                error: (_, _) => const SizedBox.shrink(),
                data: (months) => _MonthChips(
                  months: months,
                  selectedYear: _filter.year,
                  selectedMonth: _filter.month,
                  onSelect: _selectMonth,
                ),
              ),
            ),
            SizedBox(height: spacing.componentMd),
            Expanded(
              child: resultsAsync.when(
                loading: () => const Center(child: WdsSpinner()),
                error: (e, _) => Center(
                  child: Padding(
                    padding: EdgeInsets.all(spacing.componentXl),
                    child: WdsText(
                      'Failed to search: $e',
                      style: WdsTextStyle.body2,
                      color: WdsTextColor.alternative,
                    ),
                  ),
                ),
                data: (pieces) => pieces.isEmpty
                    ? _EmptyResults(query: _filter.query)
                    : ListView.separated(
                        padding: EdgeInsets.fromLTRB(
                          spacing.componentXl,
                          spacing.componentSm,
                          spacing.componentXl,
                          spacing.componentXl,
                        ),
                        itemCount: pieces.length,
                        separatorBuilder: (_, _) =>
                            SizedBox(height: spacing.componentMd),
                        itemBuilder: (context, i) {
                          final p = pieces[i];
                          return SearchResultCard(
                            piece: p,
                            onTap: () => context.push('/piece/${p.id}'),
                          );
                        },
                      ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _MonthChips extends StatelessWidget {
  const _MonthChips({
    required this.months,
    required this.selectedYear,
    required this.selectedMonth,
    required this.onSelect,
  });

  final List<({int year, int month})> months;
  final int? selectedYear;
  final int? selectedMonth;
  final void Function({int? year, int? month}) onSelect;

  @override
  Widget build(BuildContext context) {
    final spacing = context.wdsSpacing;
    final entries = <({String label, int? year, int? month})>[
      (label: 'All', year: null, month: null),
      ...months.map(
        (m) => (label: _monthsLong[m.month - 1], year: m.year, month: m.month),
      ),
    ];

    return ListView.separated(
      scrollDirection: Axis.horizontal,
      padding: EdgeInsets.symmetric(horizontal: spacing.componentXl),
      itemCount: entries.length,
      separatorBuilder: (_, _) => SizedBox(width: spacing.componentSm),
      itemBuilder: (_, i) {
        final e = entries[i];
        final active = e.year == selectedYear && e.month == selectedMonth;
        return _Chip(
          label: e.label,
          active: active,
          onTap: () => onSelect(year: e.year, month: e.month),
        );
      },
    );
  }
}

class _Chip extends StatelessWidget {
  const _Chip({
    required this.label,
    required this.active,
    required this.onTap,
  });

  final String label;
  final bool active;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final colors = context.wdsColors;
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(999),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: active ? colors.primaryNormal : Colors.transparent,
          borderRadius: BorderRadius.circular(999),
          border: Border.all(
            color: active ? colors.primaryNormal : colors.lineNormalNeutral,
          ),
        ),
        alignment: Alignment.center,
        child: Text(
          label,
          style: TextStyle(
            color: active ? colors.staticWhite : colors.labelNormal,
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
    );
  }
}

class _EmptyResults extends StatelessWidget {
  const _EmptyResults({required this.query});

  final String query;

  @override
  Widget build(BuildContext context) {
    final spacing = context.wdsSpacing;
    final msg = query.isEmpty
        ? '아직 저장된 piece가 없어요.'
        : "'$query'에 대한 결과가 없어요.";

    return Center(
      child: Padding(
        padding: EdgeInsets.all(spacing.componentXl),
        child: WdsText(
          msg,
          style: WdsTextStyle.body1,
          color: WdsTextColor.alternative,
        ),
      ),
    );
  }
}
