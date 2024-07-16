import 'package:readability/readability.dart';
import 'package:test/test.dart';

void main() {
  group('A group of tests', () {
    final ReadabilityParser parser = ReadabilityParser();

    setUp(() {
      // Additional setup goes here.
    });

    test('First Test', () {
      final Article article = parser.parse('https://www.bbc.com/sport/football/articles/cl7y4z82z2do');
      expect(article.title, isNotNull);
    });
  });
}
