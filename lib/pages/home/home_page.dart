// ignore_for_file: dead_code

import 'dart:math';

import 'package:filcnaplo/api/providers/update_provider.dart';
import 'package:filcnaplo/api/providers/sync.dart';
import 'package:filcnaplo/theme.dart';
import 'package:filcnaplo_kreta_api/models/absence.dart';
import 'package:filcnaplo_kreta_api/providers/absence_provider.dart';
import 'package:filcnaplo_kreta_api/providers/event_provider.dart';
import 'package:filcnaplo_kreta_api/providers/exam_provider.dart';
import 'package:filcnaplo_kreta_api/providers/grade_provider.dart';
import 'package:filcnaplo_kreta_api/providers/homework_provider.dart';
import 'package:filcnaplo_kreta_api/providers/message_provider.dart';
import 'package:filcnaplo_kreta_api/providers/note_provider.dart';
import 'package:filcnaplo/api/providers/user_provider.dart';
import 'package:filcnaplo/api/providers/status_provider.dart';
import 'package:filcnaplo_kreta_api/models/grade.dart';
import 'package:filcnaplo_kreta_api/models/message.dart';
import 'package:filcnaplo_kreta_api/providers/timetable_provider.dart';
import 'package:filcnaplo_mobile_ui/common/empty.dart';
import 'package:filcnaplo_mobile_ui/common/filter/filter_bar.dart';
import 'package:filcnaplo_mobile_ui/common/filter/filter_controller.dart';
import 'package:filcnaplo_mobile_ui/common/filter/filter_item.dart';
import 'package:filcnaplo_mobile_ui/common/filter/filter_view.dart';
import 'package:filcnaplo_mobile_ui/common/panel/panel.dart';
import 'package:filcnaplo_mobile_ui/common/panel/panel_button.dart';
import 'package:filcnaplo_mobile_ui/common/profile_image/profile_button.dart';
import 'package:filcnaplo_mobile_ui/common/profile_image/profile_image.dart';
import 'package:filcnaplo_mobile_ui/common/widgets/absence_group_tile.dart';
import 'package:filcnaplo_mobile_ui/common/widgets/absence_tile.dart';
import 'package:filcnaplo_mobile_ui/common/widgets/absence_view.dart';
import 'package:filcnaplo_mobile_ui/common/widgets/changed_lesson_tile.dart';
import 'package:filcnaplo_mobile_ui/common/widgets/event_tile.dart';
import 'package:filcnaplo_mobile_ui/common/widgets/event_view.dart';
import 'package:filcnaplo_mobile_ui/common/widgets/exam_tile.dart';
import 'package:filcnaplo_mobile_ui/common/widgets/exam_view.dart';
import 'package:filcnaplo_mobile_ui/common/widgets/grade_tile.dart';
import 'package:filcnaplo_mobile_ui/common/widgets/grade_view.dart';
import 'package:filcnaplo_mobile_ui/common/widgets/homework_tile.dart';
import 'package:filcnaplo_mobile_ui/common/widgets/homework_view.dart';
import 'package:filcnaplo_mobile_ui/common/widgets/message_tile.dart';
import 'package:filcnaplo_mobile_ui/common/widgets/message_view/message_view.dart';
import 'package:filcnaplo_mobile_ui/common/widgets/note_tile.dart';
import 'package:filcnaplo_mobile_ui/common/widgets/note_view.dart';
import 'package:filcnaplo_mobile_ui/pages/home/live_card/live_card.dart';
import 'package:filcnaplo_kreta_api/controllers/live_card_controller.dart';
import 'package:filcnaplo_mobile_ui/common/hero_dialog_route.dart';
import 'package:filcnaplo_mobile_ui/pages/timetable/timetable_page.dart';
import 'package:filcnaplo_mobile_ui/screens/settings/updates/updates_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_feather_icons/flutter_feather_icons.dart';
import 'package:provider/provider.dart';
import 'home_page.i18n.dart';
import 'package:filcnaplo/utils/color.dart';
import 'package:filcnaplo/utils/format.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> with TickerProviderStateMixin {
  late FilterController _filterController;
  late UserProvider user;
  late UpdateProvider updateProvider;
  late StatusProvider statusProvider;
  late GradeProvider gradeProvider;
  late TimetableProvider timetableProvider;
  late MessageProvider messageProvider;
  late AbsenceProvider absenceProvider;
  late HomeworkProvider homeworkProvider;
  late ExamProvider examProvider;
  late NoteProvider noteProvider;
  late EventProvider eventProvider;
  late String greeting;
  late String firstName;
  late LiveCardController _liveController;
  late bool showLiveCard;

  @override
  void initState() {
    super.initState();
    user = Provider.of<UserProvider>(context, listen: false);
    _filterController = FilterController(itemCount: 4);
    DateTime now = DateTime.now();
    if (now.month == user.student?.birth.month && now.day == user.student?.birth.day) {
      greeting = "happybirthday";
    } else if (now.month == DateTime.december && now.day >= 24 && now.day <= 26) {
      greeting = "merryxmas";
    } else if (now.month == DateTime.january && now.day == 1) {
      greeting = "happynewyear";
    } else if (now.hour >= 18) {
      greeting = "goodevening";
    } else if (now.hour >= 10) {
      greeting = "goodafternoon";
    } else if (now.hour >= 4) {
      greeting = "goodmorning";
    } else {
      greeting = "goodevening";
    }

    _liveController = LiveCardController(context: context, vsync: this);
  }

  @override
  void dispose() {
    _liveController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    user = Provider.of<UserProvider>(context);
    updateProvider = Provider.of<UpdateProvider>(context);
    statusProvider = Provider.of<StatusProvider>(context, listen: false);
    gradeProvider = Provider.of<GradeProvider>(context);
    timetableProvider = Provider.of<TimetableProvider>(context);
    messageProvider = Provider.of<MessageProvider>(context);
    absenceProvider = Provider.of<AbsenceProvider>(context);
    homeworkProvider = Provider.of<HomeworkProvider>(context);
    examProvider = Provider.of<ExamProvider>(context);
    noteProvider = Provider.of<NoteProvider>(context);
    eventProvider = Provider.of<EventProvider>(context);

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
                      maxLines: 2,
                      softWrap: true,
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
                  shadowColor: AppColors.of(context).shadow,

                  // Filter Bar
                  bottom: FilterBar(items: [
                    FilterItem(label: "All".i18n),
                    FilterItem(label: "Grades".i18n),
                    FilterItem(label: "Messages".i18n),
                    FilterItem(label: "Absences".i18n),
                  ], controller: _filterController),
                  pinned: true,
                  floating: false,
                  snap: false,
                );
              },
            ),
          ],
          body: FilterView(
            controller: _filterController,
            builder: (context, activeData) => FutureBuilder<Widget>(
              future: filterViewBuilder(context, activeData),
              builder: (context, snapshot) => snapshot.data ?? Container(),
            ),
          ),
        ),
      ),
    );
  }

  void openLiveCard() {
    Navigator.of(context, rootNavigator: true).push(
      HeroDialogRoute(
        builder: (context) => Center(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24.0),
            child: SizedBox(
              height: MediaQuery.of(context).size.height / 2,
              child: LiveCard(expanded: true, controller: _liveController),
            ),
          ),
        ),
      ),
    );
  }

  Future<List<DateWidget>> getFilterWidgets(HomeFilterItems activeData, {bool absencesNoExcused = false}) async {
    List<DateWidget> items = [];

    switch (activeData) {
      // All
      case HomeFilterItems.all:
        final all = await Future.wait<List<DateWidget>>([
          getFilterWidgets(HomeFilterItems.grades),
          getFilterWidgets(HomeFilterItems.lessons),
          getFilterWidgets(HomeFilterItems.messages),
          getFilterWidgets(HomeFilterItems.absences, absencesNoExcused: true),
          getFilterWidgets(HomeFilterItems.homework),
          getFilterWidgets(HomeFilterItems.exams),
          getFilterWidgets(HomeFilterItems.updates),
        ]);
        items.addAll(all.expand((x) => x));
        break;

      // Grades
      case HomeFilterItems.grades:
        for (var grade in gradeProvider.grades) {
          if (grade.type == GradeType.midYear) {
            items.add(DateWidget(
              date: grade.date,
              widget: GradeTile(grade, onTap: () => GradeView.show(grade, context: context)),
            ));
          }
        }
        break;

      // Messages
      case HomeFilterItems.messages:
        for (var message in messageProvider.messages) {
          if (message.type == MessageType.inbox) {
            items.add(DateWidget(
                date: message.date,
                widget: MessageTile(
                  message,
                  onTap: () => MessageView.show([message], context: context),
                )));
          }
        }
        items.addAll(await getFilterWidgets(HomeFilterItems.notes));
        items.addAll(await getFilterWidgets(HomeFilterItems.events));
        break;

      // Absences
      case HomeFilterItems.absences:
        absenceProvider.absences.where((a) => !absencesNoExcused || a.state != Justification.excused).forEach((absence) {
          items.add(DateWidget(
              date: absence.date,
              widget: AbsenceTile(
                absence,
                onTap: () => AbsenceView.show(absence, context: context),
              )));
        });
        break;

      // Homework
      case HomeFilterItems.homework:
        homeworkProvider.homework.where((h) => h.deadline.isAfter(DateTime.now())).forEach((homework) {
          items.add(DateWidget(
              date: homework.deadline.year != 0 ? homework.deadline : homework.date,
              widget: HomeworkTile(
                homework,
                onTap: () => HomeworkView.show(homework, context: context),
              )));
        });
        break;

      // Exams
      case HomeFilterItems.exams:
        for (var exam in examProvider.exams) {
          items.add(DateWidget(
              date: exam.writeDate.year != 0 ? exam.writeDate : exam.date,
              widget: ExamTile(
                exam,
                onTap: () => ExamView.show(exam, context: context),
              )));
        }
        break;

      // Notes
      case HomeFilterItems.notes:
        for (var note in noteProvider.notes) {
          items.add(DateWidget(
              date: note.date,
              widget: NoteTile(
                note,
                onTap: () => NoteView.show(note, context: context),
              )));
        }
        break;

      // Events
      case HomeFilterItems.events:
        for (var event in eventProvider.events) {
          items.add(DateWidget(
              date: event.start,
              widget: EventTile(
                event,
                onTap: () => EventView.show(event, context: context),
              )));
        }
        break;

      // Changed Lessons
      case HomeFilterItems.lessons:
        timetableProvider.lessons.where((l) => l.isChanged && l.start.isAfter(DateTime.now())).forEach((lesson) {
          items.add(DateWidget(
              date: lesson.date,
              widget: ChangedLessonTile(
                lesson,
                onTap: () => TimetablePage.jump(context, lesson: lesson),
              )));
        });
        break;

      // Updates
      case HomeFilterItems.updates:
        if (updateProvider.available) {
          items.add(DateWidget(
            date: DateTime.now(),
            widget: PanelButton(
              onPressed: () => openUpdates(context),
              title: Text("update_available".i18n),
              leading: const Icon(FeatherIcons.download),
              trailing: Text(
                updateProvider.releases.first.tag,
                style: TextStyle(
                  fontWeight: FontWeight.w500,
                  color: Theme.of(context).colorScheme.secondary,
                ),
              ),
            ),
          ));
        }
        break;
    }
    return items;
  }

  void openUpdates(BuildContext context) => UpdateView.show(updateProvider.releases.first, context: context);

  Future<Widget> filterViewBuilder(context, int activeData) async {
    List<Widget> filterWidgets = sortDateWidgets(context, dateWidgets: await getFilterWidgets(HomeFilterItems.values[activeData]));

    return Padding(
      padding: const EdgeInsets.only(top: 12.0),
      child: RefreshIndicator(
        color: Theme.of(context).colorScheme.secondary,
        onRefresh: () => syncAll(context),
        child: ListView.builder(
          padding: EdgeInsets.zero,
          physics: const BouncingScrollPhysics(),
          itemBuilder: (context, index) {
            if (filterWidgets.isNotEmpty) {
              return Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24.0),
                child: filterWidgets[index],
              );
            } else {
              return Empty(subtitle: "empty".i18n);
            }
          },
          itemCount: max(filterWidgets.length, 1),
        ),
      ),
    );
  }
}

