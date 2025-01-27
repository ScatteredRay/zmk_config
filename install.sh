#! /usr/bin/env bash

VENDOR_ID="239a"
PRODUCT_ID="0029"
BLK_ID="Adafruit_nRF_UF2_GLV80"
UF2_BIN="result/glove80.uf2"
MNT_PATH="/mnt/usb"

ID="$VENDOR_ID:$PRODUCT_ID"

echo "Waiting for $ID"

while true; do
    USB=$(lsusb | grep "$ID")

    if [ ! -z "$USB" ]; then
        echo "Detected $USB"
        sleep 2 # some time for ID to populate
        lsblk -o PATH,ID
        BLOCK=$(lsblk -o PATH,ID -J | jq ".[][] | select(.id | test(\"$BLK_ID\")) | .path" | jq -s --exit-status 'first' -r)
        if [ $? -eq 0 ]; then
            sudo mount $BLOCK $MNT_PATH
            ls $MNT_PATH
            if [ -e $MNT_PATH/INFO_UF2.txt ]; then
                echo 'INFO_UF2.txt exists, continuing'
                cat $MNT_PATH/INFO_UF2.txt
                sudo cp $UF2_BIN $MNT_PATH
            else
                echo 'INFO_UF2.txt not found, correct usb?'
            fi
            sudo umount $MNT_PATH
            echo "Detected $BLOCK"
        else
            echo "Unable to detect Block"
        fi
        break
    fi
    sleep 5
done

