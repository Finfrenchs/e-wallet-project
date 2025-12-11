import 'package:e_wallet/blocs/auth/auth_bloc.dart';
import 'package:e_wallet/blocs/data_plan/data_plan_bloc.dart';
import 'package:e_wallet/models/data_plan_form_model.dart';
import 'package:e_wallet/models/data_plans_model.dart';
import 'package:e_wallet/models/operator_card_model.dart';
import 'package:e_wallet/shared/shared_method.dart';
import 'package:e_wallet/shared/theme.dart';
import 'package:e_wallet/ui/widgets/buttons.dart';
import 'package:e_wallet/ui/widgets/form.dart';
import 'package:e_wallet/ui/widgets/package_item.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class DataPackagePage extends StatefulWidget {
  final OperatorCardModel operatorCard;
  const DataPackagePage({
    super.key,
    required this.operatorCard,
  });

  @override
  State<DataPackagePage> createState() => _DataPackagePageState();
}

class _DataPackagePageState extends State<DataPackagePage> {
  final phoneController = TextEditingController(text: '');
  //for selected data plan id. we make variable select data plan
  DataPlansModel? selectedDataPlan;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => DataPlanBloc(),
      child: BlocConsumer<DataPlanBloc, DataPlanState>(
        listener: (context, state) {
          if (state is DataPlanFailed) {
            showCustomSnackbar(context, state.e);
          }

          if (state is DataPlanSucces) {
            context.read<AuthBloc>().add(
                  AuthUpdateBalance(
                    selectedDataPlan!.price! *
                        -1, //agar amount berkurang setelah di kirim
                  ),
                );

            Navigator.pushNamedAndRemoveUntil(
                context, '/data-success', (route) => false);
          }
        },
        builder: (context, state) {
          if (state is DataPlanLoading) {
            return Scaffold(
              backgroundColor: lightBackgroundColor,
              body: Center(
                child: CircularProgressIndicator(
                  valueColor: AlwaysStoppedAnimation<Color>(primaryColor),
                ),
              ),
            );
          }
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
                'Paket Data',
                style: blackTextStyle.copyWith(
                  fontSize: 18,
                  fontWeight: semiBold,
                ),
              ),
              centerTitle: true,
            ),
            body: Stack(
              children: [
                ListView(
                  padding: const EdgeInsets.symmetric(horizontal: 24),
                  children: [
                    const SizedBox(height: 20),
                    // Operator Card Header
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
                              color: lightBackgroundColor,
                              borderRadius: BorderRadius.circular(16),
                            ),
                            child: Center(
                              child: Image.asset(
                                widget.operatorCard.thumbnail.toString(),
                                width: 40,
                                errorBuilder: (context, error, stackTrace) {
                                  return Icon(
                                    Icons.sim_card,
                                    color: primaryColor,
                                    size: 32,
                                  );
                                },
                              ),
                            ),
                          ),
                          const SizedBox(width: 16),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  widget.operatorCard.name.toString(),
                                  style: blackTextStyle.copyWith(
                                    fontSize: 18,
                                    fontWeight: bold,
                                  ),
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  '${widget.operatorCard.dataPlans!.length} packages available',
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
                    const SizedBox(height: 32),
                    // Phone Number Section
                    Text(
                      'Phone Number',
                      style: blackTextStyle.copyWith(
                        fontSize: 16,
                        fontWeight: semiBold,
                      ),
                    ),
                    const SizedBox(height: 12),
                    Container(
                      decoration: BoxDecoration(
                        color: whiteColor,
                        borderRadius: BorderRadius.circular(16),
                        boxShadow: [
                          BoxShadow(
                            color: blackColor.withOpacity(0.05),
                            blurRadius: 10,
                            offset: const Offset(0, 2),
                          ),
                        ],
                      ),
                      child: CustomFormField(
                        title: '+628',
                        isShowTitle: false,
                        controller: phoneController,
                      ),
                    ),
                    const SizedBox(height: 32),
                    // Select Package Section
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Select Package',
                          style: blackTextStyle.copyWith(
                            fontSize: 16,
                            fontWeight: semiBold,
                          ),
                        ),
                        if (selectedDataPlan != null)
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 12,
                              vertical: 6,
                            ),
                            decoration: BoxDecoration(
                              color: primaryColor.withOpacity(0.1),
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: Text(
                              'Selected',
                              style: primaryTextStyle.copyWith(
                                fontSize: 12,
                                fontWeight: semiBold,
                              ),
                            ),
                          ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    Wrap(
                      spacing: 16,
                      runSpacing: 16,
                      alignment: WrapAlignment.spaceBetween,
                      children: widget.operatorCard.dataPlans!.map((dataPlan) {
                        return GestureDetector(
                          onTap: () {
                            setState(() {
                              selectedDataPlan = dataPlan;
                            });
                          },
                          child: PackageItem(
                            dataPlan: dataPlan,
                            isSelected: dataPlan.id == selectedDataPlan?.id,
                          ),
                        );
                      }).toList(),
                    ),
                    const SizedBox(height: 100),
                  ],
                ),
                // Continue Button
                if (selectedDataPlan != null && phoneController.text.isNotEmpty)
                  Positioned(
                    bottom: 0,
                    left: 0,
                    right: 0,
                    child: Container(
                      padding: const EdgeInsets.all(24),
                      decoration: BoxDecoration(
                        color: whiteColor,
                        boxShadow: [
                          BoxShadow(
                            color: blackColor.withOpacity(0.08),
                            blurRadius: 20,
                            offset: const Offset(0, -4),
                          ),
                        ],
                      ),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          if (selectedDataPlan != null)
                            Container(
                              padding: const EdgeInsets.all(16),
                              margin: const EdgeInsets.only(bottom: 16),
                              decoration: BoxDecoration(
                                color: lightBackgroundColor,
                                borderRadius: BorderRadius.circular(16),
                              ),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        selectedDataPlan!.name.toString(),
                                        style: blackTextStyle.copyWith(
                                          fontSize: 14,
                                          fontWeight: semiBold,
                                        ),
                                      ),
                                      const SizedBox(height: 4),
                                      Text(
                                        '+628${phoneController.text}',
                                        style: greyTextStyle.copyWith(
                                          fontSize: 12,
                                        ),
                                      ),
                                    ],
                                  ),
                                  Text(
                                    formatCurrency(
                                        selectedDataPlan!.price ?? 0),
                                    style: primaryTextStyle.copyWith(
                                      fontSize: 16,
                                      fontWeight: bold,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          CustomFilledButton(
                            title: 'Continue',
                            onPressed: () async {
                              if (await Navigator.pushNamed(context, '/pin') ==
                                  true) {
                                final authState = context
                                    .read<AuthBloc>()
                                    .state; //this using because need pin for send data

                                String pin = '';
                                if (authState is AuthSuccess) {
                                  pin = authState.user.pin!;
                                }

                                context.read<DataPlanBloc>().add(
                                      DataPlanPost(DataPlanFormModel(
                                        dataPlanId: selectedDataPlan!.id,
                                        phoneNumber: phoneController.text,
                                        pin: pin,
                                      )),
                                    );
                              }
                            },
                          ),
                        ],
                      ),
                    ),
                  ),
              ],
            ),
          );
        },
      ),
    );
  }
}
