#!/bin/bash

# Envs
# ---------------------------------------------------\
PATH=$PATH:/bin:/sbin:/usr/bin:/usr/sbin:/usr/local/bin:/usr/local/sbin
SCRIPT_PATH=$(cd `dirname "${BASH_SOURCE[0]}"` && pwd) 2> /dev/null
cd $SCRIPT_PATH

# Vars
# ---------------------------------------------------\
ME=`whoami`
BACKUPS=$SCRIPT_PATH/backups
SERVER_NAME=`hostname`
SERVER_IP=`hostname -I | cut -d' ' -f1`
LOG=$SCRIPT_PATH/actions.log
DISTRO_UNAME=`uname`

# Output messages
# ---------------------------------------------------\
BLACK='\033[0;30m'
RED='\033[0;31m'
GREEN='\033[0;32m'
CYAN='\033[0;36m'
YELLOW='\033[0;33m'
PURPLE='\033[0;35m'
BLUE='\033[0;34m'
BOLD='\033[1m'
WHiTE="\e[1;37m"
NC='\033[0m'

ON_SUCCESS="DONE"
ON_FAIL="FAIL"
ON_ERROR="Oops"
ON_CHECK="✓"

Info() {
  echo "${BLUE}${2}${NC}\n"
}

Warn() {
  echo "${PURPLE}${2}${NC}\n"
}

Success() {
  echo "${GREEN}${ON_SUCCESS}${NC}\n"
}

Error () {
  echo "${RED}${BOLD}${ON_ERROR}${NC}\n"
}

Splash() {
  echo "${WHiTE} ${1}${NC}\n"
}

space() { 
  echo -e ""
}

# Start
# ---------------------------------------------------\
echo "${YELLOW}Вас приветствует программа по сохранению видеозаписей на резервный диск v3.2.1${NC}"
a=0
b=0
n=0
s=$(cat /home/"$ME"/count.txt)
echo "$((s+1))" | cat > /home/"$ME"/count.txt

read -p "mat2, pv установлены у этого пользователя? Если не знаете, ответьте no\n\нет: " req 

case "$req" in
	no|n|нет|Нет|не|Не|н|Н|No|N)
		sh "$SCRIPT_PATH/install.sh" mat2
		sh "$SCRIPT_PATH/install.sh" pv
	;;
esac

# Input values
# ---------------------------------------------------\
if [ ! -d /home/"$ME"/SG-1212-2/Видеонаблюдение ]
then
	echo ""
	Error
	echo "${CYAN}${BOLD}Вы забыли смонтировать диск для резервных копий${NC}"
	exit
fi

echo ""
echo "Коды мероприятий: "
echo " 1 - Диагностики"
echo " 2 - Итоговое собеседование"
echo " 3 - Олимпиады"
echo " 4 - Сочинение"
echo " 5 - ЕГКР"

read -p 'Введите код: ' dir

case "$dir" in
    (1)
    	echo ""
        echo "Выбрано: Диагностики"
        dir="Диагностики"
        diag='/media/"$ME"/CAM_SD/PRIVATE/AVCHD/BDMV/STREAM'
    ;;
    2)
        echo ""
        echo "Выбрано: Итоговое собеседование"
        dir="Итоговое собеседование"
        isob='/media/"$ME"/CAM_SD/DCIM'
    ;;
    3)
        echo ""
        echo "Выбрано: Олимпиады"
        dir="Олимпиады"
        olim='/media/"$ME"/CAM_SD/PRIVATE/AVCHD/BDMV/STREAM'
    ;;
    4)
		echo ""
		echo "Выбрано: Сочинение"
		dir="Сочинение"
		soch='/media/"$ME"/CAM_SD/PRIVATE/AVCHD/BDMV/STREAM'
	;;
	5)
		echo ""
		echo "Выбрано: ЕГКР"
		dir="ЕГКР"
		egkr='/media/"$ME"/CAM_SD/DCIM'
	;;
    *)
        echo "Нет такого формата!"
        Error
        exit
    ;;
esac


while [ True ]; do
	
	read -p 'Номер корпуса: ' build
	read -p 'Кабинет (номер): ' cab
	read -p 'Порядковый номер камеры в кабинете: ' cam

	if [ -z "$build" ] || [ -z "$cab" ] || [ -z "$cam" ]; then
		echo ""
		Error
		echo "${YELLOW}Вы забыли ввести номер корпуса, кабинета или камеры${NC}\n"
	else
		break
	fi
done


