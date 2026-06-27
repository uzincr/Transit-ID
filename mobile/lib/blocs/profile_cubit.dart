import 'package:flutter_bloc/flutter_bloc.dart';
import '../core/api_client.dart';

abstract class ProfileState {}

class ProfileInitial extends ProfileState {}
class ProfileLoading extends ProfileState {}
class ProfileLoaded extends ProfileState {
  final Map<String, dynamic> data;
  ProfileLoaded(this.data);
}
class ProfileError extends ProfileState {
  final String message;
  ProfileError(this.message);
}

class ProfileCubit extends Cubit<ProfileState> {
  ProfileCubit() : super(ProfileInitial());

  Future<void> fetchProfile() async {
    emit(ProfileLoading());
    try {
      final client = ApiClient();
      final response = await client.dio.get('/users/me');
      if (response.statusCode == 200) {
        emit(ProfileLoaded(response.data));
      } else {
        emit(ProfileError('Profil ma\'lumotlarini yuklashda xatolik'));
      }
    } catch (e) {
      emit(ProfileError('Profil ma\'lumotlarini yuklashda xatolik: ${e.toString()}'));
    }
  }
}
