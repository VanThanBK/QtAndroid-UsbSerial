#include "calibrationcontrol.h"

CalibrationControl::CalibrationControl(QObject *parent)
    : QObject{parent}
{

}

void CalibrationControl::addDevice(DeviceManager *_device)
{
    d_device = _device;

    deltax_port = d_device->robot_device;
    tester_port = d_device->test_device;

    need_response_number_ok = 0;
    is_have_add_new_ok = false;

    connect(deltax_port, &DevicePort::readyReadData, this, &CalibrationControl::robot_ready_read);
    connect(&countdown_timer, &QTimer::timeout, this, &CalibrationControl::countdown_timer_timeout);
    connect(&auto_error_timer, &QTimer::timeout, this, &CalibrationControl::auto_read_error_timeout);
}

void CalibrationControl::addRobotParameter(RobotParameter *_robot_parameter)
{
    robot_parameter = _robot_parameter;
    deltaxs_kinematic.init();

    connect(robot_parameter, &RobotParameter::loadedRobotParameter, this, &CalibrationControl::loaded_robot_parameter);
}

void CalibrationControl::forwardKinematic(float _t1, float _t2, float _t3)
{
    if (robot_parameter->is_loaded == false)
    {
        emit newNotification(false, "Error: Need load parameter!");
        return;
    }

    Angle new_angle;
    new_angle.theta1 = _t1;
    new_angle.theta2 = _t2;
    new_angle.theta3 = _t3;

    Point new_point;

    if (deltaxs_kinematic.recalculateForwardKinematics(new_angle, new_point))
    {
        emit updatedPointCal(new_point.x, new_point.y, new_point.z);
    }
    else
    {
        emit newNotification(false, "Error: Calculate Kinematic Fail!");
    }
}

void CalibrationControl::inverseKinematic(float _x, float _y, float _z)
{
    if (robot_parameter->is_loaded == false)
    {
        emit newNotification(false, "Error: Need load parameter!");
        return;
    }

    Point new_point;
    new_point.x = _x;
    new_point.y = _y;
    new_point.z = _z;

    Angle new_angle;

    if (deltaxs_kinematic.recalculateInverseKinematics(new_point, new_angle))
    {
        emit updatedAngleCal(new_angle.theta1, new_angle.theta2, new_angle.theta3);
    }
    else
    {
        emit newNotification(false, "Error: Calculate Kinematic Fail!");
    }
}

void CalibrationControl::readErrorAngle()
{
    auto_error_timer.start(400);
}

void CalibrationControl::stopReadErrorAngle()
{
    auto_error_timer.stop();
}

void CalibrationControl::setNewHomePosition(float _x, float _y, float _z)
{
    if (!deltax_port->isConnected())
    {
        emit newNotification(false, "Error: Robot disconnect!");
        return;
    }

    if (robot_parameter->is_loaded == false)
    {
        emit newNotification(false, "Error: Need load parameter!");
        return;
    }

    Point new_point;
    new_point.x = _x;
    new_point.y = _y;
    new_point.z = _z;

    Angle new_angle;

    if (deltaxs_kinematic.recalculateInverseKinematics(new_point, new_angle))
    {
        QString new_robot_para = "M609 P1144 A";
        new_robot_para += QString::number(new_angle.theta1);
        new_robot_para += " B";
        new_robot_para += QString::number(new_angle.theta2);
        new_robot_para += " C";
        new_robot_para += QString::number(new_angle.theta3);
        new_robot_para += "\n";
        deltax_port->write(new_robot_para);
        addNumberOkFeedback(1);

        robot_parameter->changedHomeAngle(new_angle.theta1, new_angle.theta2, new_angle.theta3);
    }
    else
    {
        emit newNotification(false, "Error: Calculate Kinematic Fail!");
    }
}

void CalibrationControl::homeRobot()
{
    if (!deltax_port->isConnected())
    {
        emit newNotification(false, "Error: Robot disconnect!");
        return;
    }

    QString new_robot_gcode = "G28";
    new_robot_gcode += "\n";
    deltax_port->write(new_robot_gcode);
}

void CalibrationControl::moveAPoint(float _radius, float _zdown)
{
    if (!deltax_port->isConnected())
    {
        emit newNotification(false, "Error: Robot disconnect!");
        return;
    }

    QString new_robot_gcode = "G0 X0 Y";
    new_robot_gcode += QString::number(_radius);
    new_robot_gcode += " Z";
    new_robot_gcode += QString::number(_zdown);
    new_robot_gcode += "\n";

    deltax_port->write(new_robot_gcode);
    //qInfo() << new_robot_gcode;
}

void CalibrationControl::moveBPoint(float _radius, float _zdown)
{
    if (!deltax_port->isConnected())
    {
        emit newNotification(false, "Error: Robot disconnect!");
        return;
    }

    QString new_robot_gcode = "G0 X";
    new_robot_gcode += QString::number(-_radius * cos(DEG_TO_RAD * 30));
    new_robot_gcode += " Y";
    new_robot_gcode += QString::number(-_radius * sin(DEG_TO_RAD * 30));
    new_robot_gcode += " Z";
    new_robot_gcode += QString::number(_zdown);
    new_robot_gcode += "\n";

    deltax_port->write(new_robot_gcode);
    //qInfo() << new_robot_gcode;
}

