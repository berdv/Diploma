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
#include <QVariantList>

class DataBase: public QObject
{
    Q_OBJECT

public:

    QStringList list;
    QSqlTableModel *model;
    QSqlQuery query;

    DataBase();
    ~DataBase();
    void None();
    void LoadSettings();

    Q_INVOKABLE QVariant getDiameter();
    Q_INVOKABLE QString idToDiameter(QVariant num);
    Q_INVOKABLE QVariant getMaterialDrill();
    Q_INVOKABLE QString idToMaterialDrill(QVariant id);
    Q_INVOKABLE int materialToGroupDrill(QVariant m_num);
    Q_INVOKABLE double getPriceDrill(QVariant group, QVariant diameter);
    Q_INVOKABLE double getRatioValDrill(QVariant id);
    Q_INVOKABLE QString getRatioDescDrill(QVariant id);

    Q_INVOKABLE QVariant getTools();
    Q_INVOKABLE QString idToTool(QVariant num);
    Q_INVOKABLE int materialToGroupSaw(QVariant m_num);
    Q_INVOKABLE QVariant getMaterialSaw();
    Q_INVOKABLE QString idToMaterialSaw(QVariant id);
    Q_INVOKABLE double getPriceSaw(QVariant tool, QVariant group);



    Q_INVOKABLE int addCustomer(QVariantList list);
    Q_INVOKABLE void addDrillBill(QVariantList list, int b_id);
    Q_INVOKABLE void addDrillExtraCost(QVariantList list, int b_id);
    Q_INVOKABLE void addDrillOrder(int o_id, int c_id);
    Q_INVOKABLE int addDrillOptions(QVariantList list);
    Q_INVOKABLE void delDrillBill(int b_id);
    Q_INVOKABLE void delOrder(int o_id);


    Q_INVOKABLE int addSawOptions(QVariantList list);
    Q_INVOKABLE void addSawBill(QVariantList list, int b_id);
    Q_INVOKABLE void addSawOrder(int o_id, int c_id);
    Q_INVOKABLE void delSawBill(int b_id);

    Q_INVOKABLE int getOrdersId();
    Q_INVOKABLE int getDrillBillId();
    Q_INVOKABLE int getSawBillId();
    Q_INVOKABLE QString getMinimumDate();
    Q_INVOKABLE QString getMaximumDate();
    Q_INVOKABLE QString getMinimumDateDrill();
    Q_INVOKABLE QString getMinimumDateSaw();
    Q_INVOKABLE QVariantList getStat(QString d1, QString d2);
    Q_INVOKABLE QVariantList getOrders(QString d1, QString d2);
    Q_INVOKABLE QVariantList getDrillBills(int o_id);
    Q_INVOKABLE QVariantList getDrillRatios(int b_id);
    Q_INVOKABLE QVariantList getSawBills(int o_id);

    Q_INVOKABLE void TruncBase();
    Q_INVOKABLE void RebuildBase();

private:
    QSqlDatabase dbase;
    int curtable;

};

#endif // DATABASE_H
