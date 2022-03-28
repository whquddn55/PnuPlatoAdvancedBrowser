import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:open_file/open_file.dart';
import 'package:path/path.dart';
import 'package:pnu_plato_advanced_browser/common.dart';
import 'dart:io';

import 'package:pnu_plato_advanced_browser/components/immersive_player/immersive_player.dart';
import 'package:pnu_plato_advanced_browser/controllers/route_controller.dart';
import 'package:watcher/watcher.dart';

class DirectoryPage extends StatefulWidget {
  final Directory rootDirectory;
  const DirectoryPage({Key? key, required this.rootDirectory}) : super(key: key);

  @override
  _DirectoryPageState createState() => _DirectoryPageState();
}

class _DirectoryPageState extends State<DirectoryPage> {
  Directory currentDirectory = Directory.systemTemp;

  @override
  void initState() {
    super.initState();

    _updateCurrentDirectory(widget.rootDirectory);
  }

  Widget _renderFolder(final BuildContext context, final Directory directory) {
    return ElevatedButton.icon(
      label: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Flexible(flex: 3, child: NFMarquee(text: basename(directory.path).split('\$')[0], fontWeight: FontWeight.w900)),
          Flexible(flex: 1, child: Text('(${basename(directory.path).split('\$')[1]})')),
        ],
      ),
      style: ElevatedButton.styleFrom(
        primary: Get.theme.cardColor,
        onPrimary: Get.textTheme.bodyText2!.color,
      ),
      icon: const Icon(Icons.folder_open),
      onPressed: () async => await _updateCurrentDirectory(directory),
      onLongPress: () {
        showDialog(
          context: context,
          builder: (context) {
            return AlertDialog(
              content: Text("${basename(directory.path).split('\$')[0]}(${basename(directory.path).split('\$')[1]})를 삭제합니다"),
              actions: [
                TextButton(child: const Text("취소"), onPressed: () => Navigator.pop(context)),
                TextButton(child: const Text("확인"), onPressed: () async => await _deleteFile(context, directory)),
              ],
            );
          },
        );
      },
    );
  }

  Widget _renderM3u8(final BuildContext context, final Directory directory) {
    /* m3u8파일 */
    bool show = false;
    int fileSize = 0;
    for (var file in directory.listSync()) {
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
            Flexible(flex: 3, child: NFMarquee(text: basename(directory.path), fontWeight: FontWeight.w900)),
            Flexible(flex: 1, child: Text(formatBytes(fileSize, 2), style: Get.textTheme.caption)),
          ],
        ),
        style: ElevatedButton.styleFrom(
          alignment: Alignment.centerLeft,
          primary: Get.theme.cardColor,
          onPrimary: Get.textTheme.bodyText2!.color,
        ),
        onPressed: () {
          Navigator.of(context, rootNavigator: true)
              .push(MaterialPageRoute(builder: (context) => ImmersivePlayer(url: directory.path + '/index.m3u8')));
        },
        onLongPress: () {
          showDialog(
            context: context,
            builder: (context) {
              return AlertDialog(
                content: Text("${basename(directory.path)}를 삭제합니다"),
                actions: [
                  TextButton(child: const Text("취소"), onPressed: () => Navigator.pop(context)),
                  TextButton(child: const Text("확인"), onPressed: () async => await _deleteFile(context, directory)),
                ],
              );
            },
          );
        },
      );
    } else {
      return ElevatedButton.icon(
        icon: const Icon(Icons.videocam),
        label: NFMarquee(text: basename(directory.path) + "(다운중...)", fontWeight: FontWeight.w900),
        style: ElevatedButton.styleFrom(
          alignment: Alignment.centerLeft,
          primary: Colors.grey,
          onPrimary: Colors.black,
          enableFeedback: false,
        ),
        onPressed: null,
        onLongPress: () => showDialog(
          context: context,
          builder: (context) {
            return AlertDialog(
              content: Text("${basename(directory.path)}를 삭제합니다"),
              actions: [
                TextButton(child: const Text("취소"), onPressed: () => Navigator.pop(context)),
                TextButton(child: const Text("확인"), onPressed: () async => await _deleteFile(context, directory)),
              ],
            );
          },
        ),
      );
    }
  }

  Widget _renderNormal(final BuildContext context, final FileSystemEntity fileSystemEntity) {
    return ElevatedButton.icon(
      icon: iconFromExtension(basename(fileSystemEntity.path).split('.').last),
      label: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Flexible(flex: 3, child: NFMarquee(text: basename(fileSystemEntity.path), fontWeight: FontWeight.w900)),
          Flexible(flex: 1, child: Text(formatBytes((fileSystemEntity as File).lengthSync(), 2), style: Get.textTheme.caption)),
        ],
      ),
      style: ElevatedButton.styleFrom(
        alignment: Alignment.centerLeft,
        primary: Get.theme.cardColor,
        onPrimary: Get.textTheme.bodyText2!.color,
      ),
      onPressed: () async {
        String? type;
        if (fileSystemEntity.path.toString().contains('zip')) type = "application/zip";
        var result = await OpenFile.open(fileSystemEntity.path, type: type);
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
              content: Text("${basename(fileSystemEntity.path)}를 삭제합니다"),
              actions: [
                TextButton(child: const Text("취소"), onPressed: () => Navigator.pop(context)),
                TextButton(child: const Text("확인"), onPressed: () async => await _deleteFile(context, fileSystemEntity)),
              ],
            );
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        if (currentDirectory.path == widget.rootDirectory.path) return true;
        _updateCurrentDirectory(currentDirectory.parent);
        return false;
      },
      child: GetBuilder<RouteController>(builder: (controller) {
        if (controller.currentIndex != 3) return const SizedBox.shrink();

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

        final String dirText = currentDirectory.path.replaceAll(widget.rootDirectory.path, '').split('\$')[0];

        return StreamBuilder<WatchEvent>(
          stream: Watcher(currentDirectory.path).events,
          builder: (context, snapshot) {
            final List<FileSystemEntity> fileList = currentDirectory.listSync();
            fileList.sort((a, b) {
              if (a is Directory && basename(a.path).contains('\$')) return -1;
              if (b is Directory && basename(b.path).contains('\$')) return 1;
              return a.statSync().changed.compareTo(b.statSync().changed);
            });

            final String totalStorageSize = formatBytes(_dirStatSync(widget.rootDirectory), 2);

            return Padding(
              padding: const EdgeInsets.fromLTRB(20, 20, 20, 0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(dirText == '' ? '/' : dirText),
                      Text('총 $totalStorageSize 사용중'),
                    ],
                  ),
                  Expanded(
                    child: ListView(
                      children: [
                        backButton,
                        ...fileList.map((FileSystemEntity e) {
                          if (e is Directory) {
                            if (basename(e.path).contains('\$')) {
                              return _renderFolder(context, e);
                            } else {
                              return _renderM3u8(context, e);
                            }
                          } else {
                            return _renderNormal(context, e);
                          }
                        }).toList()
                      ],
                    ),
                  ),
                ],
              ),
            );
          },
        );
      }),
    );
  }

  Future<void> _updateCurrentDirectory(Directory directory) async {
    setState(() {
      currentDirectory = directory;
    });
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
      rethrow;
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
  }
}
