import 'dart:async';

import 'package:design_system/design_system.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../providers/search_providers.dart';
import '../widgets/empty_results.dart';
import '../widgets/month_chips.dart';
import '../widgets/result_card.dart';

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
                data: (months) => MonthChips(
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
                    ? EmptyResults(query: _filter.query)
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
