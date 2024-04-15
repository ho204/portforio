// ビデオライブラリとOpenCVライブラリをインストールしておく
import processing.video.*;
import gab.opencv.*;
Capture video;
OpenCV opencv;
PGraphics screen;
void setup() {
  int height = 360;
  int width = 640;
  fullScreen();
  background(0);
  frameRate(30);
  // 描画用裏画面
  screen = createGraphics(width, height, JAVA2D);
  // OpenCVオブジェクト
  opencv = new OpenCV(this, width, height);
  String[] cameras = Capture.list();
  //println(cameras);
  while (cameras.length == 0) {
    cameras = Capture.list();
  }
  // ビデオキャプチャー
  video = new Capture(this, width,height,cameras[1]);
  video.start();
}
void draw() {
  scale(2.0);
  background(0);
  // ビデオ画像をOpenCVに読み込ませる
  opencv.loadImage(video);
  // 2値化で白黒画像にしてからノイズを低減
  opencv.threshold(160);
  opencv.erode(); opencv.erode(); opencv.erode();
  opencv.dilate(); opencv.dilate(); opencv.dilate();
  opencv.blur(4);
  opencv.threshold(160);
  // 白黒逆転してマスク画像にする
  opencv.invert();
  PImage mask = opencv.getSnapshot();
  // 裏画面にグラフィックを描く
  screen.beginDraw();
  screen.background(0);
  screen.mask(mask);
  noFill();
  
  //移動物体の輪郭を赤く塗る
  screen.pushMatrix();
  screen.stroke(255, 0, 0);
  screen.strokeWeight(3);
  screen.noFill();
  for (Contour contour : opencv.findContours()) {
    screen.beginShape();
    for (PVector point : contour.getPoints()){
      screen.vertex(point.x, point.y);
    }
    screen.endShape(CLOSE);
  }
  screen.popMatrix();
  screen.endDraw();
  // 画面表示する
  image(screen, (width/2.0 - screen.width)/2, (height/2.0 - screen.height)/2 + 200);
}
void captureEvent(Capture c) {
  c.read();
}
