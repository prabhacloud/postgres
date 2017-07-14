--select split_part(' public.test_create','.',2) LIMIT 1;
--select * FROM INFORMATION_SCHEMA.TABLES WHERE TABLE_SCHEMA = 'public' and TABLE_NAME= 'test_create' LIMIT 1;
--drop table public.test_create;
--select * from public.test_create;
--select my_functions.object_create('create table public.test_create(id text);');
--create schema my_functions;
create or replace function my_functions.object_create(p_sql text)
RETURNS BOOLEAN AS 
$BODY$
DECLARE
v_old_path text;
v_object_name text;
v_schema_name text;
v_object_type text;
v_action text;
begin
--v_old_path  := pg_catalog.current_setting('search_path');
--perform pg_catalog.current_setting('search_path','pg_temp','true');
v_object_name=split_part(p_sql,' ',3);
v_schema_name=split_part(v_object_name,'.',1);
v_object_type = split_part(p_sql,' ',2);

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
      EXECUTE p_sql;
   WHEN v_object_type = 'view' THEN
      EXECUTE p_sql;  
      ELSE
      --  do nothing
END CASE;



--perform pg_catalog.current_setting('search_path',v_old_path,'true');
return true;
end;
$BODY$
LANGUAGE plpgsql volatile security definer;
