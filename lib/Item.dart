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


  User(this.history, this.name);

  void addcart(Cart newcart){
    history.add(newcart);
  }
}