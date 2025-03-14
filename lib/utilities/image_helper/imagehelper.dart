import 'dart:io';
import 'dart:typed_data';
import 'dart:ui' as ui;
import 'package:b2b/commons.dart';
import 'package:b2b/constants.dart';
import 'package:b2b/utilities/logger.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'package:image/image.dart' as image;

import 'package:b2b/scr/core/size/size_config.dart';
import 'package:b2b/utilities/image_helper/asset_helper.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:flutter_svg/flutter_svg.dart';

class ImageProperty {
  const ImageProperty({
    Key? key,
    required this.image,
    required this.x,
    required this.y,
  });

  final ui.Image image;
  final int x;
  final int y;
}

// ignore: avoid_classes_with_only_static_members
class ImageHelper {
  static final picker = ImagePicker();

  static const double widthIcon = 18;
  static const double heightIcon = 18;

  static Widget loadFromUrl(
    String imageURL, {
    double? imageWidth,
    double? imageHeight,
    double? radius,
    BoxFit? fit = BoxFit.contain,
  }) {
    return CachedNetworkImage(
      imageUrl: imageURL,
      width: imageWidth,
      height: imageHeight,
      imageBuilder: (context, imageProvider) => Container(
        clipBehavior: Clip.hardEdge,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(radius ?? 0),
          image: DecorationImage(
            image: imageProvider,
            fit: fit,
          ),
        ),
      ),
      placeholder: (context, url) => const Center(child: CircularProgressIndicator()),
      errorWidget: (BuildContext context, String url, dynamic error) => const Center(
        child: Icon(Icons.error),
      ),
    );
  }

  static Widget loadFromAsset(
    String imageFilePath, {
    String? defaultImage,
    double? width,
    double? height,
    double? radius,
    BoxFit? fit,
    Color? tintColor,
    Alignment? alignment,
  }) {
    if (AssetHelper.hasAsset[imageFilePath] != true) {
      if ((defaultImage ?? '').isNotEmpty &&
          defaultImage != imageFilePath &&
          AssetHelper.hasAsset[defaultImage] == true) {
        return loadFromAsset(defaultImage!,
            width: width, height: height, radius: radius, fit: fit, tintColor: tintColor, alignment: alignment);
      }
      return ClipRRect(
        borderRadius: BorderRadius.circular(radius ?? 0),
        child: SizedBox(
          width: width,
          height: height,
        ),
      );
    }
    if (imageFilePath.toLowerCase().endsWith('svg')) {
      return ClipRRect(
        borderRadius: BorderRadius.circular(radius ?? 0),
        child: SvgPicture.asset(
          imageFilePath,
          width: width,
          height: height,
          fit: fit ?? BoxFit.contain,
          color: tintColor,
          alignment: alignment ?? Alignment.center,
        ),
      );
    } else {
      return ClipRRect(
        borderRadius: BorderRadius.circular(radius ?? 0),
        child: Image.asset(
          imageFilePath,
          width: width,
          height: height,
          fit: fit ?? BoxFit.contain,
          color: tintColor,
          alignment: alignment ?? Alignment.center,
        ),
      );
    }
  }

  static Widget loadIconFromAsset(
    String imageFilePath, {
    double? width = 18,
    double? height = 18,
    double? radius,
    BoxFit? fit,
    Color? tintColor,
    Alignment? alignment,
  }) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(radius ?? 0),
      child: Image.asset(
        imageFilePath,
        width: width,
        height: height,
        fit: fit ?? BoxFit.contain,
        color: tintColor,
        alignment: alignment ?? Alignment.center,
      ),
    );
  }

  static Future<Widget> loadFromCamera({
    double? width,
    double? height,
    double? radius,
    BoxFit? fit,
  }) async {
    final pickedFile = await picker.pickImage(source: ImageSource.camera);
    if (pickedFile == null) {
      return const SizedBox();
    } else {
      final File _image = File(pickedFile.path);
      return ClipRRect(
        borderRadius: BorderRadius.circular(radius ?? 0),
        child: Image.file(
          _image,
          width: width,
          height: height,
          fit: fit ?? BoxFit.contain,
        ),
      );
    }
  }

  static Future<Widget> loadFromPhotos({
    double? width,
    double? height,
    double? radius,
    BoxFit? fit,
  }) async {
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);
    if (pickedFile == null) {
      return const SizedBox();
    } else {
      final File _image = File(pickedFile.path);
      return ClipRRect(
        borderRadius: BorderRadius.circular(radius ?? 0),
        child: Image.file(
          _image,
          width: width,
          height: height,
          fit: fit ?? BoxFit.contain,
        ),
      );
    }
  }

  static Future<ui.Image> bytesToImage(Uint8List data) async {
    ui.Codec codec = await ui.instantiateImageCodec(data);
    ui.FrameInfo frame = await codec.getNextFrame();
    return frame.image;
  }

  static Future<ui.Image?> assetToImage(String asset) async {
    try {
      ByteData bytes = await rootBundle.load(asset);
      image.Image? baseSizeImage = image.decodeImage(bytes.buffer.asUint8List());
      final newWidth = getInScreenSize(baseSizeImage?.width.toDouble() ?? 0, fitHeight: true);
      final newHeight = getInScreenSize(baseSizeImage?.height.toDouble() ?? 0, fitHeight: true);
      if (newWidth == 0 || newHeight == 0 || baseSizeImage == null) {
        return bytesToImage(bytes.buffer.asUint8List());
      } else {
        image.Image resizeImage = image.copyResize(baseSizeImage, height: newHeight.toInt(), width: newWidth.toInt());
        ui.Codec codec = await ui.instantiateImageCodec(Uint8List.fromList(image.encodePng(resizeImage)));
        ui.FrameInfo frameInfo = await codec.getNextFrame();
        return frameInfo.image;
      }
    } catch (e) {
      Logger.debug(e);
    }
    return null;
  }

  static Future<Uint8List?> renderReport(String title, Uint8List body) async {
    ui.Image? imgBg = await assetToImage(AssetHelper.imgBgLogin);
    ui.Image? imgTop = await assetToImage(AssetHelper.imgReportBgTop);
    ui.Image? imgBottom = await assetToImage(AssetHelper.imgReportBgBottom);

    final delta = (imgTop?.height ?? 0) / 2;

    final image = await bytesToImage(body);

    final top = 40 * SizeConfig.devicePixelRatio;

    final left = imgBg != null && imgTop != null ? (imgBg.width - imgTop.width) / 2 : 30 * SizeConfig.devicePixelRatio;
    final left2 = imgBg != null && imgTop != null ? (imgTop.width - image.width) / 2 : 30 * SizeConfig.devicePixelRatio;

    int _height = image.height + top.toInt() * 4 + delta.toInt();
    int _width = image.width + (left.toInt() + left2.toInt()) * 2;
    final recorder = ui.PictureRecorder();
    final paintWhite = Paint()
      ..color = Colors.white
      ..style = PaintingStyle.fill;
    final paintTransparent = Paint()..style = PaintingStyle.fill;
    final paintBg = Paint()
      ..shader = ui.Gradient.linear(
        Offset(_width.toDouble(), 0),
        Offset(0, _height.toDouble()),
        [
          const Color.fromRGBO(0, 183, 79, 1.0),
          const Color.fromRGBO(29, 66, 137, 1.0),
        ],
      );

    final canvas = Canvas(
      recorder,
      Rect.fromPoints(
        const Offset(0.0, 0.0),
        Offset(
          _width.toDouble(),
          _height.toDouble(),
        ),
      ),
    );

    canvas.drawPaint(paintBg);

    TextSpan span = TextSpan(
        style: TextStyle(color: Colors.white, fontSize: 13 * SizeConfig.devicePixelRatio, fontWeight: FontWeight.w500),
        text: title.toUpperCase());
    TextPainter tp = TextPainter(text: span, textAlign: TextAlign.center, textDirection: TextDirection.ltr);
    tp.layout();
    tp.paint(canvas, Offset((_width - tp.width) / 2, (2 * top - tp.height) / 2));

    if (imgTop != null && imgBottom != null) {
      canvas.drawImage(imgTop, Offset(left, 2 * top - delta + 2), paintTransparent);
      canvas.drawImage(imgBottom, Offset(left, _height - 2 * top), paintTransparent);
    }

    if (imgBg != null) {
      canvas.drawImage(imgBg, Offset(0, top), paintTransparent);
    } else {
      Logger.debug('img bg == null');
    }

    canvas.drawRect(
        Rect.fromPoints(
          Offset(left, 2 * top + delta),
          Offset(imgTop != null ? imgTop.width.toDouble() + left : (_width - left), _height.toDouble() - 2 * top),
        ),
        paintWhite);
    canvas.drawImage(image, Offset(left.toDouble() + left2.toDouble(), 2 * top + delta), paintTransparent);

    final picture = recorder.endRecording();
    final imgFull = await picture.toImage(_width, _height);
    final imageData = await imgFull.toByteData(format: ui.ImageByteFormat.png);
    if (imageData != null) {
      return Uint8List.view(imageData.buffer);
    }
    return null;
  }

  static Future<Uint8List?> join(List<Uint8List?> list) async {
    if (list.isNotEmpty) {
      List<ImageProperty> imageProperties = [];
      final recorder = ui.PictureRecorder();
      final paint = Paint()
        ..color = Colors.white
        ..style = PaintingStyle.fill;
      int _height = 0;
      int _width = 0;
      for (int i = 0; i < list.length; i++) {
        Uint8List? item = list[i];
        if (item != null) {
          ui.Codec codec = await ui.instantiateImageCodec(item);
          ui.FrameInfo frame = await codec.getNextFrame();
          final image = frame.image;
          imageProperties.add(ImageProperty(image: image, x: 0, y: _height));
          _height += image.height;
          if (_width < image.width) {
            _width = image.width;
          }
        }
      }
      final canvas = Canvas(
        recorder,
        Rect.fromPoints(
          const Offset(0.0, 0.0),
          Offset(
            _width.toDouble(),
            _height.toDouble(),
          ),
        ),
      );
      // canvas.drawCircle(Offset(_width/2, _height/2), _width/2, paint);
      canvas.drawColor(Colors.white, BlendMode.screen);
      for (int i = 0; i < imageProperties.length; i++) {
        ImageProperty item = imageProperties[i];
        canvas.drawImage(item.image, Offset(item.x.toDouble(), item.y.toDouble()), paint);
      }
      final picture = recorder.endRecording();
      final imgFull = await picture.toImage(_width, _height);
      final imageData = await imgFull.toByteData(format: ui.ImageByteFormat.png);
      if (imageData != null) {
        return Uint8List.view(imageData.buffer);
      }
    }
    return null;
  }
}
