import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:open_file/open_file.dart';
import 'package:path/path.dart';
import 'package:pnu_plato_advanced_browser/common.dart';
import 'dart:io';

import 'package:pnu_plato_advanced_browser/pages/storagePage/directoryPage/sections/player.dart';

class DirectoryPage extends StatefulWidget {
  final Directory rootDirectory;
  const DirectoryPage({Key? key, required this.rootDirectory}) : super(key: key);

  @override
  _DirectoryPageState createState() => _DirectoryPageState();
}

class _DirectoryPageState extends State<DirectoryPage> with AutomaticKeepAliveClientMixin {
  Directory currentDirectory = Directory.systemTemp;
  List<FileSystemEntity> fileList = [];

  @override
  void initState() {
    super.initState();

    _updateCurrentDirectory(widget.rootDirectory);
  }

  @override
  bool get wantKeepAlive => true;

  @override
  Widget build(BuildContext context) {
    super.build(context);

    fileList.sort((a, b) {
      if (a is Directory && basename(a.path).contains('\$')) return -1;
      if (b is Directory && basename(b.path).contains('\$')) return 1;
      return a.statSync().changed.compareTo(b.statSync().changed);
    });

    Widget backButton = const SizedBox.shrink();
    if (widget.rootDirectory.path != currentDirectory.path) {
      backButton = ElevatedButton.icon(
        label: const Text("뒤로가기"),
        icon: const Icon(Icons.arrow_back),
        style: ElevatedButton.styleFrom(
          primary: Get.theme.backgroundColor,
        ),
        onPressed: () => _updateCurrentDirectory(currentDirectory.parent),
      );
    }

    String dirText = currentDirectory.path.replaceAll(widget.rootDirectory.path, '').split('\$')[0];

    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 20, 20, 0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(dirText == '' ? '/' : dirText),
              Text('총 ${formatBytes(_dirStatSync(widget.rootDirectory), 2)} 사용중'),
            ],
          ),
          Expanded(
            child: RefreshIndicator(
              onRefresh: () => _refreshFileList(),
              child: ListView(
                children: [
                  backButton,
                  ...fileList.map((FileSystemEntity e) {
                    if (e is Directory) {
                      if (basename(e.path).contains('\$')) {
                        /* 강좌 폴더 */
                        return ElevatedButton.icon(
                          label: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(basename(e.path).split('\$')[0]),
                              Text('(${basename(e.path).split('\$')[1]})'),
                            ],
                          ),
                          style: ElevatedButton.styleFrom(
                            primary: Get.theme.cardColor,
                            onPrimary: Get.textTheme.bodyText2!.color,
                          ),
                          icon: const Icon(Icons.folder_open),
                          onPressed: () async => await _updateCurrentDirectory(e),
                          onLongPress: () {
                            showDialog(
                              context: context,
                              builder: (context) {
                                return AlertDialog(
                                  content: Text("${basename(e.path).split('\$')[0]}(${basename(e.path).split('\$')[1]})를 삭제합니다"),
                                  actions: [
                                    TextButton(child: const Text("취소"), onPressed: () => Navigator.pop(context)),
                                    TextButton(child: const Text("확인"), onPressed: () async => await _deleteFile(context, e)),
                                  ],
                                );
                              },
                            );
                          },
                        );
                      } else {
                        /* m3u8파일 */
                        bool show = false;
                        int fileSize = 0;
                        for (var file in e.listSync()) {
                          if (basename(file.path).contains('index')) {
                            show = true;
                          }
                          fileSize += (file as File).lengthSync();
                        }
                        if (show) {
                          return ElevatedButton.icon(
                            icon: const Icon(Icons.videocam),
                            label: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(basename(e.path)),
                                Text(formatBytes(fileSize, 2), style: Get.textTheme.caption),
                              ],
                            ),
                            style: ElevatedButton.styleFrom(
                              alignment: Alignment.centerLeft,
                              primary: Get.theme.cardColor,
                              onPrimary: Get.textTheme.bodyText2!.color,
                            ),
                            onPressed: () {
                              Navigator.of(context, rootNavigator: true)
                                  .push(MaterialPageRoute(builder: (context) => Player(url: e.path + '/index.m3u8')));
                            },
                            onLongPress: () {
                              showDialog(
                                context: context,
                                builder: (context) {
                                  return AlertDialog(
                                    content: Text("${basename(e.path)}를 삭제합니다"),
                                    actions: [
                                      TextButton(child: const Text("취소"), onPressed: () => Navigator.pop(context)),
                                      TextButton(child: const Text("확인"), onPressed: () async => await _deleteFile(context, e)),
                                    ],
                                  );
                                },
                              );
                            },
                          );
                        } else {
                          return ElevatedButton.icon(
                            icon: const Icon(Icons.videocam),
                            label: Text(basename(e.path) + "(다운중...)"),
                            style: ElevatedButton.styleFrom(
                              alignment: Alignment.centerLeft,
                              primary: Get.theme.cardColor,
                              onPrimary: Get.textTheme.bodyText2!.color,
                            ),
                            onPressed: null,
                          );
                        }
                      }
                    } else {
                      /* 일반파일 */
                      return ElevatedButton.icon(
                        icon: iconFromExtension(basename(e.path).split('.').last),
                        label: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(basename(e.path)),
                            Text(formatBytes((e as File).lengthSync(), 2), style: Get.textTheme.caption),
                          ],
                        ),
                        style: ElevatedButton.styleFrom(
                          alignment: Alignment.centerLeft,
                          primary: Get.theme.cardColor,
                          onPrimary: Get.textTheme.bodyText2!.color,
                        ),
                        onPressed: () async {
                          var result = await OpenFile.open(e.path);
                          if (result.type != ResultType.done) {
                            Fluttertoast.cancel();
                            Fluttertoast.showToast(msg: result.message);
                          }
                        },
                        onLongPress: () {
                          showDialog(
                            context: context,
                            builder: (context) {
                              return AlertDialog(
                                content: Text("${basename(e.path)}를 삭제합니다"),
                                actions: [
                                  TextButton(child: const Text("취소"), onPressed: () => Navigator.pop(context)),
                                  TextButton(child: const Text("확인"), onPressed: () async => await _deleteFile(context, e)),
                                ],
                              );
                            },
                          );
                        },
                      );
                    }
                  }).toList()
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _updateCurrentDirectory(Directory directory) async {
    setState(() {
      currentDirectory = directory;
      fileList = directory.listSync();
    });
  }

  Future<void> _refreshFileList() async {
    fileList.clear();
    await for (var i in currentDirectory.list()) {
      fileList.add(i);
    }
    setState(() {});
  }

  int _dirStatSync(Directory dir) {
    int totalSize = 0;
    try {
      if (dir.existsSync()) {
        dir.listSync(recursive: true, followLinks: false).forEach((FileSystemEntity entity) {
          if (entity is File) {
            totalSize += entity.lengthSync();
          }
        });
      }
    } catch (e) {
      print(e.toString());
    }

    return totalSize;
  }

  Future<void> _deleteFile(BuildContext context, FileSystemEntity file) async {
    Navigator.pop(context);
    showDialog(
      context: context,
      builder: (context) {
        return const Center(child: CircularProgressIndicator());
      },
    );

    try {
      await file.delete(recursive: true);

      Fluttertoast.cancel();
      Fluttertoast.showToast(msg: "삭제되었습니다.");
    } catch (e) {
      Fluttertoast.cancel();
      Fluttertoast.showToast(msg: e.toString());
    }

    Navigator.pop(context);
    await _refreshFileList();
  }
}
