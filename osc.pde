//// this file contains code to handle OSC messages
////

// initialise our OSC commands 
public void KOsc_init() {

    oscP5 = new OscP5(this,_OSCPORT_);

//Accepted OSC messages:
//

//Global:
  oscP5.plug(k_config,"ksave","/conf/save");
  oscP5.plug(k_config,"kload","/conf/load");   

//Background:
  oscP5.plug(k_bg,"set_color1","/bg/color");
  oscP5.plug(k_bg,"set_color1h","/bg/color1/h");
  oscP5.plug(k_bg,"set_color1s","/bg/color1/s");
  oscP5.plug(k_bg,"set_color1b","/bg/color1/b");
  oscP5.plug(k_bg,"set_color1a","/bg/color1/a");
  oscP5.plug(k_bg,"set_mode","/bg/mode");
  oscP5.plug(k_bg,"set_color2","/bg/color2");
  oscP5.plug(k_bg,"set_color2h","/bg/color2/h");
  oscP5.plug(k_bg,"set_color2s","/bg/color2/s");
  oscP5.plug(k_bg,"set_color2b","/bg/color2/b");
  oscP5.plug(k_bg,"set_color2a","/bg/color2/a");
  oscP5.plug(k_bg,"bgimgnext","/bg/next");
  oscP5.plug(k_bg,"bgimgprev","/bg/prev");
  oscP5.plug(k_bg,"set_seq","/bg/seq");
  oscP5.plug(k_bg,"set_rotate","/bg/r");
  oscP5.plug(k_bg,"set_rotation","/bg/rx");
  oscP5.plug(k_bg,"set_scale","/bg/scale");
  oscP5.plug(k_bg,"set_xpos","/bg/x");
  oscP5.plug(k_bg,"set_ypos","/bg/y");
  oscP5.plug(k_bg,"set_fadetime","/bg/fadetime");
  oscP5.plug(k_bg,"set_zoomtime","/bg/zoom");
  oscP5.plug(k_bg,"start_zoom","/bg/z");
  oscP5.plug(k_bg,"reset","/bg/reset");



//Object:
//  object/show/n
oscP5.plug(k_object,"showhide","/object/show");


//  object/shape/n
  oscP5.plug(k_object,"set_shape","/object/shape");
//  object/next/n
  oscP5.plug(k_object,"loadnext","/object/next");
//  object/prev/n
  oscP5.plug(k_object,"loadprev","/object/prev");

//  object/scale/n
  oscP5.plug(k_object,"set_scale","/object/scale");

//  object/stroke/h/n 
  oscP5.plug(k_object,"set_strokeh","/object/stroke/h");
//  object/stroke/s/n
  oscP5.plug(k_object,"set_strokes","/object/stroke/s");
//  object/stroke/b/n
  oscP5.plug(k_object,"set_strokeb","/object/stroke/b");
//  object/stroke/a/n
  oscP5.plug(k_object,"set_strokea","/object/stroke/a");
  
//  object/stroke/color/n
oscP5.plug(k_object,"set_strokecolor","/object/stroke/color");

//  object/stroke/w/n
oscP5.plug(k_object,"set_strokew","/object/stroke/w");

//  object/fill/h/n
//  object/fill/s/n
//  object/fill/b/n
//  object/fill/a/n
//  object/fill/color/n
oscP5.plug(k_object,"set_fillcolor","/object/fill/color");

//  object/dx/n
//  object/dy/n

//  could change this to object/r/[x|y|z] and make a single rotation handler
//  object/dx/n
oscP5.plug(k_object,"set_xrotate","/object/rx"); // fixed object rotation amount, in degrees.

//  object/rx/n
oscP5.plug(k_object,"set_xrotation","/object/dx"); // rotation is a (float)delta value to add to rx each iteration

//  object/ry/n
oscP5.plug(k_object,"set_yrotation","/object/dy");

//  object/rz/n
oscP5.plug(k_object,"set_zrotation","/object/dz");

//  object/t 1 1
//  object/t 2 1
//  object/t 3 1
//  object/t 4 1 
oscP5.plug(k_object,"set_trigger","/object/t");


//  object/v/1/n
//  object/v/2/n
//  object/v/3/n
//  object/v/4/n
oscP5.plug(k_object,"set_gpvalue","/object/v");

//alternatives for brain-dead Live plugin
oscP5.plug(k_object,"set_gpvalue1","/object/v/1");
oscP5.plug(k_object,"set_gpvalue2","/object/v/2");
oscP5.plug(k_object,"set_gpvalue3","/object/v/3");
oscP5.plug(k_object,"set_gpvalue4","/object/v/4");

oscP5.plug(k_object,"set_tilex","/object/tilex");
oscP5.plug(k_object,"set_tiley","/object/tiley");

//
//Pattern:
//  pattern/show/n
oscP5.plug(k_pattern,"showhide","/ptn/show");
//  pattern/shape/n
oscP5.plug(k_pattern,"set_shape","/ptn");
  //  object/next/n
  oscP5.plug(k_pattern,"loadnext","/ptn/next");
  //  object/prev/n
  oscP5.plug(k_pattern,"loadprev","/ptn/prev");


//  pattern/scale/n
  oscP5.plug(k_pattern,"set_scale","/ptn/scale");
//  pattern/stroke/w
  oscP5.plug(k_pattern,"set_strokewidth","/ptn/stroke/w");
//  pattern/speed/n
  oscP5.plug(k_pattern,"set_speed","/ptn/speed");

//  pattern/color1/h/n 
  oscP5.plug(k_pattern,"set_color1h","/ptn/color1/h");
//  pattern/color1/s/n
  oscP5.plug(k_pattern,"set_color1s","/ptn/color1/s");
//  pattern/color1/b/n
  oscP5.plug(k_pattern,"set_color1b","/ptn/color1/b");
//  pattern/color1/a/n
  oscP5.plug(k_pattern,"set_color1a","/ptn/color1/a");

//  pattern/color2/h/n 
  oscP5.plug(k_pattern,"set_color2h","/ptn/color2/h");
//  pattern/color2/s/n
  oscP5.plug(k_pattern,"set_color2s","/ptn/color2/s");
//  pattern/color2/b/n
  oscP5.plug(k_pattern,"set_color2b","/ptn/color2/b");
//  pattern/color2/a/n
  oscP5.plug(k_pattern,"set_color2a","/ptn/color2/a");


//  pattern/color1/n
  oscP5.plug(k_pattern,"set_color1","/ptn/color1");
//  pattern/color2/n
  oscP5.plug(k_pattern,"set_color2","/ptn/color2");


//  pattern/dx/n
//  pattern/dy/n
//  pattern/r/n
//  pattern/t/1/n
//  pattern/t/2/n
//  pattern/t/3/n
//  pattern/t/4/n 
//  pattern/v/1/n
//  pattern/v/2/n
//  pattern/v/3/n
//  pattern/v/4/n
oscP5.plug(k_pattern,"set_gpvalue","/ptn/v");
//alternatives for brain-dead Live plugin
oscP5.plug(k_pattern,"set_gpvalue1","/ptn/v/1");
oscP5.plug(k_pattern,"set_gpvalue2","/ptn/v/2");
oscP5.plug(k_pattern,"set_gpvalue3","/ptn/v/3");
oscP5.plug(k_pattern,"set_gpvalue4","/ptn/v/4");


//Text:
// text/show
oscP5.plug(k_text,"showhide", "/text/show");
//text/next/n
oscP5.plug(k_text,"loadnext","/text/next");
//text/prev/n
oscP5.plug(k_text,"loadprev","/text/prev");

// text/color
oscP5.plug(k_text,"set_color", "/text/color");
// text/size
oscP5.plug(k_text,"set_size", "/text/size");
// text/font
oscP5.plug(k_text,"set_font", "/text/font");
// text/x
oscP5.plug(k_text,"set_xpos", "/text/x");
// text/y
oscP5.plug(k_text,"set_ypos", "/text/y");
// text/r
oscP5.plug(k_text,"set_rotation", "/text/r");


//Mask:
//  mask/show
oscP5.plug(k_mask,"showhide","/mask/show");
//  mask/next/n
oscP5.plug(k_mask,"loadnext","/mask/next");
//  mask/prev/n
oscP5.plug(k_mask,"loadprev","/mask/prev");
//  mask/shape/n
//  mask/scale/n
oscP5.plug(k_mask,"set_scale","/mask/scale");
//  mask/r/n
oscP5.plug(k_mask,"set_rotation","/mask/r");
//  mask/x
oscP5.plug(k_mask,"set_xpos","/mask/x");
//  mask/y
oscP5.plug(k_mask,"set_ypos","/mask/y");
//  mask/h/n 
//  mask/s/n
//  mask/b/n
//  mask/a/n
//  mask/x/n
//  mask/y/n
//  mask/r/n

}