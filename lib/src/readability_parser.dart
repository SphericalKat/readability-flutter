import 'dart:ffi' as ffi;
import 'dart:ffi';
import 'package:ffi/ffi.dart';
import 'dart:io' show Platform;

import 'package:readability/src/article.dart';

final class CArticle extends Struct {
  external Pointer<Utf8> title;
  external Pointer<Utf8> author;
  @Int32()
  external int length;
  external Pointer<Utf8> excerpt;
  external Pointer<Utf8> site_name;
  external Pointer<Utf8> image_url;
  external Pointer<Utf8> favicon_url;
  external Pointer<Utf8> content;
  external Pointer<Utf8> text_content;
  external Pointer<Utf8> language;
  external Pointer<Utf8> published_time;
  external Pointer<Utf8> err;

  @Int32()
  external int success;
}

typedef ParseFunc = CArticle Function(Pointer<Utf8> url);
typedef ParseDart = CArticle Function(Pointer<Utf8> url);

typedef FreeArticleFunc = Void Function(CArticle article);
typedef FreeArticleDart = void Function(CArticle article);

class ReadabilityParser {
  late final DynamicLibrary _lib;
  late final ParseDart _parse;
  late final FreeArticleDart _freeArticle;

  ReadabilityParser() {
    _lib = ffi.DynamicLibrary.open(_getDylibPath());
    _parse = _lib.lookupFunction<ParseFunc, ParseDart>('Parse');
    _freeArticle =
        _lib.lookupFunction<FreeArticleFunc, FreeArticleDart>('FreeArticle');
  }

  Article parse(String url) {
    // Convert the URL to a native string.
    final urlPtr = url.toNativeUtf8();

    // Call the native function.
    final article = _parse(urlPtr);

    // Free the memory allocated for the URL.
    malloc.free(urlPtr);


    // Convert the native article to a Dart article.
    final articleDart = Article(
      title: article.title == nullptr ? null : article.title.toDartString(),
      author: article.author == nullptr ? null : article.author.toDartString(),
      length: article.length,
      excerpt: article.excerpt == nullptr ? null : article.excerpt.toDartString(),
      siteName: article.site_name == nullptr ? null : article.site_name.toDartString(),
      imageUrl: article.image_url == nullptr ? null : article.image_url.toDartString(),
      faviconUrl: article.favicon_url == nullptr ? null : article.favicon_url.toDartString(),
      content: article.content == nullptr ? null : article.content.toDartString(),
      textContent: article.text_content == nullptr ? null : article.text_content.toDartString(),
      language: article.language == nullptr ? null : article.language.toDartString(),
      publishedTime: article.published_time == nullptr ? null : article.published_time.toDartString(),
    );

    // Free the memory allocated for the article.
    _freeArticle(article);

    return articleDart;
  }
}

String _getDylibPath() {
  if (Platform.isWindows) {
    return 'native/windows/x64/readability.dll';
  } else if (Platform.isMacOS) {
    return 'native/macos/x64/readability.dylib';
  } else if (Platform.isLinux) {
    return 'native/linux/x86-64/libreadability.so';
  } else {
    throw UnsupportedError('This platform is not supported.');
  }
}
