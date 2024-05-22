-- Check Primary Key
SELECT 
    tc.table_schema,
    tc.table_name,
    kc.column_name
FROM 
    INFORMATION_SCHEMA.TABLE_CONSTRAINTS AS tc
JOIN 
    INFORMATION_SCHEMA.KEY_COLUMN_USAGE AS kc
ON 
    tc.constraint_name = kc.constraint_name
WHERE 
    constraint_type = 'PRIMARY KEY'
AND 
    tc.table_name IN ('Facts', 'DimDescription', 'DimDetailDamage', 'DimLocation', 'DimTime', 'DimTotalDamage');

-- Check foreign key 

SELECT 
    fk.name AS FK_name,
    tp.name AS parent_table,
    cp.name AS parent_column,
    tr.name AS referenced_table,
    cr.name AS referenced_column
FROM 
    sys.foreign_keys AS fk
INNER JOIN 
    sys.tables tp ON fk.parent_object_id = tp.object_id
INNER JOIN 
    sys.tables tr ON fk.referenced_object_id = tr.object_id
INNER JOIN  
    sys.foreign_key_columns fkc ON fkc.constraint_object_id = fk.object_id
INNER JOIN  
    sys.columns cp ON fkc.parent_column_id = cp.column_id AND fkc.parent_object_id = cp.object_id
INNER JOIN  
    sys.columns cr ON fkc.referenced_column_id = cr.column_id AND fkc.referenced_object_id = cr.object_id;

