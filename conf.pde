// this file contains the code to load & save the values of all OSC paramaters
// in a snapshot to .json file in data/conf/

class KConfig {
    public int id;

    // so basicallly put all the object variables in a json array and save it.
    // i'm sure there's a better way here but this'll do to start

    public JSONObject values = new JSONObject();


    // constructor, um
    KConfig() {
      //  println("nothing to construct?");
    }


    void ksave(int theID) {
        println("saving bg things");
//the background parameters
        values.setInt("k_bg.mode", k_bg.mode);
        values.setInt("k_bg.color1", k_bg.color1);
        values.setInt("k_bg.color2", k_bg.color2);
        values.setInt("k_bg.imgid", k_bg.imgid);
        values.setInt("k_bg.seqid", k_bg.seqid);
        values.setInt("k_bg.fadetime", k_bg.fadetime);
        values.setInt("k_bg.zoomtime", k_bg.zoomtime);
        values.setFloat("k_bg.scale", k_bg.scale);
        values.setFloat("k_bg.r", k_bg.r);
        values.setFloat("k_bg.dr", k_bg.dr);
        
        
//        println("saving obj things");
//the object parameters
        values.setInt("k_object.id", k_object.id);
        values.setBoolean("k_object.show", k_object.show);
        values.setInt("k_object.strokecolor", k_object.strokecolor);
        values.setInt("k_object.strokew", k_object.strokew);
        values.setInt("k_object.fillcolor", k_object.fillcolor);
        values.setInt("k_object.tilex", k_object.tilex);
        values.setInt("k_object.tiley", k_object.tiley);
        values.setFloat("k_object.dx", k_object.dx);
        values.setFloat("k_object.dy", k_object.dy);
        values.setFloat("k_object.dz", k_object.dz);
        values.setFloat("k_object.rx", k_object.rx);
        values.setFloat("k_object.ry", k_object.ry);
        values.setFloat("k_object.rz", k_object.rz);
        values.setInt("k_object.t1", k_object.t1);
        values.setInt("k_object.t2", k_object.t2);
        values.setInt("k_object.t3", k_object.t3);
        values.setInt("k_object.t4", k_object.t4);
        values.setFloat("k_object.v1", k_object.v1); 
        values.setFloat("k_object.v2", k_object.v2);
        values.setFloat("k_object.v3", k_object.v3);
        values.setFloat("k_object.v4", k_object.v4);
        values.setFloat("k_object.scale", k_object.scale);
        values.setBoolean("k_object.showVerts", k_object.showVerts);
        values.setBoolean("k_object.showCoords", k_object.showCoords);


// the pattern parameters
        values.setInt("k_pattern.id", k_pattern.id);
        values.setBoolean("k_pattern.show", k_pattern.show);
        values.setInt("k_pattern.strokew", k_pattern.strokew);
        values.setInt("k_pattern.color1", k_pattern.color1);
        values.setInt("k_pattern.color2", k_pattern.color2);
        values.setInt("k_pattern.t1", k_pattern.t1);
        values.setInt("k_pattern.t2", k_pattern.t2);
        values.setInt("k_pattern.t3", k_pattern.t3);
        values.setInt("k_pattern.t4", k_pattern.t4);
        values.setFloat("k_pattern.scale", k_pattern.scale);
        values.setFloat("k_pattern.theta", k_pattern.theta);
        values.setFloat("k_pattern.speed", k_pattern.speed);
        values.setFloat("k_pattern.frames", k_pattern.frames);
        values.setFloat("k_pattern.v1", k_pattern.v1);
        values.setFloat("k_pattern.v2", k_pattern.v2);
        values.setFloat("k_pattern.v3", k_pattern.v3);
        values.setFloat("k_pattern.v4", k_pattern.v4);

// the mask parameters
        values.setInt("k_mask.id", k_mask.id);
        values.setInt("k_mask.r", k_mask.r);
        values.setInt("k_mask.dx", k_mask.dx);
        values.setInt("k_mask.dy", k_mask.dy);
        values.setInt("k_mask.color1", k_mask.color1);
        values.setBoolean("k_mask.show", k_mask.show);
        values.setFloat("k_mask.scale", k_mask.scale);


        saveJSONObject(values, dataPath("") + "/conf/" + theID + ".json");
        println("saved data/conf/" + theID + ".json");
//      println(values);
//      this.id++;
//      println("next id " + theID);
}

