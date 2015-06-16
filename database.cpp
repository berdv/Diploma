#include "database.h"

DataBase::DataBase()
{
    curtable = 0; // Initialization. DO NOT REMOVE!!!
    dbase = QSqlDatabase::addDatabase("QSQLITE");

    dbase.setDatabaseName("database.sqlite");
    if(!dbase.open()){
        qDebug() << "DB_OPEN ERROR: " << dbase.lastError().text();
        exit(0);
    }
    qDebug() << "Connection is established";

    query = QSqlQuery(dbase);

    LoadSettings();

    model = new QSqlTableModel;
    model->setEditStrategy(QSqlTableModel::OnFieldChange);
    model->setTable(list.at(0));
    model->select();
}

DataBase::~DataBase() { }

void DataBase::None() { }

void DataBase::LoadSettings()
{
    QFile check("pref_set.txt");

//    if(check.exists()){
//        check.remove();
//        exit(0);
//    }

    if(!check.exists()){
        qDebug() << "File doesn't exist!";

        //QFile props("dbinitial.txt");
        QFile props("assets:/ExtraSources/dbinitial.txt");
        props.open(QFile::ReadOnly);
        QTextStream stream (&props);
        QString str;

        QStringList str_list;
        str = stream.readLine();

        while(!str.isNull()){
            str_list = str.split(' ');
            if(str_list.at(0) == "CREATE" && str_list.at(1) == "TABLE")
                list.append(str_list.at(2));
            if(!query.exec(str))        {
                qDebug() << str << "db_Error: " <<query.lastError().databaseText();
            }
            str = stream.readLine();
        }

        props.close();
        check.open(QFile::ReadWrite);
        QTextStream w_stream (&check);

        str = "";
        for(int i=0; i<list.count(); i++){
            if(i)
                str += " ";
            str += list.at(i);
        }
            w_stream << str;
            check.close();
    }
    else{
        qDebug() << "File exists!";
        QString str;
        check.open(QFile::ReadOnly);
        QTextStream stream(&check);
        str = stream.readLine();
        list = str.split(' ');
        check.close();
    }

    //loading table names
    /*
    QFile check("pref_set.txt");
    QString str;
    check.open(QFile::ReadOnly);
    QTextStream stream(&check);
    str = stream.readLine();
    list = str.split(' ');
    check.close(); */
}

void appendStringToListofMaps(const QString& s, QVariantList& list)
{
    QVariantMap map;
    map["text"] = s;
    list.append(map);
}

QVariant DataBase::getTools()
{
    QVariantList list;
    QSqlQuery qr;
    qr.exec("SELECT name from tools");
    while(qr.next())
        appendStringToListofMaps(qr.value("name").toString(), list);

    return list;
}

QString DataBase::idToTool(QVariant num)
{
    QString ans;
    QString str;
    QSqlQuery qr;
    str = "SELECT \"name\" from \"tools\" WHERE \"id tool\" = " + QString::number(num.toInt() + 1);
    qr.prepare(str);
    qr.exec();
    qr.next();
    ans = qr.value("name").toString();
    return ans;
}

QString DataBase::idToMaterialSaw(QVariant id)
{
    QString str, ans;
    QSqlQuery qr;
    str = "SELECT \"name\" FROM saw_materials WHERE \"id material\" = " + QString::number(id.toInt() + 1);
    qr.prepare(str);
    qr.exec();
    qr.next();
    ans = qr.value("name").toString();
    return ans;
}

int DataBase::materialToGroupSaw(QVariant m_num)
{
    int ans;
    QString str;
    QSqlQuery qr;
    str = "SELECT \"group\" FROM saw_material_group WHERE \"id material\" = " + QString::number(m_num.toInt() + 1);
    qr.prepare(str);
    qr.exec();
    qr.next();
    ans = qr.value("group").toInt();
    return ans;
}

QVariant DataBase::getDiameter()
{
   QVariantList list;
   QSqlQuery qr;
   qr.exec("SELECT diameter from diameter");
   while(qr.next()){
       appendStringToListofMaps(qr.value("diameter").toString(), list);//list.append(qr.value("diameter").toString());
   }

   return list;
}

