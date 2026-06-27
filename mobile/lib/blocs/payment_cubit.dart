import 'package:flutter_bloc/flutter_bloc.dart';
import '../core/api_client.dart';

abstract class PaymentState {}

class PaymentInitial extends PaymentState {}
class PaymentLoading extends PaymentState {}
class PaymentLoaded extends PaymentState {
  final List<dynamic> payments;
  PaymentLoaded(this.payments);
}
class PaymentSuccess extends PaymentState {
  final Map<String, dynamic> payment;
  PaymentSuccess(this.payment);
}
class PaymentError extends PaymentState {
  final String message;
  PaymentError(this.message);
}

class PaymentCubit extends Cubit<PaymentState> {
  PaymentCubit() : super(PaymentInitial());

  Future<void> fetchPayments() async {
    emit(PaymentLoading());
    try {
      final client = ApiClient();
      final response = await client.dio.get('/payments');
      if (response.statusCode == 200) {
        final list = response.data as List<dynamic>;
        emit(PaymentLoaded(list));
      } else {
        emit(PaymentError('To\'lovlar tarixini yuklashda xatolik'));
      }
    } catch (e) {
      emit(PaymentError('To\'lovlar tarixini yuklashda xatolik: ${e.toString()}'));
    }
  }

  Future<void> initiatePaymentAndComplete(double amount, String method) async {
    emit(PaymentLoading());
    try {
      final client = ApiClient();
      
      // 1. Create PENDING payment
      final createResponse = await client.dio.post('/payments', data: {
        'amount': amount,
        'method': method,
        'description': 'Litsenziya muddatini uzaytirish',
      });
      
      if (createResponse.statusCode == 200) {
        final paymentId = createResponse.data['id'];
        
        // 2. Simulate payment success (Click / Payme webhook trigger)
        final completeResponse = await client.dio.post('/payments/$paymentId/complete?success=true');
        
        if (completeResponse.statusCode == 200) {
          emit(PaymentSuccess(completeResponse.data));
          fetchPayments(); // Refresh list
        } else {
          emit(PaymentError('To\'lovni yakunlashda xatolik yuz berdi'));
        }
      } else {
        emit(PaymentError('To\'lov yaratishda xatolik yuz berdi'));
      }
    } catch (e) {
      emit(PaymentError('To\'lov jarayonida xatolik: ${e.toString()}'));
    }
  }
}
