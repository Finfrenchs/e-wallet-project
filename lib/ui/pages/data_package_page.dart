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
            return const Scaffold(
              body: Center(
                child: CircularProgressIndicator(),
              ),
            );
          }
          return Scaffold(
            appBar: AppBar(
              leading: IconButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                icon: Icon(
                  Icons.arrow_back_ios_new_rounded,
                  color: blackColor,
                  size: 20,
                ),
              ),
              title: const Text(
                'Paket Data',
              ),
            ),
            body: ListView(
              padding: const EdgeInsets.symmetric(
                horizontal: 24,
              ),
              children: [
                const SizedBox(
                  height: 30,
                ),
                Text(
                  'Phone Number',
                  style: blackTextStyle.copyWith(
                    fontSize: 16,
                    fontWeight: semiBold,
                  ),
                ),
                const SizedBox(
                  height: 14,
                ),
                CustomFormField(
                  title: '+628',
                  isShowTitle: false,
                  controller: phoneController,
                ),
                const SizedBox(
                  height: 40,
                ),
                Text(
                  'Select Package',
                  style: blackTextStyle.copyWith(
                    fontSize: 16,
                    fontWeight: semiBold,
                  ),
                ),
                const SizedBox(
                  height: 14,
                ),
                Center(
                  child: Wrap(
                    spacing: 17,
                    runSpacing: 17,
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
                          ));
                    }).toList(),
                  ),
                ),
              ],
            ),
            floatingActionButton:
                (selectedDataPlan != null && phoneController.text.isNotEmpty)
                    ? Container(
                        margin: const EdgeInsets.all(24),
                        child: CustomFilledButton(
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
                      )
                    : Container(),
            floatingActionButtonLocation:
                FloatingActionButtonLocation.centerFloat,
          );
        },
      ),
    );
  }
}
