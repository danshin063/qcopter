int gCnt = 10, gShow = 0, gInd = 0, gStep = 10, gStepCnt = 10;
float [] gX = new float [gCnt];
float [] gY = new float [gCnt];

float [] dX = {150, 150, -150, -150};
float [] dZ = {150, -150, 150, -150};
float [] dY = {80, -80, 80, -80};
int dInd = 0;

class Engine
{ 
  final public float draw_size = 30.0; // эталонный размер движка
  
  float torsion, maxTorsion; // Момент кручения, оказываемый на коптер 
  float traction, maxTraction; // Тяга (подъемная сила)
  float revolutions, maxRevolutions, targetRevolutions; // Количество оборотов: текущее, максимальное, целевое
  float maxRevolutionsSpeed; // Скорость нарастания количества оборотов
  float power; // Подаваемая мощность в диапазоне от 0.0 до 1.0
  float revolutionsDirection; // Направление вращения
  float eff; // Эффективность двигателя (для эмуляции неидеальности или даже поломки) от 0.0 до 1.0 (~0.99)
  float lever; // Рычаг
  
  public Vector momentum;
  public Vector force;
  public Vector position;
  
  float updateTraction() { return traction = maxTraction * (revolutions/maxRevolutions); }
  float updateTorsion() { return torsion = maxTorsion * revolutionsDirection * (revolutions/maxRevolutions); }
  float updateTargetRevolutions() { return targetRevolutions = maxRevolutions * power; }
  float updateRevolutions(float deltaTime) {
    return revolutions += constrain(targetRevolutions - revolutions, -deltaTime * maxRevolutionsSpeed, deltaTime * maxRevolutionsSpeed);
  }
  void updateAll(float deltaTime) {
    updateTargetRevolutions();
    updateRevolutions(deltaTime);
    updateTorsion();
    updateTraction();
  }
  
  /** position relative to the mass center*/
  Engine (Vector position, float maxTraction, float maxTorsion, float maxRevolutions, float maxRevolutionsSpeed, float revolutionsDirection, float eff)
  { 
    this.position = position;
    this.maxTraction = maxTraction;
    this.maxTorsion = maxTorsion;
    this.maxRevolutions = maxRevolutions;
    this.maxRevolutionsSpeed = maxRevolutionsSpeed;
    this.revolutionsDirection = revolutionsDirection > 0? 1.0 : -1.0;
    this.eff = constrain(eff, 0.0, 1.0);
    
    lever = dist(position.x, 0.0, position.y, 0.0);
    power = revolutions = 0.0;
    updateAll(0.0); 
  }
  
  void setPower(float power)
  {
    this.power = constrain(power, 0.0, 1.0);
  }
  
  void update(float deltaTime)
  {
    updateAll(deltaTime);
    force = kUP.scaledBy(traction);
    momentum = kUP.scaledBy(torsion).add(force.dotProduct(position));
  }
  
  void draw(Vector pos) // pos - in world coordinates
  {    
    float rmr = revolutions / maxRevolutions;
    float current_color = rmr + 10*(rmr - 0.5);
    if (current_color > 1.0) current_color = 1.0;
    float current_height=rmr*draw_size; 
    
    pushMatrix();
      translate(pos.x, pos.y, pos.z);
      fill(current_color,current_color,current_color,1.0);
      box(draw_size,current_height,draw_size);
      noFill();
    popMatrix();
  }  
}





class Copter extends InertialObject
{
  ArrayList<Engine> engines;
  public boolean _shouldStabilize;
  public boolean _shouldMove;
  public boolean _pointFlag;
  Vector _normal;
  Vector _destNormal; // Целевое направление нормали
  float deltaLever;
  
  Copter (float mass, Vector position, float ix, float iy, float iz,
          ArrayList<Engine> engines) 
  {
    super(mass, position, ix, iy, iz);
    this.engines = engines;
    
    _normal = new Vector(kUP);
    _destNormal = new Vector(kUP);
    
    deltaLever = 0;
    _pointFlag = true;
  }
  
