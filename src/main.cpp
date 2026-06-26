#include <QGuiApplication>
#include <QQmlApplicationEngine>
#include <QQmlContext>

int main(int argc, char *argv[])
{
    QGuiApplication app(argc, argv);

    // Application name
    app.setApplicationName("MobileUI demo");
    app.setApplicationDisplayName("MobileUI demo");
    app.setOrganizationName("emeric");
    app.setOrganizationDomain("emeric");

#ifdef Q_OS_ANDROID
    // Expose the Android SDK version (API level) to QML
    const int androidSdkVersion = QNativeInterface::QAndroidApplication::sdkVersion();
#else
    const int androidSdkVersion = 0;
#endif

    // Start the UI
    QQmlApplicationEngine engine;
    engine.rootContext()->setContextProperty("androidSdkVersion", androidSdkVersion);
    engine.loadFromModule("MobileUI_demo", "MobileApplication");

    if (engine.rootObjects().isEmpty())
    {
        qWarning() << "Cannot init QmlApplicationEngine!";
        return EXIT_FAILURE;
    }

    return app.exec();
}
