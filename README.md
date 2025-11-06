<!--
This README describes the package. If you publish this package to pub.dev,
this README's contents appear on the landing page for your package.

For information about how to write a good package README, see the guide for
[writing package pages](https://dart.dev/tools/pub/writing-package-pages).

For general information about developing packages, see the Dart guide for
[creating packages](https://dart.dev/guides/libraries/create-packages)
and the Flutter guide for
[developing packages and plugins](https://flutter.dev/to/develop-packages).
-->

A Flutter plugin that gives the user access to HydroLoader, a highly customizable animated liquidwave loader widget.

## Features

See the widget in action here:

![hydro_loader gif](https://timnorthrop.com/images/switchboard/hydroloader/hydroloader.gif)

## Getting started

First, run the command:
```sh
$ flutter pub add hydro_loader
```

Then, you can import and use HydroLoader with the following statement:

```dart
import 'package:hydro_loader/hydro_loader.dart';
```

## Usage

An example application can be found in the GitHub repository https://github.com/timnorthrop/hydro_loader_demo.

Example usage can be found below (with the default values, exept for progress and max which must always be provided).

```dart
HydroLoader(
  progress: 0.5,
  max: 1.0,
  numWaves: 3, // optional
  waveSpeed: 100.0, // optional
  waveMagnitude: 50.0, // optional
  wavePeriod: 100.0, // optional
  waveHeightOffset: 20.0, // optional
  waveMagnitudeOffset: 8.0, // optional
  wavePeriodOffset: 20.0, // optional
  opacity: 240, // optional
  fillDirection: 'right', // optional
  backgroundColor: theme.colorScheme.primaryContainer, // optional
  waveColor: theme.colorSchem.onPrimaryContainer, // optional
  waveColorTintOffset: 25.0, // optional
  borderColor: Colors.transparent, // optional
  borderWidth: 2.0, // optional
  borderRadius: 32.0, // optional
),
```

| argument | description |
|----------|-------------|
| progress | The current progress value of the loader. Will typically be controlled by a state. |
| max | The maximum value of the loader. |
| numWaves | The number of waves "deep" the animation is. Default: 3. |
| waveSpeed | The speed of the first wave. Note that each wave takes on a speed proportional to this given speed so that the animation loops seamlessly. Default: 100.0. |
| waveMagnitude | The magnitude (height) of the first wave. Default: 50.0. |
| wavePeriod | The period (wavelength) of the first wave. Default: 100.0. |
| waveHeightOffset | The vertical offset for each consecutive wave. Default: 20.0. |
| waveMagnitudeOffset | The vertical offset of the wave magnitude for each consecutive wave. Default: 8.0. |
| wavePeriodOffset | The offset of the wave period/wavelength for each consecutive wave. Default: 20.0. |
| opacity | The opacity of the entire animation (0-255). Default: 240. |
| fillDirection | The direction the fill grows toward. Accepted values: up, down, left, right. |
| backgroundColor | The background color of the loader. Default: transparent, then is switched to the theme's color sheme's "primaryContainer" color. |
| waveColor | The base color of the waves. Default: transparent, then is switched to the theme's primary color in build(). |
| waveColorTintOffset | The amount to tint each consecutive wave's color. Default: 25.0. |
| borderColor | The color of the border. Default: transparent. |
| borderWidth | The width of the border. Default: 2.0. |
| borderRadius | The border radius of the loader. Default: 32.0. |

## Additional information

Contribute at https://github.com/timnorthrop/hydro_loader.
