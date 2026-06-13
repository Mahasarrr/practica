# This Python file uses the following encoding: utf-8
import sys

from PyQt5.QtWidgets import QApplication, QWidget, QTableWidgetItem
from podcl import Connect

# Important:
# You need to run the following command to generate the ui_form.py file
#     pyside6-uic form.ui -o ui_form.py, or
#     pyside2-uic form.ui -o ui_form.py
from form2 import Ui_Widget2

class Widget2(QWidget):
    def __init__(self):
        super().__init__()
        self.ui = Ui_Widget2()
        self.ui.setupUi(self)
        self.connect=Connect()
        self.insert()
        self.ui.tabspis.clicked.connect(self.tabspis)
        self.ui.tabmesta.clicked.connect(self.tabmesta)
        self.ui.tabob.clicked.connect(self.tabob)
        self.ui.exit.clicked.connect(self.exit)

    def insert(self):
        self.connect.cur.execute('SELECT * FROM public.oborudovanie')
        headers = [desc[0] for desc in self.connect.cur.description]
        self.ui.tableWidget.setHorizontalHeaderLabels(headers)
        self.data=self.connect.cur.fetchall()
        #self.ui.tableWidget.setRowCount(len(self.data))
        #self.ui.tableWidget.setColumnCount(len(self.data[0]))
        self.ui.tableWidget.setRowCount(len(self.data))
        self.ui.tableWidget.setColumnCount(len(headers))
        self.ui.tableWidget.setHorizontalHeaderLabels(headers)
        for row_num, row_data in enumerate(self.data):
            for col_num, cell_data in enumerate(row_data):
                item=QTableWidgetItem(str(cell_data))
                self.ui.tableWidget.setItem(row_num, col_num, item)
                self.ui.tabob.setEnabled(False)

    def tabob(self):
        self.insert()
        self.ui.tabspis.setEnabled(True)
        self.ui.tabmesta.setEnabled(True)

    def tabspis(self):
        self.connect.cur.execute('SELECT * from spisannoe_oborudovanie')
        headers2 = [desc[0] for desc in self.connect.cur.description]
        self.ui.tableWidget.setHorizontalHeaderLabels(headers2)
        self.data2 = self.connect.cur.fetchall()
        #self.ui.tableWidget.setRowCount(len(self.data2))
        #self.ui.tableWidget.setColumnCount(len(self.data2[0]))
        self.ui.tableWidget.setRowCount(len(self.data2))
        self.ui.tableWidget.setColumnCount(len(headers2))
        self.ui.tableWidget.setHorizontalHeaderLabels(headers2)
        for row2_num, row2_data in enumerate(self.data2):
            for col2_num, cell2_data in enumerate(row2_data):
                item = QTableWidgetItem(str(cell2_data))
                self.ui.tableWidget.setItem(row2_num, col2_num, item)
                self.ui.tabob.setEnabled(True)
                self.ui.tabmesta.setEnabled(True)
                self.ui.tabspis.setEnabled(False)

    def tabmesta(self):
        self.connect.cur.execute('SELECT * from rabochie_mesta')
        headers3 = [desc[0] for desc in self.connect.cur.description]
        self.ui.tableWidget.setHorizontalHeaderLabels(headers3)
        self.data3 = self.connect.cur.fetchall()
        self.ui.tableWidget.setRowCount(len(self.data3))
        self.ui.tableWidget.setColumnCount(len(headers3))
        self.ui.tableWidget.setHorizontalHeaderLabels(headers3)
        #self.ui.tableWidget.setRowCount(len(self.data3))
        #self.ui.tableWidget.setColumnCount(len(self.data3[0]))
        for row3_num, row3_data in enumerate(self.data3):
            for col3_num, cell3_data in enumerate(row3_data):
                item = QTableWidgetItem(str(cell3_data))
                self.ui.tableWidget.setItem(row3_num, col3_num, item)
                self.ui.tabob.setEnabled(True)
                self.ui.tabspis.setEnabled(True)
                self.ui.tabmesta.setEnabled(False)

    def exit(self):
        self.hide()
