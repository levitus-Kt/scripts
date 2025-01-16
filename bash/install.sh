#!/bin/bash


PACKAGE=``
if [ -n "$1" ]  #Checks the length of the first parameter value. If the length becomes zero, outputs False
then
    PACKAGE="$1"
else
    echo -n "Введите название пакета: " && read PACKAGE
fi

echo ""
echo " 1 - apt-get"
echo " 2 - apt"
echo " 3 - pip"
echo " 4 - dnf"
echo " 5 - yum"

read -p 'Выберите пакетный менеджер: ' PS3

case $PS3 in
    1) sudo apt-get install $PACKAGE ;;
    2) sudo apt install $PACKAGE ;;
    3) sudo pip install $PACKAGE ;;
    4) sudo dnf install $PACKAGE;;
    5) sudo yum install $PACKAGE;;
esac