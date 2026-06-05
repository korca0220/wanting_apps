import 'package:design_system/design_system.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/domain/entities/entry.dart';
import '../../../../core/providers/all_entries_provider.dart';

Future<void> showEditEntrySheet(
  BuildContext context, {
  required String date,
  Entry? existing,
}) {
  return showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    backgroundColor: Colors.transparent,
    builder: (_) => _EditEntrySheet(date: date, existing: existing),
  );
}

class _EditEntrySheet extends ConsumerStatefulWidget {
  const _EditEntrySheet({required this.date, this.existing});

  final String date;
  final Entry? existing;

  @override
  ConsumerState<_EditEntrySheet> createState() => _EditEntrySheetState();
}

class _EditEntrySheetState extends ConsumerState<_EditEntrySheet> {
  late final TextEditingController _controller;
  late final FocusNode _focusNode;
  bool _saving = false;

  static const _weekdays = [
    'Monday',
    'Tuesday',
    'Wednesday',
    'Thursday',
    'Friday',
    'Saturday',
    'Sunday',
  ];
  static const _months = [
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

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController(text: widget.existing?.text ?? '');
    _focusNode = FocusNode();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _focusNode.requestFocus();
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  String get _dateHeader {
    final parts = widget.date.split('-');
    final d = DateTime(
      int.parse(parts[0]),
      int.parse(parts[1]),
      int.parse(parts[2]),
    );
    return '${_weekdays[d.weekday - 1]}, ${_months[d.month - 1]} ${d.day}';
  }

  int get _charCount => _controller.text.trim().length;
  bool get _overLimit => _charCount > 200;
  bool get _isDirty {
    final t = _controller.text.trim();
    return t.isNotEmpty && t != (widget.existing?.text ?? '');
  }

  Future<void> _save() async {
    final text = _controller.text.trim();
    if (text.isEmpty) return;
    setState(() => _saving = true);
    await ref.read(allEntriesProvider.notifier).save(widget.date, text);
    if (mounted) Navigator.of(context).pop();
  }

  Future<void> _delete() async {
    final confirmed = await WdsAlert.show<bool>(
      context: context,
      title: 'Delete entry?',
      description: 'This action cannot be undone.',
      actions: [
        WdsAlertAction(
          label: 'Cancel',
          variant: WdsAlertActionVariant.assistive,
          onPressed: () => Navigator.of(context).pop(false),
        ),
        WdsAlertAction(
          label: 'Delete',
          variant: WdsAlertActionVariant.negative,
          onPressed: () => Navigator.of(context).pop(true),
        ),
      ],
    );
    if (confirmed != true) return;
    await ref.read(allEntriesProvider.notifier).delete(widget.date);
    if (mounted) Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    final colors = context.wdsColors;
    final spacing = context.wdsSpacing;
    final bottom = MediaQuery.viewInsetsOf(context).bottom;

    return Container(
      decoration: BoxDecoration(
        color: colors.backgroundNormalNormal,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
      ),
      padding: EdgeInsets.fromLTRB(
        spacing.componentLg,
        WdsSpacing.s12,
        spacing.componentLg,
        spacing.componentLg + bottom,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Center(
            child: Container(
              width: 36,
              height: 4,
              decoration: BoxDecoration(
                color: colors.lineNormalNeutral,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
          ),
          const SizedBox(height: WdsSpacing.s20),
          WdsText(_dateHeader, style: WdsTextStyle.headline1),
          const SizedBox(height: WdsSpacing.s16),
          WdsTextarea(
            controller: _controller,
            focusNode: _focusNode,
            placeholder: 'Write one line about today…',
            minLines: 3,
            maxLines: 6,
            onChanged: (_) => setState(() {}),
          ),
          const SizedBox(height: WdsSpacing.s6),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Text(
                '$_charCount / 200',
                style: context.wdsType.caption1.copyWith(
                  color: _overLimit
                      ? colors.statusNegative
                      : colors.labelAssistive,
                ),
              ),
            ],
          ),
          const SizedBox(height: WdsSpacing.s16),
          WdsButton(
            onPressed: (_saving || !_isDirty || _overLimit) ? null : _save,
            child: _saving
                ? const SizedBox(
                    width: 20,
                    height: 20,
                    child: CircularProgressIndicator(strokeWidth: 2),
                  )
                : const Text('Save'),
          ),
          const SizedBox(height: WdsSpacing.s8),
          WdsButton(
            variant: WdsButtonVariant.outlined,
            color: WdsButtonColor.assistive,
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Cancel'),
          ),
          if (widget.existing != null) ...[
            const SizedBox(height: WdsSpacing.s4),
            TextButton(
              onPressed: _delete,
              child: Text(
                'Delete entry',
                style: TextStyle(color: colors.statusNegative),
              ),
            ),
          ],
        ],
      ),
    );
  }
}
