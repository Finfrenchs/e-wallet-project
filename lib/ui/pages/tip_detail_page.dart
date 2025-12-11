import 'package:e_wallet/shared/theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';

class TipDetailPage extends StatefulWidget {
  final String title;
  final String url;

  const TipDetailPage({
    super.key,
    required this.title,
    required this.url,
  });

  @override
  State<TipDetailPage> createState() => _TipDetailPageState();
}

class _TipDetailPageState extends State<TipDetailPage> {
  double _progress = 0;
  late InAppWebViewController webViewController;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          widget.title,
          style: blackTextStyle.copyWith(
            fontSize: 16,
            fontWeight: semiBold,
          ),
        ),
        backgroundColor: whiteColor,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: blackColor),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Column(
        children: [
          _progress < 1.0
              ? LinearProgressIndicator(
                  value: _progress,
                  backgroundColor: lightBackgroundColor,
                  valueColor: AlwaysStoppedAnimation<Color>(primaryColor),
                )
              : Container(),
          Expanded(
            child: InAppWebView(
              initialUrlRequest: URLRequest(url: WebUri(widget.url)),
              onWebViewCreated: (controller) {
                webViewController = controller;
              },
              onProgressChanged: (controller, progress) {
                setState(() {
                  _progress = progress / 100;
                });
              },
              initialSettings: InAppWebViewSettings(
                useShouldOverrideUrlLoading: true,
                mediaPlaybackRequiresUserGesture: false,
                javaScriptEnabled: true,
                javaScriptCanOpenWindowsAutomatically: true,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
