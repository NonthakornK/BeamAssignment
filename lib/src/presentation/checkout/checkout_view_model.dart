import 'package:beam_checkout_assignment/src/common/base/base_view_model.dart';
import 'package:beam_checkout_assignment/src/data/user.dart';
import 'package:injectable/injectable.dart';
import 'package:rxdart/rxdart.dart';

@injectable
class CheckoutViewModel extends BaseViewModel {
  final BehaviorSubject<User> _user = BehaviorSubject();
  Stream<User> get user => _user;

  final PublishSubject<double> _navigateToPaymentPage = PublishSubject();
  Stream<double> get navigateToPaymentPage => _navigateToPaymentPage;

  void onPageLoad() {
    _user.add(const User(
        name: "Maeb Studio", email: "patcharapan.jear@maebstudio.com"));
  }

  void onChargePressed(double amount) {
    _navigateToPaymentPage.add(amount);
  }
}
