import 'package:design_system/design_system.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../providers/search_providers.dart';
import '../widgets/search_hint.dart';
import '../widgets/search_result_card.dart';

class SearchPage extends ConsumerStatefulWidget {
  const SearchPage({super.key});

  @override
  ConsumerState<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends ConsumerState<SearchPage> {
  final _controller = TextEditingController();
  String _query = '';

  static const _monthsShort = [
    'Jan',
    'Feb',
    'Mar',
    'Apr',
    'May',
    'Jun',
    'Jul',
    'Aug',
    'Sep',
    'Oct',
    'Nov',
    'Dec',
  ];
  static const _weekdays = ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'];

  String _cardDate(String dateStr) {
    final parts = dateStr.split('-');
    final d = DateTime(
      int.parse(parts[0]),
      int.parse(parts[1]),
      int.parse(parts[2]),
    );
    return '${_weekdays[d.weekday - 1]}, ${_monthsShort[d.month - 1]} ${d.day}';
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final colors = context.wdsColors;
    final spacing = context.wdsSpacing;
    final results = ref.watch(searchResultsProvider(_query));
    final hasQuery = _query.isNotEmpty;

    return Scaffold(
      backgroundColor: colors.backgroundNormalNormal,
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Container(
              color: colors.backgroundNormalNormal,
              padding: EdgeInsets.fromLTRB(
                spacing.componentLg,
                spacing.componentLg,
                spacing.componentLg,
                WdsSpacing.s12,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const WdsText('Search', style: WdsTextStyle.title2),
                  const SizedBox(height: WdsSpacing.s16),
                  WdsTextField(
                    controller: _controller,
                    placeholder: 'Search your lines…',
                    onChanged: (v) => setState(() => _query = v.trim()),
                  ),
                  if (hasQuery && results.isNotEmpty) ...[
                    const SizedBox(height: WdsSpacing.s10),
                    WdsText(
                      '${results.length} result${results.length == 1 ? '' : 's'}',
                      style: WdsTextStyle.caption1,
                      color: WdsTextColor.alternative,
                    ),
                  ],
                ],
              ),
            ),
            const WdsDivider(),
            Expanded(
              child: !hasQuery
                  ? const SearchHint()
                  : results.isEmpty
                  ? WdsFallbackView(
                      title: 'No results',
                      description: 'Nothing matched "$_query".',
                    )
                  : ListView.separated(
                      padding: EdgeInsets.symmetric(
                        horizontal: spacing.componentLg,
                        vertical: WdsSpacing.s16,
                      ),
                      itemCount: results.length,
                      separatorBuilder: (_, _) =>
                          const SizedBox(height: WdsSpacing.s8),
                      itemBuilder: (context, i) => SearchResultCard(
                        entry: results[i],
                        dateLabel: _cardDate(results[i].date),
                        query: _query,
                      ),
                    ),
            ),
          ],
        ),
      ),
    );
  }
}
