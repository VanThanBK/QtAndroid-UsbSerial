#ifndef CALIBRATIONCONTROL_H
#define CALIBRATIONCONTROL_H

#include <QObject>
#include "devicemanager.h"
#include "deviceport.h"
#include "robotparameter.h"
#include "DeltaKinematics.h"
#include <QTimer>
#include <QDebug>

class CalibrationControl : public QObject
{
    Q_OBJECT
public:
    explicit CalibrationControl(QObject *parent = nullptr);
    DeviceManager *d_device;
    DevicePort *deltax_port;
    DevicePort *tester_port;

    RobotParameter *robot_parameter;
    DeltaKinematicsClass deltaxs_kinematic;

    void addDevice(DeviceManager *_device);
    void addRobotParameter(RobotParameter *_robot_parameter);

public slots:
    void forwardKinematic(float _t1, float _t2, float _t3);
    void inverseKinematic(float _x, float _y, float _z);
    void setNewHomePosition(float _x, float _y, float _z);
    void homeRobot();
    void moveAPoint(float _radius, float _zdown);
    void moveBPoint(float _radius, float _zdown);
    void moveCPoint(float _radius, float _zdown);
    void moveCenterPoint(float _zdown);
    void setNewStepPer2Pi(float _radius, float _a, float _b, float _c);
    void readErrorAngle();
    void stopReadErrorAngle();

private:
    void addNumberOkFeedback(int _number);
    uint16_t need_response_number_ok;
    bool is_have_add_new_ok;
    void checkOkReponse();
    void getRobotErrorAngleFromString(QString r_string);
    QTimer countdown_timer;
    QTimer auto_error_timer;


private slots:
    void countdown_timer_timeout();
    void auto_read_error_timeout();

    void loaded_robot_parameter();
    void robot_ready_read(QString r_string);

signals:
    void updatedAngleCal(float _t1, float _t2, float _t3);
    void updatedPointCal(float _x, float _y, float _z);
    void newNotification(bool _is_done, QString _noti);

    void updateErrorAngle(float _t1, float _t2, float _t3);
};

#endif // CALIBRATIONCONTROL_H
