part of 'all.dart';

class ParabolicTrajectory extends QuadraticBezierTrajectory {
  ParabolicTrajectory(Point<double> beg, Point<double> end, Point<double> center):
        super(beg, end, cp : Point<double>(1.5*center.x, 1.5*center.y));
}
