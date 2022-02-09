import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

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
    await FirebaseFirestore.instance.collection('users').doc(widget.studentId).collection('chats').add({
      "isUser": !widget.isAdmin,
      "text": _controller.text,
      "time": Timestamp.now(),
    });

    setState(() {
      _controller.clear();
      _isEmpty = true;
    });

    await FirebaseFirestore.instance.collection('users').doc(widget.studentId).update({
      "time": Timestamp.now(),
      (widget.isAdmin ? "unread" : "adminUnread"): FieldValue.increment(1),
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
