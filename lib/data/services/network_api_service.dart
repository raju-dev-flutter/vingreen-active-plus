import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';

import 'app_exception.dart';
import 'base_api_service.dart';

class NetworkApiService extends BaseApiServices {
  @override
  Future<dynamic> getGetApiResponse(String url) async {
    dynamic responseJson;
    try {
      final response =
          await http.get(Uri.parse(url)).timeout(const Duration(seconds: 10));
      responseJson = returnResponse(response);
    } on SocketException {
      throw FetchDataException('No Internet Connection');
    }
    return responseJson;
  }

  @override
  Future<dynamic> getPostApiResponse(String url, dynamic data) async {
    dynamic responseJson;
    Map<String, String> headers = {
      "Content-Type": "application/json",
      "Accept": "application/json",
    };
    try {
      Response response = await post(
        Uri.parse(url),
        body: json.encode(data),
        headers: headers,
        encoding: Encoding.getByName("utf-8"),
      ).timeout(const Duration(seconds: 10));

      debugPrint(response.statusCode.toString());

      responseJson = returnResponse(response);
    } on SocketException {
      throw FetchDataException('No Internet Connection');
    }

    return responseJson;
  }

  @override
  Future<dynamic> getXFilePostApiResponse(
      String url, Map<String, String> data, XFile attachment) async {
    dynamic responseJson;
    Map<String, String> headers = {
      "Content-Type": "application/x-www-form-urlencoded",
      "Content-type": "application/json"
    };

    // debugPrint(data.toString());
    try {
      var request = http.MultipartRequest('POST', Uri.parse(url));
      request.headers.addAll(headers);
      // ============================== \\

      request.fields.addAll(data);

      request.files.add(
          await http.MultipartFile.fromPath('profile_upload', attachment.path));
      // ============================== \\

      var requested = await request.send();
      var response = await http.Response.fromStream(requested);
      responseJson = returnResponse(response);
    } on SocketException {
      throw FetchDataException('No Internet Connection');
    }
    return responseJson;
  }

  @override
  Future<dynamic> getListofXFilePostApiResponse(
      String url, Map<String, String> data, List<XFile> attachment) async {
    dynamic responseJson;
    Map<String, String> headers = {
      "Content-Type": "application/x-www-form-urlencoded",
      "Content-type": "application/json"
    };

    // debugPrint(data.toString());
    try {
      var request = http.MultipartRequest('POST', Uri.parse(url));
      request.headers.addAll(headers);
      // ============================== \\

      request.fields.addAll(data);
 
      for (int i = 0; i < attachment.length; i++) {
        final file = await http.MultipartFile.fromPath(
            'bill_upload[]', attachment[i].path);
        request.files.add(file);
      } 
      var requested = await request.send();
      var response = await http.Response.fromStream(requested);
      responseJson = returnResponse(response);
    } on SocketException {
      throw FetchDataException('No Internet Connection');
    }
    return responseJson;
  }

  dynamic returnResponse(http.Response response) {
    switch (response.statusCode) {
      case 200:
        dynamic responseJson = jsonDecode(response.body);
        return responseJson;
      case 201:
        dynamic responseJson = jsonDecode(response.body);
        return responseJson;
      case 401:
        throw BadRequestException(response.body.toString());
      case 500:
      case 404:
        throw UnauthorisedException(response.body.toString());
      default:
        throw FetchDataException(
            'Error accused while communicating with server with status code ${response.statusCode.toString()}');
    }
  }
}
