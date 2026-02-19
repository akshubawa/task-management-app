import 'package:flutter/widgets.dart';

import '../constants/app_dimensions.dart';

/// Central place for device/screen helpers used across the app.
///
/// Keep these as tiny wrappers so UI code doesn't re-implement breakpoints.
bool isTablet(BuildContext context) => AppDimensions.isTablet(context);
