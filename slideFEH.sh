#############
# FUCNTIONS #
#############

function FUNCcheckConf(){
local _conf=$1  _dir=$2

[ ! -f "$_conf" ] && {   echo "$_dir" > "$_conf" ;  echo "0" >> "$_conf" ; }

[ ! "`cat "$_conf" | head -n1`" == "$_dir" ] && {  rm -rf "$_conf" ;  FUNCcheckConf "$_conf" "$_dir" ; }

} 
#function FUNCcheckImg(){
#local _pathFile=$1  _type=$2
#
#[ "`file -b -i $_pathFile | grep -o "$_type"`" == "$_type" ] &&  return 0 || return 1
#}
function FUNCmove(){
local _conf="$1"  _dir="$2"  _direction="$3" _files="$4"
local _ligne=`wc -l <<< $_files`  _number=`cat $_conf | tail -n1`

[ $_direction == "up" ] && let _number++
[ $_direction == "down" ] && let _number--

[ "$_number" -gt "$_ligne" ] && _number=1 
[ "$_number" -lt "1" ] && _number="$_ligne"

_pathFile=`head -n"$_number" <<< "$_files" | tail -n1`
echo "$_dir" > "$_conf" ; echo "$_number" >> "$_conf"

#RETURN
echo "$_pathFile"
}
function FUNCstartFeh(){
local _pathFile="$1" 
feh --bg-scale "$_pathFile"
}

########
# MAIN #
########

dir="$1"  direction="$2"  conf=~/.confSlideFEH3  type="image" 
FUNCcheckConf "$conf" "$dir"
number="`cat $conf | tail -n1`"


[ "$#" -lt "1" ] || [ "$#" -gt "2" ] && {  echo  "ERROR : args number invalid"/n"cmd path [up/down]" ; exit 1 ; }
[ ! -d "$dir" ] && { echo "ERROR : directory not exist" ; exit 1 ; }

[ ! -f /tmp/slideFeh ] || [ ! -f /tmp/slideHashFeh ] || [ "`ls $dir | md5sum | cut -d" " -f1`" != "`head /tmp/slideHashFeh`" ] && { file  "$dir"*  | grep "image data" | cut -d":" -f1 > /tmp/slideFeh ; echo `ls $dir | md5sum | cut -d" " -f1` > /tmp/slideHashFeh ; }


files=`cat /tmp/slideFeh`
[ "$files" == "" ] && { echo "ERROR : not img found" ;  exit 1 ; } 

function main(){
pathFile=`FUNCmove "$conf" "$dir" "$direction" "$files"`
FUNCstartFeh "$pathFile"
}

[ "$2" == "down" ] || [ "$2" == "up" ] &&  { main ; exit 0 ; } 
[ "$2" == "" ] && [ "$number" == "0" ] && { direction="up" ; main ; exit 0 ; }
[ "$2" == "" ]  && { FUNCstartFeh "`head -n"$number" <<< $files | tail -n1`" ; exit 0 ;}

