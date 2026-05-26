import 'package:flutter/material.dart';
import 'package:imat_app/model/imat/user.dart';
import 'package:imat_app/model/imat/customer.dart';
import 'package:imat_app/widgets/user_manager.dart';

const Color _accentGreen = Color.fromARGB(255, 197, 243, 129);

class ProfileMenuPopup extends StatefulWidget {
  const ProfileMenuPopup({super.key});

  @override
  State<ProfileMenuPopup> createState() => _ProfileMenuPopupState();
}

class _ProfileMenuPopupState extends State<ProfileMenuPopup> {
  int view = 0;

  bool hoverSettings = false;
  bool hoverReceipts = false;

  bool isEditing = false;

  User? currentUser;

  final firstNameCtrl = TextEditingController();
  final lastNameCtrl = TextEditingController();
  final emailCtrl = TextEditingController();
  final phoneCtrl = TextEditingController();
  final mobileCtrl = TextEditingController();
  final addressCtrl = TextEditingController();
  final postCodeCtrl = TextEditingController();
  final postAddressCtrl = TextEditingController();

  @override
  void initState() {
    super.initState();
    UserManager.loadLoggedInUser().then((u) {
      currentUser = u;
      _loadUserData();
      setState(() {});
    });
  }

  void _loadUserData() {
    final c = currentUser?.customer;
    if (c == null) return;

    firstNameCtrl.text = c.firstName;
    lastNameCtrl.text = c.lastName;
    emailCtrl.text = c.email;
    phoneCtrl.text = c.phoneNumber;
    mobileCtrl.text = c.mobilePhoneNumber;
    addressCtrl.text = c.address;
    postCodeCtrl.text = c.postCode;
    postAddressCtrl.text = c.postAddress;
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

  // TOP BAR
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
                Container(height: 3, color: _accentGreen),
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

  // BOTTOM BUTTON
  Widget _bottomButton() {
    if (view == 0) {
      return SizedBox(
        width: double.infinity,
        height: 52,
        child: ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.red,
            foregroundColor: Colors.black,
          ),
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
          backgroundColor: _accentGreen,
          foregroundColor: Colors.black,
        ),
        onPressed: () => setState(() => view = 0),
        child: const Text(
          "Tillbaka",
          style: TextStyle(fontSize: 22, fontWeight: FontWeight.w500),
        ),
      ),
    );
  }

  // CONTENT
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
            color: hover ? const Color.fromARGB(255, 162, 202, 102).withOpacity(0.85) : _accentGreen,
            borderRadius: BorderRadius.circular(12),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(icon, size: 28, color: Colors.black),
              const SizedBox(width: 14),
              Text(
                label,
                style: const TextStyle(
                  fontSize: 20,
                  color: Colors.black,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // SETTINGS
  Widget _settingsView() {
    final c = currentUser?.customer;

    return Column(
      children: [
        Text(
          isEditing ? "Ändra mina uppgifter" : "Mina uppgifter",
          style: const TextStyle(fontSize: 22, fontWeight: FontWeight.w600),
        ),
        const SizedBox(height: 20),
        Expanded(
          child: SingleChildScrollView(
            child: Column(
              children: isEditing ? _editForm() : _viewForm(c),
            ),
          ),
        ),
        ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: _accentGreen,
            foregroundColor: Colors.black,
          ),
          onPressed: () {
            if (isEditing) {
              _saveProfile();
            } else {
              setState(() => isEditing = true);
            }
          },
          child: Text(isEditing ? "Spara" : "Ändra mina uppgifter"),
        ),
      ],
    );
  }

  List<Widget> _viewForm(Customer? c) {
    if (c == null) return [const Text("Ingen kunddata")];

    return [
      _info("Förnamn", c.firstName),
      _info("Efternamn", c.lastName),
      _info("Email", c.email),
      _info("Telefon", c.phoneNumber),
      _info("Mobil", c.mobilePhoneNumber),
      _info("Adress", c.address),
      _info("Postkod", c.postCode),
      _info("Postadress", c.postAddress),
    ];
  }

  List<Widget> _editForm() => [
        _field("Förnamn", firstNameCtrl),
        _field("Efternamn", lastNameCtrl),
        _field("Email", emailCtrl),
        _field("Telefon", phoneCtrl),
        _field("Mobil", mobileCtrl),
        _field("Adress", addressCtrl),
        _field("Postkod", postCodeCtrl),
        _field("Postadress", postAddressCtrl),
      ];

  Widget _field(String label, TextEditingController c) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: TextField(
        controller: c,
        decoration: InputDecoration(
          labelText: label,
          border: const OutlineInputBorder(),
        ),
      ),
    );
  }

  Widget _info(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label,
              style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 18)),
          Text(value, style: const TextStyle(fontSize: 18)),
        ],
      ),
    );
  }

  void _saveProfile() {
    final updated = Customer(
      firstNameCtrl.text,
      lastNameCtrl.text,
      phoneCtrl.text,
      mobileCtrl.text,
      emailCtrl.text,
      addressCtrl.text,
      postCodeCtrl.text,
      postAddressCtrl.text,
    );

    setState(() {
      currentUser!.customer = updated;
      isEditing = false;
    });

    UserManager.saveLoggedInUser(currentUser!);
  }

  String _getTitle() {
    if (view == 1) return "Inställningar";
    if (view == 2) return "Kvitton";

    if (currentUser == null) return "Konto";

    final c = currentUser!.customer;
    if (c == null) {
      final name = currentUser!.userName.split("@").first;
      return "Hej, ${name[0].toUpperCase()}${name.substring(1)}!";
    }

    return "Hej, ${c.firstName} ${c.lastName}!";
  }

  void _confirmLogout() {
    showDialog(
      context: context,
      barrierColor: Colors.black45,
      builder: (_) => AlertDialog(
        title: const Text("Logga ut"),
        content: const Text("Är du säker?"),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("Avbryt"),
          ),
          TextButton(
            onPressed: () async {
              await UserManager.logout();
              if (!context.mounted) return;
              Navigator.pop(context);
              Navigator.pop(context, true);
            },
            child: const Text("Ja", style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }

  Widget _receiptsView() => const Center(
        child: Text("Kvitton kommer här"),
      );
}