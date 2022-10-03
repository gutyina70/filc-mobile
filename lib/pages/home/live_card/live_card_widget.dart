import 'package:filcnaplo/theme/colors/colors.dart';
import 'package:filcnaplo_mobile_ui/common/progress_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_feather_icons/flutter_feather_icons.dart';
import 'live_card.i18n.dart';

enum ProgressAccuracy { minutes, seconds }

class LiveCardWidget extends StatelessWidget {
  const LiveCardWidget({
    Key? key,
    this.leading,
    this.title,
    this.subtitle,
    this.icon,
    this.description,
    this.nextRoom,
    this.nextSubject,
    this.progressCurrent,
    this.progressMax,
    this.progressAccuracy = ProgressAccuracy.minutes,
    this.onProgressTap,
  }) : super(key: key);

  final String? leading;
  final String? title;
  final String? subtitle;
  final IconData? icon;
  final Widget? description;
  final String? nextSubject;
  final String? nextRoom;
  final double? progressCurrent;
  final double? progressMax;
  final ProgressAccuracy? progressAccuracy;
  final Function()? onProgressTap;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 2.0),
      padding: const EdgeInsets.all(12.0),
      decoration: BoxDecoration(
        color: Theme.of(context).backgroundColor,
        borderRadius: BorderRadius.circular(16.0),
        boxShadow: [
          BoxShadow(
            offset: const Offset(0, 21),
            blurRadius: 23.0,
            color: AppColors.of(context).shadow,
          )
        ],
      ),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 6.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            Expanded(
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (leading != null)
                    Padding(
                      padding: const EdgeInsets.only(right: 12.0, top: 8.0),
                      child: Text(
                        leading!,
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 32.0,
                          fontWeight: FontWeight.w600,
                          color: Theme.of(context).colorScheme.secondary,
                        ),
                      ),
                    ),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        Row(
                          children: [
                            if (title != null)
                              Expanded(
                                child: Text.rich(
                                  TextSpan(
                                    children: [
                                      TextSpan(text: title!),
                                      if (subtitle != null)
                                        WidgetSpan(
                                          child: Container(
                                            margin: const EdgeInsets.only(left: 6.0, bottom: 3.0),
                                            padding: const EdgeInsets.symmetric(horizontal: 4.0, vertical: 2.0),
                                            decoration: BoxDecoration(
                                              color: Theme.of(context).colorScheme.secondary.withOpacity(.3),
                                              borderRadius: BorderRadius.circular(4.0),
                                            ),
                                            child: Text(
                                              subtitle!,
                                              style: TextStyle(
                                                height: 1.2,
                                                fontSize: 14.0,
                                                fontWeight: FontWeight.w600,
                                                color: Theme.of(context).colorScheme.secondary,
                                              ),
                                            ),
                                          ),
                                        ),
                                    ],
                                  ),
                                  style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 22.0),
                                  maxLines: 1,
                                  softWrap: false,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                            if (title != null) const SizedBox(width: 6.0),
                            if (icon != null)
                              Padding(
                                padding: const EdgeInsets.symmetric(vertical: 4.0),
                                child: Icon(
                                  icon,
                                  size: 26.0,
                                  color: AppColors.of(context).text.withOpacity(.75),
                                ),
                              ),
                          ],
                        ),
                        if (description != null)
                          DefaultTextStyle(
                            style: Theme.of(context).textTheme.bodyText2!.copyWith(
                                  fontWeight: FontWeight.w500,
                                  fontSize: 16.0,
                                  color: AppColors.of(context).text.withOpacity(.75),
                                ),
                            maxLines: !(nextSubject == null && progressCurrent == null && progressMax == null) ? 1 : 2,
                            softWrap: false,
                            overflow: TextOverflow.ellipsis,
                            child: description!,
                          ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            if (!(nextSubject == null && progressCurrent == null && progressMax == null))
              Padding(
                padding: const EdgeInsets.only(top: 8.0),
                child: Row(
                  children: [
                    if (nextSubject != null) const Icon(FeatherIcons.arrowRight, size: 12.0),
                    if (nextSubject != null) const SizedBox(width: 4.0),
                    if (nextSubject != null)
                      Expanded(
                        child: Text.rich(
                          TextSpan(
                            children: [
                              TextSpan(text: nextSubject!),
                              if (nextRoom != null)
                                WidgetSpan(
                                  child: Container(
                                    margin: const EdgeInsets.only(left: 4.0),
                                    padding: const EdgeInsets.symmetric(horizontal: 3.0, vertical: 1.5),
                                    decoration: BoxDecoration(
                                      color: Theme.of(context).colorScheme.secondary.withOpacity(.25),
                                      borderRadius: BorderRadius.circular(4.0),
                                    ),
                                    child: Text(
                                      nextRoom!,
                                      style: TextStyle(
                                        height: 1.1,
                                        fontSize: 11.0,
                                        fontWeight: FontWeight.w600,
                                        color: Theme.of(context).colorScheme.secondary.withOpacity(.9),
                                      ),
                                    ),
                                  ),
                                ),
                            ],
                          ),
                          style: TextStyle(
                            color: AppColors.of(context).text.withOpacity(.8),
                            fontWeight: FontWeight.w600,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          softWrap: false,
                        ),
                      ),
                    if (progressCurrent != null && progressMax != null)
                      GestureDetector(
                        onTap: onProgressTap,
                        child: Text(
                          "remaining ${progressAccuracy == ProgressAccuracy.minutes ? 'min' : 'sec'}"
                              .plural((progressMax! - progressCurrent!).round()),
                          maxLines: 1,
                          style: TextStyle(
                            fontWeight: FontWeight.w500,
                            color: AppColors.of(context).text.withOpacity(.75),
                          ),
                        ),
                      )
                  ],
                ),
              ),
            if (progressCurrent != null && progressMax != null)
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 4.0),
                child: ProgressBar(value: progressCurrent! / progressMax!),
              )
          ],
        ),
      ),
    );
  }
}
