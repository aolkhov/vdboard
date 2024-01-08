import 'dart:html';
import 'dart:math';

import 'package:vdboard/core/all.dart';
import 'package:vdboard/color/all.dart';
import 'package:vdboard/scene/all.dart';
import 'package:vdboard/shapes/all.dart';
import 'package:vdboard/trajectory/all.dart';

void main() {
  var infoElm = querySelector('#info');
  var fpsElm = querySelector("#fps");
  DivElement debugElm = querySelector("#debug-log") as DivElement;

  var mc = querySelector('#main-canvas');
  if( mc == null || !(mc is CanvasElement)) {
    infoElm?.text = "Error: canvas element with id 'main-canvas' wa not found";
    return;
  }

  CanvasElement canvasElm = mc as CanvasElement;
  if ( canvasElm.clientHeight < 400 || canvasElm.clientWidth < 600 ) {
    infoElm?.text = "Canvas is too small: expect at least 600x400, got ${canvasElm.clientWidth}x${canvasElm.clientHeight}";
    return;
  }

  infoElm?.text = "started at: ${DateTime.timestamp().toLocal()}, canvas: ${canvasElm.clientWidth}x${canvasElm.clientHeight}, debugElm: ${debugElm} ${debugElm.clientWidth}x${debugElm.clientHeight}";

  SceneContext sctx = SceneContext(canvasElm);
  Scene scene = Scene(sctx, fpsElement: fpsElm, debugElement: debugElm);

  Element? stopBtn = querySelector("#toggle-playback");
  stopBtn?.onClick.listen((MouseEvent e) {
    stopBtn.innerText = scene.paused ? "Pause" : "Resume";
    scene.togglePause();
  });

  populateScene(scene);
  scene.options["backgroundFillStyle"] = createBackgroundFillStyle(sctx);
  scene.play();
}

void populateScene(Scene scene) {
  addPrimaryDB(scene);
  addInstanceFrame(scene);
  addPrimaryPool(scene);
}

CanvasGradient createBackgroundFillStyle(SceneContext sctx) {
  final num planetHeightPct = 5.0;
  final num planetHeight = 15;
  final num planetWidthPct = 30;  // %% of the plant in the screen width
  final num atmosphereHight = 20;    // planet to space thickness in pixels

  var ctx = sctx.ctx;
  num width  = ctx.canvas.clientWidth;
  num height = ctx.canvas.clientHeight;
  sctx.scene.debug("bgr: width $width, height $height");

  num visibleHight = planetHeight; //height * planetHeightPct / 100 ;
  num visibleHalfWidth = width * planetWidthPct / 100 / 2;
  sctx.scene.debug("bgr: visibleHight $visibleHight, visibleHalfWidth $visibleHalfWidth");

  num planetRadius = (pow(visibleHight, 2) + pow(visibleHalfWidth, 2)) / (2 * visibleHight);
  num centerX = width / 2;
  num centerY = height + (planetRadius - visibleHight);
  sctx.scene.debug("bgr: planetRadius $planetRadius, centerX $centerX, centerY $centerY");

  CanvasGradient g = ctx.createRadialGradient(centerX, centerY, planetRadius, centerX, centerY, height + (planetRadius - visibleHight));

  num p1 = visibleHight / height;
  num p2 = (visibleHight + atmosphereHight) / height;
  num p12 = (p1 + p2) / 2;
  num p3 = (visibleHight + atmosphereHight * 1.2) / height;
  num p23 = (p2 + p3) / 2;

  g.addColorStop(0,  Color.fromRgb(0, 19, 77).toString());
  g.addColorStop(p1, Color.LightSkyBlue.toString());   // same color for the planet
//  g.addColorStop(p12, Color.Gold.toString());
  g.addColorStop(p23, Color.DarkGray.toString());
  g.addColorStop(p3, Color.fromRgb(77, 0, 77).toString());   // purpur
  g.addColorStop(1, Color.fromRgb(26, 0, 26).toString());      // dark purpur
  return g;
}

// A triangle flowing over a Bezier curve for 5 seconds
SceneObject buildTestObj1(Scene scene) {
  Shape triange = TriangleShape(10, "lightGreen", Color.DarkGoldenRod);
  Trajectory trj = CubicBezierTrajectory(Point(50, 50), Point(550, 250));
  return SceneObject(triange, trj, scene: scene);
}

// A bar going up and down every 2 seconds
SceneObject buildTestObj2(Scene scene) {
  RectShape bar = RectShape(width: 20, height: 100, lineWidth: 3, fillStyle: Color.LightBlue, strokeStyle: Color.DarkBlue);
  Trajectory trj = PointTrajectory.fromXY(20, 150);
  SceneObject obj = SceneObject(bar, trj, scene: scene, trjTicks: 3000 /* a cycle takes 3 seconds*/);
  obj.updaters.add(
    SceneObjectUpdater(  // modifies recangle hight
        ReturningChanageFunc(100, low: 20),
        (SceneObject obj, num newHight) => (obj.shape as RectShape).height = newHight.toDouble()
    )
  );
  return obj;
}

void addPrimaryDB(Scene scene) {
  RectShape db = RectShape(width: 180, height: 280, lineWidth: 3, fillStyle: Color.MediumSeaGreen, strokeStyle: Color.DarkBlue);
  Trajectory trj = PointTrajectory.fromXY(950, 150);
  SceneObject obj = SceneObject(db, trj, scene: scene);
  obj.updaters.add(SceneObjectUpdater(
      ReturningChanageFunc(1000),
      (SceneObject obj, num alertLevel) => (obj.shape as RectShape).fillStyle =
          LinearGradient.defaultAlertGradient.getColorAt(alertLevel / 1000.0)
  ));
  scene.objs.add(obj);
}

void addInstanceFrame(Scene scene) {
  RectShape db = RectShape(width: 700, height: 600, lineWidth: 2, fillStyle: Color.Transparent, strokeStyle: Color.DarkRed);
  Trajectory trj = PointTrajectory.fromXY(50, 50);
  SceneObject obj = SceneObject(db, trj, scene: scene);
  scene.objs.add(obj);
}

void addPrimaryPool(Scene scene) {
  RectShape db = RectShape(width: 120, height: 300, lineWidth: 2, fillStyle: Color.DeepSkyBlue, strokeStyle: Color.LightSkyBlue);
  Trajectory trj = PointTrajectory.fromXY(100, 250);
  SceneObject obj = SceneObject(db, trj, scene: scene);
  scene.objs.add(obj);
  obj.updaters.add(SceneObjectUpdater(
      ReturningChanageFunc(400),
          (SceneObject obj, num newZoom) => (obj.shape as RectShape).zoom = 0.95 + newZoom / 4000
  ));

  final Point<double> origin = Point(200, 350);
  final Point<double> dest =   Point(950, 400);

  Trajectory trj2 = CubicBezierTrajectory(origin, dest);
  Shape triangle = TriangleShape(10, "lightGreen", Color.DarkGoldenRod);
  RepeatedShape triangles = RepeatedShape(trj2, triangle, 0.1);
  SceneObject spout = SceneObject(triangles, trj2, scene: scene, trjTicks: double.infinity);
  spout.updaters.add(SceneObjectUpdater(
          LoopingChanageFunc(9500, start: 50, step: 20, smooth: false),
         (SceneObject obj, num newOffs) => (obj.shape as RepeatedShape).offset = newOffs / 10000.0
  ));
  return scene.objs.add(spout);
}
