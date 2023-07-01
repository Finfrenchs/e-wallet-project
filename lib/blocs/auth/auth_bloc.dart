import 'package:bloc/bloc.dart';
import 'package:e_wallet/models/signin_form_model.dart';
import 'package:e_wallet/models/signup_form_model.dart';
import 'package:e_wallet/models/user_edit_form_model.dart';
import 'package:e_wallet/models/user_model.dart';
import 'package:e_wallet/services/auth_service.dart';
import 'package:e_wallet/services/user_service.dart';
import 'package:e_wallet/services/wallets_service.dart';
import 'package:equatable/equatable.dart';

part 'auth_event.dart';
part 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  AuthBloc() : super(AuthInitial()) {
    on<AuthEvent>((event, emit) async {
      // TODO: implement event handler

      ///for check email
      if (event is AuthCheckEmail) {
        try {
          emit(AuthLoading());

          //save retrow from authsrvice check email
          final res = await AuthService().checkEmail(event.email);

          if (res == false) {
            emit(AuthCheckEmailSuccess());
          } else {
            emit(const AuthFailed('Email sudah terpakai.'));
          }
        } catch (e) {
          emit(AuthFailed(e.toString()));
        }
      }

      ///for register
      if (event is AuthRegister) {
        try {
          emit(AuthLoading());

          final user = await AuthService().register(event.data);

          emit(AuthSuccess(user));
        } catch (e) {
          emit(AuthFailed(e.toString()));
        }
      }

      ///for login
      if (event is AuthLogin) {
        try {
          emit(AuthLoading());

          final user = await AuthService().login(event.data);

          emit(AuthSuccess(user));
        } catch (e) {
          emit(AuthFailed(e.toString()));
        }
      }

      //for get current user
      if (event is AuthGetCurrentUser) {
        try {
          emit(AuthLoading());

          final SignInFormModel data =
              await AuthService().getCredentialFromLocal();

          final UserModel user = await AuthService().login(data); //will relogin

          emit(AuthSuccess(user));
        } catch (e) {
          emit(AuthFailed(e.toString()));
        }
      }

      //for update user
      if (event is AuthUpdateUser) {
        try {
          //pastikan state AuthSucces
          if (state is AuthSuccess) {
            final updatedUser = (state as AuthSuccess).user.copyWith(
                  username: event.data.username,
                  name: event.data.name,
                  email: event.data.email,
                  password: event.data.password,
                ); //mengambil data yang lama dan di ganti dengan data baru

            emit(AuthLoading());

            await UserService().updateUser(event.data);

            emit(AuthSuccess(updatedUser));
          }
        } catch (e) {
          print(e);
          emit(AuthFailed(e.toString()));
        }
      }

      //for update pin
      if (event is AuthUpdatePin) {
        try {
          //pastikan state AuthSucces
          if (state is AuthSuccess) {
            final updatedUser = (state as AuthSuccess).user.copyWith(
                  pin: event.newPin,
                ); //mengambil data yang lama dan di ganti dengan data baru

            emit(AuthLoading());

            await WalletsService().updatePin(event.oldPin, event.newPin);

            emit(AuthSuccess(updatedUser));
          }
        } catch (e) {
          print(e);
          emit(AuthFailed(e.toString()));
        }
      }

      //for logout
      if (event is AuthLogout) {
        try {
          emit(AuthLoading());

          await AuthService().logout();

          emit(AuthInitial()); //back to first condition

        } catch (e) {
          print(e);
          emit(AuthFailed(e.toString()));
        }
      }

      //for update user
      if (event is AuthUpdateBalance) {
        //pastikan state AuthSucces
        if (state is AuthSuccess) {
          //get current balance
          final currentUser = (state as AuthSuccess).user;
          final updatedUser = currentUser.copyWith(
            balance: currentUser.balance! + event.amount,
          ); //mengambil data yang lama dan di tambahkan balance baru

          emit(AuthSuccess(updatedUser));
        }
      }
    });
  }
}
