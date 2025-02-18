#ifndef QSERIALPORT_H
#define QSERIALPORT_H


#include "qglobal.h"
#include <QObject>
#include <QJniObject>
#include <QJniEnvironment>
#include <QBuffer>

class QSerialPort : public QObject
{
    Q_OBJECT
public:
    enum BaudRate {
        Baud1200 = 1200,
        Baud2400 = 2400,
        Baud4800 = 4800,
        Baud9600 = 9600,
        Baud19200 = 19200,
        Baud38400 = 38400,
        Baud57600 = 57600,
        Baud115200 = 115200,
        UnknownBaud = -1
    };

    enum DataBits {
        Data5 = 5,
        Data6 = 6,
        Data7 = 7,
        Data8 = 8,
        UnknownDataBits = -1
    };

    enum Parity {
        NoParity = 0,
        EvenParity = 2,
        OddParity = 3,
        SpaceParity = 4,
        MarkParity = 5,
        UnknownParity = -1
    };

    enum StopBits {
        OneStop = 1,
        OneAndHalfStop = 3,
        TwoStop = 2,
        UnknownStopBits = -1
    };

    enum SerialPortError {
        NoError,
        DeviceNotFoundError,
        PermissionError,
        OpenError,
        WriteError,
        ReadError,
        ResourceError,
        UnsupportedOperationError,
        UnknownError,
        TimeoutError,
        NotOpenError
    };
    QSerialPort();
    bool setBaudRate(qint32 baudRate);

    void newDataArrived(char *bytesA, int lengthA);
    void exceptionArrived(QString strA);

    void stopReadThread();
    void startReadThread();

    qint64 bytesAvailable();
    QByteArray read(qint64 maxlen);
    QByteArray readAll();
    QByteArray readLine();

    bool isOpen();
    void close();
    bool open(QIODevice::OpenMode mode);
    qint64 write(const char *data, qint64 maxSize);

    void setPortName(const QString &name);
    QString portName() const;

private:
    bool isConnected;
    QString m_portName;
    qint32 m_baudRate;
    DataBits m_dataBits;
    Parity m_parity;
    StopBits m_stopBits;

    qint64 readBufferMaxSize;
    QBuffer readBuffer;
    QBuffer writeBuffer;

    bool setParameters();

signals:
    void readyRead();
    void errorOccurred(QSerialPort::SerialPortError error);
};

#endif // QSERIALPORT_H
