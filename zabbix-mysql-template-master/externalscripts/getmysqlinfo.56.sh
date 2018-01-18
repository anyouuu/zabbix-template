#!/bin/bash


# desc: 支持mysql 5.6~
# command> mysql_config_editor set --login-path=mysqlcheck --user=mysqlcheck --host=localhost --password
#
#Name: MySQLMontior.sh
#Action: Zabbix monitoring mysql plug-in


MySQlBin=/usr/bin/mysql
MySQLAdminBin=/usr/bin/mysqladmin
MysqlCfgName=mysqlcheck
mysqlSock=/var/lib/mysql/mysql.sock

if [[ $# == 1 ]];then
    case $1 in
         Ping)
            result=`$MySQLAdminBin -S $mysqlSock  ping|grep alive|wc -l`
            echo $result
        ;;
         Threads)
            result=`$MySQLAdminBin -S $mysqlSock  status|cut -f3 -d":"|cut -f1 -d"Q"`
            echo $result
        ;;
         Questions)
            result=`$MySQLAdminBin -S $mysqlSock  status|cut -f4 -d":"|cut -f1 -d"S"`
            echo $result
        ;;
         Slowqueries)
            result=`$MySQLAdminBin -S $mysqlSock  status|cut -f5 -d":"|cut -f1 -d"O"`
            echo $result
        ;;
         Qps)
            result=`$MySQLAdminBin -S $mysqlSock  status|cut -f9 -d":"`
            echo $result
        ;;
         Slave_IO_State)
            result=`if [ "$($MySQlBin -S $mysqlSock  -e "show slave status\G"| grep Slave_IO_Running|awk '{print $2}')" == "Yes" ];then echo 1; else echo 0;fi`
            echo $result
        ;;
         Slave_SQL_State)
            result=`if [ "$($MySQlBin -S $mysqlSock  -e "show slave status\G"| grep Slave_SQL_Running|awk '{print $2}')" == "Yes" ];then echo 1; else echo 0;fi`
            echo $result
        ;;
         Key_buffer_size)
            result=`$MySQlBin -S $mysqlSock  -e "show variables like 'key_buffer_size';"| grep -v Value |awk '{print $2/1024^2}'`
            echo $result
        ;;
         Key_reads)
            result=`$MySQlBin -S $mysqlSock  -e "show global status like 'key_reads';"| grep -v Value |awk '{print $2}'`
            echo $result
        ;;
         Key_read_requests)
            result=`$MySQlBin -S $mysqlSock  -e "show global status like 'key_read_requests';"| grep -v Value |awk '{print $2}'`
            echo $result
        ;;
         Key_cache_miss_rate)
            result=`echo $($MySQlBin -S $mysqlSock  -e "show global status like 'key_reads';"| grep -v Value |awk '{print $2}') $($MySQlBin -S $mysqlSock  -e "show global status like 'key_read_requests';"| grep -v Value |awk '{print $2}')| awk '{if($2==0)printf("%1.4f\n",0);else printf("%1.4f\n",$1/$2*100);}'`
            echo $result
        ;;
         Key_blocks_used)
            result=`$MySQlBin -S $mysqlSock  -e "show global status like 'key_blocks_used';"| grep -v Value |awk '{print $2}'`
            echo $result
        ;;
         Key_blocks_unused)
            result=`$MySQlBin -S $mysqlSock  -e "show global status like 'key_blocks_unused';"| grep -v Value |awk '{print $2}'`
            echo $result
        ;;
         Key_blocks_used_rate)
            result=`echo $($MySQlBin -S $mysqlSock  -e "show global status like 'key_blocks_used';"| grep -v Value |awk '{print $2}') $($MySQlBin -S $mysqlSock  -e "show global status like 'key_blocks_unused';"| grep -v Value |awk '{print $2}')| awk '{if(($1==0) && ($2==0))printf("%1.4f\n",0);else printf("%1.4f\n",$1/($1+$2)*100);}'`
            echo $result
        ;;
         Innodb_buffer_pool_size)
            result=`$MySQlBin -S $mysqlSock  -e "show variables like 'innodb_buffer_pool_size';"| grep -v Value |awk '{print $2/1024^2}'`
            echo $result
        ;;
         Innodb_log_file_size)
            result=`$MySQlBin -S $mysqlSock  -e "show variables like 'innodb_log_file_size';"| grep -v Value |awk '{print $2/1024^2}'`
            echo $result
        ;;
         Innodb_log_buffer_size)
            result=`$MySQlBin -S $mysqlSock  -e "show variables like 'innodb_log_buffer_size';"| grep -v Value |awk '{print $2/1024^2}'`
            echo $result
        ;;
         Table_open_cache)
            result=`$MySQlBin -S $mysqlSock  -e "show variables like 'table_open_cache';"| grep -v Value |awk '{print $2}'`
            echo $result
        ;;
         Open_tables)
            result=`$MySQlBin -S $mysqlSock  -e "show global status like 'open_tables';"| grep -v Value |awk '{print $2}'`
            echo $result
        ;;
         Opened_tables)
            result=`$MySQlBin -S $mysqlSock  -e "show global status like 'opened_tables';"| grep -v Value |awk '{print $2}'`
            echo $result
        ;;
         Open_tables_rate)
            result=`echo $($MySQlBin -S $mysqlSock  -e "show global status like 'open_tables';"| grep -v Value |awk '{print $2}') $($MySQlBin -S $mysqlSock  -e "show global status like 'opened_tables';"| grep -v Value |awk '{print $2}')| awk '{if(($1==0) && ($2==0))printf("%1.4f\n",0);else printf("%1.4f\n",$1/($1+$2)*100);}'`
            echo $result
        ;;
         Table_open_cache_used_rate)
            result=`echo $($MySQlBin -S $mysqlSock  -e "show global status like 'open_tables';"| grep -v Value |awk '{print $2}') $($MySQlBin -S $mysqlSock  -e "show variables like 'table_open_cache';"| grep -v Value |awk '{print $2}')| awk '{if(($1==0) && ($2==0))printf("%1.4f\n",0);else printf("%1.4f\n",$1/($1+$2)*100);}'`
            echo $result
        ;;
         Thread_cache_size)
            result=`$MySQlBin -S $mysqlSock  -e "show variables like 'thread_cache_size';"| grep -v Value |awk '{print $2}'`
            echo $result
        ;;
         Threads_cached)
            result=`$MySQlBin -S $mysqlSock  -e "show global status like 'Threads_cached';"| grep -v Value |awk '{print $2}'`
            echo $result
        ;;
         Threads_connected)
            result=`$MySQlBin -S $mysqlSock  -e "show global status like 'Threads_connected';"| grep -v Value |awk '{print $2}'`
            echo $result
        ;;
         Threads_created)
            result=`$MySQlBin -S $mysqlSock  -e "show global status like 'Threads_created';"| grep -v Value |awk '{print $2}'`
            echo $result
        ;;
         Threads_running)
            result=`$MySQlBin -S $mysqlSock  -e "show global status like 'Threads_running';"| grep -v Value |awk '{print $2}'`
            echo $result
        ;;
         Qcache_free_blocks)
            result=`$MySQlBin -S $mysqlSock  -e "show global status like 'Qcache_free_blocks';"| grep -v Value |awk '{print $2}'`
            echo $result
        ;;
         Qcache_free_memory)
            result=`$MySQlBin -S $mysqlSock  -e "show global status like 'Qcache_free_memory';"| grep -v Value |awk '{print $2}'`
            echo $result
        ;;
         Qcache_hits)
            result=`$MySQlBin -S $mysqlSock  -e "show global status like 'Qcache_hits';"| grep -v Value |awk '{print $2}'`
            echo $result
        ;;
         Qcache_inserts)
            result=`$MySQlBin -S $mysqlSock  -e "show global status like 'Qcache_inserts';"| grep -v Value |awk '{print $2}'`
            echo $result
        ;;
         Qcache_lowmem_prunes)
            result=`$MySQlBin -S $mysqlSock  -e "show global status like 'Qcache_lowmem_prunes';"| grep -v Value |awk '{print $2}'`
            echo $result
        ;;
         Qcache_not_cached)
            result=`$MySQlBin -S $mysqlSock  -e "show global status like 'Qcache_not_cached';"| grep -v Value |awk '{print $2}'`
            echo $result
        ;;
         Qcache_queries_in_cache)
            result=`$MySQlBin -S $mysqlSock  -e "show global status like 'Qcache_queries_in_cache';"| grep -v Value |awk '{print $2}'`
            echo $result
        ;;
         Qcache_total_blocks)
            result=`$MySQlBin -S $mysqlSock  -e "show global status like 'Qcache_total_blocks';"| grep -v Value |awk '{print $2}'`
            echo $result
        ;;
         Qcache_fragment_rate)
            result=`echo $($MySQlBin -S $mysqlSock  -e "show global status like 'Qcache_free_blocks';"| grep -v Value |awk '{print $2}') $($MySQlBin -S $mysqlSock  -e "show global status like 'Qcache_total_blocks';"| grep -v Value |awk '{print $2}')| awk '{if($2==0)printf("%1.4f\n",0);else printf("%1.4f\n",$1/$2*100);}'`
            echo $result
        ;;
         Qcache_used_rate)
            result=`echo $($MySQlBin -S $mysqlSock  -e "show variables like 'query_cache_size';"| grep -v Value |awk '{print $2}') $($MySQlBin -S $mysqlSock  -e "show global status like 'Qcache_free_memory';"| grep -v Value |awk '{print $2}')| awk '{if($1==0)printf("%1.4f\n",0);else printf("%1.4f\n",($1-$2)/$1*100);}'`
            echo $result
        ;;
         Qcache_hits_rate)
            result=`echo $($MySQlBin -S $mysqlSock  -e "show global status like 'Qcache_hits';"| grep -v Value |awk '{print $2}') $($MySQlBin -S $mysqlSock  -e "show global status like 'Qcache_inserts';"| grep -v Value |awk '{print $2}')| awk '{if($1==0)printf("%1.4f\n",0);else printf("%1.4f\n",($1-$2)/$1*100);}'`
            echo $result
        ;;
         Query_cache_limit)
            result=`$MySQlBin -S $mysqlSock  -e "show variables like 'query_cache_limit';"| grep -v Value |awk '{print $2}'`
            echo $result
        ;;
         Query_cache_min_res_unit)
            result=`$MySQlBin -S $mysqlSock  -e "show variables like 'query_cache_min_res_unit';"| grep -v Value |awk '{print $2}'`
            echo $result
        ;;
         Query_cache_size)
            result=`$MySQlBin -S $mysqlSock  -e "show variables like 'query_cache_size';"| grep -v Value |awk '{print $2}'`
            echo $result
        ;;
         Sort_merge_passes)
            result=`$MySQlBin -S $mysqlSock  -e "show global status like 'Sort_merge_passes';"| grep -v Value |awk '{print $2}'`
            echo $result
        ;;
         Sort_range)
            result=`$MySQlBin -S $mysqlSock  -e "show global status like 'Sort_range';"| grep -v Value |awk '{print $2}'`
            echo $result
        ;;
         Sort_rows)
            result=`$MySQlBin -S $mysqlSock  -e "show global status like 'Sort_rows';"| grep -v Value |awk '{print $2}'`
            echo $result
        ;;
         Sort_scan)
            result=`$MySQlBin -S $mysqlSock  -e "show global status like 'Sort_scan';"| grep -v Value |awk '{print $2}'`
            echo $result
        ;;
         Handler_read_first)
            result=`$MySQlBin -S $mysqlSock  -e "show global status like 'Handler_read_first';"| grep -v Value |awk '{print $2}'`
            echo $result
        ;;
         Handler_read_key)
            result=`$MySQlBin -S $mysqlSock  -e "show global status like 'Handler_read_key';"| grep -v Value |awk '{print $2}'`
            echo $result
        ;;
         Handler_read_next)
            result=`$MySQlBin -S $mysqlSock  -e "show global status like 'Handler_read_next';"| grep -v Value |awk '{print $2}'`
            echo $result
        ;;
         Handler_read_prev)
            result=`$MySQlBin -S $mysqlSock  -e "show global status like 'Handler_read_prev';"| grep -v Value |awk '{print $2}'`
            echo $result
        ;;
         Handler_read_rnd)
            result=`$MySQlBin -S $mysqlSock  -e "show global status like 'Handler_read_rnd';"| grep -v Value |awk '{print $2}'`
            echo $result
        ;;
         Handler_read_rnd_next)
            result=`$MySQlBin -S $mysqlSock  -e "show global status like 'Handler_read_rnd_next';"| grep -v Value |awk '{print $2}'`
            echo $result
        ;;
         Com_select)
            result=`$MySQlBin -S $mysqlSock  -e "show global status like 'com_select';"| grep -v Value |awk '{print $2}'`
            echo $result
        ;;
         Com_insert)
            result=`$MySQlBin -S $mysqlSock  -e "show global status like 'com_insert';"| grep -v Value |awk '{print $2}'`
            echo $result
        ;;
         Com_insert_select)
            result=`$MySQlBin -S $mysqlSock  -e "show global status like 'com_insert_select';"| grep -v Value |awk '{print $2}'`
            echo $result
        ;;
         Com_update)
            result=`$MySQlBin -S $mysqlSock  -e "show global status like 'com_update';"| grep -v Value |awk '{print $2}'`
            echo $result
        ;;
         Com_replace)
            result=`$MySQlBin -S $mysqlSock  -e "show global status like 'com_replace';"| grep -v Value |awk '{print $2}'`
            echo $result
        ;;
         Com_replace_select)
            result=`$MySQlBin -S $mysqlSock  -e "show global status like 'com_replace_select';"| grep -v Value |awk '{print $2}'`
            echo $result
        ;;
         Table_scan_rate)
            result=`echo $($MySQlBin -S $mysqlSock  -e "show global status like 'Handler_read_rnd_next';"| grep -v Value |awk '{print $2}') $($MySQlBin -S $mysqlSock  -e "show global status like 'com_select';"| grep -v Value |awk '{print $2}')| awk '{if($2==0)printf("%1.4f\n",0);else printf("%1.4f\n",$1/$2*100);}'`
            echo $result
        ;;
         Open_files)
            result=`$MySQlBin -S $mysqlSock  -e "show global status like 'open_files';"| grep -v Value |awk '{print $2}'`
            echo $result
        ;;
         Open_files_limit)
            result=`$MySQlBin -S $mysqlSock  -e "show variables like 'open_files_limit';"| grep -v Value |awk '{print $2}'`
            echo $result
        ;;
         Open_files_rate)
            result=`echo $($MySQlBin -S $mysqlSock  -e "show global status like 'open_files';"| grep -v Value |awk '{print $2}') $($MySQlBin -S $mysqlSock  -e "show variables like 'open_files_limit';"| grep -v Value |awk '{print $2}')| awk '{if($2==0)printf("%1.4f\n",0);else printf("%1.4f\n",$1/$2*100);}'`
            echo $result
        ;;
         Created_tmp_disk_tables)
            result=`$MySQlBin -S $mysqlSock  -e "show global status like 'created_tmp_disk_tables';"| grep -v Value |awk '{print $2}'`
            echo $result
        ;;
         Created_tmp_tables)
            result=`$MySQlBin -S $mysqlSock  -e "show global status like 'created_tmp_tables';"| grep -v Value |awk '{print $2}'`
            echo $result
        ;;
         Created_tmp_disk_tables_rate)
            result=`echo $($MySQlBin -S $mysqlSock  -e "show global status like 'created_tmp_disk_tables';"| grep -v Value |awk '{print $2}') $($MySQlBin -S $mysqlSock  -e "show global status like 'created_tmp_tables';"| grep -v Value |awk '{print $2}')| awk '{if($2==0)printf("%1.4f\n",0);else printf("%1.4f\n",$1/$2*100);}'`
            echo $result
        ;;
         Max_connections)
            result=`$MySQlBin -S $mysqlSock  -e "show variables like 'max_connections';"| grep -v Value |awk '{print $2}'`
            echo $result
        ;;
         Max_used_connections)
            result=`$MySQlBin -S $mysqlSock  -e "show global status like 'Max_used_connections';"| grep -v Value |awk '{print $2}'`
            echo $result
        ;;
         Processlist)
            result=`$MySQlBin -S $mysqlSock  -e "show processlist" | grep -v "Id" | wc -l`
            echo $result
        ;;
         Max_connections_used_rate)
            result=`echo $($MySQlBin -S $mysqlSock  -e "show global status like 'Max_used_connections';"| grep -v Value |awk '{print $2}') $($MySQlBin -S $mysqlSock  -e "show variables like 'max_connections';"| grep -v Value |awk '{print $2}')| awk '{if($2==0)printf("%1.4f\n",0);else printf("%1.4f\n",$1/$2*100);}'`
            echo $result
        ;;
        Connection_occupancy_rate)
            result=`echo $($MySQlBin -S $mysqlSock  -e "show global status like 'Threads_connected';"| grep -v Value |awk '{print $2}') $($MySQlBin -S $mysqlSock  -e "show variables like 'max_connections';"| grep -v Value |awk '{print $2}')| awk '{if($2==0)printf("%1.4f\n",0);else printf("%5.4f\n",$1/$2*100);}'`
            echo $result
        ;;

         Table_locks_immediate)
            result=`$MySQlBin -S $mysqlSock  -e "show global status like 'Table_locks_immediate';"| grep -v Value |awk '{print $2}'`
            echo $result
        ;;
         Table_locks_waited)
            result=`$MySQlBin -S $mysqlSock  -e "show global status like 'table_locks_waited';"| grep -v Value |awk '{print $2}'`
            echo $result
        ;;
         Engine_select)
            result=`echo $($MySQlBin -S $mysqlSock  -e "show global status like 'Table_locks_immediate';"| grep -v Value |awk '{print $2}') $($MySQlBin -S $mysqlSock  -e "show global status like 'table_locks_waited';"| grep -v Value | awk '{print $2}') | awk '{if($2==0)printf("%1.4f\n",0);else printf("%5.4f\n",$1/$2*100);}'`
            echo $result
        ;;
        *)
	    result=`$MySQlBin -S $mysqlSock  -e "show global status like '$1';"| grep -v Value |awk '{print $2}'`
	    echo $result

        ;;
    esac
fi
