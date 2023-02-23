# QtAndroid-UsbSerial
Lib usbserial for Qt Android (No need root device)

JAVA Wrapper with Qt6's [QJniObject Class](https://doc.qt.io/qt-6.2/qjniobject.html)

## Quick Start

**1.** Add library to your project:

Add jitpack.io repository to your root build.gradle:
```gradle
allprojects {
    repositories {
        ...
        maven { url 'https://jitpack.io' }
    }
}
```

Starting with gradle 6.8 you can alternatively add jitpack.io repository to your settings.gradle:
```gradle
dependencyResolutionManagement {
    repositories {
        ...
        maven { url 'https://jitpack.io' }
    }
}
```

Add library to dependencies
```gradle
dependencies {
    implementation 'com.github.mik3y:usb-serial-for-android:3.4.6'
}
```

**2.** If the app should be notified when a device is attached, add 
[device_filter.xml](https://github.com/mik3y/usb-serial-for-android/blob/master/usbSerialExamples/src/main/res/xml/device_filter.xml) 
to your project's `res/xml/` directory and configure in your `AndroidManifest.xml`.

```xml
<activity
    android:name="..."
    ...>
    <intent-filter>
        <action android:name="android.hardware.usb.action.USB_DEVICE_ATTACHED" />
    </intent-filter>
    <meta-data
        android:name="android.hardware.usb.action.USB_DEVICE_ATTACHED"
        android:resource="@xml/device_filter" />
</activity>
```

**3.** Add folder [jniusbserial](https://github.com/VanThanBK/QtAndroid-UsbSerial/tree/main/android/src/org/qtproject/jniusbserial) to your project's `andorid/src/org/qtproject/` directory and [androidserial](https://github.com/VanThanBK/QtAndroid-UsbSerial/tree/main/andoridserial) to project directory.

**4.** Use it like Qt's QtSerialPort library, which is just enough for basic functions.

## Credits
The app uses the [usb-serial-for-android](https://github.com/mik3y/usb-serial-for-android) library.
