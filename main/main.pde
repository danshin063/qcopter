float gTotalTime = 0.0;
float gAmpl = 3.0;

Copter copter;
cDataArray mxData = new cDataArray(200), myData = new cDataArray(200), mzData = new cDataArray(200), 
           fmxData = new cDataArray(200), fmyData = new cDataArray(200), fmzData = new cDataArray(200);
//cGraph mg_graph;
int wGraph = 400  ,hGraph = 160;//ширина и высота графика
int xGraph = 880  ,yGraph = 000;  //координаты графика
cGraph mx_graph  = new cGraph(xGraph,yGraph, wGraph, hGraph);
int wGraph2 = 400  ,hGraph2 = 160;//ширина и высота графика
int xGraph2 = 880  ,yGraph2 = 200;  //координаты графика
cGraph my_graph  = new cGraph(xGraph2,yGraph2, wGraph2, hGraph2);
int wGraph3 = 400  ,hGraph3 = 160;//ширина и высота графика
int xGraph3 = 880  ,yGraph3 = 400;  //координаты графика
cGraph mz_graph  = new cGraph(xGraph3,yGraph3, wGraph3, hGraph3);/**/
//Graphics grap;
float baseEngineLevel = 0.5;
float engineMouseSensitivity = 0.1;
//float engineMouseSensitivity = 0.01;
float stableSensitivity = 0.0;
float engine1 = 0.0;
float engine2 = 0.0;
float engine3 = 0.0;
float engine4 = 0.0;
float i=0;

float k=1;
float l=50;
float b=1;

int viewWidth = 1280;
int viewHeight = 720;

void setup()
{
  size (viewWidth, viewHeight, P3D);
  camera (0.0, -100.0, gAmpl*500.0, 0.0, 0.0, 0.0, 0, 1, 0);
  //camera (0.0, -1000.0, 0.0, 0.0, 0.0, 0.0, 0, 0, 1);
  colorMode(RGB, 1); 

  copter = new Copter(1.0, new Vector(0.0, 0.0, 0.0), 1.0, 1.0, 1.0,
                           new ArrayList<Engine>(){{
                             add(new Engine(new Vector(-1.0, 0.0, -1.0), 2.4526 * 2.0, 1.1, 1000, 400000, 1.0, 1.0));
                             add(new Engine(new Vector( 1.0, 0.0, -1.0), 2.4526 * 2.0, 1.1, 1000, 400000,-1.0, 1.0));
                             add(new Engine(new Vector( 1.0, 0.0,  1.0), 2.4526 * 2.0, 1.1, 1000, 400000, 1.0, 1.0));
                             add(new Engine(new Vector(-1.0, 0.0,  1.0), 2.4526 * 2.0, 1.1, 1000, 400000,-1.0, 1.0));
                           }});
  //copter.angles.z = HALF_PI/4;
  //copter.angles.x = HALF_PI/2;
  updateEnginesLevers();
  controlP5 = new ControlP5(this);
  buttonRESET = controlP5.addButton("bRESET",1,210,480,40,19); buttonRESET.setLabel("RESET"); buttonRESET.setColorBackground(red_);
  frameRate(100);
}

void updateEnginesLevers()
{
  copter.setEngineLever(0, baseEngineLevel + engine1 -0.0);
  copter.setEngineLever(1, baseEngineLevel + engine2 +0.0);
  copter.setEngineLever(2, baseEngineLevel + engine3 -0.0);
  copter.setEngineLever(3, baseEngineLevel + engine4 +0.0);
  //copter.angularSpeeds.print("Угловая скорость");
  //System.out.printf("%8.4f %8.4f %8.4f %8.4f", engine1, engine2, engine3, engine4);
}


