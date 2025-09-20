import 'package:equatable/equatable.dart';

enum OtaStatus { idle, preparing, transferring, verifying, completed, failed }

class OtaProgress extends Equatable {
  final OtaStatus status;
  final double progress;
  final String? message;
  final String? error;
  
  const OtaProgress({
    required this.status,
    required this.progress,
    this.message,
    this.error,
  });
  
  @override
  List<Object?> get props => [status, progress, message, error];
}