QString DataBase::idToDiameter(QVariant num)
{
    QString str, ans;
    QSqlQuery qr;
    str = "SELECT diameter FROM diameter";
    qr.prepare(str);
    qr.exec();
    qr.next();
    for(int i=1; i<=num.toInt(); i++)
        qr.next();

    ans = qr.value("diameter").toString();
    return ans;
}

QVariant DataBase::getMaterialDrill()
{
    QVariantList list;
    QSqlQuery qr;
    qr.exec("SELECT name from drill_materials");
    while(qr.next()){
        appendStringToListofMaps(qr.value("name").toString(), list);
    }

    return list;
}

QString DataBase::idToMaterialDrill(QVariant id)
{
    QString str, ans;
    QSqlQuery qr;
    str = "SELECT \"name\" FROM drill_materials WHERE \"id material\" = " + QString::number(id.toInt() + 1);
    qr.prepare(str);
    qr.exec();
    qr.next();
    ans = qr.value("name").toString();
    return ans;
}

int DataBase::materialToGroupDrill(QVariant m_num)//(int m_num)
{
    int ans;
    QString str;
    QSqlQuery qr;
    str = "SELECT \"group\" FROM drill_material_group WHERE \"id material\" = " + QString::number(m_num.toInt() + 1);
    qr.prepare(str);
    qr.exec();
    qr.next();
    ans = qr.value("group").toInt();
    return ans;
}

double DataBase::getPriceDrill(QVariant group, QVariant diameter)
{
    double ans;
    QString str;
    QSqlQuery qr;
    //значение группы будет получено из базы, не нужно инкрементировать
    str = "SELECT \"price\" FROM drill_prices WHERE \"group\" = " + QString::number(group.toInt());
    str += " AND \"diameter\" = " + QString::number(diameter.toInt());
    qr.prepare(str);
    qr.exec();
    qr.next();
    ans = qr.value("price").toDouble();
    return ans;
}

double DataBase::getRatioValDrill(QVariant id)
{
    double ans = 1.0;
    QString str;
    QSqlQuery qr;
    str = "SELECT \"default value\" FROM drill_ratio WHERE \"id ratio\" = " + QString::number(id.toInt());
    qr.prepare(str);
    qr.exec();
    qr.next();
    ans = qr.value("default value").toDouble() * 1.0;
    return ans;
}

QString DataBase::getRatioDescDrill(QVariant id)
{
    QString ans;
    QString str;
    QSqlQuery qr;
    str = "SELECT \"description\" FROM drill_ratio WHERE \"id ratio\" = " + QString::number(id.toInt() + 1);
    qr.prepare(str);
    qr.exec();
    qr.next();
    ans = qr.value("description").toString();
    return ans;
}

QVariant DataBase::getMaterialSaw()
{
    QVariantList list;
    QSqlQuery qr;
    qr.exec("SELECT name from saw_materials");
    while(qr.next()){
        appendStringToListofMaps(qr.value("name").toString(), list);//list.append(qr.value("name").toString());
    }

    return list;
}

double DataBase::getPriceSaw(QVariant tool, QVariant group)
{
    double ans;
    QString str;
    QSqlQuery qr;
    str = "SELECT \"price\" FROM saw_prices WHERE \"id tool\" = " + QString::number(tool.toInt() + 1);
    str += " AND \"group\" = " + QString::number(group.toInt());
    qr.prepare(str);
    qr.exec();
    qr.next();
    ans = qr.value("price").toDouble();
    return ans;
}

