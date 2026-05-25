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

  InputDecoration dec(String label, [Widget? suffix]) =>
      InputDecoration(labelText: label, border: const OutlineInputBorder(), suffixIcon: suffix);

  Widget field(TextEditingController c, String label,
          {bool obscure = false, Widget? suffix}) =>
      Padding(
        padding: const EdgeInsets.only(bottom: 12),
        child: TextField(
          controller: c,
          obscureText: obscure,
          decoration: dec(label, suffix),
        ),
      );

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => Navigator.pop(context),
      child: Scaffold(
        backgroundColor: Colors.black54,
        body: Center(
          child: Container(
            width: 420,
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Align(
                  alignment: Alignment.topRight,
                  child: TextButton(
                    onPressed: () => Navigator.pop(context),
                    child: const Text("Stäng"),
                  ),
                ),

                if (view != 2)
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      TextButton(
                          onPressed: () => setState(() => view = 0),
                          child: const Text("Logga in")),
                      TextButton(
                          onPressed: () => setState(() => view = 1),
                          child: const Text("Skapa konto")),
                    ],
                  ),

                const SizedBox(height: 10),

                if (view == 0) _login(),
                if (view == 1) _register(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _login() => Column(
        children: [
          const Icon(Icons.person, size: 70),

          field(email, "E-post"),

          field(
            pass,
            "Lösenord",
            obscure: !showPass,
            suffix: IconButton(
              icon: Icon(showPass ? Icons.visibility_off : Icons.visibility),
              onPressed: () => setState(() => showPass = !showPass),
            ),
          ),

          Row(
            children: [
              Checkbox(
                value: keep,
                onChanged: (v) {
                  setState(() => keep = v!);
                  _saveKeep(v!);
                },
              ),
              const Text("Håll mig inloggad"),
            ],
          ),

          ElevatedButton(
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
            child: const Text("Logga in"),
          ),
        ],
      );

  Widget _register() => Column(
        children: [
          const Icon(Icons.person_add, size: 70),

          field(rFirst, "Förnamn"),
          field(rLast, "Efternamn"),

          field(rEmail, "E-post"),

          field(
            rPass,
            "Lösenord",
            obscure: !showRegPass,
            suffix: IconButton(
              icon: Icon(showRegPass ? Icons.visibility_off : Icons.visibility),
              onPressed: () => setState(() => showRegPass = !showRegPass),
            ),
          ),

          field(
            rConf,
            "Bekräfta",
            obscure: !showRegConf,
            suffix: IconButton(
              icon: Icon(showRegConf ? Icons.visibility_off : Icons.visibility),
              onPressed: () => setState(() => showRegConf = !showRegConf),
            ),
          ),

          ElevatedButton(
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
            child: const Text("Skapa konto"),
          ),
        ],
      );
}