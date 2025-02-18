QT += charts
QT += quick
QT += serialport
QT += qml
QT += network
QT += core


# You can make your code fail to compile if it uses deprecated APIs.
# In order to do so, uncomment the following line.
#DEFINES += QT_DISABLE_DEPRECATED_BEFORE=0x060000    # disables all the APIs deprecated before Qt 6.0.0

SOURCES += \
        androidserial/qserialport.cpp \
        androidserial/qserialportinfo.cpp \
        calibrationcontrol.cpp \
        deviceport.cpp \
        devicemanager.cpp \
        main.cpp \
        movementchecker.cpp \
        robotparameter.cpp \
        DeltaKinematics.cpp \
        testcircuitcontrol.cpp

RESOURCES += qml.qrc

# Additional import path used to resolve QML modules in Qt Creator's code model
QML_IMPORT_PATH =

RC_ICONS = images/logo.ico
TARGET = Calibrator

# Additional import path used to resolve QML modules just for Qt Quick Designer
QML_DESIGNER_IMPORT_PATH =

# Default rules for deployment.
qnx: target.path = /tmp/$${TARGET}/bin
else: unix:!android: target.path = /opt/$${TARGET}/bin
!isEmpty(target.path): INSTALLS += target

DISTFILES += \
    android/AndroidManifest.xml \
    android/build.gradle \
    android/gradle.properties \
    android/gradle/wrapper/gradle-wrapper.jar \
    android/gradle/wrapper/gradle-wrapper.properties \
    android/gradlew \
    android/gradlew.bat \
    android/res/values/libs.xml \
    android/res/xml/device_filter.xml \
    android/src/org/qtproject/jniusbserial/JniUsbSerial.java \
    android/src/org/qtproject/jniusbserial/SerialInputOutputManager.java


HEADERS += \
    androidserial/qserialport.h \
    androidserial/qserialportinfo.h \
    calibrationcontrol.h \
    devicemanager.h \
    deviceport.h \
    movementchecker.h \
    robotparameter.h \
    DeltaKinematics.h \
    testcircuitcontrol.h

contains(ANDROID_TARGET_ARCH,armeabi-v7a) {
    ANDROID_PACKAGE_SOURCE_DIR = \
        $$PWD/android
}
