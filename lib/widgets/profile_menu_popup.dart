import 'package:flutter/material.dart';
import 'package:imat_app/model/imat/user.dart';
import 'package:imat_app/widgets/user_manager.dart';

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
    UserManager.loadLoggedInUser().then((u) {
      currentUser = u;
      setState(() {});
    });
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
              height: 640,
              padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 24),
              decoration: BoxDecoration(
                color: const Color(0xFFF8F8F8),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Column(
                children: [
                  _topBar(),

                  const SizedBox(height: 32),

                  Expanded(child: _buildContent()),

                  const SizedBox(height: 24),

                  _bottomButton(),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _topBar() => Row(
        children: [
          Expanded(
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.only(bottom: 10),
                  child: Text(
                    _getTitle(),
                    style: const TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
                Container(height: 3, color: const Color(0xFF8BC34A)),
              ],
            ),
          ),
          const SizedBox(width: 14),
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("Stäng", style: TextStyle(fontSize: 18)),
          ),
        ],
      );

  Widget _bottomButton() {
    if (view == 0) {
      return SizedBox(
        width: double.infinity,
        height: 52,
        child: ElevatedButton(
          style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
          onPressed: _confirmLogout,
          child: const Text(
            "Logga ut",
            style: TextStyle(
              fontSize: 18,
              color: Colors.white,
            ),
          ),
        ),
      );
    }

    return SizedBox(
      width: double.infinity,
      height: 52,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: const Color(0xFF8BC34A),
        ),
        onPressed: () => setState(() => view = 0),
        child: const Text("Tillbaka"),
      ),
    );
  }

  Widget _buildContent() {
    if (view == 1) return _settingsView();
    if (view == 2) return _receiptsView();
    return _mainMenu();
  }

  Widget _mainMenu() => Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          _menuButton(
            "Inställningar",
            Icons.settings_outlined,
            hoverSettings,
            (v) => setState(() => hoverSettings = v),
            () => setState(() => view = 1),
          ),
          const SizedBox(height: 28),
          _menuButton(
            "Kvitton",
            Icons.receipt_long_outlined,
            hoverReceipts,
            (v) => setState(() => hoverReceipts = v),
            () => setState(() => view = 2),
          ),
        ],
      );

  Widget _menuButton(
    String label,
    IconData icon,
    bool hover,
    Function(bool) onHover,
    VoidCallback onTap,
  ) {
    return MouseRegion(
      cursor: SystemMouseCursors.click,
      onEnter: (_) => onHover(true),
      onExit: (_) => onHover(false),
      child: GestureDetector(
        onTap: onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 140),
          width: 340,
          padding: const EdgeInsets.symmetric(vertical: 18, horizontal: 20),
          decoration: BoxDecoration(
            color: hover ? const Color(0xFF7CB342) : const Color(0xFF8BC34A),
            borderRadius: BorderRadius.circular(12),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.08),
                blurRadius: hover ? 10 : 5,
                offset: const Offset(0, 3),
              )
            ],
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(icon, size: 28, color: Colors.white),
              const SizedBox(width: 14),
              Text(label,
                  style: const TextStyle(
                      fontSize: 20,
                      color: Colors.white,
                      fontWeight: FontWeight.w500)),
            ],
          ),
        ),
      ),
    );
  }

  Widget _settingsView() => _infoView(
        Icons.settings_outlined,
        "Dina inställningar",
        "Här kommer dina inställningar visas.",
      );

  Widget _receiptsView() => _infoView(
        Icons.receipt_long_outlined,
        "Dina kvitton",
        "Här kommer dina kvitton visas.",
      );

  Widget _infoView(IconData icon, String title, String text) => Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, size: 110, color: Colors.black87),
          const SizedBox(height: 26),
          Text(title,
              style: const TextStyle(fontSize: 26, fontWeight: FontWeight.w500)),
          const SizedBox(height: 14),
          Text(text,
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 17, color: Colors.grey.shade700)),
        ],
      );

  String _getTitle() {
    if (view == 1) return "Inställningar";
    if (view == 2) return "Kvitton";

    if (currentUser == null) return "Konto";

    final name = currentUser!.userName.split("@").first;
    return "Hej, ${name[0].toUpperCase()}${name.substring(1)}!";
  }

  void _confirmLogout() {
    showDialog(
      context: context,
      barrierDismissible: true,
      barrierColor: Colors.black45,
      builder: (_) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
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
      ),
    );
  }
}