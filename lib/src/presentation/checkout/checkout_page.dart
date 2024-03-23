import 'package:beam_checkout_assignment/src/data/user.dart';
import 'package:beam_checkout_assignment/src/presentation/checkout/add_note_page.dart';
import 'package:beam_checkout_assignment/src/common/base/state_awareness_view_model.dart';
import 'package:beam_checkout_assignment/src/common/component/custom_button.dart';
import 'package:beam_checkout_assignment/src/presentation/payment/payment_page.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:rxdart/rxdart.dart';

import '../../common/base/base_state.dart';
import 'checkout_view_model.dart';

class CheckoutPage extends StatefulWidget {
  const CheckoutPage({super.key});
  static const routeName = '/checkout';

  @override
  State<StatefulWidget> createState() => _CheckoutPageState();
}

class _CheckoutPageState extends BaseState<CheckoutPage>
    with StateAwarenessViewModel<CheckoutViewModel, CheckoutPage> {
  late final CheckoutViewModel _viewModel = viewModel();

  List<String> input = [];
  String? _note;
  User? _user;

  @override
  void initState() {
    _viewModel.onPageLoad();
    _subscribeToViewModel();
    super.initState();
  }

  void _subscribeToViewModel() {
    _viewModel.user.listen((user) {
      setState(() {
        _user = user;
      });
    }).addTo(compositeSubscription);

    _viewModel.navigateToPaymentPage.listen((amount) {
      Navigator.of(context).pushNamed(PaymentPage.routeName,
          arguments: PaymentPageArgs(amount: amount, name: _user?.name ?? ''));
    }).addTo(compositeSubscription);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: false,
        leading: Padding(
          padding: const EdgeInsets.only(left: 16),
          child: CircleAvatar(
            child: Text(_user?.email[1] ?? ''),
          ),
        ),
        title: Text(
          _user?.email ?? '',
          style: Theme.of(context).textTheme.bodyMedium,
          overflow: TextOverflow.ellipsis,
        ),
        actions: [
          Container(
            margin: const EdgeInsets.only(right: 16),
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: const Color.fromRGBO(222, 226, 230, 1),
              borderRadius: BorderRadius.circular(4),
            ),
          )
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: 0,
        onTap: (index) {},
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: "Checkout"),
          BottomNavigationBarItem(
              icon: Icon(Icons.settings), label: "Settings"),
        ],
      ),
      body: SafeArea(
        minimum: const EdgeInsets.symmetric(horizontal: 16),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 16),
                child: Text(
                  NumberFormat.currency(symbol: '฿ ')
                      .format(double.tryParse(input.join()) ?? 0),
                  style: Theme.of(context).textTheme.headlineLarge,
                ),
              ),
              GridView.count(
                crossAxisCount: 3,
                childAspectRatio: 104 / 80,
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                crossAxisSpacing: 8,
                mainAxisSpacing: 8,
                children: _getKeypadList(),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 20),
                child: Row(
                  children: [
                    Expanded(
                        flex: 1,
                        child: CustomButton.secondary(
                          text: "Note",
                          onPressed: _onNotePressed,
                          isSelected: _note != null && _note!.isNotEmpty,
                          leadingIcon: Icon(
                            _note != null && _note!.isNotEmpty
                                ? Icons.check
                                : Icons.edit_outlined,
                            size: 24,
                          ),
                        )),
                    const SizedBox(
                      width: 8,
                    ),
                    Expanded(
                      flex: 2,
                      child: CustomButton.primary(
                        isDisabled:
                            input.isEmpty || double.tryParse(input.join()) == 0,
                        onPressed: () => _viewModel.onChargePressed(
                            double.tryParse(input.join()) ?? 0),
                        text: "Charge",
                      ),
                    )
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  List<Widget> _getKeypadList() {
    final numpad = List.generate(9, (index) {
      final number = index + 1;
      return OutlinedButton(
          onPressed: () => _addNum(number), child: Text(number.toString()));
    });
    numpad.addAll([
      OutlinedButton(onPressed: _addDot, child: const Text('.')),
      OutlinedButton(onPressed: _addZero, child: const Text('0')),
      OutlinedButton(onPressed: _removeNum, child: const Icon(Icons.backspace)),
    ]);
    return numpad;
  }

  void _addNum(int number) {
    if (input.every((element) => element == '0')) {
      input.clear();
    }
    if (input.contains('.') && input.lastIndexOf('.') <= input.length - 3) {
      return;
    }
    if (!input.contains('.') && input.length >= 7) return;
    setState(() {
      input.add(number.toString());
    });
  }

  void _addZero() {
    if (input.length == 1 && input.first == '0') return;
    if (input.contains('.') && input.lastIndexOf('.') <= input.length - 3) {
      return;
    }
    if (!input.contains('.') && input.length >= 7) return;
    setState(() {
      input.add('0');
    });
  }

  void _addDot() {
    if (input.contains('.')) return;
    setState(() {
      if (input.isEmpty) {
        input.addAll(['0', '.']);
      } else {
        input.add('.');
      }
    });
  }

  void _removeNum() {
    if (input.isNotEmpty) {
      setState(() {
        input.removeLast();
        if (input.lastOrNull == '.') {
          input.removeLast();
        }
      });
    }
  }

  void _onNotePressed() async {
    final result = await Navigator.of(context).pushNamed(AddNotePage.routeName,
        arguments: AddNotePageArgs(note: _note)) as String?;
    if (result != null) {
      setState(() {
        _note = result;
      });
    }
  }
}
