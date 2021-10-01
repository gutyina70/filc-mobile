// ignore_for_file: dead_code

import 'dart:math';

import 'package:implicitly_animated_reorderable_list/transitions.dart';
import 'package:implicitly_animated_reorderable_list/implicitly_animated_reorderable_list.dart';
import 'package:filcnaplo/api/providers/database_provider.dart';
import 'package:filcnaplo/api/providers/update_provider.dart';
import 'package:filcnaplo_kreta_api/client/api.dart';
import 'package:filcnaplo_kreta_api/client/client.dart';
import 'package:filcnaplo_kreta_api/models/student.dart';
import 'package:filcnaplo_kreta_api/providers/absence_provider.dart';
import 'package:filcnaplo_kreta_api/providers/event_provider.dart';
import 'package:filcnaplo_kreta_api/providers/exam_provider.dart';
import 'package:filcnaplo_kreta_api/providers/grade_provider.dart';
import 'package:filcnaplo_kreta_api/providers/homework_provider.dart';
import 'package:filcnaplo_kreta_api/providers/message_provider.dart';
import 'package:filcnaplo_kreta_api/providers/note_provider.dart';
import 'package:filcnaplo_kreta_api/providers/timetable_provider.dart';
import 'package:filcnaplo/api/providers/user_provider.dart';
import 'package:filcnaplo_kreta_api/models/grade.dart';
import 'package:filcnaplo_kreta_api/models/message.dart';
import 'package:filcnaplo_kreta_api/models/week.dart';
import 'package:filcnaplo_mobile_ui/common/empty.dart';
import 'package:filcnaplo_mobile_ui/common/filter_bar.dart';
import 'package:filcnaplo_mobile_ui/common/panel/panel.dart';
import 'package:filcnaplo_mobile_ui/common/profile_image/profile_button.dart';
import 'package:filcnaplo_mobile_ui/common/profile_image/profile_image.dart';
import 'package:filcnaplo_mobile_ui/common/widgets/absence_group_tile.dart';
import 'package:filcnaplo_mobile_ui/common/widgets/absence_tile.dart';
import 'package:filcnaplo_mobile_ui/common/widgets/absence_view.dart';
import 'package:filcnaplo_mobile_ui/common/widgets/grade_tile.dart';
import 'package:filcnaplo_mobile_ui/common/widgets/grade_view.dart';
import 'package:filcnaplo_mobile_ui/common/widgets/message_tile.dart';
import 'package:filcnaplo_mobile_ui/common/widgets/message_view/message_view.dart';
import 'package:filcnaplo_mobile_ui/pages/home/live_card/live_card.dart';
import 'package:filcnaplo_kreta_api/controllers/live_card_controller.dart';
import 'package:filcnaplo_mobile_ui/common/hero_dialog_route.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'home_page.i18n.dart';
import 'package:filcnaplo/utils/color.dart';
import 'package:filcnaplo/utils/format.dart';

