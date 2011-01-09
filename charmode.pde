
cmWorld world = new cmWorld(40,40,10);



void keyPressed() {
  switch(keyCode){
     case 37:
        player.move(CMLEFT);
      break; 
     case 38:
        player.move(CMUP);
      break; 
     case 39:
        player.move(CMRIGHT);
      break; 
     case 40:
        player.move(CMDOWN);
      break; 
  }
}

class Wall extends cmThing {
  Wall(cmWorld w){
     super(w); 
    String s[] = {
     "XXXXXXX.XX"+ 
     "XXXXXXXXXX"+ 
     "XXXX.XXXXX"+ 
     "XXXXXXXXXX"+ 
     "XXXXXXXXXX"+ 
     "XXXX.XXXXX"+ 
     "XXXXXXXXXX"+ 
     "X.XXXXXXXX"+ 
     "XXXXXXX.XX"+ 
     "XXXXXXXXXX" };
      
  
     setGraphics(s);
  }
  
  
}


class Smile extends cmThing {

  Smile(cmWorld w) {
    super(w);

    String[] s = {
      "...XXXX..."+
      "...XXXX..."+
      ".....XX..."+
      "XXX..XXX.."+
      "XXXXXXXX.."+
      "....XXXX.."+
      "...XXXX..."+
      "..XX..XX.."+
      "XXXX..XXXX"+
      "XXXX....XXX",
      
      "...XXXX..."+
      "...XXXX..."+
      ".....XX..."+
      "XXX..XXX.."+
      "XXXXXXX.X."+
      "....XXX.X."+
      "....XX...."+
      "....X.X..."+
      "...XXXX..."+
      "...XXXX..."
    
    };
     setGraphics(s);
  }
}



/////////////////////////
Smile player;
void setup() {
  //frameRate(1);
  int sz = 400;
  size(400,400);    


 player = new Smile(world);
  world.warpToEmptyishRandom(player);
  //world.add(player);
  for(int i = 0; i < 50; i++){
    Wall w = new Wall(world);
    world.warpToEmptyishRandom(w);
  }


}
void draw() {
  background(200);
  world.draw();
}

//-example of use --

//--cm itself--


  //looks like there are no ENUMS :-(
int CMLEFT = 0;
int CMRIGHT  = 1;
int CMUP = 2;
int CMDOWN = 3;
int CMROTATE = 1;    
int CMMIRROR = 2;
  
  
class cmWorld {
  int WIDTH, HEIGHT; //squares across
  int TILESIZE; //size of each tile
  cmTile world[][];
  cmWorld(int w, int h, int s) {
    WIDTH = w;
    HEIGHT = h;
    TILESIZE = s;
    world = new cmTile[w][h];


    for(int y = 0; y < HEIGHT; y++) {
      for(int x = 0; x < WIDTH; x++) {
        world[x][y] = new cmTile();
      }
    }
  }

  int newX(int x, int dir) {
    if(dir == CMLEFT) return (WIDTH+x - 1) % WIDTH;
    if(dir == CMRIGHT) return (WIDTH+x + 1)%WIDTH;
    return (WIDTH+x)%WIDTH;
  }
  int newY(int y, int dir) {
    if(dir == CMUP) return (HEIGHT+y - 1)%HEIGHT;
    if(dir == CMDOWN) return (HEIGHT+y + 1)%HEIGHT;
    return (HEIGHT+y)%HEIGHT;
  }

  void add(cmThing t) {
    println(t);
    world[t.x][t.y].add(t);        
    //tile.add(t);
  }
  
