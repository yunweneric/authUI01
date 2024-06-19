import 'package:flutter/material.dart';
import 'dart:typed_data';
import 'package:flutter/services.dart' show rootBundle;
import 'dart:ui' as ui;

import 'package:flutter_open_animate/utils/sizing.dart';

class ShadedBottle extends StatefulWidget {
  final double activeIndex;
  final Duration duration;
  const ShadedBottle({super.key, required this.activeIndex, required this.duration});

  @override
  State<ShadedBottle> createState() => _ShadedBottleState();
}

class _ShadedBottleState extends State<ShadedBottle> {
  Float64List matrix4 = Matrix4.identity().storage;
  Future<ui.Image>? imgFuture;

  // New helper function
  Future<ui.Image> loadImageFromFile(String path) async {
    var fileData = Uint8List.sublistView(await rootBundle.load(path));
    return await decodeImageFromList(fileData);
  }

  @override
  void initState() {
    imgFuture = loadImageFromFile("assets/images/pattern_main.png"); // Works now
    super.initState();
  }

  double translateValue = 0;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Positioned(
          left: Sizing.width(context) * 0.2,
          right: Sizing.width(context) * 0.2,
          child: FutureBuilder(
            future: imgFuture,
            builder: (context, snapshot) {
              final secondOffset = Sizing.width(context) * 0.2;
              final firstOffset = Sizing.width(context) * 0.02;
              double beginAt = widget.activeIndex == 0 ? firstOffset : -secondOffset;
              if (snapshot.hasData) {
                return TweenAnimationBuilder(
                  tween: Tween<Offset>(begin: Offset(beginAt, 0), end: Offset(-beginAt, 0)),
                  duration: widget.duration,
                  curve: Curves.easeInOutExpo,
                  builder: (context, value, child) {
                    return Transform.translate(
                      offset: value,
                      child: ShaderMask(
                        blendMode: BlendMode.modulate,
                        shaderCallback: (_) {
                          return ImageShader(snapshot.data!, TileMode.clamp, TileMode.clamp, matrix4);
                        },
                        child: Transform.translate(
                          offset: -value,
                          child: Image.asset(
                            "assets/images/bottle.png",
                            height: Sizing.height(context),
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                    );
                  },
                );
              } else {
                return const CircularProgressIndicator();
              }
            },
          ),
        ),
      ],
    );
  }
}
