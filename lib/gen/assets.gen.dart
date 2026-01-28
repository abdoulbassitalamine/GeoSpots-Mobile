// dart format width=180

/// GENERATED CODE - DO NOT MODIFY BY HAND
/// *****************************************************
///  FlutterGen
/// *****************************************************

// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: deprecated_member_use,directives_ordering,implicit_dynamic_list_literal,unnecessary_import

import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_svg/flutter_svg.dart' as _svg;
import 'package:vector_graphics/vector_graphics.dart' as _vg;

class $AssetsIconsGen {
  const $AssetsIconsGen();

  /// File path: assets/icons/check.svg
  SvgGenImage get check => const SvgGenImage('assets/icons/check.svg', size: Size(18.0, 13.0));

  /// File path: assets/icons/chevron_right.svg
  SvgGenImage get chevronRight => const SvgGenImage('assets/icons/chevron_right.svg', size: Size(9.0, 12.0));

  /// File path: assets/icons/clip_attachment.svg
  SvgGenImage get clipAttachment => const SvgGenImage('assets/icons/clip_attachment.svg', size: Size(24.0, 24.0));

  /// File path: assets/icons/collections.svg
  SvgGenImage get collections => const SvgGenImage('assets/icons/collections.svg', size: Size(24.0, 32.0));

  /// File path: assets/icons/france.svg
  SvgGenImage get france => const SvgGenImage('assets/icons/france.svg', size: Size(512.0, 512.0));

  /// File path: assets/icons/home.svg
  SvgGenImage get home => const SvgGenImage('assets/icons/home.svg', size: Size(28.0, 32.0));

  /// File path: assets/icons/ic_outline-arrow-back.svg
  SvgGenImage get icOutlineArrowBack => const SvgGenImage('assets/icons/ic_outline-arrow-back.svg', size: Size(24.0, 24.0));

  /// File path: assets/icons/logo-geo-spots-hr.svg
  SvgGenImage get logoGeoSpotsHr => const SvgGenImage('assets/icons/logo-geo-spots-hr.svg', size: Size(354.0, 156.0));

  /// File path: assets/icons/logo-geo-spots.svg
  SvgGenImage get logoGeoSpots => const SvgGenImage('assets/icons/logo-geo-spots.svg', size: Size(188.0, 188.0));

  /// File path: assets/icons/logo_geo_spots_verticale.svg
  SvgGenImage get logoGeoSpotsVerticale => const SvgGenImage('assets/icons/logo_geo_spots_verticale.svg', size: Size(214.0, 205.0));

  /// File path: assets/icons/map.svg
  SvgGenImage get map => const SvgGenImage('assets/icons/map.svg', size: Size(27.0, 32.0));

  /// File path: assets/icons/profile.svg
  SvgGenImage get profile => const SvgGenImage('assets/icons/profile.svg', size: Size(21.0, 32.0));

  /// List of all assets
  List<SvgGenImage> get values => [
    check,
    chevronRight,
    clipAttachment,
    collections,
    france,
    home,
    icOutlineArrowBack,
    logoGeoSpotsHr,
    logoGeoSpots,
    logoGeoSpotsVerticale,
    map,
    profile,
  ];
}

class GSIcons {
  const GSIcons._();

  static const AssetGenImage appLogo = AssetGenImage('assets/app_logo.png', size: const Size(448.0, 448.0));
  static const $AssetsIconsGen icons = $AssetsIconsGen();

  /// List of all assets
  static List<AssetGenImage> get values => [appLogo];
}

class AssetGenImage {
  const AssetGenImage(this._assetName, {this.size, this.flavors = const {}, this.animation});

  final String _assetName;

  final Size? size;
  final Set<String> flavors;
  final AssetGenImageAnimation? animation;

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

class AssetGenImageAnimation {
  const AssetGenImageAnimation({required this.isAnimation, required this.duration, required this.frames});

  final bool isAnimation;
  final Duration duration;
  final int frames;
}

class SvgGenImage {
  const SvgGenImage(this._assetName, {this.size, this.flavors = const {}}) : _isVecFormat = false;

  const SvgGenImage.vec(this._assetName, {this.size, this.flavors = const {}}) : _isVecFormat = true;

  final String _assetName;
  final Size? size;
  final Set<String> flavors;
  final bool _isVecFormat;

  _svg.SvgPicture svg({
    Key? key,
    bool matchTextDirection = false,
    AssetBundle? bundle,
    String? package,
    double? width,
    double? height,
    BoxFit fit = BoxFit.contain,
    AlignmentGeometry alignment = Alignment.center,
    bool allowDrawingOutsideViewBox = false,
    WidgetBuilder? placeholderBuilder,
    String? semanticsLabel,
    bool excludeFromSemantics = false,
    _svg.SvgTheme? theme,
    _svg.ColorMapper? colorMapper,
    ColorFilter? colorFilter,
    Clip clipBehavior = Clip.hardEdge,
    @deprecated Color? color,
    @deprecated BlendMode colorBlendMode = BlendMode.srcIn,
    @deprecated bool cacheColorFilter = false,
  }) {
    final _svg.BytesLoader loader;
    if (_isVecFormat) {
      loader = _vg.AssetBytesLoader(_assetName, assetBundle: bundle, packageName: package);
    } else {
      loader = _svg.SvgAssetLoader(_assetName, assetBundle: bundle, packageName: package, theme: theme, colorMapper: colorMapper);
    }
    return _svg.SvgPicture(
      loader,
      key: key,
      matchTextDirection: matchTextDirection,
      width: width,
      height: height,
      fit: fit,
      alignment: alignment,
      allowDrawingOutsideViewBox: allowDrawingOutsideViewBox,
      placeholderBuilder: placeholderBuilder,
      semanticsLabel: semanticsLabel,
      excludeFromSemantics: excludeFromSemantics,
      colorFilter: colorFilter ?? (color == null ? null : ColorFilter.mode(color, colorBlendMode)),
      clipBehavior: clipBehavior,
      cacheColorFilter: cacheColorFilter,
    );
  }

  String get path => _assetName;

  String get keyName => _assetName;
}
