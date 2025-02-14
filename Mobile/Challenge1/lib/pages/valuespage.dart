import 'package:challenge1/pages/optionState.dart';
import 'package:decimal/decimal.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:pair/pair.dart';
import 'package:provider/provider.dart';


import 'package:challenge1/partials/nav_bar.dart';
import 'package:challenge1/partials/app_bar.dart';


class ValuesPage extends StatefulWidget {
  const ValuesPage({super.key});

  @override
  State<ValuesPage> createState() => _ValuesPageState();
}

class _ValuesPageState extends State<ValuesPage> {
  final List<TextEditingController> _controllers = [];
  bool _isSnackBarActive = false;
  late final bool _hasBeenLoaded;
  bool _isInitialized = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (!_isInitialized) {
      _hasBeenLoaded = Provider
          .of<OptionsState>(context, listen: false)
          .hasBeenLoaded;
      _initializeControllers();
      _isInitialized = true;
    }
  }

  void _initializeControllers() {
    if (!Provider.of<OptionsState>(context, listen: false).hasBeenLoaded) {
      return;
    }
    final neededValues = Provider.of<OptionsState>(context, listen: false)
        .conf
        .aggregateNeededValues();

    if (_controllers.isEmpty) {
      int num = 0;
      for (var entry in neededValues.entries){
        num += entry.value.length;
      }
      _controllers.addAll(
        List.generate(num, (index) => TextEditingController()),
      );
    }
  }

  @override
  void dispose() {
    if (_hasBeenLoaded) {
      for (final controller in _controllers) {
        controller.dispose();
      }
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surface,
      appBar: buildAppBar(context),
      body: Consumer<OptionsState>(
        builder: (context, optionsState, child) {
          if (!optionsState.hasBeenLoaded){
            return const Center(child: CircularProgressIndicator(),);
          } else {
            return _buildBody();
          }
        }
      ),
      bottomNavigationBar: NavBar(currentIndex: 2,),
    );
  }


  Widget _buildBody() {
    final optionsState = Provider.of<OptionsState>(context, listen: false);

    return Column(
      children: [
        _buildPresetSelector(),
        Expanded(
          child: !optionsState.optionsSelected || _controllers.isEmpty
              ? const Center(
            child: Text(
              "Escolha opções ou preset",
              style: TextStyle(fontSize: 24),
            ),
          )
              : _buildInputForm(),
        ),
      ],
    );
  }


  Widget _buildInputForm() {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 30.0),
        child: Column(
          children: [
            _buildParameterInputs(),
            _buildActionButtons(),
          ],
        ),
      ),
    );
  }

  Widget _buildPresetSelector(){
    return PresetSelector();
  }

  Widget _buildParameterInputs() {
    final neededValues = Provider.of<OptionsState>(context, listen: false)
        .conf
        .aggregateNeededValues();

    return Column(
      children: [
        if (Provider.of<OptionsState>(context, listen: true).hasBeenLoaded)
        for (final entry in neededValues.entries) ...[
          Padding(
            padding: const EdgeInsets.only(top: 20, bottom: 10),
              child: Align(
              alignment: Alignment.centerLeft,
                child: Text(
                  entry.key,
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w800,
                ),
              ),
            ),
          ),
          for (int i = 0, controllerIndex = _getStartingIndex(entry); i < entry.value.length; i++, controllerIndex++)
          ParameterInputRow(
            partName: entry.key,
            parameterName: entry.value[i].key,
            controller: _controllers[controllerIndex],
            paramVal: entry.value[i].value,
          ),
        ],
      ]
    );
  }

  Widget _buildActionButtons() {
    return Column(
      children: [
        Row(
          children: [
            Expanded(
              child: ElevatedButton(
                onPressed: _handleCalculate,
                style: ElevatedButton.styleFrom(
                backgroundColor: Theme.of(context).colorScheme.secondary,
                foregroundColor: Theme.of(context).colorScheme.onPrimary,
              ),
                child: const Text("Calcular", style: TextStyle(fontWeight: FontWeight.w500),
              ),
            ),
            )
          ],
        ),
        Row(
          children: [Expanded(child: PresetSaveWidget(),),],
        )
      ],
    );
  }


  void _handleCalculate() {
    if (!_validateFields()) return;
    // Add calculation logic
  }

  bool _validateFields() {
    if (_isSnackBarActive) return false;

    final allFilled = _controllers.every((c) => c.text.isNotEmpty);
    if (!allFilled) _showValidationSnackBar(allFilled);

    return allFilled;
  }

  void _showValidationSnackBar(bool allFilled) {
    setState(() => _isSnackBarActive = true);

    ScaffoldMessenger.of(context)
        .showSnackBar(
      SnackBar(
        content: Text(allFilled ? 'Tudo está preenchido!' : 'Têm que preencher todos os valores'),
        duration: const Duration(seconds: 2),
      ),
    )
        .closed
        .then((_) => setState(() => _isSnackBarActive = false));
  }

  int _getStartingIndex(MapEntry<String, List<Pair<String, Decimal>>> currentEntry) {
    final neededValues = Provider.of<OptionsState>(context, listen: false)
        .conf
        .aggregateNeededValues();

    int index = 0;
    for (final entry in neededValues.entries) {
      if (entry.toString() == currentEntry.toString()) break;
      index += entry.value.length;
    }

    return index;
  }

}

