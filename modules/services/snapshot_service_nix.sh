#! /usr/bin/env bash
###########################################################################
#       btrfs snapshot/cleanup script designed as a systemd service       #
###########################################################################
#                       snapshot retetion policy                          #
###########################################################################
# main drive snaped 2x daliy                                              #
#snaps kept for 10 days                                                   #
###########################################################################
SOURCE_SUBVOL1="/mnt/vault3/"
SNAPSHOT_DESTINATION1="/mnt/vault3/.snapshots/"

while [ true ]; do
  TIMESTAMP=$(date +"%Y-%m-%d-%H%M")
  btrfs subv snapshot $SOURCE_SUBVOL1 $SNAPSHOT_DESTINATION1$TIMESTAMP
 
  SNAPSHOT_COUNT=$(sudo btrfs subv list $SOURCE_SUBVOL1 | awk 'END{print NR}')
  while [ $SNAPSHOT_COUNT -ge 23 ]
  do
    DELETE_NEXT=$(sudo btrfs subv list $SOURCE_SUBVOL1 | awk '/snapshot/ {print $9}' | awk 'FNR == 1 {print}')
    echo "$SOURCE_SUBVOL1$DELETE_NEXT"
    sudo btrfs subv delete $SOURCE_SUBVOL1$DELETE_NEXT
    ((SNAPSHOT_COUNT--))
  done
  sleep 12h
done

