//this file contains code to display various 2d patterns
//mostly stolen from p5art.tumblr.com

//  pattern/shape/n = index number for pattern selection. 0 is off.
//  pattern/scale/n
// pattern/stroke/w // stroke weight
// pattern/color1/n
//  pattern/color1/h/n     = 
//  pattern/color1/s/n     =
//  pattern/color1/b/n     =
//  pattern/color1/a/n     =
//  pattern/color2/n
//  pattern/color2/h/n     =
//  pattern/color2/s/n     =
//  pattern/color2/b/n     =
//  pattern/color2/a/n     =
//  pattern/dx/n =
//  pattern/dy/n =
//  pattern/r/n   =

class KPattern {

    int id = 1,
        strokew = 1;

    float color1h,
            color1s,
            color1b,
            color1a,
            color2h,
            color2s,
            color2b,
            color2a;

    int numpatterns = 6;
    float theta, speed = 100;
    float frames = 500,
            scale = 1;
    int t1 = 0,
            t2,
            t3,
            t4;
    float v1 = .4,
            v2 = 300,
            v3 = 5,
            v4;
    color color1 =
    #00FF00,color2= #008833;
    boolean show = false;

    KPattern() {
    }


    void update() {
    }

    void display() {
        switch (this.id) {
            case 1:
                pattern1();
                break;
            case 2:
                pattern2();
                break;
            case 3:
                pattern3();
                break;
            case 4:
                pattern4();
                break;
            case 5:
                pattern5();
                break;
            case 6:
                pattern6();
                break;
            case 7:
                pattern7();
                break;
        }
    }

    void set_shape(int theShapeId) {
      if (theShapeId == 4) {
        set_color2a(.5);
      }  
      
      if (theShapeId == 6) {
        this.v1 = 0;
        this.v2 = 0;
        this.v3 = 1;
        this.v4 = 1;
      }
      this.id = theShapeId;
        
        this.theta = 0;
    }

    void pattern1() {

        int num = (int) map(this.v1, 0, 1, 3, 20);
        pushMatrix();
        translate(width / 2, height / 2);
        for (int i = 0; i < num; i++) {
            pushMatrix();
            float offSet = TWO_PI / num * i;
            rotate(offSet);
            float sz = width * .15;
            float x = map(sin(theta), -1, 1, sz, width * .2);
            translate(x, 0);
            pushMatrix();
            rotate(theta);
            colorMode(HSB, 255);
            fill(map(i, 0, num, 0, 255), 255, 255, alpha(this.color1));
            strokeWeight(this.strokew);
            stroke(map(i, 0, num, 255, 0), 255, 255, alpha(this.color2));

            ellipse(0, 0, sz, sz * 2);
            //   rotateX(theta);
            //   translate(0,0,100);
            //   colorMode(HSB,255);
            //   fill(map(i, 0, num, 255,0),255,255,128);
            ellipse(0, 0, sz * .7, sz * 2 * .7);
            popMatrix();
            popMatrix();
        }
        popMatrix();
        theta += TWO_PI / map(this.speed,0,1,20,1000);
        // println(theta, this.speed);
    }

    void pattern2() {

        int num = (int) map(this.v1, 0, 1, 3, 40);
        //    fill(0,32);
        //    noStroke();
        // rect(0,0,width,height);
        for (int i = 0; i < num; i++) {
            pushMatrix();
            translate(width / 2, height / 2);
            float r = TWO_PI / num * i;
            rotate(r);
            float offSet = r * map(this.v3, 0, 1, 0, 5);
            float x = map(sin(theta + offSet), -1, 1, 3, width * .3);
            float min = 5;
            float max = 50;
            float sz = map(sin(theta + offSet), -1, 1, min, max);
            fill(this.color1);
            noStroke();
            ellipse(x, 0, sz, sz);
            noFill();
            strokeWeight(this.strokew);
            stroke(this.color2);
            float scal = map(sz, min, max, 5, .8);
            ellipse(x, 0, sz * scal, sz * scal);
            popMatrix();
        }
        theta += TWO_PI / map(this.speed,0,1,20,1000);
        // println(theta, this.speed);
    }

    void pattern3() {

        int num = (int) map(this.v1, 0, 1, 20, 500);
        for (int i = 0; i < num; i++) {
            float offSet = TWO_PI / num * i;
            pushMatrix();
            float x = width / 2 + map(sin(theta + offSet * 1), -1, 1, -(map(v2, 0, 1, 100, 8800)), map(v2, 0, 1, 100, 800));
            float y = height / 2;
            float d = map(sin(theta + offSet * 2), -1, 1, 200, 400);
            translate(x, y);
            float r = offSet;
            rotate(r);
            if (t1 == 1) {
                stroke(color2);
                strokeWeight(this.strokew);
                line(-d, 0, d, 0);
            }
            stroke(this.color1);
            strokeWeight(this.strokew);
            line(-d - 12, -2, d - 2, 2);
            popMatrix();
        }
        theta += TWO_PI / map(this.speed,0,1,20,1000);
        //println(theta, this.speed);
    }

