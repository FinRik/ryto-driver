import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../widgets/buttons/button.dart';
import '../../../../widgets/inputs/general_text_field.dart';
import '../bloc/payout_setup_bloc.dart';

class BankDetailsFormView extends StatefulWidget {
  const BankDetailsFormView({super.key});

  @override
  State<BankDetailsFormView> createState() => _BankDetailsFormViewState();
}

class _BankDetailsFormViewState extends State<BankDetailsFormView> {
  final _accountController = TextEditingController();
  final _routingController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<PayoutSetupBloc, PayoutSetupState>(
      builder: (context, state) {
        return Column(
          children: [
            GeneralTextField(
              controller: _routingController,
              label: "Routing Number",
              hint: '0123456789',
              textInputType: TextInputType.number,
              prefixIcon: null,
              // enabled: !isLoading,
            ),
            const SizedBox(height: 16),
            GeneralTextField(
              controller: _accountController,
              label: "Account Number",
              hint: '0123456789',
              textInputType: TextInputType.number,
              prefixIcon: null,
              // enabled: !isLoading,
            ),
            Spacer(),
            Button(
              onTap: _onSubmit,
              isBusy: state.usPayoutSetup == USPayoutSetup.loading,
              text: "Link Bank Account",
            ),
          ],
        );
      },
    );
  }

  void _onSubmit() {
    context.read<PayoutSetupBloc>().add(
      SetUSPayoutRequested(
        accountNumber: _accountController.text,
        routingNumber: _routingController.text,
        country: "US",
      ),
    );
  }
}
