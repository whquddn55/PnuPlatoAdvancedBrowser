import 'package:flutter/material.dart';

class LectureTile extends StatelessWidget {
  final int videoCnt;
  final int assignCnt;
  final int zoomCnt;
  final Color videoColor;
  final Color assignColor;
  final Color zoomColor;
  final String title;
  final String tail;

  const LectureTile({
    Key? key,
    this.videoCnt = 0,
    this.assignCnt = 0,
    this.zoomCnt = 0,
    this.videoColor = Colors.blue,
    this.assignColor = Colors.red,
    this.zoomColor = Colors.green,
    required this.title,
    required this.tail
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListTile(
      dense: true,
      leading: Column(
        children: [
          if (videoCnt != 0)
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  height: 10,
                  width: 10,
                  margin: const EdgeInsets.only(right: 5),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(5),
                    color: videoColor,
                  ),
                ),
                Text('$videoCnt'),
              ],
            ),
          if (assignCnt != 0)
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  height: 10,
                  width: 10,
                  margin: const EdgeInsets.only(right: 5),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(5),
                    color: assignColor,
                  ),
                ),
                Text('$assignCnt'),
              ],
            ),
          if (zoomCnt != 0)
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  height: 10,
                  width: 10,
                  margin: const EdgeInsets.only(right: 5),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(5),
                    color: zoomColor,
                  ),
                ),
                Text('$zoomCnt'),
              ],
            ),
        ],
      ),
      title: Text(title),
      trailing: Text('[$tail]'),
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10.0),
          side: const BorderSide(color:Colors.black)
      ),
    );
  }
}
