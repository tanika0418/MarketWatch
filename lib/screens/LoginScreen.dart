import 'package:flutter/material.dart';
import 'package:market_watch/providers/AuthProvider.dart';
import 'package:market_watch/utils/Extensions.dart';
import 'package:provider/provider.dart';
import 'package:websafe_svg/websafe_svg.dart';

import '../utils/Constants.dart';
import '../utils/InputField.dart';
import '../utils/MToast.dart';
import '../utils/Responsive.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  bool _isLoading = false;
  final _emailIdController = TextEditingController();
  final _passwordController = TextEditingController();
  final _nameController = TextEditingController();
  final _contactController = TextEditingController();
  bool _loginToggle = true;

  @override
  void dispose() {
    _emailIdController.dispose();
    _passwordController.dispose();
    _nameController.dispose();
    _contactController.dispose();
    super.dispose();
  }

  Future<void> _login() async {
    setState(() {
      _isLoading = true;
    });

    final email = _emailIdController.text.trim();
    final password = _passwordController.text.trim();

    if (email.isEmpty) {
      _showError("Email field is empty");
      return;
    } else if (password.isEmpty) {
      _showError("Password field is empty");
      return;
    }
    try {
      await Provider.of<AuthProvider>(context, listen: false)
          .login(email, password);
    } catch (error) {
      var errorString = error.toString();
      if (errorString.startsWith("[firebase_auth/wrong-password]")) {
        _showError("Wrong password, please try again");
      } else if (errorString.startsWith("[firebase_auth/invalid-email]")) {
        _showError("The email address is badly formatted");
      } else if (errorString.startsWith("[firebase_auth/user-not-found]")) {
        _showError("User with email not found");
      } else if (errorString.startsWith(ExceptionString + SYSTEM_ERROR)) {
        _showError(errorString.split(ExceptionString + SYSTEM_ERROR).last);
      } else {
        _showError("Something went wrong");
      }
    }
  }

  Future<void> _signup() async {
    setState(() {
      _isLoading = true;
    });
    final email = _emailIdController.text.trim();
    final password = _passwordController.text.trim();
    final name = _nameController.text.trim();
    final contact = _contactController.text.trim();

    if (email.isEmpty) {
      _showError("Email field is empty");
      return;
    } else if (password.isEmpty) {
      _showError("Password field is empty");
      return;
    } else if (name.isEmpty) {
      _showError("Name field is empty");
      return;
    } else if (contact.isEmpty) {
      _showError("Contact number field is empty");
      return;
    }
    try {
      await Provider.of<AuthProvider>(context, listen: false)
          .signup(email, password, name, contact);
     // showMWToast(context,
       //   message: "Account created successfully", isError: false);
    } catch (error) {
      var errorString = error.toString();
      if (errorString.endsWith("(auth/email-already-in-use).")) {
        _showError("Account already exists");
      } else if (errorString.startsWith("(auth/invalid-email).")) {
        _showError("The email address is badly formatted");
      } else if (errorString.endsWith("(auth/weak-password).")) {
        _showError("Password is not strong enough");
      } else {
        print(errorString);
        _showError("something went wrong");
      }
    }
  }

  void _showError(String message) {
    showMWToast(
      context,
      message: message,
      isError: true,
    );
    setState(() {
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    double _width = Responsive.isMobile(context) ? double.infinity : 280;
    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage("assets/images/main_bg.jpg"),
            fit: BoxFit.cover,
            opacity: 0.6,
          ),
        ),
        child: Center(
          child: IntrinsicHeight(
            child: Container(
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.8),
                borderRadius: BorderRadius.circular(15),
                image: DecorationImage(
                  image: AssetImage("assets/images/glass_texture.jpg"),
                  fit: BoxFit.cover,
                  opacity: 0.1,
                ),
              ),
              child: Padding(
                padding: EdgeInsets.symmetric(vertical: kDefaultPadding * 1.75),
                child: Column(
                  children: [
                    WebsafeSvg.asset(
                      "assets/icons/marketwatch-logo.svg",
                      height: 38,
                    ),
                    SizedBox(height: kDefaultPadding * 1.5),
                    Padding(
                      padding:
                          EdgeInsets.symmetric(horizontal: kDefaultPadding * 2),
                      child: _loginToggle
                          ? Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                buildInputField(
                                  name: "Email ID",
                                  width: _width,
                                  icon: Icons.email,
                                  controller: _emailIdController,
                                ),
                                SizedBox(height: kDefaultPadding),
                                buildInputField(
                                  name: "Password",
                                  width: _width,
                                  isObs: true,
                                  icon: Icons.key_rounded,
                                  controller: _passwordController,
                                ),
                                SizedBox(height: kDefaultPadding * 1.5),
                                _isLoading
                                    ? Container(
                                        width: _width,
                                        child: Center(
                                          child: CircularProgressIndicator(
                                              color: kPrimaryColor),
                                        ),
                                      )
                                    : InkWell(
                                        onTap: _login,
                                        child: Container(
                                          width: _width,
                                          padding: EdgeInsets.all(
                                              kDefaultPadding * 0.75),
                                          decoration: BoxDecoration(
                                            color: kPrimaryColor,
                                            borderRadius:
                                                BorderRadius.circular(15),
                                          ),
                                          child: Center(
                                            child: Text(
                                              "Login",
                                              style: TextStyle(
                                                  color: Colors.white),
                                            ),
                                          ),
                                        ).addNeumorphism(
                                          blurRadius: 15,
                                          borderRadius: 15,
                                          offset: Offset(4, 4),
                                          topShadowColor: Colors.white60,
                                          bottomShadowColor: Color(0xFF366CF6)
                                              .withOpacity(0.60),
                                        ),
                                      ),
                                SizedBox(height: kDefaultPadding),
                                Container(
                                  child: Row(
                                    mainAxisSize: MainAxisSize.min,
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Text("Don't have an account? ",
                                          style: TextStyle(color: kTextColor)),
                                      InkWell(
                                        onTap: () {
                                          setState(() {
                                            _loginToggle = false;
                                          });
                                        },
                                        child: Text("Sign Up",
                                            style: TextStyle(
                                                color: kPrimaryColor)),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            )
                          : Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                buildInputField(
                                  name: "Name",
                                  width: _width,
                                  icon: Icons.person,
                                  controller: _nameController,
                                ),
                                SizedBox(height: kDefaultPadding * 0.75),
                                buildInputField(
                                  name: "Contact Number",
                                  width: _width,
                                  icon: Icons.call,
                                  controller: _contactController,
                                ),
                                SizedBox(height: kDefaultPadding * 0.75),
                                buildInputField(
                                  name: "Email ID",
                                  width: _width,
                                  icon: Icons.email,
                                  controller: _emailIdController,
                                ),
                                SizedBox(height: kDefaultPadding * 0.75),
                                buildInputField(
                                  name: "Password",
                                  width: _width,
                                  isObs: true,
                                  icon: Icons.key_rounded,
                                  controller: _passwordController,
                                ),
                                SizedBox(height: kDefaultPadding * 1.5),
                                _isLoading
                                    ? Container(
                                        width: _width,
                                        child: Center(
                                          child: CircularProgressIndicator(
                                              color: kPrimaryColor),
                                        ),
                                      )
                                    : InkWell(
                                        onTap: _signup,
                                        child: Container(
                                          width: _width,
                                          padding: EdgeInsets.all(
                                              kDefaultPadding * 0.75),
                                          decoration: BoxDecoration(
                                            color: kPrimaryColor,
                                            borderRadius:
                                                BorderRadius.circular(15),
                                          ),
                                          child: Center(
                                            child: Text(
                                              "Sign Up",
                                              style: TextStyle(
                                                  color: Colors.white),
                                            ),
                                          ),
                                        ).addNeumorphism(
                                          blurRadius: 15,
                                          borderRadius: 15,
                                          offset: Offset(4, 4),
                                          topShadowColor: Colors.white60,
                                          bottomShadowColor: Color(0xFF366CF6)
                                              .withOpacity(0.60),
                                        ),
                                      ),
                                SizedBox(height: kDefaultPadding*0.75),
                                Container(
                                  child: Row(
                                    mainAxisSize: MainAxisSize.min,
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Text("Already have an account? ",
                                          style: TextStyle(color: kTextColor)),
                                      InkWell(
                                        onTap: () {
                                          setState(() {
                                            _loginToggle = true;
                                          });
                                        },
                                        child: Text("Login",
                                            style: TextStyle(
                                                color: kPrimaryColor)),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                    ),
                  ],
                ),
              ),
            ).addNeumorphism(
              blurRadius: 15,
              borderRadius: 15,
              offset: Offset(4, 4),
              topShadowColor: Colors.white60,
              bottomShadowColor: Colors.black.withOpacity(0.15),
            ),
          ),
        ),
      ),
    );
  }
}
