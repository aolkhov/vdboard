part of shapes;

class RectShape extends Shape {
  double width, height, lineWidth;
  var fillStyle, strokeStyle;

  double get Width  => width;
  double get Height => height;

  RectShape({this.width = 10.0, this.height = 6.0, this.lineWidth = 1.0, this.fillStyle = "lightgreen", this.strokeStyle = "green", double zoom = 1.0}) { super.zoom = zoom; }

  @override String toString() => "RectShape{${width}x${height}, lineWidth=$lineWidth}";

  @override void draw(SceneContext sctx, Point xy, {fillStyle, strokeClr, lineWidth, angleTangent = 0.0, zoom}) {
    CanvasRenderingContext2D ctx = sctx.ctx;
    var vFillStyle   = fillStyle ?? this.fillStyle;
    var vStrokeStyle = strokeStyle ?? this.strokeStyle;
    var vLinewidth = lineWidth != null ? lineWidth : this.lineWidth;
    var vZoom        = zoom != null ? zoom : this.zoom;
    var half_width = this.width*0.5, half_height = this.height*0.5;

    ctx..save()
       ..translate(xy.x+half_width,  xy.y+half_height)
       ..rotate(math.atan(angleTangent))
       ..beginPath()
       ..rect(-half_width*vZoom, -half_height*vZoom, this.width*vZoom, this.height*vZoom)
    ;

    if( !(vFillStyle is Color && vFillStyle.isTransparent) ) {
      ctx..fillStyle = vFillStyle is Color ? vFillStyle.toString() : vFillStyle
         ..fill();
    }

    if( vLinewidth > 0 && !(vStrokeStyle is Color && vStrokeStyle.isTransparent) ) {
      ctx..strokeStyle = vStrokeStyle is Color ? vStrokeStyle.toString() : vStrokeStyle
         ..lineWidth = lineWidth != null ? lineWidth : this.lineWidth
         ..stroke();
    }

    ctx.restore();
  }
}
