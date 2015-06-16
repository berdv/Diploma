#ifndef CHECK_H
#define CHECK_H


#include <QObject>
#include <QDebug>

class Check : public QObject
{
    Q_OBJECT
public:
    explicit Check(QObject *parent = 0);
    ~Check();
    Q_INVOKABLE bool isNum(QString str);
    Q_INVOKABLE bool isStr(QString str);

signals:

public slots:
};

#endif // CHECK_H
