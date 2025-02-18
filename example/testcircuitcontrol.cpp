#include "testcircuitcontrol.h"

TestCircuitControl::TestCircuitControl(QObject *parent)
    : QObject{parent}
{

}

void TestCircuitControl::addDevice(DeviceManager *_device)
{
    d_device = _device;
    deltax_port = d_device->robot_device;
    tester_port = d_device->test_device;

    connect(deltax_port, &DevicePort::readyReadData, this, &TestCircuitControl::robot_ready_read);
}

bool TestCircuitControl::getInput()
{
    if (!deltax_port->isConnected())
    {
        return false;
    }

    QString _gcode = "M07 I0 I1 I2 I3 I4 I5 A0 A1";
    _gcode += '\n';
    deltax_port->write(_gcode);

    emit updateDataToRobotTermite("<<: " + _gcode);

    return true;
}

bool TestCircuitControl::setAutoReadInput(bool is_on)
{
    if (!deltax_port->isConnected())
    {
        return false;
    }

    QString _gcode = "";
    if (is_on)
    {
        _gcode = "M08 I0 I1 I2 I3 I4 I5 A0 A1 B1 C1000000";
    }
    else
    {
        _gcode = "M08 I0 I1 I2 I3 I4 I5 A0 A1 B0 C0";
    }
    _gcode += '\n';
    deltax_port->write(_gcode);

    emit updateDataToRobotTermite("<<: " + _gcode);

    return true;
}

bool TestCircuitControl::setDigitalOutput(QString _pin_name, bool is_on)
{
    if (!deltax_port->isConnected())
    {
        return false;
    }

    QString _gcode = "M03 ";
    _gcode += _pin_name + " W";
    _gcode += QString::number(is_on);
    _gcode += '\n';
    deltax_port->write(_gcode);

    emit updateDataToRobotTermite("<<: " + _gcode);

    return true;
}

bool TestCircuitControl::setAllDigitalOutput(bool is_on)
{
    if (!deltax_port->isConnected())
    {
        return false;
    }

    QString _gcode = "M03 D0 D1 D2 D3 D4 D5 D6 D7 W";
    _gcode += QString::number(is_on);
    _gcode += '\n';
    deltax_port->write(_gcode);

    emit updateDataToRobotTermite("<<: " + _gcode);

    return true;
}

bool TestCircuitControl::setEStopEnable(bool is_on)
{
    if (!deltax_port->isConnected())
    {
        return false;
    }

    QString _gcode = "";
    if (is_on)
    {
        _gcode = "M600 A4 B5";

    }
    else
    {
        _gcode = "M601";
    }
    _gcode += '\n';
    deltax_port->write(_gcode);

    emit updateDataToRobotTermite("<<: " + _gcode);

    return true;
}

bool TestCircuitControl::reloadIO()
{
    if (!deltax_port->isConnected())
    {
        return false;
    }

    QString _gcode = "M10";
    _gcode += '\n';
    deltax_port->write(_gcode);

    emit updateDataToRobotTermite("<<: " + _gcode);

    _gcode = "M49";
    _gcode += '\n';
    deltax_port->write(_gcode);

    emit updateDataToRobotTermite("<<: " + _gcode);

    getInput();

    return true;
}

bool TestCircuitControl::setUsb1Enable(bool is_on, QString baudrate)
{
    if (!deltax_port->isConnected())
    {
        return false;
    }

    QString _gcode = "M42 A";
    _gcode += QString::number(is_on) + " B";
    _gcode += baudrate;
    _gcode += '\n';
    deltax_port->write(_gcode);

    emit updateDataToRobotTermite("<<: " + _gcode);

    return true;
}

bool TestCircuitControl::setRs232Enable(bool is_on, QString baudrate)
{
    if (!deltax_port->isConnected())
    {
        return false;
    }

    QString _gcode = "M40 A";
    _gcode += QString::number(is_on) + " B";
    _gcode += baudrate;
    _gcode += '\n';
    deltax_port->write(_gcode);

    emit updateDataToRobotTermite("<<: " + _gcode);

    return true;
}

