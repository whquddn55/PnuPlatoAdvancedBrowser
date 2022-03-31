import 'package:flutter/material.dart';
import 'package:pnu_plato_advanced_browser/controllers/firebase_controller.dart';

class BugReportInput extends StatefulWidget {
  final String studentId;
  final bool isAdmin;
  const BugReportInput(this.studentId, this.isAdmin, {Key? key}) : super(key: key);

  @override
  State<BugReportInput> createState() => _BugReportInputState();
}

class _BugReportInputState extends State<BugReportInput> {
  final _controller = TextEditingController();
  bool _isEmpty = true;

  void _buttonEvent() async {
    await FirebaseController.to.sendChat(widget.isAdmin, _controller.text);
    setState(() {
      _controller.clear();
      _isEmpty = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(top: 8),
      padding: const EdgeInsets.all(8),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              controller: _controller,
              maxLines: null,
              decoration: const InputDecoration(labelText: "Send new message..."),
              onChanged: (value) => setState(() {
                _isEmpty = value.trim().isEmpty;
              }),
            ),
          ),
          IconButton(
            icon: const Icon(Icons.send),
            color: Colors.blue,
            onPressed: _isEmpty ? null : _buttonEvent,
          ),
        ],
      ),
    );
  }
}
