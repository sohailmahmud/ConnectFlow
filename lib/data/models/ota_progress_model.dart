import '../../domain/entities/ota_progress.dart';

class OtaProgressModel extends OtaProgress {
  const OtaProgressModel({
    required super.status,
    required super.progress,
    super.message,
    super.error,
  });
  
  factory OtaProgressModel.fromJson(Map<String, dynamic> json) {
    return OtaProgressModel(
      status: OtaStatus.values.firstWhere(
        (e) => e.toString() == 'OtaStatus.${json['status']}',
      ),
      progress: json['progress'].toDouble(),
      message: json['message'],
      error: json['error'],
    );
  }
  
  Map<String, dynamic> toJson() {
    return {
      'status': status.toString().split('.').last,
      'progress': progress,
      'message': message,
      'error': error,
    };
  }
}