import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
// import 'package:literalink/authentication/models/user.dart';
import 'package:literalink/main.dart';


class CheckoutScreen extends StatelessWidget {
  const CheckoutScreen({Key? key}) : super(key: key);

  // User user = loggedInUser;

  // tinggal ngambil data checkout_list dari djangonya gimana

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Container(
            height: 250,
            padding: const EdgeInsets.only(top: 50, left: 15, right: 15),
            decoration: const BoxDecoration(
              color: Color(0xFFA2C579),
              borderRadius: BorderRadius.only(
                bottomRight: Radius.circular(150)
              )
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Expanded(
                        child: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 15),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(50)
                          ),
                          child: const TextField(
                            decoration: InputDecoration(
                              hintText: 'Search books',
                              border: InputBorder.none
                            ),
                          ),
                        )
                    ),
                    Container(
                      margin: const EdgeInsets.only(left: 5),
                      padding: const EdgeInsets.all(10),
                      decoration: const BoxDecoration(
                        shape: BoxShape.circle,
                        color: LiteraLink.limeGreen
                      ),
                      child: const Icon(CupertinoIcons.search, color: LiteraLink.tealDeep),
                    )
                  ],
                ),
                const Spacer(),

                Text('This is Member', style: Theme.of(context).textTheme.titleLarge?.copyWith(
                  color: LiteraLink.tealDeep,
                  letterSpacing: 1,
                  fontStyle: FontStyle.italic
                )),
                Text('Checkout List', style: Theme.of(context).textTheme.displayMedium?.copyWith(
                    color: LiteraLink.tealDeep,
                )),
                const SizedBox(height: 30)
              ],
            ),
          ),
          Expanded(
            child: GridView.count(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 15),
              crossAxisCount: 2,
              childAspectRatio: 3/4,
              crossAxisSpacing: 10,
              mainAxisSpacing: 20,
              children: [
                buildCheckoutList(context),
              ],
            ),
          )
        ],
      ),
    );
  }

  Widget buildCheckoutList(BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20)
      ),
      child: Column(
        children: [
          // Expanded(
          //   child: ClipRRect(
          //     borderRadius: BorderRadius.circular(20),
          //     child: Image.asset('assets/images/$image', fit: BoxFit.cover)
          //   ),
          // ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 15),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Nama buku', style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  overflow: TextOverflow.ellipsis,
                ), maxLines: 1),
                Row(
                  children: [
                    Expanded(
                      child: Row(
                        children: List.generate(5, (index) =>
                        const Icon(Icons.star, color: Colors.amber, size: 18,)).toList(),
                      ),
                    ),
                    Text('Rp 0', style: Theme.of(context).textTheme.titleSmall?.copyWith(
                        color: Theme.of(context).colorScheme.primary
                    ),)
                  ],
                )
              ],
            ),
          )
        ],
      ),
    );
  }
}