// SPDX-FileCopyrightText: (c) 2021 Artёm IG <github.com/rtmigo>
// SPDX-License-Identifier: MIT

import 'dart:math';

import 'package:flutter/material.dart';

extension ColorExt on Color {
  MaterialColor toMaterialColor() {
    final m = <int, Color>{};

    for (int i = 0; i < 10; ++i) {
      int key;
      double opacity;
      if (i == 0) {
        key = 50;
        opacity = 0.1;
      } else {
        key = i * 100;
        opacity = (i + 1) * 0.1;
      }
      m[key] = this.withOpacity(opacity);
    }

    final int primary = 0xFF << 24 | this.red << 16 | this.green << 8 | this.blue;

    return MaterialColor(primary, m);
  }

  Color invert() {
    // https://stackoverflow.com/questions/18141976/how-to-invert-an-rgb-color-in-integer-form
    int rgb = this.value;
    int inverted = (0x00FFFFFF - (rgb | 0xFF000000)) | (rgb & 0xFF000000);
    return Color(inverted);
  }

  Color blendOverBlack(double opacity) => Color.alphaBlend(this.withOpacity(opacity), Colors.black);

  Color blendOverWhite(double opacity) => Color.alphaBlend(this.withOpacity(opacity), Colors.white);

  Color withSaturation(double s) {
    return HSLColor.fromColor(this).withSaturation(s).toColor();
  }

  Color withLightness(double lightness) {
    return HSLColor.fromColor(this).withLightness(lightness).toColor();
  }

  Color withHue(double hue) {
    while (hue < 0) {
      hue += 360;
    }
    while (hue > 360) {
      hue -= 360;
    }

    return HSLColor.fromColor(this).withHue(hue).toColor();
  }

  HSLColor toHSL() {
    return HSLColor.fromColor(this);
  }

  Color blendOver(Color background, [double? opacity]) {
    var c = this;
    if (opacity != null) {
      c = c.withOpacity(opacity);
    }
    return Color.alphaBlend(c, background);

    //return HSLColor.fromColor(this).withHue(hue).toColor();
  }

  Color lightnessFactor(double f) {
    return this.withLightness(min(1, this.toHSL().lightness * f));
  }

  Color saturationFactor(double f) {
    return this.withSaturation(min(1, this.toHSL().saturation * f));
  }

  /// String is in the format "aabbcc" or "ffaabbcc" with an optional leading "#".
  static Color fromHex(String hexString) {
    final buffer = StringBuffer();
    if (hexString.length == 6 || hexString.length == 7) buffer.write('ff');
    buffer.write(hexString.replaceFirst('#', ''));
    return Color(int.parse(buffer.toString(), radix: 16));
  }

  /// Prefixes a hash sign if [leadingHashSign] is set to `true` (default is `true`).
  String toHex({bool leadingHashSign = true}) => '${leadingHashSign ? '#' : ''}'
      '${alpha.toRadixString(16).padLeft(2, '0')}'
      '${red.toRadixString(16).padLeft(2, '0')}'
      '${green.toRadixString(16).padLeft(2, '0')}'
      '${blue.toRadixString(16).padLeft(2, '0')}';
}

MaterialColor rgbToMaterialColor(int r, int g, int b) {
  // https://medium.com/py-bits/turn-any-color-to-material-color-for-flutter-d8e8e037a837

  final m = <int, Color>{};

  for (int i = 0; i < 10; ++i) {
    int key;
    double opacity;
    if (i == 0) {
      key = 50;
      opacity = 0.1;
    } else {
      key = i * 100;
      opacity = (i + 1) * 0.1;
    }
    m[key] = Color.fromRGBO(r, g, b, opacity);
  }

  final int primary = 0xFF << 24 | r << 16 | g << 8 | b;

  return MaterialColor(primary, m);
}
