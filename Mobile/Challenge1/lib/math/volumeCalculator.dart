
import 'package:decimal/decimal.dart';
import 'dart:math' as math;

import '../services/config_manager.dart';

class VolumeCalculator {
  final ConfigManager config;
  Decimal volumeTotal = Decimal.zero;
  final Decimal pi = Decimal.parse(math.pi.toString()); // Match C#'s Math.PI

  VolumeCalculator(this.config);


  //-------------------------------------------------------//
  //----------NOT-MY-CODE----------------------------------//
  Decimal calculateVolumeClick() {
    try {
      // Retrieve boolean values from config
      bool coneBaseCheckBox = config.isSelected("Base", "Cone");
      bool cilindroBaseCheckBox = !coneBaseCheckBox;
      bool centradoCheckBox = config.isSelected("Pescoço", "Centrado");
      bool naoCentradoCheckBox = !centradoCheckBox;
      bool fundoSimCheckBox = config.isSelected("Fundo", "Sim");
      bool portaOvalCheckBox = config.isSelected("Formato Porta", "Oval");
      bool portaRetangularCheckBox = !portaOvalCheckBox;
      bool portaDentro = config.isSelected("Porta", "Interior");

      // Retrieve numeric values from config
      Decimal diametroPescoco = config.getValue("Diametro", "Pescoço");
      Decimal alturaPequenaPescoco = config.getValue("Altura Menor", "Pescoço");
      if (alturaPequenaPescoco == Decimal.fromInt(0)){
        alturaPequenaPescoco = config.getValue("Altura", "Pescoço");
      }
      Decimal diametroBase = config.getValue("Diametro", "Base");

      Decimal diametroPequenoPorta = portaOvalCheckBox ? config.getValue("Diametro Menor", "Porta") : config.getValue("Comprimento", "Porta");
      Decimal diametroGrandePorta = portaOvalCheckBox ? config.getValue("Diametro Maior", "Porta") : config.getValue("Largura", "Porta");


      Decimal espessura = config.getValue("Profundidade", "Porta");
      Decimal alturaTotal = config.getValue("Altura Total", "Geral");

      // Optional values
      Decimal anguloPescoco = config.getValue("Angulo", "Pescoço");
      Decimal hipotenusa = config.getValue("Hipotenusa", "Topo");
      Decimal hipotenusaFundo = config.getValue("Hipotenusa", "Fundo");
      Decimal diametroTubo = config.getValue("Diametro", "Fundo");
      Decimal comprimentoTubo = config.getValue("Comprimento", "Fundo");
      Decimal alturaGrandePescoco = config.getValue("Altura Maior", "Pescoço");
      Decimal arredondamentoBase = config.getValue("Arredondamento", "Base");
      if (arredondamentoBase == Decimal.fromInt(-1)){
        arredondamentoBase = Decimal.fromInt(5);
      }

      // Initialize total volume
      Decimal volumeTotal = Decimal.zero;
      Decimal raioPescoco = (diametroPescoco / Decimal.fromInt(2)).toDecimal();
      Decimal raioBase = (diametroBase / Decimal.fromInt(2)).toDecimal();
      Decimal volumePorta = Decimal.zero;
      Decimal raioBaixoTopo = Decimal.zero;
      Decimal alturaTopo = Decimal.zero;
      Decimal alturaAux = Decimal.zero;
      Decimal diferencaFundo = Decimal.zero;

      // Print debug values
      print("Altura Total: $alturaTotal");
      print("Altura Pescoço: $alturaPequenaPescoco");
      print("Altura Maior Pescoço: $alturaGrandePescoco");
      print("Ângulo Pescoço: $anguloPescoco");
      print("Diâmetro Pescoço: $diametroPescoco");
      print("Diâmetro Base: $diametroBase");
      print("Hipotenusa Topo: $hipotenusa");
      print("Arredondamento Base: $arredondamentoBase");
      print("Tipo de Porta: ${portaOvalCheckBox ? "Oval" : portaRetangularCheckBox ? "Retangular" : "Nenhuma"}");
      print("Espessura da Porta: $espessura");
      print("Eixo Maior Porta: $diametroGrandePorta");
      print("Eixo Menor Porta: $diametroPequenoPorta");
      print("Posição da Porta: ${portaDentro ? "Interior" : "Exterior"}");
      print("Fundo S/N: $fundoSimCheckBox");
      print("Diametro Tubo: $diametroTubo");
      print("Hipotenusa Fundo: $hipotenusaFundo");
      print("Compimento Tubo: $comprimentoTubo");
      // 1) Handle Cone Base
      if (coneBaseCheckBox) {
        double anguloRad = (anguloPescoco.toDouble() - (90.0)) *
            ((math.pi) / (180.0));

        if (centradoCheckBox) {
          double cosVal = math.cos(anguloRad);
          raioBaixoTopo = raioPescoco + (hipotenusa * Decimal.parse(cosVal.toString()));

          try {
            double sinVal = math.sin(anguloRad);
            alturaTopo = hipotenusa * Decimal.parse(sinVal.toString());
          } catch (e) {
            print("Altura impossível de calcular!");
            return Decimal.fromInt(-1);
          }
        }

        if (naoCentradoCheckBox) {
          raioBaixoTopo = Decimal.parse(math.cos(anguloRad).toString());
        }
      }

      // 2) Handle Cylindrical Base
      if (cilindroBaseCheckBox) {
        raioBaixoTopo = raioBase;

        if (centradoCheckBox) {
          try {
            double anguloPescocoRad = (anguloPescoco.toDouble() - 90.0) * math.pi / 180;
            double tanVal = math.tan(anguloPescocoRad);
            alturaTopo = (((diametroBase - diametroPescoco) / Decimal.fromInt(2)).toDecimal(scaleOnInfinitePrecision: 31) *
                Decimal.parse(tanVal.toString()));
          } catch (e) {
            print("Altura impossível de calcular!");
            return Decimal.fromInt(-1);
          }
        }
      }

      print("Altura Tronco Cone: $alturaTopo");

      Decimal volumePescoco = Decimal.zero;
      Decimal volumeTopo = Decimal.zero;

      // 3) Calculate Neck and Top Volumes
      if (centradoCheckBox){

         volumePescoco = pi * (raioPescoco * raioPescoco) * alturaPequenaPescoco;
         volumeTopo = ((Decimal.one / Decimal.fromInt(3)).toDecimal(scaleOnInfinitePrecision: 31)) * pi * alturaTopo *
            ((raioBaixoTopo * raioBaixoTopo) + (raioPescoco * raioPescoco) + (raioPescoco * raioBaixoTopo));

         print("Volume pescoço: $volumePescoco");
         print("Volume tronco cone: $volumeTopo");
      }
      else{
        alturaTopo = ((raioBaixoTopo * (alturaGrandePescoco - alturaPequenaPescoco)) / (raioPescoco * Decimal.fromInt(2))).toDecimal();
        volumePescoco = pi * raioPescoco * raioPescoco * ((alturaGrandePescoco + alturaPequenaPescoco) / Decimal.fromInt(2)).toDecimal();
        volumeTopo = (Decimal.one / Decimal.fromInt(3)).toDecimal(scaleOnInfinitePrecision: 31) * pi * raioBaixoTopo * raioBaixoTopo * alturaTopo;
      }

      volumeTotal += volumePescoco + volumeTopo;
      alturaAux = alturaTopo + alturaPequenaPescoco;

      // 4) Calculate Base Volume
      if (coneBaseCheckBox) {
        Decimal alturaBase = Decimal.zero;

        if (fundoSimCheckBox){
            alturaBase = config.getValue("Altura Base", "Geral");
        } else {
          print(alturaTotal);
          print(alturaAux);
          alturaBase = alturaTotal - alturaAux;

          Decimal volumeFundoReto = (pi * raioBase * raioBase *
              arredondamentoBase);
          Decimal parte1VolumeRedondo = (Decimal.fromInt(2) * pi *
              ((arredondamentoBase.pow(3)).toDecimal(
                  scaleOnInfinitePrecision: 31) / (Decimal.fromInt(3)))
                  .toDecimal(scaleOnInfinitePrecision: 31));
          Decimal parte2VolumeRedondo = (arredondamentoBase * pi *
              ((diametroBase / Decimal.fromInt(2)).toDecimal() - arredondamentoBase).pow(2).toDecimal());
          Decimal parte3VolumeRedondo = ((((diametroBase / Decimal.fromInt(2)).toDecimal() - arredondamentoBase) * (pi * arredondamentoBase).pow(2).toDecimal()) / Decimal.fromInt(2)).toDecimal();

          Decimal volumeFundoRedondo = parte1VolumeRedondo +
              parte2VolumeRedondo + parte3VolumeRedondo;

          diferencaFundo = volumeFundoReto - volumeFundoRedondo;
          volumeTotal -= diferencaFundo;
        }

          Decimal volumeBase = (Decimal.one / Decimal.fromInt(3)).toDecimal(scaleOnInfinitePrecision: 31) *
              pi * alturaBase *  ((raioBaixoTopo * raioBaixoTopo) + (raioBase * raioBase) + (raioBase * raioBaixoTopo));

          print("Volume Base Cone: $volumeBase");

          volumeTotal += volumeBase;
      }
      if (cilindroBaseCheckBox){
        Decimal alturaBase = Decimal.zero;
        Decimal volumeBase = Decimal.zero;

        if (fundoSimCheckBox){
          alturaBase = config.getValue("Altura Base", "Geral");
        }
        else {
          alturaBase = alturaTotal - alturaAux;

          Decimal volumeFundoReto = (pi * raioBase * raioBase *
              arredondamentoBase);
          Decimal parte1VolumeRedondo = (Decimal.fromInt(2) * pi *
              ((arredondamentoBase.pow(3)).toDecimal(
                  scaleOnInfinitePrecision: 31) / (Decimal.fromInt(3)))
                  .toDecimal(scaleOnInfinitePrecision: 31));
          Decimal parte2VolumeRedondo = (arredondamentoBase * pi *
              ((diametroBase / Decimal.fromInt(2)).toDecimal() - arredondamentoBase).pow(2).toDecimal());
          Decimal parte3VolumeRedondo = ((((diametroBase / Decimal.fromInt(2)).toDecimal() - arredondamentoBase) * (pi * arredondamentoBase).pow(2).toDecimal()) / Decimal.fromInt(2)).toDecimal();

          Decimal volumeFundoRedondo = parte1VolumeRedondo +
              parte2VolumeRedondo + parte3VolumeRedondo;

          diferencaFundo = volumeFundoReto - volumeFundoRedondo;

          print("Diferença Fundo Arr: ${diferencaFundo}");
          volumeTotal -= diferencaFundo;
        }

        Decimal areaBase = pi * raioBase * raioBase;

        volumeBase = areaBase * alturaBase;

        volumeTotal += volumeBase;
        print("Volume Base: ${volumeBase}");


        raioBaixoTopo = raioBase;
      }
      if (fundoSimCheckBox){
        Decimal raioTubo = (diametroTubo / Decimal.fromInt(2)).toDecimal();
        
        Decimal cateto = raioBase - raioTubo;
        Decimal alturaFundo = Decimal.zero;
        try{
          alturaFundo = Decimal.parse(math.sqrt(hipotenusaFundo.pow(2).toDouble() - cateto.pow(2).toDouble()).toString());
        } catch (e){
          print("Impossivel");
        }
        Decimal areaBaseTubo = pi * raioTubo * raioTubo;

        Decimal volumeConeFundo = Decimal.parse((1.0 /3.0).toString()) * pi * alturaFundo * raioBase * raioBase;
        Decimal volumeTuboFundo = areaBaseTubo * comprimentoTubo;

        volumeTotal += volumeConeFundo + volumeTuboFundo;

        print("Volume Fundo: ${volumeTuboFundo + volumeConeFundo}");
      }

        // 5) Calculate Porta Volume
        if (portaOvalCheckBox) {
          Decimal raioPequenoPorta = (diametroPequenoPorta / Decimal.fromInt(2)).toDecimal();
          Decimal raioGrandePorta = (diametroGrandePorta / Decimal.fromInt(2)).toDecimal();
          volumePorta = Decimal.parse(math.pi.toString()) * raioPequenoPorta * raioGrandePorta * espessura;
        } else if (portaRetangularCheckBox) {
          volumePorta = diametroPequenoPorta * diametroGrandePorta * espessura;
        }

        print("Volume Porta: $volumePorta");

        if (portaDentro) {
          volumeTotal -= volumePorta;
        } else {
          volumeTotal += volumePorta;
        }

        print("Resultado Final (L): ${(volumeTotal / Decimal.fromInt(1000)).toDecimal(scaleOnInfinitePrecision: 31)}");
        return (volumeTotal / Decimal.fromInt(1000)).toDecimal(scaleOnInfinitePrecision: 31);
    } on FormatException {
      print("Por favor, insira valores numéricos válidos.");
      return Decimal.fromInt(-1);
    }
  }

  Decimal? tryGetValue(String n1, String n2) {
    Decimal res = config.getValue(n1, n2);
    return res != Decimal.fromInt(-1) ? res : null;
  }
}

