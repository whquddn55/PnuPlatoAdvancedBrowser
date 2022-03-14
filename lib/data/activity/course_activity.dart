import 'package:flutter/material.dart';
import 'package:pnu_plato_advanced_browser/data/activity/assign_course_activity.dart';
import 'package:pnu_plato_advanced_browser/data/activity/board_course_activity.dart';
import 'package:pnu_plato_advanced_browser/data/activity/file_course_activity.dart';
import 'package:pnu_plato_advanced_browser/data/activity/folder_course_activity.dart';
import 'package:pnu_plato_advanced_browser/data/activity/unknown_course_activity.dart';
import 'package:pnu_plato_advanced_browser/data/activity/url_course_activity.dart';
import 'package:pnu_plato_advanced_browser/data/activity/vod_course_activity.dart';
import 'package:pnu_plato_advanced_browser/data/activity/zoom_course_activity.dart';

enum CourseActivityType {
  ubboard,
  vod,
}

abstract class CourseActivity {
  final String title;
  final String id;
  final String courseTitle;
  final String courseId;
  final String description;
  final String info;
  final DateTime? startDate;
  final DateTime? endDate;
  final DateTime? lateDate;
  final String? iconUrl;
  final String availablilityInfo;
  final bool availablility;

  CourseActivity({
    required this.title,
    required this.id,
    required this.courseTitle,
    required this.courseId,
    required this.description,
    required this.info,
    this.startDate,
    this.endDate,
    this.lateDate,
    this.iconUrl,
    this.availablilityInfo = '',
    this.availablility = true,
  });

  @factory
  static CourseActivity fromType({
    required final String type,
    required final String title,
    required final String id,
    required final String courseTitle,
    required final String courseId,
    required final String info,
    required final String description,
    final DateTime? startDate,
    final DateTime? endDate,
    final DateTime? lateDate,
    final String? iconUrl,
    final String? url,
    final String availablilityInfo = '',
    final bool availablility = true,
  }) {
    switch (type) {
      case "ubboard":
        return BoardCourseActivity(
          title: title,
          id: id,
          courseTitle: courseTitle,
          courseId: courseId,
          info: info,
          description: description,
          startDate: startDate,
          endDate: endDate,
          lateDate: lateDate,
          iconUrl: iconUrl,
          availablilityInfo: availablilityInfo,
          availablility: availablility,
        );
      case "folder":
        return FolderCourseActivity(
          title: title,
          id: id,
          courseTitle: courseTitle,
          courseId: courseId,
          info: info,
          description: description,
          startDate: startDate,
          endDate: endDate,
          lateDate: lateDate,
          iconUrl: iconUrl,
          availablilityInfo: availablilityInfo,
          availablility: availablility,
        );
      case "ubfile":
        return FileCourseActivity(
          title: title,
          id: id,
          courseTitle: courseTitle,
          courseId: courseId,
          info: info,
          description: description,
          startDate: startDate,
          endDate: endDate,
          lateDate: lateDate,
          iconUrl: iconUrl,
          availablilityInfo: availablilityInfo,
          availablility: availablility,
        );
      case "url":
        return UrlCourseActivity(
          title: title,
          id: id,
          courseTitle: courseTitle,
          courseId: courseId,
          info: info,
          description: description,
          startDate: startDate,
          endDate: endDate,
          lateDate: lateDate,
          iconUrl: iconUrl,
          availablilityInfo: availablilityInfo,
          availablility: availablility,
        );
      case "vod":
        return VodCourseActivity(
          title: title,
          id: id,
          courseTitle: courseTitle,
          courseId: courseId,
          info: info,
          description: description,
          startDate: startDate,
          endDate: endDate,
          lateDate: lateDate,
          iconUrl: iconUrl,
          availablilityInfo: availablilityInfo,
          availablility: availablility,
        );
      case "zoom":
        return ZoomCourseActivity(
          title: title,
          id: id,
          courseTitle: courseTitle,
          courseId: courseId,
          info: info,
          description: description,
          startDate: startDate,
          endDate: endDate,
          lateDate: lateDate,
          iconUrl: iconUrl,
          availablilityInfo: availablilityInfo,
          availablility: availablility,
        );
      case "assign":
        return AssignCourseActivity(
          title: title,
          id: id,
          courseTitle: courseTitle,
          courseId: courseId,
          info: info,
          description: description,
          startDate: startDate,
          endDate: endDate,
          lateDate: lateDate,
          iconUrl: iconUrl,
          availablilityInfo: availablilityInfo,
          availablility: availablility,
        );
      default:
        return UnknownCourseActivity(
          title: title,
          id: id,
          courseTitle: courseTitle,
          courseId: courseId,
          info: info,
          description: description,
          startDate: startDate,
          endDate: endDate,
          lateDate: lateDate,
          iconUrl: iconUrl,
          availablilityInfo: availablilityInfo,
          availablility: availablility,
          url: url,
        );
    }
  }

  Future<void> openBottomSheet(final BuildContext context);
  Future<void> open(final BuildContext context);
}
