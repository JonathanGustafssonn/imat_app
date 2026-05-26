import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:imat_app/model/imat/customer.dart';
import 'package:imat_app/model/imat_data_handler.dart';

class LoginPopup extends StatefulWidget {
  const LoginPopup({super.key});

  @override
  State<LoginPopup> createState() => _LoginPopupState();
}

class _LoginPopupState extends State<LoginPopup> {
  int view = 0;

  final email = TextEditingController();
  final pass = TextEditingController();

  final rFirst = TextEditingController();
  final rLast = TextEditingController();
  final rEmail = TextEditingController();
  final rPass = TextEditingController();
  final rConf = TextEditingController();

  String? loginError;
  String? regError;

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
              padding: const EdgeInsets.all(28),
              decoration: BoxDecoration(
                color: const Color(0xFFF8F8F8),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  _tabs(),
                  const SizedBox(height: 28),
                  if (view == 0) _loginView(),
                  if (view == 1) _registerView(),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _tabs() {
    return Row(
      children: [
        _tabButton("Logga in", 0),
        _tabButton("Skapa konto", 1),
        const Spacer(),
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text("Stäng"),
        ),
      ],
    );
  }

  Widget _tabButton(String text, int index) {
    final selected = view == index;

    return InkWell(
      onTap: () => setState(() => view = index),
      child: Padding(
        padding: const EdgeInsets.only(right: 20),
        child: Column(
          children: [
            Text(
              text,
              style: TextStyle(
                fontSize: 18,
                fontWeight: selected ? FontWeight.bold : FontWeight.normal,
              ),
            ),
            Container(
              height: 3,
              width: 80,
              color: selected ? Colors.green : Colors.grey.shade300,
            ),
          ],
        ),
      ),
    );
  }

  Widget _loginView() {
    return Column(
      children: [
        _field(email, "E-post"),
        _field(pass, "Lösenord", obscure: true),

        if (loginError != null)
          Text(loginError!, style: const TextStyle(color: Colors.red)),

        const SizedBox(height: 20),

        SizedBox(
          width: double.infinity,
          height: 52,
          child: ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.green,
            ),
            onPressed: _login,
            child: const Text("Logga in", style: TextStyle(color: Colors.white)),
          ),
        ),
      ],
    );
  }

  Future<void> _login() async {
    final iMat = context.read<ImatDataHandler>();
    final extras = iMat.getExtras();

    final savedEmail = extras["loginEmail"];
    final savedPass = extras["loginPassword"];

    if (savedEmail == email.text.trim() &&
        savedPass == pass.text.trim()) {
      iMat.addExtra("isLoggedIn", true);
      Navigator.pop(context, true);
    } else {
      setState(() => loginError = "Fel e-post eller lösenord");
    }
  }

  Widget _registerView() {
    return Column(
      children: [
        _field(rFirst, "Förnamn"),
        _field(rLast, "Efternamn"),
        _field(rEmail, "E-post"),
        _field(rPass, "Lösenord", obscure: true),
        _field(rConf, "Bekräfta lösenord", obscure: true),

        if (regError != null)
          Text(regError!, style: const TextStyle(color: Colors.red)),

        const SizedBox(height: 20),

        SizedBox(
          width: double.infinity,
          height: 52,
          child: ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.green,
            ),
            onPressed: _register,
            child: const Text("Skapa konto", style: TextStyle(color: Colors.white)),
          ),
        ),
      ],
    );
  }

  Future<void> _register() async {
    if (rPass.text != rConf.text) {
      setState(() => regError = "Lösenorden matchar inte");
      return;
    }

    final iMat = context.read<ImatDataHandler>();

    final customer = Customer(
      rFirst.text,
      rLast.text,
      "",
      "",
      rEmail.text,
      "",
      "",
      "",
    );
    iMat.setCustomer(customer);

    iMat.addExtra("loginEmail", rEmail.text.trim());
    iMat.addExtra("loginPassword", rPass.text.trim());
    iMat.addExtra("isLoggedIn", true);

    Navigator.pop(context, true);
  }

  Widget _field(TextEditingController c, String hint, {bool obscure = false}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 18),
      child: TextField(
        controller: c,
        obscureText: obscure,
        decoration: InputDecoration(
          hintText: hint,
          filled: true,
          fillColor: Colors.white,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
      ),
    );
  }
}