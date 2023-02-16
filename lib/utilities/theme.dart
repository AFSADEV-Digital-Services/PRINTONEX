import 'package:flutter/material.dart';
import 'package:printonex_final/consts/firebase/color_constants.dart';

final appTheme = ThemeData(
  primaryColor: AppColors.spaceCadet,
  scaffoldBackgroundColor: AppColors.white,
  appBarTheme: const AppBarTheme(backgroundColor: AppColors.spaceCadet),
  colorScheme: ColorScheme.fromSwatch().copyWith(secondary: AppColors.burgundy),
);
