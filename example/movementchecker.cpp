#include "movementchecker.h"

MovementChecker::MovementChecker(QObject *parent)
    : QObject{parent}
{
    robot_scurve_time_tick = 2.4f;
    //clearDesireScurveArray();
    //connect(deltax_port, &DevicePort::readyRead, this, &MovementChecker::robot_ready_read);
}

void MovementChecker::addDevice(DeviceManager *_device)
{
    d_device = _device;
    deltax_port = d_device->robot_device;
    calib_port = d_device->calib_device;

    connect(deltax_port, &DevicePort::readyReadData, this, &MovementChecker::robot_ready_read);
}

bool MovementChecker::turnOnDesireScurve(float _sample)
{
    if (!deltax_port->isConnected())
    {
        return false;
    }
    robot_scurve_time_tick = _sample;
    QString _gcode = "M410 E1 A";
    _gcode += QString::number(robot_scurve_time_tick);
    _gcode += "\n";
    deltax_port->write(_gcode);

    emit updateDataToRobotTermite("<<: " + _gcode);

//    test
//    QString _gcode1 = "G0 X0 Y0 Z-840";
//    _gcode1 += "\n";
//    deltax_port->write(_gcode1);
    return true;
}

bool MovementChecker::turnOffDesireScurve()
{
    if (!deltax_port->isConnected())
    {
        return false;
    }
    QString _gcode = "M410 E0 A";
    _gcode += QString::number(robot_scurve_time_tick);
    _gcode += "\n";
    deltax_port->write(_gcode);
    emit updateDataToRobotTermite("<<: " + _gcode);
    return true;
}

void MovementChecker::clearDesireScurveArray()
{
    desire_scurve_array.clear();
    Scurve_Point _scurve_point;
    _scurve_point.p = 0;
    _scurve_point.v = 0;
    _scurve_point.a = 0;
    _scurve_point.j = 0;
    _scurve_point.t = 0;

    desire_scurve_array.append(_scurve_point);

    emit addNewDesireScurveData(_scurve_point.p,
                                _scurve_point.v,
                                _scurve_point.a,
                                _scurve_point.j,
                                _scurve_point.t);
}

void MovementChecker::reloadDesireScurve()
{
    for (int index = 0; index < desire_scurve_array.length(); index++)
    {
        Scurve_Point _scurve_point = desire_scurve_array[index];
        emit addNewDesireScurveData(_scurve_point.p,
                                    _scurve_point.v,
                                    _scurve_point.a,
                                    _scurve_point.j,
                                    _scurve_point.t);
    }
}

bool MovementChecker::sendGcodeToRobot(QString _gcode)
{
    if (!deltax_port->isConnected())
    {
        return false;
    }
    _gcode += "\n";
    deltax_port->write(_gcode);
    emit updateDataToRobotTermite("<<: " + _gcode);
    return false;
}

void MovementChecker::robot_ready_read(QString r_string)
{   
    if (!r_string.startsWith("T-Scurve:"))
    {
        emit updateDataToRobotTermite(">>: " + r_string + "\n");
        return;
    }

    r_string = r_string.remove(0, 9);
    QStringList _value_array = r_string.split(",");

    Scurve_Point _scurve_point;
    _scurve_point.p = _value_array[0].toFloat();
    _scurve_point.v = _value_array[1].toFloat();
    _scurve_point.a = _value_array[2].toFloat();
    _scurve_point.j = _value_array[3].toFloat();
    _scurve_point.t = desire_scurve_array.length() * robot_scurve_time_tick;

    desire_scurve_array.append(_scurve_point);

    emit addNewDesireScurveData(_scurve_point.p,
                                _scurve_point.v,
                                _scurve_point.a,
                                _scurve_point.j,
                                _scurve_point.t);
}
