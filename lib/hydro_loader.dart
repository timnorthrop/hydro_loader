// lib/hydro_loader.dart
// Copyright (c) 2025 Timothy Northrop

import 'dart:math';
import 'package:flutter/material.dart';

const double offset = 1000 * pi;

/// A widget that displays a liquid wave loader. HydroLoader shows an animated liquid wave effect
/// that fills up based on the provided progress and max values. Allows customization of wave
/// properties such as speed, magnitude, period, colors, and border styles.
class HydroLoader extends StatefulWidget {
  /// The current progress value (required).
  final double progress;

  /// The maximum value (required).
  final double max;

  /// The number of waves "deep" the animation is. Default: 3.
  final int numWaves;

  /// The speed of the first wave. Note that each wave takes on a speed proportional to this given
  /// speed so that the animation loops seamlessly. Default: 100.0.
  final double waveSpeed;

  /// The magnitude (height) of the first wave. Default: 50.0.
  final double waveMagnitude;

  /// The period (wavelength) of the first wave. Default: 100.0.
  final double wavePeriod;

  /// The vertical offset for each consecutive wave. Default: 20.0.
  final double waveHeightOffset;

  /// The vertical offset of the wave magnitude for each consecutive wave. Default: 8.0.
  final double waveMagnitudeOffset;

  /// The offset of the wave period/wavelength for each consecutive wave. Default: 20.0.
  final double wavePeriodOffset;

  /// The opacity of the entire animation (0-255). Default: 240.
  final int opacity;

  /// The direction the fill grows toward. Accepted values: up, down, left, right.
  final String fillDirection;

  /// The background color of the loader. Default: transparent.
  final Color backgroundColor;

  /// The base color of the waves. Default: transparent, then is switched to the theme's primary
  /// color in build().
  final Color waveColor;

  /// The amount to tint each consecutive wave's color. Default: 25.0.
  final double waveColorTintOffset;

  /// The color of the border. Default: transparent.
  final Color borderColor;

  /// The width of the border. Default: 2.0.
  final double borderWidth;

  /// The border radius of the loader. Default: 32.0.
  final double borderRadius;

  const HydroLoader({
    super.key,
    required this.progress,
    required this.max,
    this.numWaves = 3,
    this.waveSpeed = 100.0,
    this.waveMagnitude = 50.0,
    this.wavePeriod = 100.0,
    this.waveHeightOffset = 20.0,
    this.waveMagnitudeOffset = 8.0,
    this.wavePeriodOffset = 20.0,
    this.opacity = 240,
    this.fillDirection = 'right',
    this.backgroundColor = Colors.transparent,
    this.waveColor = Colors.transparent,
    this.waveColorTintOffset = 25.0,
    this.borderColor = Colors.transparent,
    this.borderWidth = 2.0,
    this.borderRadius = 32.0,
  });

  void _validateInputs() {
    if (max <= 0) {
      throw ArgumentError('Max must be greater than 0.');
    }
    if (progress < 0 || progress > max) {
      throw ArgumentError('Progress must be between 0 and max, inclusive.');
    }
    if (numWaves < 1 || numWaves > 10) {
      throw ArgumentError('numWaves must be between 1 and 10, inclusive.');
    }
    if (waveSpeed < 0) {
      throw ArgumentError('waveSpeed must be non-negative.');
    }
    if (waveMagnitude < 0) {
      throw ArgumentError('waveMagnitude must be non-negative.');
    }
    if (wavePeriod < 10 || wavePeriod > 200) {
      throw ArgumentError('wavePeriod must be between 10 and 200, inclusive.');
    }
    if (waveHeightOffset < -200 || waveHeightOffset > 200) {
      throw ArgumentError(
        'waveHeightOffset must be between -200 and 200, inclusive.',
      );
    }
    if (waveMagnitudeOffset < 0) {
      throw ArgumentError('waveMagnitudeOffset must be non-negative.');
    }
    if (wavePeriodOffset < 0) {
      throw ArgumentError('wavePeriodOffset must be non-negative.');
    }
    if (opacity < 0 || opacity > 255) {
      throw ArgumentError('opacity must be between 0 and 255, inclusive.');
    }
    if (waveColorTintOffset < 0 || waveColorTintOffset > 80) {
      throw ArgumentError(
        'waveColorTintOffset must be between 0 and 80, inclusive.',
      );
    }
    const allowedDirections = {'up', 'down', 'left', 'right'};
    if (!allowedDirections.contains(fillDirection)) {
      throw ArgumentError(
        'fillDirection must be one of: up, down, left, right.',
      );
    }
  }

  @override
  State<HydroLoader> createState() => _HydroLoaderState();
}

