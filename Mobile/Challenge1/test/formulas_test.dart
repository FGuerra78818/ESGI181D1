import 'package:challenge1/math/formulas.dart';
import 'package:test/test.dart';
import 'package:decimal/decimal.dart';

void main() {
  group('Cylinder Volume Formula', () {
    test('should return correct volume', () {
      final height = Decimal.parse('10');
      final areaBase = Decimal.parse('3.1415926535897932');
      final expectedVolume = Decimal.parse('31.415926535897932');

      final result = cylinderVolumeFormula(height, areaBase);

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
}
