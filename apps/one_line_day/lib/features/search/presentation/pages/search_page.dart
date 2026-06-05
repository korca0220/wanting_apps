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

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final spacing = context.wdsSpacing;
    final results = ref.watch(searchResultsProvider(_query));

    return Scaffold(
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Padding(
              padding: EdgeInsets.fromLTRB(
                spacing.componentLg,
                spacing.componentLg,
                spacing.componentLg,
                spacing.componentSm,
              ),
              child: WdsText('Search', style: WdsTextStyle.title2),
            ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: spacing.componentLg),
              child: WdsTextField(
                controller: _controller,
                placeholder: 'Search your entries…',
                onChanged: (v) => setState(() => _query = v.trim()),
              ),
            ),
            SizedBox(height: spacing.componentMd),
            Expanded(
              child: _query.isEmpty
                  ? WdsFallbackView(
                      title: 'Search your entries',
                      description: 'Type a keyword to find past entries.',
                    )
                  : results.isEmpty
                      ? WdsFallbackView(
                          title: 'No results',
                          description: 'No entries match "$_query".',
                        )
                      : ListView.separated(
                          padding: EdgeInsets.symmetric(
                            horizontal: spacing.componentLg,
                            vertical: spacing.componentSm,
                          ),
                          itemCount: results.length,
                          separatorBuilder: (_, _) =>
                              SizedBox(height: spacing.componentSm),
                          itemBuilder: (context, i) =>
                              _SearchResultCard(entry: results[i]),
                        ),
            ),
          ],
        ),
      ),
    );
  }
}

class _SearchResultCard extends StatelessWidget {
  const _SearchResultCard({required this.entry});

  final Entry entry;

  String get _dateLabel {
    final parts = entry.date.split('-');
    return '${parts[0]}. ${parts[1]}. ${parts[2]}';
  }

  @override
  Widget build(BuildContext context) {
    final spacing = context.wdsSpacing;

    return GestureDetector(
      onTap: () => showEditEntrySheet(
        context,
        date: entry.date,
        existing: entry,
      ),
      child: WdsCard(
        child: Padding(
          padding: EdgeInsets.all(spacing.componentMd),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              WdsText(
                _dateLabel,
                style: WdsTextStyle.caption1,
                color: WdsTextColor.alternative,
              ),
              SizedBox(height: spacing.componentXs),
              WdsText(entry.text, style: WdsTextStyle.body2),
            ],
          ),
        ),
      ),
    );
  }
}
