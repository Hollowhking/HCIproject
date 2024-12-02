import 'dart:math';

import 'package:camera/camera.dart';
import 'package:flutter/material.dart';

import 'Item.dart';

void main() async {
  WidgetsFlutterBinding
      .ensureInitialized(); // Ensures Flutter is fully initialized before using asynchronous calls

  // Fetch the list of available cameras on the device
  final cameras = await availableCameras();
  final firstCamera = cameras
      .first; // Select the first camera in the list (usually the back camera)

  runApp(MyApp(
    camera: firstCamera,
  ));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key, required this.camera});

  final CameraDescription camera;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'InstaCart',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.green),
        useMaterial3: true,
      ),
      home: MyHomePage(
        title: 'InstaCart',
        camera: camera,
      ),
    );
  }
}

Item coke = Item(
    001,
    "12pk Coca Cola",
    "https://i5.walmartimages.com/asr/f810b124-f8a0-4a93-82d2-3e770ea24345.361d24791354ad16ecc48cff4ceee35e.jpeg?odnHeight=2000&odnWidth=2000&odnBg=FFFFFF",
    12.91);
Item pringles = Item(
    002,
    "Pringles 500g",
    "https://voila.ca/images-v3/2d92d19c-0354-49c0-8a91-5260ed0bf531/57dda498-e3a1-4944-b874-c58fff63365c/500x500.jpg",
    4.99);
Item chickenstrips =
    Item(003, "Janes Chicken Tenders", "http://i.bungo.ca/u/Es7SGJ.png", 12.91);
Item cucumber = Item(
    004,
    "Cucumber",
    "https://i5.walmartimages.ca/images/Enlarge/840/154/6000205840154.jpg?odnHeight=2000&odnWidth=2000&odnBg=FFFFFF",
    3.99);
Item carrots = Item(
    005,
    "Carrots 50g",
    "https://i5.walmartimages.ca/images/Enlarge/328/479/6000207328479.jpg",
    2.50);
Item oreo = Item(
    006,
    "Oreo cookies 495g",
    "https://i5.walmartimages.com/asr/db7d72d9-68da-4ee2-9838-ea45824ff7af.3327e3c6c5731b6a6190eba573c8a8f9.jpeg?odnHeight=2000&odnWidth=2000&odnBg=FFFFFF",
    3.45);
Item dietcoke =
    Item(007, "12pk Diet Coca Cola", "http://i.bungo.ca/u/FIsdyL.png", 12.91);

List<Item> items = [
  coke,
  pringles,
  chickenstrips,
  cucumber,
  carrots,
  oreo,
  dietcoke
];

Cart cart1 = Cart([coke, pringles], "2024-11-28");
Cart cart2 = Cart([carrots, chickenstrips, oreo, cucumber], "2024-11-03");
Cart cart3 = Cart(
    [coke, pringles, chickenstrips, cucumber, carrots, oreo, dietcoke],
    "2024-10-20");

Paymentmethod creditcard1 = Paymentmethod("0000 0000 0000 0000", "12/35", 000);

User user1 = User([cart1, cart2, cart3], "Josh", [creditcard1]);

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title, required this.camera});

  final String title;
  final CameraDescription camera;

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
          IconButton(
              onPressed: () async {
                //Go to cart history
                final result = await Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => _CartHistoryPage(user1)));
              },
              icon: const Icon(Icons.history)),
          IconButton(
              onPressed: () async {
                final result = await Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => _settingspage(user1)));
              },
              icon: const Icon(Icons.settings))
        ],
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(
              width: MediaQuery.of(context).size.width * 0.5,
              height: MediaQuery.of(context).size.height * 0.08,
              child: ElevatedButton(
                  onPressed: () async {
                    final result = await Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => _ScannerPage(
                              camera: widget.camera,
                            )));
                  },
                  style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.green,
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(50))),
                  child: Row(
                    children: [
                      Icon(Icons.shopping_cart),
                      Padding(padding: EdgeInsets.all(15)),
                      Text("New Cart")
                    ],
                  )
              ,
            ),
        ),
      ])
      )
    );
  }
}

class _ScannerPage extends StatefulWidget {
  final CameraDescription camera;
  _ScannerPage({required this.camera});
  Cart currentcart = new Cart([], "${DateTime.now()}");

  @override
  State<StatefulWidget> createState() => _ScannerPageState();
}

class _ScannerPageState extends State<_ScannerPage> {
  Cart currentCart = Cart([], "2024-11-28");
  late CameraController _controller;

