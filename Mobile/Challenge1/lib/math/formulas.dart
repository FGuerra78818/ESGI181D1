import 'package:decimal/decimal.dart';

final Decimal pi = Decimal.parse('3.1415926535897932');

Decimal cylinderVolumeFormula(Decimal height, Decimal radius){
  return height * (pi * radius * radius);
}

Decimal conicBodyVolumeFormula(Decimal height, Decimal baseRadius, Decimal topRadius){
  return Decimal.parse((1/3).toString()) * pi * height * (baseRadius * baseRadius + topRadius * topRadius + topRadius * baseRadius);
}

Decimal radiusFromDiameter(Decimal diameter) {
  return Decimal.parse(("${diameter / Decimal.parse("2")}"));
}

Decimal offCenteredCylinderFromACone(Decimal radius, Decimal bigHeight, Decimal smallHeight){
  return (pi * radius*radius *(Decimal.parse("${(bigHeight + smallHeight)/Decimal.parse("2")}")));
}



/**
 * porta
 *
  */


