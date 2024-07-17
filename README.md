# readability

A flutter plugin that wraps the native Readability [library](https://github.com/go-shiori/go-readability) for Android and iOS.

## Usage
Simply call the `parseAsync` method with the URL of the article you want to parse. The method returns a `ArticleResult` object with the title, content, and excerpt of the article.

```dart
import 'package:readability/readability.dart';

final result = await Readability.parseAsync('https://example.com/article');
print(result.title);
print(result.content);
```

An example of how to use this plugin can be found in the `example` directory.
