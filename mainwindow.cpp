#include "mainwindow.h"
#include "ui_mainwindow.h"

//#include "database.h"

MainWindow::MainWindow(QWidget *parent) :
    QMainWindow(parent),
    ui(new Ui::MainWindow)
{
//    ui->setupUi(this);
//    db.None();

//    ui->tableView->setModel(db.model);
//    ui->statusbar->showMessage(db.Table());

}

MainWindow::~MainWindow()
{
//    db.~DataBase();
//    delete ui;
}

void MainWindow::on_pushButton_3_clicked()
{
    exit(0);
}

void MainWindow::on_pushButton_2_clicked()
{
//    db.Next();
//    ui->statusbar->showMessage(db.Table());
}

void MainWindow::on_pushButton_clicked()
{
//    db.Prev();
//    ui->statusbar->showMessage(db.Table());
}

void MainWindow::on_pushButton_4_clicked()
{
//    db.Add1();
//    ui->tableView->setModel(db.model);
}

void MainWindow::on_pushButton_5_clicked()
{
//    db.Rmv1();
}

void MainWindow::on_pushButton_6_clicked()
{
    //db.getPriceSaw(2, 3);
}
