CREATE OR REPLACE FUNCTION f_vacuum_tables()
RETURNS void AS
$FUNCTION$
 DECLARE
  v_tablename  text;
  v_dead_cond  bigint;
  v_sql        text;
  cur_tablename REFCURSOR;
  v_vacuum_record text;
 BEGIN
  v_vacuum_record := 'tab_vacuum_record';
  OPEN cur_tablename FOR SELECT tablename FROM pg_tables WHERE tablename !~ '^pg|^sql';
  LOOP
   FETCH cur_tablename INTO v_tablename;
      SELECT n_dead_tup INTO v_dead_cond FROM pg_stat_user_tables WHERE relname = v_tablename;
	  IF v_dead_cond > 0 THEN
	    v_sql := 'INSERT INTO ' || v_vacuum_record || ' VALUES(' || chr(39) ||'VACUUM FULL ' || v_tablename ||';'|| chr(39) ||')';
        EXECUTE v_sql;
	  END IF;
      EXIT WHEN NOT FOUND;
  END LOOP;
  CLOSE cur_tablename;
 END;
$FUNCTION$
LANGUAGE PLPGSQL;