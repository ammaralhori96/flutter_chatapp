import '/widget/chat/message_buble.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class Messages extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
        stream: FirebaseFirestore.instance
            .collection("chat")
            .orderBy('createdAt', descending: true)
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator(backgroundColor: Colors.pink,));
          }

          final docs = snapshot.data.docs;
          final User user = FirebaseAuth.instance.currentUser;
          return ListView.builder(
              reverse: true,
              itemCount: docs.length,
              itemBuilder: (ctx, index) {
                bool msgSame = false;
                if (index < docs.length - 1) {
                  docs[index + 1]['userId'] == docs[index]['userId']
                      ? msgSame = true
                      : msgSame = false;
                  if (index == docs.length - 1) msgSame = false;

                }

                return MessageBuble(
                  docs[index]['tex'],
                  docs[index]['username'],
                  docs[index]['userImage'],
                  docs[index]['userId'] == user.uid,
                  msgSame,
                  key: ValueKey(docs[index].id),

                  //key: ValueKey("hjkghjhg"),
                );
              });
        });
  }
}
