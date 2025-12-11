import 'package:e_wallet/blocs/auth/auth_bloc.dart';
import 'package:e_wallet/blocs/transfer/transfer_bloc.dart';
import 'package:e_wallet/models/transfer_form_model.dart';
import 'package:e_wallet/shared/shared_method.dart';
import 'package:flutter/material.dart';

import 'package:e_wallet/shared/theme.dart';
import 'package:e_wallet/ui/widgets/buttons.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';

class TransferAmountPage extends StatefulWidget {
  final TransferFormModel data;
  const TransferAmountPage({
    super.key,
    required this.data,
  });

  @override
  State<TransferAmountPage> createState() => _TransferAmountPageState();
}

class _TransferAmountPageState extends State<TransferAmountPage> {
  final TextEditingController amountController =
      TextEditingController(text: '0');

  @override
  void initState() {
    super.initState();

    //mengubah format currency

    amountController.addListener(() {
      final text = amountController.text;

      ///First Metode
      // final sanitizedText = text == ""
      //     ? 0
      //     : text.replaceAll('.', ''); // Menghapus karakter non-numeric

      // amountController.value = amountController.value.copyWith(
      //   text: NumberFormat.currency(
      //     locale: 'id',
      //     decimalDigits: 0,
      //     symbol: '',
      //   ).format(
      //     int.parse(sanitizedText.toString()),
      //   ),
      // );

      ///Second Metode
      final sanitizedText = text.replaceAll(RegExp(r'[^0-9]'), '');

      if (sanitizedText.isNotEmpty) {
        amountController.value = amountController.value.copyWith(
          text: NumberFormat.currency(
            locale: 'id',
            decimalDigits: 0,
            symbol: '',
          ).format(
            int.parse(sanitizedText),
          ),
        );
      } else {
        amountController.value = amountController.value.copyWith(
          text:
              '', // Menyimpan teks kosong jika sanitizedText kosong atau nilai menjadi 0
        );
      }
    });
  }

  addAmount(String number) {
    if (amountController.text == '0') {
      amountController.text = '';
    }
    setState(() {
      amountController.text = amountController.text + number;
    });
  }

  deleteAmount() {
    if (amountController.text.isNotEmpty) {
      setState(() {
        amountController.text = amountController.text
            .substring(0, amountController.text.length - 1);
        if (amountController.text == '') {
          amountController.text = '0';
        }
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
          onPressed: () {
            Navigator.pop(context);
          },
          icon: Icon(
            Icons.arrow_back,
            color: blackColor,
            size: 24,
          ),
        ),
        title: Text(
          'Transfer Amount',
          style: blackTextStyle.copyWith(
            fontSize: 18,
            fontWeight: semiBold,
          ),
        ),
        centerTitle: true,
      ),
      body: BlocProvider(
        create: (context) => TransferBloc(),
        child: BlocConsumer<TransferBloc, TransferState>(
          listener: (context, state) {
            if (state is TransferFailed) {
              showCustomSnackbar(context, state.e);
            }

            if (state is TransferSuccess) {
              context.read<AuthBloc>().add(
                    AuthUpdateBalance(
                      int.parse(
                            amountController.text
                                .replaceAll('.', '')
                                .toString(),
                          ) *
                          -1, //agar amount berkurang setelah di kirim
                    ),
                  );

              Navigator.pushNamedAndRemoveUntil(
                  context, '/transfer-success', (route) => false);
            }
          },
          builder: (context, state) {
            if (state is TransferLoading) {
              return Center(
                child: CircularProgressIndicator(
                  valueColor: AlwaysStoppedAnimation<Color>(primaryColor),
                ),
              );
            }

            return ListView(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              children: [
                const SizedBox(height: 20),
                // Recipient Card
                Container(
                  padding: const EdgeInsets.all(20),
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
                    children: [
                      Container(
                        width: 60,
                        height: 60,
                        decoration: BoxDecoration(
                          color: primaryColor.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: Center(
                          child: Icon(
                            Icons.person_outline,
                            color: primaryColor,
                            size: 32,
                          ),
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              widget.data.sendTo ?? 'Recipient',
                              style: blackTextStyle.copyWith(
                                fontSize: 18,
                                fontWeight: bold,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              'Transfer to',
                              style: greyTextStyle.copyWith(
                                fontSize: 13,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 40),
                // Amount Input Section
                Center(
                  child: Column(
                    children: [
                      Text(
                        'Enter Amount',
                        style: greyTextStyle.copyWith(
                          fontSize: 14,
                          fontWeight: medium,
                        ),
                      ),
                      const SizedBox(height: 16),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 24,
                          vertical: 20,
                        ),
                        decoration: BoxDecoration(
                          color: whiteColor,
                          borderRadius: BorderRadius.circular(20),
                          boxShadow: [
                            BoxShadow(
                              color: primaryColor.withOpacity(0.1),
                              blurRadius: 20,
                              offset: const Offset(0, 4),
                            ),
                          ],
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              'Rp ',
                              style: primaryTextStyle.copyWith(
                                fontSize: 32,
                                fontWeight: bold,
                              ),
                            ),
                            SizedBox(
                              width: 180,
                              child: TextFormField(
                                controller: amountController,
                                textAlign: TextAlign.center,
                                style: blackTextStyle.copyWith(
                                  fontSize: 32,
                                  fontWeight: bold,
                                ),
                                enabled: false,
                                decoration: const InputDecoration(
                                  border: InputBorder.none,
                                  contentPadding: EdgeInsets.zero,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 48),
                // Number Pad
                Container(
                  padding: const EdgeInsets.all(24),
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
                    children: [
                      _buildNumberRow(['1', '2', '3']),
                      const SizedBox(height: 20),
                      _buildNumberRow(['4', '5', '6']),
                      const SizedBox(height: 20),
                      _buildNumberRow(['7', '8', '9']),
                      const SizedBox(height: 20),
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
                const SizedBox(height: 32),
                // Continue Button
                CustomFilledButton(
                  title: 'Continue to Transfer',
                  onPressed: () async {
                    if (await Navigator.pushNamed(context, '/pin') == true) {
                      final authState = context
                          .read<AuthBloc>()
                          .state; //this using because need pin for send data

                      String pin = '';
                      if (authState is AuthSuccess) {
                        pin = authState.user.pin!;
                      }

                      context.read<TransferBloc>().add(
                            TransferPost(
                              widget.data.copyWith(
                                  pin: pin,
                                  amount: amountController.text
                                      .replaceAll('.', '')),
                            ),
                          );
                    }
                  },
                ),
                const SizedBox(height: 16),
                Center(
                  child: TextButton(
                    onPressed: () {},
                    child: Text(
                      'Terms & Conditions',
                      style: greyTextStyle.copyWith(
                        fontSize: 14,
                        fontWeight: medium,
                        decoration: TextDecoration.underline,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 32),
              ],
            );
          },
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
        onTap: () => addAmount(number),
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
        onTap: deleteAmount,
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
