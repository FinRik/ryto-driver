import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../core/routes/router.dart';
import '../../../core/routes/routes.dart';
import '../../widgets/layouts/base_scaffold_widget.dart';
import '../../widgets/texts/header_text.dart';
import 'bloc/trip_setup_bloc.dart';

class TripSuccessScreen extends StatelessWidget {
  const TripSuccessScreen({super.key, required this.isDraft});

  final bool isDraft;

  @override
  Widget build(BuildContext context) {
    // We access the state to show the confirmed details
    return BlocBuilder<TripSetupBloc, TripSetupState>(
      builder: (context, state) {
        final draft = state.draft;

        return BaseScaffoldWidget(
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                IconButton(
                  icon: const Icon(
                    Icons.cancel_outlined,
                    color: Colors.black,
                    size: 28,
                  ),
                  onPressed: () {
                    context.read<TripSetupBloc>().add(const ResetTripSetup());
                    router.go(Paths.HOME);
                  },
                ),

                // 1. Success Animated Icon
                Center(
                  child: Stack(
                    alignment: Alignment.center,
                    children: [
                      Container(
                        width: 128,
                        height: 128,
                        decoration: const BoxDecoration(
                          color: Color(0xFFE2FF3B),
                          shape: BoxShape.circle,
                        ),
                      ),
                      const Icon(Icons.check_circle_outline, size: 50),
                      Positioned(
                        top: 10,
                        right: 0,
                        child: _buildDecorativeDot(12, const Color(0xFFB4F481)),
                      ),
                      Positioned(
                        bottom: 20,
                        left: 0,
                        child: _buildDecorativeDot(18, const Color(0xFFB4F481)),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 31),

                HeaderText(
                  label: isDraft
                      ? "Draft is Saved Successfully!"
                      : "Trip Published Successfully!",
                  labelStyle: const TextStyle(
                    fontSize: 30,
                    fontWeight: FontWeight.bold,
                    height: 1.2,
                  ),
                  subText: isDraft
                      ? "Your ride from ${draft.originCity} to ${draft.destinationCity} has been saved as a draft. You can view and publish it anytime."
                      : "Your ride from ${draft.originCity} to ${draft.destinationCity} is now live! Passengers can start booking seats.",
                  subTextStyle: const TextStyle(
                    fontSize: 16,
                    color: Color(0xFF475569),
                    height: 1.5,
                  ),
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  centerLabel: true,
                  centerSubtitle: true,
                ),

                const SizedBox(height: 40),

                // 3. Share Your Trip Section
                // _buildShareSection(),
                const SizedBox(height: 16),

                // 4. Trip Recap Bar (Using Bloc Data)
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 20,
                    vertical: 16,
                  ),
                  decoration: BoxDecoration(
                    color: const Color(0xFFF8F9FB),
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Row(
                    children: [
                      const CircleAvatar(
                        backgroundColor: Colors.white,
                        child: Icon(
                          Icons.directions_car,
                          color: Color(0xFF0061FF),
                          size: 20,
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              "Departure Date",
                              style: TextStyle(
                                fontSize: 12,
                                color: Color(0xFF8F9BBA),
                              ),
                            ),
                            Text(
                              "${draft.departureDate}, ${draft.departureTime}",
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Color(0xFF1B2559),
                              ),
                            ),
                          ],
                        ),
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          const Text(
                            "Available Seats",
                            style: TextStyle(
                              fontSize: 12,
                              color: Color(0xFF8F9BBA),
                            ),
                          ),
                          Text(
                            "${draft.passengerSeats} Seats",
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Color(0xFF1B2559),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 40),
              ],
            ),
          ),
        );
      },
    );
  }

  // Widget _buildShareSection() {
  //   return Container(
  //     padding: const EdgeInsets.all(24),
  //     decoration: BoxDecoration(
  //       color: const Color(0xFFF4F7FE),
  //       borderRadius: BorderRadius.circular(24),
  //       border: Border.all(color: const Color(0xFFE0E5F2)),
  //     ),
  //     child: Column(
  //       children: [
  //         const Text(
  //           "SHARE YOUR TRIP",
  //           style: TextStyle(
  //             letterSpacing: 1.2,
  //             fontSize: 12,
  //             fontWeight: FontWeight.bold,
  //             color: Color(0xFF0061FF),
  //           ),
  //         ),
  //         const SizedBox(height: 24),
  //         Row(
  //           mainAxisAlignment: MainAxisAlignment.spaceEvenly,
  //           children: [
  //             _buildShareOption(
  //               "WhatsApp",
  //               Icons.chat,
  //               const Color(0xFF25D366),
  //             ),
  //             _buildShareOption(
  //               "Telegram",
  //               Icons.send,
  //               const Color(0xFF0088CC),
  //             ),
  //             _buildShareOption("More", Icons.share, const Color(0xFF2D3748)),
  //           ],
  //         ),
  //       ],
  //     ),
  //   );
  // }

  Widget _buildDecorativeDot(double size, Color color) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(color: color, shape: BoxShape.circle),
    );
  }

  Widget _buildShareOption(String label, IconData icon, Color color) {
    return Column(
      children: [
        CircleAvatar(
          radius: 28,
          backgroundColor: color,
          child: Icon(icon, color: Colors.white, size: 24),
        ),
        const SizedBox(height: 8),
        Text(
          label,
          style: const TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w500,
            color: Color(0xFF1B2559),
          ),
        ),
      ],
    );
  }
}
