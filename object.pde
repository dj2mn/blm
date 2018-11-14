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
int _GLOBALSCALE_=180;

class KObject {


  // variables for OSC input
  int id = 0, 
  fileindex = 0, 
  strokecolor= #00FF00, 
  strokew=1, 
  fillcolor, 
  fillh, 
  fills, 
  fillb, 
  filla, 
  t1, 
  t2, 
  t3, 
  t4, 
  tilex = 1, //tessalation counters vert & horiz
  tiley = 1;
  float scale = 1, 
  strokeh, 
  strokes, 
  strokeb, 
  strokea, 
  dx = 0, 
  dy = 0, 
  dz = 0, 
  rx = 0, //
  prevrx, 
  ry = 0, 
  prevry, 
  rz = 0, 
  prevrz, 
  v1, 
  v2, 
  v3, 
  v4;


  ArrayList<String> objfilenames = new ArrayList<String>(); // set to list of .obj filenames in data/obj directory
  int numobjfiles; // set to number of .obj files in data/obj directory 
  PShape objectdata; // .obj data is loaded into this array
  PGraphics objectcanvas; 

  boolean show = false, 
  showCoords = false, 
  showVerts = false, 
  showEdges = true, 
  flicker = false,
  rotateMode = true, 
  dataisloaded = false;


  KObject() {
    objectcanvas = createGraphics(width,height,P3D);
    // get filenames from data/obj/ directory
    // needs way more smarts.. filtering for .obj files only, graceful fail on file-not-found.. etc..
    File dir = new File(dataPath("obj/"));
    String[] filenames = dir.list();
    // int numfiles = filenames.length;
    numobjfiles = 0;

    //println(filenames.length + " files found in obj/ :");
    for (int i = 0; i < filenames.length; i++) {
      //println(i + ":" + filenames[i]);
      if (filenames[i].endsWith(".obj")) {
        numobjfiles++;
        println(filenames[i] + " is an .obj file");
        objfilenames.add(filenames[i]);
      }

    }
    println(filenames.length + " files, " + numobjfiles + " of which are .obj files");
    load_obj(this.id);
  }


  void reset() {

    this.dx = 0;
    this.dy = 0;
    this.dz = 0;
    this.rx = 0;
    this.ry = 0;
    this.rz = 0;
    this.v1 = 0;
    this.v2 = 0;
    this.v3 = 0;
    this.v4 = 0;
    this.rotateMode = true;
  }

  void update() {
    this.rx = (this.rx + this.dx) % 360;
  //  println("this.rx = "+this.rx);
    this.ry = (this.ry + this.dy) % 360;
    this.rz = (this.rz + this.dz) % 360;
  }


  //
  // method to load object data from a file
  // 
  void load_obj(int theIndex) {
    this.id = theIndex;
// println("this.id = " + this.id + " : loading " + objfilenames.get(this.id));
    File f = new File(dataPath("obj") + "/" + objfilenames.get(this.id));
    if (f.exists()) {
      // this needs some sort of try/catch around it ay.

        objectdata = loadShape("obj/" + objfilenames.get(this.id));
        
         println("objectdata file " + objfilenames.get(this.id) + " loaded " + objectdata.getChildCount());
  
         this.dataisloaded = true;
        
      } else {
        this.dataisloaded = false;
      }
    
//    println("object data loaded successfully, it's got " + objectdata.getChildCount() + " children and " + objectdata.getVertexCount() + " vertexes");
    
    
  } // end of load_obj method

  void display() {
    if (!this.show || !this.dataisloaded) return;

      for (int tx = 1; tx <= this.tilex; tx++ ) {
        for (int ty = 1; ty <= this.tiley; ty++ ) {
          int tx_offset = (width / (tilex+1)) * tx;
          int ty_offset = (height / (tiley+1)) * ty;
          pushMatrix();
          objectcanvas.beginDraw();
          objectcanvas.translate(tx_offset, ty_offset);
          objectcanvas.rotateX(radians(this.rx));
          objectcanvas.rotateY(radians(this.ry));
          objectcanvas.rotateZ(radians(this.rz));
          objectcanvas.scale(this.scale);
          objectcanvas.clear();
          objectdata.disableStyle();
          objectdata.setStroke(this.strokecolor);
          objectdata.setStrokeWeight(this.strokew);
          objectdata.setFill(this.fillcolor);
          objectcanvas.shape(objectdata);
          objectcanvas.endDraw();

          image(objectcanvas,0,0);
          popMatrix();
        }
      }
}

