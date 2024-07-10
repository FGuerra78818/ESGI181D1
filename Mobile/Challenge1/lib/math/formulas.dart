import 'dart:math';
import 'package:decimal/decimal.dart';

final Decimal pi = Decimal.parse('3.1415926535897932');

Decimal cylinderVolumeFormula(Decimal height, Decimal areaBase){
  return height * areaBase;
}

Decimal conicBodyVolumeFormula(Decimal height, Decimal baseRadius, Decimal topRadius){
  return Decimal.parse((1/3).toString()) * pi * height * (baseRadius * baseRadius + topRadius * topRadius + topRadius * baseRadius);
}