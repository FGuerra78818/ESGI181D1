import 'package:decimal/decimal.dart';
import 'package:test/test.dart';
import 'package:challenge1/classes/option.dart';
import 'package:challenge1/classes/param.dart';
import 'package:pair/pair.dart';

void main() {
  group('getNeededValues', () {
    test('returns empty map when no params exist', () {
      final option = Option(name: 'Test', params: []);
      expect(option.getNeededValues(), isEmpty);
    });

    test('returns values from single selected param', () {
      final param = Param.createParam(
        'Speed',
        {'gear': ['High', 'Low']},
        0,
      );

      final option = Option(
        name: 'Motor',
        params: [param],
        selected: 0,
      );

      expect(option.getNeededValues(), equals({
        'gear': [
          Pair('High', Decimal.zero),
          Pair('Low', Decimal.zero),
        ]
      }));
    });

    test('returns correct param when multiple exist', () {
      final params = [
        Param.createParam('Voltage', {'level': ['12V']}, 0),
        Param.createParam('Current', {'rating': ['5A']}, 1),
      ];

      final option = Option(
        name: 'Power Supply',
        params: params,
        selected: 1,
      );

      expect(option.getNeededValues(), equals({
        'rating': [Pair('5A', Decimal.zero)]
      }));
    });

    test('handles complex parameter structures', () {
      final param = Param.createParam(
        'Specs',
        {
          'material': ['Aluminum', 'Steel'],
          'finish': ['Polished']
        },
        0,
      );

      final option = Option(
        name: 'Bracket',
        params: [param],
        selected: 0,
      );

      expect(option.getNeededValues(), equals({
        'material': [
          Pair('Aluminum', Decimal.zero),
          Pair('Steel', Decimal.zero),
        ],
        'finish': [Pair('Polished', Decimal.zero)]
      }));
    });
  });

}
