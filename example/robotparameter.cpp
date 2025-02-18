#include "robotparameter.h"

RobotParameter::RobotParameter(QObject *parent)
    : QObject{parent}
{

}

void RobotParameter::addDevice(DeviceManager *_device)
{
    need_response_number_ok = 0;
    is_have_add_new_ok = false;
    d_device = _device;
    deltax_port = d_device->robot_device;
    is_loaded = false;

    suggestions_geometry_d400.of = 188.5f;
    suggestions_geometry_d400.f = 340.58f;
    suggestions_geometry_d400.e = 120.0f;
    suggestions_geometry_d400.rf = 211.87f;
    suggestions_geometry_d400.re = 516.0f;
    suggestions_geometry_d400.z = 557.5f;
    suggestions_geometry_d400.d = 200.0f;

    suggestions_geometry_d600.of = 188.5f;
    suggestions_geometry_d600.f = 380.58f;
    suggestions_geometry_d600.e = 120.0f;
    suggestions_geometry_d600.rf = 241.82f;
    suggestions_geometry_d600.re = 586.0f;
    suggestions_geometry_d600.z = 635.5f;
    suggestions_geometry_d600.d = 300.0f;

    suggestions_geometry_d800.of = 188.5f;
    suggestions_geometry_d800.f = 511.15f;
    suggestions_geometry_d800.e = 120.0f;
    suggestions_geometry_d800.rf = 291.77f;
    suggestions_geometry_d800.re = 736.0f;
    suggestions_geometry_d800.z = 774.5f;
    suggestions_geometry_d800.d = 400.0f;

    suggestions_step_per_2pi.t1 = 10800;
    suggestions_step_per_2pi.t2 = 10800;
    suggestions_step_per_2pi.t3 = 10800;

    suggestions_home_angle.t1 = -18.567f;
    suggestions_home_angle.t2 = -18.567f;
    suggestions_home_angle.t3 = -18.567f;

    suggestions_axis5_infor.steps_per_unit = 13.333333333f;
    suggestions_axis5_infor.max_position = 95;
    suggestions_axis5_infor.min_position = -100;
    suggestions_axis5_infor.max_acc = 20000;
    suggestions_axis5_infor.max_jer = 2000000;
    suggestions_axis5_infor.max_vel = 1000;

    suggestions_axis6_infor.steps_per_unit = 13.333333333f;
    suggestions_axis6_infor.max_position = 95;
    suggestions_axis6_infor.min_position = -100;
    suggestions_axis6_infor.max_acc = 20000;
    suggestions_axis6_infor.max_jer = 2000000;
    suggestions_axis6_infor.max_vel = 1000;

    connect(deltax_port, &DevicePort::readyReadData, this, &RobotParameter::robot_ready_read);
    connect(deltax_port, &DevicePort::connectingFeedback, this, &RobotParameter::robot_connect_handle);

    connect(&countdown_timer, &QTimer::timeout, this, &RobotParameter::countdown_timer_timeout);
}

Robot_Geometry RobotParameter::robotParameter()
{
    return geometry;
}

Robot_Step RobotParameter::robotStepPer2Pi()
{
    return step_per_2pi;
}

void RobotParameter::changedHomeAngle(float _t1, float _t2, float _t3)
{
    home_angle.t1 = _t1;
    home_angle.t2 = _t2;
    home_angle.t3 = _t3;

    emit updatedRobotHomeAngle(home_angle.t1, home_angle.t2, home_angle.t3);
}

void RobotParameter::changedStepPer2Pi(uint16_t _t1, uint16_t _t2, uint16_t _t3)
{
    step_per_2pi.t1 = _t1;
    step_per_2pi.t2 = _t2;
    step_per_2pi.t3 = _t3;

    emit updatedRobotStepPer2Pi(step_per_2pi.t1, step_per_2pi.t2, step_per_2pi.t3);
}

bool RobotParameter::getRobotInfor()
{
    if (!deltax_port->isConnected())
    {
        return false;
    }

    QString _gcode = "ROBOTMODEL";
    _gcode += '\n';
    deltax_port->write(_gcode);

    _gcode = "IMEI";
    _gcode += '\n';
    deltax_port->write(_gcode);

    return true;
}

void RobotParameter::setRobotModel(uint8_t _robot_version, uint16_t _robot_size, uint8_t _robot_axis)
{
    robot_version = _robot_version;
    robot_size = _robot_size;
    robot_axis = _robot_axis;
}

