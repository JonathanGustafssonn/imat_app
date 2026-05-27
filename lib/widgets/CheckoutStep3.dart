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

  @override
  void initState() {
    super.initState();

    final c = widget.customer;
    if (c != null) {
      firstName.text = c.firstName;
      lastName.text = c.lastName;
      email.text = c.email;
      phone.text = c.mobilePhoneNumber;
      address.text = c.address;
      postCode.text = c.postCode;
      postAddress.text = c.postAddress;
    }
  }

  bool canFinish(ImatDataHandler iMat) {
    final c = widget.customer;
    final card = widget.card;

    if (c == null || card == null) return false;

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

  void _saveReceipt(ImatDataHandler iMat) {
    final cart = iMat.getShoppingCart();
    final extras = iMat.getExtras();

    final receipt = {
      "timestamp": DateTime.now().toIso8601String(),
      "total": iMat.shoppingCartTotal(),
      "items": cart.items.map((item) => {
            "name": item.product.name,
            "amount": item.amount,
            "price": item.product.price,
          }).toList(),
      "deliveryDate": extras["deliveryDate"],
      "deliveryTime": extras["deliveryTime"],
      "customer": widget.customer,
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

    final date = extras["deliveryDate"];
    final time = extras["deliveryTime"];

    final total = iMat.shoppingCartTotal();

    final okToFinish = canFinish(iMat);

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

              // ⭐ BIGGER TOTAL BOX
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(24),
                decoration: BoxDecoration(
                  color: Colors.green.shade600,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  "TOTALT ATT BETALA: $total kr",
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
                        onPressed: () {
                          setState(() => showItems = !showItems);
                        },
                      ),
                      child: Column(
                        children: [
                          if (showItems)
                            ...cart.items.map((item) => ListTile(
                                  title: Text(item.product.name),
                                  trailing: Text("${item.amount} st"),
                                )),
                        ],
                      ),
                    ),

                    CheckoutSection(
                      title: "Leverans",
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "Datum: ${date != null ? DateTime.parse(date).toLocal().toString().split(' ')[0] : 'Ej valt'}",
                          ),
                          Text("Tid: ${time ?? 'Ej valt'}"),
                        ],
                      ),
                    ),

                    // ⭐ EDITABLE CUSTOMER
                    CheckoutSection(
                      title: "Dina Uppgifter",
                      trailing: TextButton(
                        onPressed: () => setState(() => editCustomer = !editCustomer),
                        child: Text(editCustomer ? "Lås" : "Ändra"),
                      ),
                      child: Column(
                        children: [
                          TextField(controller: firstName, enabled: editCustomer),
                          TextField(controller: lastName, enabled: editCustomer),
                          TextField(controller: email, enabled: editCustomer),
                          TextField(controller: phone, enabled: editCustomer),
                          TextField(controller: address, enabled: editCustomer),
                          TextField(controller: postCode, enabled: editCustomer),
                          TextField(controller: postAddress, enabled: editCustomer),
                        ],
                      ),
                    ),

                    CheckoutSection(
                      title: "Betalning",
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(widget.card?.cardType == "Swish"
                              ? "Swish: ${widget.customer?.mobilePhoneNumber}"
                              : "Kort: ${maskCard(widget.card?.cardNumber)}"),
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
                    onPressed: okToFinish
                        ? () {
                            _saveReceipt(iMat);
                            widget.onFinish();
                          }
                        : null,
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