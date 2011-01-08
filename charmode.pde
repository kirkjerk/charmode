
cmWorld world = new cmWorld(50,50,8);



void keyPressed() {
  println(keyCode);
  switch(keyCode){
     case 37:
        player.move(cm.GOLEFT);
      break; 
     case 38:
        player.move(cm.GOUP);
      break; 
     case 39:
        player.move(cm.GORIGHT);
      break; 
     case 40:
        player.move(cm.GODOWN);
      break; 
  }
}

class Smile extends cmThing {

  Smile(cmWorld w, int px, int py) {
    super(w,px,py);
    String s = 
      "XXXXXXXX"+
      "X......X"+
      "X.X..X.X"+
      "X......X"+
      "X.X..X.X"+
      "X..XX..X"+
      "X......X"+
      "XXXXXXXX";
     setGraphics(s);
  }
}



/////////////////////////
Smile player;
void setup() {
  int sz = 400;
  size(400,400);    


 player = new Smile(world,4,4);

  world.add(player);


}
void draw() {
  background(200);
  world.draw();
}

//-example of use --

//--cm itself--



static class cm {
  //looks like there are no ENUMS :-(
  static int GOLEFT = 1;
  static int GORIGHT  = 2;
  static int GOUP = 3;
  static int GODOWN = 4;
  static int ROTATE = 1;    
  static int MIRROR = 2;
}

class cmWorld {
  int WIDTH, HEIGHT; //squares across
  int TILESIZE; //size of each tile
  smTile world[][];
  cmWorld(int w, int h, int s) {
    WIDTH = w;
    HEIGHT = h;
    TILESIZE = s;
    world = new smTile[w][h];


    for(int y = 0; y < HEIGHT; y++) {
      for(int x = 0; x < WIDTH; x++) {
        world[x][y] = new smTile();
      }
    }
  }

  int newX(int x, int dir) {
    if(dir == cm.GOLEFT) return x - 1;
    if(dir == cm.GORIGHT) return x + 1;
    return x;
  }
  int newY(int y, int dir) {
    if(dir == cm.GOUP) return y - 1;
    if(dir == cm.GODOWN) return y + 1;
    return y;
  }

  void add(cmThing t) {
    world[t.x][t.y].add(t);        
    //tile.add(t);
  }
  boolean move(cmThing t, int oldx, int oldy, int newx, int newy){
         world[oldx][oldy].remove(t); 
          world[newx][newy].add(t);
          return true;
  }
  void draw() {
    loadPixels();
    for(int y = 0; y < HEIGHT; y++) {
      for(int x = 0; x < WIDTH; x++) {
        smTile s = world[x][y];
        s.draw();
      }
    }   
    updatePixels();
  }
  void setPixel(int x, int y, color c) {
    pixels[x + (TILESIZE * WIDTH * y)] = c;
  }
}
class smTile {
  ArrayList contents = new ArrayList();   
  void add(cmThing t) {
    contents.add(t);
  }  
  void remove(cmThing t){
     println(contents.remove(t)); 
      println(contents.size());
  }
  void draw() {
    for(int i=0;i<contents.size();i++) {
      cmThing t = (cmThing) contents.get(i);
      t.draw();
    }
  }
}



class cmThing {
  cmWorld world;
  int x,y;
  boolean g[];
  cmThing(cmWorld w, int px, int py) {
    world = w;
    x = px;
    y = py;
  }
  void setGraphics(String s) {
    g = new boolean[s.length()];
    for(int i = 0; i < s.length(); i++) {
      if(! s.substring(i,i+1).equals(".")) {
        g[i] = true;
      }
    }
  }
  
  void move(int dir){
    int oldx = x;
    int oldy = y;  
    int newx = world.newX(x,dir);
    int newy = world.newY(y,dir);
    if(world.move(this,oldx,oldy,newx,newy)){
       x = newx;
      y = newy; 
    }
  }
  
  void draw() {
    color black = color(0);
    fill(black);
    noStroke();

    for(int r = 0; r < world.TILESIZE; r++) {
      for(int c = 0; c < world.TILESIZE; c++) {
        // print(s.charAt((r*world.TILESIZE)+c));
        int pos = (r*world.TILESIZE)+c;
        if(g[pos]) {
          world.setPixel(x * world.TILESIZE + c, y * world.TILESIZE + r,black);

          //set();
        }
      }  
      //  println("");
      //println("");
    }
  }
}