void RobotParameter::setRobotImei(QString _robot_imei)
{
    robot_imei = _robot_imei;
}

void RobotParameter::uploadInforToRobot()
{
    if (!deltax_port->isConnected())
    {
        emit newNotification(false, "Error: Robot disconnect!");
        return;
    }

    QString new_robot_model = "ROBOTMODEL:DELTA_XS_V5_D";
    new_robot_model += QString::number(robot_size);
    new_robot_model += "_";
    new_robot_model += QString::number(robot_axis);
    new_robot_model += "AXIS";

    new_robot_model += '\n';
    deltax_port->write(new_robot_model);

    new_robot_model = "IMEI:";
    new_robot_model += robot_imei;
    new_robot_model += '\n';
    deltax_port->write(new_robot_model);

    addNumberOkFeedback(2);
}

bool RobotParameter::getRobotParameter()
{
    if (!deltax_port->isConnected())
    {
        return false;
    }

    // get geometry
    QString _gcode = "M404 P1144";
    _gcode += '\n';
    deltax_port->write(_gcode);

    // step per 2pi
    _gcode = "M406 P1144";
    _gcode += '\n';
    deltax_port->write(_gcode);

    // home
    _gcode = "M610 P1144";
    _gcode += '\n';
    deltax_port->write(_gcode);

    if (robot_axis > 3)
    {
        _gcode = "M420";
        _gcode += '\n';
        deltax_port->write(_gcode);
    }

    if (robot_axis > 4)
    {
        _gcode = "M421";
        _gcode += '\n';
        deltax_port->write(_gcode);
    }

    if (robot_axis > 5)
    {
        _gcode = "M422";
        _gcode += '\n';
        deltax_port->write(_gcode);
    }

    return true;
}

void RobotParameter::setRobotGeometry(float _of, float _f, float _e, float _rf, float _re)
{
    geometry.of = _of;
    geometry.f = _f;
    geometry.e = _e;
    geometry.rf = _rf;
    geometry.re = _re;
}

void RobotParameter::setRobotMaxSize(float _z, float _d)
{
    geometry.z = _z;
    geometry.d = _d;
}

void RobotParameter::setRobotHomeAngle(float _t1, float _t2, float _t3)
{
    home_angle.t1 = _t1;
    home_angle.t2 = _t2;
    home_angle.t3 = _t3;
}

void RobotParameter::setRobotStepPer2Pi(uint16_t _t1, uint16_t _t2, uint16_t _t3)
{
    step_per_2pi.t1 = _t1;
    step_per_2pi.t2 = _t2;
    step_per_2pi.t3 = _t3;
}

void RobotParameter::setRobotAxis4Infor(QList<bool> _list_bool, QList<float> _list_float)
{
    axis4_infor.getFromList(_list_bool);
    axis4_infor.getFromList(_list_float);
}

void RobotParameter::setRobotAxis5Infor(QList<bool> _list_bool, QList<float> _list_float)
{
    axis5_infor.getFromList(_list_bool);
    axis5_infor.getFromList(_list_float);
}

void RobotParameter::setRobotAxis6Infor(QList<bool> _list_bool, QList<float> _list_float)
{
    axis6_infor.getFromList(_list_bool);
    axis6_infor.getFromList(_list_float);
}

