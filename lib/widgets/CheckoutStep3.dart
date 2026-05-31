import 'package:flutter/material.dart';
import 'package:imat_app/model/imat/customer.dart';
import 'package:imat_app/model/imat/credit_card.dart';
import 'package:imat_app/model/imat_data_handler.dart';
import 'package:imat_app/widgets/checkoutBoxes.dart';
import 'package:provider/provider.dart';

class CheckoutStep3 extends StatefulWidget {
  final VoidCallback onFinish;
  final VoidCallback onBack;
  final Customer? customer;
  final CreditCard? card;

  const CheckoutStep3({
    super.key,
    required this.onFinish,
    required this.onBack,
    this.customer,
    this.card,
  });

  @override
  State<CheckoutStep3> createState() => _CheckoutStep3State();
}

class _CheckoutStep3State extends State<CheckoutStep3> {
  bool showItems = false;

  bool editCustomer = false;

  final firstName = TextEditingController();
  final lastName = TextEditingController();
  final email = TextEditingController();
  final phone = TextEditingController();
  final address = TextEditingController();
  final postCode = TextEditingController();
  final postAddress = TextEditingController();

  bool canFinish(ImatDataHandler iMat) {
    final c = widget.customer ?? iMat.getCustomer();
    final card = widget.card ?? iMat.getCreditCard();

    if (card.cardType.isEmpty) return false;

    return c.firstName.isNotEmpty &&
        c.lastName.isNotEmpty &&
        c.email.isNotEmpty &&
        c.mobilePhoneNumber.isNotEmpty &&
        c.address.isNotEmpty &&
        c.postCode.isNotEmpty &&
        c.postAddress.isNotEmpty;
  }

  String maskCard(String? card) {
    if (card == null || card.length < 4) return "****";
    return "**** **** **** ${card.substring(card.length - 4)}";
  }

  InputDecoration _fieldStyle(bool enabled) {
    return InputDecoration(
      filled: true,
      fillColor: enabled ? Colors.white : Colors.grey.shade200,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
      ),
    );
  }

  Widget _lockedText(String text) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Text(
        text,
        style: const TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  void _saveReceipt(ImatDataHandler iMat) {
    final cart = iMat.getShoppingCart();
    final extras = iMat.getExtras();

    final receipt = {
      "timestamp": DateTime.now().toIso8601String(),
      "total": iMat.shoppingCartTotal(),
      "items": cart.items
          .map((item) => {
                "name": item.product.name,
                "amount": item.amount,
                "price": item.product.price,
              })
          .toList(),
      "deliveryDate": extras["deliveryDate"],
      "deliveryTime": extras["deliveryTime"],
      "customer": iMat.getCustomer(),
    };

    List receipts = extras["receipts"] ?? [];
    receipts.add(receipt);
    iMat.addExtra("receipts", receipts);
  }

  @override
  Widget build(BuildContext context) {
    final iMat = context.watch<ImatDataHandler>();
    final cart = iMat.getShoppingCart();
    final extras = iMat.getExtras();

    final customer = widget.customer ?? iMat.getCustomer();
    final card = widget.card ?? iMat.getCreditCard();

    final date = extras["deliveryDate"];
    final time = extras["deliveryTime"];

    final total = iMat.shoppingCartTotal();

    String formattedDate(String? dateStr) {
      if (dateStr == null) return "Ej valt";
      final d = DateTime.parse(dateStr).toLocal();
      return "${d.day}/${d.month}/${d.year}";
    }

    return Center(
      child: SizedBox(
        width: 750,
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            children: [
              const Text(
                "Bekräfta beställning",
                style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
              ),

              const SizedBox(height: 20),

              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(24),
                decoration: BoxDecoration(
                  color: Colors.green,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  "Totalt Att Betala: ${total.toStringAsFixed(2)} kr",
                  style: const TextStyle(
                    fontSize: 26,
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),

              const SizedBox(height: 20),

              Expanded(
                child: ListView(
                  children: [
                    CheckoutSection(
                      title: "Dina Varor",
                      trailing: IconButton(
                        icon: Icon(showItems
                            ? Icons.keyboard_arrow_up
                            : Icons.keyboard_arrow_down),
                        onPressed: () =>
                            setState(() => showItems = !showItems),
                      ),
                      child: Column(
                        children: [
                          if (showItems)
                            ...cart.items.map(
                              (item) => ListTile(
                                title: Text(item.product.name),
                                trailing: Text("${item.amount} st"),
                              ),
                            ),
                        ],
                      ),
                    ),

                    CheckoutSection(
                      title: "Leverans",
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text("Datum: ${formattedDate(date)}"),
                          Text("Tid: ${time ?? 'Ej valt'}"),
                        ],
                      ),
                    ),

                    CheckoutSection(
                      title: "Dina Uppgifter",
                      trailing: TextButton(
                        onPressed: () =>
                            setState(() => editCustomer = !editCustomer),
                        style: TextButton.styleFrom(
                          backgroundColor: Colors.green,
                          foregroundColor: Colors.white,
                        ),
                        child: Text(editCustomer ? "Lås" : "Ändra"),
                      ),
                      child: editCustomer
                          ? Column(
                              children: [
                                TextField(
                                  controller: firstName,
                                  decoration: _fieldStyle(true),
                                ),
                                TextField(
                                  controller: lastName,
                                  decoration: _fieldStyle(true),
                                ),
                                TextField(
                                  controller: email,
                                  decoration: _fieldStyle(true),
                                ),
                                TextField(
                                  controller: phone,
                                  decoration: _fieldStyle(true),
                                ),
                                TextField(
                                  controller: address,
                                  decoration: _fieldStyle(true),
                                ),
                                TextField(
                                  controller: postCode,
                                  decoration: _fieldStyle(true),
                                ),
                                TextField(
                                  controller: postAddress,
                                  decoration: _fieldStyle(true),
                                ),
                              ],
                            )
                          : Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                _lockedText("Förnamn: ${customer.firstName}"),
                                _lockedText("Efternamn: ${customer.lastName}"),
                                _lockedText("Email: ${customer.email}"),
                                _lockedText("Telefon: ${customer.mobilePhoneNumber}"),
                                _lockedText("Adress: ${customer.address}"),
                                _lockedText("Postnummer: ${customer.postCode}"),
                                _lockedText("Postort: ${customer.postAddress}"),
                              ],
                            ),
                    ),

                    CheckoutSection(
                      title: "Betalning",
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            card.cardType == "Swish"
                                ? "Swish: ${customer.mobilePhoneNumber}"
                                : "Kort: ${maskCard(card.cardNumber)}",
                            style:
                                const TextStyle(fontWeight: FontWeight.bold),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),

              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  ElevatedButton(
                    onPressed: widget.onBack,
                    child: const Text("Tillbaka"),
                  ),
                  ElevatedButton(
                    onPressed: () {
                            _saveReceipt(iMat);
                            widget.onFinish();
                    },
                    child: const Text("Betala"),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}