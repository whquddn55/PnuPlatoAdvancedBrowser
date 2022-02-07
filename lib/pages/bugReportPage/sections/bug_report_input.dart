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
  String _message = '';

  void _buttonEvent() async {
    await FirebaseFirestore.instance.collection('chats').doc(widget.studentId).collection('messages').add({
      "isUser": !widget.isAdmin,
      "text": _message,
      "time": Timestamp.now(),
    });
    await FirebaseFirestore.instance.collection('chats').doc(widget.studentId).update({
      "time": Timestamp.now(),
      (widget.isAdmin ? "unread" : "adminUnread"): FieldValue.increment(1),
    });
    _controller.clear();
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
                _message = value;
              }),
            ),
          ),
          IconButton(
            icon: const Icon(Icons.send),
            color: Colors.blue,
            onPressed: _message.trim().isEmpty ? null : _buttonEvent,
          ),
        ],
      ),
    );
  }
}
