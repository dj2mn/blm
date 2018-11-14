// this file contains code to load and display a 3d object

//  The object layer will display a wireframe object
//  loaded from .obj (Wavefront) file. 
//
//  object/shape/n      = index number for array list of filenames in the data/obj directory. 0 is off. (version 2 to be loaded from remote URL?)
//  object/scale/n    =
//  object/stroke/color/n
//  object/stroke/h/n = 
//  object/stroke/s/n =
//  object/stroke/b/n =
//  object/stroke/a/n   =
//  object/fill/color/n
//  object/fill/h/n   =
//  object/fill/s/n   =
//  object/fill/b/n   =
//  object/fill/a/n     =
//  object/dx/n    =
//  object/dy/n    =
//  object/rx/n    =
//  object/ry/n    =
//  object/rz/n    =
//  object/trigger1/n
//  object/trigger2/n
//  object/trigger3/n
//  object/trigger4/n
//  object/value1/n
//  object/value2/n
//  object/value3/n
//  object/value4/n

// .obj files appear to define things within a 1 x 1 x 1 space.
// so mapping coords directly to screen aint gonna get us very far
// until i work out a better way, i'll just use this as an initial scaling value
int _GLOBALSCALE_ = 180;

class KObject {


  // variables for OSC input
  int id = 8,
      fileindex = 0,
      strokecolor = #00FF00,
      strokew = 1,
      fillcolor,
      fillh,
      fills,
      fillb,
      filla,
      rx,
      prevrx,
      ry,
      prevry,
      rz,
      prevrz,
      t1,
      t2,
      t3,
      t4;
  float scale = 1,
      strokeh,
      strokes,
      strokeb,
      strokea,
        dx = 0,
        dy = 0,
        dz = 0,
        effect1val = 0,
        effect1timer = 0,
        v1,
        v2,
        v3,
        v4;

  
  ArrayList<String> objfilenames = new ArrayList<String>(); // set to list of .obj filenames in data/obj directory
 int numobjfiles; // set to number of .obj files in data/obj directory 
  String[] objectdata; // .obj data is loaded into this array
  
  int[][] faces; // = new int[2000][3]; // this and the following hold the actual object data, i think faces are technically vertices here
  float nodes[][]; // = new float[2000][]; // 2000 is a horrible hack until i can replace these with ArrayList objects.  
  int nodecount = 0;
  int facecount = 0;

  boolean show = false,
          showCoords = false,
          showVerts = false,
          showEdges = true,
          flicker = false,
          dataisloaded = false;

  
  KObject() { 
    // get filenames from data/obj/ directory
    // needs way more smarts.. filtering for .obj files only, graceful fail on file-not-found.. etc..
    File dir = new File(dataPath("obj/"));
    String[] filenames = dir.list();
   // int numfiles = filenames.length;
    numobjfiles = 0;
    
    println(filenames.length + " files found in obj/ :");
    for (int i = 0; i < filenames.length; i++ ) {
      println(i + ":" + filenames[i]);
      if( filenames[i].endsWith(".obj")) {
        numobjfiles++;
        println(filenames[i] + " is an .obj file");
        objfilenames.add(filenames[i]);
      }
      
      println(filenames.length + " files, " + numobjfiles + " of which are .obj files");
    }
    load_obj(this.id);
  }
  
    
  void init() {
    
  }
  
