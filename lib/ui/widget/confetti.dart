import 'dart:collection';
import 'dart:math';
import 'package:flutter/widgets.dart';

class Confetti extends StatefulWidget {
  static const _defaultColors = [Color(0xff20BF6B), Color(0xff868E96), Color(0xff0050bc), Color(0xff000000)];

  final bool isStopped;
  final int snippingCount;
  final List<Color> colors;
  final double snipSize;

  const Confetti({this.colors = _defaultColors, this.isStopped = false, required this.snipSize, required this.snippingCount, super.key});

  @override
  State<Confetti> createState() => _ConfettiState();
}

class ConfettiPainter extends CustomPainter {
  final defaultPaint = Paint();
  late final List<_PaperSnipping> _snippings;
  Size? _size;
  DateTime _lastTime = DateTime.now();
  final UnmodifiableListView<Color> colors;
  int snippingCount;
  double snipSize;

  ConfettiPainter({required Listenable animation, required Iterable<Color> colors, required this.snippingCount, required this.snipSize})
      : colors = UnmodifiableListView(colors),
        super(repaint: animation);

  @override
  void paint(Canvas canvas, Size size) {
    if (_size == null) {
      _snippings = List.generate(snippingCount, (i) => _PaperSnipping(frontColor: colors[i % colors.length], bounds: size, snipSize: snipSize));
    }

    final didResize = _size != null && _size != size;
    final now = DateTime.now();
    final dt = now.difference(_lastTime);
    for (final snipping in _snippings) {
      if (didResize) {
        snipping.updateBounds(size);
      }
      snipping.update(dt.inMilliseconds / 1000);
      snipping.draw(canvas);
    }

    _size = size;
    _lastTime = now;
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}

class _ConfettiState extends State<Confetti> with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      painter: ConfettiPainter(snippingCount: widget.snippingCount, colors: widget.colors, animation: _controller, snipSize: widget.snipSize),
      willChange: true,
      child: const SizedBox(),
    );
  }

  @override
  void didUpdateWidget(covariant Confetti oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.isStopped && !widget.isStopped) {
      _controller.repeat();
    } else if (!oldWidget.isStopped && widget.isStopped) {
      _controller.stop(canceled: false);
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(duration: const Duration(seconds: 1), vsync: this);

    if (!widget.isStopped) {
      _controller.repeat();
    }
  }
}

class _PaperSnipping {
  static final Random _random = Random();
  static const degToRad = pi / 180;
  static const backSideBlend = Color(0x70EEEEEE);
  Size _bounds;

  late final _Vector position = _Vector(_random.nextDouble() * _bounds.width, _random.nextDouble() * _bounds.height);
  final double rotationSpeed = 800 + _random.nextDouble() * 600;
  final double angle = _random.nextDouble() * 360 * degToRad;
  double rotation = _random.nextDouble() * 360 * degToRad;
  double cosA = 1.0;
  final double oscillationSpeed = 0.5 + _random.nextDouble() * 1.5;
  final double xSpeed = 40;
  final double ySpeed = 50 + _random.nextDouble() * 60;

  late List<_Vector> corners = List.generate(4, (i) {
    final angle = this.angle + degToRad * (45 + i * 90);
    return _Vector(cos(angle), sin(angle));
  });

  double time = _random.nextDouble();
  final Color frontColor;
  late final Color backColor = Color.alphaBlend(backSideBlend, frontColor);
  final paint = Paint()..style = PaintingStyle.fill;
  double snipSize;

  _PaperSnipping({required this.frontColor, required Size bounds, required this.snipSize}) : _bounds = bounds;

  void draw(Canvas canvas) {
    if (cosA > 0) {
      paint.color = frontColor;
    } else {
      paint.color = backColor;
    }

    final path = Path()..addPolygon(List.generate(4, (index) => Offset(position.x + corners[index].x * snipSize, position.y + corners[index].y * snipSize * cosA)), true);
    canvas.drawPath(path, paint);
  }

  void update(double dt) {
    time += dt;
    rotation += rotationSpeed * dt;
    cosA = cos(degToRad * rotation);
    position.x += cos(time * oscillationSpeed) * xSpeed * dt;
    position.y += ySpeed * dt;
    if (position.y > _bounds.height) {
      position.x = _random.nextDouble() * _bounds.width;
      position.y = 0;
    }
  }

  void updateBounds(Size newBounds) {
    if (!newBounds.contains(Offset(position.x, position.y))) {
      position.x = _random.nextDouble() * newBounds.width;
      position.y = _random.nextDouble() * newBounds.height;
    }
    _bounds = newBounds;
  }
}

class _Vector {
  double x, y;
  _Vector(this.x, this.y);
}
