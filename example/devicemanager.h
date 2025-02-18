#ifndef DEVICEMANAGER_H
#define DEVICEMANAGER_H

#include <QObject>
//#include <QSerialPort>
#if defined (Q_OS_ANDROID)
#include "androidserial/qserialportinfo.h"
#else
#include <QSerialPortInfo>
#endif

#include <QTimer>
#include <QDebug>
#include "deviceport.h"

class DeviceManager : public QObject
{
    Q_OBJECT
public:
    explicit DeviceManager(QObject *parent = nullptr);

    DevicePort *calib_device;
    DevicePort *robot_device;
    DevicePort *test_device;

public slots:
    void startGetNewPort();

    void connectCalibrator(QString portname, QString id);
    void connectDeltaXRobot(QString portname, QString id);
    void connectTestRobot(QString portname, QString id);
    void disconnectDeltaXRobot();
    void disconnectCalibrator();
    void disconnectTester();

    bool changeIdDeltaXRobot(QString id);
    bool changeIdCalibrator(QString id);
    bool changeIdTester(QString id);

private:
    QList<QSerialPortInfo> port_infos;
    QTimer port_infor_timer;
    void update_port_infors();

private slots:
    void port_infor_timer_handle();

    void robot_device_connect_handle(bool is_connected);
    void calib_device_connect_handle(bool is_connected);
    void test_device_connect_handle(bool is_connected);

signals:
    void updateComPortList(QStringList portlist);

    void connectCalibratorFeedback(QString portname, QString id);
    void rxCalibratorSignal(int byte_count);
    void txCalibratorSignal(int byte_count);

    void connectDeltaXFeedback(QString portname, QString id);
    void rxDeltaXSignal(int byte_count);
    void txDeltaXSignal(int byte_count);

    void connectTestFeedback(QString portname, QString id);
    void rxTestSignal(int byte_count);
    void txTestSignal(int byte_count);

};

#endif // DEVICEMANAGER_H