    public void kload(int theID) {
        File f = new File(dataPath("conf") + "/" + theID + ".json");
        
        if (f.exists()) {
          values.equals(0);
          println("kload: Loading " + dataPath("conf") + "/" + theID + ".json");
          values = loadJSONObject(dataPath("conf") + "/" + theID + ".json");

  // the bg parameters
  //println(" loading bg parms");
          k_bg.set_mode(values.getInt("k_bg.mode"));
          
          // if the loaded seqid is different to the current one, we need to reload the images array
          // and it seems to be asyncrhonous so we need to hide while all this goes on
          Boolean seqIsChanging = false;
          if ( k_bg.seqid != values.getInt("k_bg.seqid") ) {
            seqIsChanging = true;
            k_bg.color1 = color(0,0);
            k_bg.mode = 0;
            k_bg.set_seq(values.getInt("k_bg.seqid"));
            k_bg.loadFilenames();
            k_bg.loadImages(values.getInt("k_bg.imgid")); // loadImages will set its ID to the received value so no need to explicitly set it here
    
          }
          k_bg.set_color1(values.getInt("k_bg.color1"));
          k_bg.set_color2(values.getInt("k_bg.color2"));
          k_bg.set_scale(values.getFloat("k_bg.scale"));
          k_bg.dr = values.getFloat("k_bg.dr");
          k_bg.r = values.getFloat("k_bg.r");
          k_bg.set_rotate(values.getInt("k_bg.r"));
          k_bg.mode = values.getInt("k_bg.mode");
  
          
  // the object parameters
  //println("loading obj parms");
          k_object.show = values.getBoolean("k_object.show");
          k_object.load_obj(values.getInt("k_object.id"));
          k_object.set_strokecolor(values.getInt("k_object.strokecolor"));
          k_object.set_strokew(values.getInt("k_object.strokew"));
          k_object.set_fillcolor(values.getInt("k_object.fillcolor"));
          k_object.tilex = values.getInt("k_object.tilex");
          k_object.tiley = values.getInt("k_object.tiley");
          k_object.dx = values.getFloat("k_object.dx");
          k_object.dy = values.getFloat("k_object.dy");
          k_object.dz = values.getFloat("k_object.dz");
          k_object.rx = values.getFloat("k_object.rx");
          k_object.ry = values.getFloat("k_object.ry");
          k_object.rz = values.getFloat("k_object.rz");
          k_object.t1 = values.getInt("k_object.t1");
          k_object.t2 = values.getInt("k_object.t2");
          k_object.t3 = values.getInt("k_object.t3");
          k_object.t4 = values.getInt("k_object.t4");
          k_object.v1 = values.getFloat("k_object.v1");
          k_object.v2 = values.getFloat("k_object.v2");
          k_object.v3 = values.getFloat("k_object.v3");
          k_object.v4 = values.getFloat("k_object.v4");
          k_object.set_scale(values.getFloat("k_object.scale"));
          k_object.showVerts = values.getBoolean("k_object.showVerts");
          k_object.showCoords = values.getBoolean("k_object.showCoords");
  
  // the pattern parameters
  //println("loading ptn parms");
          k_pattern.set_shape(values.getInt("k_pattern.id"));
          k_pattern.set_strokew(values.getInt("k_pattern.strokew"));
          k_pattern.set_color1(values.getInt("k_pattern.color1"));
          k_pattern.set_color2(values.getInt("k_pattern.color2"));
  //        k_pattern.t1 = values.getInt("k_pattern.t1");
  //        k_pattern.t2 = values.getInt("k_pattern.t2");
  //        k_pattern.t3 = values.getInt("k_pattern.t3");
  //        k_pattern.t4 = values.getInt("k_pattern.t4");
          k_pattern.show = values.getBoolean("k_pattern.show");
          k_pattern.set_scale(values.getFloat("k_pattern.scale"));
          k_pattern.theta = values.getFloat("k_pattern.theta");
          k_pattern.speed = values.getFloat("k_pattern.speed");
          k_pattern.frames = values.getFloat("k_pattern.frames");
          k_pattern.v1 = values.getFloat("k_pattern.v1");
          k_pattern.v2 = values.getFloat("k_pattern.v2");
          k_pattern.v3 = values.getFloat("k_pattern.v3");
          k_pattern.v4 = values.getFloat("k_pattern.v4");
          k_pattern.showhide(values.getBoolean("k_pattern.show"));
  
  // and the mask ones last
  //println("loading mask parms");
          k_mask.id = values.getInt("k_mask.id");
          k_mask.r = values.getInt("k_mask.r");
          k_mask.dx = values.getInt("k_mask.dx");
          k_mask.dy = values.getInt("k_mask.dy");
          k_mask.color1 = values.getInt("k_mask.color1");
          k_mask.showhide(values.getBoolean("k_mask.show"));
          k_mask.set_scale(values.getFloat("k_mask.scale"));
  
  // why does the heap increase every time we run this function? let's see
  System.gc();
  
  
          k_bg.update();
          k_object.update();
          k_pattern.update();
          k_mask.update();
    }
  }
}