class HomePage extends StatefulWidget {
  HomePage({Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> with TickerProviderStateMixin {
  late TabController _tabController;
  late UserProvider user;
  late UpdateProvider updateProvider;
  late GradeProvider gradeProvider;
  late MessageProvider messageProvider;
  late AbsenceProvider absenceProvider;
  late String greeting;
  late String firstName;
  late LiveCardController _liveController;
  late bool showLiveCard;
  List<Widget> filterWidgets = [];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 4, vsync: this);
    _tabController.addListener(this.onTabChange);

    DateTime now = DateTime.now();
    if (now.hour >= 18)
      greeting = "goodevening";
    else if (now.hour >= 10)
      greeting = "goodafternoon";
    else if (now.hour >= 4)
      greeting = "goodmorning";
    else
      greeting = "goodevening";

    _liveController = LiveCardController(context: context, vsync: this);

    gradeProvider = Provider.of<GradeProvider>(context, listen: false);
    messageProvider = Provider.of<MessageProvider>(context, listen: false);
    absenceProvider = Provider.of<AbsenceProvider>(context, listen: false);
    [gradeProvider, messageProvider, absenceProvider].forEach((p) => p.addListener(updateFilteredWidgets));

    WidgetsBinding.instance?.addPostFrameCallback((_) {
      updateFilteredWidgets();
    });
  }

  void updateFilteredWidgets() {
    setState(() {
      filterWidgets = sortDateWidgets(context, dateWidgets: getFilterWidgets(HomeFilterItems.values[_tabController.index]));
    });
  }

  void onTabChange() {
    // This will be called twice,
    // & we only want to update the widgets once
    // (to avoid Empty showing another face)
    if (_tabController.indexIsChanging) this.updateFilteredWidgets();
  }

  @override
  void dispose() {
    [gradeProvider, messageProvider, absenceProvider].forEach((p) => p.removeListener(updateFilteredWidgets));
    _liveController.dispose();
    _tabController.removeListener(this.onTabChange);
    _tabController.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    user = Provider.of<UserProvider>(context);
    updateProvider = Provider.of<UpdateProvider>(context);
    List<String> nameParts = user.name?.split(" ") ?? ["?"];
    firstName = nameParts.length > 1 ? nameParts[1] : nameParts[0];

    return Scaffold(
        body: Padding(
      padding: const EdgeInsets.only(top: 12.0),
      child: NestedScrollView(
        physics: const BouncingScrollPhysics(parent: AlwaysScrollableScrollPhysics()),
        headerSliverBuilder: (context, _) => [
          AnimatedBuilder(
            animation: _liveController.animation,
            builder: (context, child) {
              return SliverAppBar(
                automaticallyImplyLeading: false,
                centerTitle: false,
                titleSpacing: 0.0,
                // Welcome text
                title: Padding(
                  padding: const EdgeInsets.only(left: 24.0),
                  child: Text(
                    greeting.i18n.fill([firstName]),
                    overflow: TextOverflow.fade,
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 18.0,
                      color: Theme.of(context).textTheme.bodyText1?.color,
                    ),
                  ),
                ),
                actions: [
                  // TODO: Search Button
                  // IconButton(
                  //   icon: Icon(FeatherIcons.search),
                  //   color: Theme.of(context).textTheme.bodyText1?.color,
                  //   splashRadius: 24.0,
                  //   onPressed: () {},
                  // ),

                  // Profile Icon
                  Padding(
                    padding: const EdgeInsets.only(right: 24.0),
                    child: ProfileButton(
                      child: ProfileImage(
                        heroTag: "profile",
                        name: firstName,
                        backgroundColor: ColorUtils.stringToColor(user.name ?? "?"),
                        badge: updateProvider.available,
                        role: user.role,
                      ),
                    ),
                  ),
                ],

                expandedHeight: _liveController.animation.value * 234.0,

                // Live Card
                flexibleSpace: FlexibleSpaceBar(
                  background: Padding(
                    padding: EdgeInsets.only(
                      left: 24.0,
                      right: 24.0,
                      top: 58.0 + MediaQuery.of(context).padding.top,
                      bottom: 52.0,
                    ),
                    child: LiveCard(
                      onTap: openLiveCard,
                      controller: _liveController,
                    ),
                  ),
                ),
                shadowColor: Color(0),

                // Filter Bar
                bottom: FilterBar(items: [
                  Tab(text: "All".i18n),
                  Tab(text: "Grades".i18n),
                  Tab(text: "Messages".i18n),
                  Tab(text: "Absences".i18n),
                ], controller: _tabController),
                pinned: true,
                floating: false,
                snap: false,
              );
            },
          ),
        ],
        body: Padding(
            padding: const EdgeInsets.only(top: 12.0),
            child: RefreshIndicator(
                color: Theme.of(context).colorScheme.secondary,
                onRefresh: _sync,
                child: GestureDetector(
                    child: ImplicitlyAnimatedList<Widget>(
                      items: filterWidgets,
                      spawnIsolate: false,
                      padding: const EdgeInsets.symmetric(horizontal: 36.0),
                      physics: const BouncingScrollPhysics(),
                      removeDuration: kTabScrollDuration,
                      areItemsTheSame: (a, b) => a.key == b.key,
                      itemBuilder: (context, animation, item, index) {
                        return SizeFadeTransition(
                          curve: Curves.easeInOutCubic,
                          animation: animation,
                          child: item,
                          sizeFraction: .3,
                        );
                      },
                    ),
                    onHorizontalDragEnd: (DragEndDetails details) {
                      double v = details.primaryVelocity ?? 0;
                      if (v > 0 && _tabController.index > 0) {
                        // User swiped Left
                        _tabController.animateTo(_tabController.index - 1);
                      } else if (v < 0 && _tabController.index < 3) {
                        _tabController.animateTo(_tabController.index + 1);
                        // User swiped Right
                      }
                    }))),
      ),
    ));
  }

