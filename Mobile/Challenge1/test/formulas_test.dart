import 'package:challenge1/math/formulas.dart';
import 'package:test/test.dart';
import 'package:decimal/decimal.dart';

void main() {
  group('Cylinder Volume Formula', () {
    test('should return correct volume', () {
      final height = Decimal.parse('256');
      final radius = Decimal.parse('65');
      final expectedVolume = Decimal.parse('3397946.61412272032512');

      final result = cylinderVolumeFormula(height, radius);

      expect(result, equals(expectedVolume));
    });
  });

  group('Conic Body Volume Formula', () {
    test('should return correct volume', () {
      final height = Decimal.parse('10');
      final baseRadius = Decimal.parse('3');
      final topRadius = Decimal.parse('1');
      final expectedVolume = Decimal.parse('136');

      final result = conicBodyVolumeFormula(height, baseRadius, topRadius);

      expect((result).toBigInt(), equals((expectedVolume).toBigInt()));
    });
  });

  group('radiusFromDiameter', () {
    test('should return the radius from the given diameter', () {
      final diameter = Decimal.parse("10");
      final expectedRadius = Decimal.parse("5");

      expect(radiusFromDiameter(diameter), equals(expectedRadius));
    });

    test('should handle zero diameter', () {
      final diameter = Decimal.parse("0");
      final expectedRadius = Decimal.parse("0");

      expect(radiusFromDiameter(diameter), equals(expectedRadius));
    });

    test('should handle negative diameter', () {
      final diameter = Decimal.parse("-10");
      final expectedRadius = Decimal.parse("-5");

      expect(radiusFromDiameter(diameter), equals(expectedRadius));
    });
  });

  group('offCenteredCylinderFromACone', () {
    test('should calculate the correct volume of the off-centered cylinder from a cone', () {
      final radius = Decimal.parse("3");
      final bigHeight = Decimal.parse("8");
      final smallHeight = Decimal.parse("4");

      // pi * r^2 * ( (bigHeight + smallHeight) / 2 )
      final expectedVolume = Decimal.parse("$pi") * radius * radius * Decimal.parse("6");

      expect(offCenteredCylinderFromACone(radius, bigHeight, smallHeight), equals(expectedVolume));
    });

    test('should handle zero heights', () {
      final radius = Decimal.parse("3");
      final bigHeight = Decimal.parse("0");
      final smallHeight = Decimal.parse("0");

      final expectedVolume = Decimal.parse("0");

      expect(offCenteredCylinderFromACone(radius, bigHeight, smallHeight), equals(expectedVolume));
    });

    test('should handle negative heights', () {
      final radius = Decimal.parse("3");
      final bigHeight = Decimal.parse("-8");
      final smallHeight = Decimal.parse("4");

      final expectedVolume = Decimal.parse("$pi") * radius * radius * Decimal.parse("-2");

      expect(offCenteredCylinderFromACone(radius, bigHeight, smallHeight), equals(expectedVolume));
    });
  });



}
