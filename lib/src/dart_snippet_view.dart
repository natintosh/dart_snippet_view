import 'package:dart_style/dart_style.dart';
import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';

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
  late WebViewController _controller;
  String? code;

  @override
  void initState() {
    super.initState();
    if (widget.runFormatter) {
      code = DartFormatter().format(widget.code);
    } else {
      code = widget.code;
    }

    _controller = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..loadFlutterAsset('packages/dart_snippet_view/assets/code_viewer.html')
      ..setNavigationDelegate(
        NavigationDelegate(
          onPageFinished: (String url) {
            _updateCodeContent();
          },
        ),
      );
  }

  void _updateCodeContent() {
    _controller.runJavaScript(
        "updateCodeContent('${code?.replaceAll("'", "\\'")}');"
    );
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: widget.height,
      width: widget.width,
      child: WebViewWidget(controller: _controller),
    );
  }
}
