import 'package:collection/collection.dart';
import 'package:face_net_authentication/widgets/async_value_ui.dart';
import 'package:face_net_authentication/widgets/v_additional_info.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:intl/intl.dart';

import '../../../common/search_filter_info_widget.dart';
import '../../../cross_auth/application/cross_auth_notifier.dart';
import '../../../cross_auth/application/is_user_crossed.dart';
import '../../../err_log/application/err_log_notifier.dart';
import '../../../firebase/remote_config/application/firebase_remote_config_notifier.dart';
import '../../../../helper.dart';
import '../../../routes/application/route_names.dart';
import '../../../../shared/providers.dart';
import '../../../user/application/user_notifier.dart';
import '../../../../utils/dialog_helper.dart';
import '../../../../widgets/v_async_widget.dart';
import '../../../../widgets/v_scaffold_widget.dart';
import '../../../../style/style.dart';
import '../../jadwal_shift_approve/application/jadwal_shift_approve_notifier.dart';
import '../application/jadwal_shift_list.dart';
import '../application/jadwal_shift_list_notifier.dart';
import 'jadwal_shift_list_item.dart';

class JadwalShiftListScaffold extends HookConsumerWidget
    with DialogHelper, CalendarHelper {
  const JadwalShiftListScaffold(this.mapPT);

  final Map<String, List<String>> mapPT;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final jadwalShiftList = ref.watch(jadwalShiftListControllerProvider);
    final jadwalShiftApprove = ref.watch(jadwalShiftApproveControllerProvider);
    final crossAuth = ref.watch(crossAuthNotifierProvider);

    /* 
      Search and Filter Date
      values
    */
    final _lastSearch = useState('');
    final _dateTimeRange = useState(CalendarHelper.initialDateRange());

    final _d1 = DateFormat('dd MMMM y').format(_dateTimeRange.value.start);
    final _d2 = DateFormat('dd MMMM y').format(_dateTimeRange.value.end);

    final _isScrollStopped = useState(false);

    final scrollController = useScrollController();
    final page = useState(0);

    _resetScroll() {
      if (scrollController.hasClients) {
        _isScrollStopped.value = false;
        scrollController.jumpTo(0.0);
      }
    }

    final onRefresh = () async {
      page.value = 0;
      _resetScroll();

      await ref
          .read(jadwalShiftListControllerProvider.notifier)
          .refresh(searchUser: _lastSearch.value);
      return Future.value();
    };

    final onPageChanged = () async {
      page.value = 0;
      _resetScroll();
      await ref
          .read(jadwalShiftListControllerProvider.notifier)
          .refresh(searchUser: _lastSearch.value);
      return Future.value();
    };

    final onFieldSubmitted = (String value) async {
      page.value = 0;
      _resetScroll();

      _lastSearch.value = value;
      await ref
          .read(jadwalShiftListControllerProvider.notifier)
          .refresh(searchUser: value);
      return Future.value();
    };

    final _initialDropdownPlaceholder = ['ACT', 'Transina', 'ALR'];
    final _currPT = ref.watch(userNotifierProvider).user.ptServer;
    final _initialDropdown = mapPT.entries
        .firstWhereOrNull((element) => element.key == _currPT)
        ?.value;

    final _dropdownValue = useState(_initialDropdown);

    final onDropdownChanged = (List<String> value) async {
      page.value = 0;
      _resetScroll();

      _dropdownValue.value = value;
      final user = ref.read(userNotifierProvider).user;

      final _ptMap = await ref
          .read(firebaseRemoteConfigNotifierProvider.notifier)
          .getPtMap();

      await ref.read(crossAuthNotifierProvider.notifier).cross(
            userId: user.nama!,
            password: user.password!,
            pt: _dropdownValue.value ?? ['ACT', 'Transina', 'ALR'],
            url: _ptMap,
          );

      return Future.value();
    };

    final onFilterSelected = (DateTimeRange value) async {
      page.value = 0;
      _resetScroll();

      _dateTimeRange.value = value;
      await ref.read(jadwalShiftListControllerProvider.notifier).refresh(
            searchUser: _lastSearch.value,
          );
      return Future.value();
    };

    final _isAtBottom = useState(false);

    void onScrolledVisibility() {
      scrollController.position.isScrollingNotifier.addListener(() {
        if (scrollController.position.pixels > 0.0) {
          _isScrollStopped.value = true;
        } else {
          _isScrollStopped.value = false;
        }

        if (scrollController.position.pixels ==
            scrollController.position.maxScrollExtent) {
          _isAtBottom.value = true;
        } else {
          _isAtBottom.value = false;
        }
      });
    }

    useEffect(() {
      scrollController.addListener(onScrolledVisibility);
      return () => scrollController.removeListener(onScrolledVisibility);
    }, [scrollController]);

    final infoMessage = [
      "Tanggal Off : Untuk menginput hari libur/masuk",
      "Jadwal Shift : untuk menginput Jadwal Shift libur/masuk",
    ];

    ref.listen<AsyncValue>(jadwalShiftListControllerProvider, (_, state) async {
      if (!state.isLoading &&
          state.hasValue &&
          state.value != '' &&
          state.value != null &&
          state.hasError == false) {
        _isAtBottom.value = false;
      }

      return state.showAlertDialogOnError(context, ref);
    });

    final errLog = ref.watch(errLogControllerProvider);
    final _userHasStaff = ref.watch(userHasStaffProvider);
    final _isUserCrossed = ref.watch(isUserCrossedProvider);

    final _isSearching = useState(false);
    final _searchFocus = useFocusNode();

    final _isDonePopping = useState(false);

    return VAsyncWidgetScaffold<void>(
      value: errLog,
      data: (_) => VAsyncWidgetScaffold(
        value: crossAuth,
        data: (_) => VAsyncWidgetScaffold<IsUserCrossedState>(
            value: _isUserCrossed,
            data: (data) {
              final _isCrossed = data.when(
                crossed: () => true,
                notCrossed: () => false,
              );

              return PopScope(
                canPop: _isDonePopping.value,
                onPopInvoked: (_) async {
                  _isDonePopping.value = false;

                  final user = ref.read(userNotifierProvider).user;
                  final _ptMap = await ref
                      .read(firebaseRemoteConfigNotifierProvider.notifier)
                      .getPtMap();

                  if (_isCrossed) {
                    await ref.read(crossAuthNotifierProvider.notifier).uncross(
                          userId: user.nama!,
                          password: user.password!,
                          url: _ptMap,
                        );
                  }

                  _isDonePopping.value = true;
                },
                child: VAsyncWidgetScaffold(
                  value: jadwalShiftApprove,
                  data: (_) => VAsyncWidgetScaffold<bool>(
                    value: _userHasStaff,
                    data: (s) => VScaffoldTabLayout(
                      length: 2,
                      scaffoldTitle: 'Jadwal Shift',
                      mapPT: mapPT,
                      additionalInfo:
                          VAdditionalInfo(infoMessage: [infoMessage]),
                      scaffoldFAB: _isCrossed
                          ? Container()
                          : FloatingActionButton.small(
                              backgroundColor: Palette.primaryColor,
                              child: Icon(
                                Icons.add,
                                color: Colors.white,
                              ),
                              onPressed: () => context.pushNamed(
                                    RouteNames.createJadwalShiftRoute,
                                  )),
                      isSearchVisible: s,
                      currPT: _initialDropdown ?? _initialDropdownPlaceholder,
                      searchFocus: _searchFocus,
                      isSearching: _isSearching,
                      onPageChanged: onPageChanged,
                      onFieldSubmitted: onFieldSubmitted,
                      onFilterSelected: onFilterSelected,
                      onDropdownChanged: onDropdownChanged,
                      initialDateRange: _dateTimeRange.value,
                      bottomLeftWidget: SearchFilterInfoWidget(
                        d1: _d1,
                        d2: _d2,
                        isSearchVisible: s,
                        isBottom: _isAtBottom.value,
                        lastSearch: _lastSearch.value,
                        isScrolling: _isScrollStopped.value,
                        onTapName: () {
                          _isSearching.value = true;
                          _searchFocus.requestFocus();
                        },
                        onTapDate: () => CalendarHelper.callCalendar(
                            context, onFilterSelected),
                      ),
                      scaffoldBody: [
                        VAsyncValueWidget<List<JadwalShiftList>>(
                            value: jadwalShiftList,
                            data: (list) {
                              final waiting = list
                                  .where((e) =>
                                      (e.spvSta == false || e.stafSta == false))
                                  .toList();
                              return _list(
                                _isCrossed,
                                waiting,
                                onRefresh,
                                scrollController,
                              );
                            }),
                        VAsyncValueWidget<List<JadwalShiftList>>(
                            value: jadwalShiftList,
                            data: (list) {
                              final approved = list
                                  .where((e) =>
                                      (e.spvSta == true && e.stafSta == true))
                                  .toList();
                              return _list(
                                _isCrossed,
                                approved,
                                onRefresh,
                                scrollController,
                              );
                            }),
                      ],
                    ),
                  ),
                ),
              );
            }),
      ),
    );
  }

  Widget _list(
    bool _isCrossed,
    List<JadwalShiftList> list,
    Future<void> Function() onRefresh,
    ScrollController scrollController,
  ) {
    return RefreshIndicator(
      onRefresh: onRefresh,
      child: ListView.separated(
          controller: scrollController,
          separatorBuilder: (__, index) => SizedBox(
                height: 8,
              ),
          itemCount: list.length + 1,
          itemBuilder: (BuildContext context, int index) => index == list.length
              ? SizedBox(
                  height: 50,
                )
              : index == 0
                  ? Column(
                      children: [
                        if (_isCrossed) ...[
                          Padding(
                              padding: const EdgeInsets.only(
                                  top: 10.0,
                                  left: 16.0,
                                  right: 16.0,
                                  bottom: 0),
                              child: Container(
                                  height: 35,
                                  padding: EdgeInsets.all(8),
                                  decoration: BoxDecoration(
                                    color:
                                        Palette.greyDisabled.withOpacity(0.1),
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  child: Center(
                                    child: Text(
                                      'Sedang Melintas Server',
                                      style: Themes.customColor(8,
                                          fontWeight: FontWeight.bold),
                                    ),
                                  ))),
                        ],
                        SizedBox(
                          height: 10,
                        ),
                        JadwalShiftListItem(list[index])
                      ],
                    )
                  : JadwalShiftListItem(list[index])),
    );
  }
}
