#ifndef TESTCIRCUITCONTROL_H
#define TESTCIRCUITCONTROL_H

#include <QObject>
#include "devicemanager.h"
#include "deviceport.h"
#include <QTimer>
#include <QDebug>

class TestCircuitControl : public QObject
{
    Q_OBJECT
public:
    explicit TestCircuitControl(QObject *parent = nullptr);
    DeviceManager *d_device;
    DevicePort *deltax_port;
    DevicePort *tester_port;
    void addDevice(DeviceManager *_device);

public slots:
    bool getInput();
    bool setAutoReadInput(bool is_on);
    bool setDigitalOutput(QString _pin_name, bool is_on);
    bool setAllDigitalOutput(bool is_on);
    bool setEStopEnable(bool is_on);
    bool reloadIO();
    bool setUsb1Enable(bool is_on, QString baudrate);
    bool setRs232Enable(bool is_on, QString baudrate);
    bool setRs485Enable(bool is_on, QString baudrate);

    bool sendGcodeToRobot(QString _data);

private:
    void getDigitalInputFromString(QString r_string);
    void getAnalogInputFromString(QString r_string);
    void getOutputInforFromString(QString r_string);
    void getUsb1FromString(QString r_string);
    void getRs232FromString(QString r_string);
    void getRs485FromString(QString r_string);

private slots:
    void robot_ready_read(QString r_string);

signals:
    void updatedDigitalInput(QString _pin_name, bool is_on);
    void updatedAnalogInput(QString _pin_name, int is_on);
    void updatedOutputInfor(QString _pin_name, bool is_on);
    void updatedUsb1Infor(bool is_on, QString _baudrate);
    void updatedRs232Infor(bool is_on, QString _baudrate);
    void updatedRs485Infor(bool is_on, QString _baudrate);

    void updateDataToRobotTermite(QString _data);
};

#endif // TESTCIRCUITCONTROL_H
