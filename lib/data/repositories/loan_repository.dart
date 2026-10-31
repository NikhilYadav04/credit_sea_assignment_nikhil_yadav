import '../../app/constants/api_endpoints.dart';
import '../../core/network/api_client.dart';
import '../models/loan_application.dart';
import '../models/loan_offer.dart';

class LoanRepository {
  LoanRepository(this._api);

  final ApiClient _api;

  Future<LoanOffer> getOffer() async {
    final data = await _api.get(ApiEndpoints.loanOffer);
    return LoanOffer.fromJson(data);
  }

  Future<LoanApplication> apply({
    required int amount,
    required int tenureDays,
    required String purpose,
  }) async {
    final data = await _api.post(
      ApiEndpoints.loanApply,
      body: {'amount': amount, 'tenureDays': tenureDays, 'purpose': purpose},
    );
    return LoanApplication.fromJson(data['application'] as Json);
  }

  Future<List<LoanApplication>> list() async {
    final data = await _api.get(ApiEndpoints.loanApplications);
    return (data['applications'] as List)
        .map((e) => LoanApplication.fromJson(e as Json))
        .toList();
  }

  Future<LoanApplication> detail(String id) async {
    final data = await _api.get('${ApiEndpoints.loanApplications}/$id');
    return LoanApplication.fromJson(data['application'] as Json);
  }
}
