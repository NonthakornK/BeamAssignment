import 'package:beam_checkout_assignment/src/common/base/base_view_model.dart';
import 'package:email_validator/email_validator.dart';
import 'package:injectable/injectable.dart';
import 'package:rxdart/rxdart.dart';

@injectable
class LandingViewModel extends BaseViewModel {
  final PublishSubject<Object?> _showError = PublishSubject();
  Stream<Object?> get showError => _showError;
  final PublishSubject<Object?> _navigateToCheckoutPage = PublishSubject();
  Stream<Object?> get navigateToCheckoutPage => _navigateToCheckoutPage;

  void onSubmit(String email, String password) {
    // Substitute for api response
    final result = EmailValidator.validate(email);
    if (result) {
      _navigateToCheckoutPage.add(null);
    } else {
      _showError.add(null);
    }
  }

  void onError() {
    _showError.add(null);
  }
}
