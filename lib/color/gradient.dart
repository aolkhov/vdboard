part of color;

class GradientStop {
  double pos;
  Color  clr;

  GradientStop(this.pos, this.clr);
}

class Gradient {
  List<GradientStop> stops = [];

  void add(double pos, Color clr) {
    assert(pos >= 0.0 && pos <= 1.0);
    for(int idx=0; idx < stops.length; idx++) {
      if (stops[idx].pos == pos) {
        stops[idx].clr = clr;
        return;
      }
    }
    stops.add(new GradientStop(pos, clr));
    stops.sort((a,b) => a.pos.compareTo(b.pos) );
  }


  getColorAt(double pos) {
    assert(pos >= 0.0 && pos <= 1.0);

    int idx=0;
    while( idx < stops.length && pos >= stops[idx].pos ) {
      idx++;
    }

    if( idx <= 0            ) return stops.first.clr;
    if( idx >= stops.length ) return stops.last.clr;
    if( pos == stops[idx-1].pos ) return stops[idx-1].clr;
    if( pos == stops[idx].pos ) return stops[idx].clr;

    // the color is between idx-1 and idx
    double q = (pos - stops[idx-1].pos) / (stops[idx].pos - stops[idx-1].pos);
    int r = (stops[idx-1].clr._r * (1-q) + stops[idx].clr._r * q).toInt();
    int g = (stops[idx-1].clr._g * (1-q) + stops[idx].clr._g * q).toInt();
    int b = (stops[idx-1].clr._b * (1-q) + stops[idx].clr._b * q).toInt();
    return Color.fromRgb(r, g, b);
  }

}

class LinearGradient extends Gradient {
  static final _AlertGradient = LinearGradient()..add(0.0, Color.Green)..add(0.6, Color.Yellow)..add(0.8, Color.Orange)..add(1.0, Color.Red);

  static LinearGradient get defaultAlertGradient => _AlertGradient;

  static CanvasGradient byTwoPoints(CanvasRenderingContext2D ctx, Color clr1, Color clr2, [num maxVal=100]) {
    CanvasGradient g = ctx.createLinearGradient(0, 0, 0, maxVal);
    g.addColorStop(0, clr1.toString());
    g.addColorStop(1, clr2.toString());
    return g;
  }
}

class RadialGradient extends Gradient {
  static CanvasGradient byTwoPoints(CanvasRenderingContext2D ctx, Color clr1, num radius1, Color clr2, num radius2) {
    CanvasGradient g = ctx.createRadialGradient(0, 0, radius1, 0, 0, radius2);
    g.addColorStop(0, clr1.toString());
    g.addColorStop(1, clr2.toString());
    return g;
  }
}
