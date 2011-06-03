#!/bin/bash

# $1 is the action (menu, append_list, custom, remove, clean, show, list, quit)
# $2 is the filename
# $NFNAME is the new file name
# $LFILE holds available labels

# $XLBL will be used to store exported label
# $NEW_XLBL will be used to store new label to be inserted


ACTION="$1"
FNAME="$2"
NFNAME="/tmp/editlabels-`basename "$2"`.$$"
LFILE="$HOME/.mutt/var/labels"

function listlabels() {
        echo ""
        echo "------------------------------------------------------------"
        echo "Available labels (from $LFILE):"
        echo "^^^^^^^^^^^^^^^^"
        cat $LFILE
        echo "------------------------------------------------------------"
}

function asklabel() {
	read -e -p "Insert label: " $1

	LNAME=`grep "${!1}" -i $LFILE | head -1`
	echo "Pronadjeno: $LNAME"

	while ( ! grep -q "^$LNAME$" "$LFILE" ) || ( [ "$LNAME" == "" ] ) ; do
		echo "Invalid label \"${!1}\""
		read -e -p "Insert valid label: " $1
		LNAME=`grep "${!1}" -i $LFILE | head -1`
		echo "Pronadjeno: $LNAME"
	done
}

function menu() {
        echo ""
        echo "Options:"
        echo "^^^^^^^"
        echo "a - appent a label from list"
        echo "b - append a custom label"
        echo ""
        echo "c - remove one label"
        echo "d - clear all labels"
        echo ""
        echo "e - show all appended labels"
        echo "f - list all availavle labels"
        echo ""
        echo "q - do nothing (quit)"
        echo "(end)"
        echo ""
        read -p "Enter selection: " ACTION

        if [ "$ACTION" == "a" ]; then
                ACTION=append_list
        elif [ "$ACTION" == "b" ]; then
                ACTION=custom
        elif [ "$ACTION" == "c" ]; then
                ACTION=remove
        elif [ "$ACTION" == "d" ]; then
                ACTION=clean
        elif [ "$ACTION" == "e" ]; then
                ACTION=show
        elif [ "$ACTION" == "f" ]; then
                ACTION=list
        elif [ "$ACTION" == "q" ]; then
                ACTION=quit
        else
                echo "Invalid action"
                menu
        fi
}

function append() {
        if [ "$XLBL" == "" ]; then
                NEW_XLBL="X-Label: $LNAME"
        else
                NEW_XLBL="$XLBL, $LNAME"
        fi

        formail -I "$NEW_XLBL" < "$FNAME" > "$NFNAME"
}

if [ "$ACTION" == "menu" ]; then
	menu
fi

while [ "$ACTION" != "quit" ]; do
        if [ "$ACTION" == "menu" ]; then
                menu
        fi

        XLBL=`formail -c -X "X-Label:" < "$FNAME"`

        if [ "$ACTION" == "append_list" ]; then
                listlabels
                asklabel LNAME
                append

        elif [ "$ACTION" == "custom" ]; then
                echo ""
                read -e -p "Insert custom label: " LNAME

                while [ "$LNAME" == "" ]; do
                        echo "Invalid label \"$LNAME\""
                        read -e -p "Insert non-empty custom label: " LNAME
                done

                append

        elif [ "$ACTION" == "remove" ]; then
                if [ "$XLBL" == "" ]; then
                        echo "No labels yet"
                else
                        echo "Current labels: $XLBL"
                        LNAME=""
                        NEW_XLBL=""
                        REMOVE=""
                        while [ "$LNAME" == "" ] || [ "$NEW_XLBL" == "" ] || [ "$REMOVE" == "" ]; do
                                read -e -p "Insert non-empty label to be removed: " LNAME
                                REMOVE=`echo $XLBL | sed "s/X-Label: //g" | grep "\b[^ ,]*$LNAME[^ ,]*" -oi | head -1 | sed "s/,//g" | sed "s/ //g"`
                                NEW_XLBL=`echo $XLBL | sed "s/, $REMOVE//g" | sed "s/$REMOVE, //g" | sed "s/ $REMOVE//g"`
                                echo "Pronadjeno: $REMOVE"
                                echo "New Label: $NEW_XLBL"
                        done

                        formail -I "$NEW_XLBL" < "$FNAME" > "$NFNAME"
                fi

        elif [ "$ACTION" == "clean" ]; then
                formail -I "X-Label:" < "$FNAME" > "$NFNAME"

        elif [ "$ACTION" == "show" ]; then
                if [ "$XLBL" == "" ]; then
                        echo "No labels yet"
                else
                        echo $XLBL
                fi

        elif [ "$ACTION" == "list" ]; then
                listlabels

        elif [ "$ACTION" == "quit" ]; then
                echo "(exit)"
        else
                echo ""
                echo "Doslo je do greske"
                echo ""
        fi

        # if we created a new file, step over the old one
        if [ -f "$NFNAME" ]; then
                mv "$NFNAME" "$FNAME"
        fi

        if [ "$ACTION" != "quit" ]; then
                ACTION=menu
        fi
done