    void pattern4() {
        int num = (int) map(this.v1, 0, 1, 20, 100);
        pushMatrix();
        translate(width / 2, height / 2);
        for (int i = 0; i < num; i++) {
            pushMatrix();
            float offSet = TWO_PI / num * i;
            rotate(offSet);
            float sz = map(sin(theta), -1, 1, width * .15, width * .2);
            float x = map(sin(theta), -1, 1, sz, width * .2);
            translate(x, 0);
            pushMatrix();
            rotate(theta);
            stroke(this.color1);
            if (false) { // (i%2==0) {
                ellipse(0, 0, sz, sz * 2);
                float px = cos(theta) * sz / 2;
                float py = sin(theta) * sz;
                float sz2 = 20;
                strokeWeight(this.strokew);
                ellipse(px, py, sz2, sz2);
                strokeWeight(this.strokew);
            } else {
                fill(this.color2);
                noStroke();
                ellipse(0, 0, sz * .7, sz * 2 * .7);
                float px = cos(theta + PI) * sz * .35;
                float py = sin(theta + PI) * sz * .7;
                float sz2 = 5;
                //fill(this.color1);
                ellipse(px, py, sz2, sz2);
                noFill();
            }
            popMatrix();
            popMatrix();
        }
        popMatrix();
        theta += TWO_PI / map(this.speed,0,1,20,1000);
        //println(theta, this.speed);
    }

    void pattern5() {
        noStroke();

        int num = (int) map(this.v1, 0, 1, 10, 30);
        int step = (int) map(this.v2, 0, 1, 50, 200);
        for (int y = 0; y <= height; y += step) {
            float j = 0;
            for (int x = 0; x <= width; x += step) {
                for (int i = num; i > 0; i--) {
                    float offSet = TWO_PI / num * i;
                    float sz = (map(this.v3, 0, 1, 2, 30) + i * 4) * map(sin(theta), -1, 1, .3, 1);
                    pushMatrix();
                    translate(x, y);
                    float r = map(sin(theta * 2 + offSet), -1, 1, -PI / 6, PI / 6);
                    rotate(r);
                    colorMode(HSB, 360, 100, 100);
                    fill(hue(color2), saturation(color2), 100 - i * 6, alpha(color2));
                    rect(5, 0, sz, sz);
                    popMatrix();
                }
                j++;
            }
        }

        theta += TWO_PI / map(this.speed,0,1,20,1000);
    }

//    void pattern699() { //saving for later
//        int num = (int) map(this.speed, 0, 1, 0.005, 0.03);
//        fill(this.color2); // (int)map(m_Fade.getValue(),0,1,128,1));
//        //    noStroke();
//        pushMatrix();
//        translate(width / 2, height / 2);
//        // rotateY(15);
//        //    rotateZ(r-360);
//        //    r = (r + map(this.v3, 0,1,-0.05,0.05) ) % 360;
//
//        float maxX = map(this.v1, 0, 1, 10, 20);
//
//        for (int i = 0; i < 360; i += map(this.v2, 0, 1, 4, 1)) {
//            float x = sin(radians(i));
//            float y = cos(radians(i));
//
//            float d = map(dist(x * maxX, y * maxX, x * (150 + sin(i + num) * 50), y * (150 + sin(i + num) * 50)), 0, 200, 1, 45);
//
//            stroke(this.color1); //, map(d,1,23,10,255));
//            strokeWeight(map(this.strokew, 0, 1, 1, 4));
//            fill(this.color2);//red,green,blue);//, 10+d);
//
//            ellipse(x * (150 + sin(i + num) * 50), y * (300 + sin(i + num) * 50), d, d);
//            ellipse(x * (100 + sin(i - num) * 50), y * (50 + sin(i - num) * 50), d, d);
//            ellipse(x * (300 + sin(i - num) * 50), y * (300 + sin(i - num) * 50), d, d);
//        }
//        num += map(this.speed, 0, 1, 0.005, 0.03);
//        popMatrix();
//    }

    void pattern6() {
      float cols = width / map(this.v1,0,1,10,80);
      float rows = height / map(this.v2,0,1,10,80);
      float lx = width/cols;
      float ly = height/rows;

       for (int i=0; i<cols; i++) {
    for (int j=0; j<rows; j++) {
      fill(color1);
      float x = (i+.5)*lx;
      float y = (j+.5)*ly;
      float distance = dist(x, y, width/this.v3, height/this.v4);
      //float distance = dist(x,y,width/2,height/2);
      float offSet = map(distance, 0, sqrt(sq(width/2)+sq(height/2)), 0, TWO_PI);
      float sz = map(sin(theta+offSet*5), -1, 1, 3, 14);
      ellipse(x, y, sz*this.scale, sz*this.scale);
    }
  } 
      
    theta -= TWO_PI / map(this.speed,0,1,10,300);  
 //   println("speed:"+speed+" theta:"+ theta + " v1:"+v1+" v2:"+v2+" v3:"+v3+" v4:"+v4);
      
    }
    
    
    
