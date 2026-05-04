import 'package:design_system/design_system.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const ShowcaseApp());
}

class ShowcaseApp extends StatefulWidget {
  const ShowcaseApp({super.key});

  @override
  State<ShowcaseApp> createState() => _ShowcaseAppState();
}

class _ShowcaseAppState extends State<ShowcaseApp> {
  ThemeMode _mode = ThemeMode.light;

  void _toggle() => setState(
        () => _mode = _mode == ThemeMode.light ? ThemeMode.dark : ThemeMode.light,
      );

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Wanted DS — Showcase',
      theme: WdsTheme.light(),
      darkTheme: WdsTheme.dark(),
      themeMode: _mode,
      home: ShowcaseHome(mode: _mode, onToggleMode: _toggle),
    );
  }
}

class ShowcaseHome extends StatelessWidget {
  const ShowcaseHome({
    super.key,
    required this.mode,
    required this.onToggleMode,
  });

  final ThemeMode mode;
  final VoidCallback onToggleMode;

  @override
  Widget build(BuildContext context) {
    final colors = context.wdsColors;
    final type = context.wdsType;

    return Scaffold(
      appBar: AppBar(
        title: Text('Wanted DS — Showcase', style: type.heading2),
        actions: [
          IconButton(
            tooltip: 'Toggle theme',
            onPressed: onToggleMode,
            icon: Icon(
              mode == ThemeMode.light ? Icons.dark_mode : Icons.light_mode,
            ),
          ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          const _Section(
            title: 'Button — Solid Primary',
            child: _ButtonRow(
              variant: WdsButtonVariant.solid,
              color: WdsButtonColor.primary,
            ),
          ),
          const _Section(
            title: 'Button — Solid Assistive',
            child: _ButtonRow(
              variant: WdsButtonVariant.solid,
              color: WdsButtonColor.assistive,
            ),
          ),
          const _Section(
            title: 'Button — Outlined Primary',
            child: _ButtonRow(
              variant: WdsButtonVariant.outlined,
              color: WdsButtonColor.primary,
            ),
          ),
          const _Section(
            title: 'Button — Outlined Assistive',
            child: _ButtonRow(
              variant: WdsButtonVariant.outlined,
              color: WdsButtonColor.assistive,
            ),
          ),
          _Section(
            title: 'Button — States (medium / solid primary)',
            child: Wrap(
              spacing: 12,
              runSpacing: 12,
              children: [
                WdsButton(onPressed: () {}, child: const Text('Default')),
                const WdsButton(onPressed: null, child: Text('Disabled')),
                WdsButton(
                  onPressed: () {},
                  loading: true,
                  child: const Text('Loading'),
                ),
                WdsButton(
                  onPressed: () {},
                  iconLeading: const Icon(Icons.bolt, size: 16),
                  child: const Text('Leading icon'),
                ),
                WdsButton(
                  onPressed: () {},
                  iconTrailing: const Icon(Icons.arrow_forward, size: 16),
                  child: const Text('Trailing icon'),
                ),
                WdsButton(
                  onPressed: () {},
                  iconOnly: true,
                  child: const Icon(Icons.add, size: 18),
                ),
              ],
            ),
          ),
          const _PhaseBSections(),
          const _PhaseCSections(),
          const _PhaseDSections(),
          const SizedBox(height: 24),
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: colors.fillAlternative,
              borderRadius: const BorderRadius.all(Radius.circular(12)),
            ),
            child: Text(
              'Token sample — primaryNormal, labelNormal, fillAlternative '
              'all driven from the active WdsColorScheme. Toggle the theme '
              'above to verify dark mode.',
              style: type.body2,
            ),
          ),
        ],
      ),
    );
  }
}

class _Section extends StatelessWidget {
  const _Section({required this.title, required this.child});

  final String title;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    final type = context.wdsType;
    return Padding(
      padding: const EdgeInsets.only(bottom: 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title, style: type.headline2),
          const SizedBox(height: 12),
          child,
        ],
      ),
    );
  }
}

class _ButtonRow extends StatelessWidget {
  const _ButtonRow({required this.variant, required this.color});

  final WdsButtonVariant variant;
  final WdsButtonColor color;

  @override
  Widget build(BuildContext context) {
    Widget btn(WdsButtonSize size, String label) => WdsButton(
          onPressed: () {},
          variant: variant,
          color: color,
          size: size,
          child: Text(label),
        );
    return Wrap(
      spacing: 12,
      runSpacing: 12,
      crossAxisAlignment: WrapCrossAlignment.center,
      children: [
        btn(WdsButtonSize.small, 'Small'),
        btn(WdsButtonSize.medium, 'Medium'),
        btn(WdsButtonSize.large, 'Large'),
      ],
    );
  }
}