  public void setMoveDirection(Vector direction)
  {
    _destNormal = new Vector (0, -1, 0);
    _destNormal.add(direction).normalize();
  }
  
  // Устанавливает прирощение силы движков для стабилизации поворота относительно destinationNormal. Предполагает, что значение силы на них (на всех) в текущий момент одинаково.
  // Предполагает, что нормаль актуальна на начало апдейта.
  void stabilize (float deltaTime)
  {
    if ( ! _shouldStabilize )
    {
      return;
    }
    
    Vector normalSpeed = angularSpeeds;
    Vector dNormal = _destNormal.subtracted(_normal);
    float sqrt2 = (float)Math.sqrt(2);
    
    Vector localEngine02axis = new Vector( sqrt2/2, 0, sqrt2/2 );
    Vector globalEngine02axis = (new Vector(localEngine02axis)).rotate(angles);
    Vector localEngine13axis = new Vector( -sqrt2/2, 0, sqrt2/2 );
    Vector globalEngine13axis = (new Vector(localEngine13axis)).rotate(angles);
    
    float dNormalProection02 = dNormal.scalarMultiply(globalEngine02axis);
    float dNormalProection13 = dNormal.scalarMultiply(globalEngine13axis);
    
    Vector localAngularSpeed = (new Vector(angularSpeeds)).rotate(angles.negatiated());
    float dSpeedProection02 = localAngularSpeed.scalarMultiply(localEngine02axis);
    float dSpeedProection13 = localAngularSpeed.scalarMultiply(localEngine13axis);
    //localAngularSpeed.print("LAS");
    //System.out.printf("%f   %f\n", dSpeedProection02, dSpeedProection13);
    
    //localAngularSpeed.rotate(0, 3.14 / 4, 0).rotate(angles);
    
    Vector level = new Vector(position);
    level.y -= dY[dInd%4]*gAmpl;
    //float scalar2 = _normal.x * cos(angles.x)+ _normal.y * cos(angles.y) + _normal.z * cos(angles.z);
    float scalar = angularSpeeds.x * _normal.x + angularSpeeds.y * _normal.y + angularSpeeds.z * _normal.z;
    float scalar2 = angles.x * _normal.x + angles.y * _normal.y + angles.z * _normal.z;
    
    //Vector Lvelocity = new Vector(velocity);
    
    float rot = 0;
    float kV = 0.3;
    //float kV = 0.0;
    float kR = 1.0; //!!!
    float kh = 0.001;
    float ky = 0.2;
    float ka = -0.01;
    float absAng = Math.abs(angularSpeeds.y);
    float highlevel = kh * level.y + ky * velocity.y;
    deltaLever = -0.1*scalar2 - 0.3*scalar;
    setEngineLever(0, engines.get(0).power + kR * dNormalProection02 + kV * dSpeedProection13 + highlevel + deltaLever);
    setEngineLever(2, engines.get(2).power - kR * dNormalProection02 - kV * dSpeedProection13 + highlevel + deltaLever);
    setEngineLever(1, engines.get(1).power + kR * dNormalProection13 - kV * dSpeedProection02 + highlevel - deltaLever);
    setEngineLever(3, engines.get(3).power - kR * dNormalProection13 + kV * dSpeedProection02 + highlevel - deltaLever);
    //System.out.printf("%f, %f\n", angularSpeeds.y, angles.y);
    //System.out.printf("%s = %8.4f %8.4f %8.4f\n", "name", dNormalProection02, dNormalProection13, 2.0);
    
  }
  
