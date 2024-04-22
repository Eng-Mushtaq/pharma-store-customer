import 'package:dio/dio.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';
import 'package:pharmacy_warehouse_store_mobile/main.dart';
import 'package:pharmacy_warehouse_store_mobile/src/model/category.dart';
import 'package:pharmacy_warehouse_store_mobile/src/model/product.dart';
import 'package:pharmacy_warehouse_store_mobile/src/model/user.dart';
import 'package:pharmacy_warehouse_store_mobile/src/services/api.dart';

import '../Category/category_cubit.dart';
part 'products_state.dart';

class SearchConstraints {
  const SearchConstraints._();
  static const String name = 'name';
  static const String scientificName = 'scientificName';
  static const String description = 'description';
  static const String brand = 'brand';
}

class ProductsCubit extends Cubit<ProductsState> {
  ProductsCubit() : super(ProductsInitial());
  String searchBarContent = "";
  Category choosenCategory = Category(id: 0, name: "All".tr);
  String searchByConstraints = SearchConstraints.name;

  Future<void> search(int? category) async {
    // logger.i(
    //     "Product Cubit Search : \nChooosen category name : ${choosenCategory.name} \nSearch bar content : $searchBarContent \nSearch By constraints : $searchByConstraints");
    try {
      emit(ProductsFetchLoading());

      String endpoint = '';
      // bool isAllChoosen = (choosenCategory.name.toString() == "All" ||
      //     choosenCategory.name.toString() == "الكل");

      // if (searchBarContent == "" && isAllChoosen) {
      //   endpoint = 'api/medicines';
      // } else if (searchBarContent == "" && !isAllChoosen) {
      //   endpoint = 'api/categories/${choosenCategory.id}';
      // } else if (searchBarContent != "" && isAllChoosen) {
      //   endpoint = 'api/search/$searchBarContent/$searchByConstraints';
      // } else if (searchBarContent != "" && !isAllChoosen) {
      //   endpoint =
      //       'api/search/${choosenCategory.id}/$searchBarContent/$searchByConstraints';
      // }

      // Fetch Searched Products from API
      String url='products';
      print("choosenCategory.name");
      print(choosenCategory.name);
      Map<String, dynamic> productsJsonData = await Api.request(
          url: 'products?cat_id=${category}',
          body: null,
          token: User.token,
          methodType: MethodType.get) as Map<String, dynamic>;
      // List<Product> products = Product.fromListJson(productsJsonData);
      var pro = ProductsListModel.fromJson(productsJsonData);
      // await Future.delayed(const Duration(seconds: 2));
      // List<Product> products = AppData.filteredProducts[choosenCategory.id];
      if (pro.data.isEmpty) {
        emit(ProductsNotFound());
        logger.e("Product Cubit Search : \nProduct Not Found");
      } else {
        emit(ProductsFetchSuccess(products: pro.data));
      }
    } on DioException catch (exception) {
      logger.e("Product Cubit Search : \nNetwork Failure");
      emit(ProductNetworkFailure(errorMessage: exception.message.toString()));
    } catch (e) {
      logger.e("Product Cubit Search : \nFetch Failure");
      emit(ProductsFetchFailure(errorMessage: e.toString()));
    }
  }

  Future<void> getFavourites() async {
    try {
      emit(ProductsFetchLoading());

      // Fetch Favourite Products from API
      Map<String, dynamic> favouriteJsonData = await Api.request(
          url: 'products',
          body: {},
          token: User.token,
          methodType: MethodType.get) as Map<String, dynamic>;
      // List<Product> favouriteProducts = Product.fromListJson(favouriteJsonData);
      var prod = ProductsListModel.fromJson(favouriteJsonData);
      // await Future.delayed(const Duration(seconds: 2));
      // List<Product> favouriteProducts = AppData.products;
      if (prod.data.isEmpty) {
        emit(ProductsNotFound());
        logger.e("Product Cubit Favourite : \nProduct Not Found");
      } else {
        emit(ProductsFetchSuccess(products: prod.data));
      }
    } on DioException catch (exception) {
      logger.e("Product Cubit Favourite : \nNetwork Failure ");
      emit(ProductNetworkFailure(errorMessage: exception.message.toString()));
    } catch (e) {
      logger.e("Product Cubit Favourite : \nFetch Failure ");
      emit(ProductsFetchFailure(errorMessage: e.toString()));
    }
  }
}

class ProductsListModel {
  ProductsListModel({
    required this.data,
  });
  late final List<ProductModel> data;

  ProductsListModel.fromJson(Map<String, dynamic> json) {
    data =
        List.from(json['data']).map((e) => ProductModel.fromJson(e)).toList();
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['data'] = data.map((e) => e.toJson()).toList();
    return _data;
  }
}

class ProductModel {
  ProductModel({
    required this.id,
    required this.name,
    this.name_2,
    this.image,
    required this.categoryId,
    required this.qty,
    this.expDate,
    required this.price,
    required this.discount,
    required this.description,
    this.deletedAt,
    required this.createdAt,
    required this.updatedAt,
  });
  late final int id;
  late final String name;
  late final String? name_2;
  late final String? image;
  late final int? categoryId;
  late int qty;
  int countInCart = 0;
  late final String? expDate;
  late final num price;
  late final String? discount;
  late final String? description;
  late final Null deletedAt;
  late final int? inStock;
  late final bool isFavorite;
  late final String? createdAt;
  late final String? updatedAt;

  ProductModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    name_2 = json['name'];
    image = json['image'];
    categoryId = json['category_id'];
    qty = json['qty'] ?? 0;
    expDate = json['exp_date'];
    price = num.parse(json['price']);
    discount = json['discount'];
    description = json['description'];
    deletedAt = null;
    inStock = json['qty'] ?? 0;
    isFavorite = json['is_favorite'] ?? false;
    updatedAt = json['updated_at'] ?? "";
    // updatedAt = json['updated_at']??"";
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
