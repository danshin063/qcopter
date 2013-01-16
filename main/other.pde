  //Calculate torques// Как написано в книжке. Пока нигде не используется >>>>>>>>>>
  /*
  void CountT()
  {
    final float Kyd = 0;
    final float KyP = 1;
    final float g = 9.81;
    float Ydp = 0;
    float Yp = angularSpeeds.y;
    float Yd = 0;
    float Y = 0; 
    T = ( g + Kyd * ( Ydp - Yp ) + KyP * ( Yd - Y )) * mass / ((float)Math.cos(angles.x) * (float)Math.cos(angles.z));
  }
  
  void CounttPhi()
  {
    final float KphiD = 1;
    final float KphiP = 1;
    final float phipd = 0;
    final float phip = velocity.x;
    final float phid = 0;
    final float phi = angles.x;
    tphi = (KphiD * (phipd - phi) + KphiP * (phid - phi)) * inertiaMatrix._a;
  }
  
  void CounttTeta()
  {
    final float KtetaD = 1;
    final float KtetaP = 1;
    final float tetapd = 0;
    final float tetap = velocity.z;
    final float tetad = 0;
    final float teta = angles.z;
    tteta = (KtetaD * (tetapd - teta) + KtetaP * (tetad - teta)) * inertiaMatrix._k;
  }
  
  void CounttPsy()
  {
    final float KpsyD = 1;
    final float KpsyP = 1;
    final float psypd = 0;
    final float psyp = velocity.y;
    final float psyd = 0;
    final float psy = angles.y;
    tpsy = (KpsyD * (psypd - psy) + KpsyP * (psyd - psy)) * inertiaMatrix._f;
  }
  */
    //<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<
