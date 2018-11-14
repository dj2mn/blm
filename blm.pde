// this file contains the main code to tie it all together.
//

import processing.core.*;
import oscP5.*;
import netP5.*;   
import java.io.File;
import java.util.*;

// some static globals
int _OSCPORT_ = 7001;


// the globals
KConfig k_config; 
OscP5 oscP5;

//instatiate the layer objects
KBackground k_bg;
KObject k_object;// = new KObject();
KPattern k_pattern;
KMask k_mask;
KText k_text;

PFont bGothic, bLCD;

void setup() {
  size(720,450,P3D);

//  fullScreen();
noCursor();
//  frameRate(12);
  k_config = new KConfig();
  k_bg = new KBackground();
  k_object = new KObject();
  k_object.scale = 1;
  // initialise our OSC system
  k_pattern = new KPattern();
  k_mask = new KMask();
  k_text = new KText();
  
  KOsc_init();
//  KMidi_init();
  
  k_bg.mode = 0;
  
  
  
}


void draw() {
 //do the stuff
background(0,64);
  // update background
  k_bg.update(); 
  // draw background
  k_bg.display();
 // println("bg mode = " + k_bg.mode );
 // update object

  k_object.update();
  // draw object if enabled
 
  if (k_object.show) k_object.display();

  // update pattern
  k_pattern.update();
  // draw pattern if enabled
  if (k_pattern.show) k_pattern.display();
  // update mask
//  k_text.update();
//  k_text.display();
  // draw mask
  k_mask.display();
  // save 
 // saveFrame("frames/####.tif");
}

//Description of parameters accepted and why.
//
// Global:
//  Not really global variables, just the scope under which
//  I've put the stuff to load and save states using JSON arrays
//  saved to data/conf/ with a simple numeric index.
// 
//  conf/save/n
//  conf/load/n
//
//Background:
//  The background layer is a solid rect by default 
//  but can also load and display static images
//  in which case HSB controls 'tint' 
//  version 2 should add ability to fade between images
//
//  bg/color/n = RGBa value setting base background colour 
//  bg/h/n  = if bg is showing img, this becomes a call to image.tint(), otherwise sets a fullscreen rect.fill()
//  bg/s/n  = HSBa controls accept float values range 0-1 from Ableton Live
//  bg/b/n  =
//  bg/a/n  = 
//  bg/mode/n = 0 = solid colour rect, 1 = gradient, 2 = tinted image
//  bg/color2/n
//  bg/h2/n
//  bg/s2/n
//  bg/b2/n
//  bg/dx/n = xoffset for image 
//  bg/dy/n = yoffset for image
//  bg/scale = scale factor for image
//  bg/r = rotation (degrees) for image
//  bg/seq/n  = load image sequence number from data/img/n/
//  bg/img/n  = load image n from current sequence data/img/{seq}/n
//  bg/next/0  = load next image in sequence or loop to start
//  bg/prev/0  = load prev image in sequence (or loop to end?)
//
//Object:
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
//  object/stroke/w/n  = stroke width
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
//  object/t/1/n   = general purpose trigger signal 1 // we can do something funkier with this later
//  object/t/2/n   = general purpose trigger signal 2 // like query the object for control inputs
//  object/t/3/n   = general purpose trigger signal 3 // but for now 4 trigger buttons and sliders
//  object/t/4/n   = general purpose trigger signal 4 // should be enough in the UI 
//  object/v/1/n   = general purpose value signal 1
//  object/v/2/n   = general purpose value signal 2
//  object/v/3/n   = general purpose value signal 3
//  object/v/4/n   = general purpose value signal 4
//
//Pattern:
//  The pattern layer will display various patterns
//
//  pattern/shape/n = index number for pattern selection. 0 is off.
//  pattern/scale/n
//  pattern/stroke/color/n
//  pattern/stroke/h/n     = 
//  pattern/stroke/s/n     =
//  pattern/stroke/b/n     =
//  pattern/stroke/a/n     =
//  pattern/stroke/color/n 
//  pattern/fill/h/n     =
//  pattern/fill/s/n     =
//  pattern/fill/b/n     =
//  pattern/fill/a/n     =
//  pattern/dx/n =
//  pattern/dy/n =
//  pattern/r/n   =
//  pattern/t/1/n   = general purpose trigger signal 1 // as above for the object triggers
//  pattern/t/2/n   = general purpose trigger signal 2
//  pattern/t/3/n   = general purpose trigger signal 3 
//  pattern/t/4/n   = general purpose trigger signal 4 
//  pattern/v/1/n   = general purpose value signal 1
//  pattern/v/2/n   = general purpose value signal 2
//  pattern/v/3/n   = general purpose value signal 3
//  pattern/v/4/n   = general purpose value signal 4
//
//
//Mask:
//  Mask/Overlay layer basically another static image layer
//  over the top but if you have png transparency in the image
//  you get like this gobo effect kind of thing. store masking images in data/mask/
//
//  mask/shape/n = index number for mask image selection. 0 is off.
//  mask/scale/n
//  mask/h/n   = 
//  mask/s/n   =
//  mask/b/n   =
//  mask/a/n     =
//  mask/dx/n =
//  mask/dy/n =
//  mask/r/n   =