import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:another_flushbar/flushbar.dart';
import 'package:task_app/presentation/state_management/provider/auth_provider.dart';

import 'task_page.dart';

class LoginPage extends HookWidget {
  const LoginPage({super.key});

  @override
  Widget build(BuildContext context) {
    final passwordVisibility = useState(false);
    final usernameController = useTextEditingController();
    final passwordController = useTextEditingController();
    final formKey = GlobalKey<FormState>();
    final usernameFocusNode = useFocusNode();
    final passwordFocusNode = useFocusNode();
    final usernameAnimationController =
        useAnimationController(duration: const Duration(milliseconds: 500));
    final passwordAnimationController =
        useAnimationController(duration: const Duration(milliseconds: 500));
    final usernameAnimation =
        Tween<Offset>(begin: const Offset(0, 0), end: const Offset(0.1, 0))
            .chain(CurveTween(curve: Curves.elasticIn))
            .animate(usernameAnimationController);
    final passwordAnimation =
        Tween<Offset>(begin: const Offset(0, 0), end: const Offset(0.1, 0))
            .chain(CurveTween(curve: Curves.elasticIn))
            .animate(passwordAnimationController);

    void shakeTextField(AnimationController controller, FocusNode focusNode) {
      controller.forward().then((_) => controller.reverse());
      focusNode.unfocus();
      Future.delayed(const Duration(milliseconds: 50), () {
        focusNode.requestFocus();
      });
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Login'),
        centerTitle: true,
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Form(
            key: formKey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text(
                  'Welcome Back!',
                  style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 40),
                SlideTransition(
                  position: usernameAnimation,
                  child: TextFormField(
                    controller: usernameController,
                    focusNode: usernameFocusNode,
                    decoration: const InputDecoration(
                      labelText: 'Username',
                      border: OutlineInputBorder(),
                      prefixIcon: Icon(Icons.person),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter your username';
                      }
                      return null;
                    },
                  ),
                ),
                const SizedBox(height: 20),
                SlideTransition(
                  position: passwordAnimation,
                  child: ValueListenableBuilder(
                    valueListenable: passwordVisibility,
                    builder: (context, isPasswordVisible, child) {
                      return TextFormField(
                        controller: passwordController,
                        focusNode: passwordFocusNode,
                        decoration: InputDecoration(
                          labelText: 'Password',
                          border: const OutlineInputBorder(),
                          prefixIcon: const Icon(Icons.lock),
                          suffixIcon: IconButton(
                            icon: Icon(isPasswordVisible
                                ? Icons.visibility
                                : Icons.visibility_off),
                            onPressed: () {
                              passwordVisibility.value =
                                  !passwordVisibility.value;
                            },
                          ),
                        ),
                        obscureText: !isPasswordVisible,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter your password';
                          }
                          return null;
                        },
                      );
                    },
                  ),
                ),
                const SizedBox(height: 40),
                ElevatedButton(
                  onPressed: () async {
                    if (formKey.currentState!.validate()) {
                      bool isLoggedIn = await Provider.of<AuthProvider>(context,
                              listen: false)
                          .login(
                        usernameController.text.trim(),
                        passwordController.text.trim(),
                      );

                      if (isLoggedIn && context.mounted) {
                        Navigator.of(context).pushReplacement(
                          MaterialPageRoute(
                              builder: (context) => const TaskPage()),
                        );
                      } else {
                        if (context.mounted) {
                          Flushbar(
                            message:
                                'Login failed. Please check your username and password.',
                            duration: const Duration(seconds: 3),
                            backgroundColor: Colors.red,
                            icon: const Icon(
                              Icons.error,
                              color: Colors.white,
                            ),
                          ).show(context);
                        }
                      }
                    } else {
                      if (passwordController.text.isEmpty) {
                        shakeTextField(
                            passwordAnimationController, passwordFocusNode);
                      }
                      if (usernameController.text.isEmpty) {
                        shakeTextField(
                            usernameAnimationController, usernameFocusNode);
                      }
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    // primary: Theme.of(context).primaryColor,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30.0),
                    ),
                  ),
                  child: const Padding(
                    padding:
                        EdgeInsets.symmetric(vertical: 15.0, horizontal: 50.0),
                    child: Text('Login', style: TextStyle(fontSize: 18)),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
