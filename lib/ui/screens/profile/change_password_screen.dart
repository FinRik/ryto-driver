import 'package:flutter/material.dart';

import '../../widgets/buttons/back_arrow_header.dart';
import '../../widgets/buttons/button.dart';
import '../../widgets/layouts/base_scaffold_widget.dart';

class ChangePasswordScreen extends StatefulWidget {
  const ChangePasswordScreen({super.key});

  @override
  State<ChangePasswordScreen> createState() => _ChangePasswordScreenState();
}

class _ChangePasswordScreenState extends State<ChangePasswordScreen> {
  bool _obscureOld = true;
  bool _obscureNew = true;

  @override
  Widget build(BuildContext context) {
    return BaseScaffoldWidget(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          BackArrowHeader(
            title: "Change Password",
            subText: "Create a strong password to protect your account.",
          ),
          const SizedBox(height: 32),
          Expanded(
            child: ListView(
              children: [
                _buildTextField(
                  "Current Password",
                  obscureText: _obscureOld,
                  onToggle: () => setState(() => _obscureOld = !_obscureOld),
                ),
                const SizedBox(height: 20),
                _buildTextField(
                  "New Password",
                  obscureText: _obscureNew,
                  onToggle: () => setState(() => _obscureNew = !_obscureNew),
                ),
                const SizedBox(height: 20),
                _buildTextField(
                  "Confirm New Password",
                  obscureText: _obscureNew,
                  showToggle: false,
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(bottom: 24.0),
            child: Button(height: 56, text: "Update Password", onTap: () {}),
          ),
        ],
      ),
    );
  }

  Widget _buildTextField(
    String label, {
    required bool obscureText,
    bool showToggle = true,
    VoidCallback? onToggle,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            color: Color(0xFF1B2559),
          ),
        ),
        const SizedBox(height: 8),
        TextField(
          obscureText: obscureText,
          decoration: InputDecoration(
            filled: true,
            fillColor: const Color(0xFFF8F9FB),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide.none,
            ),
            suffixIcon: showToggle
                ? IconButton(
                    icon: Icon(
                      obscureText ? Icons.visibility_off : Icons.visibility,
                      color: Colors.grey,
                    ),
                    onPressed: onToggle,
                  )
                : null,
          ),
        ),
      ],
    );
  }
}
