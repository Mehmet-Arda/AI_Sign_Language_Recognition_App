part of 'can_resend_email_bloc.dart';

class CanResendEmailState extends Equatable {
  final bool canResendEmail;

  const CanResendEmailState({
    required this.canResendEmail,
  });

  @override
  List<Object> get props => [canResendEmail];
}
