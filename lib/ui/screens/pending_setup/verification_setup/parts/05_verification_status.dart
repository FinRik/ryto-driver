// import 'package:flutter/material.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
//
// import '../../../../../../core/routes/router.dart';
// import '../../../../../../core/routes/routes.dart';
// import '../../../../../core/enums/action_status.dart';
// import '../../../../../core/enums/verification_status.dart';
// import '../../../../layout/dashboard_manager/cubit/onboarding_cubit.dart';
// import '../../../../widgets/buttons/back_arrow_button.dart';
// import '../../../../widgets/buttons/button.dart';
// import '../../../../widgets/loaders/loading_shimmer.dart';
// import '../../../../widgets/texts/header_text.dart';
// import '../../../../widgets/verification_card.dart';
// import '../bloc/verification_setup_bloc.dart';
//
// class VerificationStatus extends StatefulWidget {
//   const VerificationStatus({super.key, required this.pageController});
//
//   final PageController pageController;
//
//   @override
//   State<VerificationStatus> createState() => _VerificationStatusState();
// }
//
// class _VerificationStatusState extends State<VerificationStatus> {
//   @override
//   void initState() {
//     super.initState();
//     // Trigger the fetch event when the screen opens
//     context.read<VerificationSetupBloc>().add(
//       FetchVerificationStatusRequested(),
//     );
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return BlocConsumer<VerificationSetupBloc, VerificationSetupState>(
//       listener: (context, state) {
//         if (state is VerificationFailure) {
//           ScaffoldMessenger.of(
//             context,
//           ).showSnackBar(SnackBar(content: Text(state.message)));
//         }
//       },
//       builder: (context, state) {
//         return Column(
//           children: [
//             Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 const BackArrowButton(isChevron: false),
//                 const SizedBox(height: 41),
//
//                 // Logic to switch between Loading (Shimmer) and Content
//                 if (state is VerificationLoading)
//                   const LoadingShimmer()
//                 else if (state is VerificationStatusLoaded)
//                   _buildContent(state)
//                 else
//                   const Center(child: Text("Unable to load status")),
//               ],
//             ),
//             BottomAppBar(
//               color: const Color(0xffE7E8E9),
//               height: 120,
//               child: Column(
//                 mainAxisSize: MainAxisSize.max,
//                 children: [
//                   Button(
//                     text: "Go to dashboard",
//                     suffixIcon: Icons.keyboard_arrow_right,
//                     showSuffixIcon: true,
//                     isBusy: false,
//                     onTap: () {
//                       context.read<OnboardingCubit>().updateKyc(
//                         ActionStatus.pending,
//                       );
//                       router.go(Paths.HOME);
//                     },
//                   ),
//                 ],
//               ),
//             ),
//           ],
//         );
//       },
//     );
//   }
//
//   // Extracted content builder to keep the BlocBuilder clean
//   Widget _buildContent(VerificationStatusLoaded state) {
//     // You can now use state.kycResponse to set statuses dynamically
//     return Column(
//       children: [
//         const HeaderText(
//           label: "Verification Pending",
//           subText: "Your documents are being reviewed...",
//           centerSubtitle: true,
//           mainAxisAlignment: MainAxisAlignment.center,
//           crossAxisAlignment: CrossAxisAlignment.center,
//         ),
//         const SizedBox(height: 24),
//         VerificationCard(
//           title: "Identity Verification",
//           subtitle: "Government issued ID",
//           status: _mapStatus(state.kycResponse.identityStatus),
//         ),
//         VerificationCard(
//           title: "Driver's License",
//           subtitle: "Class A/B valid license",
//           index: "2",
//           status: _mapStatus(state.kycResponse.licenseStatus),
//         ),
//       ],
//     );
//   }
//
//   // Helper to map your API status strings to your Enum
//   VerificationStatusEnum _mapStatus(String? status) {
//     switch (status?.toLowerCase()) {
//       case 'approved':
//         return VerificationStatusEnum.completed;
//       case 'pending':
//         return VerificationStatusEnum.inReview;
//       case 'rejected':
//         return VerificationStatusEnum.failed;
//       default:
//         return VerificationStatusEnum.available;
//     }
//   }
// }
