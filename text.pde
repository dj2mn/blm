// this file contains code to display text
// loaded from local file system or remote URL
// HUD mode displays cpu load, IP address, screen dimensions etc

class KText {

  int id, // we will load a text file and use this to index it line by line
  size = 64, // used in the call to display text, this probably shouldn't be > displayHeight
  numlines, // number of lines in currently loaded text file
  x = width / 2,
  y = height / 2,
  t1, 
  t2, 
  t3, 
  t4;

  String[] theText, loadFontnames;
  String theLine = "a test line"; // theText holds the text file, theLine holds the line we're currently displaying
  PFont[] myFonts;
  float v1, 
  v2, 
  v3, 
  v4;

  color color1 = #ffffff;
  boolean show = true;

  KText() {
    // load fonts from font directory
    load_fonts();
  }

  void load_fonts() {
   // println("load_fonts() called");
    java.io.File folder = new java.io.File(dataPath("font/"));
    java.io.FilenameFilter fontFilter = new java.io.FilenameFilter() {
      public boolean accept(File dir, String name) {
        return name.toLowerCase().endsWith(".vlw");
      }
    };
    loadFontnames = folder.list(fontFilter);
    myFonts = new PFont[loadFontnames.length];
    for (int i = 0; i < loadFontnames.length; i++) {
      myFonts[i] = loadFont("font/" + loadFontnames[i]);
    //  println("loaded " + loadFontnames[i]);
      
    }
  }



void update() {
}

void display() {
  if (this.show) {
    fill(this.color1);
   textFont(myFonts[2], this.size);
   textAlign(CENTER);
text(theLine, this.x, this.y); 
  }
}

void set_size() {
}

void set_font(int theSelection) {
}

void set_xpos(float theValue) {
  this.x = (int)map(theValue, 0, 1, -width, width);
}

void set_ypos(float theValue) {
  this.y = (int)map(theValue, 0, 1, -height, height);
}

void set_rotation() {
}

void set_gpvalue1(float vval) {
  //println("text layer received gpvalue " + vval);
  this.v1 = vval;
}
void set_gpvalue2(float vval) {
  //println("text layer received gpvalue " + vval);
  this.v2 = vval;
}
void set_gpvalue3(float vval) {
  //println("text layer received gpvalue " + vval);
  this.v3 = vval;
}
void set_gpvalue4(float vval) {
  //println("text layer received gpvalue " + vval);
  this.v4 = vval;
}


void showhide(int theValue) {
  //println("text layer flipping");
  if (theValue == 1) { 
    this.show = true;
  } else { 
    this.show = false;
  }
}

void loadprev(int theValue) {
  if (this.id > 0) this.id--;
}
void loadnext(int theValue) {
  if (this.id < this.numlines) this.id++;
}
}