  void openLiveCard() {
    Navigator.of(context, rootNavigator: true).push(
      HeroDialogRoute(
        builder: (context) => Center(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 24.0),
            child: SizedBox(
              height: MediaQuery.of(context).size.height / 2,
              child: LiveCard(expanded: true, onTap: () => Navigator.pop(context), controller: _liveController),
            ),
          ),
        ),
      ),
    );
  }

  List<DateWidget> getFilterWidgets(HomeFilterItems activeData) {
    List<DateWidget> items = [];
    switch (activeData) {
      case HomeFilterItems.all:
        items.addAll(getFilterWidgets(HomeFilterItems.grades));
        items.addAll(getFilterWidgets(HomeFilterItems.messages));
        items.addAll(getFilterWidgets(HomeFilterItems.absences));
        break;
      case HomeFilterItems.grades:
        gradeProvider.grades.forEach((grade) {
          if (grade.type == GradeType.midYear) {
            items.add(DateWidget(
              key: grade.id,
              date: grade.date,
              widget: GradeTile(grade, onTap: () => GradeView.show(grade, context: context)),
            ));
          }
        });
        break;
      case HomeFilterItems.messages:
        messageProvider.messages.forEach((message) {
          if (message.type == MessageType.inbox) {
            items.add(DateWidget(
                key: "${message.id}",
                date: message.date,
                widget: MessageTile(
                  message,
                  onTap: () => MessageView.show([message], context: context),
                )));
          }
        });
        break;
      case HomeFilterItems.absences:
        absenceProvider.absences.forEach((absence) {
          items.add(DateWidget(
              key: absence.id,
              date: absence.date,
              widget: AbsenceTile(
                absence,
                onTap: () => AbsenceView.show(absence, context: context),
              )));
        });
        break;
    }
    return items;
  }

  Future<void> _sync() {
    return Future.wait([
      Provider.of<GradeProvider>(context, listen: false).fetch(),
      Provider.of<TimetableProvider>(context, listen: false).fetch(week: Week.current()),
      Provider.of<ExamProvider>(context, listen: false).fetch(),
      Provider.of<HomeworkProvider>(context, listen: false).fetch(from: DateTime.now().subtract(Duration(days: 30))),
      Provider.of<MessageProvider>(context, listen: false).fetch(type: MessageType.inbox),
      Provider.of<NoteProvider>(context, listen: false).fetch(),
      Provider.of<EventProvider>(context, listen: false).fetch(),
      Provider.of<AbsenceProvider>(context, listen: false).fetch(),
      // Sync student
      () async {
        if (user.user == null) return;
        Map? studentJson = await Provider.of<KretaClient>(context, listen: false).getAPI(KretaAPI.student(user.instituteCode!));
        if (studentJson == null) return;
        Student student = Student.fromJson(studentJson);

        user.user?.name = student.name;

        // Store user
        await Provider.of<DatabaseProvider>(context, listen: false).store.storeUser(user.user!);
      }(),
    ]).then((_) {
      updateFilteredWidgets();
    });
  }
}

