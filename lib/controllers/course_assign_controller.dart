import 'package:html/dom.dart';
import 'package:pnu_plato_advanced_browser/common.dart';
import 'package:pnu_plato_advanced_browser/data/course_assign.dart';
import 'package:pnu_plato_advanced_browser/data/course_file.dart';
import 'package:pnu_plato_advanced_browser/data/professor.dart';

abstract class CourseAssignController {
  static Future<CourseAssign?> fetchCourseAssign(final String assignId) async {
    var response = await requestGet(CommonUrl.courseAssignViewUrl + assignId, isFront: true);

    if (response == null) {
      return null;
    }

    var document = Document.html(response.data);

    final String title = document.getElementsByClassName('breadcrumb')[0].children.last.text.trim();
    final String contentStr = document.getElementById('intro')!.getElementsByClassName('no-overflow').isEmpty
        ? ''
        : document.getElementById('intro')!.getElementsByClassName('no-overflow')[0].innerHtml;
    final List<CourseFile> fileList = [];
    for (var fileElement in document.getElementById('intro')!.getElementsByTagName('li')) {
      fileList.add(
        CourseFile(
          imgUrl: fileElement.getElementsByTagName('img')[0].attributes['src']!,
          title: fileElement.getElementsByTagName('a')[0].text,
          url: fileElement.getElementsByTagName('a')[0].attributes['href']!,
        ),
      );
    }

    bool? submitted;
    bool? graded;
    DateTime? dueDate;
    String? dueString;
    CourseAssignDueType? dueType;
    DateTime? lastEditDate;
    final List<CourseFile> attatchFileList = [];

    for (var element in document.getElementsByClassName('generaltable')[0].getElementsByTagName('tr')) {
      if (element.children[0].text == '제출 여부') {
        submitted = element.children[1].classes.contains('submissionstatussubmitted') ? true : false;
      } else if (element.children[0].text == '채점 상황') {
        graded = element.children[1].classes.contains('submissiongraded') ? true : false;
      } else if (element.children[0].text == '종료 일시') {
        dueDate = DateTime.parse(element.children[1].text);
      } else if (element.children[0].text == '마감까지 남은 기한') {
        dueString = element.children[1].text;
        if (element.children[1].classes.contains('earlysubmission')) {
          dueType = CourseAssignDueType.early;
        } else if (element.children[1].classes.contains('overdue')) {
          dueType = CourseAssignDueType.over;
        } else if (element.children[1].classes.contains('latesubmission')) {
          dueType = CourseAssignDueType.late;
        }
      } else if (element.children[0].text == '최종 수정 일시') {
        lastEditDate = DateTime.tryParse(element.children[1].text);
      } else if (element.children[0].text == '첨부파일') {
        for (var fileElement in element.children[1].getElementsByTagName('li')) {
          attatchFileList.add(CourseFile(
            imgUrl: fileElement.getElementsByTagName('img')[0].attributes['src']!,
            title: fileElement.getElementsByTagName('a')[0].text,
            url: fileElement.getElementsByTagName('a')[0].attributes['href']!,
          ));
        }
      }
    }

    CourseAssignGradeResult? gradeResult;
    if (document.getElementsByClassName('generaltable').length >= 2) {
      String? grade;
      DateTime? gradeTime;
      String? graderName;
      String? graderId;
      Uri? graderIconUri;
      for (var element in document.getElementsByClassName('generaltable')[1].getElementsByTagName('tr')) {
        if (element.children[0].text == '성적') {
          grade = element.children[1].text;
        } else if (element.children[0].text == '채점 일시') {
          gradeTime = DateTime.parse(element.children[1].text);
        } else if (element.children[0].text == '채점자') {
          graderName = element.children[1].text;
          graderId = element.children[1].getElementsByTagName('a')[0].attributes['href']!.split('&course=')[0].split('?id=')[1];
          graderIconUri = Uri.parse(element.children[1].getElementsByTagName('img')[0].attributes['src']!);
        }
      }

      gradeResult = CourseAssignGradeResult(
        grade: grade!,
        gradeTime: gradeTime!,
        grader: Professor(
          name: graderName!,
          id: graderId!,
          iconUri: graderIconUri!,
        ),
      );
    }

    return CourseAssign(
      title: title,
      content: renderHtml(contentStr),
      fileList: fileList,
      submitted: submitted,
      graded: graded,
      dueDate: dueDate,
      dueString: dueString,
      dueType: dueType,
      lastEditDate: lastEditDate,
      attatchFileList: attatchFileList,
      gradeResult: gradeResult,
    );
  }
}
