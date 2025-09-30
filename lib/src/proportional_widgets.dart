import 'package:flutter/material.dart';
import 'package:proportional_design/src/device_detector.dart';
import 'dimensions_extension.dart';

/// Container com dimensões proporcionais automáticas
class ProportionalContainer extends StatelessWidget {
  final double? width;
  final double? height;
  final Widget child;
  final EdgeInsets? padding;
  final EdgeInsets? margin;
  final Decoration? decoration;
  final AlignmentGeometry? alignment;
  final Color? color;

  const ProportionalContainer({
    Key? key,
    this.width,
    this.height,
    required this.child,
    this.padding,
    this.margin,
    this.decoration,
    this.alignment,
    this.color,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width != null ? context.getProportionalWidth(width!) : null,
      height: height != null ? context.getProportionalHeight(height!) : null,
      padding: padding != null
          ? EdgeInsets.only(
              left: context.getProportionalPadding(padding!.left),
              right: context.getProportionalPadding(padding!.right),
              top: context.getProportionalPadding(padding!.top),
              bottom: context.getProportionalPadding(padding!.bottom),
            )
          : null,
      margin: margin != null
          ? EdgeInsets.only(
              left: context.getProportionalMargin(margin!.left),
              right: context.getProportionalMargin(margin!.right),
              top: context.getProportionalMargin(margin!.top),
              bottom: context.getProportionalMargin(margin!.bottom),
            )
          : null,
      decoration: decoration,
      alignment: alignment,
      color: color,
      child: child,
    );
  }
}

/// Text com tamanho de fonte proporcional automático
class ProportionalText extends StatelessWidget {
  final String text;
  final double? fontSize;
  final TextStyle? style;
  final TextAlign? textAlign;
  final int? maxLines;
  final TextOverflow? overflow;
  final bool softWrap;

  const ProportionalText(
    this.text, {
    Key? key,
    this.fontSize,
    this.style,
    this.textAlign,
    this.maxLines,
    this.overflow,
    this.softWrap = true,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final proportionalFontSize = fontSize != null
        ? context.getProportionalFontSize(fontSize!)
        : (style?.fontSize != null
            ? context.getProportionalFontSize(style!.fontSize!)
            : null);

    return Text(
      text,
      style:
          (style ?? const TextStyle()).copyWith(fontSize: proportionalFontSize),
      textAlign: textAlign,
      maxLines: maxLines,
      overflow: overflow,
      softWrap: softWrap,
    );
  }
}

/// SizedBox com dimensões proporcionais
class ProportionalSizedBox extends StatelessWidget {
  final double? width;
  final double? height;
  final Widget? child;

  const ProportionalSizedBox({
    Key? key,
    this.width,
    this.height,
    this.child,
  }) : super(key: key);

  /// SizedBox quadrado proporcional
  const ProportionalSizedBox.square({
    Key? key,
    required double dimension,
    Widget? child,
  })  : width = dimension,
        height = dimension,
        child = child,
        super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: width != null ? context.getProportionalWidth(width!) : null,
      height: height != null ? context.getProportionalHeight(height!) : null,
      child: child,
    );
  }
}

/// Padding com valores proporcionais
class ProportionalPadding extends StatelessWidget {
  final EdgeInsets padding;
  final Widget child;

  const ProportionalPadding({
    Key? key,
    required this.padding,
    required this.child,
  }) : super(key: key);

  /// Padding proporcional em todos os lados
  ProportionalPadding.all({
    Key? key,
    required double value,
    required Widget child,
  })  : padding = EdgeInsets.all(value),
        child = child,
        super(key: key);

  /// Padding proporcional simétrico
  ProportionalPadding.symmetric({
    Key? key,
    double horizontal = 0.0,
    double vertical = 0.0,
    required Widget child,
  })  : padding = EdgeInsets.symmetric(
          horizontal: horizontal,
          vertical: vertical,
        ),
        child = child,
        super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
        left: context.getProportionalPadding(padding.left),
        right: context.getProportionalPadding(padding.right),
        top: context.getProportionalPadding(padding.top),
        bottom: context.getProportionalPadding(padding.bottom),
      ),
      child: child,
    );
  }
}

/// Icon com tamanho proporcional
class ProportionalIcon extends StatelessWidget {
  final IconData icon;
  final double? size;
  final Color? color;
  final String? semanticLabel;

  const ProportionalIcon(
    this.icon, {
    Key? key,
    this.size,
    this.color,
    this.semanticLabel,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Icon(
      icon,
      size: size != null ? context.getProportionalIconSize(size!) : null,
      color: color,
      semanticLabel: semanticLabel,
    );
  }
}

/// Layout adaptativo por tipo de dispositivo
class AdaptiveLayout extends StatelessWidget {
  final Widget phone;
  final Widget? tablet;
  final Widget? desktop;
  final Widget? foldable;

  const AdaptiveLayout({
    Key? key,
    required this.phone,
    this.tablet,
    this.desktop,
    this.foldable,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final deviceType = context.deviceType;

    switch (deviceType) {
      case DeviceType.phone:
        return phone;
      case DeviceType.tablet:
        return tablet ?? phone;
      case DeviceType.desktop:
        return desktop ?? tablet ?? phone;
      case DeviceType.foldable:
        return foldable ?? tablet ?? phone;
    }
  }
}

/// Layout que muda baseado na orientação
class OrientationAwareLayout extends StatelessWidget {
  final Widget portrait;
  final Widget? landscape;

  const OrientationAwareLayout({
    Key? key,
    required this.portrait,
    this.landscape,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return context.isLandscape && landscape != null ? landscape! : portrait;
  }
}

/// Grid responsivo que adapta número de colunas por dispositivo
class ResponsiveGrid extends StatelessWidget {
  final List<Widget> children;
  final int? phoneColumns;
  final int? tabletColumns;
  final int? desktopColumns;
  final double spacing;
  final double runSpacing;
  final double? childAspectRatio;
  final ScrollPhysics? physics;
  final bool shrinkWrap;

  const ResponsiveGrid({
    Key? key,
    required this.children,
    this.phoneColumns,
    this.tabletColumns,
    this.desktopColumns,
    this.spacing = 8.0,
    this.runSpacing = 8.0,
    this.childAspectRatio,
    this.physics,
    this.shrinkWrap = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final deviceType = context.deviceType;
    final columns = _getColumnsForDevice(deviceType);

    return GridView.builder(
      shrinkWrap: shrinkWrap,
      physics: physics,
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: columns,
        crossAxisSpacing: context.getProportionalSpacing(spacing),
        mainAxisSpacing: context.getProportionalSpacing(runSpacing),
        childAspectRatio: childAspectRatio ?? 1.0,
      ),
      itemCount: children.length,
      itemBuilder: (context, index) => children[index],
    );
  }

  int _getColumnsForDevice(DeviceType deviceType) {
    switch (deviceType) {
      case DeviceType.phone:
        return phoneColumns ?? 1;
      case DeviceType.tablet:
        return tabletColumns ?? 2;
      case DeviceType.desktop:
        return desktopColumns ?? 3;
      case DeviceType.foldable:
        return tabletColumns ?? 2;
    }
  }
}