void RobotParameter::uploadParameterToRobot()
{
    if (!deltax_port->isConnected())
    {
        emit newNotification(false, "Error: Robot disconnect!");
        return;
    }

    QString new_robot_para = "M401 P1144 U";
    new_robot_para += QString::number(geometry.of);
    new_robot_para += " F";
    new_robot_para += QString::number(geometry.f);
    new_robot_para += " R";
    new_robot_para += QString::number(geometry.rf);
    new_robot_para += " E";
    new_robot_para += QString::number(geometry.re);
    new_robot_para += " Q";
    new_robot_para += QString::number(geometry.e);
    new_robot_para += "\n";
    deltax_port->write(new_robot_para);
    addNumberOkFeedback(1);

    new_robot_para = "M402 P1144 Z";
    new_robot_para += QString::number(geometry.z);
    new_robot_para += "\n";
    deltax_port->write(new_robot_para);
    addNumberOkFeedback(1);

    new_robot_para = "M403 P1144 R";
    new_robot_para += QString::number(geometry.d);
    new_robot_para += "\n";
    deltax_port->write(new_robot_para);
    addNumberOkFeedback(1);

    new_robot_para = "M405 P1144 A";
    new_robot_para += QString::number(step_per_2pi.t1);
    new_robot_para += " B";
    new_robot_para += QString::number(step_per_2pi.t2);
    new_robot_para += " C";
    new_robot_para += QString::number(step_per_2pi.t3);
    new_robot_para += "\n";
    deltax_port->write(new_robot_para);
    addNumberOkFeedback(1);

    new_robot_para = "M609 P1144 A";
    new_robot_para += QString::number(home_angle.t1);
    new_robot_para += " B";
    new_robot_para += QString::number(home_angle.t2);
    new_robot_para += " C";
    new_robot_para += QString::number(home_angle.t3);
    new_robot_para += "\n";
    deltax_port->write(new_robot_para);
    addNumberOkFeedback(1);

    if (robot_axis > 3)
    {
        new_robot_para = "M60 D";
        new_robot_para += QString::number(axis4_infor.is_define);
        new_robot_para += " E";
        new_robot_para += QString::number(axis4_infor.is_endstop_enable);
        new_robot_para += " I";
        new_robot_para += QString::number(axis4_infor.is_endstop_invert);
        new_robot_para += " S";
        new_robot_para += QString::number(axis4_infor.home_speed);
        new_robot_para += " R";
        new_robot_para += QString::number(axis4_infor.home_revert);
        new_robot_para += " U";
        new_robot_para += QString::number(axis4_infor.steps_per_unit);
        new_robot_para += " P";
        new_robot_para += QString::number(axis4_infor.max_position);
        new_robot_para += " Q";
        new_robot_para += QString::number(axis4_infor.min_position);
        new_robot_para += " H";
        new_robot_para += QString::number(axis4_infor.home_position);
        new_robot_para += " A";
        new_robot_para += QString::number(axis4_infor.max_acc);
        new_robot_para += " J";
        new_robot_para += QString::number(axis4_infor.max_jer);
        new_robot_para += " F";
        new_robot_para += QString::number(axis4_infor.max_vel);
        new_robot_para += "\n";
        deltax_port->write(new_robot_para);
        addNumberOkFeedback(1);
    }
    else
    {
        new_robot_para = "M60 D";
        new_robot_para += QString::number(false);
        new_robot_para += "\n";
        deltax_port->write(new_robot_para);
        addNumberOkFeedback(1);
    }

    if (robot_axis > 4)
    {
        new_robot_para = "M61 D";
        new_robot_para += QString::number(axis5_infor.is_define);
        new_robot_para += " E";
        new_robot_para += QString::number(axis5_infor.is_endstop_enable);
        new_robot_para += " I";
        new_robot_para += QString::number(axis5_infor.is_endstop_invert);
        new_robot_para += " S";
        new_robot_para += QString::number(axis5_infor.home_speed);
        new_robot_para += " R";
        new_robot_para += QString::number(axis5_infor.home_revert);
        new_robot_para += " U";
        new_robot_para += QString::number(axis5_infor.steps_per_unit);
        new_robot_para += " P";
        new_robot_para += QString::number(axis5_infor.max_position);
        new_robot_para += " Q";
        new_robot_para += QString::number(axis5_infor.min_position);
        new_robot_para += " H";
        new_robot_para += QString::number(axis5_infor.home_position);
        new_robot_para += " A";
        new_robot_para += QString::number(axis5_infor.max_acc);
        new_robot_para += " J";
        new_robot_para += QString::number(axis5_infor.max_jer);
        new_robot_para += " F";
        new_robot_para += QString::number(axis5_infor.max_vel);
        new_robot_para += "\n";
        deltax_port->write(new_robot_para);
        addNumberOkFeedback(1);
    }
    else
    {
        new_robot_para = "M61 D";
        new_robot_para += QString::number(false);
        new_robot_para += "\n";
        deltax_port->write(new_robot_para);
        addNumberOkFeedback(1);
    }

    if (robot_axis > 5)
    {
        new_robot_para = "M62 D";
        new_robot_para += QString::number(axis6_infor.is_define);
        new_robot_para += " E";
        new_robot_para += QString::number(axis6_infor.is_endstop_enable);
        new_robot_para += " I";
        new_robot_para += QString::number(axis6_infor.is_endstop_invert);
        new_robot_para += " S";
        new_robot_para += QString::number(axis6_infor.home_speed);
        new_robot_para += " R";
        new_robot_para += QString::number(axis6_infor.home_revert);
        new_robot_para += " U";
        new_robot_para += QString::number(axis6_infor.steps_per_unit);
        new_robot_para += " P";
        new_robot_para += QString::number(axis6_infor.max_position);
        new_robot_para += " Q";
        new_robot_para += QString::number(axis6_infor.min_position);
        new_robot_para += " H";
        new_robot_para += QString::number(axis6_infor.home_position);
        new_robot_para += " A";
        new_robot_para += QString::number(axis6_infor.max_acc);
        new_robot_para += " J";
        new_robot_para += QString::number(axis6_infor.max_jer);
        new_robot_para += " F";
        new_robot_para += QString::number(axis6_infor.max_vel);
        new_robot_para += "\n";
        deltax_port->write(new_robot_para);
        addNumberOkFeedback(1);
    }
    else
    {
        new_robot_para = "M62 D";
        new_robot_para += QString::number(false);
        new_robot_para += "\n";
        deltax_port->write(new_robot_para);
        addNumberOkFeedback(1);
    }
    is_loaded = true;
    emit loadedRobotParameter();
}

