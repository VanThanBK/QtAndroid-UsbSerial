#include "devicemanager.h"

DeviceManager::DeviceManager(QObject *parent)
    : QObject{parent}
{
    robot_device = new DevicePort(this);
    robot_device->setDeviceName("Delta");

    calib_device = new DevicePort(this);
    calib_device->setDeviceName("Calib");

    test_device = new DevicePort(this);
    test_device->setDeviceName("Tester");

    connect(&port_infor_timer, &QTimer::timeout, this, &DeviceManager::port_infor_timer_handle);

    connect(robot_device, &DevicePort::connectingFeedback, this, &DeviceManager::robot_device_connect_handle);
    connect(robot_device, &DevicePort::rxDataSignal, this, &DeviceManager::rxDeltaXSignal);
    connect(robot_device, &DevicePort::txDataSignal, this, &DeviceManager::txDeltaXSignal);

    connect(calib_device, &DevicePort::connectingFeedback, this, &DeviceManager::calib_device_connect_handle);
    connect(calib_device, &DevicePort::rxDataSignal, this, &DeviceManager::rxCalibratorSignal);
    connect(calib_device, &DevicePort::txDataSignal, this, &DeviceManager::txCalibratorSignal);

    connect(test_device, &DevicePort::connectingFeedback, this, &DeviceManager::test_device_connect_handle);
    connect(test_device, &DevicePort::rxDataSignal, this, &DeviceManager::rxTestSignal);
    connect(test_device, &DevicePort::txDataSignal, this, &DeviceManager::txTestSignal);
}

void DeviceManager::startGetNewPort()
{
    port_infor_timer.start(2000);
    //qInfo() << "timer start";
}

void DeviceManager::connectCalibrator(QString portname, QString id)
{
    if (portname == "Auto")
    {
        QStringList portnames;
        foreach (QSerialPortInfo port, port_infos)
        {
            portnames.append(port.portName());
        }
        calib_device->connectDevice(portnames, id);
    }
    else
    {
        calib_device->connectDevice(portname, id);
    }
}

void DeviceManager::connectDeltaXRobot(QString portname, QString id)
{
    if (portname == "Auto")
    {
        QStringList portnames;
        foreach (QSerialPortInfo port, port_infos)
        {
            portnames.append(port.portName());
        }
        robot_device->connectDevice(portnames, id);
    }
    else
    {
        robot_device->connectDevice(portname, id);
    }
}

void DeviceManager::connectTestRobot(QString portname, QString id)
{
    if (portname == "Auto")
    {
        QStringList portnames;
        foreach (QSerialPortInfo port, port_infos)
        {
            portnames.append(port.portName());
        }
        test_device->connectDevice(portnames, id);
    }
    else
    {
        test_device->connectDevice(portname, id);
    }
}

void DeviceManager::disconnectDeltaXRobot()
{
    robot_device->disconnetDevice();
}

void DeviceManager::disconnectCalibrator()
{
    calib_device->disconnetDevice();
}

void DeviceManager::disconnectTester()
{
    test_device->disconnetDevice();
}

bool DeviceManager::changeIdDeltaXRobot(QString id)
{
    if (robot_device->isConnected())
    {
        QString _send_gcode = "Address:";
        _send_gcode += id;
        _send_gcode += "\n";
        robot_device->write(_send_gcode);
        return true;
    }
    else
    {
        return false;
    }
}

bool DeviceManager::changeIdCalibrator(QString id)
{
    if (calib_device->isConnected())
    {
        QString _send_gcode = "Address:";
        _send_gcode += id;
        _send_gcode += "\n";
        calib_device->write(_send_gcode);
        return true;
    }
    else
    {
        return false;
    }
}

bool DeviceManager::changeIdTester(QString id)
{
    if (test_device->isConnected())
    {
        QString _send_gcode = "Address:";
        _send_gcode += id;
        _send_gcode += "\n";
        test_device->write(_send_gcode);
        return true;
    }
    else
    {
        return false;
    }
}

void DeviceManager::update_port_infors()
{
    QStringList portnames;
    portnames.append("Auto");
    foreach (QSerialPortInfo port, port_infos)
    {
        portnames.append(port.portName());
    }
    //qInfo() << portnames;
    emit updateComPortList(portnames);
}

void DeviceManager::port_infor_timer_handle()
{
    QList<QSerialPortInfo> new_port_infos = QSerialPortInfo::availablePorts();

    if (port_infos.length() != new_port_infos.length() || new_port_infos.length() == 0)
    {
        port_infos = new_port_infos;
        update_port_infors();
    }
    else
    {
        for (int index = 0; index < new_port_infos.length(); index++)
        {
            if (port_infos[index].portName() != new_port_infos[index].portName())
            {
                port_infos = new_port_infos;
                update_port_infors();
                break;
            }
        }
    }
}

void DeviceManager::robot_device_connect_handle(bool is_connected)
{
    if (is_connected)
    {
        emit connectDeltaXFeedback(robot_device->getDeviePort(), robot_device->getDevieID());
    }
    else
    {
        emit connectDeltaXFeedback("", "");
    }
}

void DeviceManager::calib_device_connect_handle(bool is_connected)
{
    if (is_connected)
    {
        emit connectCalibratorFeedback(calib_device->getDeviePort(), calib_device->getDevieID());
    }
    else
    {
        emit connectCalibratorFeedback("", "");
    }
}

void DeviceManager::test_device_connect_handle(bool is_connected)
{
    if (is_connected)
    {
        emit connectTestFeedback(test_device->getDeviePort(), test_device->getDevieID());
    }
    else
    {
        emit connectTestFeedback("", "");
    }
}
