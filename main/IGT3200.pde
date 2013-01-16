import controlP5.*; // controlP5 library
ControlP5 controlP5;
color red_ = color(120, 30, 30);

Button buttonRESET;

public void bRESET() {
  copter.clean();
  copter.position = new Vector(400, 300, -230);
  copter.lineAcceleration = new Vector(0.0,0.0,0.0);
  copter.angularAcceleration = new Vector(0.0,0.0,0.0);
  copter.velocity = new Vector(0.0,0.0,0.0);
  copter.angularSpeeds = new Vector(0.0,0.0,0.0);
  copter.angles = new Vector(0.0,0.0,0.0); 
}
/*import processing.serial.*;
import processing.serial.Serial; // serial library
import controlP5.*;// controlP5 library
import processing.opengl.*; 
import java.lang.StringBuffer; // for efficient String concatemation
import javax.swing.SwingUtilities; // required for swing and EDT
import javax.swing.JFileChooser; // Saving dialogue
import javax.swing.filechooser.FileFilter; // for our configuration file filter "*.mwi"
import javax.swing.JOptionPane; // for message dialogue


Serial myPort;  // Create object from Serial class
ControlP5 controlP5;
cGraph g_graph;//график

Slider scaleSlider;//полоска масштаба

//массивы из входных данных
cDataArray accPITCH   = new cDataArray(200), accROLL    = new cDataArray(200), accYAW     = new cDataArray(200),
           gyroPITCH  = new cDataArray(200), gyroROLL   = new cDataArray(200), gyroYAW    = new cDataArray(200),
           magxData   = new cDataArray(200), magyData   = new cDataArray(200), magzData   = new cDataArray(200),
           altData    = new cDataArray(200), headData   = new cDataArray(200), tempData   = new cDataArray(200),
           magxDData  = new cDataArray(200), magyDData  = new cDataArray(200), magzDData  = new cDataArray(200);

private static final int ROLL = 0, PITCH = 1, YAW = 2, ALT = 3, VEL = 4, LEVEL = 5, MAG = 6;


int lf = 10; // 10 is '\n' in ASCII
byte[] inBuffer = new byte[200];


int ch = 0;
float ax, ay, az = 0;
float gx, gy, gz = 0;
float gt = 0; 

int dm, ms = 0;

PFont font;
PrintWriter output;

//int wGraph = 500  ,hGraph = 160;//ширина и высота графика
//int xGraph = 220  ,yGraph = 5;  //координаты графика
int xText  = 5    ,yText  = 60; //координаты текста
int xScale = 704  ,yScale = yGraph  ,maxScale = 10  ,minScale = 0  ,widthScale = 150  ,heightScale = 20;

void setup2() 
{
  //свойства окна
  size(wGraph + 240, hGraph+40);
  //smooth();
  controlP5 = new ControlP5(this); // initialize the GUI controls
  scaleSlider = controlP5.addSlider("SCALE",minScale,maxScale,1,xGraph+wGraph-widthScale,yGraph,widthScale,heightScale);//0-10 пределы ползунка 
 
  scaleSlider.setLabel("");
  g_graph  = new cGraph(xGraph,yGraph, wGraph, hGraph);  
  output = createWriter("D:\\замеры\\замеры\\перемещения по квартире.csv"); 
}


void draw2() {
      String inputString = new String(inBuffer);
      String [] inputStringArr = split(inputString, ';');
      
      ch=int(inputStringArr[1]);
      switch(ch) { //кейсим канал
      
  //"zamer;ch_num;ch_val;time_ms;r1;fi1;tet1;R2;FI2;TET2;quality;"    
  case 1: ax=float(inputStringArr[2]);accPITCH.addVal(ax); break; //Акселерометр Х
  case 2: ay=float(inputStringArr[2]);accROLL.addVal(ay); break; //Акселерометр Y
  case 3: az=float(inputStringArr[2]);accYAW.addVal(ax); break; //Акселерометр Z
  case 4: gx=float(inputStringArr[2]);gyroPITCH.addVal(gx); break; //Гироскоп Х
  case 5: gy=float(inputStringArr[2]);gyroROLL.addVal(gy); break; //Гироскоп Y
  case 6: gz=float(inputStringArr[2]);gyroYAW.addVal(gz); break; //Гироскоп Z
  case 7: gt=float(inputStringArr[2]);tempData.addVal(gt); break; //Температура
  case 8: dm=int(inputStringArr[2]);        //Расстояние 
          ms=int(inputStringArr[3]); break; //время мс  
  //case 9:  altData.addVal(int(inputStringArr[2])); break;//высота
  case 9: magxData.addVal(int(inputStringArr[2])); break;//магнитные данные X
  case 10: magyData.addVal(int(inputStringArr[2])); break;//магнитные данные Y
  case 11: magzData.addVal(int(inputStringArr[2])); break;//магнитные данные Z
  case 12: magxDData.addVal(float(inputStringArr[2]));break;//стандартное отклонение по X
  case 13: magyDData.addVal(float(inputStringArr[2]));break;//стандартное отклонение по Y
  case 14: magzDData.addVal(float(inputStringArr[2]));break;//стандартное отклонение по Z
  case 15: break;//мат ожид
  case 16: break;
  case 17: break;
  case 18: magxDData.addVal(float(inputStringArr[2])); break;
  case 19: magyDData.addVal(float(inputStringArr[2]));break;
  case 20: magzDData.addVal(float(inputStringArr[2]));break;
  default:  print("Err ch is:");println(ch); break; //исключения выпадать должны здесь
} 
  
  background(#000000);

  int R = 0;
  int G = 255;
  int B = 0;
  color greencolor = color(R, G, B);
  fill(greencolor);

  //textFont(font);
  text("Logger\n" + "enabled", 20, 30);
  text("ax=\n" + ax, xText, yText);
  text("ay=\n" + ay, xText+65, yText);
  text("az=\n" + az, xText+125, yText);

  text("gx=\n" + gx, xText, yText + 30);
  text("gy=\n" + gy, xText+65, yText + 30);
  text("gz=\n" + gz, xText+125, yText + 30);

  text("temp=\n" + gt, xText, yText + 60);
  text("dist=\n" + dm, xText+65, yText + 60);
  text("time=\n" + ms, xText+125, yText + 60);
      // ---------------------------------------------------------------------------------------------
  // GRAPH
  // ---------------------------------------------------------------------------------------------
  strokeWeight(1);
  fill(255, 255, 255);
  g_graph.drawGraphBox();
  strokeWeight(1.5);
  stroke(255, 0, 0);g_graph.drawLine(magxDData, -1000, +1000);
  stroke(0, 255, 0);g_graph.drawLine(magyDData, -1000, +1000);
  stroke(0, 0, 255);g_graph.drawLine(magzDData, -1000, +1000);
 // stroke(0, 127, 0);g_graph.drawLine(accPITCH, -1000, +1000);
 // stroke(0, 0, 127);g_graph.drawLine(accYAW, -1000, +1000);
 // stroke(127, 127, 0);g_graph.drawLine(accROLL, -1000, +1000);
  
  
  
  
  
  stroke(0, 0, 0);
}
void keyPressed2() { // Press a key to save the data
  output.flush(); // Write the remaining data
  output.close(); // Finish the file
  exit(); // Stop the program
}


//********************************************************
//********************************************************
//********************************************************
/*
class cDataArray {
  float[] m_data;
  int m_maxSize, m_startIndex = 0, m_endIndex = 0, m_curSize;
  
  cDataArray(int maxSize){
    m_maxSize = maxSize;
    m_data = new float[maxSize];
  }
  void addVal(float val) {
    m_data[m_endIndex] = val;
    m_endIndex = (m_endIndex+1)%m_maxSize;
    if (m_curSize == m_maxSize) {
      m_startIndex = (m_startIndex+1)%m_maxSize;
    } else {
      m_curSize++;
    }
  }
  float getVal(int index) {return m_data[(m_startIndex+index)%m_maxSize];}
  int getCurSize(){return m_curSize;}
  int getMaxSize() {return m_maxSize;}
  float getMaxVal() {
    float res = 0.0;
    for(int i=0; i<m_curSize-1; i++) if ((m_data[i] > res) || (i==0)) res = m_data[i];
    return res;
  }
  float getMinVal() {
    float res = 0.0;
    for(int i=0; i<m_curSize-1; i++) if ((m_data[i] < res) || (i==0)) res = m_data[i];
    return res;
  }
  float getRange() {return getMaxVal() - getMinVal();}
}



// This class takes the data and helps graph it
class cGraph {
  float m_gWidth, m_gHeight, m_gLeft, m_gBottom, m_gRight, m_gTop;
  
  cGraph(float x, float y, float w, float h) {
    m_gWidth     = w; m_gHeight    = h;
    m_gLeft      = x; m_gBottom    = y;
    m_gRight     = x + w;
    m_gTop       = y + h;
  }
  
  void drawGraphBox() {
    stroke(0, 0, 0);
    rectMode(CORNERS);
    rect(m_gLeft, m_gBottom, m_gRight, m_gTop);
  }
  
  void drawLine(cDataArray data, float minRange, float maxRange) {
    float graphMultX = m_gWidth/data.getMaxSize();
    float graphMultY = m_gHeight/(maxRange-minRange);
    
    for(int i=0; i<data.getCurSize()-1; ++i) {
      float x0 = i*graphMultX+m_gLeft;
      float y0 = m_gTop-(((data.getVal(i)-(maxRange+minRange)/2)*scaleSlider.value()+(maxRange-minRange)/2)*graphMultY);
      float x1 = (i+1)*graphMultX+m_gLeft;
      float y1 = m_gTop-(((data.getVal(i+1)-(maxRange+minRange)/2 )*scaleSlider.value()+(maxRange-minRange)/2)*graphMultY);
      line(x0, y0, x1, y1);
    }
  }
}*/

