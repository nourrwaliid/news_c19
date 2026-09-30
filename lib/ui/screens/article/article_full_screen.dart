import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';

class ArticleFullScreen extends StatefulWidget {
  final String url;
  const ArticleFullScreen({super.key, required this.url});

  @override
  State<ArticleFullScreen> createState() => _ArticleFullScreenState();
}

class _ArticleFullScreenState extends State<ArticleFullScreen> {
  late final WebViewController controller;

  @override
  void initState() {
    super.initState();
    controller = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..loadRequest(Uri.parse(widget.url));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Article")),
      body: WebViewWidget(controller: controller),
    );
  }
}