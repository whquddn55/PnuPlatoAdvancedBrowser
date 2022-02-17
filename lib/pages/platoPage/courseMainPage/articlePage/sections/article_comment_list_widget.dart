import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:pnu_plato_advanced_browser/common.dart';
import 'package:pnu_plato_advanced_browser/controllers/article_comment_controller.dart';
import 'package:pnu_plato_advanced_browser/data/article_comment.dart';

class ArticleCommentListWidget extends StatefulWidget {
  final ArticleCommentMetaData metaData;
  final List<ArticleComment>? commentList;
  const ArticleCommentListWidget(this.metaData, this.commentList, {Key? key}) : super(key: key);

  @override
  State<ArticleCommentListWidget> createState() => _ArticleCommentListWidgetState();
}

class _ArticleCommentListWidgetState extends State<ArticleCommentListWidget> {
  List<ArticleComment> commentList = <ArticleComment>[];
  final TextEditingController controller = TextEditingController();
  int? replyTargetIndex;

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
        Divider(height: 2, thickness: 1, color: Colors.grey[700]),
        const Text("댓글"),
        ..._renderCommentList(),
        renderReplyBox(),
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
                await _writeComment();
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
          Flexible(
            child: Card(
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
                              Row(
                                children: [
                                  Text(comment.writerName, style: const TextStyle(color: Colors.blueAccent)),
                                  const SizedBox(width: 10.0),
                                  Text(comment.date),
                                ],
                              ),
                              OutlinedButton(
                                child: const Text("답글"),
                                style: OutlinedButton.styleFrom(visualDensity: VisualDensity.compact),
                                onPressed: () async {
                                  var res = await _clearTextField();
                                  if (res) {
                                    setState(() {
                                      replyTargetIndex = commentList.indexOf(comment);
                                    });
                                  }
                                },
                              ),
                            ],
                          ),
                          Text(comment.contents),
                        ],
                      ),
                    )
                  ],
                ),
              ),
            ),
          ),
        ],
      );
    }).toList();
  }

  Widget renderReplyBox() {
    if (replyTargetIndex == null) {
      return const SizedBox(height: 8.0);
    }
    var comment = commentList[replyTargetIndex!];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        Divider(height: 2, thickness: 1, color: Colors.grey[700]),
        Card(
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
                          Row(
                            children: [
                              Text(comment.writerName, style: const TextStyle(color: Colors.blueAccent)),
                              const SizedBox(width: 10.0),
                              Text(comment.date),
                            ],
                          ),
                          OutlinedButton(
                            child: const Text("답글"),
                            style: OutlinedButton.styleFrom(visualDensity: VisualDensity.compact),
                            onPressed: () async {
                              var res = await _clearTextField();
                              if (res) {
                                setState(() {
                                  replyTargetIndex = commentList.indexOf(comment);
                                });
                              }
                            },
                          ),
                        ],
                      ),
                      Text(comment.contents),
                    ],
                  ),
                )
              ],
            ),
          ),
        ),
        const Text("의 답글"),
      ],
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
    var res = await ArticleCommentController.writeComment(
      content: controller.text,
      metaData: widget.metaData,
      targetId: replyTargetIndex == null ? null : commentList[replyTargetIndex!].commentId,
    );

    if (res != null) {
      controller.clear();
      setState(() {
        commentList = res;
        replyTargetIndex = null;
      });
    }
  }
}
