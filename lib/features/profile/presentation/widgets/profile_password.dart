import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../../../shared/providers.dart';
import '../../../../style/style.dart';
import '../../../../widgets/alert_helper.dart';

class ProfilePassword extends ConsumerWidget {
  const ProfilePassword({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final userProvider = ref.watch(userNotifierProvider);

    final passwordVisible = ref.watch(passwordVisibleProvider);

    return Container(
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10), color: Palette.primaryColor),
      padding: EdgeInsets.all(4),
      height: 50,
      width: MediaQuery.of(context).size.width,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            'PASSWORD : ',
            style: Themes.customColor(
              15,
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
          ),
          Text(
            '${passwordVisible ? userProvider.user.password ?? '' : '*'.padRight(userProvider.user.password!.length, '*')}',
            style: Themes.customColor(
              10,
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(
            width: 8,
          ),
          SizedBox(
            width: 30,
            child: TextButton(
              style: ButtonStyle(
                  padding: WidgetStateProperty.all(EdgeInsets.zero)),
              onPressed: () => ref
                  .read(passwordVisibleProvider.notifier)
                  .state = toggleVisibility(passwordVisible),
              child: Icon(
                Icons.remove_red_eye_outlined,
                color: Colors.white,
              ),
            ),
          ),
          SizedBox(
            width: 30,
            child: TextButton(
              style: ButtonStyle(
                  padding: WidgetStateProperty.all(EdgeInsets.zero)),
              onPressed: () =>
                  copyAndNotify(userProvider.user.password ?? '', context),
              child: Icon(
                Icons.copy,
                color: Colors.white,
              ),
            ),
          ),
        ],
      ),
    );
  }

  bool toggleVisibility(bool visibility) {
    return visibility ? false : true;
  }

  void copyAndNotify(String text, BuildContext context) {
    Clipboard.setData(ClipboardData(text: text));

    AlertHelper.showSnackBar(context, message: 'Password copied');
  }
}