void RobotParameter::getRobotSuggestions(uint8_t _robot_version, uint16_t _robot_size, uint8_t _robot_axis)
{
    emit updatedRobotHomeAngle(suggestions_home_angle.t1, suggestions_home_angle.t2, suggestions_home_angle.t3);
    emit updatedRobotStepPer2Pi(suggestions_step_per_2pi.t1, suggestions_step_per_2pi.t2, suggestions_step_per_2pi.t3);
    if (_robot_version == 5 && _robot_size == 400)
    {
        emit updatedRobotGeometry(suggestions_geometry_d400.of,
                                  suggestions_geometry_d400.f,
                                  suggestions_geometry_d400.e,
                                  suggestions_geometry_d400.rf,
                                  suggestions_geometry_d400.re);
        emit updatedRobotMaxSize(suggestions_geometry_d400.z, suggestions_geometry_d400.d);
    }
    else if (_robot_version == 5 && _robot_size == 600)
    {
        emit updatedRobotGeometry(suggestions_geometry_d600.of,
                                  suggestions_geometry_d600.f,
                                  suggestions_geometry_d600.e,
                                  suggestions_geometry_d600.rf,
                                  suggestions_geometry_d600.re);
        emit updatedRobotMaxSize(suggestions_geometry_d600.z, suggestions_geometry_d600.d);
    }
    else if (_robot_version == 5 && _robot_size == 800)
    {
        emit updatedRobotGeometry(suggestions_geometry_d800.of,
                                  suggestions_geometry_d800.f,
                                  suggestions_geometry_d800.e,
                                  suggestions_geometry_d800.rf,
                                  suggestions_geometry_d800.re);
        emit updatedRobotMaxSize(suggestions_geometry_d800.z, suggestions_geometry_d800.d);
    }

    if (_robot_axis > 3)
    {
        QList<bool> _list_bool;
        QList<float> _list_float;

        suggestions_axis4_infor.addToList(_list_bool);
        suggestions_axis4_infor.addToList(_list_float);

        emit updatedRobotAxis4Infor(_list_bool, _list_float);
    }

    if (_robot_axis > 4)
    {
        QList<bool> _list_bool;
        QList<float> _list_float;

        suggestions_axis5_infor.addToList(_list_bool);
        suggestions_axis5_infor.addToList(_list_float);

        emit updatedRobotAxis5Infor(_list_bool, _list_float);
    }

    if (_robot_axis > 5)
    {
        QList<bool> _list_bool;
        QList<float> _list_float;

        suggestions_axis6_infor.addToList(_list_bool);
        suggestions_axis6_infor.addToList(_list_float);

        emit updatedRobotAxis6Infor(_list_bool, _list_float);
    }
}

void RobotParameter::createSuggestions()
{

}

void RobotParameter::getRobotInforFromString(QString r_string)
{
    r_string = r_string.remove(0, 6);
    if (r_string != "")
    {
        QStringList data_element = r_string.split('_');

        robot_version = data_element[2].remove(0, 1).toInt();
        robot_size = data_element[3].remove(0, 1).toInt();
        if (data_element.length() > 4)
        {
            QString _axis_string = data_element[4].mid(0, 1);
            robot_axis = _axis_string.toInt();
        }
        else
        {
            robot_axis = 3;
        }
        emit updatedRobotModel(robot_version, robot_size, robot_axis);
    }
}