  void warpToEmptyishRandom(cmThing t){
     int x = (int)(Math.random()*WIDTH); 
     int y = (int)(Math.random()*HEIGHT); 

     while(! world[x][y].clear()){
          x = (int)(Math.random()*WIDTH); 
          y = (int)(Math.random()*HEIGHT); 
     }
     move(t,x,y);
  }
  
  
  boolean move(cmThing t, int newx, int newy){
      int oldx = t.x; int oldy = t.y;

      if(!world[newx][newy].clear()){
        return false;
      }


      if(oldx != -1 & oldy != -1){
            world[oldx][oldy].remove(t); 
         }
         println("add to "+newx+" "+newy);
          world[newx][newy].add(t);
          t.x = newx; t.y = newy;

          return true;
  }
  void draw() {
    loadPixels();
    for(int y = 0; y < HEIGHT; y++) {
      for(int x = 0; x < WIDTH; x++) {
        cmTile s = world[x][y];
        s.draw();
      }
    }   
    updatePixels();
  }
  void setPixel(int x, int y, color c) {
    pixels[x + (TILESIZE * WIDTH * y)] = c;
  }
}
class cmTile {
  ArrayList contents = new ArrayList();   
  
  boolean clear(){
   
     for(int i=0;i<contents.size();i++) {
      cmThing t = (cmThing) contents.get(i);
      if(t.blocks) return false;
    }
     return true; 
  }
  
  void add(cmThing t) {
    contents.add(t);
  }  
  void remove(cmThing t){
contents.remove(t); 
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
  boolean g[][][];
  int facing = CMLEFT;
  int frame = 0;
  int framecount = 0;
  boolean blocks = true;
  
  cmThing(cmWorld w) {
    world = w;
    x = -1;
    y = -1;
  }
  void setGraphics(String[] s) {
    framecount = s.length;
    g = new boolean[4][framecount][];

    for(int i = 0; i < framecount; i++){
      g[CMLEFT][i] = cmBitStringToBoolean(s[i]);
      g[CMRIGHT][i] = cmMirrorBoolArray(g[CMLEFT][i],world.TILESIZE);
      g[CMUP][i] = cmRotateBoolArrayCW(g[CMLEFT][i],world.TILESIZE);
      g[CMDOWN][i] = cmRotateBoolArrayCW(g[CMRIGHT][i],world.TILESIZE);
    }
  }
  
  void move(int dir){
    facing = dir;
    int newx = world.newX(x,dir);
    int newy = world.newY(y,dir);
    if(world.move(this,newx,newy)){
       x = newx;
      y = newy; 
      frame = (frame + 1) % framecount;
    }
  }
  
  
  void draw() {
    if(x == -1 || y == -1) {println("o");return;}
    color black = color(0);
    fill(black);
    noStroke();

    for(int r = 0; r < world.TILESIZE; r++) {
      for(int c = 0; c < world.TILESIZE; c++) {
        // print(s.charAt((r*world.TILESIZE)+c));
        int pos = cmXYtoOff(c,r,world.TILESIZE); //(r*world.TILESIZE)+c;

        if(g[facing][frame][pos]) {
          world.setPixel(x * world.TILESIZE + c, y * world.TILESIZE + r,black);

          //set();
        }
      }  
    }
  }
}


int cmXYtoOff(int x, int y, int w){
    return (y*w)+x;
}


boolean[] cmMirrorBoolArray(boolean[] o, int sz){
  boolean[] n = new boolean[o.length];
  for(int y = 0; y < sz; y++){
    for(int x = 0; x < sz; x++){
      boolean oldval =  o[cmXYtoOff(sz-x-1,y,sz)];
       n[cmXYtoOff(x,y,sz)] = oldval;
    }
  }
  return n;  
}

boolean[] cmRotateBoolArrayCW(boolean[] o, int sz){
  boolean[] n = new boolean[o.length];
  for(int y = 0; y < sz; y++){
    for(int x = 0; x < sz; x++){
      boolean oldval =  o[cmXYtoOff(y,sz-x-1,sz)];
       n[cmXYtoOff(x,y,sz)] = oldval;
    }
  }
  return n;
}

  //conver X..X..XXX to boolean array
  boolean[] cmBitStringToBoolean(String s){
    boolean[] g = new boolean[s.length()];
    for(int i = 0; i < s.length(); i++) {
      if(! s.substring(i,i+1).equals(".")) {
        g[i] = true;
      }
    }
    return g;
  }

