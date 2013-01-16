class Engine
{ 
  
  /** position relative to the mass center*/
  Engine (Vector position, float maxTraction, float maxTorsion, float maxRevolutions, float revolutionDirection)
  { 
    this.maxTorsion = maxTorsion;//кручение
    this.maxTraction = maxTraction;//тяга
    this.maxRevolutions = maxRevolutions;//Обороты
    
    leverPosition = 0.0;//рычаг
    engineSpeedRevolutions = 0.0;
    this.position = position;
    
    _revolutionDirection = revolutionDirection > 0 ? 1.0 : -1.0 ; 
    this.size=50;
  }
  
  float size;
  float current_color;
  float current_height;
  /* drawing function for engine;
   * pos --- position in world coordinates
   */
   //Отрисовка самих двигателей
  void drawEN (Vector pos)
  {
    current_height=leverPosition*size;
    if (leverPosition > 0.5)
    {
      current_color=1.0;
    }
    else current_color=0.5;
    pushMatrix();
	  translate(pos.x, pos.y, pos.z);
      fill(current_color,current_color,current_color,1.0);
      box(size,current_height,size);
      noFill();
    popMatrix();
  }  
  
  float maxTorsion, maxTraction, maxRevolutions;
  float engineSpeedRevolutions;
  public float leverPosition;
  
  public Vector momentum;
  public Vector force;
  public Vector position;
  
  float _revolutionDirection;
  
  void update(float deltaTime)
  {
    engineSpeedRevolutions = leverPosition * maxRevolutions;
    
    final Vector up = new Vector(0.0, -1.0, 0.0);
    final Vector torsion = up.scaledBy(leverPosition * maxTorsion * _revolutionDirection);
    force = up.scaledBy(leverPosition * maxTraction);
        
    momentum = torsion.add(force.dotProduct(position));
    
    
  }
  
  void setLever(float newValue)
  {
    if (newValue >= 0.0 && newValue <= 1.0){
      leverPosition = newValue;
    } else if (newValue < 0.0) {
      leverPosition = 0.0;
    } else if (newValue > 1.0) {
      leverPosition = 1.0;
    }
  }
  
}
//END class ENGINE

class Copter extends InertialObject
{
  Copter (float mass, Vector position, float ix, float iy, float iz,
          ArrayList<Engine> engines) 
  {
    super(mass, position, ix, iy, iz);
    this.engines = engines;
    diff1 = new Vector(-50, 0, -50);
    diff2 = new Vector(50, 0, -50);
    diff3 = new Vector(50, 0, 50);
    diff4 = new Vector(-50, 0, 50);
  }
  
  ArrayList<Engine> engines;
  
  void update (float deltaTime)
  {
    for (int i = 0; i < this.engines.size(); i++)
    {
      Engine e = this.engines.get(i);
      e.update(deltaTime);
      
      applyLocalForce(e.force);
      applyLocalMomentum(e.momentum);
      //_print("Acceleration");
      //System.out.printf("%d%n", i);
      String str;
      //str = String.valueOf(String.format("%.2f", velocity.x) + ";" + String.format("%.2f", velocity.y) + ";" + String.format("%.2f", velocity.z) + "\n");
      //System.out.printf("velocity.x" + "\n" + "velocity.y" + "\n" + "velocity.z" + "\n");
      /*System.out.printf("\n%s = %8s %8s %8.4f %8.4f %8.4f %8.4f %8.4f %8.4f\n", j, i, System.currentTimeMillis(), appliedForce.x, 
      appliedForce.y, appliedForce.z, angularSpeeds.x, angularSpeeds.y, angularSpeeds.z);*/
      //System.out.printf("%8.4f %8.4f %8.4f\n", angles.x, angles.y, angles.z);
      //WritetoFile(str);
      j++;
      
    }
    
    applyGravity();
    super.update(deltaTime);
    //print("Copter");

  }
  