void RobotParameter::getRobotImeiFromString(QString r_string)
{
    r_string = r_string.remove(0, 5);
    if (r_string != "")
    {
        robot_imei = r_string;
        emit updatedRobotImei(robot_imei);
    }
}

void RobotParameter::getRobotGeometryFromString(QString r_string)
{
    r_string = r_string.remove(0, 3);
    if (r_string == "")
    {
        return;
    }
    QStringList data_element = r_string.split(' ');
    if (data_element.length() != 7)
    {
        return;
    }

    QString data_buffer = "";

    data_buffer = data_element[0].mid(data_element[0].indexOf(':') + 1, data_element[0].length());
    if (data_buffer != "" && data_buffer != "nan") geometry.of = data_buffer.toFloat();

    data_buffer = data_element[1].mid(data_element[1].indexOf(':') + 1, data_element[1].length());
    if (data_buffer != "" && data_buffer != "nan") geometry.f = data_buffer.toFloat();

    data_buffer = data_element[2].mid(data_element[2].indexOf(':') + 1, data_element[2].length());
    if (data_buffer != "" && data_buffer != "nan") geometry.e = data_buffer.toFloat();

    data_buffer = data_element[3].mid(data_element[3].indexOf(':') + 1, data_element[3].length());
    if (data_buffer != "" && data_buffer != "nan") geometry.rf = data_buffer.toFloat();

    data_buffer = data_element[4].mid(data_element[4].indexOf(':') + 1, data_element[4].length());
    if (data_buffer != "" && data_buffer != "nan") geometry.re = data_buffer.toFloat();

    data_buffer = data_element[5].mid(data_element[5].indexOf(':') + 1, data_element[5].length());
    if (data_buffer != "" && data_buffer != "nan") geometry.z = data_buffer.toFloat();

    data_buffer = data_element[6].mid(data_element[6].indexOf(':') + 1, data_element[6].length());
    if (data_buffer != "" && data_buffer != "nan") geometry.d = data_buffer.toFloat();

    for (int index = 0; index < data_element.length(); index++)
    {
        data_buffer = data_element[index].mid(data_element[index].indexOf(':') + 1, data_element[index].length());
        if (data_buffer == "" || data_buffer == "nan")
        {
            return;
        }
    }

    is_loaded = true;
    emit loadedRobotParameter();

    emit updatedRobotGeometry(geometry.of, geometry.f, geometry.e, geometry.rf, geometry.re);
    emit updatedRobotMaxSize(geometry.z, geometry.d);
}

void RobotParameter::getRobotHomeAngleFromString(QString r_string)
{
    r_string = r_string.remove(0, 3);
    if (r_string == "")
    {
        return;
    }
    QStringList data_element = r_string.split(' ');
    if (data_element.length() != 3)
    {
        return;
    }

    QString data_buffer = "";
    data_buffer = data_element[0].mid(data_element[0].indexOf(':') + 1, data_element[0].length());
    if (data_buffer != "" && data_buffer != "nan") home_angle.t1 = data_buffer.toFloat();
    data_buffer = data_element[1].mid(data_element[1].indexOf(':') + 1, data_element[1].length());
    if (data_buffer != "" && data_buffer != "nan") home_angle.t2 = data_buffer.toFloat();
    data_buffer = data_element[2].mid(data_element[2].indexOf(':') + 1, data_element[2].length());
    if (data_buffer != "" && data_buffer != "nan") home_angle.t3 = data_buffer.toFloat();

    for (int index = 0; index < data_element.length(); index++)
    {
        data_buffer = data_element[index].mid(data_element[index].indexOf(':') + 1, data_element[index].length());
        if (data_buffer == "" || data_buffer == "nan")
        {
            return;
        }
    }

    emit updatedRobotHomeAngle(home_angle.t1, home_angle.t2, home_angle.t3);
}

