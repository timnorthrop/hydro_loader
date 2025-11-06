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
