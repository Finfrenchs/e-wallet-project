import 'dart:convert';
import 'dart:io';

import 'package:e_wallet/models/signup_form_model.dart';
import 'package:e_wallet/shared/shared_method.dart';
import 'package:e_wallet/shared/theme.dart';
import 'package:e_wallet/ui/pages/sign_up_set_idc_page.dart';
import 'package:e_wallet/ui/widgets/buttons.dart';
import 'package:e_wallet/ui/widgets/form.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class SignUpSetProfilPage extends StatefulWidget {
  final SignUpFormModel data;

  const SignUpSetProfilPage({
    super.key,
    required this.data,
  });

  @override
  State<SignUpSetProfilPage> createState() => _SignUpSetProfilPageState();
}

class _SignUpSetProfilPageState extends State<SignUpSetProfilPage> {
  final pinController = TextEditingController(text: '');
  XFile? selectedImage;

  //validation for pin
  bool validate() {
    if (pinController.text.length != 6) {
      return false;
    }
    return true;
  }

  @override
  Widget build(BuildContext context) {
    print(widget.data.toJson());

    return Scaffold(
      body: SafeArea(
        child: ListView(
        padding: const EdgeInsets.symmetric(
          horizontal: 24,
        ),
        children: [
          Container(
            width: 200,
            height: 65,
            margin: const EdgeInsets.only(
              top: 60,
              bottom: 60,
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
              children: [
                GestureDetector(
                  onTap: () async {
                    final image = await selectImage();
                    setState(() {
                      selectedImage = image;
                    });
                  },
                  child: Container(
                    width: 120,
                    height: 120,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: lightBackgroundColor,
                      image: selectedImage == null
                          ? null
                          : DecorationImage(
                              fit: BoxFit.cover,
                              image: FileImage(
                                File(selectedImage!.path),
                              ),
                            ),
                    ),
                    child: selectedImage != null
                        ? null
                        : Center(
                            child: Image.asset(
                              'assets/ic_upload.png',
                              width: 32,
                            ),
                          ),
                  ),
                ),
                const SizedBox(
                  height: 16,
                ),
                Text(
                  'Shayna Hanna',
                  style: blackTextStyle.copyWith(
                    fontSize: 18,
                    fontWeight: medium,
                  ),
                ),
                const SizedBox(
                  height: 30,
                ),
                CustomFormField(
                  obscureText: true,
                  title: 'Set PIN (16 digit number)',
                  controller: pinController,
                  keyboardType: TextInputType.number,
                ),
                const SizedBox(
                  height: 30,
                ),
                CustomFilledButton(
                  title: 'Continue',
                  onPressed: () {
                    if (validate()) {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => SignUpSetIdentityCardPage(
                            data: widget.data.copyWith(
                              pin: pinController.text,
                              profilePicture: selectedImage == null
                                  ? null
                                  : 'data:image/png;base64,${base64Encode(
                                      File(selectedImage!.path)
                                          .readAsBytesSync(),
                                    )}',
                            ),
                          ),
                        ),
                      );
                    } else {
                      showCustomSnackbar(context, 'PIN harus 6 digit.');
                    }
                  },
                )
              ],
            ),
          ),
          const SizedBox(
            height: 50,
          ),
        ],
        ),
      ),
    );
  }
}