void RobotParameter::getRobotStepPer2PiFromString(QString r_string)
{
    r_string = r_string.remove(0, 2);
    if (r_string == "")
    {
        return;
    }
    QStringList data_element = r_string.split(' ');
    if (data_element.length() != 3)
    {
        return;
    }

    QString data_buffer = "";
    data_buffer = data_element[0].mid(data_element[0].indexOf(':') + 1, data_element[0].length());
    if (data_buffer != "" && data_buffer != "nan") step_per_2pi.t1 = data_buffer.toInt();
    data_buffer = data_element[1].mid(data_element[1].indexOf(':') + 1, data_element[1].length());
    if (data_buffer != "" && data_buffer != "nan") step_per_2pi.t2 = data_buffer.toInt();
    data_buffer = data_element[2].mid(data_element[2].indexOf(':') + 1, data_element[2].length());
    if (data_buffer != "" && data_buffer != "nan") step_per_2pi.t3 = data_buffer.toInt();

    for (int index = 0; index < data_element.length(); index++)
    {
        data_buffer = data_element[index].mid(data_element[index].indexOf(':') + 1, data_element[index].length());
        if (data_buffer == "" || data_buffer == "nan")
        {
            return;
        }
    }

    emit updatedRobotStepPer2Pi(step_per_2pi.t1, step_per_2pi.t2, step_per_2pi.t3);
}

void RobotParameter::getAxis4InforFormString(QString r_string)
{
    r_string = r_string.remove(0, 6);
    if (r_string == "")
    {
        return;
    }
    QStringList data_element = r_string.split(' ');
    if (data_element.length() != 12)
    {
        return;
    }

    QString data_buffer = "";
    data_buffer = data_element[0].mid(data_element[0].indexOf(':') + 1, data_element[0].length());
    if (data_buffer != "" && data_buffer != "nan") axis4_infor.is_define = data_buffer.toInt();

    data_buffer = data_element[1].mid(data_element[1].indexOf(':') + 1, data_element[1].length());
    if (data_buffer != "" && data_buffer != "nan") axis4_infor.is_endstop_enable = data_buffer.toInt();

    data_buffer = data_element[2].mid(data_element[2].indexOf(':') + 1, data_element[2].length());
    if (data_buffer != "" && data_buffer != "nan") axis4_infor.is_endstop_invert = data_buffer.toInt();

    data_buffer = data_element[3].mid(data_element[3].indexOf(':') + 1, data_element[3].length());
    if (data_buffer != "" && data_buffer != "nan") axis4_infor.home_speed = data_buffer.toFloat();

    data_buffer = data_element[4].mid(data_element[4].indexOf(':') + 1, data_element[4].length());
    if (data_buffer != "" && data_buffer != "nan") axis4_infor.home_revert = data_buffer.toFloat();

    data_buffer = data_element[5].mid(data_element[5].indexOf(':') + 1, data_element[5].length());
    if (data_buffer != "" && data_buffer != "nan") axis4_infor.steps_per_unit = data_buffer.toFloat();

    data_buffer = data_element[6].mid(data_element[6].indexOf(':') + 1, data_element[6].length());
    if (data_buffer != "" && data_buffer != "nan") axis4_infor.max_position = data_buffer.toFloat();

    data_buffer = data_element[7].mid(data_element[7].indexOf(':') + 1, data_element[7].length());
    if (data_buffer != "" && data_buffer != "nan") axis4_infor.min_position = data_buffer.toFloat();

    data_buffer = data_element[8].mid(data_element[8].indexOf(':') + 1, data_element[8].length());
    if (data_buffer != "" && data_buffer != "nan") axis4_infor.home_position = data_buffer.toFloat();

    data_buffer = data_element[9].mid(data_element[9].indexOf(':') + 1, data_element[9].length());
    if (data_buffer != "" && data_buffer != "nan") axis4_infor.max_acc = data_buffer.toFloat();

    data_buffer = data_element[10].mid(data_element[10].indexOf(':') + 1, data_element[10].length());
    if (data_buffer != "" && data_buffer != "nan") axis4_infor.max_jer = data_buffer.toFloat();

    data_buffer = data_element[11].mid(data_element[11].indexOf(':') + 1, data_element[11].length());
    if (data_buffer != "" && data_buffer != "nan") axis4_infor.max_vel = data_buffer.toFloat();

    for (int index = 0; index < data_element.length(); index++)
    {
        data_buffer = data_element[index].mid(data_element[index].indexOf(':') + 1, data_element[index].length());
        if (data_buffer == "" || data_buffer == "nan")
        {
            return;
        }
    }

    QList<bool> _list_bool;
    QList<float> _list_float;

    axis4_infor.addToList(_list_bool);
    axis4_infor.addToList(_list_float);

    emit updatedRobotAxis4Infor(_list_bool, _list_float);
}

