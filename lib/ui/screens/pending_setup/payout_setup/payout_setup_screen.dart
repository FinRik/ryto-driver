import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../bottom_sheets/banks_search_bottom_sheet.dart';
import '../../../widgets/layouts/base_scaffold_widget.dart';
import '../../../widgets/loaders/circular_indicator.dart';
import '../../../widgets/buttons/back_arrow_header.dart';
import '../../../widgets/inputs/general_text_field.dart';
import '../../../../core/enums/action_status.dart';
import '../../../widgets/texts/header_text.dart';
import '../../../../core/models/bank/bank.dart';
import '../../../widgets/buttons/button.dart';
import '../../../../core/routes/router.dart';
import '../../../../core/routes/routes.dart';
import '../../home/bloc/home_bloc.dart';
import 'bloc/payout_setup_bloc.dart';

class PayoutSetupScreen extends StatefulWidget {
  const PayoutSetupScreen({super.key, required this.onPopRefresh});

  final bool onPopRefresh;

  @override
  State<PayoutSetupScreen> createState() => _PayoutSetupScreenState();
}

class _PayoutSetupScreenState extends State<PayoutSetupScreen> {
  final _formKey = GlobalKey<FormState>();

  final _bankController = TextEditingController();
  final _accountNumberController = TextEditingController();
  final _accountNameController = TextEditingController();

  String? _selectedBankCode;
  String? _selectedBankName;

