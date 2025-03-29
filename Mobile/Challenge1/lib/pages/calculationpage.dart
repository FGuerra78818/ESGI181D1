import 'package:decimal/decimal.dart';
import 'package:flutter/material.dart';
import 'package:challenge1/partials/nav_bar.dart';
import 'package:challenge1/partials/app_bar.dart';
import 'package:flutter/services.dart';


import 'package:flutter/material.dart';
import 'package:pair/pair.dart';
import 'package:provider/provider.dart';

import '../services/optionState.dart';  // Make sure to import the provider package

class CalculationPage extends StatefulWidget {
  const CalculationPage({super.key});

  @override
  State<CalculationPage> createState() => _HomePageState();
}

class _HomePageState extends State<CalculationPage> {
  // Placeholder for the final calculated vat volume result.
  String vatVolumeResult = "0";
  double filledHeight = 10.0;
  final TextEditingController heightController = TextEditingController();
  bool showMore = false; // Flag to control the visibility of the "Show More" section
  double sliderMax = 0.0;

  @override
  void initState() {
    super.initState();
    // Retrieve the final vat volume result on page load.
    vatVolumeResult = calculateFinalResult();
    sliderMax = getSliderMax();
  }

  double getSliderMax(){
    for (var part in Provider.of<OptionsState>(context, listen: false).conf.partials){
        if (part.key == "Altura Total"){
          print(part.value);
          return part.value.toDouble();
        }
    }
    return 100.0;
  }

  // Placeholder function to calculate the final vat volume result.
  String calculateFinalResult() {
    Decimal res = Provider.of<OptionsState>(context, listen: false).calculateVolumeVal();
    print(res);
    return res.round().toString();
  }

  // Placeholder function for partial calculations based on height.
  void calculatePartialResults(double height) {
    print('Calculating partial results for height: $height');
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final partials = Provider.of<OptionsState>(context, listen: false).conf.partials;

    return Scaffold(
      backgroundColor: colorScheme.surface,
      appBar: buildAppBar(context),
      bottomNavigationBar: const NavBar(currentIndex: 2),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Page Title
              Text(
                'Calculo do Volume da Cuba',
                style: Theme.of(context)
                    .textTheme
                    .headlineSmall
                    ?.copyWith(color: colorScheme.onSurface),
              ),
              const SizedBox(height: 20),

              // Display final vat volume result using theme colors.
              Container(
                padding: const EdgeInsets.all(16.0),
                decoration: BoxDecoration(
                  color: colorScheme.primary,
                  borderRadius: BorderRadius.circular(8.0),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.3),
                      blurRadius: 5,
                      offset: const Offset(0, 3),
                    ),
                  ],
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Volume final:',
                      style: Theme.of(context)
                          .textTheme
                          .titleMedium
                          ?.copyWith(color: colorScheme.onPrimary),
                    ),
                    Text(
                      '$vatVolumeResult',
                      style: Theme.of(context)
                          .textTheme
                          .titleMedium
                          ?.copyWith(
                          fontWeight: FontWeight.bold,
                          color: colorScheme.onPrimary),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),

              // Show More Button
              ElevatedButton(
                onPressed: () {
                  setState(() {
                    showMore = !showMore;  // Toggle the visibility of the list
                  });
                },
                child: Text(showMore ? 'Mostrar Menos' : 'Mostrar Mais'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: colorScheme.secondary,
                  foregroundColor: colorScheme.onPrimary,
                ),
              ),

              if (showMore) ...[
                // Display the partials list
                const SizedBox(height: 10),
                Container(
                  padding: const EdgeInsets.all(16.0),
                  decoration: BoxDecoration(
                    color: colorScheme.secondary.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Volume das Partes:',
                        style: Theme.of(context)
                            .textTheme
                            .titleMedium
                            ?.copyWith(color: colorScheme.onSurface),
                      ),
                      const SizedBox(height: 10),
                      for (Pair partial in partials)
                        Text(
                          '${partial.key}: ${partial.value.round()}',
                          style: TextStyle(color: colorScheme.onSurface),
                        ),
                    ],
                  ),
                ),
              ],

              const SizedBox(height: 20),

              // Slider & Input Field
              Text(
                'Altura Vinho (m)',
                style: Theme.of(context).textTheme.titleMedium,
              ),
              const SizedBox(height: 10),

              Row(
                children: [
                  // Slider
                  Expanded(
                    child: SliderTheme(
                      data: SliderTheme.of(context).copyWith(
                        activeTrackColor: colorScheme.primary,
                        inactiveTrackColor: colorScheme.secondary,
                        thumbColor: colorScheme.tertiary,
                        overlayColor: colorScheme.tertiary.withOpacity(0.3),
                        trackHeight: 6.0,
                        thumbShape: const RoundSliderThumbShape(enabledThumbRadius: 10.0),
                        overlayShape: const RoundSliderOverlayShape(overlayRadius: 20.0),
                      ),
                      child: Slider(
                        value: filledHeight,
                        min: 0,
                        max: sliderMax,
                        divisions: 100,
                        label: filledHeight.toStringAsFixed(2),
                        onChanged: (newHeight) {
                          setState(() {
                            filledHeight = newHeight;
                            heightController.text = newHeight.toStringAsFixed(2);
                          });
                        },
                      ),
                    ),
                  ),
                  const SizedBox(width: 10),

                  // Text Field for manual input
                  SizedBox(
                    width: 80,
                    child: TextField(
                      controller: heightController,
                      keyboardType: const TextInputType.numberWithOptions(decimal: true),
                      decoration: InputDecoration(
                        border: OutlineInputBorder(),
                        hintText: "0.0",
                      ),
                      onChanged: (text) {
                        try {
                          double parsedHeight = double.parse(text);
                          if (parsedHeight >= 0 && parsedHeight <= sliderMax) {
                            setState(() {
                              filledHeight = parsedHeight;
                            });
                          }
                        } catch (e) {
                          // Handle invalid input
                        }
                      },
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 20),

              // Calculate Button
              ElevatedButton(
                onPressed: () {
                  calculatePartialResults(filledHeight);
                },
                child: const Text('Calcular Volume Parcial'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: colorScheme.secondary,
                  foregroundColor: colorScheme.onPrimary,
                ),
              ),

              const SizedBox(height: 20),
              // Suggestions section for additional features.
              Card(
                color: colorScheme.secondary,
                child: ListTile(
                  leading: Icon(Icons.info_outline, color: colorScheme.onSecondary),
                  title: Text(
                    'Additional Suggestions',
                    style: TextStyle(color: colorScheme.onSecondary),
                  ),
                  subtitle: Text(
                    '• Add input fields for custom dimensions.\n'
                        '• Include a slider for adjusting height values.\n'
                        '• Provide a detailed breakdown of the intermediate calculations.\n'
                        '• Consider graphical representations of the vat shape for visual feedback.',
                    style: TextStyle(color: colorScheme.onSecondary),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
