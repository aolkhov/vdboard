part of timeline;

abstract class Timeline {
  int _tick = 0;

  void start();
  void update(double realMsecPassed);
  int currentTick() => _tick;
}

class TimelineRealTime extends Timeline {
  int startedAt = DateTime.now().millisecondsSinceEpoch;

  void start() {
    startedAt = DateTime.now().millisecondsSinceEpoch;
  }

  void update(double _) {
    int msecsPassed = DateTime.now().millisecondsSinceEpoch - startedAt;
    this._tick = msecsPassed;
  }
}
