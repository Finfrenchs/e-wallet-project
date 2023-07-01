import 'package:bloc/bloc.dart';
import 'package:e_wallet/models/user_model.dart';
import 'package:e_wallet/services/user_service.dart';
import 'package:equatable/equatable.dart';

part 'user_event.dart';
part 'user_state.dart';

class UserBloc extends Bloc<UserEvent, UserState> {
  UserBloc() : super(UserInitial()) {
    on<UserEvent>((event, emit) async {
      //for get by username
      if (event is UserGetByUsername) {
        try {
          emit(UserLoading());

          final users = await UserService().getUsersByUsernaame(event.username);

          emit(UserSuccess(users));
        } catch (e) {
          emit(UserFailed(e.toString()));
        }
      }

      //for get recent user
      if (event is UserGetRecent) {
        try {
          emit(UserLoading());

          final users = await UserService().getRecentUsers();

          emit(UserSuccess(users));
        } catch (e) {
          emit(UserFailed(e.toString()));
        }
      }
    });
  }
}
