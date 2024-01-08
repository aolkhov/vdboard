part of scene;

class Scene {
  var options = {
    "drawTrajectories": false,
    "backgroundFillStyle":  Color.LightGray.toString()
  };

  List<SceneObject> objs = [];

  Timeline timeLine;
  SceneContext sceneContext;
  Element? fpsElement;
  DivElement? debugElement;
  bool paused = false;

  Scene(this.sceneContext, {this.fpsElement, this.debugElement, Timeline? timeLine}) :
      this.timeLine = timeLine ?? TimelineRealTime()
  {
    this.sceneContext.scene = this;
    debug("Started");
  }

  bool update(int ticks_since_start) {
    if (objs.length == 0)
      return false;

    //debug("update started with ${objs.length} objects");
    Set<SceneObject> toRemove = {};
    objs.forEach((obj) {
      if (!obj.update(ticks_since_start))
        toRemove.add(obj);
    });

    if (toRemove.isNotEmpty)
      objs.removeWhere((element) => toRemove.contains(element));
    //debug("update finsihed with ${objs.length} objects");
    return true;
  }

  bool isFinished() => paused || objs.isEmpty;

  void play() {
    timeLine.start();
    _requestNextFrameDraw();
  }

  void togglePause() {
    this.paused = !this.paused;
    if (!paused)
      _requestNextFrameDraw();
  }

  void debug(String text) {
    if( (this.debugElement?.innerHtml?.length ?? 100001) > 100000 )
      return;

    this.debugElement?.appendHtml("${DateTime.now()}: $text<br/>");
  }

  // ------------------------------------------- PRIVATE

  static const int MSEC_TO_SPEND_IN_A_LOOP = 1000 ~/ 100;  // somehow this translates to 30fps
  double  msec_spent_rendering = 0;
  double  fpsAverage = 0;
  int _frameCount = 0;

  void _showFps(double fps) {
    if( fpsAverage == 0 )
      fpsAverage = fps;

    fpsAverage = min(fps * 0.05 + fpsAverage * 0.95, 9999);
    _frameCount++;
    fpsElement!.text = fpsAverage.round().toString() + ", frame ${_frameCount}"
       + ", debug len: ${debugElement?.innerText.length}";
  }

  void _requestNextFrameDraw() {
    window.animationFrame.then((msec_since_page_load) => _drawFrame(msec_since_page_load.toDouble()));
  }

  void _drawFrame(double msec_since_page_load) async {
    final double msec_passed = msec_since_page_load - msec_spent_rendering;
    if (fpsElement != null) {
      _showFps(1000.0 / msec_passed);
      msec_spent_rendering = msec_since_page_load;
    }

    if( isFinished() )
      return;   // end of the scene, no more updates

    timeLine.update(msec_passed);
    int tick = timeLine.currentTick();

    if (!update(tick))
      return;   // end of the scene, no more updates

    _drawBackGround(sceneContext);
    _drawObects(sceneContext);

    if( msec_passed < MSEC_TO_SPEND_IN_A_LOOP ) {
      Duration duration = Duration(milliseconds: (MSEC_TO_SPEND_IN_A_LOOP - msec_passed).toInt());
      await Future.delayed(duration);   // TODO: is it right?
    }

    _requestNextFrameDraw();
  }

  void _drawBackGround(SceneContext sctx) {
    sctx.ctx.fillStyle = this.options["backgroundFillStyle"];
    sctx.ctx.fillRect(0, 0, sctx.ctx.canvas.width!, sctx.ctx.canvas.height!);
  }

  void _drawObects(SceneContext ctx) => objs.forEach((e) => e.draw(ctx));
}
