import 'package:flutter/material.dart';
import 'package:photo_view/photo_view.dart';

class FullImageView extends StatelessWidget {
  final String url;
  const FullImageView({Key? key, required this.url}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        leading: IconButton(
            onPressed: ()=>Navigator.of(context).pop(),
            icon: const Icon(Icons.arrow_back, color: Colors.white,)),
        elevation: 0,
        backgroundColor: Colors.transparent,
      ),
      body: PhotoView(
        imageProvider: NetworkImage(url),
      ),
    );
  }
}
