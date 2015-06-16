#include <QApplication>
#include <QQmlApplicationEngine>

#include "database.h"
#include "check.h"

#include "mainwindow.h" //~!

int main(int argc, char *argv[])
{
    QApplication app(argc, argv);

    /*DataBase *db = new DataBase();
    db->None();*/ //to get rid of warning
    qmlRegisterType<DataBase>("DB", 1, 0, "DataBase"); //registration of a new type for QML
    qmlRegisterType<Check>("DB", 1, 0, "Check");
    QQmlApplicationEngine engine;
    engine.load(QUrl(QStringLiteral("qrc:/main.qml")));

//    MainWindow w; //~!
//    w.show(); //~!

    return app.exec();
}
