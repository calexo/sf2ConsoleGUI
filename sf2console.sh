#!/bin/sh

# sf2ConsoleGUI
# By Calexo http://www.calexo.com
# Basic interface for Symfony2 app console
# sf2ConsoleGUI is a bash script to help managing Symfony2 projects.
# GitHub : https://github.com/calexo/sf2ConsoleGUI

## CONFIG ##
console_path="php app/console"
app_path="/var/www/html/xocellar"
## END CONFIG ##

cp=$console_path

cd $app_path

usage(){
        echo
        echo "Symfony2 App Console"
        echo "1) cache:clear"
        echo "2) router:debug"
        echo "3) generate:doctrine:entity"
        echo "4) generate:doctrine:entities"
        echo "5) doctrine:schema:update"
        echo "--- User External Commands ---"
        echo "A) less"
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
        cd src
        i=0
        find . -name "*Bundle" | sed 's/[\.]//g' | while read dir
        do
                let i++
                echo "$i) $dir"
        done
        #find . -name "*Bundle" | sed 's/\/Bundle\///' | sed 's/[\/\.]//g'
        read -p "Bundle number : " bundlenum
        bundlepath=`find . -name "*Bundle" | sed 's/[\.]//g' | sed -n "${bundlenum}p"`
        bundle=`find . -name "*Bundle" | sed 's/\/Bundle\///' | sed 's/[\/\.]//g' | sed -n "${bundlenum}p"`
        #echo "Bundle $bundle"
        cd "."$bundlepath/Entity
        ls *.php | grep -v Repository | sed 's/.php//'
        cd - > /dev/null
        read -p "Entity (enter for all the Bundle) : " entity
        if [ -n "$entity" ]; then
                target="$bundle:$entity"
        else
                target=$bundle
        fi
        cd ..
        $cp generate:doctrine:entities $target
}


r="init"
while [ -n "$r" ]; do
        usage
        read -p "Action (enter=quit): " r
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
                A|a)
                        cd web/css
                        # TODO - params
                        cmdless="lessc -x xocellar.less > xocellar.css"
                        echo $cmdless ...
                        $cmdless
                        ;;
        esac
        sleep 1
done

