part of scene;

/**
 * Provides way to modify object properties according to the specified law
 */
class SceneObjectUpdater {
  ChangeFunc valueChangeFunc;
  Function   objectUpdateFunc;

  SceneObjectUpdater(this.valueChangeFunc, this.objectUpdateFunc);

  /**
   * apply next value of valueChangeFunc() to the object via objectChangeFunc
   * Sample use:
   *    class X {
   *      num height;
   *    }
   *
   *    var upd = new SceneObjectUpdater(
   *      valueChangeFunc: new LoopingChanageFunc(10),
   *      objectChangeFunc: (X x, num new_hight) { x.height = new_height }
   *    );
   *
   * @return false whether valueChangeFunc has finsihed
   */
  bool update(SceneObject obj) {
    num val = this.valueChangeFunc.getAndAdvance();
    objectUpdateFunc(obj, val);
    return this.valueChangeFunc.isFinished();
  }
}
