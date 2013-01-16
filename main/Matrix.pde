class Matrix
{
           float _a, _b, _c,
                 _e, _f, _g,
                 _i, _j, _k;

   Matrix()
   {
     _a = 1.0; _b = 0.0; _c = 0.0;
     _e = 0.0; _f = 1.0; _g = 0.0;
     _i = 0.0; _j = 0.0; _k = 1.0;
   }
   
   Matrix (float a, float b, float c, 
           float e, float f, float g, 
           float i, float j, float k)
   {
     _a = a;
     _b = b;
     _c = c;
     _e = e;
     _f = f;
     _g = g;
     _i = i;
     _j = j;
     _k = k;
   } 
   
   public Vector multiply(Vector v)
   {
     Vector result = new Vector(
     _a * v.x + _b * v.y + _c * v.z,
     _e * v.x + _f * v.y + _g * v.z,
     _i * v.x + _j * v.y + _k * v.z);
     return result;
   }
   
   public Matrix transposed()
   {
      float a, b, c, 
           e, f, g, 
           i, j, k;
     a = _a;
     b = _b;
     c = _c;
     e = _e;
     f = _f;
     g = _g;
     i = _i;
     j = _j;
     k = _k;
     return new Matrix(a, e, i, b, f, j, c, g, k);
   }
   
  /* public Matrix transpose()
   {
     float a, b, c, 
           e, f, g, 
           i, j, k;
     a = _a;
     b = _b;
     c = _c;
     e = _e;
     f = _f;
     g = _g;
     i = _i;
     j = _j;
     k = _k;
     
     _a = a;
     _b = e;
     _c = i;
     _e = b;
     _f = f;
     _g = j;
     _i = c;
     _j = g;
     _k = k;
     return this;
   }*/
   
   
   
   public void multiply(Vector v, Vector result)
  {
    result.x = _a * v.x + _b * v.y + _c * v.z;
    result.y = _e * v.x + _f * v.y + _g * v.z;
    result.z =  _i * v.x + _j * v.y + _k * v.z;
  }
  
  //todo: rename method as in Vector
  public void multiplyBy(Matrix m)
  {          
    final float _a1 = _a * m._a + _b * m._e + _c * m._i;
    final float _b1 = _a * m._b + _b * m._f + _c * m._j;
    final float _c1 = _a * m._c + _b * m._g + _c * m._k;
   
    final float _e1 = _e * m._a + _f * m._e + _g * m._i;
    final float _f1 = _e * m._b + _f * m._f + _g * m._j;
    final float _g1 = _e * m._c + _f * m._g + _g * m._k;
   
    final float _i1 = _i * m._a + _j * m._e + _k * m._i;
    final float _j1 = _i * m._b + _j * m._f + _k * m._j;
    final float _k1 = _i * m._c + _j * m._g + _k * m._k;
   
    _a = _a1; _b = _b1; _c = _c1;
    _e = _e1; _f = _f1; _g = _g1;
    _i = _i1; _j = _j1; _k = _k1;
  }
  
  public void rotationX(float angle)
  {
    final float cosine = (float) Math.cos(angle);
    final float sine = (float) Math.sin(angle);
    
    _a = 1.0;    _b = 0.0;      _c = 0.0; 
    _e = 0.0;    _f = cosine;   _g = sine;
    _i = 0.0;    _j = -sine;    _k = cosine;
  }
  
  public void rotationY(float angle)
  {
    final float cosine = (float) Math.cos(angle);
    final float sine = (float) Math.sin(angle);
    
    _a = cosine;  _b = 0.0;     _c = -sine; 
    _e = 0.0;     _f = 1.0;     _g = 0.0;
    _i = sine;    _j = 0.0;     _k = cosine;
  }
  
  public void rotationZ(float angle)
  {
    final float cosine = (float) Math.cos(angle);
    final float sine = (float) Math.sin(angle);
    
    _a = cosine;  _b = sine;    _c = 0.0; 
    _e = -sine;   _f = cosine;  _g = 0.0;
    _i = 0.0;     _j = 0.0;     _k = 1.0;
  }
  
  public void print(String name)
  {
    System.out.printf("\n%s = \n %8.4f %8.4f %8.4f\n %8.4f %8.4f %8.4f\n %8.4f %8.4f %8.4f\n", name, _a, _b, _c, _e, _f, _g, _i, _j, _k);
  }
 }

