# Bash

В этой папке представлены различные скрипты, написанные на bash (для ОС Linux):

[drop](bash/drop.sh) - скрипт для сохранения видеозаписей с SD-карты\флешки на другой диск

[drop (network)](bash/drop_network.sh) - скрипт выполняет те же функции, но только диск является сетевой папкой\хранилищем

[install](bash/install.sh) - скрипт для быстрой установки пакета из репозиториев

Все скрипты запускать в терминале, предварительно перейдя в папку, в которой они находятся

Для использования в своих целях необходимо изменить некоторые пути в файле, который вам нужен 
(используется 5 вариантов пути до источника, так как видео писалось на камеру, и в зависимости от качества записи файлы сохранялись в разных местах)

drop.sh: изменить путь до резервного устройства (строки 82, 191, 201, 238, 244) и источника (строки 105, 111, 117, 123, 129). Меняете после /media/"$ME"

drop (network): изменить путь до источника (строки 102, 108, 114, 120, 126), меняете после /media/"$ME". И до резервного устройства (строки 80, 191, 201, 238, 244). 
В данном случае сетевая папка сначала монтируется в папку на локальном устройстве в домашнюю директорию. Поэтому если у вас папка для монтирования находится в другом месте (не в домашней директории), 
меняете весь путь целиком

-----------------------