bool TestCircuitControl::setRs485Enable(bool is_on, QString baudrate)
{
    if (!deltax_port->isConnected())
    {
        return false;
    }

    QString _gcode = "M41 A";
    _gcode += QString::number(is_on) + " B";
    _gcode += baudrate;
    _gcode += '\n';
    deltax_port->write(_gcode);

    emit updateDataToRobotTermite("<<: " + _gcode);

    return true;
}

bool TestCircuitControl::sendGcodeToRobot(QString _data)
{
    if (!deltax_port->isConnected())
    {
        return false;
    }

    QString _gcode = _data;
    _gcode += '\n';
    deltax_port->write(_gcode);

    emit updateDataToRobotTermite("<<: " + _gcode);

    return true;
}

void TestCircuitControl::getDigitalInputFromString(QString r_string)
{
    QStringList data_element = r_string.split(' ');
    bool _value = data_element[1].replace("V","").toInt();
    emit updatedDigitalInput(data_element[0], _value);
}

void TestCircuitControl::getAnalogInputFromString(QString r_string)
{
    QStringList data_element = r_string.split(' ');
    int _value = data_element[1].replace("V","").toInt();
    emit updatedAnalogInput(data_element[0], _value);
}

void TestCircuitControl::getOutputInforFromString(QString r_string)
{
    QStringList data_element = r_string.split(':');
    emit updatedOutputInfor(data_element[0], data_element[2].toInt());
}

void TestCircuitControl::getUsb1FromString(QString r_string)
{
    QStringList data_element = r_string.split(' ');
    bool is_on = false;

    int is_on_int = data_element[0].split(":")[1].toInt();
    if (is_on_int == 1)
    {
        is_on = true;
    }
    else
    {
        is_on = false;
    }

    QString baud_rate = data_element[1].split(":")[1];
    if (baud_rate.length() > 6)
    {
        baud_rate = "";
    }

    emit updatedUsb1Infor(is_on, baud_rate);
}

void TestCircuitControl::getRs232FromString(QString r_string)
{
    QStringList data_element = r_string.split(' ');
    bool is_on = false;

    int is_on_int = data_element[0].split(":")[1].toInt();
    if (is_on_int == 1)
    {
        is_on = true;
    }
    else
    {
        is_on = false;
    }

    QString baud_rate = data_element[1].split(":")[1];
    if (baud_rate.length() > 6)
    {
        baud_rate = "";
    }

    emit updatedRs232Infor(is_on, baud_rate);
}

void TestCircuitControl::getRs485FromString(QString r_string)
{
    QStringList data_element = r_string.split(' ');
    bool is_on = false;

    int is_on_int = data_element[0].split(":")[1].toInt();
    if (is_on_int == 1)
    {
        is_on = true;
    }
    else
    {
        is_on = false;
    }

    QString baud_rate = data_element[1].split(":")[1];
    if (baud_rate.length() > 6)
    {
        baud_rate = "";
    }

    emit updatedRs485Infor(is_on, baud_rate);
}

void TestCircuitControl::robot_ready_read(QString r_string)
{
    if (!r_string.startsWith("T-Scurve:"))
    {
        emit updateDataToRobotTermite(">>: " + r_string + "\n");
    }

    if (r_string.startsWith("D") && r_string.split(":").length() == 3)
    {
        getOutputInforFromString(r_string);
    }
    else if (r_string.startsWith("I") && r_string.split(" ").length() == 2)
    {
        getDigitalInputFromString(r_string);
    }
    else if (r_string.startsWith("A") && r_string.split(" ").length() == 2)
    {
        getAnalogInputFromString(r_string);
    }
    else if (r_string.startsWith("USB1:"))
    {
        getUsb1FromString(r_string);
    }
    else if (r_string.startsWith("RS232:"))
    {
        getRs232FromString(r_string);
    }
    else if (r_string.startsWith("RS485:"))
    {
        getRs485FromString(r_string);
    }
}
