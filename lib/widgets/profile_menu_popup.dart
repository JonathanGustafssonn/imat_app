import 'package:flutter/material.dart';
import 'package:imat_app/model/imat/user.dart';
import 'package:imat_app/widgets/user_manager.dart';
import 'package:shared_preferences/shared_preferences.dart';
class ProfileMenuPopup extends StatefulWidget {
  const ProfileMenuPopup({super.key});

  @override
  State<ProfileMenuPopup> createState() => _ProfileMenuPopupState();
}

class _ProfileMenuPopupState extends State<ProfileMenuPopup> {
  int view = 0;
  bool hoverSettings = false;
  bool hoverReceipts = false;

  User? currentUser;

  @override
  void initState() {
    super.initState();
    _loadUser();
  }

  Future<void> _loadUser() async {
    currentUser = await UserManager.loadLoggedInUser();
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => Navigator.pop(context),
      child: Scaffold(
        backgroundColor: Colors.black.withOpacity(0.55),

        body: Center(
          child: GestureDetector(
            onTap: () {},
            child: Container(
              width: 520,
              height: 600,
              padding: const EdgeInsets.all(30),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(18),
              ),

              child: Column(
                children: [

                  Align(
                    alignment: Alignment.topRight,
                    child: GestureDetector(
                      onTap: () => Navigator.pop(context),
                      child: const Text(
                        "Stäng",
                        style: TextStyle(
                          fontSize: 18,
                          color: Colors.black,
                          decoration: TextDecoration.underline,
                        ),
                      ),
                    ),
                  ),

                  const SizedBox(height: 10),

                  Text(
                    _getTitle(),
                    style: const TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                    ),
                  ),

                  const SizedBox(height: 25),

                  Expanded(
                    child: _buildContent(),
                  ),

                  const SizedBox(height: 25),

                  if (view == 0)
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: _confirmLogout,
                        style: ElevatedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          backgroundColor: Colors.red,
                        ),
                        child: const Text(
                          "Logga ut",
                          style: TextStyle(color: Colors.white, fontSize: 18),
                        ),
                      ),
                    ),

                  if (view != 0)
                    TextButton(
                      onPressed: () => setState(() => view = 0),
                      child: const Text("Tillbaka"),
                    ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  String _getTitle() {
    switch (view) {
      case 1:
        return "Inställningar";
      case 2:
        return "Kvitton";
      default:
        if (currentUser == null) return "Konto";
        final name = currentUser!.userName.split("@").first;
        return "Hej, ${name[0].toUpperCase()}${name.substring(1)}!";
    }
  }

  Widget _buildContent() {
    switch (view) {
      case 1:
        return _settingsView();
      case 2:
        return _receiptsView();
      default:
        return _mainMenu();
    }
  }

  Widget _mainMenu() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        _menuButton(
          label: "Inställningar",
          icon: Icons.settings,
          hover: hoverSettings,
          onHover: (v) => setState(() => hoverSettings = v),
          onTap: () => setState(() => view = 1),
        ),

        const SizedBox(height: 30),

        _menuButton(
          label: "Kvitton",
          icon: Icons.receipt_long,
          hover: hoverReceipts,
          onHover: (v) => setState(() => hoverReceipts = v),
          onTap: () => setState(() => view = 2),
        ),
      ],
    );
  }

  Widget _menuButton({
    required String label,
    required IconData icon,
    required bool hover,
    required Function(bool) onHover,
    required VoidCallback onTap,
  }) {
    return MouseRegion(
      onEnter: (_) => onHover(true),
      onExit: (_) => onHover(false),
      child: GestureDetector(
        onTap: onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 150),
          width: 300,
          padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 20),
          decoration: BoxDecoration(
            color: hover
                ? const Color.fromARGB(255, 180, 230, 110)
                : const Color.fromARGB(255, 197, 243, 129),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(icon, size: 26, color: Colors.black),
              const SizedBox(width: 12),
              Text(
                label,
                style: const TextStyle(fontSize: 20, color: Colors.black),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _settingsView() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: const [
        Icon(Icons.settings, size: 80),
        SizedBox(height: 20),
        Text("Dina inställningar", style: TextStyle(fontSize: 20)),
        SizedBox(height: 10),
        Text("Här kommer dina inställningar visas.",
            textAlign: TextAlign.center),
      ],
    );
  }

  Widget _receiptsView() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: const [
        Icon(Icons.receipt_long, size: 80),
        SizedBox(height: 20),
        Text("Dina kvitton", style: TextStyle(fontSize: 20)),
        SizedBox(height: 10),
        Text("Här kommer dina kvitton visas.",
            textAlign: TextAlign.center),
      ],
    );
  }

  void _confirmLogout() {
    showDialog(
      context: context,
      barrierDismissible: true,
      barrierColor: Colors.black.withOpacity(0.5),
      builder: (_) {
        return AlertDialog(
          title: const Text("Logga ut"),
          content: const Text("Är du säker på att du vill logga ut?"),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text("Avbryt"),
            ),
            TextButton(
              onPressed: () async {
                await UserManager.logout();

                if (!context.mounted) return;

                Navigator.of(context).pop();
                Navigator.of(context).pop(true);
              },
              child: const Text("Ja", style: TextStyle(color: Colors.red)),
            ),
          ],
        );
      },
    );
  }
}
