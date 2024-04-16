PShape model;//島の土台
PShape bird;//鳥のオブジェクト
PShape tree;//木のオブジェクト
PImage fish;
PImage tex, tex2;
//降らせる量
PVector[] snow = new PVector[150];
//カメラ移動
PVector cam = new PVector(0, -500, 0);
void setup() {
  size(1000, 1000, P3D);
  frameRate(30);
  model = loadShape("snowdome.obj");
  tex = loadImage("S__38682639.jpg");
  bird = loadShape("12213_Bird_v1_l3.obj");
  tree = loadShape("untitled.obj");
  fish = loadImage("fish.jpg");
  tex2 = loadImage( "2012120301 (2).jpg");

  textureMode(NORMAL);
  //降らせる範囲ランダムｘ、ｙ、ｚ
  for (int i = 0; i < snow.length; i++) {
    snow[i] = new PVector(
      random(-200, 200), 
      random(-300, 0), 
      random(0, 200));
  }
}

void draw() {
  background(198, 198, 198);
  float a = radians(frameCount);
  cam.x = 2000 * cos(a);
  cam.z = 2000 * sin(a);
  camera(cam.x, cam.y, cam.z, width/2, height/2, 0, 0, 1, 0);

  noStroke();
  lights();
  perspective();
  pointLight(245, 245, 245, 0, -500, 0);
  translate(width / 2, height / 2);
  if (mousePressed) {
    background(0);
    for (PVector s : snow) {
      pushMatrix();
      translate(s.x, s.y, s.z);
      // 視点へ向かうベクトルを求める、減算
      PVector v = PVector.sub(cam, s); 
      // 横にRy回転し，正面を視点に向ける、座標()を指定して角度を求める
      rotateY(atan2(v.x, v.z));
      // 縦にRx回転し，正面を視点に向ける、２点間の距離、座標()を指定して角度を求める
      float vxz = dist(0, 0, v.x, v.z);
      rotateX(atan2(-v.y, vxz));
      //テクスチャの貼り付けUV座標
      beginShape(QUADS);
      texture(tex);
      vertex(-10, -20, 0, 0, 0);
      vertex( 10, -20, 0, 1, 0);
      vertex( 10, 0, 0, 1, 1);
      vertex(-10, 0, 0, 0, 1);
      endShape();
      popMatrix();
      //落ちてくる速さ
      s.y += 5;
      //ずっと降らせるため、ｙが-100を超えたらｙ軸のー400の位置にもどす
      if (s.y > -100) s.y = -300;
    }
  }
  //スノードームの下の部分のメソッドの呼び出し
  island(100, 500, 500); //円柱の作成(高さ,横,縦)

  //スノードームの上の部分
  stroke(212, 251, 252, 100);
  strokeWeight(3);
  line(250, 10, 250, 250, -350, 250);
  line(-250, 10, 250, -250, -350, 250);
  line(-250, 10, -250, -250, -350, -250);
  line(250, 10, -250, 250, -350, -250);
  line(250, -350, -250, 250, -350, 250);
  line(250, -350, 250, -250, -350, 250);
  line(-250, -350, 250, -250, -350, -250);
  line(-250, -350, -250, 250, -350, -250);
  stroke(255, 255, 255, 100);
  strokeWeight(1);
  line(150, -350, 250, 250, -215, 250);
  line(100, -350, 250, 250, -150, 250);
  line(150, -350, -250, 250, -215, -250);
  line(100, -350, -250, 250, -150, -250);
  line(250, -350, -150, 250, -215, -250);
  line(250, -350, -100, 250, -150, -250);
  line(-250, -350, -150, -250, -215, -250);
  line(-250, -350, -100, -250, -150, -250);
  line(150, -350, 250, 250, -350, 115);
  line(100, -350, 250, 250, -350, 50);

  //机
  fill(200, 245, 245);
  pushMatrix();
  translate(0, 100, 0);
  box(1000, 10, 1000);
  translate(450, 150, 450);
  box(50, 300, 50);
  translate(-900, 0, 0);
  box(50, 300, 50);
  translate(0, 0, -900);
  box(50, 300, 50);
  translate(900, 0, 0);
  box(50, 300, 50);
  popMatrix();
  pushMatrix();

  //床
  fill(205, 133, 63);
  translate(0, 300, 0);
  beginShape(QUADS);
  texture(tex2);
  textureMode(NORMAL);
  noStroke();
  float q, p;
  for (q = -1100; q < 1100; q += 100 ) {
    for (p = -1100; p < 1100; p += 100) {
      vertex(q, 101, p, 0, 0);
      vertex(q, 101, p + 100, 1, 0);
      vertex(q + 100, 101, p + 100, 1, 1);
      vertex(q + 100, 101, p, 0, 1);
    }
  }
  endShape();
  popMatrix();

  fill(255);

  //島の土台の３Dモデル表示
  pushMatrix();
  translate(-5, -30, -80);
  rotate(PI);
  scale(35);
  shape(model);
  popMatrix();

  pushMatrix();//鳥
  translate(50, -120, -30);
  rotateX(PI/2);
  rotateY(PI/10);  
  rotateZ(PI/6);//鳥の位置調整
  scale(5);//大きさ調整
  shape(bird);
  popMatrix();

  beginShape();//木
  translate(-150, -200, -70);
  rotateX(-PI/2);
  rotateY(PI/10);
  rotateZ(-PI/6);//木の位置調整
  scale(30);//大きさ調整
  shape(tree);
  endShape();
}

