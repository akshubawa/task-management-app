import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class AppDimensions {
  AppDimensions._();

  static double baseSpacing = 4.0.w;

  static double spacingXXs = 0.5.w;

  static double spacingXs = 4.0.w;

  static double spacingS = 8.0.w;

  static double spacingM = 12.0.w;

  static double spacingL = 16.0.w;

  static double spacingXl = 20.0.w;

  static double spacing2Xl = 24.0.w;

  static double spacing3Xl = 32.0.w;

  static double spacing4Xl = 40.0.w;

  static double spacing5Xl = 48.0.w;

  static double spacing6Xl = 56.0.w;

  static double spacing7Xl = 64.0.w;

  static double screenPaddingHorizontal = 20.0.w;

  static double screenPaddingVertical = 20.0.h;

  static EdgeInsets screenPadding = EdgeInsets.all(20.0.w);

  static EdgeInsets screenPaddingH = EdgeInsets.symmetric(horizontal: 20.0.w);

  static EdgeInsets screenPaddingV = EdgeInsets.symmetric(vertical: 20.0.h);

  static EdgeInsets cardPadding = EdgeInsets.all(16.0.w);

  static EdgeInsets cardPaddingSmall = EdgeInsets.all(12.0.w);

  static EdgeInsets cardPaddingLarge = EdgeInsets.all(20.0.w);

  static EdgeInsets listItemPadding = EdgeInsets.symmetric(
    horizontal: 16.0.w,
    vertical: 12.0.h,
  );

  static EdgeInsets inputPadding = EdgeInsets.symmetric(
    horizontal: 16.0.w,
    vertical: 12.0.h,
  );

  static EdgeInsets buttonPaddingSmall = EdgeInsets.symmetric(
    horizontal: 12.0.w,
    vertical: 8.0.h,
  );

  static EdgeInsets buttonPaddingMedium = EdgeInsets.symmetric(
    horizontal: 16.0.w,
    vertical: 12.0.h,
  );

  static EdgeInsets buttonPaddingLarge = EdgeInsets.symmetric(
    horizontal: 20.0.w,
    vertical: 14.0.h,
  );

  static EdgeInsets dialogPadding = EdgeInsets.all(24.0.w);

  static EdgeInsets bottomSheetPadding = EdgeInsets.all(20.0.w);

  static double radiusNone = 0.0;

  static double radiusXs = 4.0.r;

  static double radiusS = 8.0.r;

  static double radiusM = 12.0.r;

  static double radiusL = 16.0.r;

  static double radiusXl = 20.0.r;

  static double radius2Xl = 24.0.r;

  static double radiusCircular = 999.0.r;

  static BorderRadius get borderRadiusXs =>
      BorderRadius.all(Radius.circular(radiusXs));
  static BorderRadius get borderRadiusS =>
      BorderRadius.all(Radius.circular(radiusS));
  static BorderRadius get borderRadiusM =>
      BorderRadius.all(Radius.circular(radiusM));
  static BorderRadius get borderRadiusL =>
      BorderRadius.all(Radius.circular(radiusL));
  static BorderRadius get borderRadiusXl =>
      BorderRadius.all(Radius.circular(radiusXl));
  static BorderRadius get borderRadius2Xl =>
      BorderRadius.all(Radius.circular(radius2Xl));
  static BorderRadius get borderRadiusCircular =>
      BorderRadius.all(Radius.circular(radiusCircular));

  static double borderWidthThin = 1.0.w;

  static double borderWidthMedium = 1.5.w;

  static double borderWidthThick = 2.0.w;

  static double borderWidthExtraThick = 3.0.w;

  static double iconXs = 12.0.w;

  static double iconS = 16.0.w;

  static double iconM = 20.0.w;

  static double iconL = 24.0.w;

  static double iconXl = 28.0.w;

  static double icon2Xl = 32.0.w;

  static double icon3Xl = 40.0.w;

  static double icon4Xl = 48.0.w;

  static double avatarXs = 24.0.w;

  static double avatarS = 32.0.w;

  static double avatarM = 40.0.w;

  static double avatarL = 48.0.w;

  static double avatarXl = 64.0.w;

  static double avatar2Xl = 80.0.w;

  static double avatar3Xl = 96.0.w;

  static double avatar4Xl = 120.0.w;

  static double buttonHeightSmall = 36.0.h;

  static double buttonHeightMedium = 48.0.h;

  static double buttonHeightLarge = 56.0.h;

  static double buttonHeightExtraLarge = 64.0.h;

  static double inputHeightSmall = 40.0.h;

  static double inputHeightMedium = 48.0.h;

  static double inputHeightLarge = 56.0.h;

  static const double cardHeightSmall = 80.0;

  static const double cardHeightMedium = 120.0;

  static const double cardHeightLarge = 160.0;

  static const double cardMinWidth = 280.0;

  static const double cardMaxWidth = 400.0;

  static const double bottomNavBarHeight = 64.0;

  static const double bottomNavBarIconSize = 24.0;

  static const double appBarHeight = 56.0;

  static const double appBarElevation = 0.0;

  static const double dividerThickness = 1.0;

  static const double dividerIndent = 16.0;

  static const double elevationNone = 0.0;

  static const double elevationLow = 2.0;

  static const double elevationMedium = 4.0;

  static const double elevationHigh = 8.0;

  static const double elevationExtraHigh = 12.0;

  static const double dialogWidthSmall = 280.0;

  static const double dialogWidthMedium = 400.0;

  static const double dialogWidthLarge = 560.0;

  static const double bottomSheetMaxHeightRatio = 0.9;

  static const double bottomSheetRadius = 20.0;

  static const double formFieldSpacing = 16.0;

  static const double formSectionSpacing = 24.0;

  static const double listItemHeightSmall = 48.0;

  static const double listItemHeightMedium = 64.0;

  static const double listItemHeightLarge = 80.0;

  static const double listItemSpacing = 8.0;

  static const double progressIndicatorSmall = 16.0;

  static const double progressIndicatorMedium = 24.0;

  static const double progressIndicatorLarge = 32.0;

  static const double progressIndicatorStrokeWidth = 3.0;

  static const double badgeSmall = 16.0;

  static const double badgeMedium = 20.0;

  static const double badgeLarge = 24.0;

  static const double chipHeight = 32.0;

  static const EdgeInsets chipPadding = EdgeInsets.symmetric(
    horizontal: 12.0,
    vertical: 6.0,
  );

  static const double tabBarHeight = 48.0;

  static const double tabIndicatorHeight = 3.0;

  static const double statusDotSize = 8.0;

  static const double statusDotSizeLarge = 12.0;

  static const double breakpointMobile = 600.0;

  static const double breakpointTablet = 900.0;

  static const double breakpointDesktop = 1200.0;

  static const double maxContentWidth = 1200.0;

  static const double maxFormWidth = 480.0;

  static const double loginCardWidth = 360.0;

  static const double signupCardWidth = 400.0;

  static const double memberCardHeight = 72.0;

  static const double planCardWidth = 150.0;

  static const double planCardHeight = 140.0;

  static const double dashboardCardMinHeight = 100.0;

  static const double attendanceCircleSize = 100.0;

  static const double gymLogoSize = 64.0;

  static const int animationFast = 150;

  static const int animationNormal = 250;

  static const int animationSlow = 350;

  static const int animationPageTransition = 300;

  static const Duration durationFast = Duration(milliseconds: animationFast);
  static const Duration durationNormal = Duration(
    milliseconds: animationNormal,
  );
  static const Duration durationSlow = Duration(milliseconds: animationSlow);
  static const Duration durationPageTransition = Duration(
    milliseconds: animationPageTransition,
  );

  static EdgeInsets getResponsivePadding(double screenWidth) {
    if (screenWidth < breakpointMobile) {
      return const EdgeInsets.all(16.0);
    } else if (screenWidth < breakpointTablet) {
      return const EdgeInsets.all(20.0);
    } else {
      return const EdgeInsets.all(24.0);
    }
  }

  static double getResponsiveSpacing(double screenWidth) {
    if (screenWidth < breakpointMobile) {
      return spacingM;
    } else if (screenWidth < breakpointTablet) {
      return spacingL;
    } else {
      return spacingXl;
    }
  }

  static double getResponsiveCardWidth(double screenWidth) {
    if (screenWidth < breakpointMobile) {
      return screenWidth - (screenPaddingHorizontal * 2);
    } else if (screenWidth < breakpointTablet) {
      return cardMaxWidth;
    } else {
      return cardMaxWidth * 1.2;
    }
  }

  static EdgeInsets symmetric({double horizontal = 0, double vertical = 0}) {
    return EdgeInsets.symmetric(horizontal: horizontal, vertical: vertical);
  }

  static EdgeInsets all(double value) {
    return EdgeInsets.all(value);
  }

  static EdgeInsets only({
    double left = 0,
    double top = 0,
    double right = 0,
    double bottom = 0,
  }) {
    return EdgeInsets.only(left: left, top: top, right: right, bottom: bottom);
  }

  static SizedBox verticalSpace(double height) {
    return SizedBox(height: height);
  }

  static SizedBox horizontalSpace(double width) {
    return SizedBox(width: width);
  }

  static bool isMobile(BuildContext context) {
    return MediaQuery.of(context).size.width < breakpointMobile;
  }

  static bool isTablet(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    return width >= breakpointMobile && width < breakpointDesktop;
  }

  static bool isDesktop(BuildContext context) {
    return MediaQuery.of(context).size.width >= breakpointDesktop;
  }

  static double screenWidth(BuildContext context) {
    return MediaQuery.of(context).size.width;
  }

  static double screenHeight(BuildContext context) {
    return MediaQuery.of(context).size.height;
  }

  static EdgeInsets safeAreaPadding(BuildContext context) {
    return MediaQuery.of(context).padding;
  }
}
