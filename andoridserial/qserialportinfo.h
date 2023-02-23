#ifndef QSERIALPORTINFO_H
#define QSERIALPORTINFO_H


#include "qlist.h"
#include <QJniObject>
#include <QJniEnvironment>

class QSerialPortInfo
{
private:
    QString _portName;
    QString _device;
    QString _description;
    QString _manufacturer;
    QString _serialNumber;

    quint16 _vendorIdentifier;
    quint16 _productIdentifier;

    bool    _hasVendorIdentifier;
    bool    _hasProductIdentifier;

public:
    QSerialPortInfo();
    QSerialPortInfo(const QSerialPortInfo &other);
    QSerialPortInfo& operator=(const QSerialPortInfo &other);

    static QList<QSerialPortInfo> availablePorts();
    QString portName() const;
};

#endif // QSERIALPORTINFO_H
