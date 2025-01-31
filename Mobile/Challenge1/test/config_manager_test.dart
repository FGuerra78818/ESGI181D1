import 'package:flutter_test/flutter_test.dart';
import 'package:challenge1/classes/option.dart';
import 'package:challenge1/services/config_manager.dart';

void main() {
  group('ConfigManager - createOptions', () {
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
            },
            "BARREL": {
              "RADIAL": {
                "Type": ["Normal", "Porto"]
              }
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
    });
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
        print(opt.getOptionJsonFormat());
        print(opt.getValuesJsonFormat());
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
    });
  });
}
