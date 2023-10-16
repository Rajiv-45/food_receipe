import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';

class RecipeView extends StatefulWidget {
  String url;
  RecipeView({super.key, required this.url});

  @override
  State<RecipeView> createState() => _RecipeViewState();
}

class _RecipeViewState extends State<RecipeView> {
  //flutterWebViewController
  @override
  Widget build(BuildContext context) {
    WebViewController controller = WebViewController()
      ..loadRequest(Uri.parse(widget.url));
    return Scaffold(
      appBar: AppBar(title: Text("Recipe App")),
      body: Container(
        child: WebViewWidget(controller: controller),
      ),
    );
  }
}
