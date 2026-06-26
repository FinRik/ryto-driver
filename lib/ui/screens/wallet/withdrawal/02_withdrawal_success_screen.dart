import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/routes/router.dart';
import '../../../../core/routes/routes.dart';
import '../../../widgets/buttons/button.dart';
import '../../../widgets/layouts/base_scaffold_widget.dart';
import '../../../widgets/texts/header_text.dart';
import '../bloc/wallet_bloc.dart';

class WithdrawalSuccessScreen extends StatelessWidget {
  const WithdrawalSuccessScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BaseScaffoldWidget(
      bgColor: const Color(0xFF0061FF),
      child: BlocBuilder<WalletBloc, WalletState>(
        builder: (context, state) {
          return Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Spacer(flex: 2),
              Center(
                child: Container(
                  height: 180,
                  width: 180,
                  decoration: const BoxDecoration(
                    image: DecorationImage(
                      image: AssetImage('assets/images/receipt.png'),
                      fit: BoxFit.contain,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 38),
              const HeaderText(
                label: "Transaction completed",
                subText:
                    "Your transaction has been processed successfully.You can view the details or return to continue using the app.",
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                centerLabel: true,
                centerSubtitle: true,
                labelStyle: TextStyle(color: Colors.white),
                subTextStyle: TextStyle(color: Colors.white70),
              ),

              const Spacer(flex: 2),

              Button(
                onTap: () {
                  router.go(
                    Paths.WITHDRAWDETAIL,
                    extra: state.withdrawalResponse,
                  );
                },
                text: "Transaction Details",
                buttonColor: Colors.yellow,
                textColor: Colors.black,
              ),
              const SizedBox(height: 16),

              SizedBox(
                width: double.infinity,
                height: 56,
                child: Button.outline(
                  onTap: () {
                    // Navigator.of(context).popUntil((route) => route.isFirst);
                    router.go(Paths.HOME);
                  },
                  text: "Go Home",
                  textColor: Colors.yellow,
                  border: Border.all(color: Colors.yellow),
                ),
              ),
              const SizedBox(height: 24),
            ],
          );
        },
      ),
    );
  }
}
