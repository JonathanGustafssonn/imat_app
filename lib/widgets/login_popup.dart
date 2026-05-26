import 'package:flutter/material.dart';
import 'package:imat_app/model/imat/customer.dart';
import 'package:imat_app/widgets/user_manager.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LoginPopup extends StatefulWidget {
  const LoginPopup({super.key});

  @override
  State<LoginPopup> createState() => _LoginPopupState();
}

class _LoginPopupState extends State<LoginPopup> {
  int view = 0;

  bool keep = false;
  bool showPass = false;
  bool showRegPass = false;
  bool showRegConf = false;

  final email = TextEditingController();
  final pass = TextEditingController();

  final rFirst = TextEditingController();
  final rLast = TextEditingController();
  final rEmail = TextEditingController();
  final rPass = TextEditingController();
  final rConf = TextEditingController();

  String? loginError;
  String? regPassError;
  String? regConfError;

  @override
  void initState() {
    super.initState();
    SharedPreferences.getInstance().then((p) {
      setState(() => keep = p.getBool("keepLogged_in") ?? false);
    });
  }

  Future<void> _saveKeep(bool v) async {
    final p = await SharedPreferences.getInstance();
    p.setBool("keepLogged_in", v);
  }

  bool validEmail(String v) => v.contains("@");

  bool validPass(String v) =>
      v.length >= 8 &&
      RegExp(r'[A-Z]').hasMatch(v) &&
      RegExp(r'[a-z]').hasMatch(v) &&
      RegExp(r'[0-9]').hasMatch(v) &&
      RegExp(r'[!@#\$%^&*(),.?":{}|<>]').hasMatch(v);

  void _success() => Navigator.pop(context, true);

  InputDecoration inputStyle(String hint) {
    return InputDecoration(
      hintText: hint,
      filled: true,
      fillColor: Colors.white,
      contentPadding: const EdgeInsets.symmetric(
        horizontal: 16,
        vertical: 16,
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide(color: Colors.grey.shade300),
      ),
      focusedBorder: const OutlineInputBorder(
        borderSide: BorderSide(color: Color(0xFF8BC34A), width: 2),
      ),
    );
  }

