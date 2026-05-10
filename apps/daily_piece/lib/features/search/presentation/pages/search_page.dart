import 'package:design_system/design_system.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/domain/entities/piece.dart';
import '../providers/all_pieces_provider.dart';
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

/// Filter values used by the month chip row. `all` means no month
/// constraint; otherwise the chip filters on `${year}-${month}`.
class _MonthFilter {
  const _MonthFilter.all() : year = null, month = null;
  const _MonthFilter.month(this.year, this.month);

  final int? year;
  final int? month;

  bool get isAll => year == null;
  String get key => isAll ? 'all' : '${year!}-${month!.toString().padLeft(2, '0')}';
  String get label => isAll ? 'All' : _monthsLong[month! - 1];
}

class SearchPage extends ConsumerStatefulWidget {
  const SearchPage({super.key});

  @override
  ConsumerState<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends ConsumerState<SearchPage> {
  final _query = TextEditingController();
  _MonthFilter _selected = const _MonthFilter.all();

  @override
  void initState() {
    super.initState();

    _query.addListener(() => setState(() {}));
  }

  @override
  void dispose() {
    _query.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final colors = context.wdsColors;
    final spacing = context.wdsSpacing;
    final asyncPieces = ref.watch(allPiecesProvider);

    return Scaffold(
      backgroundColor: colors.backgroundNormalNormal,
      appBar: AppBar(title: const Text('Search')),
      body: SafeArea(
        child: asyncPieces.when(
          loading: () => const Center(child: WdsSpinner()),
          error: (e, _) => Center(
            child: Padding(
              padding: EdgeInsets.all(spacing.componentXl),
              child: WdsText(
                'Failed to load: $e',
                style: WdsTextStyle.body2,
                color: WdsTextColor.alternative,
              ),
            ),
          ),
          data: (pieces) => _Body(
            pieces: pieces,
            queryCtrl: _query,
            selected: _selected,
            onSelect: (f) => setState(() => _selected = f),
          ),
        ),
      ),
    );
  }
}

class _Body extends StatelessWidget {
  const _Body({
    required this.pieces,
    required this.queryCtrl,
    required this.selected,
    required this.onSelect,
  });

  final List<Piece> pieces;
  final TextEditingController queryCtrl;
  final _MonthFilter selected;
  final ValueChanged<_MonthFilter> onSelect;

  @override
  Widget build(BuildContext context) {
    final spacing = context.wdsSpacing;
    final query = queryCtrl.text.trim().toLowerCase();
    final months = _distinctMonths(pieces);
    final filtered = pieces.where((p) {
      if (!selected.isAll &&
          (p.date.year != selected.year || p.date.month != selected.month)) {
        return false;
      }
      if (query.isEmpty) return true;
      return p.comment.toLowerCase().contains(query);
    }).toList(growable: false);

    return Column(
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
            controller: queryCtrl,
            placeholder: 'Search captions...',
          ),
        ),
        SizedBox(
          height: 40,
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            padding: EdgeInsets.symmetric(horizontal: spacing.componentXl),
            itemCount: months.length,
            separatorBuilder: (_, _) => SizedBox(width: spacing.componentSm),
            itemBuilder: (_, i) {
              final m = months[i];
              final active = m.key == selected.key;
              return _Chip(
                label: m.label,
                active: active,
                onTap: () => onSelect(m),
              );
            },
          ),
        ),
        SizedBox(height: spacing.componentMd),
        Expanded(
          child: filtered.isEmpty
              ? _EmptyResults(query: queryCtrl.text)
              : ListView.separated(
                  padding: EdgeInsets.fromLTRB(
                    spacing.componentXl,
                    spacing.componentSm,
                    spacing.componentXl,
                    spacing.componentXl,
                  ),
                  itemCount: filtered.length,
                  separatorBuilder: (_, _) =>
                      SizedBox(height: spacing.componentMd),
                  itemBuilder: (context, i) {
                    final p = filtered[i];
                    return SearchResultCard(
                      piece: p,
                      onTap: () => context.go('/my-pieces/${p.id}'),
                    );
                  },
                ),
        ),
      ],
    );
  }

  List<_MonthFilter> _distinctMonths(List<Piece> pieces) {
    final set = <String>{};
    final out = <_MonthFilter>[const _MonthFilter.all()];
    for (final p in pieces) {
      final key = '${p.date.year}-${p.date.month.toString().padLeft(2, '0')}';
      if (set.add(key)) {
        out.add(_MonthFilter.month(p.date.year, p.date.month));
      }
    }
    return out;
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
    final msg = query.trim().isEmpty
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