  void update() {
    this.rotateX(this.dx);
    this.rotateY(this.dy);
    this.rotateZ(this.dz);

  }
  
  
  //
  // method to load object data from a file
  // 
  void load_obj(int theIndex) {
      this.id = theIndex;
      println("this.id = " + this.id +" : loading " + objfilenames.get(this.id));

      // this needs some sort of try/catch around it ay.
      objectdata = loadStrings("obj/" + objfilenames.get(this.id));
      println("objectdata loaded");

      nodecount = 0;
      facecount = 0;
      // this.id = theIndex;
      // first get the number of nodes and faces in the data
      // if line starts with v it's vertex/node data, 
      // if it starts with f it's face/edge data
      
      for (int i = 0; i < objectdata.length; i++) {
          if ( objectdata[i].charAt(0) == 'v' ) {
             nodecount ++;
          }
          if ( objectdata[i].charAt(0) == 'l' ) {
             facecount ++;
          }
      }
      println("object data parsed");
      println("nodecount " + nodecount);
      println("edgecount " + facecount);
  
    // now we know how big they need to be, we can initialise the arrays
    // but i'm not sure this is working it crashes 'randomly'
    // maybe nodes and faces should be ArrayLists?
    // update - declaring them with 2000 elements and making sure i don't create .obj files with more than that
//    nodes = null;
//    faces = null;
//    println("arrays nulled and re initialised");
 
 this.dataisloaded = false;
 
 nodes = new float[2000][3]; // this and the following hold the actual object data, i think faces are technically vertices here
 faces = new int[2000][];
 
  

    int nc = 0;
    int fc = 0; //counters 
    // look at each line and parse out data if needed
    for (int i = 0; i < objectdata.length; i++) {
      
      String line = objectdata[i];
  println("parsing data line: " + line);
      if ( line.charAt(0) == 'v' ) {
        //strip first 2 chars from line and split into 
        // an array of x y z coords
        float coords[] = float(split(line.substring(2,line.length()), ' '));

        nodes[nc][0] = coords[0] * _GLOBALSCALE_;
        nodes[nc][1] = coords[1] * _GLOBALSCALE_;
        nodes[nc][2] = coords[2] * _GLOBALSCALE_;
       // println("created node " + nodes[nc][0] + "," + nodes[nc][1] + "," + nodes[nc][2]);
        nc++; 
       }  

      if ( line.charAt(0) == 'l' ) {
        int face[] = int(split(line.substring(2,line.length()), ' ')); 
        println("face " + face + " facelength " + face.length);
        faces[fc] = new int[face.length];
        for (int j = 0; j < face.length; j++) {
          faces[fc][j] = face[j] - 1; // -1 because .obj file indexes start at 1 not 0
        //  println("faces[" + fc  + "][" + j + "] = " + (face[j] - 1));
        }
        fc++;
      }
println("nodecount:" + nodecount + " nc:"+ nc + " facecount:" + facecount + " fc:" + fc);
      
    }
    this.dataisloaded = true;
    println("data loaded and parsed successfully");
  } // end of load_obj method

  
void display() {
  if (!this.show) return; // no point running if we're not supposed to be showing
  
//println("object.display called");
   //   println("in object.display() stroke = " + this.strokecolor);
    pushMatrix();
    
    translate((width / 2) + this.dx, (height / 2) + this.dy);

//    println("I am displaying " + this.facecount + " faces");
    // walk the faces array[s]
    
    int drawamt = this.facecount - (int)map(this.v4,0,1,0,this.facecount);
      for (int i = 0; i < drawamt; i++) {

      for (int j = 0; j < faces[i].length; j++) {
        
          // get the endpoint coords of the edge from the nodes array
          float x0 = nodes[faces[i][j]][0] * this.scale;
          float y0 = nodes[faces[i][j]][1] * this.scale;
          int e1 = (j+1) % faces[i].length; //this joins each vertex to the next, and the last to the first
          float x1 = nodes[faces[i][e1]][0] * this.scale;
          float y1 = nodes[faces[i][e1]][1] * this.scale;
        
          //draw the edge
          if (this.showEdges) {
            strokeWeight(this.strokew);
           // colorMode(RGB,255);
            stroke(this.strokecolor);
          //  println("line " + x0 + "," + y0 + " - " + x1 + "," + y1);
            line(x0, y0, x1, y1);
           // float sin_t = sin(radians(this.rz));
           // float cos_t = cos(radians(this.rz));
 
           // line(x0 * cos_t - y0 * sin_t, y0 * cos_t + x0 * sin_t, x1 * cos_t - y1 * sin_t, y1 * cos_t + x1 * sin_t);
          }
  
//  fill(this.fillcolor);
//  beginShape();
//  vertex(nodes[10][0],nodes[10][1]);
//  vertex(nodes[0][0],nodes[0][1]);
// vertex(nodes[11][0],nodes[11][1]);
//  vertex(nodes[21][0],nodes[21][1]);
//  endShape(CLOSE);
//  
//  
  
  
          if (this.showVerts) { 
            fill(0,255,0);
            textFont(bGothic);
            textSize(10);
            textAlign(CENTER);
            text(str(i), lerp(x0,x1,.5), lerp(y0,y1,.5));
            fill(this.fillcolor);
          }
//          if (this.showCoords) {
//            fill(this.fillcolor);
//            textAlign(CENTER);
//            text(x0 + "," + y0, x0, y0);
//            text(x1 + "," + y1, x1, y1);                
//            }
      }
    }
    popMatrix();
    
  }
  
 //// rotates about the object's Z axis
void rotateZ(float theta) {
    theta = radians(theta);
    float sin_t = sin(theta);
    float cos_t = cos(theta);
    
    for (int n=0; n<this.nodecount; n++) {
        float[] node = nodes[n];
        float x = node[0];
        float y = node[1];
        node[0] = x * cos_t - y * sin_t;
        node[1] = y * cos_t + x * sin_t;
    }
}

//// rotates about the object's Y axis
void rotateY(float theta) {
    theta = radians(theta);
  float sin_t = sin(theta);
    float cos_t = cos(theta);
    
    for (int n=0; n<this.nodecount; n++) {
        float[] node = nodes[n];
        float x = node[0];
        float z = node[2];
        node[0] = x * cos_t - z * sin_t;
        node[2] = z * cos_t + x * sin_t;
    }
};
//
//// rotates about the object's X axis
void rotateX(float theta) {
    theta = radians(theta);
    float sin_t = sin(theta);
    float cos_t = cos(theta);
    
    for (int n=0; n<this.nodecount; n++) {
        float[] node = nodes[n];
        float y = node[1];
        float z = node[2];
        node[1] = y * cos_t - z * sin_t;
        node[2] = z * cos_t + y * sin_t;
    }
};
  
