import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/enums/action_status.dart';
import '../../../../core/routes/router.dart';
import '../../../../core/routes/routes.dart';
import '../../../widgets/buttons/back_arrow_header.dart';
import '../../../widgets/layouts/base_scaffold_widget.dart';
import '../../../widgets/texts/header_text.dart';
import '../../home/bloc/home_bloc.dart';
import 'bloc/payout_setup_bloc.dart';
import 'parts/bank_details_form_view.dart';
import 'parts/identity_confirmation_view.dart';

class USPayoutSetupScreen extends StatelessWidget {
  const USPayoutSetupScreen({super.key, required this.onPopRefresh});

  final bool onPopRefresh;

  @override
  Widget build(BuildContext context) {
    return BaseScaffoldWidget(
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
            subText: "Enter your local US bank details to receive funds.",
            subTextStyle: const TextStyle(fontSize: 14),
            centerSubtitle: false,
            padding: EdgeInsets.zero,
          ),
          const SizedBox(height: 30),
          BlocConsumer<PayoutSetupBloc, PayoutSetupState>(
            listener: (context, state) {
              if (state.usPayoutSetup == USPayoutSetup.success) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(
                      state.successMessage ?? "Bank linked successfully!",
                    ),
                  ),
                );
                context.read<HomeBloc>().add(
                  UpdateOnboardingState(
                    status: ActionStatus.completed,
                    type: OnboardingStep.payout,
                  ),
                );
                if (onPopRefresh == true) {
                  router.pop(true);
                } else {
                  router.go(Paths.HOME);
                }
              }

              if (state.usPayoutSetup == USPayoutSetup.failure) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(
                      state.errorMessage ?? "Error creating Bank Account",
                    ),
                  ),
                );
              }

              if (state.usPayoutSetup == USPayoutSetup.recipientSuccess) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(
                      state.successMessage ?? "Recipient created successfully!",
                    ),
                  ),
                );
              }
              if (state.usPayoutSetup == USPayoutSetup.recipientFailure) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(
                      state.errorMessage ?? "Error creating recipient",
                    ),
                  ),
                );
              }
            },
            builder: (context, state) {
              return Expanded(
                child: AnimatedSwitcher(
                  duration: const Duration(milliseconds: 500),
                  switchInCurve: Curves.easeIn,
                  switchOutCurve: Curves.easeOut,
                  transitionBuilder:
                      (Widget child, Animation<double> animation) {
                        return FadeTransition(
                          opacity: animation,
                          child: SlideTransition(
                            position: Tween<Offset>(
                              begin: const Offset(0.0, 0.05),
                              end: Offset.zero,
                            ).animate(animation),
                            child: child,
                          ),
                        );
                      },
                  child:
                      state.currentPayout == null ||
                          state.currentPayout?.stripeRecipientAccountId == null
                      ? IdentityConfirmationView(
                          key: const ValueKey('identity_view'),
                          isBusy: state.usPayoutSetup == USPayoutSetup.loading,
                        )
                      : BankDetailsFormView(
                          key: const ValueKey('bank_form_view'),
                        ),
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}
