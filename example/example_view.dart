import 'package:flutter/material.dart';
import 'package:thumbnails_view/thumbnails_view.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Test',
      theme: ThemeData(shadowColor: const Color(0xFF121212)),
      home: HomePage(),
    );
  }
}

class HomePage extends StatelessWidget {
  const HomePage({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    const images = [
      NetworkImage(
        'https://images-na.ssl-images-amazon.com/images/I/91FZGIgvNEL._AC_UY500_.jpg',
      ),
      NetworkImage(
        'https://images-na.ssl-images-amazon.com/images/I/41mEA-lfo8L._AC_SR38_.jpg',
      ),
      NetworkImage(
        'https://images-na.ssl-images-amazon.com/images/I/41HDzGFfiRL._AC_SR38_.jpg',
      ),
    ];

    return Scaffold(
      body: Center(
        child: Container(
          width: 480.0,
          height: 456.0,
          child: ThumbnailsView(
            images: images,
            thumbnailBuilder: (ctx, image, isCurrent) {
              return Container(
                margin: const EdgeInsets.all(6.0),
                width: 32.8,
                height: 32.8,
                decoration: BoxDecoration(
                  border: Border.all(
                    color: isCurrent ? Theme.of(ctx).shadowColor : Colors.grey,
                    width: 2.4,
                  ),
                ),
                child: Image(fit: BoxFit.fill, image: image),
              );
            },
            options: const ThumbnailsViewOptions(
              thumbnailsPosition: AxisDirection.left,
              middleGap: 62.0,
            ),
          ),
        ),
      ),
    );
  }
}
