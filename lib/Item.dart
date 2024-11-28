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
}