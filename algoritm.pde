float max(float[][] arr) {
  float res = arr[0][0];
  for (int i = 0; i < arr.length; i++) {
    for (int j = 0; j < arr[0].length; j++) {
      if (res < arr[i][j])
        res = arr[i][j];
    }
  }
  return res;
}

void smootH(PImage img) {
  img.loadPixels();
  int w = img.width;
  int h = img.height;
  for (int y = 0; y < h - 1; y++) {
    for (int x = 0; x < w - 1; x++) {

      int i = x + 1;
      int j = y;

      if (img.pixels[x + w * y] != img.pixels[x + i * j]) {
        //println("sss");
        float f = 0.05;

        float r = red(img.pixels[x + w * y]);
        float g = green(img.pixels[x + w * y]);
        float b = blue(img.pixels[x + w * y]);


        float r1 = red(img.pixels[i + w * j]);
        float g1 = green(img.pixels[i + w * j]);
        float b1 = blue(img.pixels[i + w * j]);

        float dr = abs(r - r1) * f;
        float dg = abs(g - g1) * f;
        float db = abs(b - b1) * f;

        if (r > r1) {
          r -= dr;
          r1 += dr;
        } else {
          r += dr;
          r1 -= dr;
        }

        if (g > g1) {
          g -= dg;
          g1 += dg;
        } else {
          g += dg;
          g1 -= dg;
        }

        if (b > b1) {
          b -= db;
          b1 += db;
        } else {
          b += db;
          b1 -= db;
        }

        img.pixels[x + w * y] = color(r, g, b);
        img.pixels[i + w * j] = color(r1, g1, b1);
      }
    }
  }
  img.updatePixels();
}
