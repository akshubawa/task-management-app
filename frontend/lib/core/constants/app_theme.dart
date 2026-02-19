import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'app_colors.dart';
import 'app_typography.dart';
import 'app_dimensions.dart';

class AppTheme {
  AppTheme._();

  static ThemeData get darkTheme {
    return ThemeData(
      brightness: Brightness.dark,
      visualDensity: VisualDensity.adaptivePlatformDensity,

      colorScheme: ColorScheme.dark(
        primary: AppColors.primary,
        primaryContainer: AppColors.primaryDark,
        secondary: AppColors.primary,
        secondaryContainer: AppColors.primaryLight,
        surface: AppColors.surface,
        surfaceContainerHighest: AppColors.surfaceElevated,
        error: AppColors.error,
        onPrimary: AppColors.white,
        onSecondary: AppColors.white,
        onSurface: AppColors.textPrimary,
        onError: AppColors.white,
        outline: AppColors.border,
        outlineVariant: AppColors.borderLight,
      ),

      scaffoldBackgroundColor: AppColors.background,

      appBarTheme: AppBarTheme(
        backgroundColor: AppColors.background,
        surfaceTintColor: AppColors.background,
        foregroundColor: AppColors.textPrimary,
        elevation: AppDimensions.elevationNone,
        centerTitle: false,
        titleTextStyle: AppTypography.h3,
        iconTheme: IconThemeData(
          color: AppColors.iconPrimary,
          size: AppDimensions.iconL,
        ),
        actionsIconTheme: IconThemeData(
          color: AppColors.iconPrimary,
          size: AppDimensions.iconL,
        ),
        systemOverlayStyle: const SystemUiOverlayStyle(
          statusBarColor: Colors.transparent,
          statusBarIconBrightness: Brightness.light,
          statusBarBrightness: Brightness.dark,
        ),
      ),

      cardTheme: CardThemeData(
        color: AppColors.surface,
        elevation: AppDimensions.elevationLow,
        shape: RoundedRectangleBorder(
          borderRadius: AppDimensions.borderRadiusM,
        ),
        margin: EdgeInsets.zero,
      ),

      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.buttonPrimary,
          foregroundColor: AppColors.buttonPrimaryText,
          disabledBackgroundColor: AppColors.buttonDisabled,
          disabledForegroundColor: AppColors.buttonDisabledText,
          elevation: AppDimensions.elevationNone,
          shadowColor: Colors.transparent,
          padding: AppDimensions.buttonPaddingMedium,
          minimumSize: Size(double.infinity, AppDimensions.buttonHeightMedium),
          shape: RoundedRectangleBorder(
            borderRadius: AppDimensions.borderRadiusM,
          ),
          textStyle: AppTypography.buttonMedium,
        ),
      ),

      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: AppColors.textPrimary,
          backgroundColor: Colors.transparent,
          disabledForegroundColor: AppColors.buttonDisabledText,
          elevation: AppDimensions.elevationNone,
          padding: AppDimensions.buttonPaddingMedium,
          minimumSize: Size(double.infinity, AppDimensions.buttonHeightMedium),
          side: BorderSide(
            color: AppColors.border,
            width: AppDimensions.borderWidthThin,
          ),
          shape: RoundedRectangleBorder(
            borderRadius: AppDimensions.borderRadiusM,
          ),
          textStyle: AppTypography.buttonMedium,
        ),
      ),

      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          foregroundColor: AppColors.primary,
          disabledForegroundColor: AppColors.buttonDisabledText,
          padding: AppDimensions.buttonPaddingMedium,
          textStyle: AppTypography.buttonMedium,
        ),
      ),

      iconButtonTheme: IconButtonThemeData(
        style: IconButton.styleFrom(
          foregroundColor: AppColors.iconPrimary,
          disabledForegroundColor: AppColors.iconTertiary,
          iconSize: AppDimensions.iconL,
        ),
      ),

      floatingActionButtonTheme: FloatingActionButtonThemeData(
        backgroundColor: AppColors.primary,
        foregroundColor: AppColors.white,
        elevation: AppDimensions.elevationMedium,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppDimensions.radiusL),
        ),
      ),

      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: AppColors.inputBackground,
        contentPadding: AppDimensions.inputPadding,

        border: OutlineInputBorder(
          borderRadius: AppDimensions.borderRadiusM,
          borderSide: BorderSide(
            color: AppColors.border,
            width: AppDimensions.borderWidthThin,
          ),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: AppDimensions.borderRadiusM,
          borderSide: BorderSide(
            color: AppColors.border,
            width: AppDimensions.borderWidthThin,
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: AppDimensions.borderRadiusM,
          borderSide: BorderSide(
            color: AppColors.borderFocus,
            width: AppDimensions.borderWidthMedium,
          ),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: AppDimensions.borderRadiusM,
          borderSide: BorderSide(
            color: AppColors.borderError,
            width: AppDimensions.borderWidthThin,
          ),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: AppDimensions.borderRadiusM,
          borderSide: BorderSide(
            color: AppColors.borderError,
            width: AppDimensions.borderWidthMedium,
          ),
        ),
        disabledBorder: OutlineInputBorder(
          borderRadius: AppDimensions.borderRadiusM,
          borderSide: BorderSide(
            color: AppColors.border.withValues(alpha: 0.5),
            width: AppDimensions.borderWidthThin,
          ),
        ),

        hintStyle: AppTypography.inputHint,
        labelStyle: AppTypography.inputLabel,
        floatingLabelStyle: AppTypography.inputLabel.copyWith(
          color: AppColors.primary,
        ),
        errorStyle: AppTypography.error,
        helperStyle: AppTypography.bodySmall,
        prefixIconColor: AppColors.iconSecondary,
        suffixIconColor: AppColors.iconSecondary,
      ),

      textSelectionTheme: const TextSelectionThemeData(
        cursorColor: AppColors.primary,
        selectionColor: AppColors.primaryLight,
        selectionHandleColor: AppColors.primary,
      ),

      dividerTheme: const DividerThemeData(
        color: AppColors.divider,
        thickness: AppDimensions.dividerThickness,
        space: AppDimensions.dividerThickness,
      ),

      bottomNavigationBarTheme: BottomNavigationBarThemeData(
        backgroundColor: AppColors.surface,
        selectedItemColor: AppColors.primary,
        unselectedItemColor: AppColors.iconSecondary,
        selectedIconTheme: const IconThemeData(
          color: AppColors.primary,
          size: AppDimensions.bottomNavBarIconSize,
        ),
        unselectedIconTheme: const IconThemeData(
          color: AppColors.iconSecondary,
          size: AppDimensions.bottomNavBarIconSize,
        ),
        selectedLabelStyle: AppTypography.tabActive,
        unselectedLabelStyle: AppTypography.tabInactive,
        type: BottomNavigationBarType.fixed,
        elevation: AppDimensions.elevationMedium,
      ),

      navigationRailTheme: NavigationRailThemeData(
        backgroundColor: AppColors.surface,
        selectedIconTheme: IconThemeData(
          color: AppColors.primary,
          size: AppDimensions.iconL,
        ),
        unselectedIconTheme: IconThemeData(
          color: AppColors.iconSecondary,
          size: AppDimensions.iconL,
        ),
        selectedLabelTextStyle: AppTypography.labelMedium.copyWith(
          color: AppColors.primary,
        ),
        unselectedLabelTextStyle: AppTypography.labelMedium.copyWith(
          color: AppColors.textSecondary,
        ),
        indicatorColor: AppColors.primary.withValues(alpha: 0.2),
      ),

      tabBarTheme: TabBarThemeData(
        labelColor: AppColors.primary,
        unselectedLabelColor: AppColors.textSecondary,
        labelStyle: AppTypography.tabActive,
        unselectedLabelStyle: AppTypography.tabInactive,
        indicator: const UnderlineTabIndicator(
          borderSide: BorderSide(
            color: AppColors.tabIndicator,
            width: AppDimensions.tabIndicatorHeight,
          ),
        ),
        indicatorSize: TabBarIndicatorSize.tab,
      ),

      chipTheme: ChipThemeData(
        backgroundColor: AppColors.surface,
        deleteIconColor: AppColors.iconSecondary,
        disabledColor: AppColors.buttonDisabled,
        selectedColor: AppColors.primary.withValues(alpha: 0.2),
        secondarySelectedColor: AppColors.primary.withValues(alpha: 0.3),
        labelPadding: const EdgeInsets.symmetric(horizontal: 8.0),
        padding: AppDimensions.chipPadding,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppDimensions.radiusCircular),
          side: BorderSide(
            color: AppColors.border,
            width: AppDimensions.borderWidthThin,
          ),
        ),
        labelStyle: AppTypography.labelMedium,
        secondaryLabelStyle: AppTypography.labelMedium,
        brightness: Brightness.dark,
      ),

      dialogTheme: DialogThemeData(
        backgroundColor: AppColors.surface,
        elevation: AppDimensions.elevationHigh,
        shape: RoundedRectangleBorder(
          borderRadius: AppDimensions.borderRadiusL,
        ),
        titleTextStyle: AppTypography.h3,
        contentTextStyle: AppTypography.bodyMedium,
      ),

      bottomSheetTheme: BottomSheetThemeData(
        backgroundColor: AppColors.surface,
        elevation: AppDimensions.elevationHigh,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(AppDimensions.bottomSheetRadius),
            topRight: Radius.circular(AppDimensions.bottomSheetRadius),
          ),
        ),
        modalBackgroundColor: AppColors.surface,
        modalElevation: AppDimensions.elevationHigh,
      ),

      progressIndicatorTheme: const ProgressIndicatorThemeData(
        color: AppColors.primary,
        linearTrackColor: AppColors.border,
        circularTrackColor: AppColors.border,
      ),

      sliderTheme: SliderThemeData(
        activeTrackColor: AppColors.primary,
        inactiveTrackColor: AppColors.border,
        thumbColor: AppColors.primary,
        overlayColor: AppColors.primary.withValues(alpha: 0.2),
        valueIndicatorColor: AppColors.primary,
        valueIndicatorTextStyle: AppTypography.labelSmall.copyWith(
          color: AppColors.white,
        ),
      ),

      switchTheme: SwitchThemeData(
        thumbColor: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.selected)) {
            return AppColors.white;
          }
          return AppColors.textSecondary;
        }),
        trackColor: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.selected)) {
            return AppColors.primary;
          }
          return AppColors.border;
        }),
        trackOutlineColor: WidgetStateProperty.all(Colors.transparent),
      ),

      checkboxTheme: CheckboxThemeData(
        fillColor: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.selected)) {
            return AppColors.primary;
          }
          return Colors.transparent;
        }),
        checkColor: WidgetStateProperty.all(AppColors.white),
        side: BorderSide(
          color: AppColors.border,
          width: AppDimensions.borderWidthMedium,
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppDimensions.radiusXs),
        ),
      ),

      radioTheme: RadioThemeData(
        fillColor: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.selected)) {
            return AppColors.primary;
          }
          return AppColors.border;
        }),
      ),

      listTileTheme: ListTileThemeData(
        tileColor: AppColors.surface,
        selectedTileColor: AppColors.primary.withValues(alpha: 0.1),
        iconColor: AppColors.iconSecondary,
        textColor: AppColors.textPrimary,
        titleTextStyle: AppTypography.bodyMediumMedium,
        subtitleTextStyle: AppTypography.bodySmall,
        leadingAndTrailingTextStyle: AppTypography.bodySmall,
        contentPadding: AppDimensions.listItemPadding,
        shape: RoundedRectangleBorder(
          borderRadius: AppDimensions.borderRadiusM,
        ),
      ),

      expansionTileTheme: ExpansionTileThemeData(
        backgroundColor: AppColors.surface,
        collapsedBackgroundColor: AppColors.surface,
        textColor: AppColors.textPrimary,
        collapsedTextColor: AppColors.textPrimary,
        iconColor: AppColors.iconSecondary,
        collapsedIconColor: AppColors.iconSecondary,
        shape: RoundedRectangleBorder(
          borderRadius: AppDimensions.borderRadiusM,
        ),
        collapsedShape: RoundedRectangleBorder(
          borderRadius: AppDimensions.borderRadiusM,
        ),
      ),

      drawerTheme: DrawerThemeData(
        backgroundColor: AppColors.background,
        elevation: AppDimensions.elevationHigh,
        shape: const RoundedRectangleBorder(borderRadius: BorderRadius.zero),
      ),

      tooltipTheme: TooltipThemeData(
        decoration: BoxDecoration(
          color: AppColors.surfaceElevated,
          borderRadius: AppDimensions.borderRadiusS,
        ),
        textStyle: AppTypography.bodySmall.copyWith(
          color: AppColors.textPrimary,
        ),
        padding: EdgeInsets.symmetric(
          horizontal: AppDimensions.spacingM,
          vertical: AppDimensions.spacingS,
        ),
      ),

      badgeTheme: BadgeThemeData(
        backgroundColor: AppColors.error,
        textColor: AppColors.white,
        textStyle: AppTypography.badge,
      ),

      searchBarTheme: SearchBarThemeData(
        backgroundColor: WidgetStateProperty.all(AppColors.inputBackground),
        elevation: WidgetStateProperty.all(AppDimensions.elevationNone),
        padding: WidgetStateProperty.all(AppDimensions.inputPadding),
        shape: WidgetStateProperty.all(
          RoundedRectangleBorder(
            borderRadius: AppDimensions.borderRadiusM,
            side: BorderSide(
              color: AppColors.border,
              width: AppDimensions.borderWidthThin,
            ),
          ),
        ),
        hintStyle: WidgetStateProperty.all(AppTypography.inputHint),
        textStyle: WidgetStateProperty.all(AppTypography.inputText),
      ),

      textTheme: TextTheme(
        displayLarge: AppTypography.displayLarge,
        displayMedium: AppTypography.displayMedium,
        displaySmall: AppTypography.displaySmall,
        headlineLarge: AppTypography.h1,
        headlineMedium: AppTypography.h2,
        headlineSmall: AppTypography.h3,
        titleLarge: AppTypography.h4,
        titleMedium: AppTypography.h5,
        titleSmall: AppTypography.h6,
        bodyLarge: AppTypography.bodyLarge,
        bodyMedium: AppTypography.bodyMedium,
        bodySmall: AppTypography.bodySmall,
        labelLarge: AppTypography.labelLarge,
        labelMedium: AppTypography.labelMedium,
        labelSmall: AppTypography.labelSmall,
      ),

      iconTheme: IconThemeData(
        color: AppColors.iconPrimary,
        size: AppDimensions.iconM,
      ),
      primaryIconTheme: IconThemeData(
        color: AppColors.iconActive,
        size: AppDimensions.iconM,
      ),

      platform: TargetPlatform.android,
      useMaterial3: true,
    );
  }

  static const SystemUiOverlayStyle lightStatusBar = SystemUiOverlayStyle(
    statusBarColor: Colors.transparent,
    statusBarIconBrightness: Brightness.light,
    statusBarBrightness: Brightness.dark,
    systemNavigationBarColor: AppColors.background,
    systemNavigationBarIconBrightness: Brightness.light,
  );

  static const SystemUiOverlayStyle darkStatusBar = SystemUiOverlayStyle(
    statusBarColor: Colors.transparent,
    statusBarIconBrightness: Brightness.dark,
    statusBarBrightness: Brightness.light,
    systemNavigationBarColor: AppColors.white,
    systemNavigationBarIconBrightness: Brightness.dark,
  );

  static void setLightStatusBar() {
    SystemChrome.setSystemUIOverlayStyle(lightStatusBar);
  }

  static void setDarkStatusBar() {
    SystemChrome.setSystemUIOverlayStyle(darkStatusBar);
  }

  static void setPreferredOrientations() {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
  }

  static void enableAllOrientations() {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
      DeviceOrientation.landscapeLeft,
      DeviceOrientation.landscapeRight,
    ]);
  }
}
