import 'package:html/dom.dart';
import 'package:pnu_plato_advanced_browser/common.dart';
import 'package:pnu_plato_advanced_browser/controllers/exception_controller.dart';
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
    final List<dynamic> fileList = [];
    for (var div in document.getElementById('intro')!.children) {
      if (div.id.contains('assign_files')) {
        _buildAttatchFileList(fileList, div.getElementsByTagName('ul')[0]);
        break;
      }
    }

    bool? submitted;
    bool? graded;
    DateTime? dueDate;
    String? dueString;
    CourseAssignDueType? dueType;
    DateTime? lastEditDate;
    String? team;
    final List<dynamic> attatchFileList = [];

    for (var element in document.getElementsByClassName('generaltable')[0].getElementsByTagName('tr')) {
      final String target = element.children[0].text;
      switch (target) {
        case "제출 여부":
          submitted = element.children[1].classes.contains('submissionstatussubmitted') ? true : false;
          break;
        case "채점 상황":
          graded = element.children[1].classes.contains('submissiongraded') ? true : false;
          break;
        case "종료 일시":
          dueDate = DateTime.parse(element.children[1].text);
          break;
        case "마감까지 남은 기한":
          dueString = element.children[1].text;
          if (element.children[1].classes.contains('earlysubmission')) {
            dueType = CourseAssignDueType.early;
          } else if (element.children[1].classes.contains('overdue')) {
            dueType = CourseAssignDueType.over;
          } else if (element.children[1].classes.contains('latesubmission')) {
            dueType = CourseAssignDueType.late;
          }
          break;
        case "최종 수정 일시":
          lastEditDate = DateTime.tryParse(element.children[1].text);
          break;
        case "첨부파일":
          _buildAttatchFileList(attatchFileList, element.children[1].getElementsByTagName('ul')[0]);
          break;
        case "팀":
          team = element.children[1].text;
          break;
        default:
          ExceptionController.onExpcetion("found new render model! $target");
      }
    }

    bool isUpadtedToOver = document
        .getElementsByClassName("alert-heading mb-2")
        .fold<bool>(false, (previousValue, element) => previousValue |= element.text == "과제 종료일시가 지났습니다.");

    bool submitable = document.getElementsByClassName("btn btn-secondary").isNotEmpty;

    CourseAssignGradeResult? gradeResult;
    if (graded == true) {
      String? grade;
      DateTime? gradeTime;
      String? graderName;
      String? graderId;
      Uri? graderIconUri;
      String? feedbackHtmlStr;
      for (var element in document.getElementsByClassName('generaltable')[1].getElementsByTagName('tr')) {
        if (element.children[0].text == '성적') {
          grade = element.children[1].text;
        } else if (element.children[0].text == '채점 일시') {
          gradeTime = DateTime.parse(element.children[1].text);
        } else if (element.children[0].text == '채점자') {
          graderName = element.children[1].text;
          graderId = element.children[1].getElementsByTagName('a')[0].attributes['href']!.split('&course=')[0].split('?id=')[1];
          graderIconUri = Uri.parse(element.children[1].getElementsByTagName('img')[0].attributes['src']!);
        } else if (element.children[0].text == '피드백') {
          feedbackHtmlStr = element.children[1].innerHtml;
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
        feedback: feedbackHtmlStr == null ? null : renderHtml(feedbackHtmlStr),
      );
    }

    return CourseAssign(
      title: title,
      content: renderHtml(contentStr),
      fileList: fileList,
      submitted: submitted,
      graded: graded,
      isUpadtedToOver: isUpadtedToOver,
      submitable: submitable,
      dueDate: dueDate,
      dueString: dueString,
      dueType: dueType,
      lastEditDate: lastEditDate,
      attatchFileList: attatchFileList,
      gradeResult: gradeResult,
      team: team,
    );
  }

  static void _buildAttatchFileList(List<dynamic> attatchFileList, Element ul) {
    for (var li in ul.children) {
      for (var element in li.children) {
        if (element.localName == "div") {
          if (element.getElementsByTagName('img')[0].attributes['src']!.contains('folder')) {
            attatchFileList.add({
              "title": element.text.trim(),
              "imgUrl": element.getElementsByTagName('img')[0].attributes['src']!,
              "folder": [],
            });
          } else {
            attatchFileList.add(CourseFile(
              imgUrl: element.getElementsByTagName('img')[0].attributes['src']!,
              title: element.getElementsByTagName('a')[0].text,
              url: element.getElementsByTagName('a')[0].attributes['href']!,
            ));
          }
        } else if (element.localName == "ul") {
          _buildAttatchFileList(attatchFileList.last["folder"], element);
        }
      }
    }
  }
}
