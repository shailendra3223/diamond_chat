/*
import 'dart:convert';


import 'package:http/http.dart' as http;

import '../client/dioClient.dart';
import '../ui/login/login_data.dart';

abstract class ApiService {
  static var client = http.Client();

  static final DioClient _dioClient = DioClient();

  static Future<LoginResponse> fetchProduct() async {
    try {
      var response = await _dioClient.get(ConstantBaseUrl.baseurl +
          "productsticket/livesale?id_customer=3&limit=0,10");
      if (response["success"] == true) {
        return CurrentBidModel.fromJson(response);
      }
    } on Error catch (e) {
      print('Error: $e');
    }
  }

  */
/* --------------------------- Todo Product Details ToDO----------------------- *//*


  static Future<ProductDetailsData> fetchproduct_Details(
      dynamic productId) async {
    var responseProductDetails = await _dioClient.get(
        ConstantBaseUrl.baseurl + "products",
        queryParameters: {"id_product": productId});
    if (responseProductDetails["success"] == true) {
      print(responseProductDetails);
      return ProductDetailsData.fromJson(responseProductDetails);
    }
  }

  */
/* --------------------------- Todo Add To Cart ToDO----------------------- *//*


  static Future<AddtoCartModel> AddtoCart(dynamic data) async {
    var responsecart = await _dioClient
        .post("https://api.100percentback.in/app/v1/api/cart", data: data);
    return AddtoCartModel.fromJson(responsecart);
  }

*/
/* --------------------------- Todo Ticket History ToDO----------------------- *//*


  static Future<TicketOrderdHistory>  TicketHistory() async{
    try {
      var ticketHistoryResponse= await _dioClient.get(ConstantBaseUrl.baseurl +
          "order/details/tickets?id_customer=232&limit=0,10");
      if (ticketHistoryResponse["success"] == true) {
        return TicketOrderdHistory.fromJson(ticketHistoryResponse);
      }
      print(ticketHistoryResponse);
    } on Error catch (e) {
      print('Error: $e');
    }
  }
}
*/
