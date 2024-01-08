part of 'all.dart';

class CubicBezierTrajectory extends Trajectory {
  late Point<double> cp1, cp2;

  CubicBezierTrajectory(Point<double> beg, Point<double> end,
      {double cp1dist=0.25, double cp2dist=0.75, double? cp1shift, double? cp2shift}):
        super(beg, end) {
    if( cp1shift == null || cp2shift == null ) {
      double seg_len = beg.distanceTo(end);
      if( cp1shift == null ) cp1shift = -seg_len / 6.0;
      if( cp2shift == null ) cp2shift =  seg_len / 6.0;
    }
    cp1 = _shifted_point(cp1dist, cp1shift);
    cp2 = _shifted_point(cp2dist, cp2shift);
  }

  double _cubicN(double pct, double a, double b, double c, double d) {
    var t2 = pct * pct;
    var t3 = t2 * pct;
    return a + (-a * 3 + pct * (3 * a - a * pct)) * pct + (3 * b + pct * (-6 * b + b * 3 * pct)) * pct + (c * 3 - c * 3 * pct) * t2 + d * t3;
  }

  @override Point<double> getXY(double offset) {
    var x = _cubicN(offset, beg.x, cp1.x, cp2.x, end.x);
    var y = _cubicN(offset, beg.y, cp1.y, cp2.y, end.y);
    return new Point<double>(x, y);
  }

  @override void draw(SceneContext sctx, {int lineWidth=1, strokeStyle="lightgray"}) {
    sctx.ctx..beginPath()
      ..moveTo(beg.x, beg.y)
      ..bezierCurveTo(cp1.x, cp1.y, cp2.x, cp2.y, end.x, end.y)
      ..lineWidth = lineWidth
      ..strokeStyle = strokeStyle
      ..stroke();
  }

  double _getTangent(double t) {
    // Source: http://stackoverflow.com/questions/4089443/find-the-tangent-of-a-point-on-a-cubic-bezier-curve-on-an-iphone
    // note that this routine works for both the x and y side;
    // simply run this routine twice, once for x once for y
    // note that there are sometimes said to be 8 (not 4) coefficients,
    // these are simply the four for x and four for y, calculated as above in each case.
    double C1 = end.x - (3.0 * cp2.x) + (3.0 * cp1.x) - beg.x;
    double C2 = (3.0 * cp2.x) - (6.0 * cp1.x) + (3.0 * beg.x);
    double C3 = (3.0 * cp1.x) - (3.0 * beg.x);
    //double C4 = ( beg.x );  // (not needed for this calculation)
    return 3.0*C1*t*t + 2.0*C2*t + C3;
  }

}
