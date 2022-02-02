
class ProductModel {
  String name;
  String category;
  String description;
  String pId;
  String price;
  String disCount;
  int count;
  String imageUrl;
  String vendorId;
  List<dynamic>colors=[];
  List<dynamic>size=[];

  ProductModel({
    this.category,
    this.count,
    this.description,
    this.disCount,
    this.imageUrl,
    this.name,
    this.pId,
    this.price,
    this.vendorId,
    this.colors,
    this.size,
  });

  ProductModel.fromJson(Map<String, dynamic> json) {
    category = json['category'];
    count = json['count'];
    description = json['description'];
    disCount = json['disCount'];
    imageUrl = json['imageUrl'];
    name = json['name'];
    pId = json['pId'];
    price = json['price'];
    vendorId = json['vendorId'];
    colors=json['colors'];
    size=json['size'];
  }

  Map<String, dynamic> toMap() {
    return {
      'category': category,
      'count': count,
      'description': description,
      'disCount': disCount,
      'imageUrl': imageUrl,
      'name': name,
      'pId': pId,
      'price': price,
      'vendorId': vendorId,
      'colors':colors,
      'size':size,
    };
  }
}
