import 'package:flutter_bloc/flutter_bloc.dart';
import '../core/api_client.dart';

abstract class NotificationState {}

class NotificationInitial extends NotificationState {}
class NotificationLoading extends NotificationState {}
class NotificationLoaded extends NotificationState {
  final List<dynamic> notifications;
  NotificationLoaded(this.notifications);
}
class NotificationError extends NotificationState {
  final String message;
  NotificationError(this.message);
}

class NotificationCubit extends Cubit<NotificationState> {
  NotificationCubit() : super(NotificationInitial());

  Future<void> fetchNotifications() async {
    emit(NotificationLoading());
    try {
      final client = ApiClient();
      final response = await client.dio.get('/notifications');
      if (response.statusCode == 200) {
        final list = response.data as List<dynamic>;
        emit(NotificationLoaded(list));
      } else {
        emit(NotificationError('Bildirishnomalarni yuklashda xatolik'));
      }
    } catch (e) {
      emit(NotificationError('Bildirishnomalarni yuklashda xatolik: ${e.toString()}'));
    }
  }

  Future<void> markAsRead(String id) async {
    try {
      final client = ApiClient();
      final response = await client.dio.post('/notifications/$id/read');
      if (response.statusCode == 200) {
        fetchNotifications(); // Refresh list
      }
    } catch (e) {
      // Fail silently for local interaction
    }
  }
}
