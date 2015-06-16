#ifndef DATABASE_H
#define DATABASE_H

#include <QQuickItem>
#include <QSqlDatabase>
#include <QSqlQuery>
#include <QtSql>
#include <QSqlError>
#include <QSqlRecord>
#include <QDebug>
#include <QFile>
#include <QFileInfo>
#include <QMessageBox>
#include <QStandardPaths>
#include <QSettings>
#include <QTableView>

class DataBase
{
public:
    QStringList list;
    QSqlTableModel *model;
    QSqlQuery query;

    DataBase();
    ~DataBase();
    void None();
    //Print();
    void Next();
    void Prev();
    void Add1();
    void Rmv1();
    QString Table();
    void LoadSettings();

    QStringList getTools();
    QStringList getDiameter();
    QStringList getMaterialDrill();
    int materialToGroupDrill(int m_num);
    float getPriceDrill(int group, int diameter);
    float getRatioValDrill(int id);
    QString getRatioDescDrill(int id);

    int materialToGroupSaw(int m_num);
    float getDrillPrice(int group, int diameter);
    QStringList getMaterialSaw();
    float getPriceSaw(int tool, int group);



private:
    QSqlDatabase dbase;
    int curtable;

};

#endif // DATABASE_H
