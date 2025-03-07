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
                "Porta": ["Interior", "Exterior"],
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
              "Porta": "Interior",
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
              "Porta": "Exterior",
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
              "Porta": "Exterior",
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
              "Arredondamento Base": 5,
              "Volume Fabrica": 46000
            }
          },
          "F30": {
            "Options": {
              "Base": "Cone",
              "Pescoço": "Centrado",
              "Formato Porta": "Retangular",
              "Porta": "Exterior",
              "Fundo": "Não"
            },
            "Values": {
              "Diametro Pescoço": "60",
              "Altura Pescoço": "30",
              "Angulo Pescoço": "105",
              "Hipotenusa Topo": "94",
              "Diametro Base": "310",
              "Altura Total Geral": "361",
              "Comprimento Porta": "53",
              "Largura Porta": "40.5",
              "Profundidade Porta": "12",
              "Distancia Chão Porta": "25",
              "Arredondamento Base": "6",
              "Volume Fabrica": "19000"
            }
          },
          "F37": {
            "Options": {
              "Base": "Cone",
              "Pescoço": "Centrado",
              "Formato Porta": "Retangular",
              //Porta -> Formato Porta, Retangulo -> Retangular
              "Porta": "Exterior",
              //PortaPosição -> Porta, Fora -> Exterior
              "Fundo": "Não"
              // False -> Não
            },
            "Values": {
              "Diametro Pescoço": "63",
              "Altura Menor Pescoço": "33.5",
              //Pequena -> Menor, Grande -> Maior
              "Angulo Pescoço": "105",
              "Hipotenusa Topo": "67.6",
              "Diametro Base": "246",
              "Altura Total Geral": "230.5",
              // +Geral
              "Largura Porta": "53.5",
              // Diametro Menor-> Largura
              "Comprimento Porta": "40",
              // Diametro Maior -> Comprimento
              "Profundidade Porta": "6",
              // Profundidade
              "Distancia Fundo Porta": "25",
              "Arredondamento Base": "6",
              "Volume Fabrica": "7200"
            },
          },
          "SF13": {
            "Options": {
              "Base": "Cilindro",
              "Pescoço": "Centrado",
              "Formato Porta": "Retangular",
              "Porta": "Exterior",
              "Fundo": "Não"
            },
            "Values": {
              "Diametro Pescoço": "65",
              "Altura Menor Pescoço": "35",
              "Angulo Pescoço": "101.0116",
              "Diametro Base": "250",
              "Altura Total Geral": "328",
              "Comprimento Porta": "43",
              "Largura Porta": "56",
              "Profundidade Porta": "4",
              "Distancia Fundo Porta": "25",
              "Arredondamento Base": "6",
              "Volume Fabrica": "14000"
            }
          },
          "SF11": {
            "Options": {
              "Base": "Cone",
              "Pescoço": "Centrado",
              "Formato Porta": "Retangular",
              "Porta": "Exterior",
              "Fundo": "Não"
            },
            "Values": {
              "Diametro Pescoço": "98",
              "Altura Menor Pescoço": "13.5",
              "Angulo Pescoço": "106.4",
              "Hipotenusa Topo": "21.8",
              "Diametro Base": "216",
              "Altura Total Geral": "300",
              "Comprimento Porta": "40",
              "Largura Porta": "53.5",
              "Profundidade Porta": "4",
              "Distancia Chão Porta": "25",
              "Arredondamento Base": "6",
              "Volume Fabrica": "7250"
            },
          },
          "F17": {
            "Options": {
              "Base": "Cone",
              "Pescoço": "Centrado",
              "Formato Porta": "Retangular",
              "Porta": "Exterior",
              "Fundo": "Não"
            },
            "Values": {
              "Diametro Pescoço": "60",
              "Altura Menor Pescoço": "30",
              "Angulo Pescoço": "105",
              "Hipotenusa Topo": "67",
              "Diametro Base": "242.6",
              "Altura Total Geral": "232",
              "Comprimento Porta": "41",
              "Largura Porta": "50",
              "Profundidade Porta": "6",
              "Distancia Fundo Porta": "25",
              "Arredondamento Base": "6",
              "Volume Fabrica": "7125"
            }
          }
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
    Decimal expectedVolume = Decimal.parse("43128.39"); // Replace with actual expected volume

    expect(result.toString(), expectedVolume.toString(), reason: "Calculated volume does not match expected value.");
  });

  test('Volume calculation should return expected value', () {
    config = presetManager.loadPreset(config, "F30");
    Decimal result = calculator.calculateVolumeClick().round(scale: 2);

    // Expected result (this should be updated based on your expected calculations)
    Decimal expectedVolume = Decimal.parse("19004.75"); // Replace with actual expected volume

    expect(result.toString(), expectedVolume.toString(), reason: "Calculated volume does not match expected value.");
  });
  test('Volume calculation should return expected value', () {
    config = presetManager.loadPreset(config, "F37");
    Decimal result = calculator.calculateVolumeClick().round(scale: 2);

    // Expected result (this should be updated based on your expected calculations)
    Decimal expectedVolume = Decimal.parse("7200.26"); // Replace with actual expected volume

    expect(result.toString(), expectedVolume.toString(), reason: "Calculated volume does not match expected value.");
  });;;;;;;;;;;;;;;;;;;;;;;;;;;;;
  test('Volume calculation should return expected value', () {
    config = presetManager.loadPreset(config, "SF13");
    Decimal result = calculator.calculateVolumeClick().round(scale: 2);

    // Expected result (this should be updated based on your expected calculations)
    Decimal expectedVolume = Decimal.parse("14009.82"); // Replace with actual expected volume

    expect(result.toString(), expectedVolume.toString(), reason: "Calculated volume does not match expected value.");
  });;;;;;;;;;;;;;;;;;;;;;;;;;;;;

  test('Volume calculation should return expected value', () {
    config = presetManager.loadPreset(config, "SF11");
    Decimal result = calculator.calculateVolumeClick().round(scale: 2);

    // Expected result (this should be updated based on your expected calculations)
    Decimal expectedVolume = Decimal.parse("7250.19"); // Replace with actual expected volume

    expect(result.toString(), expectedVolume.toString(), reason: "Calculated volume does not match expected value.");
  });;;;;;;;;;;;;;;;;;;;;;;;;;;;;

  test('Volume calculation should return expected value', () {
    config = presetManager.loadPreset(config, "F17");
    Decimal result = calculator.calculateVolumeClick().round(scale: 2);

    // Expected result (this should be updated based on your expected calculations)
    Decimal expectedVolume = Decimal.parse("7123.95"); // Replace with actual expected volume

    expect(result.toString(), expectedVolume.toString(), reason: "Calculated volume does not match expected value.");
  });;;;;;;;;;;;;;;;;;;;;;;;;;;;;
});
}
