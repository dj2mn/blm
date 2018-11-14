//this file contains code for the background layer

//  bg/color1/n = int color value
//  bg/h1/n  = colour 1 hue. if bg is showing img, this becomes a call to image.tint(), otherwise sets a fullscreen rect.fill()
//  bg/s1/n  = saturation 
//  bg/b1/n  = brightness
//  bg/mode/n = 0 = solid colour rect, 1 = gradient, 2 = tinted image
//  bg/color2/n
//  bg/h2/n
//  bg/s2/n
//  bg/b2/n
//  bg/dx/n = xoffset for image 
//  bg/dy/n = yoffset for image
//  bg/seq/n  = load image sequence number from data/img/n/
//  bg/img/n  = load image n from current sequence data/img/{seq}/n
//  bg/next/0  = load next image in sequence or loop to start
//  bg/prev/0  = load prev image in sequence (or loop to end?)
//  bg/z to trigger a zoom effect 

class KBackground {

    public int mode = 1, //                bg/mode/n  = 0 = solid colour rect, 1 = gradient, 2 = tinted image 
            dx = 0, // x/y offset for positioning image
            dy = 0,
            pdx = 0, // prev x/y values for tweening
            pdy = 0,
            speed = 20, // transition speed for crossfades, roughly eq to frames
            imgid = 0, //                   bg/img/n  = load image n from current sequence data/img/{seq}/n
            numimgs = 0, //number of image files in current img sequence directory
            seqid = 0,
            fadetime = 100,
            fadetimer = 0,
            zoomtime = 100,
            zoomtimer = 0,
            zoomdirection = 1;

    public float scale = 1,
            savedscale,
            r = 0, // image rotation
            dr = 0, // delta rotation
            color1h, // input OSC message bg/h/n    =  if bg is showing img, the hsb values becomes a call to image.tint(), otherwise sets a fullscreen rect.fill()
            color1s, //                   bg/s/n  
            color1b, //                   bg/b/n
            color1a,
            color2h,
            color2s,
            color2b,
            color2a;

    public color color1 = #000000,color2= #000000;

    public PImage bgImage, bgNextImage, bufferImage;

  //  PShape bGradient; // a shape to hold the background gradient so it doesn't have to be calculated every time
    
    ArrayList<String> seqnames = new ArrayList<String>(); // set to list of image sequence folders directory
    ArrayList bgImages = new ArrayList();
    PImage[] loadImages;
    PGraphics  bg; // A drawing buffer
    String[] loadFilenames;
    String[] loadSequencefoldernames;

    int seqnum, counter, fileCount;
    boolean flag_imgIsLoaded = false,
            flag_isZooming = false,
            flag_isCrossfading = false;

   


    // constructor
    KBackground() {

        // first to  get folder names from data/img/ directory
        // and put in seqname array for reference by this.seqid index

        // needs way more smarts.. filtering for image files only, graceful fail on file-not-found.. etc..

        loadImages = new PImage[1000];
        loadSequencefoldernames();
        loadFilenames();
        loadImages(0);
        //    fileCount = loadFilenames.length;

        // create a Graphics object to draw into 
        bg = createGraphics(width, height, P3D);
        bg.beginDraw();
        bg.noStroke();
        bg.fill(0);
        bg.rect(0,0,width,height);
        bg.endDraw();
    }


    void init() {      
      // scan image subdirectories and populate seqence and image name arrays with initial values
    }

    void reset() {
        this.r = 0;
        this.dr = 0;
        this.dx = 0;
        this.dy = 0;
        this.scale = 1;
    }

    void update() {

        bg.beginDraw();
        bg.noStroke();
        bg.fill(this.color1);
        bg.rect(0,0,width,height);
        bg.endDraw();

        this.r = (this.r + this.dr) % 360;

        if (flag_isCrossfading) {
            if (this.fadetimer > 0) {
                this.fadetimer--;
                //   println("fadetimer = " + fadetimer + " color1a = " + color1a);
                //  set_color1b(map(this.fadetimer,0,this.fadetime,0,1));
                //   println("color1b set to " + color1b);
            } else {
                flag_isCrossfading = false;
            }
        }

        if (flag_isZooming) {
            if (this.zoomtimer < this.zoomtime) {
                this.zoomtimer++;
                float zoomvalue;
                if (this.zoomdirection == -1) {
                    zoomvalue = map(this.zoomtimer, 0, this.zoomtime, this.savedscale, 5);
                } else {
                    zoomvalue = map(this.zoomtimer, 0, this.zoomtime, this.savedscale, 0.1);
                }
             //   println("zoomvalue: " + zoomvalue + " zoomtimer:" + zoomtimer);
                set_scale(zoomvalue);

            } else {
                zoomtimer = 0;
                flag_isZooming = false;
            }

        }
    }