void RobotParameter::getAxis5InforFormString(QString r_string)
{
    r_string = r_string.remove(0, 6);
    if (r_string == "")
    {
        return;
    }
    QStringList data_element = r_string.split(' ');
    if (data_element.length() != 12)
    {
        return;
    }

    QString data_buffer = "";
    data_buffer = data_element[0].mid(data_element[0].indexOf(':') + 1, data_element[0].length());
    if (data_buffer != "" && data_buffer != "nan") axis5_infor.is_define = data_buffer.toInt();

    data_buffer = data_element[1].mid(data_element[1].indexOf(':') + 1, data_element[1].length());
    if (data_buffer != "" && data_buffer != "nan") axis5_infor.is_endstop_enable = data_buffer.toInt();

    data_buffer = data_element[2].mid(data_element[2].indexOf(':') + 1, data_element[2].length());
    if (data_buffer != "" && data_buffer != "nan") axis5_infor.is_endstop_invert = data_buffer.toInt();

    data_buffer = data_element[3].mid(data_element[3].indexOf(':') + 1, data_element[3].length());
    if (data_buffer != "" && data_buffer != "nan") axis5_infor.home_speed = data_buffer.toFloat();

    data_buffer = data_element[4].mid(data_element[4].indexOf(':') + 1, data_element[4].length());
    if (data_buffer != "" && data_buffer != "nan") axis5_infor.home_revert = data_buffer.toFloat();

    data_buffer = data_element[5].mid(data_element[5].indexOf(':') + 1, data_element[5].length());
    if (data_buffer != "" && data_buffer != "nan") axis5_infor.steps_per_unit = data_buffer.toFloat();

    data_buffer = data_element[6].mid(data_element[6].indexOf(':') + 1, data_element[6].length());
    if (data_buffer != "" && data_buffer != "nan") axis5_infor.max_position = data_buffer.toFloat();

    data_buffer = data_element[7].mid(data_element[7].indexOf(':') + 1, data_element[7].length());
    if (data_buffer != "" && data_buffer != "nan") axis5_infor.min_position = data_buffer.toFloat();

    data_buffer = data_element[8].mid(data_element[8].indexOf(':') + 1, data_element[8].length());
    if (data_buffer != "" && data_buffer != "nan") axis5_infor.home_position = data_buffer.toFloat();

    data_buffer = data_element[9].mid(data_element[9].indexOf(':') + 1, data_element[9].length());
    if (data_buffer != "" && data_buffer != "nan") axis5_infor.max_acc = data_buffer.toFloat();

    data_buffer = data_element[10].mid(data_element[10].indexOf(':') + 1, data_element[10].length());
    if (data_buffer != "" && data_buffer != "nan") axis5_infor.max_jer = data_buffer.toFloat();

    data_buffer = data_element[11].mid(data_element[11].indexOf(':') + 1, data_element[11].length());
    if (data_buffer != "" && data_buffer != "nan") axis5_infor.max_vel = data_buffer.toFloat();

    for (int index = 0; index < data_element.length(); index++)
    {
        data_buffer = data_element[index].mid(data_element[index].indexOf(':') + 1, data_element[index].length());
        if (data_buffer == "" || data_buffer == "nan")
        {
            return;
        }
    }

    QList<bool> _list_bool;
    QList<float> _list_float;

    axis5_infor.addToList(_list_bool);
    axis5_infor.addToList(_list_float);

    emit updatedRobotAxis5Infor(_list_bool, _list_float);
}

