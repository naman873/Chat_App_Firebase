import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../controller/auth_controller.dart';
import 'chat_screen.dart';
import 'login_screen.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Users"),
        automaticallyImplyLeading: false,
        centerTitle: true,
        actions: [
          IconButton(
            onPressed: () {
              Provider.of<AuthController>(context, listen: false).logoutUser();
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                  builder: (context) {
                    return const LoginScreen();
                  },
                ),
              );
            },
            icon: const Icon(Icons.logout),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(vertical: 15.0, horizontal: 20),
        child: Column(
          children: [
            StreamBuilder(
              stream: FirebaseFirestore.instance
                  .collection("users")
                  .where(
                    "uid",
                    isNotEqualTo: FirebaseAuth.instance.currentUser?.uid,
                  )
                  .snapshots(),
              builder: (context, snapshot) {
                if (!snapshot.hasData) {
                  return const Text(
                    'No Data...',
                  );
                } else {
                  return ListView.separated(
                    shrinkWrap: true,
                    itemCount: snapshot.data?.docs.length ?? 0,
                    separatorBuilder: (context, index) {
                      return const SizedBox(
                        height: 20,
                      );
                    },
                    itemBuilder: (context, index) {
                      final item = snapshot.data?.docs[index];
                      return GestureDetector(
                        onTap: () {
                          final String? sender1 =
                              FirebaseAuth.instance.currentUser?.uid;
                          final String? sender2 = item?["uid"].toString();

                          final String finalData =
                              (sender1 ?? "") + (sender2 ?? "");
                          final List<String> charList = finalData.split('');
                          charList.sort();
                          final String docId = charList.join('');

                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) {
                                return ChatScreen(
                                  docId: docId,
                                  name: item?["name"].toString(),
                                );
                              },
                            ),
                          );
                        },
                        child: Container(
                          padding: const EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(8),
                            border: Border.all(),
                          ),
                          child: Text(
                            item?["name"].toString() ?? "",
                          ),
                        ),
                      );
                    },
                  );
                }
              },
            )
          ],
        ),
      ),
    );
  }
}
