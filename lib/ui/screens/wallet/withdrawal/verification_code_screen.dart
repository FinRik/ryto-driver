import 'package:flutter/material.dart';

class VerificationCodeScreen extends StatefulWidget {
  const VerificationCodeScreen({super.key});

  @override
  State<VerificationCodeScreen> createState() => _VerificationCodeScreenState();
}

class _VerificationCodeScreenState extends State<VerificationCodeScreen> {
  String otpCode = "";
  final int codeLength = 4;

  void _onKeyTap(String value) {
    if (otpCode.length < codeLength) {
      setState(() => otpCode += value);
    }
  }

  void _onBackspace() {
    if (otpCode.isNotEmpty) {
      setState(() => otpCode = otpCode.substring(0, otpCode.length - 1));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        leading: const BackButton(color: Color(0xFF1B2559)),
        backgroundColor: Colors.white,
        elevation: 0,
      ),
      body: Column(
        children: [
          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24.0),
              child: Column(
                children: [
                  const SizedBox(height: 20),
                  // 1. Header & Icon
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: const Color(0xFFF4F7FE),
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(Icons.safety_check, color: Color(0xFF0061FF), size: 32),
                  ),
                  const SizedBox(height: 24),
                  const Text(
                    "Verification Code",
                    style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold, color: Color(0xFF1B2559)),
                  ),
                  const SizedBox(height: 12),
                  const Text(
                    "We've sent a 4-digit verification code to\n+1 ••• ••• 4291",
                    textAlign: TextAlign.center,
                    style: TextStyle(color: Color(0xFF8F9BBA), fontSize: 16),
                  ),
                  const SizedBox(height: 40),

                  // 2. OTP Code Display
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: List.generate(codeLength, (index) => _buildCodeBox(index)),
                  ),
                  const SizedBox(height: 32),

                  // Resend Timer
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: const [
                      Text("Resend code  ", style: TextStyle(color: Color(0xFF8F9BBA))),
                      Text("59s", style: TextStyle(color: Color(0xFF0061FF), fontWeight: FontWeight.bold)),
                    ],
                  ),
                ],
              ),
            ),
          ),

          // 3. Custom Keypad
          _buildCustomKeypad(),

          // 4. Action Button
          Padding(
            padding: const EdgeInsets.all(24.0),
            child: SizedBox(
              width: double.infinity,
              height: 56,
              child: ElevatedButton(
                onPressed: otpCode.length == codeLength ? () {} : null,
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF0061FF),
                  disabledBackgroundColor: const Color(0xFFE0E5F2),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                ),
                child: const Text("Continue", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCodeBox(int index) {
    bool isFilled = otpCode.length > index;
    return Container(
      width: 70,
      height: 80,
      decoration: BoxDecoration(
        color: const Color(0xFFF4F7FE),
        borderRadius: BorderRadius.circular(12),
        border: isFilled ? Border.all(color: const Color(0xFF0061FF), width: 2) : null,
      ),
      alignment: Alignment.center,
      child: Text(
        isFilled ? otpCode[index] : "",
        style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Color(0xFF1B2559)),
      ),
    );
  }

  Widget _buildCustomKeypad() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 40),
      child: Column(
        children: [
          _buildKeypadRow(["1", "2", "3"]),
          _buildKeypadRow(["4", "5", "6"]),
          _buildKeypadRow(["7", "8", "9"]),
          _buildKeypadRow([Icons.fingerprint, "0", Icons.backspace_outlined]),
        ],
      ),
    );
  }

  Widget _buildKeypadRow(List<dynamic> keys) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: keys.map((key) {
          if (key is String) {
            return _buildKey(key, onTap: () => _onKeyTap(key));
          } else {
            return _buildKeyIcon(key as IconData,
                onTap: key == Icons.backspace_outlined ? _onBackspace : () {});
          }
        }).toList(),
      ),
    );
  }

  Widget _buildKey(String label, {required VoidCallback onTap}) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(40),
      child: SizedBox(
        width: 60,
        height: 60,
        child: Center(
          child: Text(
            label,
            style: const TextStyle(fontSize: 26, fontWeight: FontWeight.bold, color: Color(0xFF1B2559)),
          ),
        ),
      ),
    );
  }

  Widget _buildKeyIcon(IconData icon, {required VoidCallback onTap}) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(40),
      child: SizedBox(
        width: 60,
        height: 60,
        child: Icon(icon, color: const Color(0xFF1B2559), size: 28),
      ),
    );
  }
}