  @override
  void initState() {
    super.initState();
    // Fetch banks if they aren't already loaded in the state
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final state = context.read<PayoutSetupBloc>().state;
      if (state.banks.isEmpty) {
        context.read<PayoutSetupBloc>().add(FetchBanksRequested());
      }
    });

    _accountNumberController.addListener(_onAccountNumberChanged);
  }

  @override
  void dispose() {
    _bankController.dispose();
    _accountNumberController.dispose();
    _accountNameController.dispose();
    super.dispose();
  }

  void _onAccountNumberChanged() {
    final accountNo = _accountNumberController.text.trim();
    if (accountNo.length == 10 && _selectedBankCode != null) {
      _validateAccount();
    }
  }

  void _showBankBottomSheet(List<Bank> banks) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => DraggableScrollableSheet(
        initialChildSize: 0.85,
        minChildSize: 0.6,
        maxChildSize: 0.95,
        expand: false,
        builder: (context, scrollController) {
          return BankSearchBottomSheet(
            banks: banks,
            onBankSelected: (bank) {
              setState(() {
                _selectedBankName = bank.name;
                _selectedBankCode = bank.code;
                _bankController.text = bank.name ?? '';
              });
              Navigator.pop(context);
              if (_accountNumberController.text.trim().length == 10) {
                _validateAccount();
              }
            },
          );
        },
      ),
    );
  }

  Future<void> _validateAccount() async {
    if (_selectedBankCode == null ||
        _accountNumberController.text.trim().isEmpty)
      return;

    context.read<PayoutSetupBloc>().add(
      ValidateBankAccountRequested(
        accountNumber: _accountNumberController.text.trim(),
        bankCode: _selectedBankCode!,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<PayoutSetupBloc, PayoutSetupState>(
      listener: (context, state) {
        // 1. Handle Successful Setup (Navigates Back)
        if (state.ngPayoutSetup == NGPayoutSetup.success) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(state.successMessage ?? "Success"),
              backgroundColor: Colors.green,
            ),
          );
          context.read<HomeBloc>().add(
            UpdateOnboardingState(
              status: ActionStatus.completed,
              type: OnboardingStep.payout,
            ),
          );
          if (widget.onPopRefresh == true) {
            router.pop(true);
          } else {
            router.go(Paths.HOME);
          }
        }

        // 2. Handle Successful Validation (Updates Controller)
        if (state.ngPayoutSetup == NGPayoutSetup.validated) {
          _accountNameController.text = state.validatedAccountName ?? '';
        }

        // 3. Handle Errors (Validation or Setup failures)
        // if (state.ngPayoutSetup == NGPayoutSetup.failure ||
        //     state.fetchStatus == PayoutFetchStatus.failure) {
        //   ScaffoldMessenger.of(context).showSnackBar(
        //     SnackBar(
        //       content: Text(state.errorMessage ?? "An error occurred"),
        //       backgroundColor: Colors.red,
        //     ),
        //   );
        // }
      },
      child: BaseScaffoldWidget(
        extendBodyBehindAppBar: true,
        resizeToAvoidBottomInset: true,
        bottomNavBar: BottomAppBar(
          color: Colors.white,
          elevation: 7,
          height: 90,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            child: BlocBuilder<PayoutSetupBloc, PayoutSetupState>(
              builder: (context, state) {
                return Button(
                  text: "Set Payout Method",
                  isBusy: state.ngPayoutSetup == NGPayoutSetup.loading,
                  onTap: () {
                    if (!_formKey.currentState!.validate()) return;
                    if (_accountNameController.text.isEmpty) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text("Please verify account first"),
                        ),
                      );
                      return;
                    }

                    context.read<PayoutSetupBloc>().add(
                      SetPayoutRequested(
                        bankCode: _selectedBankCode!,
                        bankName: _selectedBankName ?? _bankController.text,
                        accountNumber: _accountNumberController.text.trim(),
                      ),
                    );
                  },
                );
              },
            ),
          ),
        ),
        child: Form(
          key: _formKey,
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const BackArrowHeader(
                  title: "Payout Setup",
                  setDefaultPadding: false,
                ),
                const SizedBox(height: 24),
                HeaderText(
                  label: "Bank Details",
                  subText:
                      "Enter your Nigerian bank account details where you'd like to receive earnings.",
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  subTextStyle: const TextStyle(fontSize: 14),
                  centerSubtitle: true,
                ),
                const SizedBox(height: 32),

                // Bank Name Field
                BlocBuilder<PayoutSetupBloc, PayoutSetupState>(
                  builder: (context, state) {
                    return GeneralTextField(
                      label: "Bank Name",
                      hint: "Select Bank Name",
                      readOnly: true,
                      prefixIcon: null,
                      controller: _bankController,
                      suffixIcon: state.fetchStatus == PayoutFetchStatus.loading
                          ? Transform.scale(
                              scale: .4,
                              child: const CircularProgressIndicator(
                                strokeWidth: 2,
                              ),
                            )
                          : IconButton(
                              icon: const Icon(Icons.keyboard_arrow_down),
                              onPressed: () {
                                if (state.banks.isNotEmpty) {
                                  _showBankBottomSheet(state.banks);
                                } else {
                                  context.read<PayoutSetupBloc>().add(
                                    FetchBanksRequested(),
                                  );
                                }
                              },
                            ),
                      validator: (value) => value?.isEmpty ?? true
                          ? "Please select a bank"
                          : null,
                    );
                  },
                ),

                const SizedBox(height: 16),

                // Account Number Field
                GeneralTextField(
                  label: "Account Number",
                  hint: "0123456789",
                  controller: _accountNumberController,
                  textInputType: TextInputType.number,
                  prefixIcon: null,
                  inputFormatters: [LengthLimitingTextInputFormatter(10)],
                  validator: (value) => (value == null || value.length != 10)
                      ? "Enter a valid 10-digit account number"
                      : null,
                ),

                const SizedBox(height: 16),

                // Account Name Field (Auto-filled)
                BlocBuilder<PayoutSetupBloc, PayoutSetupState>(
                  builder: (context, state) {
                    final isVerifying =
                        state.ngPayoutSetup == NGPayoutSetup.validating;
                    return GeneralTextField(
                      label: "Account Name",
                      hint: "Account name will appear here",
                      prefixIcon: null,
                      readOnly: true,
                      fillColor: const Color(0xffF1F5F9),
                      filled: true,
                      controller: _accountNameController,
                      suffixIcon: isVerifying
                          ? Transform.scale(
                              scale: .4,
                              child: const CircularIndicator(),
                            )
                          : null,
                      validator: (value) => value?.isEmpty ?? true
                          ? "Account verification required"
                          : null,
                    );
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
