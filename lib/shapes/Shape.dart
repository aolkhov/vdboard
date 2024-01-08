part of shapes;

abstract class Shape {
  double zoom = 1.0;

  double get Width;
  double get Height;
  double get scaledWidth   => Width * zoom;
  double get scaledHeight  => Height * zoom;
  Point<double> get Center       => new Point<double>(Width*0.5, Height*0.5) ;         // from (0,0)
  Point<double> get scaledCenter => new Point<double>(Width*0.5*zoom, Height*0.5*zoom) ;         // from (0,0)

  void draw(SceneContext sctx, Point xy, {fillStyle, strokeClr, lineWidth, angleTangent, zoom});

  @override String toString();
}