  void setEngineLever(int engineId, float position) {
    Engine engine = this.engines.get(engineId);
    engine.setLever(position);
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
          // Calculate diffs...
      Vector cnormal = new Vector(0, -50, 0);
      cnormal.rotate(angles);
      Vector gravity = new Vector(0, -50, 0);
      Vector diff = gravity.subtract(cnormal);
      diff1 = new Vector (-50, 0, -50);
      diff1.rotate(angles).subtract(diff);
      diff2 = new Vector (50, 0, -50);
      diff2.rotate(angles).subtract(diff);
      diff3 = new Vector (50, 0, 50);
      diff3.rotate(angles).subtract(diff);
      diff4 = new Vector (-50, 0, 50);
      diff4.rotate(angles).subtract(diff);
    pushMatrix();

    
      translate(position.x, position.y, position.z); //Смещение фигуры в глобальной СК      
                          beginShape(LINES);
      //Локальные координаты
      Vector angles2 = new Vector(angles.x, angles.y, angles.z);
      
        stroke(1.0, 0.0, 0.0);
        //angles.print("Angles");
        Vector offset = new Vector (0, -100, 0);
        //offset = coordinateSystem.multiply(offset);
        offset.rotate(angles2.x, angles2.y, angles2.z);
        // 1
        Vector v = new Vector(-50, 0, -50);
        //v = coordinateSystem.multiply(v);
        v.rotate(angles2.x, angles2.y, angles2.z);
        vertex(offset.x, offset.y, offset.z);
        vertex(v.x + offset.x, v.y + offset.y, v.z + offset.z);
        //v.print("My vector 1");
        // 2
        v = new Vector(50, 0, -50);
        //v = coordinateSystem.multiply(v);
        v.rotate(angles2.x, angles2.y, angles2.z);
        vertex(offset.x, offset.y, offset.z);
        vertex(v.x + offset.x, v.y + offset.y, v.z + offset.z);
        //v.print("My vector 2");
        // 3
        v = new Vector(-50, 0, 50);
        //v = coordinateSystem.multiply(v);
        v.rotate(angles2.x, angles2.y, angles2.z);
        vertex(offset.x, offset.y, offset.z);
        vertex(v.x + offset.x, v.y + offset.y, v.z + offset.z);
        //v.print("My vector 3");
        // 4
        v = new Vector(50, 0, 50);
        //v = coordinateSystem.multiply(v);
        v.rotate(angles2.x, angles2.y, angles2.z);
        vertex(offset.x, offset.y, offset.z);
        vertex(v.x + offset.x, v.y + offset.y, v.z + offset.z);
        //v.print("My vector 4");
      endShape();
      //Поворот фигуры в глобальной СК
      rotateX(-angles.x);
      rotateY(-angles.y);
      rotateZ(-angles.z);
      

      
      beginShape(QUADS);
        stroke(1.0,1.0,1.0, 1.0);
        fill(r,g,b,0.1);  
        vertex(-size/2,-size/2,-size/2);
        vertex(-size/2,size/2,-size/2);
        vertex(size/2,size/2,-size/2);
        vertex(size/2,-size/2,-size/2); //back
        
        vertex(-size/2,-size/2,size/2);
        vertex(-size/2,size/2,size/2);
        vertex(size/2,size/2,size/2);
        vertex(size/2,-size/2,size/2); //front
        
        vertex(-size/2, -size/2, -size/2);
        vertex(-size/2, -size/2, size/2);
        vertex(-size/2, size/2, size/2);
        vertex(-size/2, size/2, -size/2);//left
        
        vertex(size/2, -size/2, -size/2);
        vertex(size/2, -size/2, size/2);
        vertex(size/2, size/2, size/2);
        vertex(size/2, size/2, -size/2);//right
        
        vertex(-size/2, size/2, -size/2);
        vertex(-size/2, size/2, size/2);
        vertex(size/2, size/2, size/2);
        vertex(size/2, size/2, -size/2);//top
        
        vertex(-size/2, -size/2, -size/2);
        vertex(-size/2, -size/2, size/2);
        vertex(size/2, -size/2, size/2);
        vertex(size/2, -size/2, -size/2);//bottom
        
      endShape();
      

	  noFill();
      
	  /* engines drawing */
      //Координаты двигателей
      this.engines.get(0).drawEN(new Vector(-50,0,-50));
      this.engines.get(1).drawEN(new Vector(50,0,-50));
      this.engines.get(2).drawEN(new Vector(50,0,50));
      this.engines.get(3).drawEN(new Vector(-50,0,50));
      
      //compForce.print("Компенсация");
      //Разность между вектором компенсирующим и вектором от центра масс до двигателя
      engin0 = compForce.addFloat(-50 , 0, -50);
      engin1 = compForce.addFloat(50 , 0, -50);
      engin2 = compForce.addFloat(50 , 0, 50);
      engin3 = compForce.addFloat(-50 , 0, 50);
      
      //System.out.printf("\n%s = \n %8.4f %8.4f %8.4f %8.4f\n", "distance", engin0.length(), engin1.length(), engin2.length(), engin3.length());
        
      //stroke - ход(направление)
     /* beginShape(LINES);
        stroke(1.0, 0.0, 0.0);
        vertex(0.0, 0.0, 0.0);
        vertex(size, 0.0, 0.0); //Размер красной линии
        stroke(0.0, 1.0, 0.0);
        vertex(0.0, 0.0, 0.0);
        vertex(0.0, size, 0.0);//Размер зеленой снизу
        stroke(0.0, 0.0, 1.0);
        vertex(0.0, 0.0, 0.0);
        vertex(0.0, 0.0, size);//Размер синей линии

      endShape();*/
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

//LOG.info("Hello, world");

	
int j = 0;	
public Vector CompVecGlob;
public Vector engin0;
public Vector engin1;
public Vector engin2;
public Vector engin3;
public Vector diff;
public Vector diff1;
public Vector diff2;
public Vector diff3;
public Vector diff4;
}

