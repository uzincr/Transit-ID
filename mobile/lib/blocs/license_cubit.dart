import 'package:flutter_bloc/flutter_bloc.dart';
import '../core/api_client.dart';

abstract class LicenseState {}

class LicenseInitial extends LicenseState {}
class LicenseLoading extends LicenseState {}
class LicenseLoaded extends LicenseState {
  final List<dynamic> licenses;
  LicenseLoaded(this.licenses);
}
class LicenseError extends LicenseState {
  final String message;
  LicenseError(this.message);
}

class LicenseCubit extends Cubit<LicenseState> {
  LicenseCubit() : super(LicenseInitial());

  Future<void> fetchLicenses() async {
    emit(LicenseLoading());
    try {
      final client = ApiClient();
      final response = await client.dio.get('/licenses/my');
      if (response.statusCode == 200) {
        final list = response.data as List<dynamic>;
        emit(LicenseLoaded(list));
      } else {
        emit(LicenseError('Litsenziya ma\'lumotlarini yuklashda xatolik'));
      }
    } catch (e) {
      emit(LicenseError('Litsenziya ma\'lumotlarini yuklashda xatolik: ${e.toString()}'));
    }
  }
}
