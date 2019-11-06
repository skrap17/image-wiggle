class facer {
  ArrayList<ArrayList<PVector>> faces;
  float[][] R;
  int[][] bounds;
  int w, h;
  int eps = 1;
  float theta = 0.1;

  int ind(int x, int y) {
    return x + y * w;
  }

  facer(PImage img) {
    img.loadPixels();
    w = img.width;
    h = img.height;
    // theta = 0.00000015 * w * h;
    R = new float[img.width][img.height];
    bounds = new int[w][h];
    faces = new ArrayList<ArrayList<PVector>>();
    for (int i = 0; i < img.width; i++) {
      for (int j = 0; j < img.height; j++) {
        if (img.pixels[ind(i, j)] == color(255))
          bounds[i][j] = 1;
      }
    }
  }

  void dist_to_b() {
    for (int x = 0; x < w; x++) {
      for (int y = 0; y < h; y++) {
        if (bounds[x][y] != 1) {
          float d = max(w, h);
          for (int i = 0; i < w; i++) {
            for (int j = 0; j < h; j++) {
              if (bounds[i][j] == 1)
                d = min(d, dist(x, y, i, j));
            }
          }
          R[x][y] = d;
          // println(x, y, d);
        }
      }
    }
    println("distance to boundary calculated");
  }

  void facing(PVector[][] G) {
    for (int y = 0; y < h; y++) {
      for (int x = 0; x < w; x++) {
        if (bounds[x][y] == 0) {
          ArrayList<PVector> stack = new ArrayList<PVector>();
          int x_ = x;
          int y_ = y;
          stack.add(new PVector(x_, y_)); 
          int cur  = 0;
          boolean stop = false;
          float cap = w * h * 0.001;
          while (cur < stack.size() && !stop && stack.size() <= cap) {
            x_ = int(stack.get(cur).x);
            y_ = int(stack.get(cur).y);
            for (int i = max(0, x_ - eps); i < min(w, x_ + eps + 1) && true; i++) {
              for (int j = max(0, y_ - eps); j < min(h, y_ + eps + 1) && true; j++) {
                if (bounds[i][j] != -1) {
                  if (abs(PVector.angleBetween(G[x_][y_], G[i][j])) <= theta) {
                    bounds[i][j] = -1; 
                    stack.add(new PVector(i, j));
                  }
                } else if (bounds[i][j] == 1) {
                  //stop = true;
                }
              }
            }
            cur++;
          }
          faces.add(stack);
        }
      }
    }
    println("done facing");
  }

  PImage colouring(String fname) {
    PImage input = loadImage(fname);
    input.loadPixels();
    PImage res = createImage(w, h, RGB);
    res.loadPixels();
    for (Iterator<ArrayList<PVector>> i = faces.iterator(); i.hasNext(); ) {
      ArrayList<PVector> curface = i.next();
      float r = 0, g = 0, b = 0;
      //color[] c = new color[curface.size()];
      //int k = 0;
      for (Iterator<PVector> j = curface.iterator(); j.hasNext(); ) {
        PVector curpoint = j.next();
        r += red(input.pixels[ind(int(curpoint.x), int(curpoint.y))]);
        g += green(input.pixels[ind(int(curpoint.x), int(curpoint.y))]);
        b += blue(input.pixels[ind(int(curpoint.x), int(curpoint.y))]);
        //c[k] = color(r, g, b);
        //k++;
      }
      r /= curface.size();
      g /= curface.size();
      b /= curface.size();

      for (Iterator<PVector> j = curface.iterator(); j.hasNext(); ) {
        PVector curpoint = j.next();
        //res.pixels[ind(int(curpoint.x), int(curpoint.y))] = c[color_pick(c)];
        res.pixels[ind(int(curpoint.x), int(curpoint.y))] = color(r, g, b);
      }
    }

    for (int y = 0; y < h; y++) {
      for (int x = 0; x < w; x++) {
        if (bounds[x][y] == 1) {
          boolean stop = false;
          for (int i = max(0, x - 1); i < min(w, x + 2) && !stop; i++) {
            for (int j = max(0, y - 1); j < min(h, y + 2) && !stop; j++) {
              if (bounds[i][j] != 1) {
                stop = true;
                res.pixels[ind(x, y)] = res.pixels[ind(i, j)];
              }
            }
          }
        }
      }
    }

    res.updatePixels();
    return res;
  }

  void align(PVector[][] G) {
    for (int y = 0; y < h; y++) {
      for (int x = 0; x < w; x++) {
        if (bounds[x][y] == 0) {
          ArrayList<PVector> stack = new ArrayList<PVector>();
          int x_ = x;
          int y_ = y;
          //int eps;
          boolean more = true;
          while (more) {
            bounds[x_][y_] = -1;
            more = false;
            stack.add(new PVector(x_, y_));  
            // eps = eps_calc(x_, y_);
            for (int i =  max(0, x_ - eps); i < min(w, x_ + eps + 1) && !more; i++) {
              for (int j = max(0, y_ - eps); j < min(h, y_ + eps + 1) && !more; j++) {
                if (bounds[i][j] == 0) {
                  if (abs(PVector.angleBetween(G[x_][y_], G[i][j])) <= theta) {
                    more = true;
                    x_ = i;
                    y_ = j;
                  }
                } else if (bounds[i][j] == 1) {
                  //more = true;
                }
              }
            }
          }
          faces.add(stack);
          //println("newline");
        }
      }
    }
  }
}


int color_pick(color[] c) {

  int[] times = new int[c.length];
  for (int i = 0; i < c.length; i++) {
    for (int j = i; j < c.length; j++) {
      if (c[i] == c[j])
        times[i]++;
    }
  }
  int max = 0;
  for (int i = 1; i < times.length; i++) {
    if (times[max] < times[i])
      max = i;
  }
  return max;
}
