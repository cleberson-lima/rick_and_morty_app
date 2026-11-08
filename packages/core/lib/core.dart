/// Shared infrastructure: networking, errors, theme and design system.
library;

export 'domain.dart';
export 'src/di/core_module.dart';
export 'src/navigation/app_routes.dart';
export 'src/network/dio_factory.dart';
export 'src/network/failure_mapper.dart';
export 'src/network/rate_limit_retry_interceptor.dart';
export 'src/theme/app_theme.dart';
export 'src/theme/theme_cubit.dart';
export 'src/theme/theme_mode_selector.dart';
export 'src/theme/theme_toggle_button.dart';
export 'src/ui/app_network_image.dart';
export 'src/ui/bottom_safe_area.dart';
export 'src/ui/details_chip_button.dart';
export 'src/ui/loading_skeleton.dart';
export 'src/ui/page_selector.dart';
export 'src/ui/phosphor_icons.dart';
export 'src/ui/responsive_results_view.dart';
export 'src/ui/result_card.dart';
export 'src/ui/state_view.dart';
export 'src/ui/status_chip.dart';
