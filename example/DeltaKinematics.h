// DeltaKinematics.h

#ifndef _DELTAKINEMATICS_h
#define _DELTAKINEMATICS_h

#define pow2(x) (x*x)
#include <cmath>

#define DEG_TO_RAD 0.017453292519943295769236907684886
#define RAD_TO_DEG 57.295779513082320876798154814105

struct Angle
{
public:
    float theta1;
    float theta2;
    float theta3;
};

class Point
{
public:
    float x;
    float y;
    float z;
};

class DeltaKinematicsClass
{
 protected:


 public:
	void init();
	bool recalculateForwardKinematics(Angle angleposition, Point &point);
	bool recalculateInverseKinematics(Point point, Angle &angleposition);
    void setParameter(float _of, float _f, float _e, float _rf, float _re);

private:
	bool recalculateAngleTheta(float x0, float y0, float z0, float &theta);
};

#endif

