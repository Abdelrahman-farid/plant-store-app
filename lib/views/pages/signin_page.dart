import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:project1/utilies/constants.dart';
import 'package:project1/view_models/auth_cubit/auth_cubit.dart';
import 'package:project1/views/widgets/custom_textfield.dart';
import 'package:project1/views/pages/root_page.dart';
import 'package:project1/views/pages/forgot_password.dart';
import 'package:project1/views/pages/signup_page.dart';

class SignIn extends StatefulWidget {
  const SignIn({Key? key}) : super(key: key);

  @override
  State<SignIn> createState() => _SignInState();
}

class _SignInState extends State<SignIn> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  void _showError(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.red,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    return BlocProvider(
      create: (context) => AuthCubit(),
      child: Scaffold(
        body: Padding(
          padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 20),
          child: SingleChildScrollView(
            child: BlocConsumer<AuthCubit, AuthState>(
              listener: (context, state) {
                if (state is AuthDone || state is GoogleAuthDone) {
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(builder: (_) => const RootPage()),
                  );
                } else if (state is AuthError) {
                  _showError(state.message);
                } else if (state is GoogleAuthError) {
                  _showError(state.message);
                }
              },
              builder: (context, state) {
                final isLoading = state is AuthLoading || 
                                  state is GoogleAuthenticating;

                return Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Image.asset('assets/images/signin.png'),
                    const Text(
                      'Sign In',
                      style: TextStyle(
                        fontSize: 35.0,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    const SizedBox(height: 30),
                    CustomTextfield(
                      controller: emailController,
                      obscureText: false,
                      hintText: 'Enter Email',
                      icon: Icons.alternate_email,
                    ),
                    CustomTextfield(
                      controller: passwordController,
                      obscureText: true,
                      hintText: 'Enter Password',
                      icon: Icons.lock,
                    ),
                    const SizedBox(height: 10),
                    GestureDetector(
                      onTap: isLoading
                          ? null
                          : () {
                              final email = emailController.text.trim();
                              final password = passwordController.text.trim();

                              if (email.isEmpty || password.isEmpty) {
                                _showError('Please enter email and password');
                                return;
                              }

                              // For demo purposes, skip authentication and go directly to home
                              Navigator.pushReplacement(
                                context,
                                MaterialPageRoute(builder: (_) => const RootPage()),
                              );
                              
                              // Uncomment below for Firebase authentication:
                              // context.read<AuthCubit>().loginWithEmailAndPassword(
                              //       email,
                              //       password,
                              //     );
                            },
                      child: Container(
                        width: size.width,
                        decoration: BoxDecoration(
                          color: isLoading 
                              ? Constants.primaryColor.withOpacity(0.6)
                              : Constants.primaryColor,
                          borderRadius: BorderRadius.circular(10),
                        ),
                        padding: const EdgeInsets.symmetric(
                            horizontal: 10, vertical: 20),
                        child: Center(
                          child: isLoading && state is AuthLoading
                              ? const SizedBox(
                                  height: 20,
                                  width: 20,
                                  child: CircularProgressIndicator(
                                    color: Colors.white,
                                    strokeWidth: 2,
                                  ),
                                )
                              : const Text(
                                  'Sign In',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 18.0,
                                  ),
                                ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 10),
                    GestureDetector(
                      onTap: () {
                        Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                                builder: (_) => const ForgotPassword()));
                      },
                      child: Center(
                        child: Text.rich(
                          TextSpan(children: [
                            TextSpan(
                              text: 'Forgot Password? ',
                              style: TextStyle(
                                color: Constants.blackColor,
                              ),
                            ),
                            TextSpan(
                              text: 'Reset Here',
                              style: TextStyle(
                                color: Constants.primaryColor,
                              ),
                            ),
                          ]),
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),
                    Row(
                      children: const [
                        Expanded(child: Divider()),
                        Padding(
                          padding: EdgeInsets.symmetric(horizontal: 10),
                          child: Text('OR'),
                        ),
                        Expanded(child: Divider()),
                      ],
                    ),
                    const SizedBox(height: 20),
                    GestureDetector(
                      onTap: isLoading
                          ? null
                          : () {
                              context.read<AuthCubit>().authenticateWithGoogle();
                            },
                      child: Container(
                        width: size.width,
                        decoration: BoxDecoration(
                            border: Border.all(color: Constants.primaryColor),
                            borderRadius: BorderRadius.circular(10)),
                        padding: const EdgeInsets.symmetric(
                            horizontal: 10, vertical: 15),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            if (isLoading && state is GoogleAuthenticating)
                              const SizedBox(
                                height: 30,
                                width: 30,
                                child: CircularProgressIndicator(
                                  strokeWidth: 2,
                                ),
                              )
                            else
                              SizedBox(
                                height: 30,
                                child: Image.asset('assets/images/google.png'),
                              ),
                            Text(
                              'Sign In with Google',
                              style: TextStyle(
                                color: Constants.blackColor,
                                fontSize: 18.0,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),
                    GestureDetector(
                      onTap: () {
                        Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(builder: (_) => const SignUp()));
                      },
                      child: Center(
                        child: Text.rich(
                          TextSpan(children: [
                            TextSpan(
                              text: 'New to Planty? ',
                              style: TextStyle(
                                color: Constants.blackColor,
                              ),
                            ),
                            TextSpan(
                              text: 'Register',
                              style: TextStyle(
                                color: Constants.primaryColor,
                              ),
                            ),
                          ]),
                        ),
                      ),
                    ),
                    const SizedBox(height: 30),
                    // Skip Login Button
                    GestureDetector(
                      onTap: () {
                        Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(builder: (_) => const RootPage()));
                      },
                      child: Center(
                        child: Container(
                          padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 24),
                          decoration: BoxDecoration(
                            border: Border.all(color: Constants.primaryColor),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Text(
                            'Continue as Guest',
                            style: TextStyle(
                              color: Constants.primaryColor,
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                );
              },
            ),
          ),
        ),
      ),
    );
  }
}
