import 'package:challenge1/math/volumeCalculator.dart';
import 'package:challenge1/services/config_manager.dart';
import 'package:challenge1/services/preset_manager.dart';
import 'package:decimal/decimal.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('loadPreset', () {
    late ConfigManager config;
    late PresetManager presetManager;
    late VolumeCalculator calculator;

    setUp(() async {
      config = ConfigManager(
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
                  "Base": ["Diametro","Arredondamento"]
                },
                "Cone": {
                  "Base": ["Diametro","Arredondamento"],
                  "Topo": ["Hipotenusa"]
                }
              },
              "Pescoço": {
                "Centrado": {
                  "Pescoço": ["Diametro", "Altura", "Angulo"]
                },
                "Desviado": {
                  "Pescoço":
                  ["Diametro", "Altura Menor", "Altura Maior"]
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
      config.createOptions();

      // Load presets from JSON file
      presetManager = PresetManager({
        "PRESETS": {
          "C69": {
            "Options": {
              "Base": "Cilindro",
              "Fundo": "Não",
              "Pescoço": "Centrado",
              "Porta": "Dentro",
              "Formato Porta": "Oval"
            },
            "Values": {
              "Diametro Pescoço": "40",
              "Altura Pescoço": "36",
              "Angulo Pescoço": "104.6",
              "Diametro Base": "305",
              "Altura Total Geral": "553",
              "Diametro Menor Porta": "31",
              "Diametro Maior Porta": "43",
              "Profundidade Porta": "1.5",
              "Distância Chão Porta": "25",
              "Arredondamento Base": 5,
            }
          },
          "72": {
            "Options": {
              "Base": "Cilindro",
              "Fundo": "Sim",
              "Pescoço": "Desviado",
              "Porta": "Fora",
              "Formato Porta": "Retangular"
            },
            "Values": {
              "Altura Maior Pescoço": 30,
              "Altura Menor Pescoço": 20,
              "Diametro Pescoço": 40,
              "Altura Base Geral": 286.88,
              "Hipotenusa Fundo": 66,
              "Diametro Base": 130,
              "Diametro Fundo": 6,
              "Comprimento Fundo": 65,
              "Distancia Chão Porta": 25,
              "Largura Porta": 42,
              "Comprimento Porta": 31,
              "Profundidade Porta": 2
            }
          },
          "C78": {
            "Options": {
              "Base": "Cilindro",
              "Pescoço": "Centrado",
              "Formato Porta": "Retangular",
              "Porta": "Fora",
              "Fundo": "Não"
            },
            "Values": {
              "Diametro Pescoço": 43,
              "Altura Pescoço": 55,
              "Angulo Pescoço": 105,
              "Diametro Base": 350,
              "Altura Total Geral": 528,
              "Comprimento Porta": 31,
              "Largura Porta": 42,
              "Profundidade Porta": 2,
              "Distancia Fundo Porta": 25,
              "Arredondamento Base": 7,
              "Volume Fabrica": 46000
            }
          },
        }
      });

    calculator = VolumeCalculator(config);
  });

  test('Volume calculation should return expected value', () {
    config = presetManager.loadPreset(config, "C69");
    Decimal result = calculator.calculateVolumeClick().round(scale: 2);

    // Expected result (this should be updated based on your expected calculations)
    Decimal expectedVolume = Decimal.parse("36255.05"); // Replace with actual expected volume

    expect(result.toString(), expectedVolume.toString(), reason: "Calculated volume does not match expected value.");
  });

  test('Volume calculation should return expected value', () {
      config = presetManager.loadPreset(config, "72");
      Decimal result = calculator.calculateVolumeClick().round(scale: 2);

      // Expected result (this should be updated based on your expected calculations)
      Decimal expectedVolume = Decimal.parse("4015.69"); // Replace with actual expected volume

      expect(result.toString(), expectedVolume.toString(), reason: "Calculated volume does not match expected value.");
    });

  test('Volume calculation should return expected value', () {
    config = presetManager.loadPreset(config, "C78");
    Decimal result = calculator.calculateVolumeClick().round(scale: 2);

    // Expected result (this should be updated based on your expected calculations)
    Decimal expectedVolume = Decimal.parse("4015.69"); // Replace with actual expected volume

    expect(result.toString(), expectedVolume.toString(), reason: "Calculated volume does not match expected value.");
  });

});
}
