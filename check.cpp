#include "check.h"

Check::Check(QObject *parent) : QObject(parent)
{

}

Check::~Check()
{

}

bool Check::isNum(QString str)
{
    QStringList list = str.split('.');
    int cnt = list.count();
    int i;
    for(i=0; i<cnt; i++)
        if(list.at(i) == "")
            return false;
    if(str.toDouble() == 0)
        return false;
    return true;
}

bool Check::isStr(QString str)
{
    QStringList list = str.split(' ');
    int cnt = list.count();
    int i;
    for(i=0; i<cnt; i++)
        if(list.at(i) == "")
            return false;
    return true;
}

