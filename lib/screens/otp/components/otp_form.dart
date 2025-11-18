import 'package:flutter/material.dart';
import '../../../services/otp_service.dart';
import '../../sign_in/sign_in_screen.dart'; // <-- ROUTE SIGN IN

class OtpForm extends StatefulWidget {
  const OtpForm({super.key});

  @override
  _OtpFormState createState() => _OtpFormState();
}

class _OtpFormState extends State<OtpForm> {
  List<TextEditingController> controllers =
      List.generate(6, (i) => TextEditingController());

  @override
  Widget build(BuildContext context) {
    return Form(
      child: Column(
        children: [
          // ============================
          // 6 Kotak OTP
          // ============================
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: List.generate(6, (index) {
              return SizedBox(
                width: 50,
                child: TextField(
                  controller: controllers[index],
                  textAlign: TextAlign.center,
                  maxLength: 1,
                  keyboardType: TextInputType.number,

                  // 🔥 FIX AGAR ANGKA TERLIHAT
                  style: const TextStyle(
                    color: Colors.black,
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),

                  decoration: InputDecoration(
                    counterText: "",
                    contentPadding: const EdgeInsets.all(0),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide:
                          const BorderSide(color: Colors.grey, width: 1),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide:
                          const BorderSide(color: Colors.blue, width: 2),
                    ),
                  ),

                  // Auto-move cursor
                  onChanged: (value) {
                    if (value.length == 1 && index < 5) {
                      FocusScope.of(context).nextFocus();
                    }
                    if (value.isEmpty && index > 0) {
                      FocusScope.of(context).previousFocus();
                    }
                  },
                ),
              );
            }),
          ),

          const SizedBox(height: 20),

          // ============================
          // Tombol Verify OTP
          // ============================
          ElevatedButton(
            child: const Text("Verify OTP"),
            onPressed: () async {
              String fullOtp = controllers.map((c) => c.text).join("");

              bool success = await OtpService.verifyOtp(fullOtp);

              if (success) {
                if (context.mounted) {
                  Navigator.pushNamedAndRemoveUntil(
                    context,
                    SignInScreen.routeName,  // 🔥 Tetap menuju halaman Login
                    (_) => false,
                  );
                }
              } else {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text("OTP salah atau kadaluarsa"),
                    backgroundColor: Colors.red,
                  ),
                );
              }
            },
          ),
        ],
      ),
    );
  }
}
