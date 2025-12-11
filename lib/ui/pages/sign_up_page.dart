import 'package:e_wallet/blocs/auth/auth_bloc.dart';
import 'package:e_wallet/models/signup_form_model.dart';
import 'package:e_wallet/shared/shared_method.dart';
import 'package:e_wallet/shared/theme.dart';
import 'package:e_wallet/ui/pages/sign_up_set_profil_page.dart';
import 'package:e_wallet/ui/widgets/buttons.dart';
import 'package:e_wallet/ui/widgets/form.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class SignUpPage extends StatefulWidget {
  const SignUpPage({super.key});

  @override
  State<SignUpPage> createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  final nameController = TextEditingController(text: '');
  final emailController = TextEditingController(text: '');
  final passwordController = TextEditingController(text: '');

  //add validation for data empty
  bool validate() {
    if (nameController.text.isEmpty ||
        emailController.text.isEmpty ||
        passwordController.text.isEmpty) {
      return false;
    }
    return true;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: BlocConsumer<AuthBloc, AuthState>(
          listener: (context, state) {
            // TODO: implement listener

            if (state is AuthFailed) {
              showCustomSnackbar(context, state.e);
            }

            if (state is AuthCheckEmailSuccess) {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => SignUpSetProfilPage(
                    data: SignUpFormModel(
                      name: nameController.text,
                      email: emailController.text,
                      password: passwordController.text,
                    ),
                  ),
                ),
              );
            }
          },
          builder: (context, state) {
            //animate loading
            if (state is AuthLoading) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            }

            return ListView(
              padding: const EdgeInsets.symmetric(
                horizontal: 24,
              ),
              children: [
                Container(
                  width: 200,
                  height: 200,
                  margin: const EdgeInsets.only(
                    top: 30,
                  ),
                  decoration: const BoxDecoration(
                    image: DecorationImage(
                      image: AssetImage('assets/img_logo_light.png'),
                      fit: BoxFit.contain,
                    ),
                  ),
                ),
                Text(
                  'Join Us to Unlock\nYour Growth',
                  style: blackTextStyle.copyWith(
                    fontSize: 20,
                    fontWeight: semiBold,
                  ),
                ),
                const SizedBox(
                  height: 30,
                ),
                Container(
                  padding: const EdgeInsets.all(22),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                    color: whiteColor,
                    boxShadow: [
                      BoxShadow(
                        color: blackColor.withOpacity(0.03),
                        blurRadius: 10,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      //NOTE: NAME INPUT
                      CustomFormField(
                        title: 'Full Name',
                        obscureText: false,
                        controller: nameController,
                      ),
                      const SizedBox(
                        height: 16,
                      ),
                      //NOTE: EMAIL INPUT
                      CustomFormField(
                        title: 'Email Address',
                        obscureText: false,
                        controller: emailController,
                      ),
                      const SizedBox(
                        height: 16,
                      ),
                      //NOTE PASSWORD INPUT
                      CustomFormField(
                        title: 'Password',
                        obscureText: true,
                        controller: passwordController,
                      ),
                      const SizedBox(
                        height: 30,
                      ),
                      CustomFilledButton(
                        title: 'Continue',
                        onPressed: () {
                          if (validate()) {
                            context
                                .read<AuthBloc>()
                                .add(AuthCheckEmail(emailController.text));
                          } else {
                            showCustomSnackbar(
                                context, 'Semua field harus diisi.');
                          }
                        },
                      )
                    ],
                  ),
                ),
                const SizedBox(
                  height: 30,
                ),
                CustomTextWidgetButton(
                  title: 'Sign In',
                  onPressed: () {
                    Navigator.pushNamed(context, '/sign-in');
                  },
                ),
                const SizedBox(
                  height: 30,
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}