  Item? activeItem;

  late Future<void>
      _initializeControllerFuture; // Future to track initialization status

  @override
  void initState() {
    super.initState();
    _controller = CameraController(
      widget.camera, // Use the camera passed from the parent widget
      ResolutionPreset.high, // Set the video resolution to high
    );

    _initializeControllerFuture = _controller.initialize();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        bottomNavigationBar: BottomAppBar(
            child: Row(children: [
              ElevatedButton(
                  onPressed: () async {
                    activeItem = items[Random().nextInt(items.length)];
                    setState(() {});

                    await Future.delayed(const Duration(seconds: 3));
                    final result =
                        await await _addItemToCartDialog(activeItem!);

                    if (result != null && result) {
                      currentCart.additem(activeItem!);
                    }

                    activeItem = null;
                    setState(() {});
                  },
                  style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
                  child: const Text("Random Item", style: TextStyle(color: Colors.white),)),
              const Spacer(),
              IconButton(
                  onPressed: () async {
                    final result = await Navigator.of(context)
                        .push(MaterialPageRoute(builder: (context) {
                      return _CartPageView(currentCart);
                    }));

                    if (result == null && result is! Cart) return;

                    currentCart = result!;
                  },
                  style: ButtonStyle(backgroundColor: WidgetStatePropertyAll(Colors.green)),
                  icon: const Icon(Icons.shopping_cart, color: Colors.white,)),
            ])),
        body: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              "Scan Your Items",
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 32),
            ),
            const Padding(padding: EdgeInsets.all(20)),
            Center(
              child: Stack(
                children: [
                  Center(
                    child: Container(
                      decoration: BoxDecoration(
                          border: Border.all(color: Colors.grey, width: 10)),
                      width: MediaQuery.of(context).size.width * 0.8,
                      height: MediaQuery.of(context).size.width * 0.8,
                      child: FutureBuilder(
                          future: _initializeControllerFuture,
                          builder: (context, snapshot) {
                            if (snapshot.connectionState !=
                                ConnectionState.done) {
                              return const CircularProgressIndicator();
                            }
                            return CameraPreview(_controller);
                          }),
                    ),
                  ),
                  if (activeItem != null)
                    Center(
                      child: Container(
                        decoration: BoxDecoration(
                            border: Border.all(color: Colors.grey, width: 10)),
                        width: MediaQuery.of(context).size.width * 0.8,
                        height: MediaQuery.of(context).size.width * 0.8,
                        child: Image.network("http://i.bungo.ca/u/Te0ZXu.png"),
                      ),
                    )
                ],
              ),
            ),
          ],
        ));
  }

  Future<Future<bool?>> _addItemToCartDialog(Item item) async {
    return showDialog<bool>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Item Found'),
          content: SingleChildScrollView(
            child: Row(
              children: [
                SizedBox(
                  width: MediaQuery.of(context).size.width * 0.3,
                  child: Image.network(item.itemimgurl),
                ),
                const Spacer(),
                SizedBox(
                  width: MediaQuery.of(context).size.width * 0.3,
                  child: Column(
                    children: [
                      Text(
                        item.itemname,
                        style: const TextStyle(
                            fontSize: 20, fontWeight: FontWeight.bold),
                        textAlign: TextAlign.center,
                        softWrap: true,
                      ),
                      Text(
                        "Price: ${item.cost}",
                        style: const TextStyle(fontSize: 20),
                      )
                    ],
                  ),
                )
              ],
            ),
          ),
          actions: <Widget>[
            SizedBox(
              width: MediaQuery.of(context).size.width * 0.9,
              child: Row(
                children: [
                  TextButton(
                    child: const Text('Cancel'),
                    onPressed: () {
                      Navigator.of(context).pop(false);
                    },
                  ),
                  const Spacer(),
                  ElevatedButton(
                    onPressed: () {
                      Navigator.of(context).pop(true);
                    },
                    style:
                        ElevatedButton.styleFrom(backgroundColor: Colors.green),
                    child: const Text(
                      'Add to Cart',
                      style: TextStyle(color: Colors.white),
                    ),
                  )
                ],
              ),
            )
          ],
        );
      },
    );
  }
}


class _CartPageView extends StatefulWidget {

  final Cart cart;

  _CartPageView(this.cart);

  @override
  State<StatefulWidget> createState() => _CartPageViewState();

}