class ParameterInputRow extends StatelessWidget {
  final String partName;
  final String parameterName;
  final TextEditingController controller;
  final Decimal paramVal;

  const ParameterInputRow({
    super.key,
    required this.partName,
    required this.parameterName,
    required this.controller,
    required this.paramVal,
  });

  @override
  Widget build(BuildContext context) {
    // Initialize controller text if empty
    if (controller.text.isEmpty && paramVal != Decimal.zero) {
      controller.text = paramVal.toString();
    }
    return Row(
      children: [
        Expanded(
          child: Text(
            parameterName,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w700,
            ),
          ),
        ),
        Expanded(
          child: TextField(
            controller: controller,
            decoration: const InputDecoration(
              border: OutlineInputBorder(),
            ),
            keyboardType: const TextInputType.numberWithOptions(decimal: true),
            inputFormatters: [
              FilteringTextInputFormatter.allow(RegExp(r'^\d*\.?\d*')),
            ],
            onChanged: (text) {
              try {
                if (text.isNotEmpty) {
                  final decimalValue = Decimal.parse(text);
                  Provider.of<OptionsState>(context, listen: false).conf.updateValue(
                      partName,
                      parameterName,
                      decimalValue
                  );
                }
              } catch (e) {
                // Handle invalid decimal input
              }
            },
          ),
        ),
      ],
    );
  }
}
class PresetSelector extends StatefulWidget{
  const PresetSelector({Key ? key}) : super(key: key);

  @override
  _PresetSelectorState createState() => _PresetSelectorState();
}

class _PresetSelectorState extends State<PresetSelector>{
  bool isExpanded = false;

  @override
  Widget build(BuildContext context){
    final presetNames = Provider.of<OptionsState>(context, listen: false).pres.getPresetNames();
    return Container(
      margin: EdgeInsets.all(8.0),
      decoration: BoxDecoration(
        border:  Border.all(color: Theme.of(context).colorScheme.onPrimary),
        borderRadius: BorderRadius.circular(8.0),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          GestureDetector(
            onTap: () {
              setState(() {
                isExpanded = !isExpanded;
              });
            },
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.secondary,
                borderRadius: isExpanded
                  ? const BorderRadius.only(
                    topLeft: Radius.circular(8.0),
                    topRight: Radius.circular(8.0),
                    )
                  : BorderRadius.circular(8.0),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text("PRESET", style: TextStyle(fontSize:  18, fontWeight: FontWeight.bold),),
                  Icon(isExpanded ? Icons.keyboard_arrow_up : Icons.keyboard_arrow_down),
                ],
              ),
            ),
          ),
          if (isExpanded )
            Container(
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.onSecondary,
                borderRadius: const BorderRadius.only(
                  bottomLeft: Radius.circular(8.0),
                  bottomRight: Radius.circular(8.0),
                ),
              ),

