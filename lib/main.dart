import 'package:e_wallet/blocs/auth/auth_bloc.dart';
import 'package:e_wallet/blocs/user/user_bloc.dart';
import 'package:e_wallet/shared/theme.dart';
import 'package:e_wallet/ui/pages/data_provider_page.dart';
import 'package:e_wallet/ui/pages/data_success_page.dart';
import 'package:e_wallet/ui/pages/home_page.dart';
import 'package:e_wallet/ui/pages/onboarding_page.dart';
import 'package:e_wallet/ui/pages/pin_page.dart';
import 'package:e_wallet/ui/pages/profile_edit_page.dart';
import 'package:e_wallet/ui/pages/profile_edit_pin_page.dart';
import 'package:e_wallet/ui/pages/profile_edit_success_page.dart';
import 'package:e_wallet/ui/pages/profile_page.dart';
import 'package:e_wallet/ui/pages/sign_in_page.dart';
import 'package:e_wallet/ui/pages/sign_up_page.dart';
import 'package:e_wallet/ui/pages/sign_up_success_page.dart';
import 'package:e_wallet/ui/pages/splash_page.dart';
import 'package:e_wallet/ui/pages/topup_page.dart';
import 'package:e_wallet/ui/pages/topup_success_page.dart';
import 'package:e_wallet/ui/pages/transfer_page.dart';
import 'package:e_wallet/ui/pages/transfer_success_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) => AuthBloc()
            ..add(
                AuthGetCurrentUser()), //using ..add for checking current user in the local storage
        ),

        //because recent sent user any in home and user bloc any in home, so build in main.dart
        BlocProvider(
          create: (context) => UserBloc(),
        ),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        //set background color scafold, so that no setting again in page one by one
        theme: ThemeData(
          scaffoldBackgroundColor: lightBackgroundColor,
          appBarTheme: AppBarTheme(
            backgroundColor: lightBackgroundColor,
            elevation: 0,
            centerTitle: true,
            iconTheme: IconThemeData(
              color: blackColor,
            ),
            titleTextStyle: blackTextStyle.copyWith(
              fontSize: 20,
              fontWeight: semiBold,
            ),
          ),
        ),
        //routing ini memudahkan kita dalam memanggil halam yang kita tuju
        //karena kita hanya memanggil route name saja jadi tidak perlu panjang2 seperti Navogator.push()......
        routes: {
          '/': (context) => const SplashPage(),
          '/onboarding': (context) => const OnboardingPage(),
          '/sign-in': (context) => const SignInPage(),
          '/sign-up': (context) => const SignUpPage(),
          '/sign-up-success': (context) => const SignUpSuccessPage(),
          '/home': (context) => const HomePage(),
          '/profile': (context) => const ProfilePage(),
          '/pin': (context) => const PinPage(),
          '/profile-edit': (context) => const ProfileEditPage(),
          '/profile-edit-pin': (context) => const ProfileEditPinPage(),
          '/profile-edit-success': (context) => const ProfileEditSuccessPage(),
          '/topup': (context) => const TopUpPage(),
          '/topup-success': (context) => const TopUpSuccessPage(),
          '/transfer': (context) => const TransferPage(),
          '/transfer-success': (context) => const TransferSuccessPage(),
          '/data-provider': (context) => const DataProviderPage(),
          '/data-success': (context) => const DataSuccessPage(),
        },
      ),
    );
  }
}
