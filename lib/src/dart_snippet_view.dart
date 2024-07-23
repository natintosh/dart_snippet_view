import 'package:flutter/material.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:dart_style/dart_style.dart';

class DartSnippetView extends StatefulWidget {
  final String code;
  final double height;
  final double width;
  final bool runFormatter;

  const DartSnippetView({
    super.key,
    required this.code,
    required this.height,
    required this.width,
    this.runFormatter = false,
  });

  @override
  State<StatefulWidget> createState() => _DartSnippetViewState();
}

class _DartSnippetViewState extends State<DartSnippetView> {
  late InAppWebViewController _webViewController;
  String? code;

  @override
  void initState() {
    super.initState();
    if (widget.runFormatter) {
      code = DartFormatter().format(widget.code);
    } else {
      code = widget.code;
    }
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: widget.height,
      width: widget.width,
      child: InAppWebView(
        initialFile: "packages/dart_snippet_view/assets/code_viewer.html",
        initialSettings: InAppWebViewSettings(javaScriptEnabled: true),
        onWebViewCreated: (InAppWebViewController controller) {
          _webViewController = controller;
        },
        onLoadStop: (InAppWebViewController controller, Uri? url) {
          _updateCodeContent();
        },
      ),
    );
  }

  void _updateCodeContent() {
    if (code != null) {
      _webViewController.evaluateJavascript(
          source: "updateCodeContent('${code!.replaceAll("'", "\\'")}');");
    }
  }
}