class _CartPageViewState extends State<_CartPageView> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text("Cart: ${widget.cart.date}"),
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.separated(
              itemCount: widget.cart.items.length,
              itemBuilder: (BuildContext context, int index) {
                return SizedBox(
                  width: MediaQuery.of(context).size.width * 0.9,
                  child: Row(
                    children: [
                      IconButton(
                        onPressed: () {
                          Item item = widget.cart.items[index];
                          widget.cart.additem(item);

                          final snackbar = SnackBar(
                            duration: const Duration(seconds: 2),
                            content: const Text("Undo last added item?"),
                            action: SnackBarAction(
                                label: "Undo",
                                onPressed: () {
                                  widget.cart.removeItem(item);
                                  setState(() {});
                                }),
                          );
                          setState(() {});
                          ScaffoldMessenger.of(context).showSnackBar(snackbar);
                        },
                        icon: const Icon(Icons.add, color: Colors.white),
                        style: ButtonStyle(backgroundColor: WidgetStatePropertyAll(Colors.green)),
                      ),
                      SizedBox(
                          width: MediaQuery.of(context).size.width * 0.25,
                          child: Image.network(widget.cart.items[index].itemimgurl)),
                      Padding(padding: EdgeInsets.all(3)),
                      Text(widget.cart.items[index].itemname),
                      Spacer(),
                      Text("${widget.cart.items[index].cost}"),
                      Padding(padding: EdgeInsets.all(3)),
                      IconButton(
                        onPressed: () {
                          Item item = widget.cart.items[index];
                          widget.cart.removeItem(item);

                          final snackbar = SnackBar(
                            content: const Text("Undo last removed item?"),
                            action: SnackBarAction(
                                label: "Undo",
                                onPressed: () {
                                  widget.cart.additem(item);
                                  setState(() {});
                                }),
                          );
                          setState(() {});
                          ScaffoldMessenger.of(context).showSnackBar(snackbar);
                        },
                        icon: const Icon(Icons.remove, color: Colors.white),
                        style: ButtonStyle(backgroundColor: WidgetStatePropertyAll(Colors.red)),
                      ),
                    ],
                  ),
                );
              },
              separatorBuilder: (BuildContext context, int index) =>
                  const Divider(),
            ),
          ),
          BottomAppBar(
            child: Row(
              children: [
                Column(
                  children: [
                    Text("Tax: ${(widget.cart.gettotal() * 0.13).toStringAsFixed(2)}"),
                    Text("Total: ${(widget.cart.gettotal() + (widget.cart.gettotal() * 0.13)).toStringAsFixed(2)}"),
                  ],
                ),
                const Spacer(),
                ElevatedButton(onPressed: () async{
                  final result = await Navigator.of(context)
                      .push(MaterialPageRoute(builder: (context) {
                    return _checkoutpage(user1, widget.cart);
                  }));
                }, style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.green),
                    child: Text("Checkout",
                      style: TextStyle(color: Colors.white)
                    ))
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _CartHistoryPage extends StatelessWidget {
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
        body: ListView.separated(
          itemCount: user.history.length,
          itemBuilder: (BuildContext context, int index) {
            return GestureDetector(
              onTap: () async {
                final result = await Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) =>
                            _CartHistoryPageView(user.history[index])));
              },
              child: Container(
                child: ListTile(
                  shape: RoundedRectangleBorder(
                      side: BorderSide(color: Colors.grey, width: 1),
                      borderRadius: BorderRadius.circular(5)),
                  title: Text(user.history[index].date),
                  trailing: Text(
                      "${(user.history[index].gettotalwithtax()).toStringAsFixed(2)}"),
                ),
              ),
            );
          },
          separatorBuilder: (BuildContext context, int index) =>
              const Divider(),
        ));
  }
}

class _CartHistoryPageView extends StatelessWidget {
  final Cart cart;

