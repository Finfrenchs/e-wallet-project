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
      backgroundColor: darkBackgroundColor,
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
              return const Center(
                child: CircularProgressIndicator(),
              );
            }

            return ListView(
              padding: const EdgeInsets.symmetric(
                horizontal: 58,
              ),
              children: [
                const SizedBox(
                  height: 46,
                ),
                Center(
                  child: Text(
                    'Total Amount',
                    style: whiteTextStyle.copyWith(
                      fontSize: 20,
                      fontWeight: semiBold,
                    ),
                  ),
                ),
                const SizedBox(
                  height: 67,
                ),
                Align(
                  child: SizedBox(
                    width: 200,
                    child: TextFormField(
                      controller: amountController,
                      cursorColor: greyColor,
                      style: whiteTextStyle.copyWith(
                        fontSize: 36,
                        fontWeight: medium,
                      ),
                      enabled: false,
                      decoration: InputDecoration(
                        prefixIcon: Text(
                          'Rp ',
                          style: whiteTextStyle.copyWith(
                            fontSize: 36,
                            fontWeight: medium,
                          ),
                        ),
                        disabledBorder: UnderlineInputBorder(
                          borderSide: BorderSide(
                            color: greyColor,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(
                  height: 66,
                ),
                Center(
                  child: Wrap(
                    spacing: 40,
                    runSpacing: 40,
                    children: [
                      CustomInputButton(
                        title: '1',
                        onTap: () {
                          addAmount('1');
                        },
                      ),
                      CustomInputButton(
                        title: '2',
                        onTap: () {
                          addAmount('2');
                        },
                      ),
                      CustomInputButton(
                        title: '3',
                        onTap: () {
                          addAmount('3');
                        },
                      ),
                      CustomInputButton(
                        title: '4',
                        onTap: () {
                          addAmount('4');
                        },
                      ),
                      CustomInputButton(
                        title: '5',
                        onTap: () {
                          addAmount('5');
                        },
                      ),
                      CustomInputButton(
                        title: '6',
                        onTap: () {
                          addAmount('6');
                        },
                      ),
                      CustomInputButton(
                        title: '7',
                        onTap: () {
                          addAmount('7');
                        },
                      ),
                      CustomInputButton(
                        title: '8',
                        onTap: () {
                          addAmount('8');
                        },
                      ),
                      CustomInputButton(
                        title: '9',
                        onTap: () {
                          addAmount('9');
                        },
                      ),
                      const SizedBox(
                        height: 60,
                        width: 60,
                      ),
                      CustomInputButton(
                        title: '0',
                        onTap: () {
                          addAmount('0');
                        },
                      ),
                      GestureDetector(
                        onTap: () {
                          deleteAmount();
                        },
                        child: Container(
                          width: 60,
                          height: 60,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: numberBackgoundColor,
                          ),
                          child: Center(
                            child: Icon(
                              Icons.arrow_back_rounded,
                              color: whiteColor,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(
                  height: 50,
                ),
                CustomFilledButton(
                  title: 'Continue',
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
                const SizedBox(
                  height: 25,
                ),
                CustomTextWidgetButton(
                  title: 'Term & Conditions',
                  onPressed: () {},
                ),
                const SizedBox(
                  height: 40,
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}
