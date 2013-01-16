public class Vector
{
  Vector ()
  {
    x = 0.0;
    y = 0.0;
    z = 0.0;
  }
  
  Vector (Vector v)
  {
    this.x = v.x;
    this.y = v.y;
    this.z = v.z;
  }
  
  Vector (float x, float y, float z)
  {
    this.x = x;
    this.y = y;
    this.z = z;
  }
  
  public Vector scaledBy(float value)
  {
    return new Vector(x * value, y * value, z * value);
  }
  
  public Vector divisionedBy(float value)
  {
    return new Vector(x / value, y / value, z / value);
  }
  
  // Умножение двух векторов построчно
  public Vector multiply(Vector v)
  {
    this.x = this.x * v.x;
    this.y = this.y * v.y;
    this.z = this.z * v.z;
    return this;
  }
  
  public float scalarMultiply(Vector v)
  {
    float result = x*v.x + y*v.y + z*v.z;
    return result;
  }
  
  public Vector scaleBy(float value)
  {
    x = x * value;
    y = y * value;
    z = z * value;
    return this;
  }
  
  public Vector divisioneBy(float value)
  {
    x = x / value;
    y = y / value;
    z = z / value;
    return this;
  }
   
  public float length()
  {
    return (float) Math.sqrt(x*x + y*y + z*z);          
  }
  
  public Vector negatiated()
  {
    Vector result = new Vector (-this.x, -this.y, -this.z);
    return result;
  }
  
  public Vector negatiate()
  {
    x = -x;
    y = -y;
    z = -z;
    return this;
  }
  
  public Vector normalized()
  {
    float l = length();
    return new Vector(x / l, y / l, z / l);                
  }
  
  public Vector normalize()
  {
    float l = length();
    x /= l;
    y /= l;
    z /= l;
    return this;
  }
  
  public Vector multiplied(Matrix m)
  {
    Vector result = new Vector();
    result.x = x * m._a + y * m._e + z * m._i;
    result.y = x * m._b + y * m._f + z * m._g;
    result.z = x * m._c + y * m._j + z * m._k;              
    return result;
  }
  
  public Vector subtract(Vector v)
  {
    x = x - v.x;
    y = y - v.y;
    z = z - v.z;
    return this;
  }
  
  public Vector add (Vector v)
  {
    x = x + v.x;
    y = y + v.y;
    z = z + v.z;
    return this;
  }
  
/*  public Vector addFloat (float a, float b, float c)
  {
    return new Vector(x + a, y + b, z + c);
  }*/
  
  public Vector subtracted(Vector v)
  {
    return new Vector(x - v.x, y - v.y, z - v.z);
  }
  
  public Vector dotProduct(Vector v)
  {
    return new Matrix(0.0,   -z,   y,
                 z,  0.0,  -x,
                -y,    x,  0.0).multiply (v);              
  }
  
  public void print (String name)
  {
    System.out.printf("%s = %8.4f %8.4f %8.4f\n", name, x, y, z);
  }
  
  public Vector rotate (float x, float y, float z)
  {
    Matrix mx = new Matrix(); 
    mx.rotationX(x);
    
    Matrix my = new Matrix();
    my.rotationY(y);
    
    Matrix mz = new Matrix();
    mz.rotationZ(z);
   
    mx.multiplyBy(my);
    mx.multiplyBy(mz);

    Vector result = new Vector(this);
    result = mx.multiply(result);
    this.x = result.x;
    this.y = result.y;
    this.z = result.z;
    return this;
  }
  
  public Vector rotate (Vector angles)
  {
    return this.rotate(angles.x, angles.y, angles.z);
  }
  
  public float x, y, z;  
}

