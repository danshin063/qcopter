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
    lineAcceleration = new Vector();
    angularAcceleration = new Vector();
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
    
    localMomentum = new Vector();    
    localForce = new Vector();
    appliedMomentum = new Vector();
  }
  
  void applyLocalForce(Vector force)
  {
    localForce.add(force);
  }
  
  void update(float deltaTime)
  {
    updateCS();
    
    //lineAcceleration = new Vector();
    lineAcceleration.add(appliedForce.divisioneBy(mass));
    lineAcceleration.add(coordinateSystem.multiply(localForce).divisioneBy(mass));
    velocity.add(lineAcceleration.scaleBy(deltaTime));
    if (velocity.length() < 0.001) { //to prevent sliding
      velocity.x = 0.0;
      velocity.y = 0.0;
      velocity.z = 0.0;
    }
    position.add(velocity);
    
    /*angularSpeeds.add((appliedMomentum.multiplied(inertiaMatrix)).scaledBy(deltaTime));
    angularSpeeds.add(((coordinateSystem.multiply(localMomentum)).multiplied(inertiaMatrix)).scaleBy(deltaTime));
    angularAcceleration = angularSpeeds.divisionedBy(deltaTime);
    angles.add(angularSpeeds.scaledBy(deltaTime));*/
    //angularAcceleration = new Vector();
    angularAcceleration.add(appliedMomentum.multiplied(inertiaMatrix));
    angularAcceleration.add((coordinateSystem.multiply(localMomentum)).multiplied(inertiaMatrix));
    angularSpeeds.add(angularAcceleration.scaleBy(deltaTime));
    angles.add(angularSpeeds.scaledBy(deltaTime));
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
    
    
    mz.multiplyBy(my);
    mz.multiplyBy(mx);
    
    coordinateSystem = mz;
    //coordinateSystem.print("CS");
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

