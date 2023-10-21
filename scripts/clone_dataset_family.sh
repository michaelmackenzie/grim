#!/usr/bin/bash
#------------------------------------------------------------------------------
# clone configuration of an existing dataset family to create a prototype configuration 
# for a new one
# call signature:
#                   clone_dataset_family project old_family_id new_family_id
# example:
#                   clone_dataset_family pbar2m bmum0b0 bmumcb0
#------------------------------------------------------------------------------ 
project=$1
  odsid=$2
  ndsid=$3
   doit=$4

ndir=$project/datasets/$ndsid
odir=$project/datasets/$odsid

if [ ".$doit" == "." ] ; then prefix=echo ; else prefix='' ; fi

if [ ! -d $ndir ] ; then 
    $prefix mkdir -p $ndir ; 
    $prefix mkdir -p $ndir/catalog ; 
fi

for f in `ls $odir/* | grep .fcl$` ; do
    bn=`basename $f`
    bn1=`echo $bn | sed s/$odsid/$ndsid/g`

    if [ ".$prefix" == ".echo" ] ; then 
	echo cat $odir/$bn \| sed s/$odsid/$ndsid/g \>\| $ndir/$bn1
    else
	cat $odir/$bn | sed s/$odsid/$ndsid/g >| $ndir/$bn1
    fi
done

for f in init_project.py $project.$odsid.org ; do

    if [ -f $odir/$f ] ; then
	nf=`echo $f | sed s/$odsid/$ndsid/g`
	if [ ".$prefix" == ".echo" ] ; then 
	    echo cat $odir/$f \| sed s/$odsid/$ndsid/g \>\| $ndir/$nf
	else
	    cat $odir/$f | sed s/$odsid/$ndsid/g >| $ndir/$nf
	fi
    fi
done
