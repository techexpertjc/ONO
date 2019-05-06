class Item{
  String _itemname;
  int _id;
  int _price;
  int _qty;
  String _url;

  Item(this._itemname,this._price,this._qty,this._url);

  Item.map(dynamic obj) {
    this._itemname = obj['itemname'];
    this._price = obj['price'];
    this._id = obj['id'];
    this._qty=obj['qty'];
    this._url=obj['url'];
  }

  String get itemname => _itemname;
  int get id => _id;
  int get qty => _qty;
  int get price => _price;
  String get url => _url;

  Map<String, dynamic> toMap(){
    var map = new Map<String, dynamic>();
    map['itemname']=_itemname;
    map['price']=_price;
    map['qty']=_qty;
    map['url']=_url;
    if (id != null) {
      map["id"] = _id;
    }
    return map;
  }

  Item.fromMap(Map<String,dynamic> map) {
    this._itemname=map['itemname'];
    this._price=map['price'];
    this._qty=map['qty'];
    this._id=map['id'];
    this._url=map['url'];
  }  

}