import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:pnu_plato_advanced_browser/common.dart';
import 'package:pnu_plato_advanced_browser/controllers/course_article_comment_controller.dart';
import 'package:pnu_plato_advanced_browser/data/article_comment.dart';

class ArticleCommentList extends StatefulWidget {
  final ArticleCommentMetaData metaData;
  final List<ArticleComment>? commentList;
  const ArticleCommentList(this.metaData, this.commentList, {Key? key}) : super(key: key);

  @override
  State<ArticleCommentList> createState() => _ArticleCommentListState();
}

class _ArticleCommentListState extends State<ArticleCommentList> {
  List<ArticleComment> commentList = <ArticleComment>[];
  final TextEditingController controller = TextEditingController();
  int? replyTargetIndex;
  ArticleComment? editTargetComment;

  @override
  void initState() {
    super.initState();
    if (widget.commentList != null) {
      commentList.addAll(widget.commentList!);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Divider(height: 20, thickness: 1, color: Colors.grey[700]),
        const Text("댓글"),
        ..._renderCommentList(),
        _renderReplyBox(),
        TextField(
          controller: controller,
          decoration: const InputDecoration(
            border: OutlineInputBorder(
              borderSide: BorderSide(color: Colors.grey),
            ),
            hintText: "댓글",
          ),
          maxLines: null,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            OutlinedButton(
              child: const Text("취소"),
              onPressed: () async {
                var res = await _clearTextField();
                if (res) {
                  setState(() {
                    replyTargetIndex = null;
                  });
                }
              },
            ),
            const SizedBox(width: 10.0),
            ElevatedButton(
              child: const Text("작성"),
              onPressed: () async {
                var dialogContext = await showProgressDialog(context, "댓글 작성중입니다...");
                if (editTargetComment != null) {
                  await _editComment();
                } else {
                  await _writeComment();
                }
                closeProgressDialog(dialogContext);
              },
            )
          ],
        ),
      ],
    );
  }

  List<Widget> _renderCommentList() {
    return commentList.map((comment) {
      return Row(
        children: [
          SizedBox(width: (comment.depth * 25.0)),
          Flexible(child: _renderArticleCommentCard(comment, false)),
        ],
      );
    }).toList();
  }

  Widget _renderReplyBox() {
    if (replyTargetIndex == null) {
      return const SizedBox(height: 8.0);
    }
    var comment = commentList[replyTargetIndex!];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        Divider(height: 2, thickness: 1, color: Colors.grey[700]),
        _renderArticleCommentCard(comment, true),
        Text(editTargetComment != null ? "를 수정합니다" : "의 답글을 작성합니다"),
      ],
    );
  }

  Widget _renderArticleCommentCard(final ArticleComment comment, bool isReply) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 50, width: 50, child: CachedNetworkImage(imageUrl: comment.imgUrl)),
            Flexible(
              fit: FlexFit.tight,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Flexible(
                        child: Text.rich(
                          TextSpan(
                            children: [
                              TextSpan(
                                text: comment.writerName,
                                style: const TextStyle(color: Colors.blueAccent),
                              ),
                              const TextSpan(text: "   "),
                              TextSpan(
                                text: comment.date,
                                style: const TextStyle(color: Colors.grey),
                              ),
                            ],
                          ),
                        ),
                      ),
                      isReply
                          ? const SizedBox.shrink()
                          : PopupMenuButton(
                              itemBuilder: (context) {
                                return [
                                  if (comment.repliable) const PopupMenuItem(child: Text("답글"), value: 0),
                                  if (comment.editable) const PopupMenuItem(child: Text("수정"), value: 1),
                                  if (comment.erasable) const PopupMenuItem(child: Text("삭제"), value: 2),
                                ];
                              },
                              onSelected: (index) async {
                                switch (index) {
                                  case 0:
                                    await _selectComment(comment, false);
                                    break;
                                  case 1:
                                    await _selectComment(comment, true);
                                    break;
                                  case 2:
                                    await _deleteComment(comment);
                                    break;
                                }
                              },
                            )
                    ],
                  ),
                  Text(comment.contents),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }

  Future<bool> _clearTextField() async {
    if (controller.text == '') {
      return true;
    }

    var res = await showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          content: const Text("댓글 작성을 취소하시겠습니까?"),
          actions: [
            TextButton(
              child: const Text("취소"),
              onPressed: () {
                Navigator.pop(context, false);
              },
            ),
            TextButton(
              child: const Text("확인"),
              onPressed: () {
                Navigator.pop(context, true);
              },
            ),
          ],
        );
      },
    );

    if (res) {
      controller.clear();
    }
    return res;
  }

  Future<void> _writeComment() async {
    var res = await CourseArticleCommentController.writeComment(
        replyTargetIndex == null ? null : commentList[replyTargetIndex!].commentId, widget.metaData, controller.text);

    if (res != null) {
      controller.clear();
      setState(() {
        commentList = res;
        replyTargetIndex = null;
      });
    } else {
      Fluttertoast.cancel();
      Fluttertoast.showToast(msg: "알 수 없는 이유로 작성에 실패하였습니다.");
    }
  }

  Future<void> _editComment() async {
    var res = await CourseArticleCommentController.editComment(editTargetComment!.commentId, widget.metaData, controller.text);

    if (res != null) {
      controller.clear();
      setState(() {
        commentList = res;
        replyTargetIndex = null;
      });
    } else {
      Fluttertoast.cancel();
      Fluttertoast.showToast(msg: "알 수 없는 이유로 수정에 실패하였습니다.");
    }
  }

  Future<void> _deleteComment(final ArticleComment comment) async {
    int index = commentList.indexOf(comment);
    bool deletable = (commentList.length == index + 1) || commentList[index + 1].depth <= commentList[index].depth;

    if (!deletable) {
      Fluttertoast.cancel();
      Fluttertoast.showToast(msg: "답글이 달린 댓글은 삭제할 수 없습니다.");
    } else {
      var dialogResult = await showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            content: const Text("댓글을 삭제합니다."),
            actions: [
              TextButton(
                child: const Text("취소"),
                onPressed: () {
                  Navigator.pop(context, false);
                },
              ),
              TextButton(
                child: const Text("삭제"),
                onPressed: () {
                  Navigator.pop(context, true);
                },
              )
            ],
          );
        },
      );

      if (dialogResult == true) {
        var dialogContext = await showProgressDialog(context, "삭제 중입니다..");
        var deleteResult = await CourseArticleCommentController.deleteComment(comment.commentId, widget.metaData);
        closeProgressDialog(dialogContext);
        if (deleteResult == null) {
          Fluttertoast.cancel();
          Fluttertoast.showToast(msg: "알 수 없는 이유로 삭제에 실패하였습니다.");
        } else {
          setState(() {
            commentList = deleteResult;
          });
        }
      }
    }
  }

  Future<void> _selectComment(final ArticleComment comment, final bool isEdit) async {
    var res = await _clearTextField();
    if (res) {
      setState(() {
        replyTargetIndex = commentList.indexOf(comment);
        if (isEdit) {
          editTargetComment = comment;
          controller.text = comment.contents;
        } else {
          editTargetComment = null;
        }
      });
    }
  }
}