class _HydroLoaderState extends State<HydroLoader>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;
  double _wavePhase = 0.0;
  // initialize to a large phase offset to avoid initial alignment of waves
  double _phaseOffset = offset;
  double _previousAnimationValue = 0.0;

  @override
  void initState() {
    super.initState();

    widget._validateInputs();

    _controller = AnimationController(
      vsync: this,
      duration: Duration(
        milliseconds: max(
          1,
          (widget.wavePeriod * 1000 / widget.waveSpeed).round(),
        ),
      ),
    )..repeat();

    _animation = Tween<double>(
      begin: 0,
      end: widget.waveSpeed,
    ).animate(_controller);

    _controller.addListener(() {
      final currentValue = _animation.value;

      if (currentValue < _previousAnimationValue) {
        _phaseOffset += widget.waveSpeed;
      }

      _previousAnimationValue = currentValue;

      setState(() {
        _wavePhase = (currentValue + _phaseOffset) * 2 * pi;
      });
    });
  }

  @override
  void didUpdateWidget(covariant HydroLoader oldWidget) {
    super.didUpdateWidget(oldWidget);

    if (oldWidget.waveSpeed != widget.waveSpeed ||
        oldWidget.wavePeriod != widget.wavePeriod) {
      final newDuration = Duration(
        milliseconds: (widget.wavePeriod * 1000 / widget.waveSpeed).round(),
      );

      _controller
        ..duration = newDuration
        ..repeat();

      _animation = Tween<double>(
        begin: 0,
        end: widget.waveSpeed,
      ).animate(_controller);

      // initialize to a large phase offset to avoid initial alignment of waves
      _phaseOffset = offset;
      _previousAnimationValue = _animation.value;

      setState(() {
        _wavePhase = _animation.value * 2 * pi;
      });
    }
  }

  @override
  void dispose() {
    _controller.stop();
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    // default to theme's primary color if transparent/not set
    final waveColorLocal = widget.waveColor == Colors.transparent
        ? theme.colorScheme.onPrimaryContainer
        : widget.waveColor;

    final backgroundColorLocal = widget.backgroundColor == Colors.transparent
        ? theme.colorScheme.primaryContainer
        : widget.backgroundColor;

    final borderRadius = BorderRadius.circular(widget.borderRadius);

    return IgnorePointer(
      child: Container(
        clipBehavior: Clip.antiAlias,
        decoration: BoxDecoration(
          borderRadius: borderRadius,
          border: Border.all(
            color: widget.borderColor,
            width: widget.borderWidth,
          ),
        ),
        child: CustomPaint(
          painter: LiquidWavePainter(
            progress: widget.progress,
            max: widget.max,
            numWaves: widget.numWaves,
            waveSpeed: widget.waveSpeed,
            waveMagnitude: widget.waveMagnitude,
            wavePeriod: widget.wavePeriod,
            waveHeightOffset: widget.waveHeightOffset,
            waveMagnitudeOffset: widget.waveMagnitudeOffset,
            wavePeriodOffset: widget.wavePeriodOffset,
            opacity: widget.opacity,
            fillDirection: widget.fillDirection,
            backgroundColor: backgroundColorLocal,
            waveColor: waveColorLocal,
            waveColorTintOffset: widget.waveColorTintOffset,
            wavePhase: _wavePhase,
          ),
          child: const SizedBox.expand(),
        ),
      ),
    );
  }
}

class LiquidWavePainter extends CustomPainter {
  final double progress;
  final double max;
  final int numWaves;
  final double waveSpeed;
  final double waveMagnitude;
  final double wavePeriod;
  final double waveHeightOffset;
  final double waveMagnitudeOffset;
  final double wavePeriodOffset;
  final int opacity;
  final String fillDirection;
  final Color backgroundColor;
  final Color waveColor;
  final double waveColorTintOffset;
  final double wavePhase;

