import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:imat_app/model/imat/customer.dart';
import 'package:imat_app/model/imat/credit_card.dart';
import 'package:imat_app/model/imat_data_handler.dart';
import 'package:imat_app/widgets/checkoutBoxes.dart';
import 'package:provider/provider.dart';

class CheckoutStep2 extends StatefulWidget {
  final VoidCallback onNext;
  final VoidCallback onBack;

  final Function(Customer) onCustomerChanged;
  final Function(CreditCard) onCardChanged;

  const CheckoutStep2({
    super.key,
    required this.onNext,
    required this.onBack,
    required this.onCustomerChanged,
    required this.onCardChanged,
  });

  @override
  State<CheckoutStep2> createState() => _CheckoutStep2State();
}

class _CheckoutStep2State extends State<CheckoutStep2> {
  final firstName = TextEditingController();
  final lastName = TextEditingController();
  final email = TextEditingController();
  final mobilePhoneNumber = TextEditingController();
  final phone = TextEditingController();
  final address = TextEditingController();
  final postCode = TextEditingController();
  final postAddress = TextEditingController();

  final cardNumber = TextEditingController();
  final cardMonth = TextEditingController();
  final cardYear = TextEditingController();
  final cvc = TextEditingController();

  String delivery = "Hemleverans";
  String payment = "Kort";

  DateTime? deliveryDate;
  String? deliveryTime;

  bool editRecipient = false;
  bool editPayment = false;

  @override
  void initState() {
    super.initState();

    final customer = context.read<ImatDataHandler>().getCustomer();

    firstName.text = customer.firstName;
    lastName.text = customer.lastName;
    email.text = customer.email;
    mobilePhoneNumber.text = customer.mobilePhoneNumber;
    phone.text = customer.phoneNumber;
    address.text = customer.address;
    postCode.text = customer.postCode;
    postAddress.text = customer.postAddress;
  }

  void saveData() {
    final iMat = context.read<ImatDataHandler>();

    widget.onCustomerChanged(
      Customer(
        firstName.text,
        lastName.text,
        phone.text,
        mobilePhoneNumber.text,
        email.text,
        address.text,
        postCode.text,
        postAddress.text,
      ),
    );

    widget.onCardChanged(
      CreditCard(
        payment,
        "${firstName.text} ${lastName.text}",
        int.tryParse(cardMonth.text) ?? 0,
        int.tryParse(cardYear.text) ?? 0,
        cardNumber.text,
        int.tryParse(cvc.text) ?? 0,
      ),
    );

    iMat.addExtra("deliveryDate", deliveryDate?.toIso8601String());
    iMat.addExtra("deliveryTime", deliveryTime);
  }

