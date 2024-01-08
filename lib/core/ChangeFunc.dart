part of core;

/**
 * A mapping changing value according to some law.
 */
abstract class ChangeFunc {
  num getCurrent();
  num getAndAdvance();
  bool isFinished() => false;
}

/** Sounds silly, but a non-changing changing function comes handy at times */
class ConstantChangeFun extends ChangeFunc {
  final num val;
  ConstantChangeFun(this.val) {}
  @override num getCurrent() => val;
  @override num getAndAdvance() => val;
  @override bool isFinished() => false;

  ConstantChangeFun.fromJson(Map json) : val = json["val"] {}
  @override Map toJson() => { "val": val };
}

/**
 * The function goes from start to stop and then always returns the stop
 *
 *   3    ___________________
 *   2   /
 *   1  /
 *   0 /
 *     01233333333
 *
 * [start] the initial value
 * [step]  the value increment
 * [stop]  the last and all.dart subsequent values
 */
class StoppingChangeFunc extends ChangeFunc {
  final num start, step, stop;
  num _curr, _next;

  StoppingChangeFunc(this.stop, {this.start=0.0, this.step=0.1})
      : _curr = start,
        _next = start
  {
    assert(step != 0, "step can't be zero");
    assert((step > 0 && start < stop) || (step < 0 && start > stop),
      "step $step direction is wrong for range $start .. $stop");
  }

  @override num getCurrent() => _curr;

  @override num getAndAdvance() {
    if( isFinished() )
      return stop;

    _curr = _next;
    _next += step;
    if (step > 0 && _next > stop)
      _next = stop;
    else if (step < 0 && _next < stop)
      _next = stop;

    return _curr;
  }

  @override bool isFinished() => _curr == stop;

  StoppingChangeFunc.fromJson(Map json): this(json["stop"], start: json["start"], step: json["step"]);
  @override Map toJson() => {"start": start, "stop": stop, "step": step};

}

/**
 * The function goes from start stop and then always loops back to the start
 * There is a tricky thing: start and stop mean the same point in smooth mode:
 *
 *         8|4
 *         ____
 *       /     \
 *    7 |       |  5
 *       \     /
 *         ---
 *          6
 *
 *  start = 4, stop = 8. For step = 3, the sequence is: 4,7,6,5,8,7
 *  Note that 4 never repeats, but that's ok because it is the same thing as 8
 */
class LoopingChanageFunc extends ChangeFunc {
  final int start, step, stop;
  final bool smooth;
  int _len;     // stop - start
  int _curr;    // always 0 .. _len

  LoopingChanageFunc(this.stop, {this.start=0, this.step=1, this.smooth = true, initial_val = null})
      : _curr = 0,
        _len = stop - start
  {
    assert(step != 0, "step can't be zero");
    assert(start < stop, "the lower loop boundary should be less than the upper one, got ($start, $stop)");
    assert(!smooth || step.abs() <= stop - start);  // smooth step shouldn't exceed the loop range

    initial_val ??= step > 0 ? start : stop;
    _curr = initial_val! - start;

    assert(0 <= _curr && _curr <= _len,
        "initial value $initial_val should be in the (start, stop) range ($start, $stop)");
  }

  LoopingChanageFunc.fromJson(Map json): this(json["stop"], start: json["start"], step: json["step"], smooth: json["smooth"]);
  @override Map toJson() => {"start": start, "stop": stop, "step": step, "smooth": smooth };

  @override int getCurrent() => start + _curr;

  @override int getAndAdvance() {
    int ret = _curr;

    _curr += step;
    if (_curr > _len && smooth)
      _curr -= _len;
    else if (_curr > _len && !smooth)
      _curr = 0;
    else if (_curr < 0 && smooth)
      _curr += _len;
    else if (_curr < 0 &&!smooth)
      _curr = _len;

    return start + ret;
  }
}

/**
 * Going from start to stop then from stop to start: 0,1,2,3,2,1,0
 *
 *   3     /       /
 *   2    /  \    /  \
 *   1   /    \  /    ...
 *   0  /      \/
 *      0123 21 0123 2...
 *
 *  Note how both start and stop extremes are not repeated
 *
 */
class ReturningChanageFunc extends ChangeFunc {
  int low, high, step;
  int activeStep;
  bool touchEdge;

  int _curr;

  ReturningChanageFunc(this.high, {this.low = 0, this.step = 1, this.touchEdge = true, int? initVal}) :
        this.activeStep = step,
        this._curr = initVal ?? (step > 0 ? low : high)
  {
    assert(step != 0, "step can't be zero");
    assert(low < high, "the lower boundary should be less than the upper one, got ($low, $high)");
    assert(!touchEdge || step.abs() <= high - low);  // smooth step shouldn't exceed the loop range

    assert(low <= _curr && _curr <= high,
       "initial value $initVal should be in the (low, high) range ($low, $high)");
  }

  @override
  int getCurrent() => this._curr;

  @override
  int getAndAdvance() {
    int ret = _curr;

    _curr += activeStep;
    if (_curr > high && touchEdge) {
      _curr = high;
      activeStep = -activeStep;
    } else if (_curr > high && !touchEdge) {
      _curr = ret;
      activeStep = -activeStep;
    } else if (_curr < low && touchEdge) {
      _curr = low;
      activeStep = -activeStep;
    } else if (_curr < low && !touchEdge) {
      _curr = ret;
      activeStep = -activeStep;
    }

    return ret;
  }
}
