import 'package:flutter/material.dart';

class MessageBuble extends StatelessWidget {
  final Key key;
  final String message;
  final String userName;
  final String userImage;
  final bool isMe;
  final bool msgSame;

  const MessageBuble(
    this.message,
    this.userName,
    this.userImage,
    this.isMe,
    this.msgSame, {
    this.key,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Row(
          mainAxisAlignment:
              isMe ? MainAxisAlignment.end : MainAxisAlignment.start,
          children: [
            Container(
              decoration: BoxDecoration(
                color: !isMe ? Colors.grey[300] : Theme.of(context).accentColor,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(14),
                  topRight: Radius.circular(14),
                  bottomLeft: !isMe ? Radius.circular(0) : Radius.circular(14),
                  bottomRight: isMe ? Radius.circular(0) : Radius.circular(14),
                ),
              ),
              width: 140,
              padding: EdgeInsets.symmetric(
                vertical: 10,
                horizontal: 16,
              ),
              margin: EdgeInsets.only(
                top:msgSame? 4:16,
                right: 8,
                left: 8,
              ),
              child: Column(
                crossAxisAlignment:
                    isMe ? CrossAxisAlignment.end : CrossAxisAlignment.start,
                children: [
                  if (!msgSame)
                    Text(
                      userName,
                      style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: !isMe
                              ? Colors.blueAccent
                              : Colors.yellowAccent.shade100),
                    ),
                  Text(
                    message,
                    style: TextStyle(
                        color: !isMe
                            ? Colors.black
                            : Theme.of(context)
                                .accentTextTheme
                                .headline6
                                .color),
                    textAlign: !isMe ? TextAlign.end : TextAlign.start,
                  ),
                ],
              ),
            )
          ],
        ),
        if (!msgSame)
          Positioned(
              top: 0,
              left: !isMe ? 120 : null,
              right: isMe ? 120 : null,
              child: CircleAvatar(
                backgroundImage: NetworkImage(userImage),
              ))
      ],
      overflow: Overflow.visible,
    );
  }
}
