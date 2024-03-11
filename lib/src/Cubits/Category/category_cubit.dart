import 'package:dio/dio.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';
import 'package:pharmacy_warehouse_store_mobile/main.dart';
import 'package:pharmacy_warehouse_store_mobile/src/model/category.dart';
import 'package:pharmacy_warehouse_store_mobile/src/model/user.dart';
import 'package:pharmacy_warehouse_store_mobile/src/services/api.dart';

part 'category_state.dart';

class CategoryCubit extends Cubit<CategoryState> {
  CategoryCubit() : super(CategoryInitial());
  List<Category>? currentCategories;
  Future<void> getCategories() async {
    try {
      emit(CategoryFetchLoading());

      // Fetch Categories from API
      Map<String, dynamic> categoriesJsonData = await Api.request(
          url: 'category',
          body: {},
          token: User.token,
          methodType: MethodType.get) as Map<String, dynamic>;
   var cata=   CategoryResponseModel.fromJson(categoriesJsonData);
      // List<Category> categories = Category.fromListJson(categoriesJsonData);
      // currentCategories = categories;
      // categories.insert(0, Category(id: 0, name: "All".tr));

      // await Future.delayed(const Duration(seconds: 2));
      // List<Category> categories = AppData.categories;
      emit(CategoryFetchSuccess(categories: cata.data));
    } on DioException catch (exception) {
      logger.e("Category Cubit Fetch : \nNetwork Failure ");
      emit(CategoryNetworkFailure(errorMessage: exception.message.toString()));
    } catch (e) {
      logger.e("Category Cubit Fetch : \nFetch Failure ");
      emit(CategoryFetchFailure(errorMessage: e.toString()));
    }
  }
}
class CategoryResponseModel {
  CategoryResponseModel({
    required this.data,
  });
  late final List<Category> data;

  CategoryResponseModel.fromJson(Map<String, dynamic> json){
    data = List.from(json['data']).map((e)=>Category.fromJson(e)).toList();
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['data'] = data.map((e)=>e.toJson()).toList();
    return _data;
  }
}

class Category {
  Category({
    required this.id,
    required this.name,
     this.createdAt,
     this.updatedAt,
  });
  late final int id;
  late final String name;
  late final String? createdAt;
  late final String? updatedAt;

  Category.fromJson(Map<String, dynamic> json){
    id = json['id'];
    name = json['name'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['id'] = id;
    _data['name'] = name;
    _data['created_at'] = createdAt;
    _data['updated_at'] = updatedAt;
    return _data;
  }
}