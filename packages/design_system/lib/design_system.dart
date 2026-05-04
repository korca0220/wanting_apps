/// Wanted Design System (Flutter port).
///
/// See `docs/` for the framework-neutral specification this library
/// implements. Public surface area is limited to semantic tokens and
/// components; primitives are kept in `src/` and not re-exported.
library;

// Theme entry points
export 'src/theme/wds_theme.dart';
export 'src/theme/wds_theme_ext.dart';

// Semantic token types (public so consumers can type-annotate / store
// references in their own ThemeExtensions if needed)
export 'src/theme/wds_color_scheme.dart';
export 'src/theme/wds_typography.dart';
export 'src/theme/wds_spacing_theme.dart';
export 'src/theme/wds_radius_theme.dart';
export 'src/theme/wds_shadow_theme.dart';
export 'src/theme/wds_motion_theme.dart';

// Foundation primitives that components reference directly when no
// semantic alias exists (motion, spacing primitives, typography tokens).
// Color primitives stay private to enforce the Semantic-only invariant.
export 'src/foundations/wds_typography_tokens.dart';
export 'src/foundations/wds_spacing.dart';
export 'src/foundations/wds_radius.dart';
export 'src/foundations/wds_motion.dart';

// Components (Tier 1)
export 'src/components/alert/wds_alert.dart';
export 'src/components/avatar/wds_avatar.dart';
export 'src/components/badge/wds_badge.dart';
export 'src/components/button/wds_button.dart';
export 'src/components/card/wds_card.dart';
export 'src/components/checkbox/wds_checkbox.dart';
export 'src/components/divider/wds_divider.dart';
export 'src/components/fallback_view/wds_fallback_view.dart';
export 'src/components/icon_button/wds_icon_button.dart';
export 'src/components/label/wds_label.dart';
export 'src/components/modal/wds_modal.dart';
export 'src/components/progress_tracker/wds_progress_tracker.dart';
export 'src/components/radio/wds_radio.dart';
export 'src/components/select/wds_select.dart';
export 'src/components/skeleton/wds_skeleton.dart';
export 'src/components/snackbar/wds_snackbar.dart';
export 'src/components/spinner/wds_spinner.dart';
export 'src/components/switch/wds_switch.dart';
export 'src/components/text_field/wds_text_field.dart';
export 'src/components/textarea/wds_textarea.dart';
export 'src/components/tooltip/wds_tooltip.dart';
