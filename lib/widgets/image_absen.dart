import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';

import '../infrastructures/image/infrastructures/image_repository.dart';
import '../network_state/application/network_state_notifier.dart';
import '../style/style.dart';

final displayImageProvider = StateProvider<bool>((ref) {
  return false;
});

final imageErrorProvider = StateProvider<bool>((ref) {
  return false;
});

class ImageAbsen extends ConsumerStatefulWidget {
  const ImageAbsen();

  @override
  ConsumerState<ImageAbsen> createState() => _ImageAbsenState();
}

class _ImageAbsenState extends ConsumerState<ImageAbsen> {
  InAppWebViewController? webViewController;
  InAppWebViewController? webViewControllerDummy;

  @override
  Widget build(BuildContext context) {
    final imageUrl = ref.watch(imageUrlProvider);
    final imageError = ref.watch(imageErrorProvider);
    final displayImage = ref.watch(displayImageProvider);
    final networkState = ref.watch(networkStateNotifierProvider);

    return networkState.when(
        online: () => SizedBox(
            height: displayImage
                ? 425
                : imageError == false
                    ? 50
                    : 1,
            child: Stack(
              children: [
                // Dummy Webview to validate url
                SizedBox(
                  height: 1,
                  width: 1,
                  child: InAppWebView(
                    onWebViewCreated: (controller) {
                      webViewControllerDummy = controller;
                    },
                    initialUrlRequest: URLRequest(url: Uri.parse(imageUrl)),
                    onLoadError: (controller, url, code, message) {
                      debugger();
                      ref.read(displayImageProvider.notifier).state = false;
                    },
                    onLoadStop: (controller, url) async {
                      String html = await controller.evaluateJavascript(
                          source:
                              "window.document.getElementsByTagName('html')[0].outerHTML;");

                      log('html $html');

                      if (html.contains('Runtime Error')) {
                        ref.read(imageErrorProvider.notifier).state = true;
                      } else {
                        ref.read(imageErrorProvider.notifier).state = false;
                      }
                    },
                    onConsoleMessage: (controller, consoleMessage) {
                      print(consoleMessage);
                    },
                  ),
                ),
                if (imageUrl.isNotEmpty && imageError == false)
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(
                        height: 16,
                      ),
                      InkWell(
                        onTap: () => displayImage
                            ? ref.read(displayImageProvider.notifier).state =
                                false
                            : ref.read(displayImageProvider.notifier).state =
                                true,
                        child: Ink(
                          child: Row(
                            children: [
                              Text(
                                'Lokasi Jarak Terdekat',
                                style: Themes.customColor(
                                  13,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              Text(
                                ' : ',
                                style: Themes.customColor(
                                  13,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              displayImage
                                  ? Icon(
                                      Icons.arrow_drop_down_outlined,
                                      color: Theme.of(context)
                                          .secondaryHeaderColor,
                                    )
                                  : Icon(Icons.arrow_right_outlined,
                                      color: Theme.of(context)
                                          .secondaryHeaderColor)
                            ],
                          ),
                        ),
                      ),
                      if (displayImage) ...[
                        SizedBox(
                          height: 8,
                        ),
                        Center(
                          child: Container(
                              height: 350,
                              width: 300,
                              decoration: BoxDecoration(
                                color: Palette.secondaryColor,
                                borderRadius: BorderRadius.circular(12),
                              ),
                              padding: EdgeInsets.all(8),
                              child: IgnorePointer(
                                ignoring: true,
                                child: InAppWebView(
                                  onWebViewCreated: (controller) {
                                    webViewController = controller;
                                  },
                                  initialUrlRequest:
                                      URLRequest(url: Uri.parse(imageUrl)),
                                  onLoadStop: (controller, url) async {
                                    String html =
                                        await controller.evaluateJavascript(
                                            source:
                                                "window.document.getElementsByTagName('html')[0].outerHTML;");

                                    if (html.contains('Runtime Error')) {
                                      ref
                                          .read(displayImageProvider.notifier)
                                          .state = false;
                                    }
                                  },
                                  onConsoleMessage:
                                      (controller, consoleMessage) {
                                    print(consoleMessage);
                                  },
                                ),
                              )),
                        )
                      ]
                    ],
                  ),
              ],
            )),
        offline: () => Container());
  }
}
