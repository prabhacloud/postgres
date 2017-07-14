select split_part(split_part('create table public.test_create(id text);',' ',3),'(',1);
split_part(split_part(p_sql,' ',3),'(',1);
select my_functions.table_check('create table public.test_create(id text);');

create or replace function my_functions.table_check(p_sql text)
RETURNS BOOLEAN AS 
$BODY$
DECLARE
v_object_name text;
v_schema_name text;
v_object_type text;

begin

v_object_name=split_part(split_part(p_sql,' ',3),'(',1);
v_schema_name=split_part(v_object_name,'.',1);
v_object_type = split_part(p_sql,' ',2);
RAISE NOTICE '%',split_part(v_object_name,'.',2);
RAISE NOTICE '%',v_schema_name;
RAISE NOTICE '%',v_object_type;



CASE 
   WHEN v_object_type = 'table' THEN   
   RAISE NOTICE '%',split_part(v_object_name,'.',2);
   RAISE NOTICE '%',v_schema_name;
   PERFORM * FROM INFORMATION_SCHEMA.TABLES WHERE TABLE_SCHEMA = v_schema_name and TABLE_NAME = split_part(v_object_name,'.',2) LIMIT 1;
   IF FOUND 
   THEN 
   RAISE EXCEPTION '% ALREADY EXISTS drop it',v_object_name;
   RETURN FALSE;
   END IF;   
   WHEN v_object_type = 'view' THEN
   ELSE
      --  do nothing
END CASE;

return true;
end;
$BODY$
LANGUAGE plpgsql volatile security definer;