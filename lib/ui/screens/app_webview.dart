import 'package:flutter/material.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';

import '../../core/routes/router.dart';
import '../widgets/buttons/back_arrow_button.dart';
import '../widgets/loaders/circular_indicator.dart';

class AppWebview extends StatefulWidget {
  const AppWebview({super.key, required this.args});

  final WebviewArgs args;

  @override
  State<AppWebview> createState() => _AppWebviewState();
}

class _AppWebviewState extends State<AppWebview> {
  InAppWebViewController? webViewController;

  var loadingPercentage = 0;

  @override
  Widget build(BuildContext context) {
    // return WillPopScope(
    //   onWillPop: () async {
    //     return await showModalBottomSheet(
    //       context: context,
    //       isScrollControlled: true,
    //       isDismissible: false,
    //       shape: const RoundedRectangleBorder(
    //         borderRadius: BorderRadius.vertical(top: Radius.circular(25.0)),
    //       ),
    //       builder: (context) => const ExitAppBottomSheet(),
    //     ) ??
    //         false;
    //   },
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: Padding(padding: EdgeInsets.all(8), child: BackArrowButton()),
        title: Text(widget.args.title ?? 'Rider App'),
      ),
      body: Stack(
        children: [
          InAppWebView(
            initialUrlRequest: URLRequest(url: WebUri(widget.args.url)),
            initialOptions: InAppWebViewGroupOptions(
              crossPlatform: InAppWebViewOptions(transparentBackground: true),
              // android: AndroidInAppWebViewOptions(geolocationEnabled: true),
              // ios: IOSInAppWebViewOptions(allowsInlineMediaPlayback: true),
            ),
            onWebViewCreated: (controller) {
              webViewController = controller;
            },
            onProgressChanged: (controller, progress) =>
                setState(() => loadingPercentage = progress),
            onLoadStart: (controller, url) {
              Center(
                child: CircularIndicator(value: loadingPercentage / 100.0),
              );
              setState(() => loadingPercentage = 0);
            },
            onLoadStop: (controller, url) async {
              // context.read<AppLoaderController>().stopLoading();
              setState(() => loadingPercentage = 100);
            },
            // androidOnGeolocationPermissionsShowPrompt:
            //     (InAppWebViewController controller, String origin) async {
            //   return GeolocationPermissionShowPromptResponse(
            //     origin: origin,
            //     allow: true,
            //     retain: true,
            //   );
            // },
          ),
          if (loadingPercentage < 100)
            Center(child: CircularIndicator(value: loadingPercentage / 100.0)),
        ],
      ),
    );
  }

  @override
  void dispose() {
    super.dispose();
  }
}
