// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables, must_be_immutable, prefer_final_fields, file_names, use_build_context_synchronously, library_private_types_in_public_api


import 'package:flutter/material.dart';


import '../../firebase/auth.dart';


import 'regisPage.dart';


class LoginPage extends StatefulWidget {

  const LoginPage({Key? key}) : super(key: key);


  @override

  _LoginPageState createState() => _LoginPageState();

}


class _LoginPageState extends State<LoginPage> {

  bool isPasswordVisible = false;


  bool _loading = false;


  final _formKey = GlobalKey<FormState>();


  final TextEditingController _ctrlEmail = TextEditingController();


  final TextEditingController _ctrlPassword = TextEditingController();


  Future<void> handleSubmit() async {

    if (!_formKey.currentState!.validate()) return;


    final email = _ctrlEmail.value.text;


    final password = _ctrlPassword.value.text;


    setState(() => _loading = true);


    try {

      await Auth().login(email, password);


      ScaffoldMessenger.of(context).showSnackBar(

        SnackBar(

          content: Text("Login successful!"),

          duration: Duration(seconds: 3),

          backgroundColor: Colors.blue,

        ),

      );


      Navigator.pushNamed(context, '/home');

    } catch (e) {

      ScaffoldMessenger.of(context).showSnackBar(

        SnackBar(

          content: Text("Failed to login!"),

          duration: Duration(seconds: 2),

          backgroundColor: Colors.red,

        ),

      );

    } finally {

      setState(() => _loading = false);

    }

  }


  @override

  Widget build(BuildContext context) {

    return Scaffold(

      body: ListView(

        children: [
          Container(
            height: 200,
            color: Colors.blueAccent,
            child: const Padding(
              padding: EdgeInsets.only(top: 60.0, left: 22),
              child: Text(
                'Hello\nWelcome Back!',
                style: TextStyle(
                  fontSize: 30,
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),

          Form(
            key: _formKey,
            child: Container(
            
              decoration: const BoxDecoration(
            
                borderRadius: BorderRadius.only(
            
                  topLeft: Radius.circular(40),
            
                  topRight: Radius.circular(40),
            
                ),
            
                // color: Colors.white,
            
              ),
            
              child: Padding(
            
                padding: const EdgeInsets.only(left: 18.0, right: 18),
            
                child: Column(
            
                  mainAxisAlignment: MainAxisAlignment.center,
            
                  children: [
            
                    TextFormField(
            
                      controller: _ctrlEmail,
            
                      validator: (value) {
            
                        if (value == null || value.isEmpty) {
            
                          return 'Email cannot be empty';
            
                        }
            
                        return null;
            
                      },
            
                      decoration: InputDecoration(
            
                        labelText: 'Email',
                        prefixIcon: Icon(Icons.email),
            
                        labelStyle: TextStyle(
            
                          fontWeight: FontWeight.bold,
            
                          // color: Colors.black,
                          
            
                        ),
            
                      ),
            
                    ),
            
                    TextFormField(
            
                      controller: _ctrlPassword,
            
                      obscureText: !isPasswordVisible,
            
                      validator: (value) {
            
                        if (value == null || value.isEmpty) {
            
                          return 'Password cannot be empty';
            
                        }
            
            
                        return null;
            
                      },
            
                      decoration: InputDecoration(
                        prefixIcon: Icon(Icons.lock),
          
                        suffixIcon: IconButton(
            
                          icon: Icon(
            
                            isPasswordVisible
            
                                ? Icons.visibility
            
                                : Icons.visibility_off,
            
                            // color: Colors.grey,
            
                          ),
            
                          onPressed: () {
            
                            setState(() {
            
                              isPasswordVisible = !isPasswordVisible;
            
                            });
            
                          },
            
                        ),
            
                        labelText: 'Password',
            
                        labelStyle: const TextStyle(
            
                          fontWeight: FontWeight.bold,
            
                          // color: Colors.black,
            
                        ),
            
                      ),
            
                    ),
            
                    const SizedBox(
            
                      height: 50,
            
                    ),
            
                    GestureDetector(
            
                      onTap: () => handleSubmit(),
            
                      child: _loading
            
                          ? const SizedBox(
            
                              width: 20,
            
                              height: 20,
            
                              child: CircularProgressIndicator(
            
                                color: Colors.white,
            
                                strokeWidth: 2,
            
                              ),
            
                            )
            
                          : Container(
            
                              height: 55,
            
                              width: 300,
            
                              decoration: BoxDecoration(
            
                                borderRadius: BorderRadius.circular(30),
            
                                color: Colors.blueAccent,
            
                              ),
            
                              child: const Center(
            
                                child: Text(
            
                                  'SIGN IN',
            
                                  style: TextStyle(
            
                                    fontWeight: FontWeight.bold,
            
                                    fontSize: 20,
            
                                    color: Colors.white,
            
                                  ),
            
                                ),
            
                              ),
            
                            ),
            
                    ),
            
                    const SizedBox(
            
                      height: 20, // Adjusted height
            
                    ),
            
                    Row(
            
                      mainAxisAlignment: MainAxisAlignment.center,
            
                      children: [
            
                        const Text(
            
                          "Don't have an account?",
            
                          style: TextStyle(
            
                            fontWeight: FontWeight.bold,
            
                            color: Colors.grey,
            
                          ),
            
                        ),
            
                        GestureDetector(
            
                          onTap: () {
            
                            // Navigate to RegisPage when "Sign up" is tapped
            
            
                            Navigator.push(
            
                              context,
            
                              MaterialPageRoute(
            
                                  builder: (context) => const RegisPage()),
            
                            );
            
                          },
            
                          child: const Text(
            
                            " Sign up",
            
                            style: TextStyle(
            
                              fontWeight: FontWeight.bold,
            
                              fontSize: 17,
            
                              color: Colors.blueAccent,
            
                            ),
            
                          ),
            
                        ),
            
                      ],
            
                    ),
            
                  ],
            
                ),
            
              ),
            
            ),
          ),

        ],

      ),

    );

  }

}

