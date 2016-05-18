/**
 * ControlP5 Slider set value
 * changes the value of a slider on keyPressed
 *
 * by Andreas Schlegel, 2012
 * www.sojamo.de/libraries/controlP5
 *
 */
import peasy.*;
import javax.swing.*; 
//import remixlab.proscene.*;
import processing.opengl.*;

import static javax.swing.JOptionPane.*;
import controlP5.*;
import cc.arduino.*;
import processing.serial.*;
boolean start =false;
final boolean debug = true;



float radius;
float depth;
float ang = 0, ang2 = 0;
int pts = 120;
color moving=#F51119;
color cvalue=#F51119;
color dofgroundstroke=#FFDB27;
color dofgroundfill=#FFC710;
color dofsecstroke=#1179F5;
color dofsecfill=#F511C4;

color doftecstroke=#E8876F;
color doftecfill=#BABDB6;

color dofabovestroke=#00FF61;
color dofabovefill=#00B5FF;

color doftopstroke=#A40000;
color doftopfill=#00FF61;


Serial myPort;        // The serial port
//private PeasyCam cam;
PeasyCam cam;

ControlP5 cp5;

Arduino arduino; 
//console
int xs, ys, zs;
int c = 0;
Println console;
Textarea myTextarea;
String groundinput, secinput, tecinput, aboveinput, topinput, clawinput, smoothinput;
int framefps = 60;
color myColorBackground =  #FFFFFF;
//move smooth
int smomov=1;
int ground = 90;
int sec = 90; // original 105
int tec = 90;
int above = 90;
int top =90;
int claw = 96;
public int oground, osec, otec, oabove, otop, oclaw;
int s1ground, s1sec, s1tec, s1above, s1top, s1claw;
int s2ground, s2sec, s2tec, s2above, s2top, s2claw;
int s3ground, s3sec, s3tec, s3above, s3top, s3claw;
int s4ground, s4sec, s4tec, s4above, s4top, s4claw;
int pground=90;
int psec=90;
int ptec=90;
int pabove=90;
int ptop=90;
int pclaw=96;
int parkground=90;
int parksec=130;
int parktec=90;
int parkabove=90;
int parktop =90;
int parkclaw = 96;

int vccPin = 2;
color off = color(4, 79, 111);
color on = color(84, 145, 158);