int DataBase::addCustomer(QVariantList list)
{
    int id = 0, cnt, new_id;
    QString str;
    QSqlQuery qr;
    str = "SELECT count(\"id customer\") FROM customers WHERE \"name\" = '" + list.at(0).toString();
    str += "' AND \"address\" = '"  + list.at(1).toString();
    str += "' AND \"phone\" = '"  + list.at(2).toString() + "';";
    qr.prepare(str);
    qr.exec();
    qr.next();
    cnt = qr.value("count(id customer)").toInt();
    if(cnt == 0){

        str = "SELECT count(\"id customer\") FROM customers";
        qr.prepare(str);
        qr.exec();
        qr.next();
        new_id = qr.value("count(id customer)").toInt() + 1;

        str = "INSERT INTO customers VALUES('" + QString::number(new_id) + "', '" + list.at(0).toString() + "', ";
        str +="'" + list.at(1).toString() + "', ";
        str +="'" + list.at(2).toString() + "');";
        qr.exec(str);
        return new_id;
    }
    else{

        str = "SELECT \"id customer\" FROM customers WHERE \"name\" = '" + list.at(0).toString();
        str+= "' AND \"address\" = '"  + list.at(1).toString();
        str += "' AND \"phone\" = '"  + list.at(2).toString() + "';";
        qr.prepare(str);
        qr.exec();
        qr.next();
        id = qr.value("id customer").toInt();
        return id;
    }
}

int DataBase::getDrillBillId()
{
    int count;
    int id;
    QString str;
    QSqlQuery qr;
    qr.exec("SELECT count(*) FROM drill_bill");
    qr.next();
    count = qr.value("count(*)").toInt();
    if(!count){
        return 1;
    }
    else{
        str = "SELECT MAX(\"id bill\") FROM drill_bill";
        qr.exec(str);
        qr.next();
        id = qr.value("MAX(id bill)").toInt() + 1;
        return id;
    }

}

int DataBase::getOrdersId()
{
    QString str;
    QSqlQuery qr;
    int o_id;
    str = "select max(\"id order\") from orders";
    qr.exec(str);
    qr.next();
    o_id = qr.value("max(id order)").toInt() + 1;

    return o_id;
}

int DataBase::getSawBillId()
{
    int count;
    int id;
    QString str;
    QSqlQuery qr;
    qr.exec("SELECT count(*) FROM saw_bill");
    qr.next();
    count = qr.value("count(*)").toInt();
    if(!count){
        return 1;
    }
    else{
        str = "SELECT MAX(\"id bill\") FROM saw_bill";
        qr.exec(str);
        qr.next();
        id = qr.value("MAX(id bill)").toInt() + 1;
        return id;
    }
}

void DataBase::addDrillBill(QVariantList list, int b_id)
{
    QString str;
    QSqlQuery qr;
    double price;
    int group;

    group = materialToGroupDrill(list.at(3));
    price = getPriceDrill(group, list.at(0));
    price = price * list.at(1).toDouble() * list.at(2).toDouble();

    str = "INSERT INTO drill_bill VALUES('" + QString::number(b_id) + "', '";
    str += list.at(0).toString() + "', '";
    str += list.at(1).toString() + "', '";
    str += QString::number(group) + "', '";
    str += list.at(2).toString() + "', '";
    str += QString::number(price) + "');"; //*list.at(1).toDouble()*list.at(2).toDouble()


    qr.exec(str);
}

void DataBase::addDrillExtraCost(QVariantList list, int b_id)
{
    int i;
    QSqlQuery qr;
    QString str;
    i=0;

    while(i < list.count()){
        str = "INSERT INTO drill_extra_cost VALUES('" + QString::number(b_id) + "', '";
        str += list.at(i).toString() + "', '";
        str += list.at(i+1).toString() + "', '";
        str += list.at(i+2).toString() + "');";

        qr.exec(str);
        i+=3;
    }
}

