import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:sneaky_links/flutter_flow/flutter_flow_theme.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'dart:async';

class WebViewClass extends StatefulWidget {
  final String title;
  final String url;

  WebViewClass(this.title, this.url);

  @override
  _WebViewClassState createState() => _WebViewClassState();
}
class _WebViewClassState extends State<WebViewClass> {
  Completer<WebViewController> _controller = Completer<WebViewController>();
  bool isLoading = true;

  @override
  void initState() {
    super.initState();

    print(widget.url);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0.0,
        backgroundColor: Colors.white,
        leading: Padding(
          padding: EdgeInsets.only(left: 0.0),
          child: InkWell(
            onTap: () {
              if (Navigator.canPop(context)) {
                Navigator.pop(context);
              } else {
                SystemNavigator.pop();
              }
            },
            child: Icon(
              Icons.arrow_back_ios,
              size: 30,
              color: Colors.black,
            ),
          ),
        ),
        centerTitle: true,
        title: Text(
          widget.title,
          maxLines: 2,
          textAlign: TextAlign.center,
          overflow: TextOverflow.ellipsis,
          style: TextStyle(color: Colors.black,
          fontSize: 15,),
        ),
      ),
      body: Stack(
        children: [
          WebView(
            initialUrl: widget.url,
            javascriptMode: JavascriptMode.unrestricted,
            onWebViewCreated: (WebViewController webViewController) {
              _controller.complete(webViewController);

            },
            onPageFinished: (finish) {
              print(finish.toString());
              setState(() {
                isLoading = false;
              });
            },
            onPageStarted: (url){
              print(url.toString());
              setState(() {
                isLoading = false;
              });

            },

          ),
          isLoading
              ? Center(
                  child: CircularProgressIndicator(
                  ),
                )
              : Stack(),
        ],
      ),
    );
  }
}
