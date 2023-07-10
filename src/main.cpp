#include <QGuiApplication>
#include <QQmlApplicationEngine>

#include <MobileUI>

/* ************************************************************************** */

int main(int argc, char *argv[])
{
    QGuiApplication app(argc, argv);

    // Application name
    app.setApplicationName("MobileUI demo");
    app.setApplicationDisplayName("MobileUI demo");
    app.setOrganizationName("emeric");
    app.setOrganizationDomain("emeric");

    // Register MobileUI
    MobileUI::registerQML();

    // Start the UI
    QQmlApplicationEngine engine;
    QQmlContext *engine_context = engine.rootContext();

    engine.load(QUrl(QStringLiteral("qrc:/qml/MobileUI.qml")));
    if (engine.rootObjects().isEmpty())
    {
        qWarning() << "Cannot init QmlApplicationEngine!";
        return EXIT_FAILURE;
    }

    return app.exec();
}

/* ************************************************************************** */
