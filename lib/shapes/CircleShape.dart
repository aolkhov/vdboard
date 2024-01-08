part of 'all.dart';

class CircleShape extends Shape {
  double radius, lineWidth;
  var fillStyle, strokeStyle;

  double get Width  => radius * 2.0;
  double get Height => radius * 2.0;
  Point<double> get Center => new Point<double>(radius, radius);
  Point<double> get scaledCenter => new Point<double>(radius*zoom, radius*zoom);

  CircleShape({this.radius = 3.0, this.lineWidth = 1.0, this.fillStyle = "lightgreen", this.strokeStyle = "green", double zoom = 1.0}) { super.zoom = zoom; }

  @override String toString() => "CircleShape{radius=$radius, lineWidth=$lineWidth}";

  @override void draw(SceneContext sctx, Point xy, {fillStyle, strokeClr, lineWidth, angleTangent, zoom}) {
    CanvasRenderingContext2D ctx = sctx.ctx;
    var vFillStyle = fillStyle == null ? this.fillStyle : fillStyle;

    ctx..beginPath()
      ..arc(xy.x, xy.y, radius.toDouble(), 0, 2 * math.pi, false)
      ..fillStyle = vFillStyle is Color ? vFillStyle.toString() : vFillStyle
      ..fill()
    ;

    var vLineWidth = lineWidth == null ? this.lineWidth : lineWidth;
    if( vLineWidth != null && vLineWidth > 0 ) {
      ctx.lineWidth   = vLineWidth;
      ctx.strokeStyle = strokeStyle == null ? this.strokeStyle : strokeStyle;
      ctx.stroke();
    }
  }

}
