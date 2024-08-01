// import 'package:finity/design/widgets/custom_field.dart';
// import 'package:finity/features/auth/repos/auth_repo.dart';
// import 'package:finity/features/auth/ui/pages/signup_page.dart';
// import 'package:finity/features/auth/ui/widgets/gradient_button.dart';
// import 'package:flutter/material.dart';

// class LoginPage extends StatefulWidget {
//   const LoginPage({super.key});
//   static const routeName = '/loginPage';

//   @override
//   State<LoginPage> createState() => _LoginPageState();
// }

// class _LoginPageState extends State<LoginPage> {
//   final TextEditingController emailController = TextEditingController();
//   final TextEditingController passwordController = TextEditingController();
//   final formKey = GlobalKey<FormState>();
//   bool isLoading = false;
//   final AuthService authService = AuthService();
//   Future<void> _submitForm() async {
//     setState(() {
//       isLoading = true;
//     });
//     if (formKey.currentState!.validate()) {
//       ScaffoldMessenger.of(context).showSnackBar(
//         const SnackBar(
//           content: Text('submitted'),
//         ),
//       );
//     } else {
//       ScaffoldMessenger.of(context).showSnackBar(
//         const SnackBar(
//           content: Text('Please fill all the fields'),
//         ),
//       );
//     }
//     authService.signInUser(
//       context: context,
//       email: emailController.text,
//       password: passwordController.text,
//     );

//     setState(() {
//       isLoading = false;
//     });
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//         appBar: AppBar(),
//         body: Padding(
//             padding: const EdgeInsets.only(left: 20, right: 20),
//             child: Form(
//               key: formKey,
//               child: Column(
//                 mainAxisAlignment: MainAxisAlignment.center,
//                 crossAxisAlignment: CrossAxisAlignment.center,
//                 children: [
//                   Text(
//                     'Login ',
//                     style: TextStyle(fontSize: 40, fontWeight: FontWeight.w500),
//                   ),
//                   const SizedBox(height: 30),
//                   CustomField(
//                     hintText: 'enter your email',
//                     controller: emailController,
//                     suffixIcon: const Icon(Icons.email),
//                   ),
//                   const SizedBox(height: 20),
//                   CustomField(
//                     hintText: 'enter your password',
//                     controller: passwordController,
//                     isObscureText: true,
//                     suffixIcon: const Icon(Icons.lock),
//                   ),
//                   const SizedBox(height: 20),
//                   isLoading
//                       ? const CircularProgressIndicator()
//                       : GradientButton(
//                           text: Text(
//                             "Login",
//                             style: TextStyle(fontWeight: FontWeight.w600),
//                           ),
//                           onPressed: () {
//                             _submitForm();
//                           }),
//                   const SizedBox(height: 20),
//                   GestureDetector(
//                     onTap: () {
//                       Navigator.push(
//                           context,
//                           MaterialPageRoute(
//                               builder: (context) => const SignUpPage()));
//                     },
//                     child: RichText(
//                       text: TextSpan(
//                         children: [
//                           TextSpan(
//                             text: "Don't have an account? ",
//                             style: TextStyle(color: Colors.white),
//                           ),
//                           TextSpan(
//                             text: "SignUp",
//                             style: TextStyle(color: Colors.blue),
//                           ),
//                         ],
//                       ),
//                     ),
//                   ),
//                 ],
//               ),
//             )));
//   }
// }

import 'package:finity/features/auth/ui/pages/signup_page.dart';
import 'package:finity/features/home/bottom_nav_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:finity/design/widgets/custom_field.dart';
import 'package:finity/features/auth/bloc/auth_bloc.dart';
import 'package:finity/features/auth/ui/widgets/gradient_button.dart';
import 'package:finity/features/home/home_screen.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});
  static const routeName = '/loginPage';

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final formKey = GlobalKey<FormState>();
  bool isLoading = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: BlocListener<AuthBloc, AuthState>(
        listener: (context, state) {
          if (state is AuthLoading) {
            setState(() {
              isLoading = true;
            });
          } else if (state is AuthErrorState) {
            setState(() {
              isLoading = false;
            });
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(state.message)),
            );
          } else if (state is AuthAuthenticated) {
            setState(() {
              isLoading = false;
            });
            Navigator.pushNamedAndRemoveUntil(
              context,
              BottomNavBar.routeName,
              (route) => false,
            );
          }
        },
        child: Padding(
          padding: const EdgeInsets.only(left: 20, right: 20),
          child: Form(
            key: formKey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(
                  'Login',
                  style: TextStyle(fontSize: 40, fontWeight: FontWeight.w500),
                ),
                const SizedBox(height: 30),
                CustomField(
                  hintText: 'enter your email',
                  controller: emailController,
                  suffixIcon: const Icon(Icons.email),
                ),
                const SizedBox(height: 20),
                CustomField(
                  hintText: 'enter your password',
                  controller: passwordController,
                  isObscureText: true,
                  suffixIcon: const Icon(Icons.lock),
                ),
                const SizedBox(height: 20),
                isLoading
                    ? const CircularProgressIndicator()
                    : GradientButton(
                        text: Text(
                          "Login",
                          style: TextStyle(fontWeight: FontWeight.w600),
                        ),
                        onPressed: () {
                          if (formKey.currentState!.validate()) {
                            BlocProvider.of<AuthBloc>(context).add(
                              AuthLoginEvent(
                                context: context,
                                email: emailController.text,
                                password: passwordController.text,
                              ),
                            );
                          } else {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text('Please fill all the fields'),
                              ),
                            );
                          }
                        },
                      ),
                const SizedBox(height: 20),
                GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const SignUpPage(),
                      ),
                    );
                  },
                  child: RichText(
                    text: const TextSpan(
                      children: [
                        TextSpan(
                          text: "Don't have an account? ",
                          style: TextStyle(color: Colors.white),
                        ),
                        TextSpan(
                          text: "SignUp",
                          style: TextStyle(color: Colors.blue),
                        ),
                      ],
                    ),
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
