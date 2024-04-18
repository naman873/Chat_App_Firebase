import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class ChatScreen extends StatefulWidget {
  String? docId;
  String? name;
  ChatScreen({this.docId, this.name});

  @override
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final TextEditingController _controller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.name ?? ""),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: <Widget>[
              StreamBuilder(
                stream: FirebaseFirestore.instance
                    .collection("chats")
                    .doc(widget.docId)
                    .collection("messages")
                    .orderBy("createdAt", descending: false)
                    .snapshots(),
                builder: (context, snapshot) {
                  if (!snapshot.hasData) {
                    return const Text(
                      'No Chats...',
                    );
                  } else {
                    return Expanded(
                      child: ListView.separated(
                        separatorBuilder: (context, index) {
                          return const SizedBox(
                            height: 10,
                          );
                        },
                        shrinkWrap: true,
                        itemCount: snapshot.data?.docs.length ?? 0,
                        itemBuilder: (context, index) {
                          final item = snapshot.data?.docs[index];
                          return Row(
                            mainAxisAlignment: item?["sendBy"] ==
                                    FirebaseAuth.instance.currentUser?.uid
                                ? MainAxisAlignment.end
                                : MainAxisAlignment.start,
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Container(
                                width: MediaQuery.of(context).size.width * 0.5,
                                height:
                                    MediaQuery.of(context).size.height * 0.06,
                                padding: const EdgeInsets.all(8),
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(8),
                                  border: Border.all(),
                                ),
                                child: Text(
                                  item?["message"].toString() ?? "",
                                ),
                              ),
                            ],
                          );
                        },
                      ),
                    );
                  }
                },
              ),
              const Divider(height: 1.0),
              _buildTextComposer(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTextComposer() {
    return Container(
      decoration: BoxDecoration(color: Theme.of(context).cardColor),
      child: Row(
        children: <Widget>[
          Flexible(
            child: TextField(
              controller: _controller,
              decoration: const InputDecoration.collapsed(
                hintText: 'Send a message',
              ),
            ),
          ),
          IconButton(
            icon: const Icon(Icons.send),
            onPressed: () => _handleSubmitted(_controller.text),
          ),
        ],
      ),
    );
  }

  void _handleSubmitted(String text) async {
    await FirebaseFirestore.instance
        .collection("chats")
        .doc(widget.docId)
        .collection('messages')
        .add({
      "message": text,
      "sendBy": FirebaseAuth.instance.currentUser?.uid,
      "createdAt": FieldValue.serverTimestamp(),
    }).then((value) {
      _controller.text = "";
    });
  }
}
