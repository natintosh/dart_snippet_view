import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:dart_style/dart_style.dart';
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
  String? code;

  late WebViewController controller;

  @override
  void initState() {
    super.initState();
    initController();
    if (widget.runFormatter) {
      code = DartFormatter().format(widget.code);
    } else {
      code = widget.code;
    }
    loadResource();
  }

  void initController() {
    controller = WebViewController();
  }

  void loadResource() {
    rootBundle.loadString('packages/dart_snippet_view/assets/code_viewer.html')
        .then((a) {
      controller.loadHtmlString(a.replaceAll('{{CODE}}', code ?? ''));
    });
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: widget.height,
      width: widget.width,
      child: WebViewWidget(
        controller: controller,
      ),
    );
  }
}