  LiquidWavePainter({
    required this.progress,
    required this.max,
    required this.numWaves,
    required this.waveSpeed,
    required this.waveMagnitude,
    required this.wavePeriod,
    required this.waveHeightOffset,
    required this.waveMagnitudeOffset,
    required this.wavePeriodOffset,
    required this.opacity,
    required this.fillDirection,
    required this.backgroundColor,
    required this.waveColor,
    required this.waveColorTintOffset,
    required this.wavePhase,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final backgroundPaint = Paint()..color = backgroundColor;

    canvas.drawRect(
      Rect.fromLTWH(0, 0, size.width, size.height),
      backgroundPaint,
    );

    switch (fillDirection) {
      case 'down':
        _paint(canvas, size, axisIsHorizontal: true, invert: false);
        break;
      case 'left':
        _paint(canvas, size, axisIsHorizontal: false, invert: true);
        break;
      case 'right':
        _paint(canvas, size, axisIsHorizontal: false, invert: false);
        break;
      case 'up':
      default:
        _paint(canvas, size, axisIsHorizontal: true, invert: true);
        break;
    }
  }

  @override
  bool shouldRepaint(LiquidWavePainter oldDelegate) {
    return oldDelegate.progress != progress ||
        oldDelegate.max != max ||
        oldDelegate.numWaves != numWaves ||
        oldDelegate.waveMagnitude != waveMagnitude ||
        oldDelegate.wavePeriod != wavePeriod ||
        oldDelegate.waveHeightOffset != waveHeightOffset ||
        oldDelegate.waveMagnitudeOffset != waveMagnitudeOffset ||
        oldDelegate.wavePeriodOffset != wavePeriodOffset ||
        oldDelegate.opacity != opacity ||
        oldDelegate.fillDirection != fillDirection ||
        oldDelegate.backgroundColor != backgroundColor ||
        oldDelegate.waveColor != waveColor ||
        oldDelegate.waveColorTintOffset != waveColorTintOffset ||
        oldDelegate.wavePhase != wavePhase;
  }

  double _phaseForWave(double speedFactor) {
    if (!wavePhase.isFinite) {
      return 0.0;
    }

    return wavePhase * speedFactor;
  }

  Paint _paintForWave(int waveIndex) {
    final baseHsl = HSLColor.fromColor(waveColor);
    final tinted = baseHsl
        .withLightness(
          (baseHsl.lightness + (waveIndex * waveColorTintOffset / 255)).clamp(
            0.0,
            1.0,
          ),
        )
        .toColor();

    return Paint()..color = tinted.withAlpha(opacity);
  }

  double _effectiveWavePeriod(int waveIndex) {
    final value = wavePeriod - waveIndex * wavePeriodOffset;
    return value.abs() < 1 ? (value.isNegative ? -1 : 1) : value;
  }

  double _effectiveWaveMagnitude(int waveIndex) {
    final value = waveMagnitude - waveIndex * waveMagnitudeOffset;
    return value < 0 ? 0.0 : value;
  }

  void _paint(
    Canvas canvas,
    Size size, {
    required bool axisIsHorizontal,
    required bool invert,
  }) {
    final fillRatio = (progress / max).clamp(0.0, 1.0);

    if (axisIsHorizontal) {
      final baseLevel = invert
          ? size.height * (1 - fillRatio)
          : size.height * fillRatio;

      for (int i = numWaves - 1; i >= 0; i--) {
        final path = Path()..moveTo(0, invert ? size.height : 0);

        final speedFactor = 1 - (i / numWaves);
        final effectivePhase = _phaseForWave(speedFactor);
        final effectiveWavePeriod = _effectiveWavePeriod(i);
        final effectiveMagnitude = _effectiveWaveMagnitude(i);
        final effectiveWaveHeightOffset = invert
            ? waveHeightOffset
            : -waveHeightOffset;

        for (double x = 0; x <= size.width; x += 1) {
          final waveY =
              baseLevel +
              cos((x - effectivePhase) / effectiveWavePeriod) *
                  effectiveMagnitude +
              effectiveWaveHeightOffset * i;

          path.lineTo(x, waveY);
        }

        if (invert) {
          path
            ..lineTo(size.width, size.height)
            ..lineTo(0, size.height);
        } else {
          path
            ..lineTo(size.width, 0)
            ..lineTo(0, 0);
        }

        path.close();
        canvas.drawPath(path, _paintForWave(i));
      }
    } else {
      final baseLevel = invert
          ? size.width * (1 - fillRatio)
          : size.width * fillRatio;

      for (int i = numWaves - 1; i >= 0; i--) {
        final path = Path()..moveTo(invert ? size.width : 0, 0);

        final speedFactor = 1 - (i / numWaves);
        final effectivePhase = _phaseForWave(speedFactor);
        final effectiveWavePeriod = _effectiveWavePeriod(i);
        final effectiveMagnitude = _effectiveWaveMagnitude(i);
        final effectiveWaveHeightOffset = invert
            ? waveHeightOffset
            : -waveHeightOffset;

        for (double y = 0; y <= size.height; y += 1) {
          final waveX =
              baseLevel +
              cos((y - effectivePhase) / effectiveWavePeriod) *
                  effectiveMagnitude -
              i * effectiveWaveHeightOffset;

          path.lineTo(waveX, y);
        }

        if (invert) {
          path
            ..lineTo(size.width, size.height)
            ..lineTo(size.width, 0);
        } else {
          path
            ..lineTo(0, size.height)
            ..lineTo(0, 0);
        }

        path.close();
        canvas.drawPath(path, _paintForWave(i));
      }
    }
  }
}
