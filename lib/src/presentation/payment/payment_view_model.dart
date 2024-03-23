import 'package:beam_checkout_assignment/src/common/base/base_view_model.dart';
import 'package:injectable/injectable.dart';
import 'package:rxdart/rxdart.dart';

@injectable
class PaymentViewModel extends BaseViewModel {
  final BehaviorSubject<bool> _isLoading = BehaviorSubject();
  Stream<bool> get isLoading => _isLoading;

  final BehaviorSubject<bool> _isApproved = BehaviorSubject();
  Stream<bool> get isApproved => _isApproved;

  final PublishSubject<Object?> _navigateToCheckoutPage = PublishSubject();
  Stream<Object?> get navigateToCheckoutPage => _navigateToCheckoutPage;

  void onPageLoad() {
    // Substitute for scan
    Future.delayed(
      const Duration(seconds: 5),
      () {
        _isLoading.add(true);
      },
    );
  }

  void onPaymentProcessed() {
    // Substitute for payment
    Future.delayed(
      const Duration(seconds: 5),
      () {
        _isApproved.add(true);
      },
    );
  }

  void onNextPressed() {
    _navigateToCheckoutPage.add(null);
  }
}