class _PhaseBSections extends StatefulWidget {
  const _PhaseBSections();

  @override
  State<_PhaseBSections> createState() => _PhaseBSectionsState();
}

class _PhaseBSectionsState extends State<_PhaseBSections> {
  bool? _checkbox = false;
  bool? _checkboxIndet;
  String _radio = 'a';
  bool _switch = true;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _Section(
          title: 'IconButton',
          child: Wrap(
            spacing: 12,
            runSpacing: 12,
            children: [
              WdsIconButton(
                onPressed: () {},
                semanticLabel: 'Close',
                icon: const Icon(Icons.close),
              ),
              WdsIconButton(
                onPressed: () {},
                variant: WdsIconButtonVariant.background,
                semanticLabel: 'More',
                icon: const Icon(Icons.more_horiz),
              ),
              WdsIconButton(
                onPressed: () {},
                variant: WdsIconButtonVariant.outlined,
                semanticLabel: 'Search',
                icon: const Icon(Icons.search),
              ),
              WdsIconButton(
                onPressed: () {},
                variant: WdsIconButtonVariant.solid,
                semanticLabel: 'Add',
                icon: const Icon(Icons.add),
              ),
              WdsIconButton(
                onPressed: () {},
                size: WdsIconButtonSize.small,
                semanticLabel: 'Heart',
                icon: const Icon(Icons.favorite_border),
              ),
            ],
          ),
        ),
        _Section(
          title: 'Checkbox',
          child: Wrap(
            spacing: 16,
            runSpacing: 12,
            children: [
              WdsCheckbox(
                value: _checkbox,
                label: 'Default',
                onChanged: (v) => setState(() => _checkbox = v),
              ),
              WdsCheckbox(
                value: _checkboxIndet,
                label: 'Indeterminate',
                onChanged: (v) => setState(() => _checkboxIndet = v),
              ),
              const WdsCheckbox(
                value: false,
                onChanged: null,
                label: 'Disabled',
              ),
              const WdsCheckbox(
                value: true,
                onChanged: null,
                label: 'Required',
                required: true,
              ),
              const WdsCheckbox(
                value: true,
                onChanged: null,
                label: 'Invalid',
                invalid: true,
              ),
            ],
          ),
        ),
        _Section(
          title: 'Radio',
          child: Wrap(
            spacing: 16,
            runSpacing: 12,
            children: [
              WdsRadio<String>(
                value: 'a',
                groupValue: _radio,
                label: 'Option A',
                onChanged: (v) => setState(() => _radio = v ?? 'a'),
              ),
              WdsRadio<String>(
                value: 'b',
                groupValue: _radio,
                label: 'Option B',
                onChanged: (v) => setState(() => _radio = v ?? 'b'),
              ),
              WdsRadio<String>(
                value: 'c',
                groupValue: _radio,
                label: 'Option C (small)',
                size: WdsRadioSize.small,
                onChanged: (v) => setState(() => _radio = v ?? 'c'),
              ),
            ],
          ),
        ),
        _Section(
          title: 'Switch',
          child: Wrap(
            spacing: 16,
            runSpacing: 12,
            crossAxisAlignment: WrapCrossAlignment.center,
            children: [
              WdsSwitch(
                value: _switch,
                onChanged: (v) => setState(() => _switch = v),
              ),
              WdsSwitch(
                value: _switch,
                size: WdsSwitchSize.small,
                onChanged: (v) => setState(() => _switch = v),
              ),
              const WdsSwitch(value: true, onChanged: null),
            ],
          ),
        ),
        const _Section(
          title: 'Divider',
          child: SizedBox(
            height: 80,
            child: Row(
              children: [
                Expanded(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Text('A'),
                      WdsDivider(),
                      Text('B'),
                    ],
                  ),
                ),
                SizedBox(width: 16),
                WdsDivider(vertical: true),
                SizedBox(width: 16),
                Expanded(
                  child: Center(child: Text('Vertical divider →')),
                ),
              ],
            ),
          ),
        ),
        const _Section(
          title: 'Badge',
          child: Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              WdsBadge(label: 'NEW', size: WdsBadgeSize.xsmall),
              WdsBadge(label: 'Tag', size: WdsBadgeSize.small),
              WdsBadge(label: 'Medium'),
              WdsBadge(label: 'Outlined', variant: WdsBadgeVariant.outlined),
            ],
          ),
        ),
        const _Section(
          title: 'Label',
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              WdsLabel(text: 'Default label'),
              SizedBox(height: 4),
              WdsLabel(text: 'Required field', required: true),
              SizedBox(height: 4),
              WdsLabel(text: 'Disabled label', disabled: true),
            ],
          ),
        ),
        const _Section(
          title: 'Avatar',
          child: Wrap(
            spacing: 12,
            runSpacing: 12,
            crossAxisAlignment: WrapCrossAlignment.center,
            children: [
              WdsAvatar(size: WdsAvatarSize.xsmall),
              WdsAvatar(size: WdsAvatarSize.small, initials: 'JW'),
              WdsAvatar(),
              WdsAvatar(
                variant: WdsAvatarVariant.company,
                size: WdsAvatarSize.large,
              ),
              WdsAvatar(
                variant: WdsAvatarVariant.academy,
                size: WdsAvatarSize.large,
              ),
            ],
          ),
        ),
        const _Section(
          title: 'Spinner',
          child: Wrap(
            spacing: 16,
            runSpacing: 12,
            crossAxisAlignment: WrapCrossAlignment.center,
            children: [
              WdsSpinner(size: 16),
              WdsSpinner(),
              WdsSpinner(size: 32, variant: WdsSpinnerVariant.wanted),
            ],
          ),
        ),
      ],
    );
  }
}

