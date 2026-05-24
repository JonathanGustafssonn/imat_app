import 'package:flutter/material.dart';
import 'package:imat_app/model/imat/customer.dart';
import 'package:imat_app/model/imat/credit_card.dart';
import 'package:imat_app/model/imat_data_handler.dart';
import 'package:imat_app/widgets/checkoutBoxes.dart';
import 'package:provider/provider.dart';

class CheckoutStep3 extends StatelessWidget {
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
  Widget build(BuildContext context) {
    final iMat = context.watch<ImatDataHandler>();
    final cart = iMat.getShoppingCart();
    final extras = iMat.getExtras();

    final date = extras["deliveryDate"];
    final time = extras["deliveryTime"];

    return Padding(
      padding: const EdgeInsets.all(20),
      child: Column(
        children: [
          const Text("Bekräfta beställning",
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),

          Expanded(
            child: ListView(
              children: [
                CheckoutSection(
                  title: "Dina Varor",
                  child: Column(
                    children: cart.items.map((item) {
                      return ListTile(
                        title: Text(item.product.name),
                        trailing: Text("${item.amount} st"),
                      );
                    }).toList(),
                  ),
                ),

                CheckoutSection(
                  title: "Leverans",
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text("Datum: ${date != null ? DateTime.parse(date).toLocal().toString().split(' ')[0] : 'Ej valt'}"),
                      Text("Tid: ${time ?? 'Ej valt'}"),
                    ],
                  ),
                ),

                CheckoutSection(
                  title: "Dina Uppgifter",
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text("Namn: ${customer?.firstName} ${customer?.lastName}"),
                      Text("Email: ${customer?.email}"),
                      Text("Telefon: ${customer?.mobilePhoneNumber}"),
                      Text("Adress: ${customer?.address}"),
                      Text("Postnummer: ${customer?.postCode}"),
                      Text("Postort: ${customer?.postAddress}"),
                    ],
                  ),
                ),

                CheckoutSection(
                  title: "Betalning",
                  child: Text(card?.cardType == "Swish"
                      ? "Swish: ${customer?.mobilePhoneNumber}"
                      : "Kortbetalning"),
                ),

                CheckoutSection(
                  title: "Totalbelopp",
                  child: Text("${iMat.shoppingCartTotal()} kr",
                      style: const TextStyle(fontSize: 18)),
                ),
              ],
            ),
          ),

          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              ElevatedButton(onPressed: onBack, child: const Text("Tillbaka")),
              ElevatedButton(onPressed: onFinish, child: const Text("Betala")),
            ],
          ),
        ],
      ),
    );
  }
}