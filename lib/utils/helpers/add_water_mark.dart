import 'dart:ui' as ui;

import 'dart:io';

import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';

Future<File> addWatermark({
  required File originalImage,
  required String address,
  required String latLng,
  required String dateTime,
}) async {
  final bytes = await originalImage.readAsBytes();
  final codec = await ui.instantiateImageCodec(bytes);
  final frame = await codec.getNextFrame();
  final ui.Image image = frame.image;

  final recorder = ui.PictureRecorder();
  final canvas = Canvas(recorder);

  final paint = Paint();
  canvas.drawImage(image, Offset.zero, paint);

  // Dark overlay
  final rect = Rect.fromLTWH(
    0,
    image.height - 150,
    image.width.toDouble(),
    150,
  );
  canvas.drawRect(rect, Paint()..color = Colors.black.withOpacity(0.6));

  // Text painter
  final textPainter = TextPainter(
    textDirection: TextDirection.ltr,
    text: TextSpan(
      text: "$address\n$latLng\n$dateTime",
      style: const TextStyle(
        color: Colors.white,
        fontSize: 28,
        fontWeight: FontWeight.bold,
      ),
    ),
  );

  textPainter.layout(maxWidth: image.width.toDouble() - 40);
  textPainter.paint(canvas, Offset(20, image.height - rect.height));

  final picture = recorder.endRecording();
  final finalImage = await picture.toImage(image.width, image.height);

  final pngBytes = await finalImage.toByteData(format: ui.ImageByteFormat.png);

  final dir = await getTemporaryDirectory();
  final file = File(
    "${dir.path}/clockin_${DateTime.now().millisecondsSinceEpoch}.png",
  );
  await file.writeAsBytes(pngBytes!.buffer.asUint8List());

  return file;
}