List<Widget> sortDateWidgets(
  BuildContext context, {
  required List<DateWidget> dateWidgets,
  bool showTitle = true,
  EdgeInsetsGeometry padding = const EdgeInsets.symmetric(horizontal: 8.0),
}) {
  dateWidgets.sort((a, b) => -a.date.compareTo(b.date));

  List<Conversation> conversations = [];
  List<DateWidget> convMessages = [];

  // Group messages into conversations
  dateWidgets.forEach((w) {
    if (w.widget.runtimeType == MessageTile) {
      Message message = (w.widget as MessageTile).message;

      if (message.conversationId != null) {
        convMessages.add(w);

        Conversation conv = conversations.firstWhere((e) => e.id == message.conversationId, orElse: () => Conversation(id: message.conversationId!));
        conv.add(message);
        if (conv.messages.length == 1) conversations.add(conv);
      }

      if (conversations.any((c) => c.id == message.messageId)) {
        Conversation conv = conversations.firstWhere((e) => e.id == message.messageId);
        convMessages.add(w);
        conv.add(message);
      }
    }
  });

  // remove individual messages
  convMessages.forEach((e) => dateWidgets.remove(e));

  // Add conversations
  conversations.forEach((conv) {
    conv.sort();

    dateWidgets.add(DateWidget(
      key: "${conv.newest.date.millisecondsSinceEpoch}-msg",
      date: conv.newest.date,
      widget: MessageTile(
        conv.newest,
        onTap: () => MessageView.show(conv.messages, context: context),
      ),
    ));
  });

  List<Widget> items = [];
  dateWidgets.sort((a, b) => -a.date.compareTo(b.date));

  List<List<DateWidget>> groupedDateWidgets = [[]];
  dateWidgets.forEach((element) {
    if (groupedDateWidgets.last.length > 0) {
      if (element.date.difference(groupedDateWidgets.last.last.date).inDays != 0) {
        groupedDateWidgets.add([element]);
        return;
      }
    }
    groupedDateWidgets.last.add(element);
  });

  if (groupedDateWidgets.first.length > 0) {
    groupedDateWidgets.forEach((elements) {
      bool _showTitle = showTitle;

      // Group Absence Tiles
      List<DateWidget> absenceTileWidgets = elements.where((element) {
        return element.widget.runtimeType == AbsenceTile && (element.widget as AbsenceTile).absence.delay == 0;
      }).toList();
      List<AbsenceTile> absenceTiles = absenceTileWidgets.map((e) => e.widget as AbsenceTile).toList();
      if (absenceTiles.length > 1) {
        elements.removeWhere((element) => element.widget.runtimeType == AbsenceTile && (element.widget as AbsenceTile).absence.delay == 0);
        if (elements.length == 0) {
          _showTitle = false;
        }
        elements.add(DateWidget(
            widget: AbsenceGroupTile(absenceTiles, showDate: !_showTitle),
            date: absenceTileWidgets.first.date,
            key: "${absenceTileWidgets.first.date.millisecondsSinceEpoch}-absence-group"));
      }

      final String date = (elements + absenceTileWidgets).first.date.format(context);
      if (_showTitle) items.add(PanelTitle(title: Text(date), key: ValueKey("$date")));
      items.add(PanelHeader(padding: EdgeInsets.only(top: 12.0), key: ValueKey("$date-header")));
      elements.forEach((element) {
        items.add(PanelBody(padding: padding, child: element.widget, key: ValueKey(element.key)));
      });
      items.add(PanelFooter(padding: EdgeInsets.only(bottom: 12.0), key: ValueKey("$date-footer")));

      items.add(Padding(padding: EdgeInsets.only(bottom: 12.0), key: ValueKey("$date-padding")));
    });
  }
  if (items.isEmpty) items.add(Empty(subtitle: "empty".i18n, key: ValueKey("empty")));
  return items;
}

class DateWidget {
  final DateTime date;
  final Widget widget;
  final String? key;
  const DateWidget({required this.date, required this.widget, this.key});
}

enum HomeFilterItems { all, grades, messages, absences }
