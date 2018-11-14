//this file contains code to display a mask/overlay

//  mask/shape/n = index number for mask image selection. 0 is off.
//  mask/scale/n
//  mask/h/n   = 
//  mask/s/n   =
//  mask/b/n   =
//  mask/a/n     =
//  mask/dx/n =
//  mask/dy/n =
//  mask/r/n   =

class KMask {
  
  PImage imgMask, imgBuffer, imgTemp;
  int id = 0,
      r = 0,
      dx = 0,
      dy = 0,
      color1 = #FFFFFF;
      
  boolean flag_imgIsLoaded = false,
          show = false;
  
  float scale = 1;
  
  KMask() {
    loadImg();
  }
  
  
  void loadImg() {
      this.flag_imgIsLoaded = false;
      // need smarts here to check for existence of file etc
      this.imgTemp = loadImage("data/mask/" + this.id + ".png");
      
      if (this.imgTemp == null) { 
      println("didn't load image!");
      flag_imgIsLoaded = false; 
      }
      else  {
//println("loading mask/"  + this.id + ".png");
        if (imgTemp.width < imgTemp.height ) {
          this.imgTemp.resize(0,(int)(height * this.scale));
        } else {
          this.imgTemp.resize((int)(width * this.scale),0); 
        }
        this.imgMask = this.imgTemp;
        flag_imgIsLoaded = true;
        

      }
  } // end loadImg()
 
   void update() {
     
     
   }
   
   
  void display() {
    if(this.show) {
      pushMatrix();
      translate((width / 2)+this.dx, (height / 2)+this.dy);
      rotate(radians(this.r));
      translate(-imgMask.width/2, -imgMask.height/2);
      imageMode(CENTER);
      tint(this.color1);
      image(this.imgMask, width / 2, height / 2, (int)(this.imgMask.width * this.scale), (int)(this.imgMask.height * this.scale));
     
      popMatrix(); 
    } 

  }
  
  // first version of showhide receives type int from OSC
  void showhide(int theValue) {
// println("flipping mask");
    if(theValue == 1) { 
      this.show = true;
    } else { 
      this.show = false;
    }
  }
  
  // second version of showhide receives type Boolean from config load
  void showhide(Boolean theValue) {
    if (theValue) {
        this.show = true;
    } else {
        this.show = false;
    }
}


  // display next image in sequence or loop to start
// method called when bg/next/0 received
void loadnext() {
//println("received NEXT trigger" + theValue);
  // if imgid = image_filename_array.size imgid = 0 else
  if (true) {
    this.id++;
    this.loadImg();
   // this.display();
  }
}

//  bg/prev/0  = display prev image in sequence (or loop to end?)
void loadprev(int theValue) {
//println("received PREV trigger " + theValue);
  //if imgid = 0 exit else
  //if imgid = 0 imgid = size of array of image filenames else
  if (theValue == 1) {
    if (this.id > 0 ) { 
      this.id--; 
      this.loadImg();
          
    }
   }
}

void set_rotation(float theValue) {
  this.r = (int)map(theValue,0,1,0,360);
  //println("bg rotation = " + r);
}

void set_scale(float theValue) {
  this.scale = theValue;
 // println("mask scale = " + scale);
}

void set_xpos(float theValue) {
  //because we put 0,0,at center screen, mapping this way allows
  //for positioning the image just off screen.
  this.dx = (int)map(theValue,0,1,-width,width);
//println("dx = " + this.dx);
}

void set_ypos(float theValue) {
  this.dy = (int)map(theValue,0,1,-height,height);
//println("dy = " + this.dy);
}



}