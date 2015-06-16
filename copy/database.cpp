#include "database.h"

DataBase::DataBase()
{
    curtable = 0; // Initialization. DO NOT REMOVE!!!
    dbase = QSqlDatabase::addDatabase("QSQLITE");

    dbase.setDatabaseName("database.sqlite");//"assets:/Samples/da_db.sqlite");//C:\\Qt\\Qt5.3.1\\Tools\\QtCreator\\bin\\DA\\da_db.sqlite");//qrc:/sources/db.sqlite");
    if(!dbase.open()){
        qDebug() << dbase.lastError().text();//"Something went wrong";
        exit(0);
    }
    qDebug() << "Connection is established";

    query = QSqlQuery(dbase);

    LoadSettings();

    model = new QSqlTableModel;
    model->setEditStrategy(QSqlTableModel::OnFieldChange);
    model->setTable(list.at(0));
    model->select();

    //#######################copying from assets
    //    QString tmpString;
    //    QString databasePath;


    //    QFile::setPermissions(databasePath, QFile::ReadOwner | QFile::WriteOwner);
    //    tmpString = QStandardPaths::writableLocation(QStandardPaths::HomeLocation);
    //    QFileInfo databaseFileInfo(QString("%1/%2").arg(tmpString).arg("2.png"));
    //    databasePath = databaseFileInfo.absoluteFilePath();

    //    QFile file("assets:/ExtraSources/2.png");
    //    QFile curfile(databasePath);//"/data/data/org.qtproject.example.DA/files/2.png");
    //    curfile.setPermissions(QFile::ReadOwner | QFile::WriteOwner);

    //    //qDebug() <<"new path is: "<<databasePath; // to display full name with path of database

    //    if ( databaseFileInfo.exists() ){
    //        qDebug() << "file is already exists, removing it.";
    //        curfile.remove();
    //    }

    //    qDebug() << "file does not exist";
    //    //bool copySuccess = QFile::copy( QString("assets:/ExtraSources/22.png"), databasePath );

    //    bool copySuccess = file.copy(databasePath);

    //    if ( !copySuccess ){
    //        qDebug() << "Error:" << "Could not copy database from 'assets' to" << databasePath;
    //        databasePath.clear();
    //    }
    //    else{
    //        qDebug() << "Success:" << "file is now located in following directory: " << databasePath;
    //        file.close();
    //        curfile.close();
    //        QFile newfile(databasePath);
    //        newfile.setPermissions(QFile::ReadOwner | QFile::WriteOwner);
    //    }

    //#######################

}

DataBase::~DataBase()
{
//    int i;
//    for(i=0; i<list.count(); i++){
//        query.exec(QString("DROP TABLE" + list.at(i)));
//    }
}

void DataBase::None()
{

}

void DataBase::Next()
{
    curtable = (curtable + 1)%(list.count());
    model->setTable(list.at(curtable));
    model->select();
    qDebug() << "curtable is " << curtable;
}

void DataBase::Prev()
{
    if(curtable)
            curtable--;
    else
        curtable = list.count() - 1;
    model->setTable(list.at(curtable));
    model->select();
    qDebug() << "curtable is " << curtable;
}

void DataBase::Add1()
{
    if(!query.exec("INSERT INTO customers VALUES(2,'Cusomer','Address', '123456');"))
        qDebug() << "db_Error: " <<query.lastError().databaseText();
}

void DataBase::Rmv1()
{
    if(!query.exec("DELETE FROM customers  WHERE address = 'Address'"))
        qDebug() << "db_Error: " <<query.lastError().databaseText();
}

QString DataBase::Table()
{
    return list.at(curtable);
}

void DataBase::LoadSettings()
{
/*    QFile check("pref_set.txt");
    if(!check.exists()){
        qDebug() << "File doesn't exist!";

        QFile props("assets:/ExtraSources/dbinitial.txt");//"dbinitial.txt");
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
            qDebug() << str;
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
    */
    //loading table names
    QFile check("pref_set.txt");
    QString str;
    check.open(QFile::ReadOnly);
    QTextStream stream(&check);
    str = stream.readLine();
    list = str.split(' ');
    check.close();
}

QStringList DataBase::getTools()
{
    QStringList list;
    QSqlQuery qr;
    qr.exec("SELECT name from tools");
    while(qr.next()){
        //qDebug() << qr.value("name");
        list.append(qr.value("name").toString());
    }

    qDebug() << list;
    return list;
}

QStringList DataBase::getDiameter()
{
    QStringList list;
    QSqlQuery qr;
    qr.exec("SELECT diameter from diameter");
    while(qr.next()){
        //qDebug() << qr.value("name");
        list.append(qr.value("diameter").toString());
    }

    qDebug() << list;
    return list;

}

QStringList DataBase::getMaterialDrill()
{
    QStringList list;
    QSqlQuery qr;
    qr.exec("SELECT name from drill_materials");
    while(qr.next()){
        //qDebug() << qr.value("name");
        list.append(qr.value("name").toString());
    }

    qDebug() << list;
    return list;
}

int DataBase::materialToGroupDrill(int m_num)
{
    int ans;
    QString str;
    QSqlQuery qr;
    str = "SELECT \"group\" FROM drill_material_group WHERE \"id material\" = " + QString::number(m_num);
    qr.prepare(str);
    qr.exec();
    qr.next();
    ans = qr.value("group").toInt();
    qDebug() << "answer: " << ans;
    return ans;
}

float DataBase::getDrillPrice(int group, int diameter)
{
    float ans;
    QString str;
    QSqlQuery qr;
    str = "SELECT \"price\" FROM drill_prices WHERE \"group\" = " + QString::number(group);
    str += " AND \"diameter\" = " + QString::number(diameter);
    qr.prepare(str);
    qr.exec();
    qr.next();
    ans = qr.value("price").toInt();
    qDebug() << "answer: " << ans;
    return ans;
}

QStringList DataBase::getMaterialSaw()
{
    QStringList list;
    QSqlQuery qr;
    qr.exec("SELECT name from saw_materials");
    while(qr.next()){
        list.append(qr.value("name").toString());
    }

    qDebug() << list;
    return list;
}

float DataBase::getPriceSaw(int tool, int group)
{
    float ans;
    QString str;
    QSqlQuery qr;
    str = "SELECT \"price\" FROM saw_prices WHERE \"id tool\" = " + QString::number(tool);
    str += " AND \"group\" = " + QString::number(group);
    qr.prepare(str);
    qr.exec();
    qr.next();
    ans = qr.value("price").toInt();
    qDebug() << "answer: " << ans;
    return ans;
}
