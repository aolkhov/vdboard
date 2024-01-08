part of 'all.dart';

class LinearTrajectory extends Trajectory {

  LinearTrajectory(Point<double> beg, Point<double> end): super(beg, end);

  @override Point<double> getXY(double offset) {
    var x = beg.x + (end.x - beg.x) * offset;
    var y = beg.y + (end.y - beg.y) * offset;
    return new Point(x, y);
  }

  @override void draw(SceneContext sctx, {int lineWidth=1, strokeStyle="lightgray"}) {
    sctx.ctx..beginPath()
      ..moveTo(beg.x, beg.y)
      ..lineTo(end.x, end.y)
      ..lineWidth = lineWidth
      ..strokeStyle = strokeStyle
      ..stroke();
  }

  double abs(double v) => v < 0 ? -v : v;

  @override double getTangent(double u) => abs(end.x - beg.x) < 0.001 ? 0 : (end.y - beg.y)/(end.x - beg.x);
}