public void setup() {  
  size(720, 400, OPENGL);
    frameRate(framefps);
    directionalLight(166, 166, 196, -60, -60, -60);
  ambientLight(105, 105, 130);

  smooth(233);
  cam = new PeasyCam(this, 700);
  cam.setMinimumDistance(2);
  cam.setMaximumDistance(700);
  //cam.setP
  
  String COMx, COMlist = "";

  println(Arduino.list());
  PFont fontinput = createFont("arial", 14);
  noStroke();
  cp5 = new ControlP5(this);
  cp5.enableShortcuts();
  myTextarea = cp5.addTextarea("txt")
    .setPosition(590, 15)
    .setSize(120, 300)
    .setFont(createFont("", 10))
    .setLineHeight(14)
    .setColor(#12FF00)
    ;

  console = cp5.addConsole(myTextarea);


  cp5.addButton("VCC").setPosition(5, 5).setSize(40, 40).setLabel("on/off").setColorBackground(color(off));
  cp5.addButton("on").setPosition(45, 5).setLabel("On").setSize(20, 40).setVisible(false);  
  cp5.addButton("off").setPosition(45, 5).setLabel("Off").setSize(20, 40).setVisible(true);  


  cp5.addButton("getpos").setLabel("GET POS").setPosition(5, 295).setSize(40, 30).update();  
  cp5.addButton("con").setPosition(5, 225).setSize(40, 30);
  cp5.addButton("PARK").setPosition(5, 260).setSize(40, 30);
  cp5.addButton("parksave").setPosition(5, 50).setSize(40, 10).setLabel("S");
  cp5.addButton("set1").setPosition(5, 90).setLabel("SET1").setSize(40, 20);
  cp5.addButton("set1s").setPosition(45, 90).setLabel("save").setSize(40, 20).setVisible(false);  
  cp5.addButton("set1l").setPosition(85, 90).setLabel("load").setSize(40, 20).setVisible(false);  
  cp5.addButton("set2").setPosition(5, 110).setLabel("SET2").setSize(40, 20);
  cp5.addButton("set2s").setPosition(45, 110).setLabel("save").setSize(40, 20).setVisible(false);
  cp5.addButton("set2l").setPosition(85, 110).setLabel("load").setSize(40, 20).setVisible(false);   
  cp5.addButton("set3").setPosition(5, 130).setLabel("SET3").setSize(40, 20);
  cp5.addButton("set3s").setPosition(45, 130).setLabel("save").setSize(40, 20).setVisible(false);
  cp5.addButton("set3l").setPosition(85, 130).setLabel("load").setSize(40, 20).setVisible(false);
  cp5.addButton("set4").setPosition(5, 150).setLabel("set4").setSize(40, 20);
  cp5.addButton("set4s").setPosition(45, 150).setLabel("save").setSize(40, 20).setVisible(false);   
  cp5.addButton("set4l").setPosition(85, 150).setLabel("load").setSize(40, 20).setVisible(false);

  cp5.addButton("setmov").setPosition(5, 60).setLabel("setmove").setSize(40, 30);
  cp5.addSlider("smomov").setRange(0, 100).setLabel("smooth steps").setValue(smomov).setPosition(45, 60).setSize(100, 30).setVisible(false).getTriggerEvent();    
//test slider
 //cp5.addSlider("ground").setRange(180, 0).setValue(ground).setNumberOfTickMarks(180).setPosition(75, 365).setSize(470, 30).getTriggerEvent();  

  cp5.addSlider("ground").setRange(180, 0).setValue(ground).setPosition(75, 365).setSize(470, 30).getTriggerEvent();
  cp5.addTextfield("groundinput").setPosition(40, 365).setLabel("ground").setSize(30, 30).setFont(fontinput);
  cp5.addButton("setground").setPosition(5, 365).setSize(30, 30).setLabel("OK").setOn().setId(1);    
  //cp5.addSlider("ground").setRange(180, 0).setValue(ground).setPosition(75, 365).setSize(470, 30).setId(11).setVisible(false);    

  cp5.addSlider("sec").setRange(180, 23).setValue(sec).setPosition(50, 85).setSize(30, 195).setVisible(true).getTriggerEvent(); 
  cp5.addTextfield("secinput").setPosition(50, 295).setLabel("").setSize(30, 30).setFont(fontinput);
  cp5.addButton("setsec").setPosition(50, 330).setSize(30, 30).setLabel("OK").setOn().setId(2);

  cp5.addSlider("tec").setRange(180, 23).setValue(tec).setPosition(100, 75).setSize(30, 200).setVisible(true).getTriggerEvent();  
  cp5.addTextfield("tecinput").setLabel("").setPosition(100, 290).setSize(30, 30).setFont(fontinput);
  cp5.addButton("settec").setPosition(100, 325).setSize(30, 30).setLabel("OK").setOn().setId(3);

  cp5.addSlider("above").setRange(150, 8).setValue(above).setPosition(245, 40).setSize(300, 30).getTriggerEvent() ; 
  cp5.addTextfield("aboveinput").setPosition(210, 40).setLabel("").setSize(30, 30).setFont(fontinput);
  cp5.addButton("setabove").setPosition(175, 40).setSize(30, 30).setLabel("OK").setOn().setId(4);

  cp5.addSlider("top").setRange(165, 10).setValue(top).setPosition(285, 5).setSize(295, 30).getTriggerEvent(); 
  cp5.addTextfield("topinput").setPosition(250, 5).setSize(30, 30).setLabel("").setFont(fontinput);
  cp5.addButton("setop").setPosition(215, 5).setSize(30, 30).setLabel("OK").setOn().setId(5);

  cp5.addSlider("claw").setRange(96, 150).setValue(claw).setPosition(550, 110).setSize(30, 180).getTriggerEvent();  
  cp5.addTextfield("clawinput").setPosition(550, 305).setSize(30, 30).setLabel("").setFont(fontinput);
  cp5.addButton("setclaw").setPosition(550, 340).setSize(30, 30).setLabel("OK").setOn().setId(6);

  cp5.addButton("setall").setPosition(5, 330).setSize(40, 30).setLabel("OK all").setOn().setId(7); 
  addMouseWheelListener();
  /*
       try {
   if(debug) printArray(Serial.list());
   int i = Arduino.list().length;
   if (i != 0) {
   if (i >= 2) {
   // need to check which port the inst uses -
   // for now we'll just let the user decide
   for (int j = 0; j < i;) {
   COMlist += char(j+'a') + " = " + Serial.list()[j];
   if (++j < i) COMlist += ",  ";
   }
   COMx = showInputDialog("Which COM port is correct? (a,b,..):\n"+COMlist);
   if (COMx == null) exit();
   if (COMx.isEmpty()) exit();
   i = int(COMx.toLowerCase().charAt(0) - 'a') + 1;
   }
   String portName = Arduino.list()[i-1];
   if(debug) println(portName);
   arduino = new Arduino(this, portName, 57600); // change baud rate to your liking
   // arduino.bufferUntil('\n'); // buffer until CR/LF appears, but not required..
   }
   else {
   showMessageDialog(frame,"Device is not connected to the PC");
   exit();
   }
   }
   catch (Exception e)
   { //Print the type of error
   showMessageDialog(frame,"COM port is not available (may\nbe in use by another program)");
   println("Error:", e);
   exit();
   }
   */
  //    arduino = new Arduino(this, Arduino.list()[1], 57600);
  //   arduino = new Arduino(this, "COM4", 57600);
   arduino = new Arduino(this, Arduino.list()[1], 57600);
 // arduino = new Arduino(this, "/dev/ttyACM0", 57600);
  arduino.pinMode(5, Arduino.SERVO); //ground
  arduino.pinMode(6, Arduino.SERVO);// sec
  arduino.pinMode(7, Arduino.SERVO);// tec
  arduino.pinMode(8, Arduino.SERVO); //above
  arduino.pinMode(4, Arduino.SERVO); //claw
//  arduino.pinMode(1, Arduino.SERVO); //ground
  arduino.pinMode(vccPin, Arduino.OUTPUT);
  arduino.digitalWrite(vccPin, Arduino.HIGH);

  cp5.setAutoDraw(false);
}


void controlEvent(ControlEvent theEvent) {
  switch(theEvent.getController().getId()) {
    case(1):  
    oground=ground;
    if (groundinput==null)
      ground=(int)cp5.getController("ground").getValue();
    else    
    {  
      groundinput= (String)cp5.getController("groundinput").getStringValue();
      ground= int(groundinput);
    }
    cp5.getController("ground").setUpdate(true);
    cp5.getController("ground").setValue(ground);
    draw();
    break;


    case(2):
    osec=sec;
    if (secinput==null)
      sec=(int)cp5.getController("sec").getValue();
    else    
    {  
      secinput= (String)cp5.getController("secinput").getStringValue();
      sec= int(secinput);
    }
    cp5.getController("sec").setUpdate(true);
    cp5.getController("sec").setValue(sec);
    draw();
    //println(theEvent.getController().getStringValue());
    break;

    case(3):
    otec=tec;   
    if (tecinput==null)
      tec=(int)cp5.getController("tec").getValue();
    else
    {
      tecinput = (String)cp5.getController("tecinput").getStringValue();   
      tec = int(tecinput);
    }   
    cp5.getController("tec").setUpdate(true);
    cp5.getController("tec").setValue(tec);
    draw();
    break;

    case(4):
    oabove=above;    
    if (aboveinput==null)
      above=(int)cp5.getController("above").getValue();
    else
    {
      aboveinput = (String)cp5.getController("aboveinput").getStringValue();   
      above = int(aboveinput);
    }      
    cp5.getController("above").setUpdate(true);
    cp5.getController("above").setValue(above);
    draw();   
    break;

    case(5):
    otop=top;
    if (topinput==null)
      top=(int)cp5.getController("top").getValue();
    else    
    {  
      secinput= (String)cp5.getController("topinput").getStringValue();
      top= int(topinput);
    }
    cp5.getController("top").setUpdate(true);
    cp5.getController("top").setValue(top);
    draw();
    break;

    case(6):
    oclaw=claw;
    if (clawinput==null)
      claw=(int)cp5.getController("claw").getValue();
    else
    { 
      clawinput = (String)cp5.getController("clawinput").getStringValue();   
      claw = int(clawinput);
    }
    cp5.getController("claw").setUpdate(true);
    cp5.getController("claw").setValue(claw);
    draw();
    break;
    //update all
    case(7):
    oground=ground;
    osec=sec;
    otec =tec;
    oabove=above;
    otop=top;
    oclaw=claw;
    if (groundinput==null)
      ground=(int)cp5.getController("ground").getValue();
    else
    {
      groundinput= (String)cp5.getController("groundinput").getStringValue();
      ground=int(groundinput);
      ground++;
    }

    if (secinput==null)
      sec=(int)cp5.getController("sec").getValue();
    else    
    {  
      secinput= (String)cp5.getController("secinput").getStringValue();
      sec= int(secinput);
    }

    if (tecinput==null)
      tec=(int)cp5.getController("tec").getValue();
    else
    {
      tecinput = (String)cp5.getController("tecinput").getStringValue();   
      tec = int(tecinput);
    }

    if (aboveinput==null)
      above=(int)cp5.getController("above").getValue();
    else
    {
      aboveinput = (String)cp5.getController("aboveinput").getStringValue();   
      above = int(aboveinput);
    }

    if (topinput==null)
      top=(int)cp5.getController("top").getValue();
    else
    {      
      topinput = (String)cp5.getController("topinput").getStringValue();   
      top = int(topinput);
    }  

    if (clawinput==null)
      claw=(int)cp5.getController("claw").getValue();
    else
    { 
      clawinput = (String)cp5.getController("clawinput").getStringValue();   
      claw = int(clawinput);
    }

    cp5.getController("ground").setUpdate(true);
    cp5.getController("ground").setValue(ground);
    cp5.getController("sec").setUpdate(true);
    cp5.getController("sec").setValue(sec);
    cp5.getController("tec").setUpdate(true);
    cp5.getController("tec").setValue(tec);
    cp5.getController("above").setUpdate(true);
    cp5.getController("above").setValue(above);
    cp5.getController("top").setUpdate(true);
    cp5.getController("top").setValue(top);
    cp5.getController("claw").setUpdate(true);
    cp5.getController("claw").setValue(claw);
    draw();
    break;
    case(11):
    ground=(int)cp5.getController("ground").getValue();
    cp5.getController("claw").setValue(claw);
    draw();

  default: 
  break;
  }
}



void draw() {

//  frame.setLocation(0,500);
  background(myColorBackground);


  if (pground != ground || psec !=sec || ptec !=tec || pabove != above || pclaw != claw)
    println(oground +"\t" + osec +"\t"+ otec+ "\t" +oabove+"\t" + otop + "\t"+ oclaw +"\t");
  if (start==true)
  {
    if (ground> oground)
    {
      int bet =ground -oground;
      for (int q =0; q<bet; q++)
      {
        oground++;
        arduino.servoWrite(5, oground);
        cp5.getController("ground").setColorActive(77);
        cp5.getController("ground").setUpdate(true);
        cp5.getController("ground").setValue(oground);
        println(oground +"\t" + sec +"\t"+ tec+ "\t" +above+"\t" + top + "\t"+ claw +"\t");
        delay(smomov);
      }
    }
    if (ground<oground)
    {
      int wet = oground -ground;
      for (int a= 0; a<wet; a++)
      {
        oground--;
        arduino.servoWrite(5, oground); 
        cp5.getController("ground").setColorActive(88);
        cp5.getController("ground").setUpdate(true);
        cp5.getController("ground").setValue(oground);
        println(oground +"\t" + sec +"\t"+ tec+ "\t" +above+"\t" + top + "\t"+ claw +"\t");
        delay(smomov);
      }
    }
    if (sec> osec)
    {
      int bet =sec -osec;
      for (int q =0; q<bet; q++)
      {
        osec++;
        arduino.servoWrite(6, osec); 
        cp5.getController("sec").setUpdate(true);
        cp5.getController("sec").setValue(osec);
        println(ground +"\t" + osec +"\t"+ tec+ "\t" +above+"\t" + top + "\t"+ claw +"\t");
        delay(smomov);
      }
    }
    if (sec<osec)
    {
      int wet = osec -sec;
      for (int a= 0; a<wet; a++)
      {
        osec--;
        arduino.servoWrite(6, osec); 
        cp5.getController("sec").setUpdate(true);
        cp5.getController("sec").setValue(osec);
        println(ground +"\t" + osec +"\t"+ tec+ "\t" +above+"\t" + top + "\t"+ claw +"\t");
        delay(smomov);
      }
    }   
    if (tec> otec)
    {
      int bet =tec -otec;
      for (int q =0; q<bet; q++)
      {
        otec++;
        arduino.servoWrite(7, otec); 
        cp5.getController("tec").setUpdate(true);
        cp5.getController("tec").setValue(otec);
        println(ground +"\t" + sec +"\t"+ otec+ "\t" +above+"\t" + top + "\t"+ claw +"\t");
        delay(smomov);
      }
    }
    if (tec < otec)
    {
      int wet = otec -tec;
      for (int a= 0; a<wet; a++)
      {
        otec--;
        arduino.servoWrite(7, otec); 
        cp5.getController("tec").setUpdate(true);
        cp5.getController("tec").setValue(otec);
        println(ground +"\t" + sec +"\t"+ otec+ "\t" +above+"\t" + top + "\t"+ claw +"\t");
        delay(smomov);
      }
    }  
    if (above> oabove)
    {
      int bet =above -oabove;
      for (int q =0; q<bet; q++)
      {
        oabove++;
        arduino.servoWrite(8, oabove); 
        cp5.getController("above").setUpdate(true);
        cp5.getController("above").setValue(oabove);
        println(ground +"\t" + sec +"\t"+ tec+ "\t" +oabove+"\t" + top + "\t"+ claw +"\t");
        delay(smomov);
      }
    }
    if (above < oabove)
    {
      int wet = oabove -above;
      for (int a= 0; a<wet; a++)
      {
        oabove--;
        arduino.servoWrite(8, oabove); 
        cp5.getController("above").setUpdate(true);
        cp5.getController("above").setValue(oabove);
        println(ground +"\t" + sec +"\t"+ tec+ "\t" +oabove+"\t" + top + "\t"+ claw +"\t");
        delay(smomov);
      }
    } 
    if (top> otop)
    {
      int bet =top -otop;
      for (int q =0; q<bet; q++)
      {
        otop++;
        arduino.servoWrite(9, otop); 
        cp5.getController("top").setUpdate(true);
        cp5.getController("top").setValue(otop);
        println(ground +"\t" + sec +"\t"+ tec+ "\t" +above+"\t" + otop + "\t"+ claw +"\t");
        delay(smomov);
      }
    }
    if (top < otop)
    {
      int wet = otop -top;
      for (int a= 0; a<wet; a++)
      {
        otop--;
        arduino.servoWrite(9, otop); 
        cp5.getController("top").setUpdate(true);
        cp5.getController("top").setValue(otop);
        println(ground +"\t" + sec +"\t"+ tec+ "\t" +above+"\t" + otop + "\t"+ claw +"\t");
        delay(smomov);
      }
    }  
    if (claw> oclaw)
    {
      int bet =claw -oclaw;
      for (int q =0; q<bet; q++)
      {
        oclaw++;
        arduino.servoWrite(4, oclaw); 
        cp5.getController("claw").setUpdate(true);
        cp5.getController("claw").setValue(oclaw);
        println(ground +"\t" + sec +"\t"+ tec+ "\t" +above+"\t" + top + "\t"+ oclaw +"\t");
        delay(smomov);
      }
    }
    if (claw < oclaw)
    {
      
      
      int wet = oclaw -claw;
      for (int a= 0; a<wet; a++)
      {
        oclaw--;
        arduino.servoWrite(4, oclaw); 
        cp5.getController("claw").setUpdate(true);
        cp5.getController("claw").setValue(oclaw);
        println(ground +"\t" + sec +"\t"+ tec+ "\t" +above+"\t" + top + "\t"+ oclaw +"\t");
        delay(smomov);
      }
    }  


    pground=ground;
    cp5.getController("ground").setUpdate(true);
    cp5.getController("ground").setValue(pground);
    psec=sec;
    cp5.getController("sec").setUpdate(true);
    cp5.getController("sec").setValue(psec);
    ptec=tec;
    cp5.getController("tec").setUpdate(true);
    cp5.getController("tec").setValue(ptec);

    pabove=above;
    cp5.getController("above").setUpdate(true);
    cp5.getController("above").setValue(pabove);
    ptop=top;
    pclaw=claw;
  } 
  else{
    println("First start");
    oground=ground;
    osec=sec;
    otec=tec;
    oabove=above;
    otop=top;
    oclaw=claw;
    cp5.getController("ground").setUpdate(true);
    cp5.getController("ground").setValue(ground);
    cp5.getController("sec").setUpdate(true);
    cp5.getController("sec").setValue(sec);
    cp5.getController("tec").setUpdate(true);
    cp5.getController("tec").setValue(tec);
    cp5.getController("above").setUpdate(true);
    cp5.getController("above").setValue(above);
    cp5.getController("top").setUpdate(true);
    cp5.getController("top").setValue(top);
    cp5.getController("claw").setUpdate(true);
    cp5.getController("claw").setValue(claw);
    start=true;
  }

  robot();
  gui();
}


void gui() {
  hint(DISABLE_DEPTH_TEST);
  cam.beginHUD();
  cp5.draw();
  cam.endHUD();
  hint(ENABLE_DEPTH_TEST);
}


public void robot() {

//float radius;
//this float depth;  
  rotateX(0);//45 am anfang
  rotate(0);
  noFill();
  stroke(1);
//  box(200, 200, 10);
  fill(#FF9627);
  noFill();

  stroke(#3465A4);
  strokeWeight(1);
  ellipse(0, 0, 150, 150);
  //horizont - ebene212
  pushMatrix();

  //rotateZ(45);
  //rotateY(270);



  //popMatrix();


  //erstes nicht bewglich
  //pushMatrix();
//mittel von grundplattform
  translate(0, 0, 25);
  fill(#BABDB6);
  stroke(#3465A4);
  strokeWeight(1);
  box(100, 10, 50);

  //browne 
  translate(0,20, -15);
  //groundservo halterung vom ground servo
  strokeWeight(1);
  fill(#BABDB6);
  stroke(#A40000);
  //unteres element
  box(20, 30, 2 );
  //ellipse(0, 0, 100, 100);
  translate(0, -14, 9);
  //groundservo aluding
  //platte am 
  box(20, 2, 20 );
  translate(-5, 24,7);
dofground();

dofsec();
  
  translate(0,65,20);
doftec();
rotateX(90*(PI/180));

rotateZ(90*(PI/180));
dofabove();
//drawdof(22 ,5 ,-40,#FFEBEF, (above * 90));
  popMatrix();
  }


public void getpos(int theValue) 
{
  print("ground:");
  println(ground);
  print("setground:");
  println(ground);
  print("sec:");
  println(sec);
  print("tec:");
  println(tec);
  print("above:");
  println(above);
  print("top:");
  println(top);
  print("claw:");
  println(claw);
}
/*
public void setground(int theValue)
 {
 ground = groundi;
 cp5.getController("ground").setUpdate(true);
 cp5.getController("ground").show();
 draw();
 }
 
 public void setground()
 {
 groundinput=(String)cp5.getController("groundinput").getStringValue();
 ground=int(groundinput);
 cp5.getController("ground").setUpdate(true);
 cp5.getController("ground").setValue(ground);
 print("ground: ");
 println(ground);
 draw();
 }*/

public void PARK() 
{
  ground=parkground;
  cp5.getController("ground").setUpdate(true);
  cp5.getController("ground").setValue(ground);
  delay(1000);
  sec =parksec;
  cp5.getController("sec").setUpdate(true);
  cp5.getController("sec").setValue(sec);
  delay(1000);
  tec=parktec;
  cp5.getController("tec").setUpdate(true);
  cp5.getController("tec").setValue(tec);
  delay(1000);
  above =parkabove;
  cp5.getController("above").setUpdate(true);
  cp5.getController("above").setValue(above);
  delay(1000);
  top =parktop;
  cp5.getController("top").setUpdate(true);
  cp5.getController("top").setValue(top);
  delay(1000);
  claw =parkclaw;
  cp5.getController("claw").setUpdate(true);
  cp5.getController("claw").setValue(claw);
}


public void VCC () {
  if (true==cp5.getController("on").isVisible())
  {
    println("POWER OFF");
    cp5.getController("VCC").setColorBackground(color(off));
    cp5.getController("off").setVisible(true);
    cp5.getController("on").setVisible(false);
    arduino.digitalWrite(vccPin, Arduino.HIGH);
  } else
  {
    println("POWER ON");
    cp5.getController("VCC").setColorBackground(color(on));
    cp5.getController("off").setVisible(false); 
    cp5.getController("on").setVisible(true); 
    arduino.digitalWrite(vccPin, Arduino.LOW);
  }
}




public void setmov ()
{
  if (true==cp5.getController("smomov").isVisible())
  {
    cp5.getController("smomov").setVisible(false);
    cp5.getController("sec").setVisible(true);
    cp5.getController("tec").setVisible(true);
  } else
  {
    cp5.getController("smomov").setVisible(true);
    cp5.getController("sec").setVisible(false);
    cp5.getController("tec").setVisible(false);
  }
  println("Smooth steps changed to " +smomov);
}

public void set1 ()
{
  if (true==cp5.getController("set1s").isVisible())
  {
    cp5.getController("set1s").setVisible(false);
    cp5.getController("set1l").setVisible(false);
    cp5.getController("sec").setVisible(true);
    cp5.getController("tec").setVisible(true);
  } else
  {
    cp5.getController("set1s").setVisible(true);
    cp5.getController("set1l").setVisible(true);
    cp5.getController("sec").setVisible(false);
    cp5.getController("tec").setVisible(false);
  }
  println("SET1 loaded \n" + "ground: "+s1ground+"sec: "+s1sec+ "tec: "+s1tec+ "above: "+s1above+ "top: "+s1top+"claw: "+s1claw );
}

public void set1s()
{
  s1ground =(int)cp5.getController("ground").getValue();
  s1sec =(int)cp5.getController("sec").getValue();
  s1tec =(int)cp5.getController("tec").getValue();
  s1above =(int)cp5.getController("above").getValue();
  s1top =(int)cp5.getController("top").getValue();
  s1claw =(int)cp5.getController("claw").getValue();
}

public void set1l ( )
{
  ground=s1ground;
  sec=s1sec;
  tec=s1tec;
  above=s1above;
  top=s1top;
  claw=s1claw;
  cp5.getController("ground").setUpdate(true);
  cp5.getController("ground").setValue(ground);
  cp5.getController("sec").setUpdate(true);
  cp5.getController("sec").setValue(sec);
  cp5.getController("tec").setUpdate(true);
  cp5.getController("tec").setValue(tec);
  cp5.getController("above").setUpdate(true);
  cp5.getController("above").setValue(above);
  cp5.getController("top").setUpdate(true);
  cp5.getController("top").setValue(top);
  cp5.getController("claw").setUpdate(true);
  cp5.getController("claw").setValue(claw);
}

public void set2 ()
{
  if (true==cp5.getController("set2s").isVisible())
  {
    cp5.getController("set2s").setVisible(false);
    cp5.getController("set2l").setVisible(false);
    cp5.getController("sec").setVisible(true);
    cp5.getController("tec").setVisible(true);
  } else
  {
    cp5.getController("set2s").setVisible(true);
    cp5.getController("set2l").setVisible(true);
    cp5.getController("sec").setVisible(false);
    cp5.getController("tec").setVisible(false);
  }
}
public void set2s ()
{
  s2ground =(int)cp5.getController("ground").getValue();
  s2sec =(int)cp5.getController("sec").getValue();
  s2tec =(int)cp5.getController("tec").getValue();
  s2above =(int)cp5.getController("above").getValue();
  s2top =(int)cp5.getController("top").getValue();
  s2claw =(int)cp5.getController("claw").getValue();
}

public void set2l ( )
{
  ground=s2ground;
  sec=s2sec;
  tec=s2tec;
  above=s2above;
  top=s2top;
  claw=s2claw;
  cp5.getController("ground").setUpdate(true);
  cp5.getController("ground").setValue(ground);
  cp5.getController("sec").setUpdate(true);
  cp5.getController("sec").setValue(sec);
  cp5.getController("tec").setUpdate(true);
  cp5.getController("tec").setValue(tec);
  cp5.getController("above").setUpdate(true);
  cp5.getController("above").setValue(above);
  cp5.getController("top").setUpdate(true);
  cp5.getController("top").setValue(top);
  cp5.getController("claw").setUpdate(true);
  cp5.getController("claw").setValue(claw);
}

public void set3 ()
{
  println("SET3");
  if (true==cp5.getController("set3s").isVisible())
  {
    cp5.getController("set3s").setVisible(false);
    cp5.getController("set3l").setVisible(false);
    cp5.getController("sec").setVisible(true);
    cp5.getController("tec").setVisible(true);
  } else
  {
    cp5.getController("set3s").setVisible(true);
    cp5.getController("set3l").setVisible(true);
    cp5.getController("sec").setVisible(false);
    cp5.getController("tec").setVisible(false);
  }
}

public void set3s ()
{
  s3ground =(int)cp5.getController("ground").getValue();
  s2sec =(int)cp5.getController("sec").getValue();
  s3tec =(int)cp5.getController("tec").getValue();
  s3above =(int)cp5.getController("above").getValue();
  s3top =(int)cp5.getController("top").getValue();
  s3claw =(int)cp5.getController("claw").getValue();
}

public void set3l ( )
{
  ground=s3ground;
  sec=s3sec;
  tec=s3tec;
  above=s3above;
  top=s3top;
  claw=s3claw;
  cp5.getController("ground").setUpdate(true);
  cp5.getController("ground").setValue(ground);
  cp5.getController("sec").setUpdate(true);
  cp5.getController("sec").setValue(sec);
  cp5.getController("tec").setUpdate(true);
  cp5.getController("tec").setValue(tec);
  cp5.getController("above").setUpdate(true);
  cp5.getController("above").setValue(above);
  cp5.getController("top").setUpdate(true);
  cp5.getController("top").setValue(top);
  cp5.getController("claw").setUpdate(true);
  cp5.getController("claw").setValue(claw);
}

public void set4 ()
{
  println("SET4");
  if (true==cp5.getController("set4s").isVisible())
  {
    cp5.getController("set4s").setVisible(false);
    cp5.getController("set4l").setVisible(false);
    cp5.getController("sec").setVisible(true);
    cp5.getController("tec").setVisible(true);
  } else
  {
    cp5.getController("set4s").setVisible(true);
    cp5.getController("set4l").setVisible(true);
    cp5.getController("sec").setVisible(false);
    cp5.getController("tec").setVisible(false);
  }
}

public void set4s ()
{
  s4ground =(int)cp5.getController("ground").getValue();
  s4sec =(int)cp5.getController("sec").getValue();
  s4tec =(int)cp5.getController("tec").getValue();
  s4above =(int)cp5.getController("above").getValue();
  s4top =(int)cp5.getController("top").getValue();
  s4claw =(int)cp5.getController("claw").getValue();
}

public void set4l ( )
{
  ground=s4ground;
  sec=s4sec;
  tec=s4tec;
  above=s4above;
  top=s4top;
  claw=s4claw;
  cp5.getController("ground").setUpdate(true);
  cp5.getController("ground").setValue(ground);
  cp5.getController("sec").setUpdate(true);
  cp5.getController("sec").setValue(sec);
  cp5.getController("tec").setUpdate(true);
  cp5.getController("tec").setValue(tec);
  cp5.getController("above").setUpdate(true);
  cp5.getController("above").setValue(above);
  cp5.getController("top").setUpdate(true);
  cp5.getController("top").setValue(top);
  cp5.getController("claw").setUpdate(true);
  cp5.getController("claw").setValue(claw);
}



// mouse wheel slider bewegen
void addMouseWheelListener() {
  frame.addMouseWheelListener(new java.awt.event.MouseWheelListener() {
    public void mouseWheelMoved(java.awt.event.MouseWheelEvent e) {
      cp5.setMouseWheelRotation(e.getWheelRotation());
    }
  }
  );
}



void drawCylinder( int sides, float r, float h)
{
  noStroke();
    float angle = 360 / sides;
    float halfHeight = h / 2;

    // draw top of the tube
    beginShape();
     stroke(1);

    for (int i = 0; i < sides; i++) {
        float x = cos( radians( i * angle ) ) * r;
        float y = sin( radians( i * angle ) ) * r;
        vertex( x, y, -halfHeight);
    }
    endShape(CLOSE);

    // draw bottom of the tube
    beginShape();
    for (int i = 0; i < sides; i++) {
        float x = cos( radians( i * angle ) ) * r;
        float y = sin( radians( i * angle ) ) * r;
        vertex( x, y, halfHeight);
    }
    endShape(CLOSE);
    
    // draw sides
     noStroke();

    beginShape(TRIANGLE_STRIP);
    for (int i = 0; i < sides + 1; i++) {
        float x = cos( radians( i * angle ) ) * r;
        float y = sin( radians( i * angle ) ) * r;
        vertex( x, y, halfHeight);
        vertex( x, y, -halfHeight);    
    }
    endShape(CLOSE);

}

void dofground(){
 //anfang dof
    //servo selbst
 float  crsground = 90* (PI/180);

    fill(dofgroundfill);
  stroke(dofgroundstroke);

  box(30, 10, 30 );
  
  //servo drehpunkt
   strokeWeight(1);
  fill(dofgroundfill);
  stroke(dofgroundstroke);
  translate(-10,0,-1);
  // box(1,1,32 );
    strokeWeight(1);
  fill(dofgroundfill);
  stroke(dofgroundstroke);
  //rotateZ(PI);
  
 
  rotateZ(crsground);
  
  float rad = radians(ground);
  rotateZ(rad * -1);

// zylynder( 2,17);
     drawCylinder( 30,  2, 40 );

 translate(0,15,19);
 strokeWeight(1);
 fill(dofgroundfill);
  noFill();

 stroke(dofgroundstroke);
 box(10,40,2 );

 translate(0,19,-19);
 strokeWeight(1);
 fill(dofgroundfill);
 noFill();

 stroke(dofgroundstroke);
 box(10,2,40 ); 
 
 translate(0,-19,-19);
 strokeWeight(1);
 fill(dofgroundfill);
  noFill();

 stroke(dofgroundstroke);
 box(10,40,2 );
 //ende  dof 
   
}
  
void dofsec()
{
 //float  crssec = 270* (PI/180);
  float  crssecx = 270* (PI/180);
  float  crssecy = 90* (PI/180);
  float  crssecz = 270* (PI/180);

 //anfang dofsec
    //servo selbst
translate(5,5,44);
rotateX(crssecx);
rotateY(crssecy);
    fill(#FFDB27);
  stroke(dofsecstroke);
  box(30, 10, 30 );
  //servo drehpunkt
   strokeWeight(1);
  fill(dofsecfill);
  stroke(dofsecstroke);
  translate(-10,0,-1);
    strokeWeight(1);
  fill(dofsecfill);
  stroke(dofsecstroke);
  rotateZ(crssecz);
  float rad = radians(sec);
  rotateZ(rad * -1);
     drawCylinder( 30,  2, 40 );
 translate(0,15,19);
 strokeWeight(1);
 fill(dofsecfill);
  noFill();
 stroke(dofsecstroke);
 box(10,40,2 );
 translate(0,19,-19);
 strokeWeight(1);
 fill(dofsecfill);
 noFill();
 stroke(dofsecstroke);
 box(10,2,40 ); 
 translate(0,-19,-19);
 strokeWeight(1);
 fill(dofsecfill);
  noFill();
 stroke(dofsecstroke);
 box(10,40,2 );
 //ende  dof  
}


void doftec()
{
 //float  crssec = 270* (PI/180);
// float  crstecx = 270* (PI/180);
//  float  crstecy = 90* (PI/180);
  //float  crstecz = 270* (PI/180);
 translate(0,-40,-1);
// box(10,2,40 );
 //anfang dofTec
    //servo selbst
    //rotateX(crstecx);
//rotateY(crstecy);
  translate(0,15,19);
 strokeWeight(2);
 fill(doftecfill);
  //noFill();
 stroke(doftecstroke);
 // roter
 box(10,40,2 );
 translate(0,-19,-19);
 
 strokeWeight(1);
 stroke(doftecstroke);
//fill(#00FF61);   //grünn aufliegendes zum voriegen servo gerüst
 noFill();
 box(10,2,40 ); 
 //boden = gegenüberliegendes vom roten 
 stroke(doftecstroke);
 translate(0,19,-19);
 strokeWeight(1);
fill(doftecfill);
 //noFill();
 box(10,40,2 );   
 stroke(doftecstroke);
 translate(0,15,19);
 strokeWeight(2);
  //noFill();
 fill(doftecfill);
//  rotateZ(crstecz);

 float rad = radians(tec+180);
 rotateZ((-rad) * -1);
 drawCylinder( 30,  2, 40 );   
   stroke(doftecstroke);
   noFill();
   fill(doftecfill);
  strokeWeight(1);
  translate(0,-8,1);
  box(10, 30, 30 );
  //servo drehpunkt
   strokeWeight(1);
  fill(doftecfill);
  /*
  translate(-10,0,-1);
  strokeWeight(1);
  fill(#FF2761);
  stroke(doftecstroke);
//  rotateZ(crstecz);
  float rad = radians(tec);
  rotateZ(rad * -1);
     drawCylinder( 30,  2, 40 );
 */
}

void dofabove(){
    translate(-11,10,6);
    float acrad = 270*(PI/180); 
    strokeWeight(1);
    fill(dofabovefill);
    stroke(dofabovestroke);
    box(30, 10, 30 );
    //servo drehpunkt
    fill(dofabovefill);
    stroke(dofabovestroke);
    translate(-10,0,-1);
    strokeWeight(1);
    fill(dofabovefill);
    stroke(dofabovestroke);
    float rad = radians(above);
    rotateZ((-rad)-acrad);
     drawCylinder( 30,  2, 40 );
     translate(0,15,19);
     strokeWeight(1);
     fill(dofabovefill);
     //noFill();
     stroke(dofabovestroke);
     box(10,40,2 );
     translate(0,19,-19);
     strokeWeight(1);
     fill(dofabovefill);
    // noFill();
     stroke(dofabovestroke);
     box(10,2,40 ); 
     translate(0,-19,-19);
     strokeWeight(1);
     fill(dofabovefill);
    // noFill();
     stroke(dofabovestroke);
     box(10,40,2 );
}
/*
void ground(int ground) {
  oground= ground;
 arduino.servoWrite(5, oground); 
 
 cp5.getController("ground").setUpdate(true);
 cp5.getController("ground").setValue(oground);
}
*/
/*
//anfang dof
    //servo selbst

    fill(#FFDB27);
  stroke(#27FFD5);

  box(30, 10, 30 );
  
  //servo drehpunkt
   strokeWeight(1);
  fill(#BABDB6);
  stroke(#A40000);
  translate(-10,0,-1);
  // box(1,1,32 );
    strokeWeight(1);
  fill(#FF2761);
  stroke(#001FFF);
  //rotateZ(PI);
  
 
  rotateZ(crsground);
  
  float rad = radians(ground);
  rotateZ(rad * -1);

// zylynder( 2,17);
     drawCylinder( 30,  2, 40 );

 translate(0,15,19);
 strokeWeight(1);
 fill(#BABDB6);
  noFill();

 stroke(#A40000);
 box(10,40,2 );

 translate(0,19,-19);
 strokeWeight(1);
 fill(#00FF61);
 noFill();

 stroke(#00B5FF);
 box(10,2,40 ); 
 
 translate(0,-19,-19);
 strokeWeight(1);
 fill(#00FF61);
  noFill();

 stroke(#00B5FF);
 box(10,40,2 );
 //ende  dof 
  

void drawdof(int tx , int ty ,int tz, color coldof, int dang)
{
  //float xrad= dang *(PI/180);
 //float  yrad = dang* (PI/180);
  float rad = (-dang)* (PI/180);


 //anfang dofsec
    //servo selbst
//rotateX(xrad);
//rotateY(yrad);
    fill(coldof);
  stroke(#FDFF00);

  box(30, 10, 30 );
  //servo drehpunkt
   strokeWeight(1);
 // fill(#BABDB6);
  stroke(#A40000);
  translate(-10,0,-1);
  strokeWeight(1);
  fill(#FF2761);
  stroke(#001FFF);
     rotateZ(rad);
     

 drawCylinder( 30,  2, 40 );
 translate(0,15,19);
 strokeWeight(1);
 fill(#BABDB6);
 //fill(coldof);
 stroke(#FDFF00);

 box(10,40,2 );
 translate(0,19,-19);
 strokeWeight(1);
 fill(#00FF61);
 fill(coldof); 
 stroke(#FDFF00);
 box(10,2,40 ); 
 
 translate( 0, -19,-19);
 strokeWeight(1);
 fill(#00FF61);
 noFill();
 fill(coldof);
 stroke(#FDFF00);
 box(10,40,2 );
 //ende  dof  
}

*/