  @override
  Widget build(BuildContext context) {
    final now = DateTime.now();
    final closingHour = 23;
    final cutoffHour = now.hour + 2;

    final availableTimes = List.generate(17, (i) => 7 + i)
        .where((hour) {
          if (deliveryDate != null &&
              deliveryDate!.day == now.day &&
              deliveryDate!.month == now.month &&
              deliveryDate!.year == now.year) {
            return hour >= cutoffHour && hour < closingHour;
          }
          return true;
        })
        .toList();

    return Center(
      child: SizedBox(
        width: 600,
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            children: [
              const Text(
                "Leverans & Betalning",
                style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
              ),

              Expanded(
                child: ListView(
                  children: [
                    CheckoutSection(
                      title: "Leverans",
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          DropdownButton<String>(
                            value: delivery,
                            onChanged: (v) => setState(() => delivery = v!),
                            items: const [
                              DropdownMenuItem(
                                  value: "Hemleverans", child: Text("Hemleverans")),
                              DropdownMenuItem(
                                  value: "Hämta i butik", child: Text("Hämta i butik")),
                            ],
                          ),

                          const SizedBox(height: 10),

                          const Text("Välj datum:",
                              style: TextStyle(fontWeight: FontWeight.bold)),
                          TextButton(
                            onPressed: () async {
                              final picked = await showDatePicker(
                                context: context,
                                initialDate: now,
                                firstDate: now,
                                lastDate: now.add(const Duration(days: 14)),
                              );
                              if (picked != null) {
                                setState(() => deliveryDate = picked);
                              }
                            },
                            child: Text(
                              deliveryDate == null
                                  ? "Välj datum"
                                  : "${deliveryDate!.day}/${deliveryDate!.month}/${deliveryDate!.year}",
                            ),
                          ),

                          const SizedBox(height: 10),

                          const Text("Välj tid:",
                              style: TextStyle(fontWeight: FontWeight.bold)),

                          DropdownButton<String>(
                            value: deliveryTime,
                            hint: const Text("Välj tid"),
                            onChanged: (v) => setState(() => deliveryTime = v),
                            items: availableTimes.map((hour) {
                              return DropdownMenuItem(
                                value: "$hour:00",
                                child: Text("$hour:00"),
                              );
                            }).toList(),
                          ),
                        ],
                      ),
                    ),

                    CheckoutSection(
                      title: "Mottagare",
                      trailing: TextButton(
                        onPressed: () => setState(() => editRecipient = !editRecipient),
                        style: TextButton.styleFrom(
                          backgroundColor: Colors.green,
                          foregroundColor: Colors.white,
                        ),
                        child: Text(editRecipient ? "Lås" : "Ändra"),
                      ),
                      child: Column(
                        children: [
                          TextField(controller: firstName, enabled: editRecipient, decoration: const InputDecoration(labelText: "Förnamn")),
                          TextField(controller: lastName, enabled: editRecipient, decoration: const InputDecoration(labelText: "Efternamn")),
                          TextField(controller: email, enabled: editRecipient, decoration: const InputDecoration(labelText: "Email")),
                          TextField(controller: phone, enabled: editRecipient, decoration: const InputDecoration(labelText: "Telefonnummer* (Valfritt)")),
                          TextField(controller: mobilePhoneNumber, enabled: editRecipient, decoration: const InputDecoration(labelText: "Mobilnummer")),
                          TextField(controller: address, enabled: editRecipient, decoration: const InputDecoration(labelText: "Adress")),
                          TextField(controller: postCode, enabled: editRecipient, decoration: const InputDecoration(labelText: "Postnummer")),
                          TextField(controller: postAddress, enabled: editRecipient, decoration: const InputDecoration(labelText: "Postort")),
                        ],
                      ),
                    ),

                    CheckoutSection(
                      title: "Betalning",
                      trailing: TextButton(
                        onPressed: () => setState(() => editPayment = !editPayment),
                        style: TextButton.styleFrom(
                          backgroundColor: Colors.green,
                          foregroundColor: Colors.white,
                        ),
                        child: Text(editPayment ? "Lås" : "Ändra"),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          DropdownButton<String>(
                            value: payment,
                            onChanged: editPayment
                                ? (v) => setState(() => payment = v!)
                                : null,
                            items: const [
                              DropdownMenuItem(value: "Kort", child: Text("Kort")),
                              DropdownMenuItem(value: "Swish", child: Text("Swish")),
                            ],
                          ),

                          const SizedBox(height: 10),

                          if (payment == "Kort") ...[
                            TextField(controller: cardNumber, enabled: editPayment, decoration: const InputDecoration(labelText: "Kortnummer")),
                            Row(
                              children: [
                                Expanded(child: TextField(controller: cardMonth, enabled: editPayment, decoration: const InputDecoration(labelText: "MM"))),
                                const SizedBox(width: 10),
                                Expanded(child: TextField(controller: cardYear, enabled: editPayment, decoration: const InputDecoration(labelText: "YY"))),
                              ],
                            ),
                            TextField(controller: cvc, enabled: editPayment, decoration: const InputDecoration(labelText: "CVC")),
                          ],

                          if (payment == "Swish") ...[
                            TextField(controller: mobilePhoneNumber, enabled: editPayment, decoration: const InputDecoration(labelText: "Swish-nummer")),
                          ],
                        ],
                      ),
                    ),
                  ],
                ),
              ),

              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  ElevatedButton(onPressed: widget.onBack, child: const Text("Tillbaka")),
                  ElevatedButton(
                    onPressed: () {
                      saveData();
                      widget.onNext();
                    },
                    child: const Text("Fortsätt"),
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