#!/bin/bash

# recursively delete dcache directory on NAF. Argument is a folder on your dcache home dir
# Usage: delete_dcache_directory skim2015
#  to delete srm://dcache-se-cms.desy.de:.../pnfs/desy.de/cms/tier2/store/user/${USER}/skim2015
delete_dcache_directory()
{
echo "This will delete the folder $1 on your NAF dCache directory and all its contents."
read -r -p "Are you sure? [y/N] " response

if [[ $response =~ ^([yY][eE][sS]|[yY])$ ]]
then
    echo "Deleting $(ls /pnfs/desy.de/cms/tier2/store/user/${USER}/$1/*.* | wc -l) files... (this might take some time)"
    for i in  `ls /pnfs/desy.de/cms/tier2/store/user/${USER}/$1/*.*`
    do
        srmrm srm://dcache-se-cms.desy.de:8443/srm/managerv2?SFN=${i}
    done
    echo "Deleting directory..."
    srmrmdir srm://dcache-se-cms.desy.de:8443/srm/managerv2?SFN=/pnfs/desy.de/cms/tier2/store/user/${USER}/$i
    echo "Done."
else
    echo "aborted"
fi
}
