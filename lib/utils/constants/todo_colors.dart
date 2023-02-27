import 'package:flutter/material.dart';

@immutable
class TodoColors extends ThemeExtension<TodoColors> {
  const TodoColors({
    required this.supportSeparator,
    required this.supportOverlay,
    required this.labelPrimary,
    required this.labelSecondary,
    required this.labelTertiary,
    required this.labelDisable,
    required this.colorRed,
    required this.colorGreen,
    required this.colorBlue,
    required this.colorGray,
    required this.colorGrayLight,
    required this.colorWhite,
    required this.backPrimary,
    required this.backSecondary,
    required this.backElevated,
    required this.remoteColor
  });

  final Color? supportSeparator;
  final Color? supportOverlay;
  final Color? labelPrimary;
  final Color? labelSecondary;
  final Color? labelTertiary;
  final Color? labelDisable;
  final Color? colorRed;
  final Color? colorGreen;
  final Color? colorBlue;
  final Color? colorGray;
  final Color? colorGrayLight;
  final Color? colorWhite;
  final Color? backPrimary;
  final Color? backSecondary;
  final Color? backElevated;
  final Color? remoteColor;

  @override
  TodoColors copyWith({
    Color? supportSeparator,
    Color? supportOverlay,
    Color? labelPrimary,
    Color? labelSecondary,
    Color? labelTertiary,
    Color? labelDisable,
    Color? colorRed,
    Color? colorGreen,
    Color? colorBlue,
    Color? colorGray,
    Color? colorGrayLight,
    Color? colorWhite,
    Color? backPrimary,
    Color? backSecondary,
    Color? backElevated,
    Color? remoteColor
  }) => TodoColors(
      supportSeparator: supportSeparator ?? this.supportSeparator,
      supportOverlay: supportOverlay ?? this.supportOverlay,
      labelPrimary: labelPrimary ?? this.labelPrimary,
      labelSecondary: labelSecondary ?? this.labelSecondary,
      labelTertiary: labelTertiary ?? this.labelTertiary,
      labelDisable: labelDisable ?? this.labelDisable,
      colorRed: colorRed ?? this.colorRed,
      colorGreen: colorGreen ?? this.colorGreen,
      colorBlue: colorBlue ?? this.colorBlue,
      colorGray: colorGray ?? this.colorGray,
      colorGrayLight: colorGrayLight ?? this.colorGrayLight,
      colorWhite: colorWhite ?? this.colorWhite,
      backPrimary: backPrimary ?? this.backPrimary,
      backSecondary: backSecondary ?? this.backSecondary,
      backElevated: backElevated ?? this.backElevated,
      remoteColor: remoteColor ?? this.remoteColor
  );

  @override
  TodoColors lerp(ThemeExtension<TodoColors>? other, double t) {
    if (other is! TodoColors) {
      return this;
    }
    return TodoColors(
      supportSeparator: Color.lerp(supportSeparator, other.supportSeparator, t),
      supportOverlay: Color.lerp(supportOverlay, other.supportOverlay, t),
      labelPrimary: Color.lerp(labelPrimary, other.labelPrimary, t),
      labelSecondary: Color.lerp(labelSecondary, other.labelSecondary, t),
      labelTertiary: Color.lerp(labelTertiary, other.labelTertiary, t),
      labelDisable: Color.lerp(labelDisable, other.labelDisable, t),
      colorRed: Color.lerp(colorRed, other.colorRed, t),
      colorGreen: Color.lerp(colorGreen, other.colorGreen, t),
      colorBlue: Color.lerp(colorBlue, other.colorBlue, t),
      colorGray: Color.lerp(colorGray, other.colorGray, t),
      colorGrayLight: Color.lerp(colorGrayLight, other.colorGrayLight, t),
      colorWhite: Color.lerp(colorWhite, other.colorWhite, t),
      backPrimary: Color.lerp(backPrimary, other.backPrimary, t),
      backSecondary: Color.lerp(backSecondary, other.backSecondary, t),
      backElevated: Color.lerp(backElevated, other.backElevated, t),
      remoteColor: Color.lerp(remoteColor, other.remoteColor, t),
    );
  }
}