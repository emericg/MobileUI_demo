/*!
 * COPYRIGHT (C) 2023 Emeric Grange - All Rights Reserved
 *
 * This program is free software: you can redistribute it and/or modify
 * it under the terms of the GNU General Public License as published by
 * the Free Software Foundation, either version 3 of the License, or
 * (at your option) any later version.
 *
 * This program is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 * GNU General Public License for more details.
 *
 * You should have received a copy of the GNU General Public License
 * along with this program.  If not, see <http://www.gnu.org/licenses/>.
 *
 * \date      2023
 * \author    Emeric Grange <emeric.grange@gmail.com>
 */

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
