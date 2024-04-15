// ビデオライブラリとOpenCVライブラリをインストールしておく
import processing.video.*;
import gab.opencv.*;
Capture video;
OpenCV opencv;
PGraphics screen;
PImage focus;
void setup() {
  int height = 360;
  int width = 480;
  fullScreen();
  frameRate(30);
  fullScreen();
  focus = loadImage("nc193607.png");
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
  video = new Capture(this, width, height,cameras[1]);
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
  //輪郭を検出して輪郭の内側を塗りつぶす
  pushMatrix();
  stroke(0, 0, 0);
  strokeWeight(3);
  for (Contour contour : opencv.findContours()) {
    screen.beginShape();
    for (PVector point : contour.getPoints()){
      fill(0, 0, 0);
      vertex(point.x, point.y);
    }
    endShape(CLOSE);
  }
  popMatrix();
  //白黒逆転してマスク画像にする
  opencv.invert();
  PImage mask = opencv.getSnapshot();
  // 裏画面にグラフィックを描く
  screen.beginDraw();
  screen.background(0);
  //scale(40);
  tint(0, 255, 0);
  screen.image(focus,0,0);
  screen.endDraw();
  // マスクを適用する
  screen.mask(mask);
  // 画面表示する
  image(screen, (width/2.0 - screen.width)/2, (height/2.0 - screen.height)/2 + 200);
}
void captureEvent(Capture c) {
  c.read();
}
