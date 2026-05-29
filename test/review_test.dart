import 'package:flutter_test/flutter_test.dart';
import 'package:vaistu_priminimo_sistema/models/review.dart';

void main() {
  group('Review', () {
    test('creates Review with score and review', () {
      final review = Review(score: 5, review: 'Excellent medication!');
      expect(review.score, 5);
      expect(review.review, 'Excellent medication!');
    });

    test('creates Review with score and null review', () {
      final review = Review(score: 3, review: null);
      expect(review.score, 3);
      expect(review.review, isNull);
    });

    test('toMap includes score and review when review is not null', () {
      final review = Review(score: 4, review: 'Good');
      final map = review.toMap();
      expect(map, {'score': 4, 'review': 'Good'});
    });

    test('toMap includes only score when review is null', () {
      final review = Review(score: 2, review: null);
      final map = review.toMap();
      expect(map, {'score': 2});
      expect(map.containsKey('review'), false);
    });
  });
}
