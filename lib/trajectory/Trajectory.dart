part of trajectory;

final Point<double> NoPoint = Point(-10000, -10000);

/**
 * Trajectory represent object moving path.
 * Normally it is invisible, although has method to display itself.
 *
 * This class serves as base for various types of real trajectories: line, curve, bezier curve, circle, etc.
 */
abstract class Trajectory {
  Point<double>  beg, end;
  Trajectory(this.beg, this.end);

  /**
   * Draw the trajectory with specified style and line width
   * [ctx]: Context to draw onto
   * [lineWidth]: line width as applies to Context drawings
   * [strokeStyle]: color, gradient, or pattern. See http://www.w3schools.com/tags/canvas_strokestyle.asp
   */
  void draw(SceneContext sctx, {int lineWidth=1, strokeStyle="lightgray"});

  /**
   * Get coordinates of point [progress] along the trajectory.
   * [progress] is a number between 0 and 1, with 0 corresponding to the starting point, and 1 to the end.
   * Returns: 2-D point
   */
  Point<double> getXY(double progress);

  /**
   * Get tanget to X axis at point [progress] along the trajectory
   * [progress] is a number between 0 and 1, with 0 corresponding to the starting point, and 1 to the end.
   * Returns: tangent value
   */
  double getTangent(double progress) => _getTangentSlowWay(progress);

  /**
   * Indicates where the offset corresponds to the end of the trajectory
   */
  bool hasEnded(double offset) => offset > 1.0;

  Point<double> _shifted_point(double how_far_along, double shift_distance) {
    double dx = end.x - beg.x;
    double dy = end.y - beg.y;
    double seg_len = beg.distanceTo(end);

    var res_x = beg.x + dx * how_far_along;
    var res_y = beg.y + dy * how_far_along;

    if( shift_distance != 0.0 && seg_len > 10.0 ) {
      res_x -= shift_distance * dy / seg_len;
      res_y += shift_distance * dx / seg_len;
    }

    return new Point<double>(res_x, res_y);
  }

  double _getTangentSlowWay(double progress, [double delta=0.01]) {
    final double epsilon = 0.0001;
    Point<double> xy  = getXY(progress);
    Point<double> xy2 = getXY(progress+delta);
    double dx = xy2.x - xy.x;
    double dy = xy2.y - xy.y;
    return dy/(dx.abs() > epsilon ? dx : epsilon*dx.sign); // atan2(dy, dx);
  }

}
