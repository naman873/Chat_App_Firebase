import 'package:chat_app/screens/signup_screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../controller/auth_controller.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: MediaQuery.of(context).size.height * 0.15),
            Center(child: Image.asset("assets/images/login_image.jpg")),
            SizedBox(
              height: MediaQuery.of(context).size.height * 0.01,
            ),
            TextFormField(
              controller: emailController,
              decoration: const InputDecoration(
                hintText: "Username",
                hintStyle: TextStyle(
                  fontSize: 16,
                  color: Color(0xff635C5C),
                  fontFamily: 'Poppins',
                ),
                contentPadding:
                    EdgeInsets.symmetric(vertical: 15, horizontal: 10),
                border: OutlineInputBorder(
                  borderSide: BorderSide(
                    color: Colors.grey,
                    width: 4,
                  ),
                ),
                enabledBorder: OutlineInputBorder(
                  borderSide: BorderSide(
                    color: Colors.grey,
                    width: 1,
                  ),
                ),
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(
                    color: Colors.grey,
                    width: 2,
                  ),
                ),
              ),
            ),
            SizedBox(
              height: MediaQuery.of(context).size.height * 0.03,
            ),
            TextFormField(
              controller: passwordController,
              decoration: const InputDecoration(
                hintText: "Password",
                hintStyle: TextStyle(
                  fontSize: 16,
                  color: Color(0xff635C5C),
                  fontFamily: 'Poppins',
                ),
                contentPadding:
                    EdgeInsets.symmetric(vertical: 15, horizontal: 10),
                border: OutlineInputBorder(
                  borderSide: BorderSide(
                    color: Colors.grey,
                    width: 4,
                  ),
                ),
                enabledBorder: OutlineInputBorder(
                  borderSide: BorderSide(
                    color: Colors.grey,
                    width: 1,
                  ),
                ),
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(
                    color: Colors.grey,
                    width: 2,
                  ),
                ),
              ),
            ),
            SizedBox(
              height: MediaQuery.of(context).size.height * 0.03,
            ),
            Consumer<AuthController>(builder: (context, auth, child) {
              return auth.loader == false
                  ? ElevatedButton(
                      style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xffF68326),
                          fixedSize: Size(MediaQuery.of(context).size.width,
                              MediaQuery.of(context).size.height * 0.07),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          elevation: 5),
                      onPressed: () {
                        if (emailController.text != "" &&
                            passwordController.text != "") {
                          Provider.of<AuthController>(context, listen: false)
                              .loginUser(emailController.text,
                                  passwordController.text, context);
                        } else {
                          if (emailController.text == "") {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text("Please Enter UserName"),
                              ),
                            );
                          } else {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text("Please Enter Password"),
                              ),
                            );
                          }
                        }
                      },
                      child: const Text(
                        "Login",
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 24,
                            fontWeight: FontWeight.w600),
                      ))
                  : const Center(
                      child: CircularProgressIndicator(),
                    );
            }),
            SizedBox(
              height: MediaQuery.of(context).size.height * 0.07,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                const Text(
                  "Don't Have an account?",
                  style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w400,
                      fontFamily: 'Poppins'),
                ),
                const SizedBox(
                  width: 10,
                ),
                GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) {
                          return SignUpScreen();
                        },
                      ),
                    );
                  },
                  child: const Text(
                    "SignUp",
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      fontFamily: 'Poppins',
                    ),
                  ),
                )
              ],
            ),
            SizedBox(
              height: MediaQuery.of(context).size.height * 0.12,
            ),
            const Center(
              child: Text(
                "Chat App",
                style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w400,
                    fontFamily: 'Poppins'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
