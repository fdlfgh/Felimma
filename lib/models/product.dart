import 'package:cloud_firestore/cloud_firestore.dart';

class ProductModel {
  static const ID = "id";
  static const NAME = "name";
  static const PICTURE = "picture";
  static const PRICE = "price";
  static const DESCRIPTION = "description";
  static const CATEGORY = "category";
  static const FEATURED = "featured";
  static const BRAND = "brand";
  static const SALE = "sale";
  static const DURATION = "duration";
  static const PHONENUMBER = "phoneNumber";
  static const ADDRESS = "address";


  String _id;
  String _name;
  String _picture;
  String _description;
  String _category;
  String _brand;
  String _phoneNumber;
  String _address;
  int _price;
  bool _sale;
  bool _featured;
  List _duration;

  String get id => _id;

  String get name => _name;

  String get picture => _picture;

  String get brand => _brand;

  String get category => _category;

  String get description => _description;

  String get phoneNumber => _phoneNumber;

  String get address => _address;


  int get price => _price;

  bool get featured => _featured;

  bool get sale => _sale;

  List get duration => _duration;

  ProductModel.fromSnapshot(DocumentSnapshot snapshot) {
    _id = snapshot.data[ID];
    _brand = snapshot.data[BRAND];
    _sale = snapshot.data[SALE];
    _description = snapshot.data[DESCRIPTION] ?? " ";
    _featured = snapshot.data[FEATURED];
    _price = snapshot.data[PRICE].floor();
    _category = snapshot.data[CATEGORY];
    _duration = snapshot.data[DURATION];
    _name = snapshot.data[NAME];
    _address = snapshot.data[ADDRESS];
    _phoneNumber = snapshot.data[PHONENUMBER];
    _picture = snapshot.data[PICTURE];

  }
}