void DataBase::addDrillOrder(int o_id, int c_id)
{
    double price, price_sum = 0, ec_v;//, depth;
    double cons = 0;
    int order_id;//, am;
    QSqlQuery qr, qr_p, qr_ec;
    QString str;
    QDateTime current = QDateTime::currentDateTime();

    str = "SELECT \"id bill\" FROM drill_options WHERE \"id options\" = " + QString::number(o_id);
    qr.exec(str);
    while(qr.next()){ //getting id_bill from current order

        str = "SELECT * FROM drill_bill WHERE \"id bill\" = " + qr.value("id bill").toString();
        qr_p.exec(str);
        qr_p.next();
//        double diam, depth, am, gr;
//        diam = qr_p.value("diameter").toDouble();
//        depth = qr_p.value("depth").toDouble();
//        am = qr_p.value("amount").toDouble();
//        gr = qr_p.value("group").toDouble();
        price = qr_p.value("price").toDouble();

        //price = price * am * depth;

        str = "SELECT \"value\" FROM drill_extra_cost WHERE \"id bill\" = " + qr.value("id bill").toString();
        qr_ec.exec(str);
        ec_v = 1.0;
        while(qr_ec.next()){
            ec_v = ec_v + (qr_ec.value("value").toDouble() - 1);
        }

//        qDebug() << "Отверстие: (/)" << diam << "  [" << depth << " x " << am << "] - " << gr;
//        qDebug() <<"Количество см: " << depth*am << " с суммарным коэффициентом " << ec_v;
        qDebug() <<"Цена: " << price << " итог: " << price*ec_v;
        price_sum = price_sum + price*ec_v;
        cons = cons + price*0.8;
    }

    if(price_sum < 3000)
        price_sum = 3000;

    qDebug() << "Итоговая стоимость: " << price_sum;
//    qDebug() << "ID заказчика: " << c_id;
//    qDebug() <<"Дата: " << current.toString("yyyy-MM-dd") << "\n";

    order_id = getOrdersId();
    cons = cons/16;

    str = "INSERT INTO orders VALUES('" + QString::number(order_id) + "', '";
    str += QString::number(o_id) + "', '";
    str += QString::number(c_id) + "', '";
    str += QString::number(cons) + "', '"; //consumables
    str += QString::number(price_sum) + "', '";
    str += QString::number(price_sum*0.2) + "', '"; //salary
    str += current.toString("yyyy-MM-dd") + "', '";
    str += "0');"; //0 for drill order

    qr.exec(str);
}

int DataBase::addDrillOptions(QVariantList list)
{
    QString str;
    int opt_id = 0, i;
    QSqlQuery qr;


    str = "select MAX(\"id options\") from drill_options";
    qr.exec(str);
    qr.next();
    opt_id = qr.value("MAX(id options)").toInt() + 1;

    for(i=0; i<list.count(); i++){
        str = "INSERT INTO drill_options VALUES(" + QString::number(opt_id) + ", ";
        str += list.at(i).toString() + ");";
        qr.exec(str);
    }

    return opt_id;
}

void DataBase::delDrillBill(int b_id)
{
    QSqlQuery qr;
    QString str;
    str = "DELETE FROM drill_bill WHERE \"id bill\" = " + QString::number(b_id);
    qr.exec(str);
    str = "DELETE FROM drill_options WHERE \"id bill\" = " + QString::number(b_id);
    qr.exec(str);
    str = "DELETE FROM drill_extra_cost WHERE \"id bill\" = " + QString::number(b_id);
    qr.exec(str);
}

void DataBase::delOrder(int o_id)
{
    QSqlQuery qr;
    QString str;
    str = "DELETE FROM orders WHERE \"id order\" = " + QString::number(o_id);
    qr.exec(str);
}

int DataBase::addSawOptions(QVariantList list)
{
    QString str;
    int opt_id = 0, i;
    QSqlQuery qr;


    str = "select MAX(\"id options\") from saw_options";
    qr.exec(str);
    qr.next();
    opt_id = qr.value("MAX(id options)").toInt() + 1;

    for(i=0; i<list.count(); i++){
        str = "INSERT INTO saw_options VALUES(" + QString::number(opt_id) + ", ";
        str += list.at(i).toString() + ");";
        qr.exec(str);
    }

    return opt_id;
}

void DataBase::addSawBill(QVariantList list, int b_id)
{
    QString str;
    QSqlQuery qr;
    double price;
    double depth, length, area;
    int tool = list.at(5).toInt() + 1;
    int group = materialToGroupSaw(list.at(6));
    depth = list.at(0).toDouble();
    length = list.at(1).toDouble();
    area = depth * length / 10000;

    qDebug() << "id tool: " << tool << " group: " << group;

    price = getPriceSaw(tool, group) * area /*m to cm*/;

    str = "INSERT INTO saw_bill VALUES('" + QString::number(b_id) + "', '";

    str += QString::number(depth) + "', '"; //depth
    str += QString::number(length) + "', '"; //length
    str += QString::number(area) + "', '"; //area
    str += list.at(3).toString() + "', '"; //amount
    str += list.at(4).toString() + "', '"; //two_sided
    str += QString::number(tool) + "', '"; //id tool
    str += QString::number(group) + "', '"; //group
    if(list.at(7).toString() == "true"){
        str += list.at(8).toString() + "', '"; //ratio
        str += list.at(9).toString() + "', '"; //comment
    }
    else
        str += "1', '', '";
    str += QString::number(price) + "');"; //price

   qr.exec(str);
}

