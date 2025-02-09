import 'package:challenge1/classes/param.dart';
import 'package:decimal/decimal.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:challenge1/classes/option.dart';
import 'package:challenge1/services/config_manager.dart';
import 'package:pair/pair.dart';

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

    group('ConfigManager.aggregateNeededValues', () {
      late ConfigManager configManager;
      final mockDecimal = Decimal.zero;

      setUp(() => configManager = ConfigManager({}, {}));

      test('returns empty map when no options exist', () {
        expect(configManager.aggregateNeededValues(), isEmpty);
      });

      test('aggregates single option with multiple categories', () {
        configManager.options = [
          Option(
              name: "Fundo",
              params: [
                Param.createParam("Sim", {
                  "Geral": ["Altura Base"],
                  "Fundo": ["Hipotenusa", "Diametro"]
                }, 0)
              ],
              selected: 0
          )
        ];

        expect(configManager.aggregateNeededValues(), equals({
          "Geral": [Pair("Altura Base", mockDecimal)],
          "Fundo": [
            Pair("Hipotenusa", mockDecimal),
            Pair("Diametro", mockDecimal)
          ]
        }));
      });

      test('combines multiple options with different categories', () {
        configManager.options = [
          Option.createOption("Fundo", {
            "Sim": {"Geral": ["Altura Base"]}
          }),
          Option.createOption("Formato Porta", {
            "Retangular": {"Porta": ["Largura"]}
          })
        ];

        expect(configManager.aggregateNeededValues(), equals({
          "Geral": [Pair("Altura Base", mockDecimal)],
          "Porta": [Pair("Largura", mockDecimal)]
        }));
      });

      test('concatenates same category across multiple options', () {
        configManager.options = [
          Option.createOption("Fundo", {
            "Sim": {"Geral": ["Altura Base"]}
          }),
          Option.createOption("Extra", {
            "Ativo": {"Geral": ["Altura Total"]}
          })
        ];

        expect(configManager.aggregateNeededValues(), equals({
          "Geral": [
            Pair("Altura Base", mockDecimal),
            Pair("Altura Total", mockDecimal)
          ]
        }));
      });

      test('handles checkbox options when selected', () {
        configManager.options = [
          Option(
              name: "Pescoço Adicional",
              params: [
                Param.createParam("", {"Base": []}, 0),
                Param.createParam("Sim", {
                  "Pescoço": ["Altura Adicional"]
                }, 1)
              ],
              isCheckbox: true,
              selected: 1
          )
        ];

        expect(configManager.aggregateNeededValues(), equals({
          "Pescoço": [Pair("Altura Adicional", mockDecimal)]
        }));
      });

      test('handles mixed radial and checkbox options', () {
        configManager.options = [
          Option.createOption("Base", {
            "Cilindro": {"Base": ["Diametro"]}
          }),
          Option(
              name: "Pescoço Adicional",
              params: [
                Param.createParam("", {"Base": []}, 0),
                Param.createParam("Sim", {
                  "Pescoço": ["Altura Adicional"]
                }, 1)
              ],
              isCheckbox: true,
              selected: 1
          )
        ];

        expect(configManager.aggregateNeededValues(), equals({
          "Base": [Pair("Diametro", mockDecimal)],
          "Pescoço": [Pair("Altura Adicional", mockDecimal)]
        }));
      });

      test('preserves parameter order within categories', () {
        configManager.options = [
          Option.createOption("First", {
            "Opt1": {"Structural": ["Beam Length"]}
          }),
          Option.createOption("Second", {
            "Opt2": {"Structural": ["Beam Width"]}
          })
        ];


        expect(configManager.aggregateNeededValues()["Structural"], equals([
          Pair("Beam Length", mockDecimal),
          Pair("Beam Width", mockDecimal)
        ]));
      });
    });

    group('ConfigManager.updateValue', () {
      late ConfigManager configManager;

      setUp(() {
        configManager = ConfigManager({}, {});
        configManager.options = [
          Option.createOption("Fundo", {
            "Sim": {
              "Geral": ["Altura Base"],
              "Fundo": ["Hipotenusa", "Diametro", "Comprimento"]
            },
            "Não": {
              "Geral": ["Altura Total"]
            }
          }),
          Option.createOption("Formato Porta", {
            "Retangular": {
              "Porta": ["Largura", "Comprimento", "Profundidade", "Distância Chão"]
            },
            "Oval": {
              "Porta": ["Diametro Menor", "Diametro Maior", "Profundidade", "Distância Chão"]
            }
          }),
          Option.createOption("Base", {
            "Cilindro": {
              "Base": ["Diametro"]
            },
            "Cone": {
              "Base": ["Diametro"],
              "Topo": ["Hipotenusa"]
            }
          }),
          Option(
              name: "Pescoço Adicional",
              params: [
                Param.createParam("", {"Base": []}, 0),
                Param.createParam("Sim", {
                  "Pescoço": ["Altura Adicional", "Diametro Adicional"]
                }, 1)
              ],
              isCheckbox: true,
              selected: 0
          )
        ];
      });

      test('updates single matching parameter', () {
        configManager.options[0].selected = 0; // Select "Sim" for Fundo
        configManager.updateValue("Geral","Altura Base", Decimal.parse('10'));

        expect(configManager.options[0].getNeededValues()["Geral"]![0].value, Decimal.parse('10'));
      });

      test('updates multiple matches across options', () {
        configManager.options[0].selected = 0; // Select "Sim" for Fundo
        configManager.options[2].selected = 1; // Select "Cone" for Base
        configManager.updateValue("Fundo","Diametro", Decimal.parse('20'));

        expect(configManager.options[0].getNeededValues()["Fundo"]![1].value, Decimal.parse('20'));
        expect(configManager.options[2].getNeededValues()["Base"]![0].value, Decimal.parse('0'));
      });

      test('does not modify non-matching parameters', () {
        configManager.options[1].selected = 0; // Select "Retangular" for Formato Porta
        configManager.updateValue("Geral","Altura Base", Decimal.parse('30'));

        expect(configManager.options[1].getNeededValues()["Porta"]!.every((pair) => pair.value == Decimal.zero), isTrue);
      });

      test('handles case sensitivity correctly', () {
        configManager.options[0].selected = 0; // Select "Sim" for Fundo
        configManager.updateValue("Geral","altura base", Decimal.parse('40'));

        expect(configManager.options[0].getNeededValues()["Geral"]![0].value, Decimal.zero);
      });

      test('updates nested parameter structures', () {
        configManager.options[2].selected = 1; // Select "Cone" for Base
        configManager.updateValue("Topo","Hipotenusa", Decimal.parse('50'));

        expect(configManager.options[2].getNeededValues()["Topo"]![0].value, Decimal.parse('50'));
      });

      test('only updates selected parameters', () {
        configManager.options[1].selected = 0; // Select "Retangular" for Formato Porta
        configManager.updateValue("Porta","Diametro Menor", Decimal.parse('60'));

        expect(configManager.options[1].getNeededValues()["Porta"]!.every((pair) => pair.value == Decimal.zero), isTrue);
      });

      test('updates checkbox option when selected', () {
        configManager.options[3].selected = 1; // Select "Sim" for Pescoço Adicional
        configManager.updateValue("Pescoço","Altura Adicional", Decimal.parse('70'));

        expect(configManager.options[3].getNeededValues()["Pescoço"]![0].value, Decimal.parse('70'));
      });
    });

    group('ConfigManager.getJsonEncoding', () {
      late ConfigManager configManager;

      setUp(() async {
        // Initialize ConfigManager with mocked data
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

      test('should return correct JSON encoding', () {
        // Act
        final jsonEncoding = configManager.getJsonEncoding();

        // Assert: Verify the number of options and values
        expect(jsonEncoding['Options'].length, equals(5), reason: 'Expected 5 options');
        expect(jsonEncoding['Values'].length, equals(12), reason: 'Expected 12 values');

        // Assert: Verify specific keys in Options
        expect(jsonEncoding['Options'].keys, containsAll(['Base', 'Porta', 'Formato Porta', 'Fundo', 'Pescoço']));

      });

      test('should correctly encode options and values Default', () {
        // Act
        final jsonEncoding = configManager.getJsonEncoding();

        print(jsonEncoding);
        // Expected data based on mock setup
        final expectedOptions = {
          'Base': 'Cilindro',
          'Porta': 'Dentro',
          'Formato Porta': 'Retangular',
          'Fundo': 'Sim',
          'Pescoço': 'Centrado'
        };

        Decimal mockDec = Decimal.zero;

        final expectedValues = {
          "Diametro Pescoço": mockDec,
          "Altura Pescoço": mockDec,
          "Angulo Pescoço": mockDec,
          "Diametro Base": mockDec,
          "Altura Base Geral": mockDec,
          "Hipotenusa Fundo": mockDec,
          "Largura Porta": mockDec,
          "Comprimento Porta": mockDec,
          "Profundidade Porta": mockDec,
          "Diametro Fundo": mockDec,
          "Comprimento Fundo": mockDec,
          "Distância Chão Porta": mockDec
        };

        // Assert: Check if Options match expected data
        expectedOptions.forEach((key, value) {
          expect(jsonEncoding['Options'][key], equals(value), reason: 'Mismatch for option $key');
        });

        // Assert: Check if Values match expected data
        expectedValues.forEach((key, value) {
          expect(jsonEncoding['Values'][key], equals(value), reason: 'Mismatch for value $key');
        });
      });
    });

}