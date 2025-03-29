import 'dart:math';

import 'package:challenge1/services/optionState.dart';
import 'package:challenge1/services/config_manager.dart';
import 'package:challenge1/services/file_manager.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class GraphWidget extends StatelessWidget {
  const GraphWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    ConfigManager conf = Provider.of<OptionsState>(context, listen: false).conf;
    return FutureBuilder<Map<String, dynamic>>(
      future: getGraphJson(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.done) {
          if (snapshot.hasError) {
            return Text('Error: ${snapshot.error}');
          }
          final points = getPoints(conf, snapshot.data!);
          final values = getValues(conf, snapshot.data!);
          return LayoutBuilder(
            builder: (context, constraints) {
              return CustomPaint(
                painter: GraphPainter(pointCoords: values, selectedPoints: points, colour: Theme.of(context).colorScheme.onPrimary),
              );
            },
          );

        } else {
          return CircularProgressIndicator();
        }
      },
    );
  }
}

class GraphPainter extends CustomPainter {
  final List<List<String>> selectedPoints;
  final Map<String, List<double>> pointCoords;
  final colour;

  GraphPainter({required this.selectedPoints, required this.pointCoords, required this.colour});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = colour
      ..strokeWidth = 2
      ..style = PaintingStyle.stroke;

    // Scale points to the current size of the canvas
    Map<String, Offset> scaledPoints = {};
    pointCoords.forEach((key, value) {
      scaledPoints[key] = Offset(
        value[0].toDouble() / 5 * size.width,  // Assuming max x is 5
        (value[1].toDouble() / 7.5) * size.height,  // Assuming max y is 8, and inverting y-axis
      );
    });
    Map<String, Offset> pointsToShow = {};
    // Draw the lines based on the selected points
    for (var pointList in selectedPoints) {
      if (pointList.length > 1) {
        Path path = Path();
        path.moveTo(scaledPoints[pointList[0]]!.dx, scaledPoints[pointList[0]]!.dy);

        for (int i = 1; i < pointList.length; i++) {
          if (pointList[i] == "sph1" || pointList[i] == "sph2") {
            // Use quadraticBezierTo to create the curve
            String controlPointKey = pointList[i]; // sph1 or sph2
            String endPointKey = (i + 1 < pointList.length) ? pointList[i + 1] : pointList[0]; // Wrap around

            Offset controlPoint = scaledPoints[controlPointKey]!;
            Offset endPoint = scaledPoints[endPointKey]!;

            path.quadraticBezierTo(
              controlPoint.dx,
              controlPoint.dy,
              endPoint.dx,
              endPoint.dy,
            );

            // Skip the next point (the endpoint of the curve)
            i++;
          } else {
            path.lineTo(scaledPoints[pointList[i]]!.dx, scaledPoints[pointList[i]]!.dy);
            pointsToShow[pointList[i]] = scaledPoints[pointList[i]]!;
          }
        }
        canvas.drawPath(path, paint);
      }
    }


    // Draw points
    final pointPaint = Paint()
      ..color = colour
      ..strokeWidth = 4
      ..style = PaintingStyle.fill;

    pointsToShow.forEach((key, value) {
      canvas.drawCircle(value, 3, pointPaint);
    });
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;  // Always repaint for simplicity. Optimize if needed.
  }
}

Future<Map<String, dynamic>> getGraphJson() {
  final FileManager fm = FileManager();
  return fm.readJsonFile("graph.json");
}

List<List<String>> getPoints(ConfigManager conf, Map<String, dynamic> json) {
  List<List<String>> res = [];
  var vatData = json["GRAPH"]["VAT"] as Map<String, dynamic>;
  for (final opt in conf.options) {
    if (vatData.containsKey(opt.name)) {
      var optData = vatData[opt.name] as Map<String, dynamic>;
      if (optData.containsKey(opt.params[opt.selected].name)) {
        var points = optData[opt.params[opt.selected].name];
        if (points is! List){
          for (final opt2 in conf.options){
            if (points.containsKey(opt2.name)) {
              var optData2 = points[opt2.name] as Map<String, dynamic>;
              if (optData2.containsKey(opt2.params[opt2.selected].name)) {
                points = optData2[opt2.params[opt2.selected].name];
                break;
              }
            }
          }
        }
        if (points is List) {
          List<String> p2 = points.map((e) => e.toString()).toList();
          res.add(p2);
        }
      }
    }
  }
  print("\n");
  print("\n");
  return res;
}

Map<String, List<double>> getValues(ConfigManager conf, Map<String, dynamic> json) {
  Map<String, List<double>> res = {};
  var valuesData = json["GRAPH"]?["VAT"]?["Values"] as Map<String, dynamic>?;

  if (valuesData == null) return res;

  for (final opt in conf.options) {
    if (valuesData.containsKey(opt.name)) {
      var optData = valuesData[opt.name] as Map<String, dynamic>?;
      if (optData != null && optData.containsKey(opt.params[opt.selected].name)) {
        var values = optData[opt.params[opt.selected].name] as Map<String, dynamic>?;
        if (values != null) {
          res.addAll(processValues(values));
        }
      }
    }
  }

  if (valuesData.containsKey("Rest")) {
    var restValues = valuesData["Rest"] as Map<String, dynamic>?;
    if (restValues != null) {
      res.addAll(processValues(restValues));
    }
  }
  return res;
}

Map<String, List<double>> processValues(Map<String, dynamic> originalMap) {
  Map<String, List<double>> result = {};

  originalMap.forEach((key, value) {
    if (value is List) {
      // Convert each element to double
      List<double> doubleList = value.map((e) => (e as num).toDouble()).toList();
      result[key] = doubleList;
    }
  });

  return result;
}