void DataBase::addSawOrder(int o_id, int c_id)
{
    double price, price_sum = 0, depth, am, ratio_val;
    //int tool; double length;
    double cons;
    int order_id;
    QSqlQuery qr, qr_p;
    QString str;
    QDateTime current = QDateTime::currentDateTime();

    str = "SELECT \"id bill\" FROM saw_options WHERE \"id options\" = " + QString::number(o_id);
    qr.exec(str);
    while(qr.next()){ //getting id_bill from current order

        str = "SELECT * FROM saw_bill WHERE \"id bill\" = " + qr.value("id bill").toString();
        qr_p.exec(str);
        qr_p.next();

        double area, gr, length;
        depth = qr_p.value("depth").toDouble();
        length = qr_p.value("length").toDouble();
        area = qr_p.value("area").toDouble();
        am = qr_p.value("amount").toInt();
        gr = qr_p.value("group").toInt();
        //tool = qr_p.value("id tool").toDouble();
        ratio_val = qr_p.value("ratio").toDouble();
        price = qr_p.value("price").toDouble();

        price = price * am;
        cons = cons + price;

        qDebug() << "Отверстие: " << "  [" << depth << " x " << length << " <" << am << ">] - " << gr;
        qDebug() <<"проем кв.м " << area << " с суммарным коэффициентом " << ratio_val;
        qDebug() <<"Цена: " << price << " итог: " << price*ratio_val;
        qDebug() << "Цена за проем: " << price*ratio_val/am;
        price_sum = price_sum + price*ratio_val;
    }

    if(price_sum < 3000)
        price_sum = 3000;

    cons = cons/13;
    qDebug() << "Итоговая стоимость: " << price_sum;    
    qDebug() << "ID заказчика: " << c_id;
    qDebug() <<"Дата: " << current.toString("yyyy-MM-dd") << "\n";

    order_id = getOrdersId();

    str = "INSERT INTO orders VALUES('" + QString::number(order_id) + "', '";
    str += QString::number(o_id) + "', '";
    str += QString::number(c_id) + "', '";
    str += QString::number(cons) + "', '"; //consumables
    str += QString::number(price_sum) + "', '";
    str += QString::number(price_sum*0.2) + "', '"; //salary
    str += current.toString("yyyy-MM-dd") + "', '";
    str +="1');"; //1 for saw order

    qr.exec(str);

}

void DataBase::delSawBill(int b_id)
{
    QSqlQuery qr;
    QString str;
    str = "DELETE FROM saw_bill WHERE \"id bill\" = " + QString::number(b_id);
    qr.exec(str);
    str = "DELETE FROM saw_options WHERE \"id bill\" = " + QString::number(b_id);
    qr.exec(str);
}

QString DataBase::getMinimumDate()
{
    //SELECT * FROM drill_order, saw_order ORDER BY date ASC
    QString str, ans;
    QSqlQuery qr;
    str = "select min(date) from orders";
    qr.prepare(str);
    qr.exec();
    qr.next();
    ans = qr.value("min(date)").toString();
    if(ans == ""){
        QDateTime current = QDateTime::currentDateTime();
        return current.toString("yyyy-MM-dd");
    }
    return ans;

}

QString DataBase::getMaximumDate()
{
    QString str, ans;
    QSqlQuery qr;
    str = "select max(date) from orders";
    qr.prepare(str);
    qr.exec();
    qr.next();
    ans = qr.value("max(date)").toString();
    if(ans == ""){
        QDateTime current = QDateTime::currentDateTime();
        return current.toString("yyyy-MM-dd");
    }
    return ans;
}