              child: presetNames.isEmpty ?
              const Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [Text("Sem presets")],
              )

              : ListView.builder(
                shrinkWrap: true,
                itemCount: presetNames.length,
                itemBuilder: (BuildContext dialogContext, index){
                  final presetName = presetNames[index];
                  return Padding(
                    padding: const EdgeInsets.symmetric(vertical: 4.0, horizontal: 8.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Padding(padding: const EdgeInsets.symmetric(horizontal: 8.0), child:
                        Text(
                          presetName,
                          style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
                        ),),
                        // Action Buttons (Select and Delete)
                        Row(
                          children: [
                            IconButton(
                              icon: const Icon(Icons.check, color: Colors.green),
                              onPressed: () {
                                Provider.of<OptionsState>(context, listen: false).loadPreset(presetName);
                                setState(() {
                                  isExpanded = false; // Collapse after selecting
                                });
                                Navigator.pushReplacement(
                                  context,
                                  MaterialPageRoute(builder: (context) => const ValuesPage()),
                                );
                              },
                            ),
                            IconButton(
                              icon: const Icon(Icons.delete, color: Colors.red),
                              onPressed: () {
                                _confirmDelete(dialogContext, presetName);
                              },
                            ),
                          ],
                        ),
                      ],
                    ),
                  );
                }
            )
            )
        ],
      )
    );
  }
  void _confirmDelete(BuildContext context, String presetName) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Eliminar Preset"),
        content:
        Text("Tens a certeza que queres eliminar o preset \"$presetName\"? Não pode ser recuperado."),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(), // Cancel action
            child: const Text("Cancelar"),
          ),
          TextButton(
            onPressed: () {
              Provider.of<OptionsState>(context, listen: false).pres.deletePreset(presetName);
              Navigator.of(context).pop(); // Close dialog
              setState(() {}); // Refresh UI after deletion
            },
            child: const Text("Eliminar", style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }
}

class PresetSaveWidget extends StatefulWidget {
  const PresetSaveWidget({Key? key}) : super(key: key);

  @override
  _PresetSaveWidgetState createState() => _PresetSaveWidgetState();
}

class _PresetSaveWidgetState extends State<PresetSaveWidget> {
  final TextEditingController _textFieldController = TextEditingController();

  Future<void> _showTextInputDialog(BuildContext context) async {
    String enteredText = "";

    await showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        return AlertDialog(
          title: const Text('Guardar Preset'),
          content: TextField(
            controller: _textFieldController,
            decoration: const InputDecoration(hintText: "Insere o nome do Preset"),
            inputFormatters: [
              FilteringTextInputFormatter.allow(RegExp(r'^\w{0,8}')), // Limit to alphanumeric and 8 characters
            ],
          ),
          actions: <Widget>[
            TextButton(
              child: const Text('CANCELAR'),
              onPressed: () {
                Navigator.pop(context);
              },
            ),
            TextButton(
              child: const Text('OK'),
              onPressed: () {
                enteredText = _textFieldController.text.trim();
                Navigator.pop(context);
                if (enteredText.isNotEmpty) {
                  _savePreset(context, enteredText);
                }
              },
            ),
          ],
        );
      },
    );
  }

  Future<void> _showOverwriteConfirmationDialog(
      BuildContext context, String presetName) async {
    await showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Confirmação para Reescrever'),
          content:
          Text('Um preset com nome "$presetName" já existe. Quer que seja reescrito?'),
          actions: <Widget>[
            TextButton(
              child: const Text('Cancelar'),
              onPressed: () {
                Navigator.of(context).pop(); // Close the dialog
              },
            ),
            TextButton(
              child: const Text('Reescrever'),
              onPressed: () {
                Provider.of<OptionsState>(context, listen: false)
                    .savePreset(presetName);
                Navigator.of(context).pop(); // Close the dialog
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('O preset "$presetName" foi reescrito com sucesso!')),
                );
              },
            ),
          ],
        );
      },
    );
  }

  void _savePreset(BuildContext context, String presetName) async {
    final optionsState = Provider.of<OptionsState>(context, listen: false);

    if (optionsState.pres.doesPresetAlreadyExist(presetName)) {
      // Show overwrite confirmation dialog
      _showOverwriteConfirmationDialog(context, presetName);
    } else {
      // Save new preset
      optionsState.savePreset(presetName);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('O preset "$presetName" foi guardado!')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 20.0),
      child: ElevatedButton(
        onPressed: () => _showTextInputDialog(context),
        style: ElevatedButton.styleFrom(
          backgroundColor: Theme.of(context).colorScheme.secondary,
          foregroundColor: Theme.of(context).colorScheme.onPrimary,
        ),
        child: const Text("Guardar Preset", style: TextStyle(fontWeight: FontWeight.w500),),
      ),
    );
  }
}




