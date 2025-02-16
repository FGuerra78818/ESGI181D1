import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:challenge1/partials/graph.dart';
import 'package:challenge1/partials/app_bar.dart';

import 'optionState.dart';

class PreviewPage extends StatelessWidget {
  const PreviewPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: buildAppBar(context),
      body: _buildBody(context),
    );
  }

  Widget _buildBody(BuildContext context){
    final optionState = Provider.of<OptionsState>(context);

    return optionState.optionsSelected
        ? SingleChildScrollView( // Show the GraphWidget if options are selected
      child: _buildGraphNValues(context, optionState),
    )
        : const Center( // Show a placeholder if options are not selected
      child: Text("Escolha opções ou preset",
        style: TextStyle(fontSize: 24),),
    );
  }

  Widget _buildGraphNValues(BuildContext context, OptionsState optionState) {
    return Padding(
      padding: const EdgeInsets.all(24.0),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Graph Widget with a defined height
          SizedBox(
            height: MediaQuery.of(context).size.height * 0.55,
            width: double.infinity,
             child: Container(
               decoration: BoxDecoration(
                   border: Border.all(
                       color: Theme.of(context).colorScheme.onPrimary),
                   borderRadius: BorderRadius.circular(6)) ,
               child: const GraphWidget(),
             )
            ),
          const SizedBox(height: 10),
          const Text("Dados Necessários:", style: TextStyle(fontSize: 24, fontWeight: FontWeight.w900), ),

          // Value Labels
          for (final entry in optionState.conf.aggregateNeededValues().entries) ...[
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 8.0),
              child: Text(
                entry.key,
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              ),
            ),
            Wrap(
              spacing: 8.0, // Horizontal spacing between chips
              runSpacing: 4.0, // Vertical spacing between chips
              children: entry.value.map((value) => Chip(
                label: Text(value.key),
                backgroundColor: Theme.of(context).colorScheme.secondary,
              )).toList(),
            ),
          ],
          const SizedBox(height: 52), // More scroll at the bottom idk if it works
        ],
      ),
    );
  }


}