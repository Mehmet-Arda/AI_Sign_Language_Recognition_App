import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

part 'can_resend_email_event.dart';
part 'can_resend_email_state.dart';

class CanResendEmailBloc extends Bloc<CanResendEmailEvent, CanResendEmailState> {
  CanResendEmailBloc() : super(const CanResendEmailState(canResendEmail: true)) {
    on<CanResendEmailEvent>((event, emit) async{
      


      await Future.delayed(const Duration(seconds: 5));

      
    });
  }
}
