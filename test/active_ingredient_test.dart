import 'package:flutter_test/flutter_test.dart';
import 'package:vaistu_priminimo_sistema/models/medication/active_ingredient.dart';

void main() {
  group('ActiveIngredient', () {
    test('ibuprofen has correct label', () {
      expect(ActiveIngredient.ibuprofen.getLabel, 'Ibuprofenas');
    });

    test('statin has correct label', () {
      expect(ActiveIngredient.statin.getLabel, 'Statinas');
    });

    test('unspecifeid has correct label', () {
      expect(ActiveIngredient.unspecifeid.getLabel, 'Nenurodyta');
    });
  });
}