void draw()
{
  background(0.2);
  //copter.clean();
 if (keys['t']) {
   baseEngineLevel = 1.0;
 } else if (keys['g']) {
   baseEngineLevel = 0.4;
 } else {
   baseEngineLevel = 0.5;
 }
 //copter.angularSpeeds.print("Скорость");
 engine1 = keys['u']? engineMouseSensitivity : (keys['w']? -engineMouseSensitivity : 0);
 engine2 = keys['i']? engineMouseSensitivity : (keys['e']? -engineMouseSensitivity : 0);
 engine3 = keys['k']? engineMouseSensitivity : (keys['d']? -engineMouseSensitivity : 0);
 engine4 = keys['j']? engineMouseSensitivity : (keys['s']? -engineMouseSensitivity : 0);
 /*
 engine1 = keys['p']? engineMouseSensitivity : 0;
 engine3 = keys['p']? engineMouseSensitivity : 0;*/
  
  copter._shouldMove = ( ! (keys['f'] || keys['v'] || 
 keys['c'] || keys['b'] || 
 keys['k'] || keys['d']
 ) );
  
 Vector moveDirection = new Vector(0, 0, 0); 
 if (keys['f']) moveDirection.z -= 0.3;
 if (keys['v']) moveDirection.z += 0.3;
 if (keys['c']) moveDirection.x -= 0.3;
 if (keys['b']) moveDirection.x += 0.3;
 copter.setMoveDirection(moveDirection);
 copter.course();
  copter._shouldStabilize =  ( ! (keys['u'] || keys['w'] || 
 keys['i'] || keys['e'] || 
 keys['k'] || keys['d'] || 
 keys['j'] || keys['s'] ||
 keys['t'] || keys['g']
 ) );
 //copter._shouldStabilize = false;


 updateEnginesLevers();
   
  copter.update(0.01);
  gTotalTime += 0.01;
  //System.out.printf("%f\n", gTotalTime);
  
  copter.drawCS(100.0, 1.0, 1.0, 1.0); // 100 - размер коптера 
  copter.drawUp(100.0);  //Зеленая линия вверх
   mxData.addVal(copter.angles.x * 1000); 
   myData.addVal(copter.angles.y * 1000);
   mzData.addVal(copter.angles.z * 1000);
 
   
  strokeWeight(1);
  fill(255, 255, 255);
  mx_graph.drawGraphBox();
  my_graph.drawGraphBox();
  mz_graph.drawGraphBox();
  strokeWeight(1.5);
  stroke(255, 0, 0);mx_graph.drawLine(mxData, -1000, +1000);
  stroke(0, 255, 0);mx_graph.drawLine(fmxData, -1000, +1000);
  stroke(255, 0, 0);my_graph.drawLine(myData, -1000, +1000);
  stroke(0, 255, 0);my_graph.drawLine(fmyData, -1000, +1000);
  stroke(255, 0, 0);mz_graph.drawLine(mzData, -1000, +1000);
  stroke(0, 255, 0);mz_graph.drawLine(fmzData, -1000, +1000);
  //stroke(0, 0, 255);mg_graph.drawLine(mzData, -1000, +1000);
  //copter.angularSpeeds.print("AngularSpeed");
}

//-------------------------->>DrawEnd

boolean[] keys = new boolean[65536]; 

void handleKeys(char key)
{
}

void keyReleased()
{
  keys[key] = false;
  handleKeys(key);
}

void keyPressed()
{
  keys[key] = true;
  handleKeys(key);
}
//------------------------------------------------------------------------->>Graphic
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
    stroke(50, 50, 50);
    rectMode(CORNERS);
    rect(m_gLeft, m_gBottom, m_gRight, m_gTop);
  }
  
  void drawLine(cDataArray data, float minRange, float maxRange) {
    float graphMultX = m_gWidth/data.getMaxSize();
    float graphMultY = m_gHeight/(maxRange-minRange);
    
    for(int i=0; i<data.getCurSize()-1; ++i) {
      float x0 = i*graphMultX+m_gLeft;
      float y0 = m_gTop-(((data.getVal(i)-(maxRange+minRange)/2)+(maxRange-minRange)/2)*graphMultY);
      float x1 = (i+1)*graphMultX+m_gLeft;
      float y1 = m_gTop-(((data.getVal(i+1)-(maxRange+minRange)/2 )+(maxRange-minRange)/2)*graphMultY);
      line(x0, y0, x1, y1);
    }
  }
}