class _PhaseCSections extends StatefulWidget {
  const _PhaseCSections();

  @override
  State<_PhaseCSections> createState() => _PhaseCSectionsState();
}

class _PhaseCSectionsState extends State<_PhaseCSections> {
  String _selected = 'flutter';
  int _step = 1;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _Section(
          title: 'Alert (modal)',
          child: WdsButton(
            onPressed: () {
              WdsAlert.show<bool>(
                context: context,
                title: 'Delete this draft?',
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
            },
            child: const Text('Open Alert'),
          ),
        ),
        _Section(
          title: 'Snackbar',
          child: Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              WdsButton(
                onPressed: () => WdsSnackbar.show(
                  context: context,
                  message: 'Saved successfully',
                  variant: WdsSnackbarVariant.success,
                  actionLabel: 'View',
                  onAction: () {},
                ),
                size: WdsButtonSize.small,
                child: const Text('Success'),
              ),
              WdsButton(
                onPressed: () => WdsSnackbar.show(
                  context: context,
                  message: 'Could not connect',
                  variant: WdsSnackbarVariant.error,
                ),
                variant: WdsButtonVariant.outlined,
                size: WdsButtonSize.small,
                child: const Text('Error'),
              ),
              WdsButton(
                onPressed: () => WdsSnackbar.show(
                  context: context,
                  message: 'Heads up — limited data',
                  variant: WdsSnackbarVariant.warning,
                ),
                variant: WdsButtonVariant.outlined,
                color: WdsButtonColor.assistive,
                size: WdsButtonSize.small,
                child: const Text('Warning'),
              ),
            ],
          ),
        ),
        _Section(
          title: 'ProgressTracker',
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              WdsProgressTracker(
                steps: const ['Account', 'Profile', 'Verify', 'Done'],
                current: _step,
              ),
              const SizedBox(height: 12),
              Wrap(
                spacing: 8,
                children: [
                  WdsButton(
                    onPressed: _step > 0
                        ? () => setState(() => _step--)
                        : null,
                    variant: WdsButtonVariant.outlined,
                    size: WdsButtonSize.small,
                    child: const Text('Prev'),
                  ),
                  WdsButton(
                    onPressed: _step < 3
                        ? () => setState(() => _step++)
                        : null,
                    size: WdsButtonSize.small,
                    child: const Text('Next'),
                  ),
                ],
              ),
            ],
          ),
        ),
        const _Section(
          title: 'Skeleton',
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  WdsSkeleton(variant: WdsSkeletonVariant.circle),
                  SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        WdsSkeleton(width: 160),
                        SizedBox(height: 6),
                        WdsSkeleton(width: 100),
                      ],
                    ),
                  ),
                ],
              ),
              SizedBox(height: 12),
              WdsSkeleton(
                variant: WdsSkeletonVariant.rectangle,
                width: double.infinity,
                height: 120,
              ),
            ],
          ),
        ),
        _Section(
          title: 'FallbackView',
          child: Container(
            decoration: BoxDecoration(
              border: Border.all(
                color: context.wdsColors.lineNormalAlternative,
              ),
              borderRadius: BorderRadius.circular(12),
            ),
            child: WdsFallbackView(
              padding: WdsFallbackViewPadding.compact,
              image: const Icon(Icons.inbox_outlined, size: 60),
              title: 'No items yet',
              description:
                  'Once you start a piece, it will appear here for quick access.',
              action: WdsButton(
                onPressed: () {},
                child: const Text('Start a new piece'),
              ),
            ),
          ),
        ),
        _Section(
          title: 'Select',
          child: SizedBox(
            width: 240,
            child: WdsSelect<String>(
              value: _selected,
              label: 'Framework',
              items: const [
                WdsSelectOption(value: 'flutter', label: 'Flutter'),
                WdsSelectOption(value: 'react', label: 'React'),
                WdsSelectOption(value: 'svelte', label: 'Svelte'),
              ],
              onChanged: (v) => setState(() => _selected = v ?? 'flutter'),
            ),
          ),
        ),
      ],
    );
  }
}

