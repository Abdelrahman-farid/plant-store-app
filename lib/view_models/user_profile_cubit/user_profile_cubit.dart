import 'package:flutter_bloc/flutter_bloc.dart';
import 'user_profile_state.dart';

class UserProfileCubit extends Cubit<UserProfileState> {
  UserProfileCubit()
    : super(UserProfileState(name: 'Abdelrahman Farid', photoUrl: null));

  void updateProfile({String? name, String? photoUrl}) {
    emit(
      state.copyWith(
        name: name ?? state.name,
        photoUrl: photoUrl ?? state.photoUrl,
      ),
    );
  }

  void setPhotoUrl(String url) {
    emit(state.copyWith(photoUrl: url));
  }

  void setName(String name) {
    emit(state.copyWith(name: name));
  }
}
