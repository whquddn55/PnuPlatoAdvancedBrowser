import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

class ArticleComments extends StatefulWidget {
  final List<Map<String, dynamic>>? commentList;
  const ArticleComments(this.commentList, {Key? key}) : super(key: key);

  @override
  State<ArticleComments> createState() => _ArticleCommentsState();
}

class _ArticleCommentsState extends State<ArticleComments> {
  List<Map<String, dynamic>> commentList = <Map<String, dynamic>>[];
  final TextEditingController controller = TextEditingController();
  int? replyTarget;

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
        ...commentList.map((comment) {
          return Row(
            children: [
              SizedBox(width: (comment["depth"] * 25.0)),
              Flexible(
                child: Card(
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(height: 50, width: 50, child: CachedNetworkImage(imageUrl: comment["imgUrl"])),
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
                                      Text(comment["writerName"], style: const TextStyle(color: Colors.blueAccent)),
                                      const SizedBox(width: 10.0),
                                      Text(comment["date"]),
                                    ],
                                  ),
                                  OutlinedButton(
                                    child: const Text("답글"),
                                    style: OutlinedButton.styleFrom(visualDensity: VisualDensity.compact),
                                    onPressed: () async {
                                      var res = await _clearTextField();
                                      if (res) {
                                        setState(() {
                                          replyTarget = commentList.indexOf(comment);
                                        });
                                      }
                                    },
                                  ),
                                ],
                              ),
                              Text(comment["contents"]),
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
        }).toList(),
        _replyBox(),
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
                    replyTarget = null;
                  });
                }
              },
            ),
            const SizedBox(width: 10.0),
            ElevatedButton(
              child: const Text("작성"),
              onPressed: () {},
            )
          ],
        ),
      ],
    );
  }

  Widget _replyBox() {
    if (replyTarget == null) {
      return const SizedBox(height: 8.0);
    }
    var comment = commentList[replyTarget!];

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
                SizedBox(height: 50, width: 50, child: CachedNetworkImage(imageUrl: comment["imgUrl"])),
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
                              Text(comment["writerName"], style: const TextStyle(color: Colors.blueAccent)),
                              const SizedBox(width: 10.0),
                              Text(comment["date"]),
                            ],
                          ),
                          OutlinedButton(
                            child: const Text("답글"),
                            style: OutlinedButton.styleFrom(visualDensity: VisualDensity.compact),
                            onPressed: () async {
                              var res = await _clearTextField();
                              if (res) {
                                setState(() {
                                  replyTarget = commentList.indexOf(comment);
                                });
                              }
                            },
                          ),
                        ],
                      ),
                      Text(comment["contents"]),
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
}