class _PhaseDSections extends StatefulWidget {
  const _PhaseDSections();

  @override
  State<_PhaseDSections> createState() => _PhaseDSectionsState();
}

class _PhaseDSectionsState extends State<_PhaseDSections> {
  final _ctrl = TextEditingController();
  final _textareaCtrl = TextEditingController();

  @override
  void dispose() {
    _ctrl.dispose();
    _textareaCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _Section(
          title: 'TextField',
          child: Column(
            children: [
              WdsTextField(
                controller: _ctrl,
                label: 'Email',
                placeholder: 'name@example.com',
                helperText: 'We will never share your email.',
                clearable: true,
              ),
              const SizedBox(height: 12),
              const WdsTextField(
                placeholder: 'Invalid example',
                invalid: true,
                errorText: 'Required',
              ),
              const SizedBox(height: 12),
              const WdsTextField(
                placeholder: 'Disabled',
                disabled: true,
                initialValue: 'cannot edit',
              ),
            ],
          ),
        ),
        _Section(
          title: 'Textarea',
          child: WdsTextarea(
            controller: _textareaCtrl,
            label: 'Notes',
            placeholder: 'Type a few lines...',
            minLines: 3,
            maxLines: 6,
          ),
        ),
        const _Section(
          title: 'Tooltip',
          child: Wrap(
            spacing: 16,
            runSpacing: 12,
            children: [
              WdsTooltip(
                message: 'Hover or long-press',
                child: Icon(Icons.info_outline),
              ),
              WdsTooltip(
                message: 'Copy to clipboard',
                shortcut: '⌘C',
                size: WdsTooltipSize.medium,
                child: Icon(Icons.copy),
              ),
            ],
          ),
        ),
        _Section(
          title: 'Modal',
          child: Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              WdsButton(
                onPressed: () => WdsModal.showPopup<void>(
                  context: context,
                  builder: (ctx) => Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const WdsModalNavigation(title: 'Popup modal'),
                      const WdsModalContent(
                        child: Text('A centred dialog. Tap outside or close to dismiss.'),
                      ),
                      WdsModalActionArea(actions: [
                        WdsButton(
                          onPressed: () => Navigator.of(ctx).pop(),
                          variant: WdsButtonVariant.outlined,
                          color: WdsButtonColor.assistive,
                          size: WdsButtonSize.small,
                          child: const Text('Close'),
                        ),
                      ]),
                    ],
                  ),
                ),
                size: WdsButtonSize.small,
                child: const Text('Popup'),
              ),
              WdsButton(
                onPressed: () => WdsModal.showBottom<void>(
                  context: context,
                  builder: (ctx) => Padding(
                    padding: const EdgeInsets.all(20),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const WdsCardTitle('Bottom sheet'),
                        const SizedBox(height: 8),
                        const WdsCardCaption(
                          'Drag down to dismiss, or tap outside.',
                        ),
                        const SizedBox(height: 16),
                        WdsButton(
                          onPressed: () => Navigator.of(ctx).pop(),
                          size: WdsButtonSize.small,
                          child: const Text('Got it'),
                        ),
                      ],
                    ),
                  ),
                ),
                variant: WdsButtonVariant.outlined,
                size: WdsButtonSize.small,
                child: const Text('Bottom sheet'),
              ),
            ],
          ),
        ),
        _Section(
          title: 'Card',
          child: WdsCard(
            child: WdsCardContent(
              children: [
                WdsCardThumbnail(
                  aspectRatio: 16 / 9,
                  trailingOverlay: const WdsBadge(
                    label: 'NEW',
                    size: WdsBadgeSize.xsmall,
                  ),
                  child: Container(
                    color: context.wdsColors.fillAlternative,
                    child: const Center(child: Icon(Icons.image, size: 40)),
                  ),
                ),
                const WdsCardTitle('A composable card'),
                const WdsCardCaption(
                  'Compose Thumbnail / Title / Caption / Content slots into rich layouts.',
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
