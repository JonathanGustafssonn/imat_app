import 'package:flutter/material.dart';
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
        borderSide: BorderSide(
          color: Colors.grey.shade300,
        ),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(
          color: Color(0xFF8BC34A),
          width: 2,
        ),
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
                  fontWeight:
                      selected ? FontWeight.w500 : FontWeight.w400,
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

                      MouseRegion(
                        cursor: SystemMouseCursors.click,
                        child: TextButton(
                          style: TextButton.styleFrom(
                            foregroundColor: Colors.grey.shade700,
                            padding: const EdgeInsets.symmetric(
                              horizontal: 14,
                              vertical: 10,
                            ),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ).copyWith(
                            overlayColor: WidgetStateProperty.all(
                            Colors.grey.withOpacity(0.1),
                          ),
                        ),
                        onPressed: () => Navigator.pop(context),
                        child: const Text(
                          "Stäng",
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
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
        const Icon(
          Icons.person_outline,
          size: 120,
          color: Colors.black87,
        ),

        const SizedBox(height: 28),

        Align(
          alignment: Alignment.centerLeft,
          child: Text(
            "E-post",
            style: TextStyle(
              fontSize: 18,
              color: Colors.grey.shade800,
            ),
          ),
        ),

        const SizedBox(height: 8),

        field(email, ""),

        Align(
          alignment: Alignment.centerLeft,
          child: Text(
            "lösenord",
            style: TextStyle(
              fontSize: 18,
              color: Colors.grey.shade800,
            ),
          ),
        ),

        const SizedBox(height: 8),

        field(
          pass,
          "",
          obscure: !showPass,
          suffix: IconButton(
            icon: Icon(
              showPass
                  ? Icons.visibility_off
                  : Icons.visibility,
            ),
            onPressed: () {
              setState(() => showPass = !showPass);
            },
          ),
        ),

        Row(
          children: [
            Checkbox(
              value: keep,
              activeColor: const Color(0xFF8BC34A),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(4),
              ),
              onChanged: (v) {
                setState(() => keep = v!);
                _saveKeep(v!);
              },
            ),

            Text(
              "Håll mig inloggad",
              style: TextStyle(
                color: Colors.grey.shade600,
                fontSize: 16,
              ),
            ),

            const Spacer(),

            TextButton(
              onPressed: () {},
              child: const Text(
                "Återställ Lösenord",
                style: TextStyle(
                  color: Colors.blue,
                ),
              ),
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

              if (ok) {
                final prefs =
                    await SharedPreferences.getInstance();

                await prefs.setBool(
                  "keepLogged_in",
                  keep,
                );

                _success();
              }
            },
            child: const Text(
              "Logga in",
              style: TextStyle(
                fontSize: 18,
                color: Colors.white,
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _register() {
    return Column(
      children: [
        const Icon(
          Icons.person_add_alt_1_outlined,
          size: 120,
          color: Colors.black87,
        ),

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
              showRegPass
                  ? Icons.visibility_off
                  : Icons.visibility,
            ),
            onPressed: () {
              setState(() => showRegPass = !showRegPass);
            },
          ),
        ),

        field(
          rConf,
          "Bekräfta lösenord",
          obscure: !showRegConf,
          suffix: IconButton(
            icon: Icon(
              showRegConf
                  ? Icons.visibility_off
                  : Icons.visibility,
            ),
            onPressed: () {
              setState(() => showRegConf = !showRegConf);
            },
          ),
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
              if (validEmail(rEmail.text) &&
                  validPass(rPass.text) &&
                  rPass.text == rConf.text) {
                final ok = await UserManager.register(
                  rEmail.text.trim(),
                  rPass.text.trim(),
                );

                if (ok) {
                  await UserManager.login(
                    rEmail.text.trim(),
                    rPass.text.trim(),
                  );

                  _success();
                }
              }
            },
            child: const Text(
              "Skapa konto",
              style: TextStyle(
                fontSize: 18,
                color: Colors.white,
              ),
            ),
          ),
        ),
      ],
    );
  }
}