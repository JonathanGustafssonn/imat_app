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
  bool showItems = false; // dropdown för varor

  @override
  Widget build(BuildContext context) {
    final iMat = context.watch<ImatDataHandler>();
    final cart = iMat.getShoppingCart();
    final extras = iMat.getExtras();

    final date = extras["deliveryDate"];
    final time = extras["deliveryTime"];

    return Center(
      child: SizedBox(
        width: 600,
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
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.green.shade400,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  "Totalt: ${iMat.shoppingCartTotal()} kr",
                  style: const TextStyle(
                    fontSize: 20,
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
                        icon: Icon(
                          showItems
                              ? Icons.keyboard_arrow_up
                              : Icons.keyboard_arrow_down,
                        ),
                        onPressed: () {
                          setState(() => showItems = !showItems);
                        },
                      ),
                      child: Column(
                        children: [
                          if (!showItems)
                            const Text("Tryck för att visa varor"),

                          if (showItems)
                            ...cart.items.map((item) {
                              return ListTile(
                                title: Text(item.product.name),
                                trailing: Text("${item.amount} st"),
                              );
                            }).toList(),
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

                    CheckoutSection(
                      title: "Dina Uppgifter",
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text("Namn: ${widget.customer?.firstName} ${widget.customer?.lastName}"),
                          Text("Email: ${widget.customer?.email}"),
                          Text("Telefon: ${widget.customer?.mobilePhoneNumber}"),
                          Text("Adress: ${widget.customer?.address}"),
                          Text("Postnummer: ${widget.customer?.postCode}"),
                          Text("Postort: ${widget.customer?.postAddress}"),
                        ],
                      ),
                    ),

                    CheckoutSection(
                      title: "Betalning",
                      child: Text(
                        widget.card?.cardType == "Swish"
                            ? "Swish: ${widget.customer?.mobilePhoneNumber}"
                            : "Kortbetalning",
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
                    onPressed: widget.onFinish,
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