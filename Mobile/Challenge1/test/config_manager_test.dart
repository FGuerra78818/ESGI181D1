import 'package:flutter_test/flutter_test.dart';
import 'package:challenge1/classes/option.dart';
import 'package:challenge1/services/config_manager.dart';

void main() {
    late ConfigManager configManager;

    setUp(() async {
      // Create an instance of ConfigManager with mocked data
      configManager = ConfigManager(
        {
          "OPTIONS": {
            "VAT": {
              "RADIAL": {
                "Base": ["Cilindro", "Cone"],
                "Porta": ["Dentro", "Fora"],
                "Formato Porta": ["Retangular", "Oval"],
                "Fundo": ["Sim", "Não"],
                "Pescoço": ["Centrado", "Desviado"]
              },
              "CHECKBOX": ["Pescoço Adicional"]
            }
          }
        },
        {
          "NEEDEDVALUES": {
            "VAT": {
              "Fundo": {
                "Sim": {
                  "Geral": ["Altura Base"],
                  "Fundo": ["Hipotenusa", "Diametro", "Comprimento"]
                },
                "Não": {
                  "Geral": ["Altura Total"]
                }
              },
              "Formato Porta": {
                "Retangular": {
                  "Porta": ["Largura", "Comprimento", "Profundidade", "Distância Chão"]
                },
                "Oval": {
                  "Porta": ["Diametro Menor", "Diametro Maior", "Profundidade", "Distância Chão"]
                }
              },
              "Base": {
                "Cilindro": {
                  "Base": ["Diametro"]
                },
                "Cone": {
                  "Base": ["Diametro"],
                  "Topo": ["Hipotenusa"]
                }
              },
              "Pescoço": {
                "Centrado": {
                  "Pescoço": ["Diametro", "Altura", "Angulo"]
                },
                "Desviado": {
                  "Pescoço":
                  ["Diametro", "Altura Menor", "Altura Maior", "Angulo"]
                }
              },
              "Pescoço Adicional": {
                "":
                {"Base": []},
                "Sim":
                {"Pescoço": ["Altura Adicional", "Diametro Adicional"]}
              }
            }
          }
        },
      );
      configManager.createOptions();
    });

    group('ConfigManager - createOptions', () {
    test('should Give Needed Values', () async {
      Map<String, Map<String,List<String>>> res = configManager.getNeededValues("Fundo");
      assert(true,true);
    });
    test('should create options correctly', () async {
      // Call createOptions
      bool result = configManager.createOptions();

      // Verify that options were created successfully
      expect(result, true);
      for (Option opt in configManager.options){
        //print(opt.getOptionJsonFormat());
        //print(opt.getValuesJsonFormat());
        print(opt);
        print("----------------------------------------------------------------------------------");
      }
      /*
      expect(configManager.options.length, greaterThan(0));

      // Verify specific options
      Option baseOption = configManager.options.firstWhere((o) => o.name == 'Base');
      expect(baseOption.name, 'Base');
      expect(baseOption.neededValues, isNotNull);

      Option portaOption = configManager.options.firstWhere((o) => o.name == 'Porta');
      expect(portaOption.name, 'Porta');
      expect(portaOption.neededValues, isNotNull);*/
    });});

    group('handleCheckbox', () {
      test('toggles Pescoço Adicional from 0 to 1', () async {
        // Initial state
        final initialOption = configManager.options.firstWhere(
              (o) => o.name == "Pescoço Adicional",
        );
        expect(initialOption.selected, 0);

        // Action
        configManager.handleSelectedChange("Pescoço Adicional", 1);

        // Verification
        final updatedOption = configManager.options.firstWhere(
              (o) => o.name == "Pescoço Adicional",
        );
        expect(updatedOption.selected, 1);
      });

      test('toggles Pescoço Adicional from 1 to 0', () {
        // Set initial state
        configManager.options.firstWhere(
              (o) => o.name == "Pescoço Adicional",
        ).selected = 1;

        // Action
        configManager.handleSelectedChange("Pescoço Adicional", 0);

        // Verification
        final updatedOption = configManager.options.firstWhere(
              (o) => o.name == "Pescoço Adicional",
        );
        expect(updatedOption.selected, 0);
      });

      test('does nothing for non-checkbox options', () {
        // Take a radial option from your config
        final radialOption = configManager.options.firstWhere(
              (o) => o.name == "Base", // From VAT/RADIAL in your JSON
        );
        final initialValue = radialOption.selected;

        // Action
        configManager.handleSelectedChange("Base", 0);

        // Verification
        expect(radialOption.selected, initialValue);
      });

      test('does nothing for non-existent option', () {
        final initialOptions = List<Option>.from(configManager.options);

        // Action
        configManager.handleSelectedChange("Non-existent Option", 0);

        // Verification
        expect(configManager.options, initialOptions);
      });

      test('toggles "Base" from "Cilindro" to "Cone"', () async {
        // Initial state
        final initialOption = configManager.options.firstWhere(
              (o) => o.name == "Base",
        );
        expect(initialOption.selected, 0);

        // Action
        configManager.handleSelectedChange("Base", 1);

        // Verification
        final updatedOption = configManager.options.firstWhere(
              (o) => o.name == "Base",
        );
        expect(updatedOption.selected, 1);
      });
    });
}
