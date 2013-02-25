#!/bin/sh

## CONFIG ##
console_path="app/console"
app_path="/var/www/html/xocellar"
## END CONFIG ##

cp=$console_path

cd $app_path

# echo $console_path

usage(){
        echo
        echo "Symfony2 App Console"
        echo "1) cache:clear"
        echo "2) router:debug"
        echo "3) generate:doctrine:entity"
        echo "4) generate:doctrine:entities"
        echo "5) doctrine:schema:update"
        echo "6) less"
}

schemaupdate() {
        $cp doctrine:schema:update --dump-sql
        read -p "Apply to database ? (y/N)" conf
        case $conf in
                y|Y)
                        $cp doctrine:schema:update --force
                        ;;
        esac
}

doctrineentities() {
        
}


r="init"
while [ -n "$r" ]; do
        usage
        read -p "Action : " r
        case $r in
                1)
                        sudo rm -Rf ${app_path}/app/cache/
                        $cp cache:clear
                        sudo chmod -R 777 ${app_path}/app/cache/
                        ;;
                2)
                        $cp router:debug
                        ;;
                3)
                        $cp generate:doctrine:entity
                        ;;
                4)
                        doctrineentities
                        ;;
                5)
                        schemaupdate
                        ;;
                6)
                        cd web/css
                        cmdless="lessc -x xocellar.less > xocellar.css"
                        echo $cmdless ...
                        $cmdless
                        ;;
        esac
done

