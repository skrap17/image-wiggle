import java.util.*; 


String[] fnames = {"shrek.jpg", "land.jpg", "owl.jpg", "bridge.jpg", "test1.jpg", 
  "test2.jpg", "lisa.jpg", "tree.jpg", "aaa.png", "hog.jpg", 
  "butter.jpg", "car.jpg", "panda.jpg", "test3.jpeg", "undertale2.png", "me.jpeg", "test.jpeg"};

PImage img, res;
PImage res1;
detector d;
facer f;

int num = int(random(fnames.length));
String fname;


void setup() {
  size(500, 500); 
  surface.setResizable(true);
  fname = "input/" + fnames[num];
  img = loadImage(fname);
  surface.setSize(img.width, img.height);
  surface.setLocation(displayWidth / 2 - width / 2, displayHeight / 2 - height / 2);
  String name, resol;
  name = fname.substring(fname.lastIndexOf('/') + 1, fname.indexOf('.'));
  resol = fname.substring(fname.lastIndexOf('.') + 1);

  d = new detector(fname);
  res = d.detect().copy();

  res.save("results/" + name + "_edges." + resol);

  println("done edging");
  background(0);

  f = new facer(res);
  //f.dist_to_b();
  //println(f.R.length, f.R[0].length, img.width, img.height);
  f.facing(d.Gog);
  println(f.faces.size());
  res1 = f.colouring(fname);
  res1.save("newout/" + name + "1." + resol);
  println("done");
}




void draw() {
  //image(res, 0, 0);

  image(res1, 0, 0);
  //colorMode(HSB);
  //for (ArrayList<PVector> face : f.faces){
  //  stroke(random(255), 255, 255);
  //  for (PVector point : face){
  //    point(point.x, point.y);
  //  }
  //}

  //colorMode(HSB);
  //float maxst = max(f.R);
  //for (int i = 0; i < img.width; i++) {
  //  for (int j = 0; j < img.height; j++) {
  //    stroke(map(f.R[i][j], 0, maxst, 0, 255), 255, 255);
  //    point(i, j);
  //  }
  //}
  //stroke(255, 0, 0);
  //for( PVector v : f.faces.get(10))
  //  point(v.x, v.y);
  noLoop();
}
