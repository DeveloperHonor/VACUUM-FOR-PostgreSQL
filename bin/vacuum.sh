#!/bin/bash
#获取环境变量
CURRDIR=$(cd "$(dirname $0)";pwd)
TOPDIR=$(cd $CURRDIR/..;pwd)
CONFIG=$TOPDIR/conf/host.ini
CT_FILE=${TOPDIR}/sql/CREATE_VACCUM_TABLE_RECORD.sql
CT_FUNCTION=${TOPDIR}/sql/CHECK_NEEDS_VACUUM_TABLE_FUNCTION.sql
source $CONFIG
CONNINFO="psql -U $USER -d $DBNAME -h $HOSTADDR -p $PORT"

function check_status()
{
        echo "检查数据库服务器状态是否正常 !"
        stat=`$CONNINFO -Aqt -c 'SELECT 1'`
        if [ "${stat}" == "1" ];then
                echo "服务器连接正常"
        else
                echo "服务器连接异常,退出"
                exit -1;
        fi
}
function create_table()
{
        echo "创建收集需要vacuum的表"
        $CONNINFO -f $CT_FILE
}

function create_function()
{
        echo "创建收集需要 vacuum 表的函数"
        $CONNINFO -f $CT_FUNCTION
}
check_status

create_table

create_function 
