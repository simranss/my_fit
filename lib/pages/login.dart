import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:my_fit/models/login.dart';
import 'package:provider/provider.dart';

class LoginPage extends StatelessWidget {
  const LoginPage({super.key});

  @override
  Widget build(BuildContext context) {
    var loginModel = context.read<LoginModel>();
    return SafeArea(
      child: Scaffold(
        body: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text(
                'Sign in with Google',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w500,
                  color: Colors.black,
                ),
              ),
              InkWell(
                onTap: () {
                  // google login
                  debugPrint('google login');
                  loginModel.signInWithGoogle();
                },
                child: SizedBox(
                  width: 53,
                  child: AspectRatio(
                    aspectRatio: 1,
                    child: SvgPicture.asset(
                      'assets/svg/google_icon.svg',
                      semanticsLabel: 'Google login',
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