void CalibrationControl::moveCPoint(float _radius, float _zdown)
{
    if (!deltax_port->isConnected())
    {
        emit newNotification(false, "Error: Robot disconnect!");
        return;
    }

    QString new_robot_gcode = "G0 X";
    new_robot_gcode += QString::number(_radius * cos(DEG_TO_RAD * 30));
    new_robot_gcode += " Y";
    new_robot_gcode += QString::number(-_radius * sin(DEG_TO_RAD * 30));
    new_robot_gcode += " Z";
    new_robot_gcode += QString::number(_zdown);
    new_robot_gcode += "\n";

    deltax_port->write(new_robot_gcode);
    //qInfo() << new_robot_gcode;
}

void CalibrationControl::moveCenterPoint(float _zdown)
{
    if (!deltax_port->isConnected())
    {
        qInfo() << "Errorrr";
        emit newNotification(false, "Error: Robot disconnect!");
        return;
    }

    QString new_robot_gcode = "G0 X0 Y0 Z";
    new_robot_gcode += QString::number(_zdown);
    new_robot_gcode += "\n";

    deltax_port->write(new_robot_gcode);
    //qInfo() << new_robot_gcode;
}

void CalibrationControl::setNewStepPer2Pi(float _radius, float _a, float _b, float _c)
{
    if (!deltax_port->isConnected())
    {
        emit newNotification(false, "Error: Robot disconnect!");
        return;
    }

    if (robot_parameter->is_loaded == false)
    {
        emit newNotification(false, "Error: Need load parameter!");
        return;
    }

    Robot_Step step_per_2pi = robot_parameter->robotStepPer2Pi();

    Robot_Step new_step_per_2pi;

    new_step_per_2pi.t1 = step_per_2pi.t1 + step_per_2pi.t1 * (_radius - _a) / _radius;
    new_step_per_2pi.t2 = step_per_2pi.t2 + step_per_2pi.t2 * (_radius - _b) / _radius;
    new_step_per_2pi.t3 = step_per_2pi.t3 + step_per_2pi.t3 * (_radius - _c) / _radius;

    QString new_robot_para = "M405 P1144 A";
    new_robot_para += QString::number(new_step_per_2pi.t1);
    new_robot_para += " B";
    new_robot_para += QString::number(new_step_per_2pi.t2);
    new_robot_para += " C";
    new_robot_para += QString::number(new_step_per_2pi.t3);
    new_robot_para += "\n";
    deltax_port->write(new_robot_para);
    addNumberOkFeedback(1);

    robot_parameter->changedStepPer2Pi(new_step_per_2pi.t1, new_step_per_2pi.t2, new_step_per_2pi.t3);
}

void CalibrationControl::addNumberOkFeedback(int _number)
{
    need_response_number_ok += _number;
    is_have_add_new_ok = true;
    countdown_timer.start(2000);
}

void CalibrationControl::checkOkReponse()
{
    if (is_have_add_new_ok == false)
    {
        return;
    }
    need_response_number_ok--;
    if (need_response_number_ok == 0 && is_have_add_new_ok == true)
    {
        countdown_timer.stop();
        emit newNotification(true, "Done");
        is_have_add_new_ok = false;
    }
}

void CalibrationControl::getRobotErrorAngleFromString(QString r_string)
{
    r_string = r_string.remove(0, 11);
    if (r_string == "")
    {
        return;
    }
    QStringList data_element = r_string.split(',');
    if (data_element.length() != 3)
    {
        return;
    }

    float t1_error = 0.0f;
    float t2_error = 0.0f;
    float t3_error = 0.0f;

    if (data_element[0] != "" && data_element[0] != "nan") t1_error = data_element[0].toFloat();
    if (data_element[1] != "" && data_element[1] != "nan") t2_error = data_element[1].toFloat();
    if (data_element[2] != "" && data_element[2] != "nan") t3_error = data_element[2].toFloat();

    emit updateErrorAngle(t1_error, t2_error, t3_error);
}

void CalibrationControl::countdown_timer_timeout()
{
    is_have_add_new_ok = false;
    need_response_number_ok = 0;
    countdown_timer.stop();
    emit newNotification(false, "Fail");
}

void CalibrationControl::auto_read_error_timeout()
{
    if (!deltax_port->isConnected())
    {
        emit newNotification(false, "Error: Robot disconnect!");
        auto_error_timer.stop();
        return;
    }

    QString new_robot_gcode = "ErrorAngle";
    new_robot_gcode += "\n";

    deltax_port->write(new_robot_gcode);
}

void CalibrationControl::loaded_robot_parameter()
{
    Robot_Geometry _current_geometry = robot_parameter->robotParameter();
    deltaxs_kinematic.setParameter(_current_geometry.of, _current_geometry.f, _current_geometry.e, _current_geometry.rf, _current_geometry.re);
    deltaxs_kinematic.init();
}

void CalibrationControl::robot_ready_read(QString r_string)
{
    if (r_string == "Ok")
    {
        checkOkReponse();
    }
    else if (r_string.startsWith("ErrorAngle:"))
    {
        getRobotErrorAngleFromString(r_string);
    }
}