  Widget field(
    TextEditingController c,
    String hint, {
    bool obscure = false,
    Widget? suffix,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 22),
      child: TextField(
        controller: c,
        obscureText: obscure,
        onChanged: (_) {
          setState(() {
            loginError = null;
            regPassError = null;
            regConfError = null;
          });
        },
        decoration: inputStyle(hint).copyWith(
          suffixIcon: suffix,
        ),
      ),
    );
  }

  Widget tabButton(String text, int index) {
    final selected = view == index;

    return Expanded(
      child: InkWell(
        onTap: () => setState(() => view = index),
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.only(bottom: 10),
              child: Text(
                text,
                style: TextStyle(
                  fontSize: 17,
                  fontWeight: selected ? FontWeight.w500 : FontWeight.w400,
                  color: Colors.black87,
                ),
              ),
            ),
            Container(
              height: 3,
              color: selected
                  ? const Color(0xFF8BC34A)
                  : Colors.grey.shade300,
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => Navigator.pop(context),
      child: Scaffold(
        backgroundColor: Colors.black45,
        body: Center(
          child: GestureDetector(
            onTap: () {},
            child: Container(
              width: 560,
              padding: const EdgeInsets.symmetric(
                horizontal: 28,
                vertical: 24,
              ),
              decoration: BoxDecoration(
                color: const Color(0xFFF8F8F8),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  /// TOP BAR
                  Row(
                    children: [
                      Expanded(
                        child: Row(
                          children: [
                            tabButton("Logga in", 0),
                            tabButton("Skapa konto", 1),
                          ],
                        ),
                      ),
                      TextButton(
                        onPressed: () => Navigator.pop(context),
                        child: const Text("Stäng"),
                      ),
                    ],
                  ),

                  const SizedBox(height: 28),

                  if (view == 0) _login(),
                  if (view == 1) _register(),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _login() {
    return Column(
      children: [
        const Icon(Icons.person_outline, size: 120),

        const SizedBox(height: 28),

        Align(
          alignment: Alignment.centerLeft,
          child: Text("E-post",
              style: TextStyle(fontSize: 18, color: Colors.grey.shade800)),
        ),
        const SizedBox(height: 8),
        field(email, ""),

        Align(
          alignment: Alignment.centerLeft,
          child: Text("Lösenord",
              style: TextStyle(fontSize: 18, color: Colors.grey.shade800)),
        ),
        const SizedBox(height: 8),

        field(
          pass,
          "",
          obscure: !showPass,
          suffix: IconButton(
            icon: Icon(
              showPass ? Icons.visibility_off : Icons.visibility,
            ),
            onPressed: () => setState(() => showPass = !showPass),
          ),
        ),

        if (loginError != null)
          Align(
            alignment: Alignment.centerLeft,
            child: Text(
              loginError!,
              style: const TextStyle(color: Colors.red),
            ),
          ),

        Row(
          children: [
            Checkbox(
              value: keep,
              activeColor: const Color(0xFF8BC34A),
              onChanged: (v) {
                setState(() => keep = v!);
                _saveKeep(v!);
              },
            ),
            Text("Håll mig inloggad",
                style: TextStyle(color: Colors.grey.shade600)),
            const Spacer(),
            TextButton(
              onPressed: () {},
              child: const Text("Återställ lösenord"),
            ),
          ],
        ),

        const SizedBox(height: 18),

        SizedBox(
          width: double.infinity,
          height: 52,
          child: ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF8BC34A),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
            ),
            onPressed: () async {
              final ok = await UserManager.login(
                email.text.trim(),
                pass.text.trim(),
              );

              if (!ok) {
                setState(() {
                  loginError = "Fel e-post eller lösenord";
                });
                return;
              }

              final prefs = await SharedPreferences.getInstance();
              await prefs.setBool("keepLogged_in", keep);

              _success();
            },
            child: const Text(
              "Logga in",
              style: TextStyle(fontSize: 18, color: Colors.white),
            ),
          ),
        ),
      ],
    );
  }

  Widget _register() {
    return Column(
      children: [
        const Icon(Icons.person_add_alt_1_outlined, size: 120),

        const SizedBox(height: 28),

        field(rFirst, "Förnamn"),
        field(rLast, "Efternamn"),
        field(rEmail, "E-post"),

        field(
          rPass,
          "Lösenord",
          obscure: !showRegPass,
          suffix: IconButton(
            icon: Icon(
              showRegPass ? Icons.visibility_off : Icons.visibility,
            ),
            onPressed: () => setState(() => showRegPass = !showRegPass),
          ),
        ),

        if (regPassError != null)
          Align(
            alignment: Alignment.centerLeft,
            child: Text(regPassError!,
                style: const TextStyle(color: Colors.red)),
          ),

        field(
          rConf,
          "Bekräfta lösenord",
          obscure: !showRegConf,
          suffix: IconButton(
            icon: Icon(
              showRegConf ? Icons.visibility_off : Icons.visibility,
            ),
            onPressed: () => setState(() => showRegConf = !showRegConf),
          ),
        ),

        if (regConfError != null)
          Align(
            alignment: Alignment.centerLeft,
            child: Text(regConfError!,
                style: const TextStyle(color: Colors.red)),
          ),

        const SizedBox(height: 12),

        SizedBox(
          width: double.infinity,
          height: 52,
          child: ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF8BC34A),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
            ),
            onPressed: () async {
              if (!validPass(rPass.text)) {
                setState(() {
                  regPassError =
                      "Minst 8 tecken, stor/liten bokstav, siffra och specialtecken";
                });
                return;
              }

              if (rPass.text != rConf.text) {
                setState(() {
                  regConfError = "Lösenorden matchar inte";
                });
                return;
              }

              final customer = Customer(
                rFirst.text.trim(),
                rLast.text.trim(),
                "",
                "",
                rEmail.text.trim(),
                "",
                "",
                "",
              );

              final ok = await UserManager.registerWithCustomer(
                rEmail.text.trim(),
                rPass.text.trim(),
                customer,
              );

              if (ok) {
                await UserManager.login(
                  rEmail.text.trim(),
                  rPass.text.trim(),
                );

                _success();
              }
            },
            child: const Text(
              "Skapa konto",
              style: TextStyle(fontSize: 18, color: Colors.white),
            ),
          ),
        ),
      ],
    );
  }
}