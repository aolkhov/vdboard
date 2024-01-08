part of color;

class InvalidColorNameException implements Exception {
  String msg;
  InvalidColorNameException(this.msg);
  @override String toString() => msg;
}

// Based on
//   https://github.com/chrisalexander/shades/blob/master/lib/colour.dart
//   http://stackoverflow.com/questions/2353211/hsl-to-rgb-color-conversion

class Color {
  int _r = 0, _g = 0, _b = 0, _a = 255;

  static final Color Transparent = Color.fromRgbA(0, 0, 0, 0);

  static final Color Black = new Color.fromRgb(0, 0, 0);
  static final Color White = new Color.fromRgb(255, 255, 255);
  // Greenishes
  static final Color DarkSlateGray = new Color.fromRgb(47,79,79);
  static final Color Green = new Color.fromRgb(0,128,0);
  static final Color Chartreuse = new Color.fromRgb(127,255,0);
  static final Color ForestGreen = new Color.fromRgb(34,139,34);
  static final Color GreenYellow = new Color.fromRgb(173,255,47);
  static final Color LawnGreen = new Color.fromRgb(124,252,0);
  static final Color LightGreen = new Color.fromRgb(144,238,144);
  static final Color Lime = new Color.fromRgb(0,255,0);
  static final Color LimeGreen = new Color.fromRgb(50,205,50);
  static final Color MediumSeaGreen = new Color.fromRgb(60,179,113);
  static final Color MediumSpringGreen = new Color.fromRgb(0,250,154);
  static final Color PaleGreen = new Color.fromRgb(152,251,152);
  static final Color SpringGreen = new Color.fromRgb(0,255,127);
  static final Color LightSeaGreen = new Color.fromRgb(32,178,170);
  static final Color DarkCyan = new Color.fromRgb(0,139,139);

  // Cyan and blue
  static final Color Blue          = new Color.fromRgb(  0,   0, 255);
  static final Color LightBlue     = new Color.fromRgb(173, 216, 230);
  static final Color DarkBlue      = new Color.fromRgb(  0,   0, 139);
  static final Color DarkTurquoise = new Color.fromRgb(  0, 206, 209);
  static final Color DodgerBlue    = new Color.fromRgb( 30, 144, 255);
  static final Color DeepSkyBlue   = new Color.fromRgb(  0, 191, 255);
  static final Color LightSkyBlue  = new Color.fromRgb(135, 206, 250);
  static final Color MidnightBlue  = new Color.fromRgb( 25,  25, 112);
  static final Color Navy          = new Color.fromRgb(  0,   0, 128);

  // Red and pink
  static final Color Red = new Color.fromRgb(255,0,0);
  static final Color DarkRed = new Color.fromRgb(102,0,0);
  static final Color Crimson = new Color.fromRgb(220,20,60);
  static final Color Magenta = new Color.fromRgb(255,0,255);
  static final Color SaddleBrown = new Color.fromRgb(139,69,19);
  static final Color Orange = new Color.fromRgb(255,165,0);

  // Yallow and goldish
  static final Color Yellow = new Color.fromRgb(255,255,0);
  static final Color PaleGoldenRod = new Color.fromRgb(238,232,170);
  static final Color Gold = new Color.fromRgb(255,215,0);
  static final Color GoldenRod = new Color.fromRgb(218,165,32);
  static final Color DarkGoldenRod = new Color.fromRgb(184,134,11);
  static final Color Khaki = new Color.fromRgb(240,230,140);

  // Whitesh
  static final Color AntiqueWhite = new Color.fromRgb(250,235,215);
  static final Color Gray = new Color.fromRgb(128,128,128);
  static final Color LightSlateGray = new Color.fromRgb(119,136,153);
  static final Color DarkGray = new Color.fromRgb(169,169,169);
  static final Color LightGray = new Color.fromRgb(211,211,211);
  static final Color DimGray = new Color.fromRgb(105,105,105);

  static Color fromString(String str) {
    if( str.startsWith("#") )
      return new Color.fromHex(str);
    //List<int> rgb = Color._colours[str.toLowerCase()];
    //if( rgb == null )
      throw new InvalidColorNameException(str);
    //return new Color.fromRgb(rgb[0], rgb[1], rgb[2]);
  }