QString DataBase::getMinimumDateDrill()
{
    //SELECT * FROM drill_order, saw_order ORDER BY date ASC
    QString str, ans;
    QSqlQuery qr;
    str = "select min(date) from orders WHERE type = 0";
    qr.prepare(str);
    qr.exec();
    qr.next();
    ans = qr.value("min(date)").toString();
    if(ans == ""){
        QDateTime current = QDateTime::currentDateTime();
        return current.toString("yyyy-MM-dd");
    }

    return ans;

}

QString DataBase::getMinimumDateSaw()
{
    QString str, ans;
    QSqlQuery qr;
    str = "select min(date) from orders WHERE type = 1";
    qr.prepare(str);
    qr.exec();
    qr.next();
    ans = qr.value("min(date)").toString();
    if(ans == ""){
        QDateTime current = QDateTime::currentDateTime();
        return current.toString("yyyy-MM-dd");
    }
    return ans;
}

QVariantList DataBase::getStat(QString d1, QString d2)
{
    QVariantList list;
    QString s, f, str;
    QSqlQuery qr;
    double dc_s = 0, dp_s = 0, ds_s = 0;
    if(d1 == "")
        s = "2000-01-01";
    else
        s = d1;
    if(d2 == "")
        f = "3000-01-01";
    else
        f = d2;

    str = "select count(*) from orders WHERE type = 0 AND date BETWEEN '" + s + "' AND '" + f + "';";
    qr.exec(str);
    qr.next();
    qr.value("count(*)").toInt();
    list.append(qr.value("count(*)").toInt()); //0

    str = "select count(*) from orders WHERE type = 1 AND date BETWEEN '" + s + "' AND '" + f + "';";
    qr.exec(str);
    qr.next();
    qr.value("count(*)").toInt();

    list.append( qr.value("count(*)").toInt()); //1

    str = "SELECT * FROM orders WHERE type = 0 AND date BETWEEN '" + s + "' AND '" + f + "';";
    qr.exec(str);
    while(qr.next()){
        dc_s = dc_s + qr.value("consumables").toDouble();
        dp_s = dp_s + qr.value("price").toDouble();
        ds_s = ds_s + qr.value("salary").toDouble();
    }

    list.append(dc_s); //2
    list.append(dp_s); //3
    list.append(ds_s); //4

    double sc_s = 0, sp_s = 0, ss_s = 0;

    str = "SELECT * FROM orders WHERE type = 1 AND date BETWEEN '" + s + "' AND '" + f + "';";
    qr.exec(str);
    while(qr.next()){
        sc_s = sc_s + qr.value("consumables").toDouble();
        sp_s = sp_s + qr.value("price").toDouble();
        ss_s = ss_s + qr.value("salary").toDouble();
    }

    list.append(sc_s); //5
    list.append(sp_s); //6
    list.append(ss_s); //7

    list.append(sc_s + dc_s); //8
    list.append(sp_s + dp_s); //9
    list.append(ss_s + ds_s); //10
    return list;
}

QVariantList DataBase::getOrders(QString d1, QString d2)
{
    QVariantList list;
    QString s, f, str, str2;
    QSqlQuery qr, qr2;
    int count;
    if(d1 == "")
        s = "2000-01-01";
    else
        s = d1;
    if(d2 == "")
        f = "3000-01-01";
    else
        f = d2;

    str = "select * from orders WHERE date BETWEEN '" + s + "' AND '" + f + "';";

    qr.exec(str);
    while(qr.next()){
        list.append(qr.value("id order").toInt()); //0
        list.append(qr.value("id options").toInt()); //1
        list.append(qr.value("id customer").toInt()); //2
        list.append(qr.value("consumables").toDouble()); //3
        list.append(qr.value("price").toDouble()); //4
        list.append(qr.value("salary").toDouble()); //5
        list.append(qr.value("date").toString()); //6
        list.append(qr.value("type").toInt()); //7
        if(qr.value("type").toInt() == 0){
            str2 = "select count(*) from drill_options where \"id options\" = " + qr.value("id options").toString();
        }
        else{
            str2 = "select count(*) from saw_options where \"id options\" = " + qr.value("id options").toString();
        }
        qr2.exec(str2);
        qr2.next();
        count = qr2.value("count(*)").toInt();
        list.append(count); //8
    }
    return list;
}

