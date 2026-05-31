import 'package:flutter/material.dart';
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
  final _formKey = GlobalKey<FormState>();

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

  String formatDate(DateTime d) {
    const months = [
      "jan", "feb", "mar", "apr", "maj", "jun",
      "jul", "aug", "sep", "okt", "nov", "dec"
    ];
    return "${d.day} ${months[d.month - 1]} ${d.year}";
  }

  bool validateEmail(String v) => v.contains("@") && v.contains(".");
  bool validatePhone(String v) => v.replaceAll(RegExp(r'\\D'), '').length >= 8;
  bool validatePostCode(String v) => RegExp(r'^[0-9]{5}$').hasMatch(v);
  bool validateCard(String v) => v.replaceAll(" ", "").length >= 12;
  bool validateCVC(String v) => v.length >= 3;

  void saveData() {
    if (!_formKey.currentState!.validate()) return;
    if (deliveryDate == null || deliveryTime == null) return;

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

  InputDecoration fieldStyle(String label, bool enabled) {
    return InputDecoration(
      labelText: label,
      filled: true,
      fillColor: enabled ? Colors.white : Colors.grey.shade300,
      border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
    );
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
        width: 800,
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Form(
            key: _formKey,
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
                                DropdownMenuItem(value: "Hemleverans", child: Text("Hemleverans")),
                                DropdownMenuItem(value: "Hämta i butik", child: Text("Hämta i butik")),
                              ],
                            ),

                            const SizedBox(height: 10),

                            Text("Datum: ${deliveryDate != null ? formatDate(deliveryDate!) : "Välj datum"}"),
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
                              child: const Text("Ändra datum"),
                            ),

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
                        child: Wrap(
                          spacing: 10,
                          runSpacing: 10,
                          children: [
                            SizedBox(width: 350,
                              child: TextFormField(
                                controller: firstName,
                                enabled: editRecipient,
                                decoration: fieldStyle("Förnamn", editRecipient),
                                validator: (v) => v!.isEmpty ? "Obligatoriskt" : null,
                              ),
                            ),
                            SizedBox(width: 350,
                              child: TextFormField(
                                controller: lastName,
                                enabled: editRecipient,
                                decoration: fieldStyle("Efternamn", editRecipient),
                                validator: (v) => v!.isEmpty ? "Obligatoriskt" : null,
                              ),
                            ),
                            SizedBox(width: 350,
                              child: TextFormField(
                                controller: email,
                                enabled: editRecipient,
                                decoration: fieldStyle("Email", editRecipient),
                              ),
                            ),
                            SizedBox(width: 350,
                              child: TextFormField(
                                controller: phone,
                                enabled: editRecipient,
                                decoration: fieldStyle("Telefon", editRecipient),
                              ),
                            ),
                            SizedBox(width: 350,
                              child: TextFormField(
                                controller: mobilePhoneNumber,
                                enabled: editRecipient,
                                decoration: fieldStyle("Mobil", editRecipient),
                              ),
                            ),
                            SizedBox(width: 350,
                              child: TextFormField(
                                controller: address,
                                enabled: editRecipient,
                                decoration: fieldStyle("Adress", editRecipient),
                              ),
                            ),
                            SizedBox(width: 350,
                              child: TextFormField(
                                controller: postCode,
                                enabled: editRecipient,
                                decoration: fieldStyle("Postnummer", editRecipient),
                              ),
                            ),
                            SizedBox(width: 350,
                              child: TextFormField(
                                controller: postAddress,
                                enabled: editRecipient,
                                decoration: fieldStyle("Postort", editRecipient),
                              ),
                            ),
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
                          children: [
                            DropdownButton<String>(
                              value: payment,
                              onChanged: editPayment ? (v) => setState(() => payment = v!) : null,
                              items: const [
                                DropdownMenuItem(value: "Kort", child: Text("Kort")),
                                DropdownMenuItem(value: "Swish", child: Text("Swish")),
                              ],
                            ),

                            if (payment == "Kort") ...[
                              TextFormField(
                                controller: cardNumber,
                                enabled: editPayment,
                                decoration: fieldStyle("Kortnummer", editPayment),
                                validator: (v) => validateCard(v!) ? null : "Ogiltigt kort",
                              ),
                              Row(
                                children: [
                                  Expanded(
                                    child: TextFormField(
                                      controller: cardMonth,
                                      enabled: editPayment,
                                      decoration: fieldStyle("MM", editPayment),
                                    ),
                                  ),
                                  const SizedBox(width: 10),
                                  Expanded(
                                    child: TextFormField(
                                      controller: cardYear,
                                      enabled: editPayment,
                                      decoration: fieldStyle("YY", editPayment),
                                    ),
                                  ),
                                ],
                              ),
                              TextFormField(
                                controller: cvc,
                                enabled: editPayment,
                                decoration: fieldStyle("CVC", editPayment),
                                validator: (v) => validateCVC(v!) ? null : "CVC",
                              ),
                            ],

                            if (payment == "Swish") ...[
                              TextFormField(
                                controller: mobilePhoneNumber,
                                enabled: editPayment,
                                keyboardType: TextInputType.phone,
                                decoration: fieldStyle("Swish-nummer (samma som mobilnummer)", editPayment),
                              ),
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
                        if (_formKey.currentState!.validate()) {
                          widget.onNext();
                        }
                      },
                      child: const Text("Fortsätt"),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}