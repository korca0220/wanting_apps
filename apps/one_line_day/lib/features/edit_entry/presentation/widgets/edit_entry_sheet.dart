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
  bool _saving = false;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController(text: widget.existing?.text ?? '');
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  String get _dateLabel {
    final parts = widget.date.split('-');
    return '${parts[0]}. ${parts[1]}. ${parts[2]}';
  }

  bool get _isDirty {
    final current = _controller.text.trim();
    return current.isNotEmpty && current != (widget.existing?.text ?? '');
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
        borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
      ),
      padding: EdgeInsets.fromLTRB(
        spacing.componentLg,
        spacing.componentMd,
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
          SizedBox(height: spacing.componentMd),
          WdsText(_dateLabel, style: WdsTextStyle.heading2),
          SizedBox(height: spacing.componentMd),
          WdsTextarea(
            controller: _controller,
            placeholder: 'How was today?',
            minLines: 3,
            maxLines: 6,
            onChanged: (_) => setState(() {}),
          ),
          SizedBox(height: spacing.componentXs),
          Align(
            alignment: Alignment.centerRight,
            child: Text(
              '${_controller.text.trim().length}/200',
              style: context.wdsType.caption1.copyWith(
                color: _controller.text.trim().length > 200
                    ? context.wdsColors.statusNegative
                    : context.wdsColors.labelAlternative,
              ),
            ),
          ),
          SizedBox(height: spacing.componentMd),
          WdsButton(
            onPressed: (_saving || !_isDirty || _controller.text.trim().length > 200)
                ? null
                : _save,
            child: _saving
                ? const SizedBox(
                    width: 20,
                    height: 20,
                    child: CircularProgressIndicator(strokeWidth: 2),
                  )
                : const Text('Save'),
          ),
          if (widget.existing != null) ...[
            SizedBox(height: spacing.componentSm),
            WdsButton(
              variant: WdsButtonVariant.outlined,
              color: WdsButtonColor.assistive,
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Cancel'),
            ),
            SizedBox(height: spacing.componentSm),
            TextButton(
              onPressed: _delete,
              child: Text(
                'Delete entry',
                style: TextStyle(color: context.wdsColors.statusNegative),
              ),
            ),
          ] else ...[
            SizedBox(height: spacing.componentSm),
            WdsButton(
              variant: WdsButtonVariant.outlined,
              color: WdsButtonColor.assistive,
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Cancel'),
            ),
          ],
        ],
      ),
    );
  }
}
