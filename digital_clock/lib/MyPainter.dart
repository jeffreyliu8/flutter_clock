import 'package:flutter/material.dart';
import 'dart:math';

class MyPainter extends CustomPainter {
  Paint _activePaint;
  Paint _inactivePaint;
  Paint _outerCirclePaint;
  Paint _innerCirclePaint;

  double _percent;
  int _numOfDividerLines;
  bool _isInverseColor;

  List<Path> pathList = new List();

  MyPainter(this._percent, this._numOfDividerLines, this._isInverseColor) {
    _activePaint = Paint()
      ..color = Colors.red
      ..strokeCap = StrokeCap.round
      ..strokeWidth = 1;

    _inactivePaint = Paint()
      ..color = const Color(0xff191d2b)
      ..strokeCap = StrokeCap.round
      ..strokeWidth = 1;

    _outerCirclePaint = Paint()
      ..color = Colors.black
      ..strokeCap = StrokeCap.round
      ..strokeWidth = 1;

    _innerCirclePaint = Paint()
      ..color = Colors.white
      ..strokeCap = StrokeCap.round
      ..strokeWidth = 1;
  }

  //private function
  void getAllPaths(Size size) {
    double fanStart = 0;

    double fanWidthInDegree =
        (360 - (_numOfDividerLines * _dividerWidthInDegree)) /
            _numOfDividerLines;

    for (var i = 0; i < _numOfDividerLines; i++) {
//      debugPrint('start: $fanStart ');

      Path path = Path();
      path.arcTo(
          Rect.fromLTWH(
              _outerCirclePadding,
              _outerCirclePadding,
              size.width - _outerCirclePadding * 2,
              size.height - _outerCirclePadding * 2),
          degToRad(fanStart),
          degToRad(fanWidthInDegree),
          false);

      path.arcTo(
          Rect.fromLTWH(
              size.width / 4 + _innerCircleXOffset,
              size.height / 4 + _innerCircleYOffset,
              size.width / 2,
              size.height / 2),
          degToRad(
              fanStart + fanWidthInDegree + _innerCircleRotationOffsetInDegree),
          degToRad(-fanWidthInDegree),
          false);

      pathList.add(path);

      fanStart = fanStart + (360 / _numOfDividerLines);
    }
  }

  double _dividerWidthInDegree = 1; // 10 degree
  double _innerCircleXOffset = -10;
  double _innerCircleYOffset = -25;
  double _innerCircleRotationOffsetInDegree = -17;
  double _innerCirclePadding = 1;
  double _outerCirclePadding = 1;

  num degToRad(num deg) => deg * (pi / 180.0);

  @override
  void paint(Canvas canvas, Size size) {
    double needle = _percent * _numOfDividerLines;
//    debugPrint('needle: $needle ');

    getAllPaths(size);

    // draw background black circle
    canvas.drawCircle(
        Offset(
          size.width / 2,
          size.height / 2,
        ),
        size.width / 2,
        _outerCirclePaint);

    int startIndex = 31;
    for (var i = 0; i < _numOfDividerLines; i++) {
      Paint rightColor = _activePaint;
      if (!_isInverseColor) {
        if (needle > i) {
          rightColor = _activePaint;
        } else {
          rightColor = _inactivePaint;
        }
      } else {
        if (needle > i) {
          rightColor = _inactivePaint;
        } else {
          rightColor = _activePaint;
        }
      }

      canvas.drawPath(pathList[startIndex], rightColor);
      startIndex++;
      if (startIndex >= _numOfDividerLines) {
        startIndex = 0;
      }
    }

    // draw inner white circle
    canvas.drawCircle(
        Offset(
          size.width / 2 + _innerCircleXOffset,
          size.height / 2 + _innerCircleYOffset,
        ),
        size.width / 4 - _innerCirclePadding,
        _innerCirclePaint);
  }

  @override
  bool shouldRepaint(MyPainter oldDelegate) {
    return oldDelegate._percent != _percent;
  }
}
