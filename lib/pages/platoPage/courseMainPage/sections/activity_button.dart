import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:pnu_plato_advanced_browser/common.dart';
import 'package:pnu_plato_advanced_browser/components/emphasis_container.dart';
import 'package:pnu_plato_advanced_browser/controllers/todo_controller.dart';
import 'package:pnu_plato_advanced_browser/data/activity/course_activity.dart';
import 'package:pnu_plato_advanced_browser/data/todo/todo.dart';

class ActivityButton extends StatelessWidget {
  final String courseTitle;
  final String courseId;
  final CourseActivity activity;
  final bool isTarget;
  const ActivityButton({Key? key, required this.activity, required this.courseTitle, required this.courseId, required this.isTarget})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    bool avilablity = activity.iconUrl != null && activity.availablility == true;
    return Stack(
      children: [
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: Opacity(
            opacity: avilablity == false ? 0.5 : 1.0,
            child: InkWell(
              onTap: avilablity == false ? null : () async => await activity.openBottomSheet(context),
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 8.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Container(
                          margin: const EdgeInsets.only(right: 10),
                          child: activity.iconUrl == null
                              ? const SizedBox.shrink()
                              : CachedNetworkImage(
                                  imageUrl: activity.iconUrl!,
                                  placeholder: (context, url) => const SizedBox(
                                    width: 20,
                                    height: 20,
                                    child: CircularProgressIndicator(strokeWidth: 1),
                                  ),
                                  errorWidget: (context, url, error) => const Icon(Icons.error),
                                  height: 20,
                                  width: 20,
                                ),
                        ),
                        Flexible(
                          child: GetBuilder<TodoController>(builder: (controller) {
                            Todo? sameTodo =
                                controller.todoList.firstWhereOrNull((todo) => todo.courseId == activity.courseId && todo.id == activity.id);

                            Color titleColor = Colors.black;
                            if (sameTodo != null) {
                              switch (sameTodo.status) {
                                case TodoStatus.done:
                                  titleColor = Colors.green;
                                  break;
                                case TodoStatus.undone:
                                case TodoStatus.doing:
                                  titleColor = Colors.red;
                                  break;
                              }
                            }

                            return Text.rich(
                              TextSpan(
                                text: activity.title,
                                style: TextStyle(
                                  fontWeight: FontWeight.w900,
                                  color: titleColor,
                                ),
                                children: [
                                  TextSpan(
                                    text: '   ${activity.info}',
                                    style: const TextStyle(
                                      color: Colors.blueAccent,
                                      fontWeight: FontWeight.normal,
                                    ),
                                  ),
                                  if (activity.startDate != null)
                                    if (activity.lateDate != null)
                                      TextSpan(
                                        text:
                                            '\n${DateFormat('yyyy-MM-dd HH:mm:ss').format(activity.startDate!)} ~ ${DateFormat('yyyy-MM-dd HH:mm:ss').format(activity.endDate!)}\n(지각: ${DateFormat('yyyy-MM-dd HH:mm:ss').format(activity.lateDate!)})',
                                        style: const TextStyle(
                                          color: Colors.orangeAccent,
                                          fontWeight: FontWeight.normal,
                                        ),
                                      )
                                    else
                                      TextSpan(
                                        text:
                                            '\n${DateFormat('yyyy-MM-dd HH:mm:ss').format(activity.startDate!)} ~ ${DateFormat('yyyy-MM-dd HH:mm:ss').format(activity.endDate!)}',
                                        style: const TextStyle(
                                          color: Colors.orangeAccent,
                                          fontWeight: FontWeight.normal,
                                        ),
                                      ),
                                ],
                              ),
                            );
                          }),
                        ),
                      ],
                    ),
                    if (activity.availablilityInfo != '') renderHtml(activity.availablilityInfo),
                    if (activity.description != '') renderHtml(activity.description)
                  ],
                ),
              ),
            ),
          ),
        ),
        if (isTarget) const Positioned.fill(child: IgnorePointer(child: EmphasisContainer()))
      ],
    );
  }
}
