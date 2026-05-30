#include <QGuiApplication>
#include <QQmlApplicationEngine>

int main(int argc, char *argv[])
{
    QGuiApplication app(argc, argv);

    // Application name
    app.setApplicationName("MobileUI demo");
    app.setApplicationDisplayName("MobileUI demo");
    app.setOrganizationName("emeric");
    app.setOrganizationDomain("emeric");

    // Start the UI
    QQmlApplicationEngine engine;

    engine.loadFromModule("MobileUI_demo", "MobileApplication");

    if (engine.rootObjects().isEmpty())
    {
        qWarning() << "Cannot init QmlApplicationEngine!";
        return EXIT_FAILURE;
    }

    return app.exec();
}