void RobotParameter::getAxis6InforFormString(QString r_string)
{
    r_string = r_string.remove(0, 6);
    if (r_string == "")
    {
        return;
    }
    QStringList data_element = r_string.split(' ');
    if (data_element.length() != 12)
    {
        return;
    }

    QString data_buffer = "";
    data_buffer = data_element[0].mid(data_element[0].indexOf(':') + 1, data_element[0].length());
    if (data_buffer != "" && data_buffer != "nan") axis6_infor.is_define = data_buffer.toInt();

    data_buffer = data_element[1].mid(data_element[1].indexOf(':') + 1, data_element[1].length());
    if (data_buffer != "" && data_buffer != "nan") axis6_infor.is_endstop_enable = data_buffer.toInt();

    data_buffer = data_element[2].mid(data_element[2].indexOf(':') + 1, data_element[2].length());
    if (data_buffer != "" && data_buffer != "nan") axis6_infor.is_endstop_invert = data_buffer.toInt();

    data_buffer = data_element[3].mid(data_element[3].indexOf(':') + 1, data_element[3].length());
    if (data_buffer != "" && data_buffer != "nan") axis6_infor.home_speed = data_buffer.toFloat();

    data_buffer = data_element[4].mid(data_element[4].indexOf(':') + 1, data_element[4].length());
    if (data_buffer != "" && data_buffer != "nan") axis6_infor.home_revert = data_buffer.toFloat();

    data_buffer = data_element[5].mid(data_element[5].indexOf(':') + 1, data_element[5].length());
    if (data_buffer != "" && data_buffer != "nan") axis6_infor.steps_per_unit = data_buffer.toFloat();

    data_buffer = data_element[6].mid(data_element[6].indexOf(':') + 1, data_element[6].length());
    if (data_buffer != "" && data_buffer != "nan") axis6_infor.max_position = data_buffer.toFloat();

    data_buffer = data_element[7].mid(data_element[7].indexOf(':') + 1, data_element[7].length());
    if (data_buffer != "" && data_buffer != "nan") axis6_infor.min_position = data_buffer.toFloat();

    data_buffer = data_element[8].mid(data_element[8].indexOf(':') + 1, data_element[8].length());
    if (data_buffer != "" && data_buffer != "nan") axis6_infor.home_position = data_buffer.toFloat();

    data_buffer = data_element[9].mid(data_element[9].indexOf(':') + 1, data_element[9].length());
    if (data_buffer != "" && data_buffer != "nan") axis6_infor.max_acc = data_buffer.toFloat();

    data_buffer = data_element[10].mid(data_element[10].indexOf(':') + 1, data_element[10].length());
    if (data_buffer != "" && data_buffer != "nan") axis6_infor.max_jer = data_buffer.toFloat();

    data_buffer = data_element[11].mid(data_element[11].indexOf(':') + 1, data_element[11].length());
    if (data_buffer != "" && data_buffer != "nan") axis6_infor.max_vel = data_buffer.toFloat();

    for (int index = 0; index < data_element.length(); index++)
    {
        data_buffer = data_element[index].mid(data_element[index].indexOf(':') + 1, data_element[index].length());
        if (data_buffer == "" || data_buffer == "nan")
        {
            return;
        }
    }

    QList<bool> _list_bool;
    QList<float> _list_float;

    axis6_infor.addToList(_list_bool);
    axis6_infor.addToList(_list_float);

    emit updatedRobotAxis6Infor(_list_bool, _list_float);
}

void RobotParameter::addNumberOkFeedback(int _number)
{
    need_response_number_ok += _number;
    is_have_add_new_ok = true;
    countdown_timer.start(2000);
}

void RobotParameter::checkOkReponse()
{
    if (is_have_add_new_ok == false)
    {
        return;
    }
    need_response_number_ok--;
    if (need_response_number_ok == 0 && is_have_add_new_ok == true)
    {
        countdown_timer.stop();
        emit newNotification(true, "Seting Done");
        is_have_add_new_ok = false;
    }
}

void RobotParameter::countdown_timer_timeout()
{
    is_have_add_new_ok = false;
    need_response_number_ok = 0;
    emit newNotification(false, "Seting False");
}

void RobotParameter::robot_ready_read(QString r_string)
{
    if (r_string.startsWith("MODEL:"))
    {
        getRobotInforFromString(r_string);
    }
    else if (r_string.startsWith("IMEI:"))
    {
        getRobotImeiFromString(r_string);
    }
    else if (r_string.startsWith("OF:"))
    {
        getRobotGeometryFromString(r_string);
    }
    else if (r_string.startsWith("A:"))
    {
        getRobotStepPer2PiFromString(r_string);
    }
    else if (r_string.startsWith("T1:"))
    {
        getRobotHomeAngleFromString(r_string);
    }
    else if (r_string.startsWith("AXIS4 "))
    {
        getAxis4InforFormString(r_string);
    }
    else if (r_string.startsWith("AXIS5 "))
    {
        getAxis5InforFormString(r_string);
    }
    else if (r_string.startsWith("AXIS6 "))
    {
        getAxis6InforFormString(r_string);
    }
    else if (r_string == "Ok")
    {
        checkOkReponse();
    }
}

void RobotParameter::robot_connect_handle(bool is_connected)
{
    if (is_connected)
    {
        getRobotInfor();
    }
    else
    {
        is_loaded = false;
    }
}
