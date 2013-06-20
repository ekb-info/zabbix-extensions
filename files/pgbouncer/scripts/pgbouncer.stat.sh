#!/usr/bin/env bash
# $1 - param_name, $2 - pool_name
# pgbouncer pools stats

if [ ! -f ~zabbix/.pgpass ]; then echo "ERROR: ~zabbix/.pgpass not found" ; exit 1; fi

PSQL=$(which psql)
hostname=$(grep -w ^listen_addr /etc/pgbouncer.conf |cut -d" " -f3 |cut -d, -f1)
port=6432
dbname="pgbouncer"
username=$(head -n 1 ~zabbix/.pgpass |cut -d: -f4)
PARAM="$1"

if [ '*' = "$hostname" ]; then hostname="127.0.0.1"; fi

conn_param="-qAtX -F: -h $hostname -p $port -U $username $dbname"

case "$PARAM" in
'avg_req' )
        $PSQL $conn_param -c "show stats" |grep -w $2 |cut -d: -f6
;;
'avg_recv' )
        $PSQL $conn_param -c "show stats" |grep -w $2 |cut -d: -f7
;;
'avg_sent' )
        $PSQL $conn_param -c "show stats" |grep -w $2 |cut -d: -f8
;;
'avg_query' )
        $PSQL $conn_param -c "show stats" |grep -w $2 |cut -d: -f9
;;
'cl_active' )
        $PSQL $conn_param -c "show pools" |grep -w $2 |cut -d: -f3
;;
'cl_waiting' )
        $PSQL $conn_param -c "show pools" |grep -w $2 |cut -d: -f4
;;
'sv_active' )
        $PSQL $conn_param -c "show pools" |grep -w $2 |cut -d: -f5
;;
'sv_idle' )
        $PSQL $conn_param -c "show pools" |grep -w $2 |cut -d: -f6
;;
'sv_used' )
        $PSQL $conn_param -c "show pools" |grep -w $2 |cut -d: -f7
;;
'sv_tested' )
        $PSQL $conn_param -c "show pools" |grep -w $2 |cut -d: -f8
;;
'sv_login' )
        $PSQL $conn_param -c "show pools" |grep -w $2 |cut -d: -f9
;;
'maxwait' )
        $PSQL $conn_param -c "show pools" |grep -w $2 |cut -d: -f10
;;
'free_clients' )
        $PSQL $conn_param -c "show lists" |grep -w free_clients |cut -d: -f2
;;
'used_clients' )
        $PSQL $conn_param -c "show lists" |grep -w used_clients |cut -d: -f2
;;
'login_clients' )
        $PSQL $conn_param -c "show lists" |grep -w login_clients |cut -d: -f2
;;
'free_servers' )
        $PSQL $conn_param -c "show lists" |grep -w free_servers |cut -d: -f2
;;
'used_servers' )
        $PSQL $conn_param -c "show lists" |grep -w used_servers |cut -d: -f2
;;
'total_avg_req' )
        $PSQL $conn_param -c "show stats" |cut -d: -f6 |awk '{ s += $1 } END { print s }'
;;
'total_avg_recv' )
        $PSQL $conn_param -c "show stats" |cut -d: -f7 |awk '{ s += $1 } END { print s }'
;;
'total_avg_sent' )
        $PSQL $conn_param -c "show stats" |cut -d: -f8 |awk '{ s += $1 } END { print s }'
;;
'total_avg_query' )
        $PSQL $conn_param -c "show stats" |cut -d: -f6,9 |awk -F: '{ a += $1 * $2} { b += $1} END { print a / b }'
;;
* ) echo "ZBX_NOTSUPPORTED"; exit 1;;
esac