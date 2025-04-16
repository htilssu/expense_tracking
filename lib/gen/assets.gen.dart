/// GENERATED CODE - DO NOT MODIFY BY HAND
/// *****************************************************
///  FlutterGen
/// *****************************************************

// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: directives_ordering,unnecessary_import,implicit_dynamic_list_literal,deprecated_member_use

import 'package:flutter/widgets.dart';

class $AssetsImagesGen {
  const $AssetsImagesGen();

  /// File path: assets/images/Logo.svg
  String get logo => 'assets/images/Logo.svg';

  /// File path: assets/images/ellipse_3.svg
  String get ellipse3 => 'assets/images/ellipse_3.svg';

  /// File path: assets/images/facebook.svg
  String get facebook => 'assets/images/facebook.svg';

  /// File path: assets/images/google.svg
  String get google => 'assets/images/google.svg';

  /// File path: assets/images/hold_money.svg
  String get holdMoney => 'assets/images/hold_money.svg';

  /// File path: assets/images/money_pig.png
  AssetGenImage get moneyPig =>
      const AssetGenImage('assets/images/money_pig.png');

  /// File path: assets/images/money_pig_small.png
  AssetGenImage get moneyPigSmall =>
      const AssetGenImage('assets/images/money_pig_small.png');

  /// File path: assets/images/pig_colorful.png
  AssetGenImage get pigColorful =>
      const AssetGenImage('assets/images/pig_colorful.png');

  /// List of all assets
  List<dynamic> get values => [
    logo,
    ellipse3,
    facebook,
    google,
    holdMoney,
    moneyPig,
    moneyPigSmall,
    pigColorful,
  ];
}

class Assets {
  const Assets._();

  static const $AssetsImagesGen images = $AssetsImagesGen();
}

class AssetGenImage {
  const AssetGenImage(this._assetName, {this.size, this.flavors = const {}});

  final String _assetName;

  final Size? size;
  final Set<String> flavors;

  Image image({
    Key? key,
    AssetBundle? bundle,
    ImageFrameBuilder? frameBuilder,
    ImageErrorWidgetBuilder? errorBuilder,
    String? semanticLabel,
    bool excludeFromSemantics = false,
    double? scale,
    double? width,
    double? height,
    Color? color,
    Animation<double>? opacity,
    BlendMode? colorBlendMode,
    BoxFit? fit,
    AlignmentGeometry alignment = Alignment.center,
    ImageRepeat repeat = ImageRepeat.noRepeat,
    Rect? centerSlice,
    bool matchTextDirection = false,
    bool gaplessPlayback = true,
    bool isAntiAlias = false,
    String? package,
    FilterQuality filterQuality = FilterQuality.medium,
    int? cacheWidth,
    int? cacheHeight,
  }) {
    return Image.asset(
      _assetName,
      key: key,
      bundle: bundle,
      frameBuilder: frameBuilder,
      errorBuilder: errorBuilder,
      semanticLabel: semanticLabel,
      excludeFromSemantics: excludeFromSemantics,
      scale: scale,
      width: width,
      height: height,
      color: color,
      opacity: opacity,
      colorBlendMode: colorBlendMode,
      fit: fit,
      alignment: alignment,
      repeat: repeat,
      centerSlice: centerSlice,
      matchTextDirection: matchTextDirection,
      gaplessPlayback: gaplessPlayback,
      isAntiAlias: isAntiAlias,
      package: package,
      filterQuality: filterQuality,
      cacheWidth: cacheWidth,
      cacheHeight: cacheHeight,
    );
  }

  ImageProvider provider({AssetBundle? bundle, String? package}) {
    return AssetImage(_assetName, bundle: bundle, package: package);
  }

  String get path => _assetName;

  String get keyName => _assetName;
}
