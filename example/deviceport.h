#ifndef DEVICEPORT_H
#define DEVICEPORT_H

#include <QObject>
#include <QThread>
#include <QMutex>
//#include <QSerialPort>
#if defined (Q_OS_ANDROID)
#include "androidserial/qserialport.h"
#else
#include <QSerialPort>
#endif
#include <QTimer>
#include <QIODevice>
#include <QDebug>

class CustomSerial : public QObject
{
    Q_OBJECT
public:
    CustomSerial();
    ~CustomSerial();

private:
    QSerialPort *serial;
    QString serial_read_data;

private slots:
    void handle_error(QSerialPort::SerialPortError error);
    void read_serial();

public slots:
    void openPort(const QString &port_name);
    void closePort();
    void writePort(const QString &data);

signals:
    void readyReadData(const QString &data);
    void errorOccurredPort(const QSerialPort::SerialPortError error);
    void responseInforPort(const QString &port_name, const bool &is_open);
};

//----------------------------------------------------------------------

class DevicePort : public QObject
{
    Q_OBJECT
public:
    explicit DevicePort(QObject *parent = nullptr);
    ~DevicePort();
    void connectDevice(QString _portname, QString _id);
    void connectDevice(QStringList _portnames, QString _id);
    void disconnetDevice();
    QString getDeviePort();
    QString getDevieID();
    bool isConnected();
    QString getDeviceName();
    void setDeviceName(QString _device_name);
    void write(QString data);

private:

    QThread serialThread;

    CustomSerial *d_serial;
    QString id;
    QString string_data;

    bool is_connecting;
    QStringList list_port;
    QString device_port;
    bool is_connect;
    int port_index;

    QString device_name;

    QTimer timer_timeout;

    void connect_device();
    void processing_connect_data(QString _data);
    void write_data(QString data);

private slots:
    void read_data(const QString &data);
    void handle_error(QSerialPort::SerialPortError error);
    void getInforPort(const QString &port_name, const bool &is_open);
    void connecting_timeout();

signals:

    void connectingFeedback(bool is_connected);
    void rxDataSignal(int byte_count);
    void txDataSignal(int byte_count);
    void readyReadData(QString r_string);
};

#endif // DEVICEPORT_H
