import 'package:flutter/material.dart';
import 'package:challenge1/pages/optionState.dart';
import 'package:provider/provider.dart';

import 'package:challenge1/partials/app_bar.dart';
import 'package:challenge1/partials/nav_bar.dart';

import '../classes/param.dart';


enum RecipientTypes { VAT, BARREL }


class OptionsPage extends StatefulWidget {
  const OptionsPage({super.key});

  @override
  State<StatefulWidget> createState() {
    return _OptionsPageState();
  }
}

class _OptionsPageState extends State<OptionsPage> {


  @override
  void initState() {
    super.initState();
    _type = Provider.of<OptionsState>(context, listen: false).type == "VAT" ? RecipientTypes.VAT : RecipientTypes.BARREL;
  }

  RecipientTypes? _type;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surface,
      appBar: buildAppBar(context),
      bottomNavigationBar: NavBar(currentIndex: 1,),
      body: Consumer<OptionsState>(
        builder: (context, optionsState, child) {
          if (!optionsState.hasBeenLoaded) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          } else {
            return buildSingleChildScrollView();
          }
        },
      ),
    );
  }

  Widget buildSingleChildScrollView() {
    return SingleChildScrollView(
      child: Column(
        children: [

          Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              children: [
                Align(
                  alignment: Alignment.centerLeft,
                  child: Padding(
                    padding: const EdgeInsets.only(left: 16.0),
                    child: Text(
                      'Tipo de Recipiente',
                      style: const TextStyle(
                        fontSize: 32,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),
                LayoutBuilder(
                  builder: (context, constraints) {
                    return Wrap(
                      spacing: 8,
                      runSpacing: 8,
                      children: [
                        SizedBox(
                          width: constraints.maxWidth / 2 - 12,
                          child: ListTile(
                            contentPadding: EdgeInsets.zero,
                            title: const Text('Cuba'),
                            leading: Radio<RecipientTypes>(
                              value: RecipientTypes.VAT,
                              groupValue: _type,
                              activeColor: Theme.of(context).colorScheme.tertiary,
                              onChanged: (RecipientTypes? value) {
                                Provider.of<OptionsState>(context, listen: false).swapType();
                                setState(() {
                                  _type = value;
                                });
                              },
                            ),
                          ),
                        ),
                        SizedBox(
                          width: constraints.maxWidth / 2 - 12,
                          child: ListTile(
                            contentPadding: EdgeInsets.zero,
                            title: const Text('Pipa'),
                            leading: Radio<RecipientTypes>(
                              value: RecipientTypes.BARREL,
                              groupValue: _type,
                              activeColor: Theme.of(context).colorScheme.tertiary,
                              onChanged: (RecipientTypes? value) {
                                Provider.of<OptionsState>(context, listen: false).swapType();
                                setState(() {
                                  _type = value;
                                });
                              },
                            ),
                          ),
                        ),
                      ],
                    );
                  },
                ),
                const SizedBox(height: 16),
                if (_type == RecipientTypes.VAT) ...[
                  for (var option in Provider.of<OptionsState>(context, listen: false).conf.options)
                    Column(
                      children: [
                        Align(
                          alignment: Alignment.centerLeft,
                          child: Padding(
                            padding: const EdgeInsets.only(left: 16.0),
                            child: Text(
                              option.name,
                              style: const TextStyle(
                                fontSize: 24,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                        ),
                        LayoutBuilder(
                          builder: (context, constraints) {
                            return Wrap(
                              spacing: 8,
                              runSpacing: 8,
                              children: [
                                for (final param in option.params)
                                  if (param.name.isNotEmpty)
                                    if (!option.isCheckbox)
                                      SizedBox(
                                        width: constraints.maxWidth / 2 - 12,
                                        child: ListTile(
                                          contentPadding: EdgeInsets.zero,
                                          title: Text(param.name),
                                          leading: Radio<Param>(
                                            value: param,
                                            groupValue: option.params[option.selected],
                                            activeColor: Theme.of(context).colorScheme.tertiary,
                                            onChanged: (Param? value) {
                                              setState(() {
                                                _handleRadioChange(option.name, param.id);
                                              });
                                            },
                                          ),
                                        ),
                                      )
                                    else
                                      Row(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Transform.translate(
                                            offset: const Offset(8, 0),
                                            child: Checkbox(
                                              value: option.selected == 1,
                                              onChanged: (value) =>
                                                  _handleCheckboxChange(option.name, param.id, option.selected),
                                            ),
                                          )
                                        ],
                                      )
                              ],
                            );
                          },
                        ),
                        const SizedBox(height: 16),
                      ],
                    ),
                ]
              ],
            ),
          ),
        ],
      ),
    );
  }


  void _handleCheckboxChange(String option, int param, int value)  {
    if (value == 1) {
      Provider.of<OptionsState>(context, listen: false)
          .conf.handleSelectedChange(option, 0);
    } else {
      Provider.of<OptionsState>(context, listen: false)
          .conf.handleSelectedChange(option, 1);
    }
    setState(() {});
  }

  void _handleRadioChange(String option, int param){
    Provider.of<OptionsState>(context, listen: false).conf.handleSelectedChange(option, param);
  }

}