import 'package:filcnaplo/helpers/average_helper.dart';
import 'package:filcnaplo/theme.dart';
import 'package:filcnaplo_kreta_api/models/grade.dart';
import 'package:filcnaplo_mobile_ui/common/widgets/certification_view.dart';
import 'package:filcnaplo_mobile_ui/common/widgets/grade_tile.dart';
import 'package:flutter/material.dart';
import 'package:flutter_feather_icons/flutter_feather_icons.dart';
import 'certification_card.i18n.dart';

class CertificationCard extends StatelessWidget {
  const CertificationCard(this.grades, {Key? key, required this.gradeType}) : super(key: key);

  final List<Grade> grades;
  final GradeType gradeType;

  String getGradeTypeTitle() {
    String title;

    switch (gradeType) {
      case GradeType.halfYear:
        title = "mid".i18n;
        break;
      case GradeType.firstQ:
        title = "1q".i18n;
        break;
      case GradeType.secondQ:
        title = "2q".i18n;
        break;
      case GradeType.thirdQ:
        title = "3q".i18n;
        break;
      case GradeType.fourthQ:
        title = "4q".i18n;
        break;
      default:
        title = "final".i18n;
    }

    return title;
  }

  @override
  Widget build(BuildContext context) {
    String title = getGradeTypeTitle();
    double avg = AverageHelper.averageEvals(grades, finalAvg: true);
    Color color = gradeColor(context: context, value: avg);
    Color textColor;

    if (color.computeLuminance() >= .5) {
      textColor = Colors.black;
    } else {
      textColor = Colors.white;
    }

    return Container(
      margin: const EdgeInsets.symmetric(vertical: 2.0),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12.0),
        gradient: LinearGradient(
          colors: [color, color.withOpacity(.75)],
        ),
      ),
      child: Material(
        type: MaterialType.transparency,
        borderRadius: BorderRadius.circular(12.0),
        child: ListTile(
          contentPadding: const EdgeInsets.symmetric(vertical: 4.0, horizontal: 16.0),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.0)),
          leading: Text(
            avg.toStringAsFixed(1),
            style: TextStyle(
              color: textColor,
              fontWeight: FontWeight.bold,
              fontSize: 24.0,
            ),
          ),
          title: Text.rich(
            TextSpan(
              text: title,
              children: [
                TextSpan(
                  text: " • ${grades.length}",
                  style: TextStyle(
                    color: AppColors.of(context).text.withOpacity(.75),
                    fontWeight: FontWeight.w600,
                    fontSize: 16.0,
                  ),
                ),
              ],
            ),
            style: TextStyle(
              color: textColor,
              fontWeight: FontWeight.w700,
              fontSize: 18.0,
            ),
          ),
          trailing: Icon(FeatherIcons.arrowRight, color: textColor),
          onTap: () => CertificationView.show(grades, context: context, gradeType: gradeType),
        ),
      ),
    );
  }
}
