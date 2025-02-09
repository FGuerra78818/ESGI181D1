import 'package:challenge1/services/config_manager.dart';
import 'package:challenge1/services/preset_manager.dart';
import 'package:decimal/decimal.dart';
import 'package:pair/pair.dart';
import 'package:test/test.dart';

void main() {
  group('loadPreset', () {
    late ConfigManager configManager;
    late PresetManager presetManager;

    setUp(() async {
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

      // Load presets from JSON file
      presetManager = PresetManager({
        "PRESETS": {
          "C69": {
            "Options": {
              "Base": "Cilindro",
              "Fundo": "Sim",
              "Pescoço": "Centrado",
              "Porta": "Dentro",
              "Formato Porta": "Oval"
            },
            "Values": {
              "Diametro Pescoço": "40",
              "Altura Pescoço": "36",
              "Angulo Pescoço": "1",
              "Diametro Base": "304.5",
              "Altura Base Geral": "521.3",
              "Hipotenusa Fundo": "1",
              "Diametro Menor Porta": "31",
              "Diametro Maior Porta": "43",
              "Profundidade Porta": "1.5",
              "Distância Chão Porta": "1",
              "Diametro Fundo": "1",
              "Comprimento Fundo": "1"
            }
          }
        }
      });
    });

    test('should load valid preset successfully', () {
      // Arrange
      const presetName = "C69";

      // Act
      final result = presetManager.loadPreset(configManager, presetName);

      print(result.options);
      // Assert
      expect(result.getValue("Diametro", "Pescoço"), equals(Decimal.parse('40')));
      // Verify options were processed (5 options in sample)
      // Verify values were processed (12 values in sample)
    });

    test('preset loading sets all values correctly', () {
      // Arrange
      const presetName = "C69";
      final expectedValues = {
        "Diametro Pescoço": Decimal.parse('40'),
        "Altura Pescoço": Decimal.parse('36'),
        "Angulo Pescoço": Decimal.parse('1'),
        "Diametro Base": Decimal.parse('304.5'),
        "Altura Base Geral": Decimal.parse('521.3'),
        "Hipotenusa Fundo": Decimal.parse('1'),
        "Diametro Menor Porta": Decimal.parse('31'),
        "Diametro Maior Porta": Decimal.parse('43'),
        "Profundidade Porta": Decimal.parse('1.5'),
        "Distância Chão Porta": Decimal.parse('1'),
        "Diametro Fundo": Decimal.parse('1'),
        "Comprimento Fundo": Decimal.parse('1'),
      };

      // Act
      presetManager.loadPreset(configManager, presetName);
      final neededValues = configManager.aggregateNeededValues();

      // Assert
      expectedValues.forEach((fullKey, expectedValue) {
        final words = fullKey.split(' ');
        final lastWord = words.last;
        final parameterName = words.sublist(0, words.length - 1).join(' ');

        expect(neededValues[lastWord], isNotNull, reason: 'Category $lastWord missing');

        final parameterPair = neededValues[lastWord]!.firstWhere(
              (pair) => pair.key == parameterName,
          orElse: () => Pair('', Decimal.zero),
        );

        expect(parameterPair.value, equals(expectedValue),
            reason: 'Incorrect value for $fullKey');
      });
    });

    test('should handle non-existent preset', () {
      // Arrange
      const invalidPreset = "NonExistent";

      // Act
      final result = presetManager.loadPreset(configManager, invalidPreset);

      // Assert
      expect(result, equals(configManager));
    });

    test('should process option parameters correctly', () {
      // Arrange
      const presetName = "C69";
      final expectedOptions = {
        "Base": "Cilindro",
        "Fundo": "Sim",
        "Pescoço": "Centrado",
        "Porta": "Interior",
        "Formato Porta": "Oval"
      };

      // Act
      presetManager.loadPreset(configManager, presetName);

      // Assert
      expectedOptions.forEach((key, value) {
        // Verify handleSelectedChange was called with correct parameters
      });
    });

    test('should split value keys correctly', () {
      // Arrange
      const presetName = "C69";
      final testCases = [
        ("Diametro Pescoço", "Pescoço", "Diametro"),
        ("Altura Base Geral", "Geral", "Altura Base"),
        ("Distãncia Chão Porta", "Porta", "Distãncia Chão"),
      ];

      // Act
      presetManager.loadPreset(configManager, presetName);

      // Assert
      testCases.forEach((testCase) {
        // Verify updateValue called with (lastWord, remainingWords, value)
      });
    });

    test('should handle empty preset name', () {
      // Arrange
      const emptyPreset = "";

      // Act
      final result = presetManager.loadPreset(configManager, emptyPreset);

      // Assert
      expect(result, equals(configManager));
    });
    test('preset loading sets all options correctly', () {
      // Arrange
      const presetName = "C69";
      final expectedOptions = {
        "Base": "Cilindro",
        "Fundo": "Sim",
        "Pescoço": "Centrado",
        "Porta": "Dentro",
        "Formato Porta": "Oval"
      };

      // Act
      presetManager.loadPreset(configManager, presetName);

      // Assert
      expectedOptions.forEach((optionName, expectedValue) {
        final option = configManager.options.firstWhere(
                (opt) => opt.name == optionName,
            orElse: () => throw Exception('Option $optionName not found')
        );

        expect(option, isNotNull, reason: 'Option $optionName missing');

        print(option.selected);
        print(option);
        final selectedParam = option.params[option.selected];
        expect(selectedParam.name, equals(expectedValue),
            reason: 'Incorrect selection for $optionName');

        // Additional check to ensure the correct index is selected
        final expectedIndex = option.params.indexWhere((param) => param.name == expectedValue);
        expect(option.selected, equals(expectedIndex),
            reason: 'Incorrect selected index for $optionName');
      });
    });
    test('getAllPresetNames', () {
      expect(presetManager.getPresetNames().length, equals(1));
    });
  });
}
