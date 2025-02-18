#ifndef MOVEMENTCHECKER_H
#define MOVEMENTCHECKER_H

#include <QObject>
#include "devicemanager.h"
#include "deviceport.h"
#include <QDebug>

struct Scurve_Point
{
    float p;
    float v;
    float a;
    float j;
    float t;
};

class MovementChecker : public QObject
{
    Q_OBJECT
public:
    explicit MovementChecker(QObject *parent = nullptr);

    DeviceManager *d_device;
    DevicePort *deltax_port;
    DevicePort *calib_port;
    void addDevice(DeviceManager *_device);

public slots:
    bool turnOnDesireScurve(float _sample);
    bool turnOffDesireScurve();
    void clearDesireScurveArray();
    void reloadDesireScurve();

    bool sendGcodeToRobot(QString _gcode);

private:
    QList<Scurve_Point> desire_scurve_array;
    QList<Scurve_Point> real_scurve_array;

    float robot_scurve_time_tick;

private slots:
    void robot_ready_read(QString r_string);

signals:
    void addNewDesireScurveData(float _p, float _v, float _a, float _j, float _t);
    void updateDataToRobotTermite(QString _data);
};

#endif // MOVEMENTCHECKER_H
