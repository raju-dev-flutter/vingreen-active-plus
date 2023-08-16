import 'package:image_picker/image_picker.dart';

abstract class BaseApiServices {
  Future<dynamic> getGetApiResponse(String url);

  Future<dynamic> getPostApiResponse(String url, dynamic data);

  Future<dynamic> getXFilePostApiResponse(
      String url, Map<String, String> data, XFile attachment);

  Future<dynamic> getListofXFilePostApiResponse(
      String url, Map<String, String> data, List<XFile> attachment);
}
