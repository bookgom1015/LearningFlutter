import 'dart:math';
import 'package:flutter/material.dart';

class PepeRain extends StatefulWidget {
  static const int Length = 64;
  static const double DegToRad = pi / 180;

  const PepeRain({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _PepeRainState();
}

class _PepeRainState extends State<PepeRain> with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  late double _deviceWidth;
  late double _deviceHeight;

  late List<Offset> _offsets;
  late List<double> _sizes;
  late List<Offset> _positions;
  late List<Offset> _velocities;
  late List<double> _rotations;
  late List<double> _rotSpeeds;

  late Stopwatch _stopwatch;
  Duration _prevTime = Duration.zero;
  Duration _frameTime = Duration.zero;

  @override
  void initState() {
    super.initState();

    _stopwatch = Stopwatch()..start();

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 20)
    );

    _controller.addListener(() {
      var elapsed = _stopwatch.elapsed;
      _frameTime = elapsed - _prevTime;
      _prevTime = elapsed;

      for (int index = 0; index < PepeRain.Length; ++index) {
        var pos = _positions[index];
        double ms = _frameTime.inMilliseconds / 1000;
        var deltaX = _velocities[index].dx * ms;
        var deltaY = _velocities[index].dy * ms;

        _rotations[index] = _rotations[index] + _rotSpeeds[index] * ms;

        var finalX = pos.dx + deltaX;
        var diffX = finalX - _offsets[index].dx;
        var size = _sizes[index];
        if (diffX * diffX > size * size) {
          _velocities[index] = Offset(_velocities[index].dx * -1, _velocities[index].dy);
        }

        var finalY = pos.dy + deltaY;
        if (finalY >= _deviceHeight) {
          Random random = Random();
          _offsets[index] = Offset(
            random.nextInt(_deviceWidth.toInt()).toDouble(),
            random.nextInt(2048).toDouble() * -1
          );
          double size = random.nextInt(120) + 8;;
          _sizes[index] = size;
          _velocities[index] = Offset(random.nextInt(32).toDouble(), size);

          finalY = _offsets[index].dy;

          _rotations[index] = random.nextInt(30).toDouble() * PepeRain.DegToRad;
          _rotSpeeds[index] = random.nextInt(45).toDouble() * PepeRain.DegToRad;
        }
        _positions[index] = Offset(finalX, finalY);
      }
    });

    _controller.repeat();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    
    _deviceWidth = MediaQuery.of(context).size.width;
    _deviceHeight = 2 * (MediaQuery.of(context).size.height
                     - MediaQuery.of(context).padding.top // Status bar height
                      - AppBar().preferredSize.height);

    List<Offset> offsetList = [];
    List<double> sizeList = [];
    List<Offset> posList = [];
    List<Offset> velList = [];
    List<double> rotList = [];
    List<double> rotSpeedList = [];
    Random random = Random();
    for (int index = 0; index < PepeRain.Length; ++index) {
      double offsetX = random.nextInt(_deviceWidth.toInt()).toDouble();
      double offsetY = random.nextInt(2048).toDouble() * -1;
      double size = random.nextInt(120) + 8;

      offsetList.add(Offset(offsetX, offsetY));
      sizeList.add(size);
      posList.add(Offset(offsetX, offsetY));
      velList.add(Offset(random.nextInt(32).toDouble(), size));
      rotList.add(random.nextInt(30).toDouble() * PepeRain.DegToRad);
      rotSpeedList.add(random.nextInt(45).toDouble() * PepeRain.DegToRad);
    }
    _offsets = offsetList;
    _sizes = sizeList;
    _positions = posList;
    _velocities = velList;
    _rotations = rotList;
    _rotSpeeds = rotSpeedList;
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    List list = Iterable<int>.generate(_offsets.length).toList();

    return AnimatedBuilder(
      animation: _controller, 
      builder: (BuildContext contextk, _) {
        return Stack(          
          children: List<Widget>.from(list.map((index) => pepeWidget(index)))
        );
      }
    );
  }

  Widget pepeWidget(index) {
    return Positioned(      
      top: _positions[index].dy,
      left: _positions[index].dx,
      child: Transform.rotate(
        angle: _rotations[index],
        child: Container(
          width: _sizes[index],
          height: _sizes[index],
          decoration: const BoxDecoration(
            image: DecorationImage(
              image: AssetImage("assets/images/pepe.png")
            )
          ),
        )
      )
    );
  }  
}