//スノードームの下の部分のメソッド中身
void island(float y, float x, float z) {
  //上面
  fill(3, 156, 255, 128);
  noStroke();
  beginShape(QUADS);
  vertex(-x/2, -y/2, z/2);
  fill(255);
  vertex(-x/2, -y/2, -z/2);
  fill(255);
  vertex(x/2, -y/2, -z/2);
  fill(10, 73, 255, 128);
  vertex(x/2, -y/2, z/2); 
  fill(10, 73, 255, 128);
  endShape();


  //底面
  fill(219, 219, 219, 128);
  noStroke();
  beginShape(QUADS);
  vertex(-x/2, y/2, -z/2);
  vertex(x/2, y/2, -z/2);
  vertex(x/2, y/2, z/2);
  vertex(-x/2, y/2, z/2);
  endShape();

  //側面１
  fill(255);
  beginShape(QUADS);
  vertex(-x/2, -y/2, z/2);
  vertex(x/2, -y/2, z/2);
  vertex(x/2, y/2, z/2);
  vertex(-x/2, y/2, z/2);
  texture(fish);
  textureMode(NORMAL);
  vertex(-x/2, -y/2, z/2, 0, 0);
  vertex(x/2, -y/2, z/2, 1, 0);
  vertex(x/2, y/2, z/2, 1, 1);
  vertex(-x/2, y/2, z/2, 0, 1);
  endShape();

  //側面２
  beginShape(QUADS);
  vertex(x/2, -y/2, -z/2);
  vertex(x/2, y/2, -z/2);
  vertex(x/2, y/2, z/2);
  vertex(x/2, -y/2, z/2);
  texture(fish);
  textureMode(NORMAL);
  vertex(x/2, -y/2, -z/2, 1, 0);
  vertex(x/2, y/2, -z/2, 1, 1);
  vertex(x/2, y/2, z/2, 0, 1);
  vertex(x/2, -y/2, z/2, 0, 0);
  endShape();

  //側面３
  beginShape(QUADS);
  vertex(-x/2, -y/2, -z/2);
  vertex(x/2, -y/2, -z/2);
  vertex(x/2, y/2, -z/2);
  vertex(-x/2, y/2, -z/2);
  texture(fish);
  textureMode(NORMAL);
  vertex(-x/2, -y/2, -z/2, 1, 0);
  vertex(x/2, -y/2, -z/2, 0, 0);
  vertex(x/2, y/2, -z/2, 0, 1);
  vertex(-x/2, y/2, -z/2, 1, 1);
  endShape();

  //側面４
  beginShape(QUADS);
  vertex(-x/2, -y/2, -z/2);
  vertex(-x/2, y/2, -z/2);
  vertex(-x/2, y/2, z/2);
  vertex(-x/2, -y/2, z/2);
  texture(fish);
  textureMode(NORMAL);
  vertex(-x/2, -y/2, -z/2, 0, 0);
  vertex(-x/2, y/2, -z/2, 0, 1);
  vertex(-x/2, y/2, z/2, 1, 1);
  vertex(-x/2, -y/2, z/2, 1, 0);
  endShape();
}
//スノードームの下の部分メソッド終了
