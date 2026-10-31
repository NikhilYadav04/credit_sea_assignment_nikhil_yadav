enum StageState { done, active, pending, rejected }

class TimelineStep {
  const TimelineStep({required this.label, required this.state});

  final String label;
  final StageState state;

  factory TimelineStep.fromJson(Map<String, dynamic> json) {
    return TimelineStep(
      label: json['label'] as String,
      state: StageState.values.byName(json['state'] as String),
    );
  }
}

class LoanApplication {
  const LoanApplication({
    required this.id,
    required this.applicationNo,
    required this.purpose,
    required this.amount,
    required this.tenureDays,
    required this.totalPayable,
    required this.status,
    required this.bannerTitle,
    required this.bannerMessage,
    required this.timeline,
    required this.repaid,
    this.rejectionReason,
    this.dueAt,
  });

  final String id;
  final String applicationNo;
  final String purpose;
  final int amount;
  final int tenureDays;
  final int totalPayable;
  final String status;
  final String bannerTitle;
  final String bannerMessage;
  final String? rejectionReason;
  final List<TimelineStep> timeline;
  final bool repaid;
  final DateTime? dueAt;

  bool get isFinished => status == 'REJECTED' || status == 'DISBURSED';

  bool get canRepay => status == 'DISBURSED' && !repaid;

  factory LoanApplication.fromJson(Map<String, dynamic> json) {
    final banner = json['banner'] as Map<String, dynamic>;
    return LoanApplication(
      id: json['id'] as String,
      applicationNo: json['applicationNo'] as String,
      purpose: json['purpose'] as String,
      amount: (json['amount'] as num).toInt(),
      tenureDays: (json['tenureDays'] as num).toInt(),
      totalPayable: (json['totalPayable'] as num).toInt(),
      status: json['status'] as String,
      bannerTitle: banner['title'] as String,
      bannerMessage: banner['message'] as String,
      rejectionReason: json['rejectionReason'] as String?,
      repaid: json['repaid'] as bool? ?? false,
      dueAt: json['dueAt'] == null ? null : DateTime.parse(json['dueAt'] as String).toLocal(),
      timeline: (json['timeline'] as List)
          .map((e) => TimelineStep.fromJson(e as Map<String, dynamic>))
          .toList(),
    );
  }
}