QVariantList DataBase::getDrillBills(int o_id)
{
    int i;
    QVariantList bills, list;
    QString str;
    QSqlQuery qr;

    str = "select \"id bill\" from drill_options";
    str += " where \"id options\" = " + QString::number(o_id);
    qr.prepare(str);
    qr.exec();
    while(qr.next()){
        bills.append(qr.value("id bill").toInt());
    }
    //~~~~~~~~~~~ now we got all bills
    if(bills.count() == 0)
        return list;

    str = "select * from drill_bill where \"id bill\" IN (";
    for(i=0; i<bills.count(); i++){
        if(i)
            str += ", ";
        str += bills.at(i).toString();
    }
    str += ")";

    qr.prepare(str);
    qr.exec();
    while(qr.next()){
        list.append(qr.value("id bill").toInt()); //0
        list.append(qr.value("diameter").toInt()); //1
        list.append(qr.value("depth").toDouble()); //2
        list.append(qr.value("group").toInt()); //3
        list.append(qr.value("amount").toInt()); //4
        list.append(qr.value("price").toDouble()); //5
    }

    return list;
}

QVariantList DataBase::getDrillRatios(int b_id)
{
    QVariantList list;
    QString str;
    QSqlQuery qr, qr2;
    str = "select * from drill_extra_cost WHERE \"id bill\" = " + QString::number(b_id);
    qr.prepare(str);
    qr.exec();
    while(qr.next()){
        str = "SELECT \"description\" FROM drill_ratio WHERE \"id ratio\" = " +  qr.value("id ratio").toString();;
        qr2.prepare(str); qr2.exec(); qr2.next();

        list.append(qr2.value("description").toString());
        list.append(qr.value("value").toDouble());
        list.append(qr.value("comment").toString());
    }

    return list;

}

QVariantList DataBase::getSawBills(int o_id)
{
    int i;
    QVariantList bills, list;
    QString str;
    QSqlQuery qr;

    str = "select \"id bill\" from saw_options where \"id options\" = " + QString::number(o_id);
    qr.prepare(str);
    qr.exec();
    while(qr.next()){
        bills.append(qr.value("id bill").toInt());
    }
    //~~~~~~~~~~~ now we got all bills

    if(bills.count() == 0)
        return list;

    str = "select * from saw_bill where \"id bill\" IN (";
    for(i=0; i<bills.count(); i++){
        if(i)
            str += ", ";
        str += bills.at(i).toString();
    }
    str += ")";

    qr.prepare(str);
    qr.exec();
    while(qr.next()){
        list.append(qr.value("id bill").toInt()); //0
        list.append(qr.value("depth").toDouble()); //1
        list.append(qr.value("length").toDouble()); //2
        list.append(qr.value("area").toDouble()); //3
        list.append(qr.value("amount").toInt()); //4
        list.append(qr.value("two-sided access").toString()); //5
        list.append(qr.value("id tool").toInt()); //6
        list.append(qr.value("group").toInt()); //7
        list.append(qr.value("ratio").toDouble()); //8
        list.append(qr.value("comment").toString()); //9
        list.append(qr.value("price").toDouble()); //10
    }

    return list;
}

void DataBase::TruncBase()
{
    QString str;
    QSqlQuery qr;
    str = "TRUNCATE TABLE drill_order"; qr.exec(str);
    str = "TRUNCATE TABLE drill_bill"; qr.exec(str);
    str = "TRUNCATE TABLE drill_options"; qr.exec(str);
    str = "TRUNCATE TABLE drill_extra_cost"; qr.exec(str);
    str = "TRUNCATE TABLE saw_order"; qr.exec(str);
    str = "TRUNCATE TABLE saw_bill"; qr.exec(str);
    str = "TRUNCATE TABLE saw_options"; qr.exec(str);
}

void DataBase::RebuildBase()
{
    QFile check("pref_set.txt");
    check.remove();
    LoadSettings();
}
