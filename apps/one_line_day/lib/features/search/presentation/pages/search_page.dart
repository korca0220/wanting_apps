import 'package:design_system/design_system.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/domain/entities/entry.dart';
import '../../../edit_entry/presentation/widgets/edit_entry_sheet.dart';
import '../providers/search_providers.dart';

class SearchPage extends ConsumerStatefulWidget {
  const SearchPage({super.key});

  @override
  ConsumerState<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends ConsumerState<SearchPage> {
  final _controller = TextEditingController();
  String _query = '';

  static const _monthsShort = [
    'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
    'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec',
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
                  WdsText('Search', style: WdsTextStyle.title2),
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
                  ? _SearchHint()
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
                          itemBuilder: (context, i) => _SearchResultCard(
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

class _SearchHint extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final colors = context.wdsColors;

    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.search, size: 40, color: colors.labelAssistive),
          const SizedBox(height: WdsSpacing.s12),
          WdsText(
            'Type a keyword',
            style: WdsTextStyle.body1,
            color: WdsTextColor.alternative,
          ),
          const SizedBox(height: WdsSpacing.s4),
          WdsText(
            'Find entries by words you remember',
            style: WdsTextStyle.caption1,
            color: WdsTextColor.disable,
          ),
        ],
      ),
    );
  }
}

class _SearchResultCard extends StatelessWidget {
  const _SearchResultCard({
    required this.entry,
    required this.dateLabel,
    required this.query,
  });

  final Entry entry;
  final String dateLabel;
  final String query;

  @override
  Widget build(BuildContext context) {
    final colors = context.wdsColors;

    return GestureDetector(
      onTap: () => showEditEntrySheet(context, date: entry.date, existing: entry),
      child: Container(
        decoration: BoxDecoration(
          color: colors.backgroundElevatedNormal,
          borderRadius: BorderRadius.circular(12),
        ),
        padding: const EdgeInsets.all(WdsSpacing.s16),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  WdsText(
                    dateLabel,
                    style: WdsTextStyle.caption1,
                    color: WdsTextColor.alternative,
                  ),
                  const SizedBox(height: WdsSpacing.s6),
                  _HighlightedText(text: entry.text, query: query),
                ],
              ),
            ),
            const SizedBox(width: WdsSpacing.s8),
            Icon(Icons.chevron_right, size: 18, color: colors.labelAssistive),
          ],
        ),
      ),
    );
  }
}

class _HighlightedText extends StatelessWidget {
  const _HighlightedText({required this.text, required this.query});

  final String text;
  final String query;

  @override
  Widget build(BuildContext context) {
    final colors = context.wdsColors;
    final baseStyle = context.wdsType.body1.copyWith(color: colors.labelNormal);
    final highlightStyle = baseStyle.copyWith(
      color: colors.primaryNormal,
      fontWeight: FontWeight.w700,
    );

    final lower = text.toLowerCase();
    final lowerQ = query.toLowerCase();
    final idx = lower.indexOf(lowerQ);

    if (idx < 0) return Text(text, style: baseStyle);

    return Text.rich(
      TextSpan(children: [
        if (idx > 0) TextSpan(text: text.substring(0, idx), style: baseStyle),
        TextSpan(
          text: text.substring(idx, idx + query.length),
          style: highlightStyle,
        ),
        if (idx + query.length < text.length)
          TextSpan(text: text.substring(idx + query.length), style: baseStyle),
      ]),
    );
  }
}