  void course ()
  {
    if ( ! _shouldMove ) return;
    float prec = 10.0;
    Vector destination = new Vector(dX[dInd%4]*gAmpl, 0, dZ[dInd%4]*gAmpl);
    Vector direction = destination.subtracted(position);
    direction.y = 0;
    if ( direction.length() + abs(position.y - dY[dInd%4]*gAmpl) < prec ) {
      ++dInd;
    }
    else {
      float k = 0.001;
      float v = -0.2;
      Vector course = new Vector(0, 0, 0);
      course.x = constrain(direction.x * k, -0.5, 0.5) + constrain(velocity.x*v, -0.5, 0.5);
      course.z = constrain(direction.z * k, -0.5, 0.5) + constrain(velocity.z*v, -0.5, 0.5);
      //System.out.printf("\n>> Direction: %f, Speed:%f\n", direction.x * k, velocity.x * v);
      //System.out.printf("Pos: %f, Course: %f\n", position.x, course.x);
      //course.print("Course");
      //direction.print("Direction");
      copter.setMoveDirection(course);
    }
  }
  
  void update (float deltaTime)
  {
    clean();
    stabilize(deltaTime);
    
    for (int i = 0; i < this.engines.size(); i++)
    {
      Engine e = this.engines.get(i);
      e.update(deltaTime);
      
      applyLocalForce(e.force);
      applyLocalMomentum(e.momentum);
      String str;
    }
    
    applyGravity();
    super.update(deltaTime);

    // Обновляем нормаль
    _normal = new Vector(0, -1, 0);
    _normal.rotate(angles);
  }
  
  void setEngineLever(int engineId, float position) {
    Engine engine = this.engines.get(engineId);
    engine.setPower(position);
  }
  
  
  void print(String name)
  {
    System.out.printf("Copter [%s]:\n", name);
    for (int i = 0; i < this.engines.size(); i++)
    {
      Engine e = this.engines.get(i);
      /*System.out.printf("  Engine # %u:, Lever position: %f, Forse: %f, Momentum: %f\n", 
                          String.valueOf(i), String.valueOf(e.leverPosition), String.valueOf(e.momentum));*/
    }
  } 
  
  /* draw helicopter with size and color specified */
  void drawCS(float size, float r, float g, float b)
  { 
    pushMatrix();
      translate(position.x, position.y, position.z); //Смещение фигуры в глобальной СК      
      //Поворот фигуры в глобальной СК

      rotateX(-angles.x);
      rotateY(-angles.y);
      rotateZ(-angles.z);
      //rotate(coordinateSystem);
          
      beginShape(QUADS);
        stroke(1.0,1.0,1.0, 1.0);
        fill(r,g,b,0.1);  
        vertex(-size/2,-size/4,-size/2);
        vertex(-size/2,size/4,-size/2);
        vertex(size/2,size/4,-size/2);
        vertex(size/2,-size/4,-size/2); //back
        
        vertex(-size/2,-size/4,size/2);
        vertex(-size/2,size/4,size/2);
        vertex(size/2,size/4,size/2);
        vertex(size/2,-size/4,size/2); //front
        
        vertex(-size/2, -size/4, -size/2);
        vertex(-size/2, -size/4, size/2);
        vertex(-size/2, size/4, size/2);
        vertex(-size/2, size/4, -size/2);//left
        
        vertex(size/2, -size/4, -size/2);
        vertex(size/2, -size/4, size/2);
        vertex(size/2, size/4, size/2);
        vertex(size/2, size/4, -size/2);//right
        
        vertex(-size/2, size/4, -size/2);
        vertex(-size/2, size/4, size/2);
        vertex(size/2, size/4, size/2);
        vertex(size/2, size/4, -size/2);//top
        
        vertex(-size/2, -size/4, -size/2);
        vertex(-size/2, -size/4, size/2);
        vertex(size/2, -size/4, size/2);
        vertex(size/2, -size/4, -size/2);//bottom    
      endShape();        
      
      noFill();
      
      /* engines drawing */
      //Координаты двигателей
      this.engines.get(0).draw(new Vector(-50,0,-50));
      this.engines.get(1).draw(new Vector(50,0,-50));
      this.engines.get(2).draw(new Vector(50,0,50));
      this.engines.get(3).draw(new Vector(-50,0,50));
/*
    popMatrix();
      rotateX(-angles.x);
      rotateY(-angles.y);
      rotateZ(-angles.z);
      
    pushMatrix();
*/    
    popMatrix();
    
    strokeWeight(2*gAmpl);
    fill(255, 255, 255);
    stroke(50, 50, 50);
    rectMode(CORNER);
    float tempK = 0.7;//1.55;
    rect(-viewWidth/2*tempK*gAmpl, -viewHeight/2*tempK*gAmpl, 200*tempK*gAmpl, 200*tempK*gAmpl);
    if (gStep == gStepCnt)
    {
      gX[gInd] = (-viewWidth/2 + 100) * tempK*gAmpl + position.x * 0.4;
      gY[gInd] = (-viewHeight/2 + 100) * tempK*gAmpl + position.z * 0.4;
      ++gInd; if (gInd == gCnt) gInd = 0; if (gShow < gCnt) ++gShow;
    }
    ++gStep; if (gStep > gStepCnt) gStep = 1;
    
    stroke(255, 0, 0);
    for (int i = 0; i < gShow; ++i) {
       if (i == gInd) ;
       else if (i == 0 && gShow == gCnt)
         line(gX[0], gY[0],gX[gCnt-1], gY[gCnt-1]);
       else if (i > 0)
         line(gX[i], gY[i],gX[i-1], gY[i-1]);
    }
    strokeWeight(5*gAmpl);
    stroke(0, 0, 255);
    point((-viewWidth/2 + 100) * tempK*gAmpl + dX[dInd%4]*gAmpl*0.4, (-viewHeight/2 + 100) * tempK*gAmpl + dZ[dInd%4]*gAmpl*0.4);
    strokeWeight(2);
  }	
  
