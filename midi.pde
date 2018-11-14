import themidibus.*; //Import the library
import javax.sound.midi.MidiMessage; //Import the MidiMessage classes http://java.sun.com/j2se/1.5.0/docs/api/javax/sound/midi/MidiMessage.html
import javax.sound.midi.SysexMessage;
import javax.sound.midi.ShortMessage;

MidiBus myBus; // The MidiBus
int timer = millis(),
    tdelta = 0,
    tick = 1,
    beat = 1;

public void KMidi_init() {
  MidiBus.list(); // List all available Midi devices on STDOUT. This will show each device's index and name.
  myBus = new MidiBus(this, "LK Mini MIDI", -1); // Create a new MidiBus object

};

void midiMessage(MidiMessage message) {
  // Receive a MidiMessage
  int mstatus = message.getStatus();
  switch(mstatus) {
    case 248: 
      // MIDI Clock tick
      tdelta = millis() - timer;
      timer = millis();
      tick = ( tick+1) % 24  ; 
      if (tick == 1) { 
        beat = (beat+1) % 4;
//        print(beat + " ");
        if (beat == 3 ) {
//          println("--------");
        }
      };
      break;
    case 192:
      // Program Change
      int pchange = message.getMessage()[1] & 0xFF;
      println("Program Change: " + pchange);
      k_config.kload(pchange);
      break;
    default:
      println("Status Byte/MIDI Command:"+message.getStatus());
      for (int i = 1;i < message.getMessage().length;i++) {
        println("Param "+(i+1)+": "+(int)(message.getMessage()[i] & 0xFF));
       }
       println("------");
      break;
  }
  
}

void controllerChange(int channel, int number, int value) {
  // Receive a controllerChange
  //println();
  //println("Controller Change:");
  //println("--------");
  //println("Channel:"+channel);
  //println("Number:"+number);
  //println("Value:"+value);
  switch(number) {
    case 0: // MVC Bank Select MSB 
    break;
    case 32: // MVC Bank Select LSB
    break;
    case 5: // MVC Dissolve Time MSB 
    break;
    case 37: // MVC Dissolve Time LSB
    break;
    case 71: // MVC Effect Control 1
    break;
    case 72: // MVC Effect Control 2
    break;
    case 73: // MVC Effect Control 3
    break;
    case 121: //MVC Reset All Controllers
    break;
    
  }
}

//void programChange(int channel, int number) {
//  println("Program Change:");
//  println("Channel: "+channel);
//  println("Number: " + number);
//}