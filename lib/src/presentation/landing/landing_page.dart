import 'package:beam_checkout_assignment/src/common/base/state_awareness_view_model.dart';
import 'package:beam_checkout_assignment/src/presentation/landing/landing_view_model.dart';
import 'package:email_validator/email_validator.dart';
import 'package:flutter/material.dart';
import 'package:rxdart/rxdart.dart';

import '../checkout/checkout_page.dart';
import '../../common/base/base_state.dart';
import '../../common/component/custom_button.dart';
import '../../common/component/custom_textformfield.dart';

class LandingPage extends StatefulWidget {
  const LandingPage({super.key});
  static const routeName = '/landing';

  @override
  State<StatefulWidget> createState() => _LandingPageState();
}

class _LandingPageState extends BaseState<LandingPage>
    with StateAwarenessViewModel<LandingViewModel, LandingPage> {
  late final LandingViewModel _viewModel = viewModel();

  final _formKey = GlobalKey<FormState>();
  final _emailTextController = TextEditingController();
  final _passwordController = TextEditingController();

  @override
  void initState() {
    _subscribeToViewModel();
    super.initState();
  }

  @override
  void dispose() {
    _emailTextController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _subscribeToViewModel() {
    _viewModel.navigateToCheckoutPage.listen((_) {
      Navigator.of(context).pushNamed(CheckoutPage.routeName);
    }).addTo(compositeSubscription);

    _viewModel.showError.listen((_) {
      showAdaptiveDialog(
        context: context,
        builder: (context) => _buildErrorDialog(),
      );
    }).addTo(compositeSubscription);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        minimum: const EdgeInsets.symmetric(horizontal: 16),
        child: SingleChildScrollView(
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 40),
                  child: Text(
                    "Sign in",
                    style: Theme.of(context).textTheme.displayLarge,
                  ),
                ),
                CustomTextFormField(
                  controller: _emailTextController,
                  title: "Email address",
                  isRequired: true,
                  validator: () =>
                      EmailValidator.validate(_emailTextController.text),
                  errorMessage: "Invalid email address. Please try again.",
                  keyboardType: TextInputType.emailAddress,
                  clearButtonOnFocus: true,
                ),
                CustomTextFormField(
                  controller: _passwordController,
                  title: "Password",
                  isRequired: true,
                  obscureText: true,
                  clearButtonOnFocus: true,
                ),
                CustomButton.primary(
                  onPressed: _onSubmit,
                  text: "Sign In",
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _onSubmit() {
    if (_formKey.currentState!.validate()) {
      _viewModel.onSubmit(_emailTextController.text, _passwordController.text);
    } else {
      _viewModel.onError();
    }
  }

  Widget _buildErrorDialog() {
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Couldn't sign you in",
              style: Theme.of(context).textTheme.displayLarge,
            ),
            const SizedBox(height: 24),
            const Text(
              "Your email address or password doesn't look right. Please try again.",
            ),
            const SizedBox(height: 24),
            CustomButton.primary(
              onPressed: Navigator.of(context).pop,
              text: "OK",
            )
          ],
        ),
      ),
    );
  }
}
