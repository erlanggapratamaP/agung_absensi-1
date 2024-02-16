import 'package:face_net_authentication/widgets/async_value_ui.dart';
import 'package:flutter/material.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../../routes/application/route_names.dart';
import '../../../widgets/v_async_widget.dart';
import '../../../widgets/v_scaffold_widget.dart';
import '../../../style/style.dart';
import '../application/sakit_dtl.dart';
import '../application/sakit_dtl_notifier.dart';

class SakitDtlPageBy extends StatefulHookConsumerWidget {
  const SakitDtlPageBy(
    this.idSakit,
  );
  final int idSakit;

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _SakitDtlPageByState();
}

class _SakitDtlPageByState extends ConsumerState<SakitDtlPageBy> {
  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref
          .read(sakitDtlNotifierProvider.notifier)
          .loadSakitDetail(idSakit: widget.idSakit);
    });
  }

  @override
  Widget build(BuildContext context) {
    ref.listen<AsyncValue>(sakitDtlNotifierProvider, (_, state) {
      state.showAlertDialogOnError(context);
    });

    final sakitDtl = ref.watch(sakitDtlNotifierProvider);

    return VAsyncWidgetScaffold<List<SakitDtl>>(
        value: sakitDtl,
        data: (dtl) => RefreshIndicator(
              onRefresh: () {
                ref
                    .read(sakitDtlNotifierProvider.notifier)
                    .loadSakitDetail(idSakit: dtl.first.idSakit);
                return Future.value();
              },
              child: VScaffoldWidget(
                scaffoldTitle: 'Upload Gambar',
                scaffoldFAB: FloatingActionButton.small(
                    backgroundColor: Palette.primaryColor,
                    child: Icon(
                      Icons.upload,
                      color: Colors.white,
                    ),
                    onPressed: () => context.pushNamed(
                        RouteNames.sakitUploadRoute,
                        extra: dtl.first.idSakit)),
                scaffoldBody: ListView.separated(
                  itemCount: dtl.length,
                  separatorBuilder: (context, index) => SizedBox(
                    height: 8,
                  ),
                  itemBuilder: (context, index) => InkWell(
                      onTap: () => context.pushNamed(
                          RouteNames.sakitPhotoDtlRoute,
                          extra: ref
                              .read(sakitDtlNotifierProvider.notifier)
                              .urlImageFormSakit(dtl[index].namaImg)),
                      child: Ink(child: SakitDtlWidget(dtl[index]))),
                ),
              ),
            ));
  }
}

class SakitDtlWidget extends HookConsumerWidget {
  const SakitDtlWidget(
    this.item,
  );

  final SakitDtl item;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final imageUrl = ref
        .watch(sakitDtlNotifierProvider.notifier)
        .urlImageFormSakit(item.namaImg);

    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        color: theme.primaryColor,
      ),
      padding: EdgeInsets.all(8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // UPPER
                  Text(
                    'ID : ${item.idSakit}',
                    style: Themes.customColor(11,
                        color: Theme.of(context).unselectedWidgetColor),
                  ),
                  SizedBox(
                    height: 2,
                  ),
                  Text(
                    'Nama : ${item.namaImg}',
                    style: Themes.customColor(11,
                        color: Theme.of(context).unselectedWidgetColor),
                  ),
                  SizedBox(
                    height: 2,
                  ),
                  Text(
                    'Created By : ${item.cUser}',
                    style: Themes.customColor(10,
                        color: Theme.of(context).unselectedWidgetColor),
                  ),
                ],
              ),
              SizedBox(
                width: 50,
                child: Row(
                  children: [
                    Flexible(
                      child: Text(
                        'Tgl Upload : ${item.cDate}',
                        maxLines: 3,
                        style: Themes.customColor(8,
                            color: Theme.of(context).unselectedWidgetColor),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),

          SizedBox(
            height: 8,
          ),

          // RIGHT
          Container(
              height: 350,
              // width: 300,
              decoration: BoxDecoration(
                color: Palette.secondaryColor,
                borderRadius: BorderRadius.circular(12),
              ),
              padding: EdgeInsets.all(8),
              child: IgnorePointer(
                ignoring: true,
                child: InAppWebView(
                  onWebViewCreated: (_) {},
                  initialUrlRequest: URLRequest(url: Uri.parse(imageUrl)),
                  onLoadStop: (controller, url) async {
                    String html = await controller.evaluateJavascript(
                        source:
                            "window.document.getElementsByTagName('html')[0].outerHTML;");

                    if (html.contains('Runtime Error')) {}
                  },
                  onConsoleMessage: (controller, consoleMessage) {
                    print(consoleMessage);
                  },
                ),
              )),

          SizedBox(
            height: 8,
          ),

          // LOWER
        ],
      ),
    );
  }
}
