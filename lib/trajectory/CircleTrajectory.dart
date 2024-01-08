part of 'all.dart';

class CircleTrajectory extends Trajectory {
  double _radius;

  CircleTrajectory(Point<double> center, this._radius): super(center, NoPoint);
  CircleTrajectory.fromXY(double x, double y, this._radius): super(Point<double>(x,y), NoPoint);

  void draw(SceneContext sctx, {int lineWidth=1, strokeStyle="lightgray"}) {
    sctx.ctx..beginPath()
      ..arc(beg.x, beg.y, _radius, 0.0, math.pi * 2.0, false)
      ..lineWidth = lineWidth
      ..strokeStyle = strokeStyle
      ..stroke()
    ;
  }

  Point<double> getXY(double progress) {
    double angle = progress * math.pi * 2.0;
    return new Point(_radius * math.cos(angle) + beg.x, _radius * math.sin(angle) + beg.y);
  }

  @override bool hasEnded(double offset) => false;
/*
  @override double getTangent(double u) =>
    u == 0.25
        ? 1000.0
        : u == 0.75 ? -1000.0 : math.sin(u*math.pi*2.0) / math.cos(u*math.pi*2.0)
    ;
*/
}
