    SELECT  pf.name AS pf_name ,
            ps.name AS partition_scheme_name ,
            p.partition_number ,
            ds.name AS partition_filegroup ,
            OBJECT_NAME(si.object_id) AS object_name ,
            rv.value AS range_value ,
            SUM(CASE WHEN si.index_id IN ( 1, 0 ) THEN p.rows
                     ELSE 0
                END) AS num_rows
    FROM    sys.destination_data_spaces AS dds
            JOIN sys.data_spaces AS ds ON dds.data_space_id = ds.data_space_id
            JOIN sys.partition_schemes AS ps ON dds.partition_scheme_id = ps.data_space_id
            JOIN sys.partition_functions AS pf ON ps.function_id = pf.function_id
            LEFT JOIN sys.partition_range_values AS rv ON pf.function_id = rv.function_id
                                                          AND dds.destination_id = CASE pf.boundary_value_on_right
                                                                                     WHEN 0 THEN rv.boundary_id
                                                                                     ELSE rv.boundary_id + 1
                                                                                   END
            LEFT JOIN sys.indexes AS si ON dds.partition_scheme_id = si.data_space_id
            LEFT JOIN sys.partitions AS p ON si.object_id = p.object_id
                                             AND si.index_id = p.index_id
                                             AND dds.destination_id = p.partition_number
            LEFT JOIN sys.dm_db_partition_stats AS dbps ON p.object_id = dbps.object_id
                                                           AND p.partition_id = dbps.partition_id
    GROUP BY ds.name ,
            p.partition_number ,
            pf.name ,
            pf.type_desc ,
            pf.fanout ,
            pf.boundary_value_on_right ,
            ps.name ,
            si.object_id ,
            rv.value;
           