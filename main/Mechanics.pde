class MassPoint
{
  MassPoint(float mass, Vector position)
  {
    this.mass = mass;
    this.position = position;
    velocity = new Vector(0.0, 0.0, 0.0);
    appliedForce = new Vector(0.0, 0.0, 0.0);
  }
  
  void clean()
  {
    appliedForce.x = 0.0;
    appliedForce.y = 0.0;
    appliedForce.z = 0.0;
  }
  
  void update(float deltaTime)
  {
    //position.add(velocity.add(appliedForce.scaleBy(deltaTime * deltaTime / mass)));  
      position.add((velocity.add(appliedForce.scaleBy(deltaTime / mass)).scaleBy(deltaTime))); 
  }
  
  void applyForce(Vector force)  
  {
    appliedForce.add(force);
  }
  
  void applyGravity(Vector down) 
  {
    final float g = 9.81; 
    applyForce(down.scaledBy(mass*g)); 
  }
  
  float mass;
  public Vector position, velocity, appliedForce;
}
//END OF MASS POINT


class InertialObject extends MassPoint
{
  InertialObject(float mass, Vector position, float ix, float iy, float iz)
  {
    super(mass, position);
    inertiaMatrix = new Matrix(1.0 / ix, 0.0, 0.0,
                               0.0, 1.0 / iy, 0.0,
                               0.0, 0.0, 1.0 / iz);                         
    angles = new Vector();
    angularSpeeds = new Vector();
    localMomentum = new Vector();
    appliedMomentum = new Vector();
    localForce = new Vector();
    //компенсирующая сила
    compForce = new Vector();
    FFangaccel = new Filter(0.0, 0.00001, NullVector, 1.0);
    FFlineaccel = new Filter(0.0, 3.0, NullVector, 30.0);
  }
  
  void clean()
  {
    super.clean();
    
    localMomentum.x = 0.0;
    localMomentum.y = 0.0;
    localMomentum.z = 0.0;
    
    localForce.x = 0.0;
    localForce.y = 0.0;
    localForce.z = 0.0;
    
    appliedMomentum.x = 0.0;
    appliedMomentum.y = 0.0;
    appliedMomentum.z = 0.0;
  }
  
  void applyLocalForce(Vector force) // force in global CS
  {
    localForce.add(force);
  }
  
  void update(float deltaTime)
  {
    updateCS();

    //velocity.add(appliedForce.scaleBy(deltaTime * deltaTime / mass));
    //Fspeed.update(velocity.x);
    //velocity.x=Fspeed.x;
    velocity.add(appliedForce.scaleBy(deltaTime / mass));
    //compForce = appliedForce.
    //velocity.add((coordinateSystem.multiply(localForce)).scaleBy(deltaTime * deltaTime / mass));
    velocity.add((coordinateSystem.multiply(localForce)).scaleBy(deltaTime / mass));
    lineAcceleration = velocity.divisionedBy(deltaTime);
    //lineAcceleration.print("Line");
    if (velocity.length() < 0.001) { //to prevent sliding
      velocity.x = 0.0;
      velocity.y = 0.0;
      velocity.z = 0.0;
    }
    FlineAcceleration = FFlineaccel.update(lineAcceleration);
    //velocity.divisionedBy(deltaTime).print("Acceleration");
    position.add(velocity);
    //Либо inertial либо reverse matrix
    angularSpeeds.add((appliedMomentum.multiplied(inertiaMatrix)).scaledBy(deltaTime));
    angularSpeeds.add(((coordinateSystem.multiply(localMomentum)).multiplied(inertiaMatrix)).scaleBy(deltaTime));
    angles.add(angularSpeeds.scaledBy(deltaTime));
    angularAcceleration = angularSpeeds.divisionedBy(deltaTime);
    //FFaccel.update(angularAcceleration);
    FangularAcceleration = FFangaccel.update(angularAcceleration);
    //angularAcceleration.print("Not");
    //FangularAcceleration.print("Kalman");
  }


  
  void applyLocalMomentum(Vector momentum)
  {
    localMomentum.add(momentum);
  }
 
  void applyMomentum(Vector momentum)
  {
    appliedMomentum.add(momentum);
  }
  
///////////////////////////////////
//Отрисовка верхней зеленой линии.//Переделаю под свою
  void drawUp(float size)
  {
    pushMatrix();
      translate(position.x, position.y, position.z);
      Vector localUp = new Vector(0.0, -1.0, 0.0);
      Vector globalUp = (coordinateSystem.multiply(localUp)).scaleBy(size);
      //Приводим размер вектора нормали к вектору g
      float l = 0;
      Vector normalized = new Vector(1.0, 1.0, 1.0);
      l = (float)Math.sqrt((float)Math.pow((globalUp.x),2) + (float)Math.pow((globalUp.y),2) + (float)Math.pow((globalUp.z),2));
      normalized = globalUp.scaledBy(98 / l);
      noFill();
      beginShape(LINES);
      //Нормаль
        stroke(0.0, 1.0, 0.0);
        vertex(0.0, 0.0, 0.0);
        vertex(normalized.x, normalized.y, normalized.z);
      //Вектор g пока взял как 98
        stroke(1.0, 0.0, 0.0);
        vertex(0.0, 0.0, 0.0);
        vertex(0.0, -98, 0.0);
      //Разность между нормалью и вектором g
        stroke(1.0, 1.0, 1.0);
        vertex(normalized.x, normalized.y, normalized.z);
        vertex(0.0, -98  , 0.0);
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
///////////////////////////////////

  void applyGravity()
  {
    final float g = 9.81; 
    applyForce((new Vector(0.0, 1.0, 0.0)).scaleBy(mass * g));
  }

  void updateCS()
  {
    Matrix mx = new Matrix(); 
    mx.rotationX(angles.x);
    
    Matrix my = new Matrix();
    my.rotationY(angles.y);
    
    Matrix mz = new Matrix();
    mz.rotationZ(angles.z);
    
    
    mx.multiplyBy(my);
    mx.multiplyBy(mz);
    
    coordinateSystem = mx; 
  }
  
  Matrix coordinateSystem, inertiaMatrix, reverseMatrix;
  
  public Vector angularSpeeds, angles, angularAcceleration, lineAcceleration;
  public Vector FangularAcceleration = new Vector(0.0, 0.0 ,0.0), FlineAcceleration = new Vector(0.0 ,0.0, 0.0), NullVector = new Vector(0.0 ,0.0, 0.0);
  public Filter FFangaccel,FFlineaccel;
  //Filter Fspeed;
  // resulting forces and momentums applied in this integration step (frame) to inertial mass object
  public Vector localForce;    //force in local e;
  //public Vector appliedForce; // (inherited) force in global CS
  public Vector localMomentum; // momentum in local CS
  public Vector appliedMomentum; // momentum in global CS
  public Vector compForce;  
  public float T;
  public float tphi;
  public float tteta;
  public float tpsy;
  
}