// difference.inDays is not reliable
bool _sameDate(DateTime a, DateTime b) => (a.year == b.year && a.month == b.month && a.day == b.day);

List<Widget> sortDateWidgets(
  BuildContext context, {
  required List<DateWidget> dateWidgets,
  bool showTitle = true,
  EdgeInsetsGeometry? padding,
}) {
  dateWidgets.sort((a, b) => -a.date.compareTo(b.date));

  List<Conversation> conversations = [];
  List<DateWidget> convMessages = [];

  // Group messages into conversations
  for (var w in dateWidgets) {
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
  }

  // remove individual messages
  for (var e in convMessages) {
    dateWidgets.remove(e);
  }

  // Add conversations
  for (var conv in conversations) {
    conv.sort();

    dateWidgets.add(DateWidget(
      date: conv.newest.date,
      widget: MessageTile(
        conv.newest,
        onTap: () => MessageView.show(conv.messages, context: context),
      ),
    ));
  }

  List<Widget> items = [];
  dateWidgets.sort((a, b) => -a.date.compareTo(b.date));

  List<List<DateWidget>> groupedDateWidgets = [[]];
  for (var element in dateWidgets) {
    if (groupedDateWidgets.last.isNotEmpty) {
      if (!_sameDate(element.date, groupedDateWidgets.last.last.date)) {
        groupedDateWidgets.add([element]);
        continue;
      }
    }
    groupedDateWidgets.last.add(element);
  }

  if (groupedDateWidgets.first.isNotEmpty) {
    for (var elements in groupedDateWidgets) {
      bool _showTitle = showTitle;

      // Group Absence Tiles
      List<DateWidget> absenceTileWidgets = elements.where((element) {
        return element.widget.runtimeType == AbsenceTile && (element.widget as AbsenceTile).absence.delay == 0;
      }).toList();
      List<AbsenceTile> absenceTiles = absenceTileWidgets.map((e) => e.widget as AbsenceTile).toList();
      if (absenceTiles.length > 1) {
        elements.removeWhere((element) => element.widget.runtimeType == AbsenceTile && (element.widget as AbsenceTile).absence.delay == 0);

        if (elements.isEmpty) {
          _showTitle = false;
        }

        elements.add(DateWidget(widget: AbsenceGroupTile(absenceTiles, showDate: !_showTitle), date: absenceTileWidgets.first.date));
      }

      items.add(Padding(
        padding: const EdgeInsets.only(bottom: 12.0),
        child: Panel(
          padding: padding,
          title: _showTitle ? Text((elements + absenceTileWidgets).first.date.format(context, forceToday: true)) : null,
          child: Column(children: elements.map((e) => e.widget).toList()),
        ),
      ));
    }
  }
  return items;
}

class DateWidget {
  DateTime date;
  Widget widget;
  DateWidget({required this.date, required this.widget});
}

enum HomeFilterItems { all, grades, messages, absences, homework, exams, notes, events, lessons, updates }
