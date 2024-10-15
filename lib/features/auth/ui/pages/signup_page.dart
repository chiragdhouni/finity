import 'package:finity/models/address_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:finity/design/widgets/custom_field.dart';
import 'package:finity/blocs/auth/auth_bloc.dart';
import 'package:finity/features/auth/ui/pages/login_page.dart';
import 'package:finity/features/auth/ui/widgets/gradient_button.dart';

class SignUpPage extends StatefulWidget {
  const SignUpPage({super.key});
  static const routeName = '/signUpPage';

  @override
  State<SignUpPage> createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  final TextEditingController nameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController addressController = TextEditingController();
  final TextEditingController cityController = TextEditingController();
  final TextEditingController stateController = TextEditingController();
  final TextEditingController countryController = TextEditingController();
  final TextEditingController zipCodeController = TextEditingController();
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
          } else if (state is AuthInitial) {
            setState(() {
              isLoading = false;
            });
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content:
                    Text('Account created! Login with the same credentials!'),
              ),
            );
            Navigator.pushNamed(context, LoginPage.routeName);
          }
        },
        child: SingleChildScrollView(
          child: Form(
            key: formKey,
            child: Padding(
              padding: const EdgeInsets.only(left: 20, right: 20),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const Text(
                    'SignUp',
                    style: TextStyle(fontSize: 40, fontWeight: FontWeight.w500),
                  ),
                  const SizedBox(height: 30),
                  CustomField(
                    hintText: 'Enter your name',
                    controller: nameController,
                    suffixIcon: const Icon(Icons.person),
                  ),
                  const SizedBox(height: 20),
                  CustomField(
                    hintText: 'Enter your email',
                    controller: emailController,
                    suffixIcon: const Icon(Icons.email),
                  ),
                  const SizedBox(height: 20),
                  CustomField(
                    hintText: 'Enter your password',
                    controller: passwordController,
                    isObscureText: true,
                    suffixIcon: const Icon(Icons.lock),
                  ),
                  const SizedBox(height: 20),
                  CustomField(
                    hintText: 'Enter your address',
                    controller: addressController,
                    suffixIcon: const Icon(Icons.location_on),
                  ),
                  const SizedBox(height: 20),
                  CustomField(
                    hintText: 'Enter your city',
                    controller: cityController,
                    suffixIcon: const Icon(Icons.location_city),
                  ),
                  const SizedBox(height: 20),
                  CustomField(
                    hintText: 'Enter your state',
                    controller: stateController,
                    suffixIcon: const Icon(Icons.map),
                  ),
                  const SizedBox(height: 20),
                  CustomField(
                    hintText: 'Enter your country',
                    controller: countryController,
                    suffixIcon: const Icon(Icons.flag),
                  ),
                  const SizedBox(height: 20),
                  CustomField(
                    hintText: 'Enter your zip code',
                    controller: zipCodeController,
                    suffixIcon: const Icon(Icons.markunread_mailbox),
                  ),
                  const SizedBox(height: 20),
                  isLoading
                      ? const Center(child: CircularProgressIndicator())
                      : GradientButton(
                          text: const Text(
                            "SignUp",
                            style: TextStyle(fontWeight: FontWeight.w600),
                          ),
                          onPressed: () {
                            if (formKey.currentState!.validate()) {
                              AddressModel address = AddressModel(
                                address: addressController.text,
                                city: cityController.text,
                                state: stateController.text,
                                country: countryController.text,
                                zipCode: zipCodeController.text,
                              );
                              BlocProvider.of<AuthBloc>(context).add(
                                AuthSignUpEvent(
                                  email: emailController.text,
                                  password: passwordController.text,
                                  name: nameController.text,
                                  address: address,
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
                          builder: (context) => const LoginPage(),
                        ),
                      );
                    },
                    child: RichText(
                      text: const TextSpan(
                        children: [
                          TextSpan(
                            text: "Already have an account? ",
                            style: TextStyle(color: Colors.white),
                          ),
                          TextSpan(
                            text: "Login",
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
      ),
    );
  }
}
