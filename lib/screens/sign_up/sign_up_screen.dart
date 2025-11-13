import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart'; // <=== Tambahkan ini
import '../../components/socal_card.dart';
import '../../constants.dart';
import 'components/sign_up_form.dart';

class SignUpScreen extends StatelessWidget {
  static String routeName = "/sign_up";

  const SignUpScreen({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Sign Up"),
      ),
      body: SafeArea(
        child: SizedBox(
          width: double.infinity,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: SingleChildScrollView(
              child: Column(
                children: [
                  const SizedBox(height: 16),
                  const Text("Register Account", style: headingStyle),
                  const Text(
                    "Lengkapi detail Anda atau lanjutkan \nMasuk dengan Google",
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 16),
                  const SignUpForm(),
                  const SizedBox(height: 16),
                   // 🔹 Divider “atau”
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Row(
                      children: const [
                        Expanded(child: Divider(thickness: 1)),
                        Padding(
                          padding: EdgeInsets.symmetric(horizontal: 8),
                          child: Text("atau"),
                        ),
                        Expanded(child: Divider(thickness: 1)),
                      ],
                    ),
                  ),
                                  const SizedBox(height: 16),

                  // 🔹 Tombol Google
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: SizedBox(
                      width: double.infinity,
                      height: 48,
                      child: OutlinedButton.icon(
                         icon: SvgPicture.asset(
                          'assets/icons/google-icon.svg', // ambil dari folder icons
                          height: 24,
                          width: 24,
                        ),
                        label: const Text(
                          "Masuk dengan Google",
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: 16,
                          ),
                        ),
                        style: OutlinedButton.styleFrom(
                          backgroundColor: Colors.white,
                          side: const BorderSide(color: Colors.grey),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        onPressed: () {
                          // TODO: Tambahkan fungsi Google Sign-In
                        },
                      ),
                    ),
                  ),
                  // 👇 Tambahkan teks ini di bawah tombol Google
Padding(
  padding: const EdgeInsets.all(8.0),
  child: Text(
    'Dengan masuk, Anda mengonfirmasi bahwa Anda\n'
    'menerima Syarat dan Ketentuan kami',
    textAlign: TextAlign.center,
    style: Theme.of(context).textTheme.bodySmall,
  ),
),

const SizedBox(height: 20),

                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
