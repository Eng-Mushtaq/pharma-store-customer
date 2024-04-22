import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_storage/get_storage.dart';
import 'package:http/http.dart' as http;
import 'package:pharmacy_warehouse_store_mobile/src/model/product.dart';
import 'package:pharmacy_warehouse_store_mobile/main.dart';
import 'package:pharmacy_warehouse_store_mobile/src/model/user.dart';
import 'package:pharmacy_warehouse_store_mobile/src/services/api.dart';

import '../Products/products_cubit.dart';
import 'check_out_model.dart';
part 'cart_state.dart';

class CartCubit extends Cubit<CartState> {
  CartCubit() : super(CartInitial());
  List<ProductModel> cartProducts = [];
  int totalPrice = 0;

  Future<void> addToCart(
      {required ProductModel product, required int quantity}) async {
    // try {
    emit(CartAddLoading());
    String token = GetStorage().read('token') ?? "";
    // Product already exist; increase quantity
    print("token");
    print(token);
    print(cartProducts.length);
    if (cartProducts.where((element) => element.id == product.id).isEmpty) {
      cartProducts.add(product);
    }
    for (int i = 0; i < cartProducts.length; i++) {
      print('9999999999999999999999');
      if (cartProducts[i].id == product.id) {
        // if (cartProducts[i].qty + quantity <=
        //     cartProducts[i].inStock!.toInt()) {
        product.countInCart = quantity;
        // product.countInCart += quantity;
        totalPrice = quantity * product.price.toInt();
        // totalPrice += quantity * product.price.toInt();
        var headers = {
          'Accept': 'application/json',
          'Authorization': 'Bearer $token',
        };
        var request =
            http.MultipartRequest('POST', Uri.parse('${Api.baseUrl}cart/add'));
        request.fields.addAll({'id': '${product.id}', 'qty': '${quantity}'});

        request.headers.addAll(headers);

        http.StreamedResponse response = await request.send();
        print(response.statusCode);
        if (response.statusCode == 200) {
          emit(CartAddSuccess());
          print(await response.stream.bytesToString());
        } else {
          print(response.reasonPhrase);
        }

        // var response = await Api.request(
        //     url: 'cart/add',
        //     body: {
        //       'id': product.id,
        //       // cartProducts[i].id,
        //       'qty': product.qty,
        //       // cartProducts[i].qty,
        //     },
        //     token: User.token,
        //     methodType: MethodType.post);
        print("response.toString()");
        print(response.toString());
        // List<Product> favouriteProducts = Product.fromListJson(favouriteJsonData);
        // var prod = ProductsListModel.fromJson(favouriteJsonData);
        // emit(CartAddSuccess());
        logger.i("Current cart products :$cartProducts");
        // } else {
        //   // throw Exception();
        // }
        return;
      }

      // Product do not exist: add it to list
      if (quantity <= product.inStock!.toInt()) {
        if (quantity <= product.qty) {
          product.qty = quantity;
          //   cartProducts.add(product);
          totalPrice += (product.qty * product.price.toInt());
          //   emit(CartAddSuccess());
          //   logger.i("Current cart products :$cartProducts");
        } else {
          emit(CartAddFailure());
          throw Exception();
        }
      }
    }
    // } catch (e) {
    //   logger.e("Cart Cubit Add to Cart : \nAdd Failure ");
    //   emit(CartAddFailure());
    // }
  }

  Future<void> increaseProductAmount({required ProductModel product}) async {
    String token = GetStorage().read('token') ?? "";
    for (int i = 0; i < cartProducts.length; i++) {
      if (cartProducts[i].id == product.id) {
        // if (cartProducts[i].qty + 1 <= cartProducts[i].inStock) {
        // if (cartProducts[i].qty + 1 <= cartProducts[i].qty) {
        cartProducts[i].countInCart++;
        totalPrice += product.price.toInt();
        var headers = {
          'Accept': 'application/json',
          'Authorization': 'Bearer $token',
        };
        var request = http.MultipartRequest(
            'POST', Uri.parse('http://192.168.0.17:8000/api/cart/add'));
        request.fields
            .addAll({'id': '${product.id}', 'qty': '${product.countInCart}'});

        request.headers.addAll(headers);

        http.StreamedResponse response = await request.send();
        print(response.statusCode);
        if (response.statusCode == 200) {
          emit(CartAddSuccess());
          print(await response.stream.bytesToString());
        } else {
          print(response.reasonPhrase);
        }

        emit(CartProductsChange());
        logger.i("Current cart products :$cartProducts");
        return;
      }
      // }
    }
  }

  Future<void> decreaseProductAmount({required ProductModel product}) async {
    String token = GetStorage().read('token') ?? "";
    for (int i = 0; i < cartProducts.length; i++) {
      if (cartProducts[i].id == product.id) {
        if (cartProducts[i].countInCart > 0) {
          cartProducts[i].countInCart--;
          var headers = {
            'Accept': 'application/json',
            'Authorization': 'Bearer $token',
          };
          var request = http.MultipartRequest(
              'POST', Uri.parse('http://192.168.0.17:8000/api/cart/add'));
          request.fields
              .addAll({'id': '${product.id}', 'qty': '${product.countInCart}'});
          request.headers.addAll(headers);

          http.StreamedResponse response = await request.send();
          print(response.statusCode);
          if (response.statusCode == 200) {
            emit(CartAddSuccess());
            print(await response.stream.bytesToString());
          } else {
            print(response.reasonPhrase);
          }

          if (cartProducts[i].countInCart == 0) {
            cartProducts.removeAt(i);
          }
          totalPrice -= product.price.toInt();
          emit(CartProductsChange());
          logger.i("Current cart products :$cartProducts");
          return;
        }
      }
    }
  }

  Future<void> purchaseCart() async {
    try {
      emit(CartPurchaseLoading());
      //await Future.delayed(const Duration(seconds: 2));
      String token = GetStorage().read('token') ?? "";
      var headers = {
        'Accept': 'application/json',
        'Authorization': 'Bearer $token',
      };
      var request = await http.get(
        Uri.parse('${Api.baseUrl}cart/checkout'), headers: headers,);
      // request.fields
      //     .addAll({'id': '${product.id}', 'qty': '${product.countInCart}'});
      // request.headers.addAll(headers);

      // http.StreamedResponse response = await request.send();
      print(request.statusCode);
      print(request.body);
      if (request.statusCode == 200) {
        var data = jsonDecode(request.body);
        var res = CheckOutModel.fromJson(data);
        totalPrice = 0;
        emit(CartPurchaseSuccess());
        cartProducts.clear();
        // if (orders.data.isEmpty) {
        // emit(OrdersFetchEmpty());
        // } else {
        // emit(OrdersFetchSuccess(orders: orders.data));
        // }
        ///todo to json cart
//       Api.request(
//           url: 'api/carts',
//           body: Product.toJsonCart(cartProducts),
//           token: User.token,
//           methodType: MethodType.post);

        // logger.i(Product.toJsonCart(cartProducts));
        totalPrice = 0;
        emit(CartPurchaseSuccess());
        cartProducts.clear();
      }
    }
      on DioException catch (e) {
      logger.e("Cart Cubit Purchase : \nNetwork Failure ");
      emit(CartNetworkFailure(errorMessage: e.message.toString()));
    } catch (e) {
      logger.e("Cart Cubit Purchase : \nPurchase Failure ");
      logger.e(e.toString());
      emit(CartPurchaseFailure(errorMessage: e.toString()));
    }
  }
}
