import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class NewMessages extends StatefulWidget {
  @override
  _NewMessagesState createState() => _NewMessagesState();
}

class _NewMessagesState extends State<NewMessages> {
  final _controler = TextEditingController();
  String _enterdMessage = "";

  _sendMessage() async {
    FocusScope.of(context).unfocus();
    final user = FirebaseAuth.instance.currentUser;
    final userData = await FirebaseFirestore.instance
        .collection('users')
        .doc(user.uid)
        .get();
    FirebaseFirestore.instance.collection("chat").add({
      'tex': _enterdMessage,
      "createdAt": Timestamp.now(),
      "username": userData['username'],
      "userId": user.uid,
      "userImage": userData['image_url'],
    });
    _controler.clear();
    setState(() {
      _enterdMessage = "";
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.green[50],
      margin: EdgeInsets.only(top: 8),
      padding: EdgeInsets.all(8),
      child: Row(
        children: [
          Expanded(
              child: TextField(
            autocorrect: true,
            enableSuggestions: true,
            textCapitalization: TextCapitalization.sentences,
            controller: _controler,
            decoration: InputDecoration(
                enabledBorder: UnderlineInputBorder(
                  borderSide: BorderSide(color: Theme.of(context).primaryColor),
                ),
                hintText: 'Send a message...',
                hintStyle: TextStyle(color: Theme.of(context).primaryColor)),
            onChanged: (val) {
              setState(() {
                _enterdMessage = val;
              });
            },
          )),
          IconButton(
              color: Theme.of(context).primaryColor,
              disabledColor: Colors.grey,
              onPressed: _enterdMessage.trim().isEmpty ? null : _sendMessage,
              icon: Icon(
                Icons.send,
              )),
        ],
      ),
    );
  }
}
