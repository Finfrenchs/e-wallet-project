import 'package:e_wallet/blocs/auth/auth_bloc.dart';
import 'package:e_wallet/shared/shared_method.dart';
import 'package:e_wallet/shared/theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class PinPage extends StatefulWidget {
  const PinPage({super.key});

  @override
  State<PinPage> createState() => _PinPageState();
}

class _PinPageState extends State<PinPage> with SingleTickerProviderStateMixin {
  final TextEditingController pinController = TextEditingController(text: '');
  String pin = '';
  bool isError = false;
  late AnimationController _shakeController;
  late Animation<double> _shakeAnimation;

  @override
  void initState() {
    super.initState();

    final authState = context.read<AuthBloc>().state;
    if (authState is AuthSuccess) {
      pin = authState.user.pin!;
    }

    _shakeController = AnimationController(
      duration: const Duration(milliseconds: 500),
      vsync: this,
    );

    _shakeAnimation = Tween<double>(begin: 0, end: 10).animate(
      CurvedAnimation(parent: _shakeController, curve: Curves.elasticIn),
    );
  }

  @override
  void dispose() {
    _shakeController.dispose();
    pinController.dispose();
    super.dispose();
  }

  void addPin(String number) {
    if (pinController.text.length < 6) {
      setState(() {
        isError = false;
        pinController.text = pinController.text + number;
      });
    }

    if (pinController.text.length == 6) {
      if (pinController.text == pin) {
        Navigator.pop(context, true);
      } else {
        setState(() {
          isError = true;
        });
        _shakeController.forward(from: 0).then((_) {
          Future.delayed(const Duration(milliseconds: 500), () {
            setState(() {
              pinController.clear();
              isError = false;
            });
          });
        });
        showCustomSnackbar(
            context, 'PIN yang anda masukkan salah. Silakan coba lagi.');
      }
    }
  }

  void deletePin() {
    if (pinController.text.isNotEmpty) {
      setState(() {
        isError = false;
        pinController.text =
            pinController.text.substring(0, pinController.text.length - 1);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: lightBackgroundColor,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: blackColor),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          'Enter PIN',
          style: blackTextStyle.copyWith(
            fontSize: 18,
            fontWeight: semiBold,
          ),
        ),
        centerTitle: true,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: ConstrainedBox(
            constraints: BoxConstraints(
              minHeight: MediaQuery.of(context).size.height -
                  AppBar().preferredSize.height -
                  MediaQuery.of(context).padding.top -
                  MediaQuery.of(context).padding.bottom,
            ),
            child: IntrinsicHeight(
              child: Column(
                children: [
                  const SizedBox(height: 32),
                  // Logo or Icon
                  Container(
                    width: 80,
                    height: 80,
                    decoration: BoxDecoration(
                      color: primaryColor.withOpacity(0.1),
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      Icons.lock_outline_rounded,
                      size: 40,
                      color: primaryColor,
                    ),
                  ),
                  const SizedBox(height: 24),
                  // Title
                  Text(
                    'Verify your PIN',
                    style: blackTextStyle.copyWith(
                      fontSize: 24,
                      fontWeight: bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Enter your 6-digit PIN to continue',
                    style: greyTextStyle.copyWith(
                      fontSize: 14,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 32),
                  // PIN Dots Indicator
                  AnimatedBuilder(
                    animation: _shakeAnimation,
                    builder: (context, child) {
                      return Transform.translate(
                        offset: isError
                            ? Offset(_shakeAnimation.value, 0)
                            : Offset.zero,
                        child: child,
                      );
                    },
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 32,
                        vertical: 28,
                      ),
                      decoration: BoxDecoration(
                        color: whiteColor,
                        borderRadius: BorderRadius.circular(20),
                        boxShadow: [
                          BoxShadow(
                            color: blackColor.withOpacity(0.05),
                            blurRadius: 20,
                            offset: const Offset(0, 4),
                          ),
                        ],
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        mainAxisSize: MainAxisSize.min,
                        children: List.generate(6, (index) {
                          bool isFilled = index < pinController.text.length;
                          return Container(
                            margin: const EdgeInsets.symmetric(horizontal: 8),
                            width: 16,
                            height: 16,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: isError
                                  ? redColor
                                  : isFilled
                                      ? primaryColor
                                      : greyColor.withOpacity(0.2),
                              border: Border.all(
                                color: isError
                                    ? redColor
                                    : isFilled
                                        ? primaryColor
                                        : greyColor.withOpacity(0.3),
                                width: 2,
                              ),
                            ),
                          );
                        }),
                      ),
                    ),
                  ),
                  const Spacer(),
                  const SizedBox(height: 10),
                  // Number Pad
                  Container(
                    padding: const EdgeInsets.all(20),
                    margin: const EdgeInsets.only(bottom: 24),
                    decoration: BoxDecoration(
                      color: whiteColor,
                      borderRadius: BorderRadius.circular(24),
                      boxShadow: [
                        BoxShadow(
                          color: blackColor.withOpacity(0.05),
                          blurRadius: 20,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        _buildNumberRow(['1', '2', '3']),
                        const SizedBox(height: 16),
                        _buildNumberRow(['4', '5', '6']),
                        const SizedBox(height: 16),
                        _buildNumberRow(['7', '8', '9']),
                        const SizedBox(height: 16),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            const SizedBox(width: 70, height: 70),
                            _buildNumberButton('0'),
                            _buildDeleteButton(),
                          ],
                        ),
                      ],
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

  Widget _buildNumberRow(List<String> numbers) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: numbers.map((number) => _buildNumberButton(number)).toList(),
    );
  }

  Widget _buildNumberButton(String number) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: () => addPin(number),
        borderRadius: BorderRadius.circular(35),
        child: Container(
          width: 70,
          height: 70,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            border: Border.all(
              color: greyColor.withOpacity(0.2),
              width: 1,
            ),
          ),
          child: Center(
            child: Text(
              number,
              style: blackTextStyle.copyWith(
                fontSize: 24,
                fontWeight: semiBold,
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildDeleteButton() {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: deletePin,
        borderRadius: BorderRadius.circular(35),
        child: Container(
          width: 70,
          height: 70,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: redColor.withOpacity(0.1),
          ),
          child: Center(
            child: Icon(
              Icons.backspace_outlined,
              color: redColor,
              size: 28,
            ),
          ),
        ),
      ),
    );
  }
}
