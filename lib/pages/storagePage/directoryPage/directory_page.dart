import 'package:file_icon/file_icon.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:open_file/open_file.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart';
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

    Widget? backButton;
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
      padding: const EdgeInsets.all(20.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(dirText == '' ? '/' : dirText),
          SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                backButton ?? const SizedBox.shrink(),
                ...fileList.map((FileSystemEntity e) {
                  if (e is Directory) {
                    if (basename(e.path).contains('\$')) {
                      return ElevatedButton.icon(
                        label: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(basename(e.path).split('\$')[0]),
                            Text('(${basename(e.path).split('\$')[1]})'),
                          ],
                        ),
                        icon: const Icon(Icons.folder_open),
                        onPressed: () async => await _updateCurrentDirectory(e),
                      );
                    } else {
                      return ElevatedButton.icon(
                        icon: FileIcon('a.mp4'),
                        label: Text(basename(e.path)),
                        style: ElevatedButton.styleFrom(alignment: Alignment.centerLeft),
                        onPressed: () {
                          Navigator.of(context, rootNavigator: true)
                              .push(MaterialPageRoute(builder: (context) => Player(url: e.path + '/index.m3u8')));
                        },
                      );
                    }
                  } else {
                    return ElevatedButton.icon(
                      icon: FileIcon(basename(e.path)),
                      label: Text(basename(e.path)),
                      style: ElevatedButton.styleFrom(alignment: Alignment.centerLeft),
                      onPressed: () async {
                        var result = await OpenFile.open(e.path);
                        if (result.type != ResultType.done) {
                          Fluttertoast.cancel();
                          Fluttertoast.showToast(msg: result.message);
                        }
                      },
                    );
                  }
                }).toList()
              ],
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
}
