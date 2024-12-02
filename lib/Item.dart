class Item{
  int itemid;
  String itemname;
  String itemimgurl;
  double cost;

  Item(this.itemid, this.itemname, this.itemimgurl, this.cost);
}

class Cart{
  List<Item> items;
  String date;

  Cart(this.items, this.date);

  void additem(Item item){
    items.add(item);

    items.sort((a, b) {
      return a.itemname.compareTo(b.itemname);
    });
  }

  void removeItem(Item item) {
    items.remove(item);

    items.sort((a, b) {
      return a.itemname.compareTo(b.itemname);
    });
  }

  double gettotal(){
    double total = 0;
    for (int i=0; i< items.length; i++){
      total += items[i].cost;
    }
    return total;
  }

  double gettotalwithtax(){
    return (gettotal() + (gettotal()*0.13));
  }
}

class User{
  List<Cart> history;
  String name;
  List<Paymentmethod> paymentmethods;

  User(this.history, this.name, this.paymentmethods);

  void addcart(Cart newcart){
    history.add(newcart);
  }

  void addpaymentmethod(Paymentmethod newmethod){
    paymentmethods.add(newmethod);
  }
}

class Paymentmethod{
  String creditcartnumber;
  String expirydate;
  int securitycode;

  Paymentmethod(this.creditcartnumber, this.expirydate, this.securitycode);
}