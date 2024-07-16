import 'package:readability/readability.dart';

void main() {
  var parser = ReadabilityParser();
  Article article = parser.parse('https://www.bbc.com/sport/football/articles/cl7y4z82z2do');
  print(article.toString());
}