  //Отрисовка верхней зеленой линии.//Переделаю под свою
  void drawUp(float size)
  {
    pushMatrix();
      translate(position.x, position.y, position.z);
      Vector localUp = new Vector(0.0, -1.0, 0.0);
      //Vector globalUp = (coordinateSystem.multiply(localUp)).scaleBy(size);
      Vector globalUp = new Vector(_normal);
      //Приводим размер вектора нормали к вектору g
      float l = 0;
      Vector normalized = new Vector(1.0, 1.0, 1.0);
      //l = (float)Math.sqrt((float)Math.pow((globalUp.x),2) + (float)Math.pow((globalUp.y),2) + (float)Math.pow((globalUp.z),2));
      normalized = globalUp.scaledBy(98);// / l);
      noFill();
      beginShape(LINES);
      //Нормаль
        stroke(0.0, 1.0, 0.0);
        vertex(0.0, 0.0, 0.0);
        vertex(normalized.x, normalized.y, normalized.z);
      //Вектор g пока взял как 98
        stroke(1.0, 0.0, 0.0);
        vertex(0.0, 0.0, 0.0);
        vertex(_destNormal.x*98, _destNormal.y*98, _destNormal.z*98);
        //vertex(0.0, -98, 0.0);
      //Разность между нормалью и вектором g
        stroke(1.0, 1.0, 1.0);
        
        vertex(normalized.x, normalized.y, normalized.z);
        vertex(_destNormal.x*98, _destNormal.y*98, _destNormal.z*98);
       //Разность между нормалью и вектором g смещенное к началу координат. 
        stroke(0.0, 1.0, 1.0);
        vertex(0.0, 0.0, 0.0);
        vertex((-normalized.x) * 3, (-98 - normalized.y) * 3  , (-normalized.z) * 3 );
        //compForce.add(-normalized.x, -98 -normalized.y, -normalized.z);
        compForce.x = -normalized.x;
        compForce.y = -98 -normalized.y;
        compForce.z = -normalized.z;
      endShape();
    popMatrix();    
  }

 public void WritetoFile(String str) {
   RandomAccessFile aFile;
        try{
            aFile=new RandomAccessFile("D:\\Myfile","rw");//открываем для чтения/записи
                aFile.seek(aFile.length());
                aFile.writeChars(str);
            }
        catch (Exception e){
            e.printStackTrace();
        }
  }
}

