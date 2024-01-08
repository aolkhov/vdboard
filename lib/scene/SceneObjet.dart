part of scene;

class SceneObject {
  List<SceneObjectUpdater> updaters = [];

  Shape shape;
  Trajectory trj;
  double trjTicks;
  double velocity = 1;

  final String name;
  Scene? scene;

  int? _startTick;

  double _trjOffset = 0;

  SceneObject(this.shape, this.trj, {this.trjTicks = 5000, String? name, this.scene}) :
      this.name = name ?? identityHashCode(trjTicks).toRadixString(36)
  {
    assert(this.trjTicks > 0);
  }

  bool update(int ticks_since_start) {
    if (_startTick == null)
      _startTick = ticks_since_start;

    this._trjOffset = (ticks_since_start - _startTick!) / trjTicks * velocity;
//    scene?.debug("${this.name}: _trjOffset ${this._trjOffset}, xy ${trj.getXY(_trjOffset)}, angle ${trj.getTangent(_trjOffset)}, shape $shape");
    if (this.trj.hasEnded(_trjOffset))
      return false;
    /*
    Set<SceneObjectUpdater> toRemove = {};
    updaters.forEach((u) {
      if (!u.update(this))
        toRemove.add(u);
    });

    if (toRemove.isNotEmpty)
      updaters.removeWhere((u) => toRemove.contains(u));

    return updaters.isNotEmpty;
    */
    for(SceneObjectUpdater updater in updaters)
      updater.update(this);

    return true;
  }

  bool finished() => updaters.isEmpty;

  void draw(SceneContext sctx) {
    Point xy = trj.getXY(this._trjOffset);
    shape.draw(sctx, xy, angleTangent: trj.getTangent(this._trjOffset));
  }
}
