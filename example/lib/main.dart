import 'package:flutter/material.dart';
import 'package:hydro_loader/hydro_loader.dart';

void main() => runApp(const DemoApp());

class DemoApp extends StatefulWidget {
  const DemoApp({super.key});
  @override
  State<DemoApp> createState() => _DemoAppState();
}

class _DemoAppState extends State<DemoApp> {
  double progress = 50.0;
  final double max = 100.0;
  int numWaves = 3;
  double waveSpeed = 100.0;
  double waveMagnitude = 50.0;
  double wavePeriod = 100.0;
  double waveHeightOffset = 20.0;
  double waveMagnitudeOffset = 8.0;
  double wavePeriodOffset = 2.0;
  int opacity = 240;
  String fillDirection = 'right';
  Color backgroundColor = Colors.transparent;
  Color waveColor = Colors.transparent;
  double waveColorTintOffset = 25.0;
  Color borderColor = Colors.transparent;
  double borderWidth = 2.0;
  double borderRadius = 32.0;
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(title: const Text('HydroLoader demo')),
        backgroundColor: Theme.of(context).colorScheme.secondaryContainer,
        body: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Center(
                  child: SizedBox(
                    width: 800,
                    height: 300,
                    child: HydroLoader(
                      progress: progress,
                      max: max,
                      numWaves: numWaves,
                      waveSpeed: waveSpeed,
                      waveMagnitude: waveMagnitude,
                      wavePeriod: wavePeriod,
                      waveHeightOffset: waveHeightOffset,
                      waveMagnitudeOffset: waveMagnitudeOffset,
                      wavePeriodOffset: wavePeriodOffset,
                      opacity: opacity,
                      fillDirection: fillDirection,
                      backgroundColor: backgroundColor,
                      waveColor: waveColor,
                      waveColorTintOffset: waveColorTintOffset,
                      borderColor: borderColor,
                      borderWidth: borderWidth,
                      borderRadius: borderRadius,
                    ),
                  ),
                ),
                const SizedBox(height: 8),
                _buildDirectionSelector(context),
                const SizedBox(height: 8),
                _buildSlider(
                  label: 'progress',
                  value: progress,
                  min: 0,
                  max: max,
                  onChanged: (v) => setState(() => progress = v),
                  valueFormatter: (v) =>
                      '${(v / max * 100).toStringAsFixed(1)}%',
                ),
                _buildSlider(
                  label: 'numWaves',
                  value: numWaves.toDouble(),
                  min: 1,
                  max: 10,
                  divisions: 9,
                  onChanged: (v) => setState(() => numWaves = v.round()),
                  valueFormatter: (v) => v.toStringAsFixed(0),
                ),
                _buildSlider(
                  label: 'waveSpeed',
                  value: waveSpeed,
                  min: 10,
                  max: 200,
                  onChanged: (v) => setState(() => waveSpeed = v),
                  valueFormatter: (v) => v.toStringAsFixed(1),
                ),
                _buildSlider(
                  label: 'waveMagnitude',
                  value: waveMagnitude,
                  min: 0,
                  max: 150,
                  onChanged: (v) => setState(() => waveMagnitude = v),
                ),
                _buildSlider(
                  label: 'wavePeriod',
                  value: wavePeriod,
                  min: 10,
                  max: 200,
                  onChanged: (v) => setState(() => wavePeriod = v),
                ),
                _buildSlider(
                  label: 'waveHeightOffset',
                  value: waveHeightOffset,
                  min: -200,
                  max: 200,
                  onChanged: (v) => setState(() => waveHeightOffset = v),
                  valueFormatter: (v) => v.toStringAsFixed(2),
                ),
                _buildSlider(
                  label: 'waveMagnitudeOffset',
                  value: waveMagnitudeOffset,
                  min: 0,
                  max: 40,
                  onChanged: (v) => setState(() => waveMagnitudeOffset = v),
                ),
                _buildSlider(
                  label: 'wavePeriodOffset',
                  value: wavePeriodOffset,
                  min: 0,
                  max: 50,
                  onChanged: (v) => setState(() => wavePeriodOffset = v),
                ),
                _buildSlider(
                  label: 'waveColorTintOffset',
                  value: waveColorTintOffset,
                  min: 0,
                  max: 80,
                  onChanged: (v) => setState(() => waveColorTintOffset = v),
                ),
                _buildSlider(
                  label: 'opacity',
                  value: opacity.toDouble(),
                  min: 0,
                  max: 255,
                  divisions: 255,
                  onChanged: (v) => setState(() => opacity = v.round()),
                  valueFormatter: (v) => v.toStringAsFixed(0),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildSlider({
    required String label,
    required double value,
    required double min,
    required double max,
    required ValueChanged<double> onChanged,
    int? divisions,
    String Function(double)? valueFormatter,
  }) {
    final textValue = valueFormatter?.call(value) ?? value.toStringAsFixed(1);

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '$label: $textValue',
            style: TextStyle(
              color: Theme.of(context).colorScheme.onPrimaryContainer,
            ),
          ),
          Slider(
            value: value,
            onChanged: onChanged,
            min: min,
            max: max,
            divisions: divisions,
          ),
        ],
      ),
    );
  }

  Widget _buildDirectionSelector(BuildContext context) {
    final onPrimary = Theme.of(context).colorScheme.onPrimaryContainer;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Scroll to see all options if on a smaller screen\n\nfillDirection: ${fillDirection.toUpperCase()}',
          style: TextStyle(color: onPrimary),
        ),
        DropdownButton<String>(
          value: fillDirection,
          dropdownColor: Theme.of(context).colorScheme.secondaryContainer,
          onChanged: (value) {
            if (value == null) return;
            setState(() => fillDirection = value);
          },
          items: const [
            DropdownMenuItem(value: 'up', child: Text('Up')),
            DropdownMenuItem(value: 'down', child: Text('Down')),
            DropdownMenuItem(value: 'left', child: Text('Left')),
            DropdownMenuItem(value: 'right', child: Text('Right')),
          ],
        ),
      ],
    );
  }
}