    void startFade(int currimgid) {
//      println("starting fade from(?) currimgid " + currimgid);
        flag_isCrossfading = true;
        fadetimer = fadetime;
        this.bufferImage = loadImages[currimgid];
    }

    void start_zoom() {
        this.savedscale = this.scale;
        if (this.scale == 1) return;
        //println("zoooom!");
        flag_isZooming = true;
        if (this.scale > 1) {
            this.zoomdirection = 1;
        } else {
            this.zoomdirection = -1;
        }
    }


    void display() {
        switch (this.mode) {
            case 0:
            case 1: //<>//
                pushMatrix();
                image(bg,0,0);
                popMatrix();
                break;

            case 2:

                if (flag_imgIsLoaded == true) {

                    pushMatrix();
                    translate((width / 2) + this.dx, (height / 2) + this.dy);
                    rotate(radians(this.r));
                    translate(-this.bgImage.width / 2, -this.bgImage.height / 2);
                    imageMode(CENTER);
                    colorMode(RGB, 255); // just to make sure
                    tint(this.color1);
                   // println("(int)(this.bgImage.width * this.scale) = " + (int)(this.bgImage.width));// * this.scale));        

                    if (flag_isCrossfading) {
                        tint(this.color1, map(this.fadetimer, 0, this.fadetime, 0, 255)); //fading out image
                        image(this.bufferImage, width / 2, height / 2, (int) (this.bufferImage.width * this.scale), (int) (this.bufferImage.height * this.scale));
                        tint(this.color1, map(this.fadetimer, 0, this.fadetime, 255, 0));
                    }

                    image(this.bgImage, width / 2, height / 2, (int) (this.bgImage.width * this.scale), (int) (this.bgImage.height * this.scale));

                    popMatrix();
                }
                break;
        }
    }

    void set_seq(int theSeqId) {
        this.seqid = theSeqId;
        loadFilenames();
        loadImages(0);
       // println("seqid set to " + seqid);
    }

    void set_mode(int theMode) {
        this.mode = theMode;
         // println("mode changed to "+mode);
        //if ( mode == 2 ) this.color1 = color(255); // re/set for image tint
        // this.display();
    }

    // and now the method/handlers that are mapped to received messages in the osc file
    void set_color1(int theColor) {
        colorMode(RGB, 255);
        this.color1 = color(theColor);
        colorMode(HSB, 1.0); // I'm saving these values in the range 0-1 because braindead Max Live plugin
        this.color1h = hue(this.color1);
        this.color1s = saturation(this.color1);
        this.color1b = brightness(this.color1);
        this.color1a = alpha(this.color1);
    }

    void set_color2(int theColor) {
        colorMode(RGB, 255);
        this.color2 = color(theColor);
      //  println(this.color2);
        colorMode(HSB, 1.0); // I'm saving these values in the range 0-1 because braindead Max Live plugin
        this.color2h = hue(this.color2);
        this.color2s = saturation(this.color2);
        this.color2b = brightness(this.color2);
        this.color2a = alpha(this.color2);
    }


    void set_color1h(float theValue) {
        colorMode(HSB, 1.0);
        int newColor1 = color(theValue, this.color1s, this.color1b);
        this.set_color1(newColor1);
    }

    void set_color1s(float theValue) {
        //println("set_strokes called"); 
        colorMode(HSB, 1.0);
        int newColor1 = color(this.color1h, theValue, this.color1b, this.color1a);
        this.set_color1(newColor1);
    }

    void set_color1b(float theValue) {
        colorMode(HSB, 1.0);
        int newColor1 = color(this.color1h, this.color1s, theValue, this.color1a);
        this.set_color1(newColor1);
    }

    void set_color1a(float theValue) {
        colorMode(HSB, 1.0);
        int newColor1 = color(this.color1h, this.color1s, this.color1a, theValue);
        this.set_color1(newColor1);
    }

    void set_color2h(float theValue) {
        colorMode(HSB, 1.0);
        int newColor2 = color(theValue, this.color2s, this.color2b, this.color2a);
        this.set_color2(newColor2);
    }

    void set_color2s(float theValue) {
        //println("set_strokes called"); 
        colorMode(HSB, 1.0);
        int newColor2 = color(this.color2h, theValue, this.color2b, this.color2a);
        this.set_color2(newColor2);
    }

    void set_color2b(float theValue) {
        colorMode(HSB, 1.0);
        int newColor2 = color(this.color2h, this.color2s, theValue, this.color2a);
        this.set_color2(newColor2);
    }