    void pattern7() { 
        int num = (int) map(this.v1, 0, 1, 5, 100);
        float unit = width / num;
        fill(this.color1);
        for (int y = 0; y <= num; y++) {
            for (int x = 0; x <= num; x++) {
                float distance = dist(width / 2, height / 2, x * unit, y * unit);
                float offSet = map(distance, 0, sqrt(sq(width / 2) + sq(height / 2)), 0, TWO_PI);
                float sz = map(sin(theta + offSet), -1, 1, unit * .2, unit * .1);
                float angle = atan2(y * unit - height / 2, x * unit - width / 2);
                sz = unit * map(this.scale, .5, 2, .2, 5);
                pushMatrix();
                translate(x * unit, y * unit);
                rotate(angle);
                float px = map(sin(theta + offSet), -1, 1, 0, 25);
                ellipse(px, 0, sz, sz);
                popMatrix();
            }
        }


        theta -= TWO_PI / map(this.speed,0,1,20,1000);
    }

    void set_strokew(int theStroke) {
        //println("receieved a message, set strokew to " + this.strokew);
        this.strokew = theStroke;
    }

    void set_gpvalue(int vid, float vval) {
        //  println("received gpvalue " + vid);
        switch (vid) {
            case 1:
                this.v1 = vval;
                break;
            case 2:
                this.v2 = vval;
                break;
            case 3:
                this.v3 = vval;
                break;
            case 4:
                this.v4 = vval;
                break;
        }
    }

    void set_gpvalue1(float vval) {
        //println("received gpvalue " + vid);
        this.v1 = vval;
    }

    void set_gpvalue2(float vval) {
        //println("received gpvalue " + vid);
        this.v2 = vval;
    }

    void set_gpvalue3(float vval) {
        //println("received gpvalue " + vid);
        this.v3 = vval;
    }

    void set_gpvalue4(float vval) {
        //println("received gpvalue " + vid);
        this.v4 = vval;
    }


    void loadprev(int theValue) {
        if (this.id > 1) {
            reset_inputs();
            set_shape(this.id-1);
        }
    }

    void loadnext(int theValue) {
        if (this.id < this.numpatterns) {
            reset_inputs();
            set_shape(this.id+1);
        }
    }

    void showhide(int theValue) {
        if (theValue == 1) {
            this.show = true;
        } else {
            this.show = false;
        }
    }

    void showhide(Boolean theValue) {
        if (theValue) {
            this.show = true;
        } else {
            this.show = false;
        }
    }


    void reset_inputs() {
        this.v1 = this.v2 = this.v3 = this.v4 = this.theta = 0;
        this.t1 = this.t2 = this.t3 = this.t4 = 0;
    }

    void set_speed(float theSpeed) {
        this.speed = theSpeed; // map(theSpeed, 0, 1, 100, 1000);
//println("set speed to " + this.speed);
    }

    void set_scale(float theScale) {
// println("/ptn/scale/" + theScale + " received");
        this.scale = theScale;
    }

    void set_color1(int theColor) {
        colorMode(RGB, 255);
        this.color1 = color(theColor);
        colorMode(HSB, 1.0); // I'm saving these values in the range 0-1 because braindead Max Live plugin
        this.color1h = hue(theColor);
        this.color1s = saturation(theColor);
        this.color1b = brightness(theColor);
        this.color1a = alpha(theColor);
     //   println("set_color1 made H:" + this.color1h + " S:" + this.color1s + " B:" + this.color1b);
    } // end of set_color1

    void set_color2(int theColor) {
        colorMode(RGB, 255);
        this.color2 = color(theColor);
        colorMode(HSB, 1.0); // I'm saving these values in the range 0-1 because braindead Max Live plugin
        this.color2h = hue(theColor);
        this.color2s = saturation(theColor);
        this.color2b = brightness(theColor);
        this.color2a = alpha(theColor);
    } // end of set_color2

    void set_color1h(float theValue) {
        colorMode(HSB, 1.0);
        int newColor1 = color(theValue, this.color1s, this.color1b, this.color1a);
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
        int newColor1 = color(this.color1h, this.color1s, this.color1b, theValue);
        this.set_color1(newColor1);
    }

    void set_color2h(float theValue) {
        colorMode(HSB, 1.0);
        int newColor2 = color(theValue, this.color2s, this.color2b, this.color2a);
        this.set_color1(newColor2);
    }

    void set_color2s(float theValue) {
        //println("set_strokes called"); 
        colorMode(HSB, 1.0);
        int newColor2 = color(this.color2h, theValue, this.color2b, this.color2a);
        this.set_color1(newColor2);
    }

    void set_color2b(float theValue) {
        colorMode(HSB, 1.0);
        int newColor2 = color(this.color2h, this.color2s, theValue, this.color2a);
        this.set_color2(newColor2);
    }

    void set_color2a(float theValue) {
        colorMode(HSB, 1.0);
        int newColor2 = color(this.color2h, this.color2s, this.color2b, theValue);
        this.set_color2(newColor2);
    }

}