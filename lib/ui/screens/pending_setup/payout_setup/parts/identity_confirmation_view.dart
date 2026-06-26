import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../core/models/user/user_entity.dart';
import '../../../../blocs/profile/profile_bloc.dart';
import '../../../../widgets/buttons/button.dart';
import '../bloc/payout_setup_bloc.dart';

class IdentityConfirmationView extends StatelessWidget {
  final bool isBusy;

  const IdentityConfirmationView({super.key, required this.isBusy});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ProfileBloc, ProfileState>(
      builder: (context, state) {
        final user = state.user;
        return Column(
          children: [
            const Icon(
              Icons.verified_user_outlined,
              size: 30,
              color: Colors.blue,
            ),
            const SizedBox(height: 16),
            const Text(
              "Verify Your Details",
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            ),
            const Text(
              "Confirm your legal info for US Payouts",
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 32),

            _infoCard(user!),
            Spacer(),
            Button(
              onTap: () {
                context.read<PayoutSetupBloc>().add(
                  SetUSRecipientRequested(
                    contactEmail: user.email ?? "",
                    displayName: "${user.firstName} ${user.lastName}",
                    entityType: "individual",
                  ),
                );
              },
              isBusy: isBusy,
              text: "Confirm & Continue",
            ),
          ],
        );
      },
    );
  }

  Widget _infoCard(UserEntity user) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.grey[50],
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey[200]!),
      ),
      child: Column(
        children: [
          _row("Legal Name", "${user.firstName} ${user.lastName}"),
          const Divider(),
          _row("Home Address", user.homeAddress ?? "Not set"),
          const Divider(),
          _row("Country", user.country!),
        ],
      ),
    );
  }

  Widget _row(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: const TextStyle(color: Colors.grey)),
          Text(value, style: const TextStyle(fontWeight: FontWeight.bold)),
        ],
      ),
    );
  }
}
