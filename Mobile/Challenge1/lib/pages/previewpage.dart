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
      body: _buildBody(context), // Call _buildBody instead of the inline Center widget
    );
  }

  Widget _buildBody(BuildContext context){
    final optionState = Provider.of<OptionsState>(context); // Remove listen: false

    return optionState.optionsSelected
        ? Center( // Show the GraphWidget if options are selected
      child: SizedBox(
        width: MediaQuery.of(context).size.width * 0.9,
        height: MediaQuery.of(context).size.height * 0.8,
        child: const GraphWidget(),
      ),
    )
        : const Center( // Show a placeholder if options are not selected
      child: Text("Escolha opções ou preset",
        style: TextStyle(fontSize: 24),), // Or any other widget
    );
  }


}