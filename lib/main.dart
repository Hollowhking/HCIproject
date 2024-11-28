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

Item coke = Item(001, "12pk Coca Cola", "itemimgurl", 12.91);
Item pringles = Item(002, "Pringles 500g", "itemimgurl", 4.99);
Item chickenstrips = Item(003, "Janes Chicken Tenders", "itemimgurl", 12.91);

Cart cart1 = Cart([coke, pringles], "2024-11-28");

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
              MaterialPageRoute(builder: (context) => _CartHistoryPage([cart1]))
            );
          }, icon: const Icon(Icons.history))
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
  Cart currentcart = new Cart([], "2024-11-28");


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
  List<Cart> carthistorylist;
  _CartHistoryPage(this.carthistorylist);

  @override
  Widget build(BuildContext context) {
    print(carthistorylist.length);
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text("Cart History"),
      ),
      body:ListView.separated(
            itemCount: carthistorylist.length,
            itemBuilder: (BuildContext context, int index){
              return GestureDetector(
                onTap: () async{

                },
                child: Container(
                  child: ListTile(
                    title: Text(carthistorylist[index].date),
                  ),
                ),
              );
            },
            separatorBuilder: (BuildContext context, int index) => const Divider(),
          )
    );
  }
  
}