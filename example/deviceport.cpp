#include "deviceport.h"

DevicePort::DevicePort(QObject *parent)
    : QObject{parent}
{
    d_serial = new CustomSerial();
    is_connecting = false;

    timer_timeout.setSingleShot(true);
    connect(&timer_timeout, &QTimer::timeout, this, &DevicePort::connecting_timeout);

    d_serial->moveToThread(&serialThread);

    connect(d_serial, &CustomSerial::readyReadData, this, &DevicePort::read_data);
    connect(d_serial, &CustomSerial::errorOccurredPort, this, &DevicePort::handle_error);
    connect(d_serial, &CustomSerial::responseInforPort, this, &DevicePort::getInforPort);

    connect(&serialThread, &QThread::finished, d_serial, &QObject::deleteLater);

    serialThread.start();
}

DevicePort::~DevicePort()
{
    serialThread.quit();
    serialThread.wait();
}

void DevicePort::connectDevice(QString _portname, QString _id)
{
    if (is_connecting)
    {
        return;
    }
    is_connecting = true;

    list_port.clear();
    list_port.append(_portname);
    id = _id;
    port_index = 0;
    connect_device();
}

void DevicePort::connectDevice(QStringList _portnames, QString _id)
{
    if (is_connecting || _portnames.length() == 0)
    {
        return;
    }
    is_connecting = true;
    //d_serial->runSerial();

    list_port.clear();
    list_port = _portnames;
    id = _id;
    port_index = 0;
    connect_device();
}

void DevicePort::disconnetDevice()
{
    d_serial->closePort();
}

QString DevicePort::getDeviePort()
{
    return device_port;
}

QString DevicePort::getDevieID()
{
    return id;
}

bool DevicePort::isConnected()
{
    return is_connect;
}

QString DevicePort::getDeviceName()
{
    return device_name;
}

void DevicePort::setDeviceName(QString _device_name)
{
    device_name = _device_name;
}

void DevicePort::write(QString data)
{
    write_data(data);
}

void DevicePort::connect_device()
{
    if (port_index == list_port.length())
    {
        emit connectingFeedback(false);
        is_connecting = false;
        return;
    }

    //emit closePort();

    d_serial->openPort(list_port[port_index]);

    QString confirm_data = "Is";
    confirm_data += device_name + "\n";
    write_data(confirm_data);
    timer_timeout.start(1000);
}

void DevicePort::processing_connect_data(QString _data)
{
    int _indexof_data = _data.indexOf(":");
    if (_indexof_data > -1)
    {
        //qInfo() << _data;
        QString _key = _data.left(_indexof_data);
        QString _value = _data.right(_data.length() - _indexof_data - 1);

        //qInfo() << _key << "-:-" << _value;

        if (_key == "Address")
        {
            if (id == "")
            {
                id = _value;
                emit connectingFeedback(true);
                timer_timeout.stop();
                is_connecting = false;
            }
            else if (id != _value)
            {
                port_index++;
                timer_timeout.stop();
                d_serial->closePort();
                connect_device();
            }
            else
            {
                emit connectingFeedback(true);
                timer_timeout.stop();
                is_connecting = false;
            }
        }
    }
    else
    {
        QString _compare_data = "Yes";
        _compare_data += device_name;

        //qInfo() << _data;

        if (_data == _compare_data)
        {
            QString confirm_data = "Address";
            confirm_data += "\n";
            write_data(confirm_data);
        }
        else if (_data.indexOf("Yes") > -1)
        {
            port_index++;
            timer_timeout.stop();
            d_serial->closePort();
            connect_device();
        }
    }
}

void DevicePort::write_data(QString data)
{
    d_serial->writePort(data);
    emit txDataSignal(data.length());
}

void DevicePort::read_data(const QString &data)
{
    emit rxDataSignal(data.length());

    if (is_connecting)
    {
        processing_connect_data(data);
    }
    else
    {
        emit readyReadData(data);
    }
}

void DevicePort::handle_error(QSerialPort::SerialPortError error)
{
    if (error == QSerialPort::ResourceError) {
        d_serial->closePort();
        emit connectingFeedback(false);
    }
}

void DevicePort::getInforPort(const QString &port_name, const bool &is_open)
{
    device_port = port_name;
    is_connect = is_open;
}

void DevicePort::connecting_timeout()
{
    if (is_connecting == false)
    {
        return;
    }
    port_index++;
    d_serial->closePort();
    connect_device();
}

//----------------------------------------------------------------------------

CustomSerial::CustomSerial()
{
    serial = new QSerialPort();
    serial->setBaudRate(115200);

    connect(serial, &QSerialPort::readyRead, this, &CustomSerial::read_serial);
    connect(serial, &QSerialPort::errorOccurred, this, &CustomSerial::handle_error);
}

CustomSerial::~CustomSerial()
{

}

void CustomSerial::handle_error(QSerialPort::SerialPortError error)
{
    emit errorOccurredPort(error);
}

void CustomSerial::read_serial()
{
    if (serial->bytesAvailable())
    {
        serial_read_data += QString(serial->readAll());
    }

    qInfo() <<"Device port:" << serial_read_data;

    while (serial_read_data.indexOf('\n') > -1)
    {
        QString new_reponse = "";

        new_reponse = serial_read_data.mid(0, serial_read_data.indexOf('\n'));
        serial_read_data = serial_read_data.remove(0, serial_read_data.indexOf('\n') + 1);

        new_reponse = new_reponse.remove('\n');
        new_reponse = new_reponse.remove('\r');

        if (new_reponse == "")
        {
            continue;
        }

        //qInfo() << new_reponse;

        emit readyReadData(new_reponse);
    }
}

void CustomSerial::openPort(const QString &port_name)
{
    if (serial->isOpen())
    {
        serial->close();
    }
    serial->setPortName(port_name);
    if (serial->open(QIODevice::ReadWrite))
    {
        emit responseInforPort(serial->portName(), serial->isOpen());
    }
    //qInfo() << "open thread";
}

void CustomSerial::closePort()
{
    if (serial->isOpen())
    {
        serial->close();
        emit responseInforPort("", false);
    }
    //qInfo() << "close thread";
}

void CustomSerial::writePort(const QString &data)
{
    if (serial->isOpen())
    {
        serial->write(data.toUtf8(), data.length());
    }
    //qInfo() << "write thread " << data;
}
