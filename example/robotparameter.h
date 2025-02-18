#ifndef ROBOTPARAMETER_H
#define ROBOTPARAMETER_H

#include <QObject>
#include "devicemanager.h"
#include "deviceport.h"
#include <QTimer>
#include <QDebug>

struct Robot_Geometry{
    float of;
    float f;
    float e;
    float rf;
    float re;
    float z;
    float d;
};

struct Robot_Angle{
    float t1;
    float t2;
    float t3;
};

struct Robot_Step{
    uint16_t t1;
    uint16_t t2;
    uint16_t t3;
};

struct Axis_Infor{
//    Q_GADGET
//public:
    bool is_define = false;
    bool is_endstop_enable = true;
    bool is_endstop_invert = true;
    float home_speed = 30.0f;
    float home_revert = 20.0f;
    float steps_per_unit = 8.33333333f;
    float max_position = 178.0f;
    float min_position = -182.0f;
    float home_position = 0;
    float max_acc = 150000;
    float max_jer = 5000000;
    float max_vel = 2000.0f;
//    Q_PROPERTY(bool is_define MEMBER is_define)
//    Q_PROPERTY(bool is_endstop_enable MEMBER is_endstop_enable)
//    Q_PROPERTY(bool is_endstop_invert MEMBER is_endstop_invert)
//    Q_PROPERTY(float home_speed MEMBER home_speed)
//    Q_PROPERTY(float home_revert MEMBER home_revert)
//    Q_PROPERTY(float steps_per_unit MEMBER steps_per_unit)
//    Q_PROPERTY(float max_position MEMBER max_position)
//    Q_PROPERTY(float min_position MEMBER min_position)
//    Q_PROPERTY(float home_position MEMBER home_position)
//    Q_PROPERTY(float max_acc MEMBER max_acc)
//    Q_PROPERTY(float max_jer MEMBER max_jer)
//    Q_PROPERTY(float max_vel MEMBER max_vel)
    void addToList(QList<bool> &_list_bool){
        _list_bool.append(is_define);
        _list_bool.append(is_endstop_enable);
        _list_bool.append(is_endstop_invert);
    }
    void addToList(QList<float> &_list_float){
        _list_float.append(home_speed);
        _list_float.append(home_revert);
        _list_float.append(steps_per_unit);
        _list_float.append(max_position);
        _list_float.append(min_position);
        _list_float.append(home_position);
        _list_float.append(max_acc);
        _list_float.append(max_jer);
        _list_float.append(max_vel);
    }
    void getFromList(QList<bool> &_list_bool)
    {
        is_define = _list_bool[0];
        is_endstop_enable = _list_bool[1];
        is_endstop_invert = _list_bool[2];
    }
    void getFromList(QList<float> &_list_float)
    {
        home_speed = _list_float[0];
        home_revert = _list_float[1];
        steps_per_unit = _list_float[2];
        max_position = _list_float[3];
        min_position = _list_float[4];
        home_position = _list_float[5];
        max_acc = _list_float[6];
        max_jer = _list_float[7];
        max_vel = _list_float[8];
    }
};

class RobotParameter : public QObject
{
    Q_OBJECT

public:
    explicit RobotParameter(QObject *parent = nullptr);
    DeviceManager *d_device;
    DevicePort *deltax_port;
    void addDevice(DeviceManager *_device);

    Robot_Geometry robotParameter();
    Robot_Step robotStepPer2Pi();
    void changedHomeAngle(float _t1, float _t2, float _t3);
    void changedStepPer2Pi(uint16_t _t1, uint16_t _t2, uint16_t _t3);

    bool is_loaded;

public slots:
    bool getRobotInfor();
    void setRobotModel(uint8_t _robot_version, uint16_t _robot_size, uint8_t _robot_axis);
    void setRobotImei(QString _robot_imei);
    void uploadInforToRobot();

    bool getRobotParameter();
    void setRobotGeometry(float _of, float _f, float _e, float _rf, float _re);
    void setRobotMaxSize(float _z, float _d);
    void setRobotHomeAngle(float _t1, float _t2, float _t3);
    void setRobotStepPer2Pi(uint16_t _t1, uint16_t _t2, uint16_t _t3);
    void setRobotAxis4Infor(QList<bool> _list_bool, QList<float> _list_float);
    void setRobotAxis5Infor(QList<bool> _list_bool, QList<float> _list_float);
    void setRobotAxis6Infor(QList<bool> _list_bool, QList<float> _list_float);
    void uploadParameterToRobot();

    void getRobotSuggestions(uint8_t _robot_version, uint16_t _robot_size, uint8_t _robot_axis);


    void createSuggestions();
private:
    uint16_t robot_size;
    QString robot_imei;
    uint8_t robot_axis;
    uint8_t robot_version;

    Robot_Geometry geometry;
    Robot_Angle home_angle;
    Robot_Step step_per_2pi;

    Robot_Geometry suggestions_geometry_d400;
    Robot_Geometry suggestions_geometry_d600;
    Robot_Geometry suggestions_geometry_d800;

    Robot_Step suggestions_step_per_2pi;
    Robot_Angle suggestions_home_angle;

    Axis_Infor axis4_infor;
    Axis_Infor axis5_infor;
    Axis_Infor axis6_infor;

    Axis_Infor suggestions_axis4_infor;
    Axis_Infor suggestions_axis5_infor;
    Axis_Infor suggestions_axis6_infor;

    void getRobotInforFromString(QString r_string);
    void getRobotImeiFromString(QString r_string);
    void getRobotGeometryFromString(QString r_string);
    void getRobotHomeAngleFromString(QString r_string);
    void getRobotStepPer2PiFromString(QString r_string);
    void getAxis4InforFormString(QString r_string);
    void getAxis5InforFormString(QString r_string);
    void getAxis6InforFormString(QString r_string);

    void addNumberOkFeedback(int _number);
    uint16_t need_response_number_ok;
    bool is_have_add_new_ok;
    void checkOkReponse();
    QTimer countdown_timer;

private slots:
    void countdown_timer_timeout();

    void robot_ready_read(QString r_string);
    void robot_connect_handle(bool is_connected);

signals:

    void updatedRobotModel(uint8_t _robot_version, uint16_t _robot_size, uint8_t _robot_axis);
    void updatedRobotImei(QString _robot_imei);
    void updatedRobotGeometry(float _of, float _f, float _e, float _rf, float _re);
    void updatedRobotMaxSize(float _z, float _d);
    void updatedRobotHomeAngle(float _t1, float _t2, float _t3);
    void updatedRobotStepPer2Pi(uint16_t _t1, uint16_t _t2, uint16_t _t3);
    void updatedRobotAxis4Infor(QList<bool> _list_bool, QList<float> _list_float);
    void updatedRobotAxis5Infor(QList<bool> _list_bool, QList<float> _list_float);
    void updatedRobotAxis6Infor(QList<bool> _list_bool, QList<float> _list_float);
    void loadedRobotParameter();
    void newNotification(bool _is_done, QString _noti);

    void waitOkFeedbackDone(bool _is_done, QString _noti);
};

#endif // ROBOTPARAMETER_H
