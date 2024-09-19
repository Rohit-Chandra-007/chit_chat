import 'package:chit_chat/widgets/message_bubble.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';

class ChatMessages extends StatefulWidget {
  const ChatMessages({super.key});

  @override
  State<ChatMessages> createState() => _ChatMessagesState();
}

class _ChatMessagesState extends State<ChatMessages> {
  void setupPushNotification() async {
    final fcm = FirebaseMessaging.instance;
    await fcm.requestPermission();
    // final token = await fcm.getToken();
    // print(token);

    fcm.subscribeToTopic('chat');
  }

  @override
  void initState() {
    setupPushNotification();
    super.initState();
  }


  @override
  Widget build(BuildContext context) {
    final authenticatedUser = FirebaseAuth.instance.currentUser!;
    return StreamBuilder(
      stream: FirebaseFirestore.instance
          .collection('chat')
          .orderBy('createdAt', descending: true)
          .snapshots(),
      builder: (context, chatSnapshot) {
        if (chatSnapshot.connectionState == ConnectionState.waiting) {
          return const Center(
            child: SizedBox(
              width: 50,
              height: 50,
              child: CircularProgressIndicator(
                color: Color(0xff1DA1F2),
              ),
            ),
          );
        }
        if (!chatSnapshot.hasData || chatSnapshot.data!.docs.isEmpty) {
          return const Center(
            child: Text('No new Messages'),
          );
        }
        if (chatSnapshot.hasError) {
          return const Center(
            child: Text('Something went wrong'),
          );
        }
        final chatList = chatSnapshot.data!.docs;
        return ListView.builder(
          itemCount: chatList.length,
          reverse: true,
          itemBuilder: (context, index) {
            final chatMessage = chatList[index].data();
            final nextChatMessgae =
                index + 1 < chatList.length ? chatList[index + 1].data() : null;
            final currentUserId = chatMessage['userId'];
            final nextMsgUserId =
                nextChatMessgae != null ? nextChatMessgae['userId'] : null;

            final nextUserIsSame = currentUserId == nextMsgUserId;
            if (nextUserIsSame) {
              return MessageBubble.next(
                message: chatMessage['text'],
                isMe: authenticatedUser.uid == currentUserId,
              );
            } else {
              return MessageBubble.first(
                userImage: null,
                username: chatMessage['username'],
                message: chatMessage['text'],
                isMe: authenticatedUser.uid == currentUserId,
              );
            }
          },
        );
      },
    );
  }
}