  void olddisplay() {
    if (!this.show || !this.dataisloaded) return; // no point running if we're not supposed to be showing

    //println("object.display called");
      for (int tx = 1; tx <= this.tilex; tx++ ) {
        for (int ty = 1; ty <= this.tiley; ty++ ) {
          int tx_offset = (width / (tilex+1)) * tx;
          int ty_offset = (height / (tiley+1)) * ty;
          pushMatrix();
          //draw the edge
          //if (this.showEdges) {
          //}
          //if (this.showVerts) {
          //}
          //if (this.showCoords) {
          //}

          translate(tx_offset, ty_offset);
          rotateX(radians(this.rx));
          rotateY(radians(this.ry));
          rotateZ(radians(this.rz));
          scale(this.scale);
         // objectdata.setStroke(this.strokecolor);
         // objectdata.setFill(this.fillcolor);
         // shape(objectdata);
         for (int c = 0; c < objectdata.getChildCount(); c++ ) {
           PShape face = objectdata.getChild(c); 
           // println("child " + c + " has " + face.getVertexCount() + " vertexes");

           // this appears to be a bug because it doesn't work
           //face.disableStyle();
           //face.setStroke(this.strokecolor);
           //face.setFill(this.fillcolor);
           //shape(face);

           // so instead walk the vertexes and draw it out manually
           for (int w = 0; w < face.getVertexCount(); w++ ) {
             PVector v1 = face.getVertex(w);
             PVector v2 = face.getVertex((w+1)%face.getVertexCount());
             stroke(this.strokecolor);
             fill(this.fillcolor);
             strokeWeight(this.strokew);
             line(v1.x,v1.y,v2.x,v2.y);
           }
 
       }

          popMatrix();
        } //end of for ty loop
      } // end of for tx loop
    
  }


  void set_strokecolor(int theColor) {
    // take a color value, set the stroke color RGB-in-one and separate HSBa values.
    colorMode(RGB, 255);
    this.strokecolor = color(theColor);
    colorMode(HSB, 1.0); // I'm saving these values in the range 0-1 because braindead Max Live plugin  
    this.strokeh = hue(theColor);
    this.strokes = saturation(theColor);
    this.strokeb = brightness(theColor);
    this.strokea = alpha(theColor);
  } // end of set_strokecolor

    void set_fillcolor(int theColor) {
    this.fillcolor = color(theColor);

    //println("new color " + theColor + " is a bit " + hue(theColor) + " and " + saturation(theColor));
    //  this.fillh = hue(theColor);
    //   this.fills = saturation(theColor);
    //  this.fillb = brightness(theColor);
    //   colorMode(RGB,255);
  } // end of set_fillcolor

    void set_strokew(int theStroke) {
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

  void set_tilex(int theValue) {
    // println("/object/scale/" + theScale + " received");
    this.tilex = theValue;
  }

  void set_tiley(int theValue) {
    // println("/object/scale/" + theScale + " received");
    this.tiley = theValue;
  }

  void set_xrotation(int theXrotdelta) {
    //println("/object/rx/" + theXrot + " received");
    this.prevrx = this.rx;
    this.rx = theXrotdelta;
    // float rxdelta = this.rx - this.prevrx;
 //   println("set_xrotation prevrx="+this.prevrx+" rx="+this.rx);
  }

  void set_xrotate(int theXrot) {
    //println("/object/rx/" + theXrot + " received");
    this.prevrx = this.rx;
    this.rx = theXrot;
    float rxdelta = this.rx - this.prevrx;
  //  println("set_xrotate prevrx="+this.prevrx+" rx="+this.rx);
  }

  void set_yrotation(int theYrot) {
    //println("/object/ry/" + theYrot + " received");
    this.prevry = this.ry;
    this.ry = theYrot;
    float rydelta = this.ry - this.prevry;
    //println("rydelta: " + rydelta + " ry:" + ry);
    // this.rotateY(rydelta);
  }

  void set_zrotation(int theZrot) {
    //println("/object/rz/" + theZrot + " received");
    this.prevrz = this.rz;
    this.rz = theZrot;
    float rzdelta = this.rz - this.prevrz;
    //println("rzdelta: " + rzdelta + " rz:" + rz);
    // this.rotateZ(rzdelta);
  }

  void set_trigger(int tid, int ival) {
   // println("received trigger " + tid);
    switch (tid) {
    case 1:
      load_obj(this.id);
      reset();
      break;
    case 2:
      this.showVerts = !this.showVerts;
      break;
    case 3:
      this.showCoords = !this.showCoords;
      break;
    case 4:
      this.rotateMode = !this.rotateMode;
      println("rotateMode:" + rotateMode);
      break;
    }
  }

  void set_gpvalue(int vid, float vval) {
    //   println("received gpvalue " + vid);
    switch (vid) {
    case 1:
      this.dx = map(vval, 0, 1, 0, 5);
     // println("set_gpvalue dx="+this.dx);
      break;
    case 2:
      this.dy = map(vval, 0, 1, 0, 5);
      break;
    case 3:
      this.dz = map(vval, 0, 1, 0, 5);
      break;
    case 4:
      this.v4 = vval;
    }
  }

  void set_gpvalue1(float vval) {
    //println("received gpvalue " + vid);
    this.dx = map(vval, 0, 1, -5, 5);
  }

  void set_gpvalue2(float vval) {
    //println("received gpvalue " + vid);
    this.dy = map(vval, 0, 1, -5, 5);
  }

  void set_gpvalue3(float vval) {
    //println("received gpvalue " + vid);
    this.dz = map(vval, 0, 1, -5, 5);
  }

  void set_gpvalue4(float vval) {
    //println("received gpvalue " + vid);
    this.v4 = map(vval, 0, 1, -5, 5);
  }


  void showhide(int theValue) {
 //   println("flipping");
    if (theValue == 1) {
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
    if (this.id > 0) this.id--;
    load_obj(this.id);
  }

  void loadnext(int theValue) {
    if (this.id < this.numobjfiles) this.id++;
    load_obj(this.id);
  }
}