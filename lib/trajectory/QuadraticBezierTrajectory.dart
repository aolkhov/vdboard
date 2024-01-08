part of 'all.dart';

class QuadraticBezierTrajectory extends Trajectory {
  late Point<double> cp;

  QuadraticBezierTrajectory(Point<double> beg, Point<double> end, {double cp_dist=0.5, double? cp_shift, Point<double>? cp}): super(beg, end) {
    if (cp != null) {
      this.cp = cp;
    } else {
      if (cp_shift == null) cp_shift = -beg.distanceTo(end) / 6.0;
      this.cp = _shifted_point(cp_dist, cp_shift);
    }
  }

  @override Point<double> getXY(double offset) {
    var x = math.pow(1.0 - offset, 2) * beg.x + 2.0 * (1.0 - offset) * offset * cp.x + math.pow(offset, 2) * end.x;
    var y = math.pow(1.0 - offset, 2) * beg.y + 2.0 * (1.0 - offset) * offset * cp.y + math.pow(offset, 2) * end.y;
    return new Point(x, y);
  }

  @override void draw(SceneContext sctx, {int lineWidth=1, strokeStyle="lightgray"}) {
    sctx.ctx..beginPath()
      ..moveTo(beg.x, beg.y)
      ..quadraticCurveTo(cp.x, cp.y, end.x, end.y)
      ..lineWidth = lineWidth
      ..strokeStyle = strokeStyle
      ..stroke();
  }

  @override double getTangent(double u) {
    final double epsilon = 0.0001;
    double uc = 1 - u;
    double dx = (uc*cp.x + u*end.x) - (uc*beg.x + u*cp.x);
    double dy = (uc*cp.y + u*end.y) - (uc*beg.y + u*cp.y);
    return dy/(dx.abs() > epsilon ? dx : epsilon*dx.sign); // atan2(dy, dx);
  }
}
