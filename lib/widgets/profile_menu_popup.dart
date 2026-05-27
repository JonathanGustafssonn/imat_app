import 'package:flutter/material.dart';
import 'package:imat_app/model/imat/shopping_item.dart';
import 'package:provider/provider.dart';
import 'package:imat_app/model/imat/customer.dart';
import 'package:imat_app/model/imat_data_handler.dart';

const Color _accentGreen = Color.fromARGB(255, 197, 243, 129);

class ProfileMenuPopup extends StatefulWidget {
  const ProfileMenuPopup({super.key});

  @override
  State<ProfileMenuPopup> createState() => _ProfileMenuPopupState();
}

class _ProfileMenuPopupState extends State<ProfileMenuPopup> {
  int view = 0; // 0 = main menu, 1 = settings, 2 = receipts
  bool isEditing = false;

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
    _loadCustomer();
  }

  void _loadCustomer() {
    final iMat = context.read<ImatDataHandler>();
    final c = iMat.getCustomer();

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

  Widget _topBar() {
    final c = context.read<ImatDataHandler>().getCustomer();
    final name = "${c.firstName} ${c.lastName}".trim();

    return Row(
      children: [
        Expanded(
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.only(bottom: 10),
                child: Text(
                  view == 0
                      ? "Hej, $name!"
                      : view == 1
                          ? "Inställningar"
                          : "Kvitton",
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
          child: const Text(
            "Stäng",
            style: TextStyle(
              fontSize: 18,
              color: Colors.black,
              ),
            ),
        ),
      ],
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
            () => setState(() => view = 1),
          ),
          const SizedBox(height: 28),
          _menuButton(
            "Kvitton",
            Icons.receipt_long_outlined,
            () => setState(() => view = 2),
          ),
        ],
      );

  Widget _menuButton(String label, IconData icon, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 340,
        padding: const EdgeInsets.symmetric(vertical: 18, horizontal: 20),
        decoration: BoxDecoration(
          color: _accentGreen,
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
    );
  }

  Widget _settingsView() {
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
              children: isEditing ? _editForm() : _viewForm(),
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

  List<Widget> _viewForm() {
    final c = context.read<ImatDataHandler>().getCustomer();

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

    context.read<ImatDataHandler>().setCustomer(updated);

    setState(() => isEditing = false);
  }

  // RECEIPTS VIEW
  Widget _receiptsView() {
    final iMat = context.watch<ImatDataHandler>();
    final extras = iMat.getExtras();

  final receipts = extras["receipts"] ?? [];

  if (receipts.isEmpty) {
    return const Center(
      child: Text("Inga kvitton ännu"),
    );
  }

    return ListView.builder(
      itemCount: receipts.length,
      itemBuilder: (context, index) {
        final r = receipts[index];

      // Tid då beställningen gjordes
        DateTime? orderDateTime;

        if (r["timestamp"] != null) {
          orderDateTime = DateTime.tryParse(r["timestamp"]);
        }

        String orderText = "Okänd tid";

        if (orderDateTime != null) {
          final h = orderDateTime.hour.toString().padLeft(2, '0');
          final m = orderDateTime.minute.toString().padLeft(2, '0');

          orderText =
            "${orderDateTime.day}/${orderDateTime.month}/${orderDateTime.year} kl. $h:$m";
        }

      // Leverans/hämtning
        String deliveryText = "Ej valt";

        if (r["deliveryDate"] != null && r["deliveryTime"] != null) {
          final parsedDate = DateTime.tryParse(r["deliveryDate"]);

          if (parsedDate != null) {
            deliveryText =
              "${parsedDate.day}/${parsedDate.month}/${parsedDate.year} kl. ${r["deliveryTime"]}";
          }
        }

        return Container(
          margin: const EdgeInsets.only(bottom: 14),
          decoration: BoxDecoration(
            color: Colors.white,
            border: Border.all(color: _accentGreen, width: 2),
            borderRadius: BorderRadius.circular(12),
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(10),
            child: ExpansionTile(
              tilePadding: const EdgeInsets.symmetric(
                horizontal: 16,
                vertical: 6,
              ),
              childrenPadding: const EdgeInsets.fromLTRB(16, 0, 16, 16),

              title: Text(
                "Kvitto - $orderText",
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w600,
                ),
              ),

              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      "Leverans/Hämtning:",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                    Text(
                      deliveryText,
                      style: const TextStyle(fontSize: 16),
                    ),
                  ],
                ),

                const SizedBox(height: 10),

                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      "Total:",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                    Text(
                      "${r["total"]} kr",
                      style: const TextStyle(fontSize: 16),
                    ),
                  ],
                ),

                const SizedBox(height: 16),

                const Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    "Varor",
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),

                const SizedBox(height: 8),

                ...List.generate(
                  (r["items"] as List).length,
                  (i) {
                    final item = r["items"][i];

                    return Padding(
                      padding: const EdgeInsets.symmetric(vertical: 3),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(
                            child: Text(
                              item["name"],
                              style: const TextStyle(fontSize: 16),
                            ),
                          ),
                          Text(
                            "${(item["amount"] as num).toInt()}x",
                            style: const TextStyle(fontSize: 16),
                          ),
                        ],
                      ),
                    );
                  },
                ),

                const SizedBox(height: 16),

                Align(
                  alignment: Alignment.centerRight,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: _accentGreen,
                      foregroundColor: Colors.black,
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 6,
                      ),
                      minimumSize: const Size(0, 32),
                      tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                    ),
                    onPressed: () {
                      final iMat = context.read<ImatDataHandler>();

                      final items = r["items"] as List;

                      for (final item in items) {
                        final product = iMat.products.firstWhere(
                          (p) => p.name == item["name"],
                          orElse: () => throw Exception("Produkt inte hittad:"),
                        );

                        iMat.shoppingCartAdd(
                          ShoppingItem(
                            product,
                            (item["amount"] as num).toDouble(),
                          ),
                        );
                      }

                      setState(() => view = 0);

                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text("Produkter tillagda i varukorgen")),
                        );
                    },
                    child: const Text("Köp igen"),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _bottomButton() {
    if (view == 0) {
      return SizedBox(
        width: double.infinity,
        height: 52,
        child: ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.red,
          ),
          onPressed: _logout,
          child: const Text(
            "Logga ut",
            style: TextStyle(fontSize: 18, color: Colors.white),
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
          style: TextStyle(
            fontSize: 22,
            fontWeight: FontWeight.w500
          ),
        ),
      ),
    );
  }

  void _logout() {
    final iMat = context.read<ImatDataHandler>();
    iMat.addExtra("isLoggedIn", false);
    Navigator.pop(context, true);
  }
}