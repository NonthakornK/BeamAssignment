import 'package:beam_checkout_assignment/src/common/base/base_state.dart';
import 'package:beam_checkout_assignment/src/common/base/state_awareness_view_model.dart';
import 'package:beam_checkout_assignment/src/presentation/payment/payment_view_model.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:rxdart/rxdart.dart';

import '../checkout/checkout_page.dart';

class PaymentPageArgs {
  final double amount;
  final String name;

  const PaymentPageArgs({required this.amount, required this.name});
}

enum PageState { scan, loading, approved }

class PaymentPage extends StatefulWidget {
  const PaymentPage({super.key, required this.args});
  static const routeName = '/payment';

  final PaymentPageArgs args;

  @override
  State<StatefulWidget> createState() => _PaymentPageState();
}

class _PaymentPageState extends BaseState<PaymentPage>
    with StateAwarenessViewModel<PaymentViewModel, PaymentPage> {
  late final PaymentViewModel _viewModel = viewModel();
  PageState _state = PageState.scan;

  @override
  void initState() {
    _viewModel.onPageLoad();
    _subscribeToViewModel();
    super.initState();
  }

  void _subscribeToViewModel() {
    _viewModel.isLoading.listen((user) {
      setState(() {
        _state = PageState.loading;
      });
      _viewModel.onPaymentProcessed();
    }).addTo(compositeSubscription);

    _viewModel.isApproved.listen((user) {
      setState(() {
        _state = PageState.approved;
      });
    }).addTo(compositeSubscription);

    _viewModel.navigateToCheckoutPage.listen((_) {
      Navigator.of(context).pushNamed(CheckoutPage.routeName);
    }).addTo(compositeSubscription);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: _state == PageState.scan ? const Text("Scan to pay") : null,
      ),
      body: SafeArea(
        minimum: const EdgeInsets.symmetric(horizontal: 16),
        child: Builder(
          builder: (context) {
            switch (_state) {
              case PageState.scan:
                return _buildQrPage();
              case PageState.loading:
                return _buildLoadingPage();
              case PageState.approved:
                return _buildApprovedPage();
            }
          },
        ),
      ),
    );
  }

  Widget _buildQrPage() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        QrImageView(
            size: MediaQuery.of(context).size.width * 0.5,
            padding: const EdgeInsets.all(16),
            data: widget.args.amount.toString()),
        const SizedBox(
          height: 24,
        ),
        Container(
          width: double.infinity,
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
              color: const Color.fromRGBO(248, 249, 250, 1),
              borderRadius: BorderRadius.circular(12)),
          child: Column(
            children: [
              Text(
                "Pay ${widget.args.name}",
                style: Theme.of(context).textTheme.displayMedium,
              ),
              Text(
                NumberFormat.currency(symbol: '฿ ').format(widget.args.amount),
                style: Theme.of(context).textTheme.headlineLarge,
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildLoadingPage() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        SizedBox.fromSize(
          size: Size.square(MediaQuery.of(context).size.width * 0.5),
          child: const Padding(
            padding: EdgeInsets.all(16),
            child: CircularProgressIndicator(
              color: Color.fromRGBO(226, 228, 237, 1),
              strokeWidth: 10,
            ),
          ),
        ),
        const SizedBox(
          height: 24,
        ),
        SizedBox(
          width: double.infinity,
          child: Column(
            children: [
              Text(
                "Payment processing...",
                style: Theme.of(context).textTheme.displayLarge,
              ),
              const SizedBox(
                height: 20,
              ),
              Text(
                "Please do not refresh or close this page.\nThanks for being awesome and patient.",
                style: Theme.of(context)
                    .textTheme
                    .displayMedium!
                    .copyWith(color: const Color.fromRGBO(73, 80, 87, 1)),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildApprovedPage() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Padding(
          padding: const EdgeInsets.all(20),
          child: CircleAvatar(
            radius: MediaQuery.of(context).size.width * 0.25,
            backgroundColor: const Color.fromRGBO(79, 112, 253, 1),
          ),
        ),
        const SizedBox(
          height: 20,
        ),
        Text(
          "Payment successful!",
          style: Theme.of(context).textTheme.displayLarge,
        ),
        const SizedBox(
          height: 24,
        ),
        Container(
          width: double.infinity,
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
              color: const Color.fromRGBO(248, 249, 250, 1),
              borderRadius: BorderRadius.circular(12)),
          child: Column(
            children: [
              Text(
                "Paid ${widget.args.name}",
                style: Theme.of(context).textTheme.displayMedium,
              ),
              Text(
                NumberFormat.currency(symbol: '฿ ').format(widget.args.amount),
                style: Theme.of(context).textTheme.headlineLarge,
              ),
            ],
          ),
        ),
        const SizedBox(
          height: 20,
        ),
        SizedBox(
          width: double.infinity,
          child: OutlinedButton(
            style: OutlinedButton.styleFrom(
              padding: const EdgeInsets.all(18),
              textStyle: TextStyle(
                fontFamily: GoogleFonts.inter().fontFamily,
                fontWeight: FontWeight.w600,
                fontSize: 16,
                height: 24 / 16,
              ),
              side: const BorderSide(
                color: Color.fromRGBO(222, 226, 230, 1),
              ),
              foregroundColor: const Color.fromRGBO(73, 80, 87, 1),
            ),
            onPressed: _viewModel.onNextPressed,
            child: const Text("Charge New Payment"),
          ),
        )
      ],
    );
  }
}
