
// ignore_for_file: file_names

import 'dart:io';

import 'package:cloudinary_public/cloudinary_public.dart';
import 'package:image_picker_platform_interface/src/types/image_source.dart';


class FotosService{
  FotosService();

  Future<String> uploadImage(File image) async {
    final cloudinary = CloudinaryPublic('dydttkb7s', 'ml_default', cache: false);
    try {
      CloudinaryResponse response = await cloudinary.uploadFile(
        CloudinaryFile.fromFile(image.path,
            resourceType: CloudinaryResourceType.Image),
      );
      return response.secureUrl;
    } on CloudinaryException catch (e) {
      // ignore: avoid_print
      print(e.message);
      // ignore: avoid_print
      print(e.request);
      return "";
    }
  }
}