  _CartHistoryPageView(this.cart);

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
              separatorBuilder: (BuildContext context, int index) =>
                  const Divider(),
            ),
          ),
          BottomAppBar(
            child: Row(
              children: [
                const Spacer(),
                Column(
                  children: [
                    Text("Tax: ${(cart.gettotal() * 0.13).toStringAsFixed(2)}"),
                    Text("Total: ${(cart.gettotal() + (cart.gettotal() * 0.13)).toStringAsFixed(2)}"),
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

class _settingspage extends StatelessWidget {
  User currentuser;
  final TextEditingController cardNumberController = TextEditingController();
  final TextEditingController expiryDateController = TextEditingController();
  final TextEditingController securityCodeController = TextEditingController();

  _settingspage(this.currentuser);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text("Settings"),
      ),
      body: Column(
        children: [
          Padding(padding: EdgeInsets.all(24.0),
            child: Row(
              children: [
                const Text("Name: "),
                Expanded(child: TextFormField(
                  initialValue: currentuser.name,
                  onChanged: (text){
                    currentuser.name = text;
                  },
                  decoration: InputDecoration(
                    border: OutlineInputBorder()
                  ),
                ))
              ],
            ),
          ),
          SizedBox(height: 24),
          Text(
            "Add New Payment Method",
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
          ),
          SizedBox(height: 8),
          TextField(
            controller: cardNumberController,
            keyboardType: TextInputType.number,
            decoration: InputDecoration(
              labelText: "Credit Card Number",
              border: OutlineInputBorder(),
            ),
          ),
          SizedBox(height: 16),

          TextField(
            controller: expiryDateController,
            keyboardType: TextInputType.datetime,
            decoration: InputDecoration(
              labelText: "Expiry Date (MM/YY)",
              border: OutlineInputBorder(),
            ),
          ),
          SizedBox(height: 16),

          TextField(
            controller: securityCodeController,
            keyboardType: TextInputType.number,
            decoration: InputDecoration(
              labelText: "Security Code (CVV)",
              border: OutlineInputBorder(),
            ),
          ),
          SizedBox(height: 24),

          Center(
            child: ElevatedButton(
              onPressed: () {
                // Validate inputs
                if (cardNumberController.text.isEmpty ||
                    expiryDateController.text.isEmpty ||
                    securityCodeController.text.isEmpty) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text("All fields are required!")),
                  );
                  return;
                }

                try {
                  final newPaymentMethod = Paymentmethod(
                    cardNumberController.text,
                    expiryDateController.text,
                    int.parse(securityCodeController.text),
                  );
                  currentuser.addpaymentmethod(newPaymentMethod);

                  cardNumberController.clear();
                  expiryDateController.clear();
                  securityCodeController.clear();

                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text("Payment method added successfully!")),
                  );
                } catch (e) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text("Invalid input: $e")),
                  );
                }
              },
              child: Text("Add Payment Method"),
            ),
          ),
        ],
      ),
    );
  }
}

class _checkoutpage extends StatelessWidget{
  User currentuser;
  Cart newcart;

  _checkoutpage(this.currentuser, this.newcart);

  @override
  Widget build(BuildContext context) {

    Paymentmethod selectedPaymentMethod = currentuser.paymentmethods.first;

    return Scaffold(
      appBar: AppBar(
        title: Text("Checkout"),
        centerTitle: true,
      ),
      body: Padding(
          padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Hello, ${currentuser.name}',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 16),
            Text(
              'Total Cost:',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
            ),
            SizedBox(height: 8),
            Text(
              '\$${newcart.gettotalwithtax().toStringAsFixed(2)}',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.green),
            ),
            SizedBox(height: 24),
            Text(
              'Select Payment Method:',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
            ),
            SizedBox(height: 8),
            DropdownButton<Paymentmethod>(
              value: selectedPaymentMethod,
              items: currentuser.paymentmethods
                  .map((method) => DropdownMenuItem<Paymentmethod>(
                value: method,
                  child: Text('Card ending in ${method.creditcartnumber.substring(method.creditcartnumber.length - 4)}')              ))
                  .toList(),
              onChanged: (newMethod) {
                if (newMethod != null) {
                  selectedPaymentMethod = newMethod;
                }
              },
              isExpanded: true,
            ),
            SizedBox(height: 32),
            Center(
              child: ElevatedButton(
                onPressed: () {
                  // Add the cart to the user's purchase history
                  currentuser.history = List.from(currentuser.history)..add(newcart);

                  // Show a confirmation dialog
                  showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return AlertDialog(
                        title: Text('Purchase Confirmed'),
                        content: Text('Your order has been successfully placed!'),
                        actions: [
                          TextButton(
                            onPressed: () {
                              Navigator.pop(context);
                              Navigator.pop(context);
                              Navigator.pop(context);
                              Navigator.pop(context); // Return all the way home
                            },
                            child: Text('OK'),
                          ),
                        ],
                      );
                    },
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.greenAccent,
                  padding: EdgeInsets.symmetric(horizontal: 40, vertical: 15),
                ),
                child: Text(
                  'Submit Order',
                  style: TextStyle(fontSize: 18),
                ),
              ),
            ),
          ],
        )
      ),
    );
  }
}