  void set_strokecolor(int theColor) {
    // take a color value, set the stroke color RGB-in-one and separate HSBa values.
    colorMode(RGB,255); 
    this.strokecolor = color(theColor);
    colorMode(HSB,1.0); // I'm saving these values in the range 0-1 because braindead Max Live plugin  
    this.strokeh = hue(theColor);
    this.strokes = saturation(theColor);
    this.strokeb = brightness(theColor);
    this.strokea = alpha(theColor);

  } // end of set_strokecolor
  
  void set_fillcolor(int theColor) {
    this.fillcolor = color(theColor);
   
   println("new color " + theColor + " is a bit " + hue(theColor) + " and " + saturation(theColor));
  //  this.fillh = hue(theColor);
 //   this.fills = saturation(theColor);
  //  this.fillb = brightness(theColor);
 //   colorMode(RGB,255);
    
  } // end of set_fillcolor
  
  void set_strokewidth(int theStroke) {
    this.strokew = theStroke;
  }
  
  void set_strokeh(float theValue) {
//  println("set_strokeh called with value " + theValue); 
    this.strokeh = theValue;
 //   println("H:" + this.strokeh + " S:" + this.strokes + " B:" + this.strokeb);
  //  colorMode(HSB, 1.0);
    this.set_strokecolor(color(theValue, this.strokes, this.strokeb, this.strokea)); 
  }
  
  void set_strokes(float theValue) {
  //println("set_strokes called"); 
    this.strokes = theValue;
  //  colorMode(HSB, 1.0);
    this.set_strokecolor(color(this.strokeh, theValue, this.strokeb, this.strokea)); 
  }
  
  void set_strokeb(float theValue) {
  //println("set_strokeb called"); 
    this.strokeb = theValue;
  //  colorMode(HSB, 1.0);
    this.set_strokecolor(color(this.strokeh, this.strokes, theValue, this.strokea)); 
  }
  
  void set_strokea(float theValue) {
  //println("set_strokea called"); 
   // this.strokea = theValue;
 //   colorMode(HSB, 1.0);
    this.set_strokecolor(color(this.strokeh, this.strokes, this.strokeb, theValue)); 
  }
  
  void set_scale(float theScale) { 
   // println("/object/scale/" + theScale + " received");
    this.scale = theScale;
  }

  void set_xrotation(int theXrot) { 
  //  println("/object/rx/" + theXrot + " received");
    this.prevrx = this.rx;
    this.rx = theXrot;
    int rxdelta = this.rx - this.prevrx;
    //println("rxdelta: " + rxdelta);
    this.rotateX(rxdelta);
  }

  void set_yrotation(int theYrot) { 
  //  println("/object/ry/" + theYrot + " received");
     this.prevry = this.ry;
    this.ry = theYrot;
    int rydelta = this.ry - this.prevry;
    //println("rxdelta: " + rxdelta);
    this.rotateY(rydelta);
   }

  void set_zrotation(int theZrot) { 
  //  println("/object/rz/" + theZrot + " received");
     this.prevrz = this.rz;
    this.rz = theZrot;
    int rzdelta = this.rz - this.prevrz;
    //println("rxdelta: " + rxdelta);
    this.rotateZ(rzdelta);
   }
   
   void set_trigger(int tid, int ival) {
     println("received trigger " + tid);
     switch(tid) {
       case 1:
         this.dx = 0;
         this.dy = 0;
         this.dz = 0;
         break;
       case 2:
         this.effect1val = 255;
         this.effect1timer = ival;
         break;
     }
   }

   void set_gpvalue(int vid, float vval) {
     println("received gpvalue " + vid);
     switch(vid) {
       case 1:
         this.dx = map(vval,0,1, -5 , 5);
         break;  
       case 2:
         this.dy = map(vval,0,1, -5 , 5);
         break;  
       case 3:
         this.dz = map(vval,0,1, -5 , 5);
         break;
       case 4:
         this.v4 = vval;
     }
     
    }

   void set_gpvalue1(float vval) {
     //println("received gpvalue " + vid);
     this.dx = map(vval,0,1, -5 , 5);
   }
   void set_gpvalue2(float vval) {
     //println("received gpvalue " + vid);
     this.dy = map(vval,0,1, -5 , 5);
   }
   void set_gpvalue3(float vval) {
     //println("received gpvalue " + vid);
     this.dz = map(vval,0,1, -5 , 5);
   }
   void set_gpvalue4(float vval) {
     //println("received gpvalue " + vid);
     this.v4 = map(vval,0,1, -5 , 5);
   }

     
   void showhide(int theValue) {
     println("flipping");
      if(theValue == 1) { 
        this.show = true;
      } else { 
        this.show = false;
      }
    }

    void set_shape(int theShapeId) {
     // set the requested id, within reason, then load it
 //     this.id = theShapeId % numobjfiles;
  //    load_obj(this.id);  
    } 
     
    void loadprev(int theValue) {
      if(this.id > 0) this.id--;
      load_obj(this.id);
    }
    void loadnext(int theValue) {
      if(this.id < this.numobjfiles) this.id++;
      load_obj(this.id);
    }

}