# File iteration
# ---------------------------------------------------\
case "$dir" in
	"Диагностики")
		cd $diag
	;;
	"Итоговое собеседование")
		cd $isob
	;;
	"Олимпиады")
		cd $olim
	;;
	"Сочинение")
		cd $soch
	;;
	"ЕГКР")
		cd $egkr
	;;
esac

if [ `ls -a | wc -l` -eq 2 ]; then echo "В директории $(pwd) нет файлов!" && exit; fi			#Check for empty directory

for FILE in *;
do
	n=$((n+1))
done
count=$n
n=$((100 / n))
proc=$n


for FILE in *;
do
	exiftool $FILE | grep Modification | sed 's/:/./g' | cat > /home/"$ME"/set.txt
	v=$(cat /home/"$ME"/set.txt | cut -c35-44)

	# Eliminating the human factor on an existing folder
	# ---------------------------------------------------\
	if [ -d  /home/"$ME"/SG-1212-2/Видеонаблюдение/"$dir"/"$v"/"$build-$cab-cam$cam" ]
	then
		echo ""
		Error
		echo "${CYAN}${BOLD}С этой камеры записи уже скинуты${NC}"
		read -p "Скрипт может перезаписать уже существующие файлы. Перезаписать? (n - создать копию, e - выйти): " sol
		case "$sol" in
			no|n|нет|Нет|не|Не|н|Н|No|N)
				cam=$((cam+1))
				 	while [ True ]; do
						if [ -f  /home/"$ME"/SG-1212-2/Видеонаблюдение/"$dir"/"$v"/"$build-$cab-cam$cam"/"S1212-$dir-$v-$build-$cab-cam$cam-00$a$b$c.MTS" ]
						then
							c=$((c+1))
						else
							break
						fi
					done
			;;
			e|E|exit|Exit|е|Е|вых|выход|Вых|Выход)
				exit
			;;
			*)
		 		break
	 		;;
		esac
	fi
done

echo ""
echo -n "${BLUE}Подаю напряжение на первичную обмотку${NC}  "
sleep 2
echo "$ON_CHECK"
echo -n "${BLUE}Подаю ток на катодную пару${NC}  "
sleep 3
echo "$ON_CHECK"
echo "${BLUE}Обесточиваю город...${NC}"

for FILE in *;
do

	# Extracting metadata from a file
	# ---------------------------------------------------\
	exiftool $FILE | grep Modification | sed 's/:/./g' | cat > /home/"$ME"/set.txt
	v=$(cat /home/"$ME"/set.txt | cut -c35-44)

	c=$((c+1))

	mkdir -p /home/"$ME"/SG-1212-2/Видеонаблюдение/"$dir"/"$v"/"$build"-"$cab"-cam"$cam"
	
	echo ""
	echo "Копирование файла $c/$count  "

	#Without progress bar: #cp $FILE /media/ctc/Seagate\ Backup\ Plus\ Drive/Видеонаблюдение/"$dir"/"$v"/"$build"-"$cab"-cam"$cam"/"S1212-$dir-$v-$build-$cab-cam$cam-00$a$b$c.MTS"
	echo "Прогресс файла:"; pv -ptrW $FILE >  /home/"$ME"/SG-1212-2/Видеонаблюдение/"$dir"/"$v"/"$build"-"$cab"-cam"$cam"/"S1212-$dir-$v-$build-$cab-cam$cam-00$a$b$c.MTS"
	
	echo -n "Общий прогресс: "
	if [ $n -le 20 ];	then
		echo "[===                 ] $n%"
	elif [ $n -le 40 ]; then
		echo "[======              ] $n%"
	elif [ $n -le 60 ]; then
		echo "[==========          ] $n%"
	elif [ $n -le 80 ]; then
		echo "[=============       ] $n%"
	elif [ $n -le 95 ]; then
		echo "[================    ] $n%"
	else
		echo "[====================] 100%"
	fi
	n=$((n+proc))


	# Counter capacity
	# ---------------------------------------------------\
	if [ $c -eq 9 ];
	then
		b=$((b+1))
		c=0
		echo "$ON_CHECK"
	elif [ $b -eq 9 ]; then
		a=$((a+1))
		b=0
		echo "$ON_CHECK"
	fi

done

Success
echo "$((s%2+1)) запуск\n"

SCRIPT_PATH=$(cd `dirname "${BASH_SOURCE[0]}"` && pwd) 2> /dev/null
cd $SCRIPT_PATH > /dev/null
aplay -q ~/Ready.wav


