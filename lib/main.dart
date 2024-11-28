import 'package:flutter/material.dart';

import 'Item.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'InstaCart',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.green),
        useMaterial3: true,
      ),
      home: const MyHomePage(title: 'InstaCart'),
    );
  }
}

Item coke = Item(001, "12pk Coca Cola", "https://i5.walmartimages.com/asr/f810b124-f8a0-4a93-82d2-3e770ea24345.361d24791354ad16ecc48cff4ceee35e.jpeg?odnHeight=2000&odnWidth=2000&odnBg=FFFFFF", 12.91);
Item pringles = Item(002, "Pringles 500g", "https://voila.ca/images-v3/2d92d19c-0354-49c0-8a91-5260ed0bf531/57dda498-e3a1-4944-b874-c58fff63365c/500x500.jpg", 4.99);
Item chickenstrips = Item(003, "Janes Chicken Tenders", "http://i.bungo.ca/u/Es7SGJ.png", 12.91);
Item cucumber = Item(004, "Cucumber", "https://i5.walmartimages.ca/images/Enlarge/840/154/6000205840154.jpg?odnHeight=2000&odnWidth=2000&odnBg=FFFFFF", 3.99);
Item carrots = Item(005, "Carrots 50g", "https://i5.walmartimages.ca/images/Enlarge/328/479/6000207328479.jpg", 2.50);
Item Oreo = Item(006, "Oreo cookies 495g", "https://i5.walmartimages.com/asr/db7d72d9-68da-4ee2-9838-ea45824ff7af.3327e3c6c5731b6a6190eba573c8a8f9.jpeg?odnHeight=2000&odnWidth=2000&odnBg=FFFFFF", 3.45);
Item dietcoke = Item(007, "12pk Diet Coca Cola", "http://i.bungo.ca/u/FIsdyL.png", 12.91);


Cart cart1 = Cart([coke, pringles], "2024-11-28");
Cart cart2 = Cart([carrots,chickenstrips,Oreo,cucumber], "2024-11-03");
Cart cart3 = Cart([coke,pringles, chickenstrips, cucumber, carrots, Oreo, dietcoke], "2024-10-20");

User user1 = User([cart1, cart2, cart3], "Josh");

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title),
        actions: [
          IconButton(onPressed: () async{
            //Go to cart history
            final result = await Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => _CartHistoryPage(user1))
            );
          }, icon: const Icon(Icons.history)),
          IconButton(
              onPressed: () async{
                final result = await Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => _settingspage(user1))
                );
              }, icon: const Icon(Icons.settings))
        ],
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
                onPressed: () async{
                  final result = await Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => _scannerpage())
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.green,
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(50)
                  )
                ),
                child: const Text("New Cart")
            )
          ],
        ),
      ),
    );
  }
}

class _scannerpage extends StatelessWidget{
  Cart currentcart = new Cart([], "${DateTime.now()}");


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: BottomAppBar(
        color: Colors.black,
        child: Row(
          children: [
            ElevatedButton(
                onPressed: () =>{

                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.red
                ),
                child: Text("Random Item")),
                Spacer(),
                IconButton(
                  alignment: Alignment.bottomRight,
                  onPressed: () =>{
  
                  },
                icon: Icon(Icons.shopping_cart)
            ),
          ]
        )
      )
    );
  }
}

class _CartHistoryPage extends StatelessWidget{
  User user;
  _CartHistoryPage(this.user);

  @override
  Widget build(BuildContext context) {
    print(user.history.length);
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text("Cart History"),
      ),
      body:ListView.separated(
            itemCount: user.history.length,
            itemBuilder: (BuildContext context, int index){
              return GestureDetector(
                onTap: () async{
                  final result = await Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => _cartpageview(user.history[index]))
                  );
                },
                child: Container(
                  child: ListTile(
                    shape: RoundedRectangleBorder(
                      side: BorderSide(color: Colors.grey, width: 1),
                      borderRadius: BorderRadius.circular(5)
                    ),
                    title: Text(user.history[index].date),
                    trailing: Text("${(user.history[index].gettotalwithtax()).toStringAsFixed(2)}"),
                  ),
                ),
              );
            },
            separatorBuilder: (BuildContext context, int index) => const Divider(),
          )
    );
  }
  
}

class _cartpageview extends StatelessWidget {
  final Cart cart;

  _cartpageview(this.cart);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text("Cart: ${cart.date}"),
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.separated(
              itemCount: cart.items.length,
              itemBuilder: (BuildContext context, int index) {
                return ListTile(
                  leading: Image.network(cart.items[index].itemimgurl),
                  title: Text(cart.items[index].itemname),
                  trailing: Text("${cart.items[index].cost}"),
                );
              },
              separatorBuilder: (BuildContext context, int index) => const Divider(),
            ),
          ),
          BottomAppBar(
            child: Row(
              children: [
                Spacer(),
                Column(
                  children: [
                    Text("Tax: ${(cart.gettotal()*0.13).toStringAsFixed(2)}"),
                    Text("Total: ${(cart.gettotal() + (cart.gettotal()*0.13)).toStringAsFixed(2)}"),
                  ],
                )
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _settingspage extends StatelessWidget{
  User currentuser;

  _settingspage(this.currentuser);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text("Settings"),
      ),
    );
  }

}