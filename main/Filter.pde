class Filter
{
  Filter(float q, float R, Vector measure, float Pk)
  {
    this.q = q;
    this.R = R;
    this.measure = measure;
    this.Pk = Pk;
    float Kk = 0;
    Vector X = new Vector(0.0, 0.0 ,0.0);   
  }
  
  Vector update(Vector measure)
  {
     Pk = Pk + q;
     Kk = Pk / (Pk + R);
     //measure.print("X");
     //System.out.printf("%s = %8.4f\n", "K", Kk);
     X = X.add(measure.subtract(X).scaledBy(Kk));
     Pk = (1 - Kk) * Pk;
     return X;
  }
  
  float q, R, Pk, Kk;
  Vector measure, X = new Vector(0.0, 0.0 ,0.0);
}
//try initial P not null
//q process noise covariance (труднее всего подобрать)
//R measurement noise covariance (погрешность приборов)
//X value 
//Pk estimation error covariance
//Kk kalman gain
/*
class Filter
{
  Filter(float q, float r, float measure, float p, float k)
  {
    this.q = q;
    this.r = r;
    this.measure = measure;
    this.p = p;
    float x = 0;    
  }
  
  void update(float measure)
  {
     p = p + q;
     k = p / (p + r);
     x = x + k * (measure - x);
     p = (1 - k) * p;
  }
  
  float q, r, measure, p, k, x;
}*/

