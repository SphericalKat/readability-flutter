// You have generated a new plugin project without specifying the `--platforms`
// flag. An FFI plugin project that supports no platforms is generated.
// To add platforms, run `flutter create -t plugin_ffi --platforms <platforms> .`
// in this directory. You can also find a detailed instruction on how to
// add platforms in the `pubspec.yaml` at
// https://flutter.dev/docs/development/packages-and-plugins/developing-packages#plugin-platforms.

import 'dart:async';
import 'dart:ffi';
import 'dart:io';
import 'dart:isolate';
import 'package:ffi/ffi.dart';
import 'package:readability/article.dart';

import 'readability_bindings_generated.dart';

/// A very short-lived native function.
///
/// For very short-lived functions, it is fine to call them on the main isolate.
/// They will block the Dart execution while running the native function, so
/// only do this for native functions which are guaranteed to be short-lived.
// int sum(int a, int b) => _bindings.sum(a, b);

/// A longer lived native function, which occupies the thread calling it.
///
/// Do not call these kind of native functions in the main isolate. They will
/// block Dart execution. This will cause dropped frames in Flutter applications.
/// Instead, call these native functions on a separate isolate.
///
/// Modify this to suit your own use case. Example use cases:
///
/// 1. Reuse a single isolate for various different kinds of requests.
/// 2. Use multiple helper isolates for parallel execution.
Future<ArticleResponse> parseAsync(String url) async {
  final SendPort helperIsolateSendPort = await _helperIsolateSendPort;
  final int requestId = _nextParseRequestId++;
  final _ParseRequest request = _ParseRequest(url, requestId);
  final Completer<ArticleResponse> completer = Completer<ArticleResponse>();
  _parseRequests[requestId] = completer;
  helperIsolateSendPort.send(request);
  return completer.future;
}

const String _libName = 'readability';

/// The dynamic library in which the symbols for [ReadabilityBindings] can be found.
final DynamicLibrary _dylib = () {
  if (Platform.isMacOS || Platform.isIOS) {
    return DynamicLibrary.open('$_libName.framework/$_libName');
  }
  if (Platform.isAndroid || Platform.isLinux) {
    return DynamicLibrary.open('lib$_libName.so');
  }
  if (Platform.isWindows) {
    return DynamicLibrary.open('$_libName.dll');
  }
  throw UnsupportedError('Unknown platform: ${Platform.operatingSystem}');
}();

/// The bindings to the native functions in [_dylib].
final ReadabilityBindings _bindings = ReadabilityBindings(_dylib);

/// A request to compute `sum`.
///
/// Typically sent from one isolate to another.
class _ParseRequest {
  final String url;
  final int id;

  const _ParseRequest(this.url, this.id);
}

class ArticleResponse {
  final Article article;
  final int id;

  ArticleResponse({
    required this.article,
    required this.id,
  });
}

/// Counter to identify [_ParseRequest]s and [ArticleResponse]s.
int _nextParseRequestId = 0;

/// Mapping from [_ParseRequest] `id`s to the completers corresponding to the correct future of the pending request.
final Map<int, Completer<ArticleResponse>> _parseRequests =
    <int, Completer<ArticleResponse>>{};

/// The SendPort belonging to the helper isolate.
Future<SendPort> _helperIsolateSendPort = () async {
  // The helper isolate is going to send us back a SendPort, which we want to
  // wait for.
  final Completer<SendPort> completer = Completer<SendPort>();

  // Receive port on the main isolate to receive messages from the helper.
  // We receive two types of messages:
  // 1. A port to send messages on.
  // 2. Responses to requests we sent.
  final ReceivePort receivePort = ReceivePort()
    ..listen((dynamic data) {
      if (data is SendPort) {
        // The helper isolate sent us the port on which we can sent it requests.
        completer.complete(data);
        return;
      }
      if (data is ArticleResponse) {
        // The helper isolate sent us a response to a request we sent.
        final Completer<ArticleResponse> completer = _parseRequests[data.id]!;
        _parseRequests.remove(data.id);
        completer.complete(data);
        return;
      }
      throw UnsupportedError('Unsupported message type: ${data.runtimeType}');
    });

  // Start the helper isolate.
  await Isolate.spawn((SendPort sendPort) async {
    final ReceivePort helperReceivePort = ReceivePort()
      ..listen((dynamic data) {
        // On the helper isolate listen to requests and respond to them.
        if (data is _ParseRequest) {
          final urlPointer = data.url.toNativeUtf8();
          final CArticle article = _bindings.Parse(urlPointer);

          // Free the native string.
          calloc.free(urlPointer);

          // Convert the native article to a Dart article.
          final articleDart = Article(
            title:
                article.title == nullptr ? null : article.title.toDartString(),
            author: article.author == nullptr
                ? null
                : article.author.toDartString(),
            length: article.length,
            excerpt: article.excerpt == nullptr
                ? null
                : article.excerpt.toDartString(),
            siteName: article.site_name == nullptr
                ? null
                : article.site_name.toDartString(),
            imageUrl: article.image_url == nullptr
                ? null
                : article.image_url.toDartString(),
            faviconUrl: article.favicon_url == nullptr
                ? null
                : article.favicon_url.toDartString(),
            content: article.content == nullptr
                ? null
                : article.content.toDartString(),
            textContent: article.text_content == nullptr
                ? null
                : article.text_content.toDartString(),
            language: article.language == nullptr
                ? null
                : article.language.toDartString(),
            publishedTime: article.published_time == nullptr
                ? null
                : article.published_time.toDartString(),
          );
          ArticleResponse articleDartResponse =
              ArticleResponse(article: articleDart, id: data.id);

          // Free the native article.
          _bindings.FreeArticle(article);

          sendPort.send(articleDartResponse);
          return;
        }
        throw UnsupportedError('Unsupported message type: ${data.runtimeType}');
      });

    // Send the port to the main isolate on which we can receive requests.
    sendPort.send(helperReceivePort.sendPort);
  }, receivePort.sendPort);

  // Wait until the helper isolate has sent us back the SendPort on which we
  // can start sending requests.
  return completer.future;
}();
