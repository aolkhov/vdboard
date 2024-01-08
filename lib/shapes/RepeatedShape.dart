part of shapes;

/**
 * The provvided shape is repeated along the treajectory
 */
class RepeatedShape extends Shape {
  Trajectory trj;
  Shape shape;
  double distanceBetween;  // distance between the shapes in trajectory units (0..1)
  double offset;           // offset of the first shape. Update it to animate

  RepeatedShape(this.trj, this.shape, this.distanceBetween, {this.offset = 0.0});

  @override double get Height => (trj.end.y - trj.beg.y).abs();
  @override double get Width  => (trj.end.x - trj.beg.x).abs();

  @override void draw(SceneContext sctx, Point<num> xy, {fillStyle, strokeClr, lineWidth, angleTangent, zoom}) {
    Object drawTrajectories = sctx.scene.options["drawTrajectories"] ?? false;
    if( drawTrajectories is bool && drawTrajectories )
      trj.draw(sctx);

    for(double offs = offset; offs < 1; offs += distanceBetween) {
      Point xy = trj.getXY(offs);
      double tan = trj.getTangent(offs);
      shape.draw(sctx, xy, angleTangent: tan);
    }
  }
}
