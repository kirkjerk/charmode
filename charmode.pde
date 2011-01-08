cmWorld world = new cmWorld(50,50,8);

void setup(){
    int sz = 400;
    size(400,400);    
  
String s = 
"XXXXXXXX"+
"X......X"+
"X.X..X.X"+
"X......X"+
"X.X..X.X"+
"X..XX..X"+
"X......X"+
"XXXXXXXX";
    cmThing t = new cmThing(world,3,3,s);
   
    world.add(t);


   world.draw(); 
}

//-example of use --

//--cm itself--


class cm {
//looks like there are no ENUMS :-(
int LEFT = 1;
int RIGHT  = 2;
int UP = 3;
int DOWN = 4;
int ROTATE = 1;    
int MIRROR = 2;
}

class cmWorld {
    int WIDTH, HEIGHT; //squares across
    int TILESIZE; //size of each tile
    smTile world[][];
    cmWorld(int w, int h, int s){
           WIDTH = w;
           HEIGHT = h;
           TILESIZE = s;
           world = new smTile[w][h];
           
           
           for(int y = 0; y < HEIGHT; y++){
            for(int x = 0; x < WIDTH; x++){
                world[x][y] = new smTile();    
            }   
        }
    }
    
    void add(cmThing t){
        world[t.x][t.y].add(t);        
        //tile.add(t);
    }
    void draw(){
        for(int y = 0; y < HEIGHT; y++){
             for(int x = 0; x < WIDTH; x++){
                smTile s = world[x][y];
                s.draw();
            }
        }   
    }
    
}
class smTile {
     ArrayList contents = new ArrayList();   
    void add(cmThing t){
        contents.add(t);   
    }  
    void draw(){
      for(int i=0;i<contents.size();i++){
        cmThing t = (cmThing) contents.get(i);
        t.draw();
      } 
    }
}



class cmThing {
    cmWorld world;
    int x,y;
    boolean g[];
    cmThing(cmWorld w, int px, int py, String s){
        world = w;
        x = px;
        y = py;
        g = new boolean[s.length()];
        for(int i = 0; i < s.length(); i++){
           if(! s.substring(i,i+1).equals(".")){
              g[i] = true; 
           }
        }
    }
    void draw(){
      color black = color(0);
      fill(black);
      noStroke();
      
      for(int r = 0; r < world.TILESIZE; r++){
        for(int c = 0; c < world.TILESIZE; c++){
         // print(s.charAt((r*world.TILESIZE)+c));
        int pos = (r*world.TILESIZE)+c;
          if(g[pos]){
            set(x * world.TILESIZE + c, y * world.TILESIZE + r,black);
          } 
        }  
            //  println("");
        //println("");
    }
    }
}


