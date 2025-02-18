#include <QApplication>
#include <QQmlApplicationEngine>
#include <QQmlContext>
#include "devicemanager.h"
#include "movementchecker.h"
#include "robotparameter.h"
#include "testcircuitcontrol.h"
#include "calibrationcontrol.h"


int main(int argc, char *argv[])
{
#if QT_VERSION < QT_VERSION_CHECK(6, 0, 0)
    QCoreApplication::setAttribute(Qt::AA_EnableHighDpiScaling);
#endif
    DeviceManager deviceManager;
    MovementChecker movementChecker;
    movementChecker.addDevice(&deviceManager);
    RobotParameter robotParameterControl;
    robotParameterControl.addDevice(&deviceManager);
    TestCircuitControl testCircuitControl;
    testCircuitControl.addDevice(&deviceManager);
    CalibrationControl calibrationControl;
    calibrationControl.addDevice(&deviceManager);
    calibrationControl.addRobotParameter(&robotParameterControl);

    QApplication app(argc, argv);
    app.setOrganizationName("IMWI JSC");
    app.setOrganizationDomain("https://www.imwi.cc");

    QQmlApplicationEngine engine;

    engine.rootContext()->setContextProperty("deviceManager", &deviceManager);
    engine.rootContext()->setContextProperty("robotParameterControl", &robotParameterControl);
    engine.rootContext()->setContextProperty("movementChecker", &movementChecker);
    engine.rootContext()->setContextProperty("testCircuitControl", &testCircuitControl);
    engine.rootContext()->setContextProperty("calibrationControl", &calibrationControl);
    engine.rootContext()->setContextProperty("applicationDirPath", QGuiApplication::applicationDirPath());

    const QUrl url(QStringLiteral("qrc:/qml/main.qml"));
    QObject::connect(&engine, &QQmlApplicationEngine::objectCreated,
                     &app, [url](QObject *obj, const QUrl &objUrl) {
        if (!obj && url == objUrl)
            QCoreApplication::exit(-1);
    }, Qt::QueuedConnection);
    engine.load(url);

    return app.exec();
}