  /// [rgb_string] format is "#rrggbb".
  Color.fromHex(String rgb_string) {
    final int idx = 1; //rgb_string.startsWith("#") ? 1 : 0;
    this._r = int.parse(rgb_string.substring(idx+0, idx+2), radix: 16);
    this._g = int.parse(rgb_string.substring(idx+2, idx+4), radix: 16);
    this._b = int.parse(rgb_string.substring(idx+4, idx+6), radix: 16);
  }

  Color.fromRgb(this._r, this._g, this._b);
  Color.fromRgbA(this._r, this._g, this._b, this._a);

  Color.fromHsl(double h, double s, double l) {
    List<int> rgb = Color.hsl2rgb(h, s, l);
    _r = rgb[0];  _g = rgb[1];  _b = rgb[2];
  }

  @override String toString() {
    //return "rgba(${this._r}, ${this._g}, ${this._b}, ${this._a})";
    String hh(int v) => v.toRadixString(16).padLeft(2, '0');
    return "#"+hh(this._r)+hh(this._g)+hh(this._b);
  }

  List<double> toHsl() => Color.rgb2hsl(_r, _g, _b);
  List<int>    toRgb() => [_r, _g, _b];

  void adjust_lightness(double adjustment) {
    List<double> hsl = Color.rgb2hsl(_r, _g, _b);
    hsl[2] += adjustment;
    if( hsl[2] < 0.0 ) hsl[2] = 0.0;
    if( hsl[2] > 1.0 ) hsl[2] = 1.0;
    List<int> rgb = Color.hsl2rgb(hsl[0], hsl[1], hsl[2]);
    this._r = rgb[0];  this._g = rgb[1];  this._b = rgb[2];
  }

  /**
   * Converts an RGB color value to HSL. Conversion formula
   * adapted from http://en.wikipedia.org/wiki/HSL_color_space.
   * Assumes r, g, and b are contained in the set [0, 255] and
   * returns h, s, and l in the set [0, 1].
   *
   * [r]       The red color value
   * [g]       The green color value
   * [b]       The blue color value
   * [return]  Array The HSL representation
   */
  static List<double> rgb2hsl(int rr, int gg, int bb) {
    double _min2(double v1, double v2) => v1 <= v2 ? v1 : v2;  double min3(double v1, double v2, double v3) => _min2(v1, _min2(v2, v3));
    double _max2(double v1, double v2) => v1 >= v2 ? v1 : v2;  double max3(double v1, double v2, double v3) => _max2(v1, _max2(v2, v3));

    double r = rr/255.0, g = gg/255.0, b = bb/255.0;
    double max = max3(r, g, b), min = min3(r, g, b);
    double h, s, l = (max + min) / 2;

    if( max == min ) {
      h = s = 0.0; // achromatic
    } else {
      double d = (max - min).toDouble();
      s = l > 0.5 ? d / (2 - max - min) : d / (max + min);
      h = max == r ? (g - b) / d + (g < b ? 6.0 : 0.0)
        : max == g ? (b - r) / d + 2.0
        :            (r - g) / d + 4.0;

      h /= 6.0;
    }

    return [h, s, l];
  }

  /**
   * Converts an HSL color value to RGB. Conversion formula
   * adapted from http://en.wikipedia.org/wiki/HSL_color_space.
   * Assumes h, s, and l are contained in the set [0, 1] and
   * returns r, g, and b in the set [0, 255].
   *
   * [h]       The hue
   * [s]       The saturation
   * [l]       The lightness
   * [return  Array           The RGB representation
   */
  static List<int> hsl2rgb(double h, double s, double l) {
    double r, g, b;

    if( s == 0 ) {
      r = g = b = 1.0; // achromatic
    } else {
      double hue2rgb(double p, double q, double t ) {
        if( t < 0.0     ) t += 1.0;
        if( t > 1.0     ) t -= 1.0;
        if( t < 1.0/6.0 ) return p + (q - p) * 6 * t;
        if( t < 1.0/2.0 ) return q;
        if( t < 2.0/3.0 ) return p + (q - p) * (2.0/3.0 - t) * 6.0;
        return p;
      }

      double q = l < 0.5 ? l * (1.0 + s) : l + s - l * s;
      double p = 2.0 * l - q;
      r = hue2rgb(p, q, h + 1.0/3.0);
      g = hue2rgb(p, q, h);
      b = hue2rgb(p, q, h - 1.0/3.0);
    }

    return [(r * 255.0).round(), (g * 255.0).round(), (b * 255).round()];
  }

  bool get isTransparent => _a == 0;
}
