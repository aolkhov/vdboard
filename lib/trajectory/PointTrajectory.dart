part of 'all.dart';

class PointTrajectory extends Trajectory {

  PointTrajectory.fromPoint(Point<double> xy): super(xy, xy);
  PointTrajectory.fromXY(double x, double y): super(Point<double>(x,y), NoPoint);

  void draw(SceneContext sctx, {int lineWidth=1, strokeStyle="lightgray"}) {
    sctx.ctx..beginPath()
      ..lineWidth = lineWidth
      ..strokeStyle = strokeStyle
      ..moveTo(beg.x, beg.y)
      ..lineTo(beg.x, beg.y)
      ..stroke();
  }

  Point<double> getXY(double progress) => beg;

  @override double getTangent(double u) => 0.0;

  @override bool hasEnded(double offset) => false;
}
