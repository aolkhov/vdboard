part of 'all.dart';

class TriangleShape extends Shape {
  double triangle_height, in_depth;
  var    fillStyle;
  Color  strokeClr;
  double lineWidth, angleTangent;

  @override double get Width  => triangle_height;
  @override double get Height => triangle_height * tg30 * 2.0;

  static const sin30 = 0.5;
  static const cos30 = 0.866;  // cos 30 degree,
  static const tg30  = sin30/cos30;
  static const pi180 = math.pi/180.0;

  TriangleShape(this.triangle_height, this.fillStyle, this.strokeClr,
      {this.lineWidth = 1.0, this.angleTangent = 0.0, double zoom = 1.0, this.in_depth = 0.0}
  ) {
    super.zoom = zoom;
  }

  @override String toString() => "TriangleShape{height=$triangle_height, indepth=$in_depth}, angle=$angleTangent";

  @override void draw(SceneContext sctx, Point xy, {fillStyle, strokeClr, lineWidth, angleTangent, zoom}) {
    CanvasRenderingContext2D ctx = sctx.ctx;

    var vfillStyle   = fillStyle ?? this.fillStyle;
    var vStrokeClr = strokeClr ?? this.strokeClr;
    var vLineWidth  = lineWidth ?? this.lineWidth;
    var vAangleTangent = angleTangent ?? this.angleTangent;
    var vZoom = zoom ?? this.zoom;

    Point right = Point(triangle_height/2.0, 0);
    Point top   = Point(-triangle_height/2.0, -triangle_height * tg30);
    Point btm   = Point(top.x, -top.y);

    ctx.save();
    ctx.translate(xy.x, xy.y);

    if (vAangleTangent != 0)
      ctx.rotate(math.atan(vAangleTangent));

    ctx..beginPath()
       ..moveTo(right.x, right.y)
       ..lineTo(top.x, top.y)
    ;

    if (in_depth != 0) {
      Point mid   = Point(-triangle_height/2.0 + triangle_height*in_depth, 0);
      ctx.lineTo(mid.x, mid.y);
    }

    ctx..lineTo(btm.x, btm.y)
       ..closePath()
    ;

    if( vZoom != null )
      ctx.scale(vZoom,  vZoom);

    ctx..lineWidth = vLineWidth
      ..strokeStyle = vStrokeClr.toString()
      ..fillStyle = vfillStyle is Color ? vfillStyle.toString() : vfillStyle
      ..fill()
      ..stroke()
    ;

    ctx.restore();

    //sctx.scene.debug("draw TriangleShape: top: $top, right: $right, bottom: $btm;  xy: $xy, vZoom: $vZoom");
  }
}