    void set_color2a(float theValue) {
        colorMode(HSB, 1.0);
        int newColor2 = color(this.color2h, this.color2s, this.color2a, theValue);
        this.set_color2(newColor2);
    }



    // display next image in sequence or loop to start
    // method called when bg/next/0 received
    void bgimgnext(int theValue) {
//          println("received NEXT trigger " + theValue);
//            println("there are " + loadFilenames.length + " files to choose from");
        // if imgid = image_filename_array.size imgid = 0 else

        startFade(this.imgid);
        if (this.imgid < loadFilenames.length - 1) {
            this.imgid++;
//                 println("imgid++ now = " + imgid);
            this.bgImage = loadImages[this.imgid];
        } else { // we're at the end so loop back to beginning
            this.imgid = 0;
//                 println("imgid++ now = " + imgid);
            this.bgImage = loadImages[this.imgid];
        }
    }

    //  bg/prev/0  = display prev image in sequence (or loop to end?)
    void bgimgprev(int theValue) {
//            println("received PREV trigger " + theValue);
        startFade(this.imgid);

        if (this.imgid > 0) {
            this.imgid--;
//            println("imgid-- now = " + imgid);
            this.bgImage = loadImages[this.imgid];
        } else { // we're back at the start so loop t'end
            this.imgid = loadFilenames.length - 1;
//            println("imgid-- now = " + imgid);
            this.bgImage = loadImages[this.imgid];
        }
    }

    void set_rotate(int theValue) {
        this.r = theValue;
       // println("bg rotate = " + r);
    }

    void set_rotation(float theValue) {
        this.dr = map(theValue, 0, 1, 0, 10);
       // println("bg rotation = " + dr);
    }

    void set_scale(float theValue) {
        this.scale = theValue;
      //  println("bg scale = " + scale);
    }

    void set_fadetime(float theValue) {
        this.fadetime =int(map(theValue, 0, 1, 5, 1000));
//   println("fadetime set to "+fadetime); 
    }

    void set_zoomtime(float theValue) {
        this.zoomtime =int(map(theValue, 0, 1, 5, 1000));
     //   println("zoomtime set to " + zoomtime);
    }

    //this is named a bit wrong since we're setting
    //a delta offset value not the actual image coord
    void set_xpos(float theValue) {
        this.dx = (int) map(theValue, 0, 1, -width, width);
        //println("dx = " + this.dx);
    }

    void set_ypos(float theValue) {
        this.dy = (int) map(theValue, 0, 1, -height, height);
        //  println("dy = " + this.dy);
    }

    void set_bGradient() {
      //for (int i = 0; i <= displayHeight; i++) {
      //  float inter = map(i, 0, displayHeight, 0, 1);
      //  color c = lerpColor(this.color1, this.color2, inter);
      //  bg.setFill(this.color1);
      // }
    }
    
    void loadFilenames() {
     //   println("loadFilenames() called");
        java.io.File folder = new java.io.File(dataPath("img/" + loadSequencefoldernames[this.seqid]));
        java.io.FilenameFilter imgFilter = new java.io.FilenameFilter() {
            public boolean accept(File dir, String name) {
                return name.toLowerCase().endsWith(".jpg")
                        || name.toLowerCase().endsWith(".png");
            }
        };
        loadFilenames = folder.list(imgFilter);
        // and after all that we're still getting .DS_Store in the list somehow 
      //  println("loadFilenames.length = " + loadFilenames.length);
    }

    void loadSequencefoldernames() {
     //   println("loadSequencefoldernames() called");
        java.io.File folder = new java.io.File(dataPath("img/"));
        loadSequencefoldernames = folder.list();
        for (int i = 0; i < loadSequencefoldernames.length; i++) {
            println(i + ": " + loadSequencefoldernames[i]);
        }
    }

    void loadImages(int initialId) {
        for (int i = fileCount; i < loadFilenames.length; i++) { // only load new images
            // this needs some serious validations. eg it'll break when OSX puts a .DS_Store in the directory
            
            loadImages[i] = loadImage("img/" + loadSequencefoldernames[this.seqid] + "/" + loadFilenames[i]);
            
            if (loadImages[i].width < loadImages[i].height) {
                loadImages[i].resize(0, (int) (height * this.scale));
            } else {
                loadImages[i].resize((int) (width * this.scale), 0);
            }
        }
        // we've (re)loaded the array of images so a few things need to be reset
        this.imgid = initialId;
        this.bgImage = loadImages[this.imgid];
        this.bufferImage = bgImage;
        this.flag_imgIsLoaded = true;

    }
}