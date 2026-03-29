import 'package:flutter/material.dart';
import 'package:intl_phone_number_field/intl_phone_number_field.dart';

class CountryPhoneInputField extends StatefulWidget {
  const CountryPhoneInputField({super.key, required this.onChanged});

  final void Function(String number) onChanged;

  @override
  State<CountryPhoneInputField> createState() => _CountryPhoneInputFieldState();
}

class _CountryPhoneInputFieldState extends State<CountryPhoneInputField> {
  final TextEditingController controller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "Phone Number",
          style: TextStyle(fontWeight: FontWeight.w500, fontSize: 14),
        ),
        SizedBox(height: 8),
        InternationalPhoneNumberInput(
          height: 60,
          controller: controller,
          inputFormatters: const [],
          formatter: MaskedInputFormatter('### ### ####'),
          initCountry: CountryCodeModel(
            name: "Nigeria",
            dial_code: "+234",
            code: "NG",
          ),
          betweenPadding: 6,
          onInputChanged: (phone) => setState(
            () => widget.onChanged("${phone.dial_code}${phone.rawNumber}"),
          ),
          // loadFromJson: loadFromJson,
          dialogConfig: DialogConfig(
            backgroundColor: const Color(0xFF444448),
            searchBoxBackgroundColor: const Color(0xFF56565a),
            searchBoxIconColor: const Color(0xFFFAFAFA),
            countryItemHeight: 55,
            topBarColor: const Color(0xFF1B1C24),
            selectedItemColor: const Color(0xFF56565a),
            selectedIcon: Padding(
              padding: const EdgeInsets.only(left: 10),
              child: Image.asset(
                "assets/check.png",
                width: 20,
                fit: BoxFit.fitWidth,
              ),
            ),
            textStyle: TextStyle(
              color: const Color(0xFFFAFAFA).withOpacity(0.7),
              fontSize: 14,
              fontWeight: FontWeight.w600,
            ),
            searchBoxTextStyle: TextStyle(
              color: const Color(0xFFFAFAFA).withOpacity(0.7),
              fontSize: 14,
              fontWeight: FontWeight.w600,
            ),
            titleStyle: const TextStyle(
              color: Color(0xFFFAFAFA),
              fontSize: 18,
              fontWeight: FontWeight.w700,
            ),
            searchBoxHintStyle: TextStyle(
              color: const Color(0xFFFAFAFA).withOpacity(0.7),
              fontSize: 14,
              fontWeight: FontWeight.w600,
            ),
          ),
          countryConfig: CountryConfig(
            decoration: BoxDecoration(
              border: Border.all(width: 2, color: const Color(0xFFE5E5E6)),
              borderRadius: BorderRadius.circular(100),
            ),
            noFlag: false,
            textStyle: const TextStyle(
              color: Color(0xffAAAAAD),
              fontSize: 16,
              fontWeight: FontWeight.w400,
            ),
            flagSize: 24,
            flatFlag: false,
          ),
          validator: (number) {
            if (number.number.isEmpty) {
              return "The phone number cannot be left emptyssss";
            }
            return null;
          },
          phoneConfig: PhoneConfig(
            focusedColor: const Color(0xFF6D59BD),
            enabledColor: const Color(0xFF6D59BD),
            errorColor: const Color(0xFFFF5494),
            labelStyle: null,
            labelText: null,
            floatingLabelStyle: null,
            focusNode: null,
            radius: 100,
            hintText: "0000 000 000",
            borderWidth: 2,
            backgroundColor: Colors.transparent,
            decoration: null,
            popUpErrorText: true,
            autoFocus: false,
            showCursor: false,
            textInputAction: TextInputAction.done,
            autovalidateMode: AutovalidateMode.onUserInteraction,
            errorTextMaxLength: 2,
            errorPadding: const EdgeInsets.only(top: 14),
            errorStyle: const TextStyle(
              color: Color(0xFFFF5494),
              fontSize: 12,
              height: 1,
            ),
            textStyle: const TextStyle(
              color: Colors.black,
              fontSize: 16,
              fontWeight: FontWeight.w400,
            ),
            hintStyle: TextStyle(
              color: Color(0xffAAAAAD),
              fontSize: 16,
              fontWeight: FontWeight.w400,
            ),
          ),
        ),
      ],
    );
  }
}
