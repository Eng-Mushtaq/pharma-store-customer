import 'package:dio/dio.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pharmacy_warehouse_store_mobile/main.dart';
import 'package:pharmacy_warehouse_store_mobile/src/model/product.dart';
import 'package:pharmacy_warehouse_store_mobile/src/model/user.dart';
import 'package:pharmacy_warehouse_store_mobile/src/services/api.dart';

import '../Products/products_cubit.dart';
part 'home_state.dart';

class HomeProductsType {
  const HomeProductsType._();
  static const mostPopular = "Most Popular";
  static const recentlyAdded = "Recently Added";
}

class HomeCubit extends Cubit<HomeState> {
  HomeCubit() : super(HomeInitial());

  Future<void> getHomeProducts() async {
    try {
      emit(HomeProductsFetchLoading());

      // Fetch Most Popular Products from API
      dynamic mostPopularJsonData = await Api.request(
          url: 'products/last',
          body: {},
          token: User.token,
          methodType: MethodType.get);
      // List<Product> mostPopularProducts =
      //     Product.fromListJson(mostPopularJsonData);
      var prod = ProductsListModel.fromJson(mostPopularJsonData);
      // Fetch Recently Added Products from API
      Map<String, dynamic> recentlyAddedJsonData = await Api.request(
          url: 'products/last',
          body: {},
          token: User.token,
          methodType: MethodType.get) as Map<String, dynamic>;
      // List<Product> recentlyAddedProducts =
      //     Product.fromListJson(recentlyAddedJsonData);
      var recent = ProductsListModel.fromJson(recentlyAddedJsonData);

      // await Future.delayed(const Duration(seconds: 2));
      // List<Product> mostPopularProducts = AppData.products;
      // List<Product> recentlyAddedProducts = AppData.products;
      emit(HomeProductsFetchSucess(
          mostPopular: prod.data, recentlyAdded: recent.data));
    } on DioException catch (exception) {
      logger.e("Home Cubit Fetch Products : \nNetwork Failure");
      emit(HomeNetworkFailure(errorMessage: exception.message.toString()));
    } catch (e) {
      logger.e("Home Cubit Fetch Products : \nFetch Failure+${e.toString()}");
      emit(HomeProductsFetchFailure(errorMessage: e.toString()));
    }
  }
}
