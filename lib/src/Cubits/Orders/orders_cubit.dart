import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_storage/get_storage.dart';
import 'package:pharmacy_warehouse_store_mobile/main.dart';
import 'package:pharmacy_warehouse_store_mobile/src/model/order.dart';
import 'package:pharmacy_warehouse_store_mobile/src/model/user.dart';
import 'package:pharmacy_warehouse_store_mobile/src/services/api.dart';

import 'orders_list_model.dart';
import 'package:http/http.dart' as http;

part 'orders_state.dart';

class OrdersCubit extends Cubit<OrdersState> {
  OrdersCubit() : super(OrdersInitial());

  void getOrders() async {
    try {
      emit(OrdersFetchLoading());
      String token = GetStorage().read('token') ?? "";
      var headers = {
        'Accept': 'application/json',
        'Authorization': 'Bearer $token',
      };
      var request = await http.get(
           Uri.parse('${Api.baseUrl}orders'),headers: headers,);
      // request.fields
      //     .addAll({'id': '${product.id}', 'qty': '${product.countInCart}'});
      // request.headers.addAll(headers);

      // http.StreamedResponse response = await request.send();
      print(request.statusCode);
      print(request.body);
      if (request.statusCode == 200) {
        var data=jsonDecode(request.body);
        var orders = OrdersModel.fromJson(data);
        if (orders.data.isEmpty) {
          emit(OrdersFetchEmpty());
        } else {
          emit(OrdersFetchSuccess(orders: orders.data));
        }
        // emit(CartAddSuccess());
        // print(await response.stream.bytesToString());
      } else {
        // print(response.reasonPhrase);
      }
      // Map<String, dynamic> ordersJsonData = await Api.request(
      //     url: 'orders',
      //     body: {},
      //     token: User.token,
      //     methodType: MethodType.get);
      // as Map<String, dynamic>;
      // var orders = OrdersModel.fromJson(ordersJsonData);
      // if (orders.data.isEmpty) {
      //   emit(OrdersFetchEmpty());
      // } else {
      //   emit(OrdersFetchSuccess(orders: orders.data));
      // }
    } on DioException catch (exception) {
      logger.e("Orders Cubit : \nNetwork Failure \n${exception.message}");
      emit(OrdersNetworkFailure(errorMessage: exception.message.toString()));
    } catch (e) {
      logger.e("Orders Cubit : \nFetch Failure \n$e");
      emit(OrdersFetchFailure(errorMessage: e.toString()));
    }
  }

  void getOrder({required int id}) async {
    try {
      emit(OrderFetchLoading());
      Map<String, dynamic> orderJsonData = await Api.request(
          url: 'api/carts/$id',
          body: {},
          token: User.token,
          methodType: MethodType.get) as Map<String, dynamic>;
      Order order = Order.fromJson(orderJsonData['data']);
      emit(OrderFetchSuccess(order: order));
    } on DioException catch (exception) {
      logger.e("Orders Cubit : \nNetwork Failure \n${exception.message}");
      emit(OrderNetworkFailure(errorMessage: exception.message.toString()));
    } catch (e) {
      logger.e("Orders Cubit : \nFetch Failure \n$e");
      emit(OrderFetchFailure(errorMessage: e.toString()));
    }
  }
}
