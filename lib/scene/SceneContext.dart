part of scene;

class SceneContext {
  CanvasRenderingContext2D ctx;
  late Scene scene;

  SceneContext(CanvasElement canvasElm) :
        ctx = (canvasElm as CanvasElement).context2D
  {}
}
