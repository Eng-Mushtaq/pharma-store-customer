import '../Products/products_cubit.dart';

class OrdersModel {
  OrdersModel({
    required this.data,
  });
  late final List<OrderModel> data;

  OrdersModel.fromJson(Map<String, dynamic> json){
    data = List.from(json['data']).map((e)=>OrderModel.fromJson(e)).toList();
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['data'] = data.map((e)=>e.toJson()).toList();
    return _data;
  }
}

class OrderModel {
  OrderModel({
    required this.id,
    required this.userId,
    required this.totalPrice,
    required this.status,
    required this.createdAt,
    required this.updatedAt,
    required this.details,
  });
  late final int id;
  late final int userId;
  late final String totalPrice;
  late final String status;
  late final String createdAt;
  late final String updatedAt;
  late final List<Details> details;

  OrderModel.fromJson(Map<String, dynamic> json){
    id = json['id'];
    userId = json['user_id'];
    totalPrice = json['total_price'];
    status = json['status'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    details = List.from(json['details']).map((e)=>Details.fromJson(e)).toList();
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['id'] = id;
    _data['user_id'] = userId;
    _data['total_price'] = totalPrice;
    _data['status'] = status;
    _data['created_at'] = createdAt;
    _data['updated_at'] = updatedAt;
    _data['details'] = details.map((e)=>e.toJson()).toList();
    return _data;
  }
}

class Details {
  Details({
    required this.id,
    required this.orderId,
    required this.productId,
    required this.quantity,
    required this.totalPrice,
    required this.createdAt,
    required this.updatedAt,
    required this.product,
  });
  late final int id;
  late final int orderId;
  late final int productId;
  late final int quantity;
  late final String totalPrice;
  late final String createdAt;
  late final String updatedAt;
  late final ProductModel product;

  Details.fromJson(Map<String, dynamic> json){
    id = json['id'];
    orderId = json['order_id'];
    productId = json['product_id'];
    quantity = json['quantity'];
    totalPrice = json['total_price'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    product = ProductModel.fromJson(json['product']);
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['id'] = id;
    _data['order_id'] = orderId;
    _data['product_id'] = productId;
    _data['quantity'] = quantity;
    _data['total_price'] = totalPrice;
    _data['created_at'] = createdAt;
    _data['updated_at'] = updatedAt;
    _data['product'] = product.toJson();
    return _data;
  }
}

class Product {
  Product({
    required this.id,
    required this.name,
    this.name_2,
    this.image,
    required this.categoryId,
    required this.qty,
    required this.expDate,
    required this.price,
    required this.discount,
    required this.description,
    this.deletedAt,
    required this.createdAt,
    required this.updatedAt,
  });
  late final int id;
  late final String name;
  late final Null name_2;
  late final Null image;
  late final int categoryId;
  late final int qty;
  late final String expDate;
  late final String price;
  late final String discount;
  late final String description;
  late final Null deletedAt;
  late final String createdAt;
  late final String updatedAt;

  Product.fromJson(Map<String, dynamic> json){
    id = json['id'];
    name = json['name'];
    name_2 = null;
    image = null;
    categoryId = json['category_id'];
    qty = json['qty'];
    expDate = json['exp_date'];
    price = json['price'];
    discount = json['discount'];
    description = json['description'];
    deletedAt = null;
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['id'] = id;
    _data['name'] = name;
    _data['name_2'] = name_2;
    _data['image'] = image;
    _data['category_id'] = categoryId;
    _data['qty'] = qty;
    _data['exp_date'] = expDate;
    _data['price'] = price;
    _data['discount'] = discount;
    _data['description'] = description;
    _data['deleted_at'] = deletedAt;
    _data['created_at'] = createdAt;
    _data['updated_at'] = updatedAt;
    return _data;
  }
}