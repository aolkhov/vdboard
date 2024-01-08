part of 'all.dart';

/// Used when shape is required, but should behave like there was no shape
class NullShape extends Shape {
  double get Width  => 0.0;
  double get Height => 0.0;
  @override void draw(SceneContext sctx, Point xy, {fillStyle, strokeClr, lineWidth, angleTangent, zoom}) {}

  static final NullShape val = new NullShape();

  @override String toString() => "NullShape{}";

}
