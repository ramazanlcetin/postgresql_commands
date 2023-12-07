--Create Custom Type (Özel Tip Oluşturma)
CREATE TYPE public."enum_publication_type" 
AS ENUM ('RESEARCH','COMPILATION','FACT_PRESENTATION','OTHER','BOOK_PRESENTATION','CORRECTION',
                                                    'EDITORIAL','LETTER','LETTER_TO_EDITOR','MEETING_SUMMARY','REPORT','RETRACTED','SHORT_REPORT','TRANSLATION');

--Add Property On Custom Type (Özel Tipe Veri Ekleme)
ALTER TYPE enum_publication_type ADD VALUE  IF NOT EXISTS  'NOTE';


-- Other DB connect table of view (Başka bir DB üzerindeki tabloyu view olarak bağlama)
CREATE OR REPLACE VIEW public.vw_user_list
AS SELECT t1.id,
    t1.first_name,
    t1.last_name,
    t1.email,
    t1.enabled,
    (t1.first_name::text || ' '::text) || t1.last_name::text AS fullname
   FROM dblink('host=mydomain.address dbname=DB_NAME  
               user=USER_NAME password=PASSWORD'::text, 
               'select u.id,u.first_name,u.last_name,u.email,u.enabled from tbl_user_list as u'::text) 
               t1(id character varying, first_name character varying, last_name character varying, email character varying, enabled boolean);


-- Create Trigger After Update (Güncelleme Sonrası Çalışacak Trigger Oluşturma)
CREATE trigger trigger_name AFTER UPDATE ON table_name FOR EACH ROW  EXECUTE FUNCTION my_function_name();

-- Create Function For Trigger After Update (Güncelleme Sonrası Çalışacak Trigger İçin Fonksiyon)
CREATE OR REPLACE FUNCTION my_function_name() RETURNS trigger LANGUAGE plpgsql
AS $function$
    begin
	   	update my_table_name set updated_date =now() where id=new.id;
        RETURN NEW;
    END;
$function$
;


-- Create GIN INDEX for text column (Metinsel ifadeler için vektörel GIN INDEX oluşturma)
CREATE INDEX my_index_name ON my_table_name USING gin (m_vector(column_name));

------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
/*  5M item log table (tbl_audit_log)
|id       |tag                |event_time             |
|---------|-------------------|-----------------------|
|1,609,862|Item-1186406|2023-09-14 16:11:48.229|
|1,609,864|Item-1186406|2023-09-14 16:11:48.231|
|1,609,866|Item-1186406|2023-09-14 16:11:48.233|
|1,609,868|Item-1186406|2023-09-14 16:11:48.234|
|1,609,870|Item-1186406|2023-09-14 16:11:48.236|
|1,609,872|Item-1186406|2023-09-14 16:11:48.237|
|1,609,874|Item-1186406|2023-09-14 16:11:48.239|
|1,609,876|Item-1186406|2023-09-14 16:11:48.240|
|1,609,878|Item-1186406|2023-09-14 16:11:48.243|
|1,609,880|Item-1186406|2023-09-14 16:11:48.245|
****
*/
-- ADD generated column-------------------------------------------------------------------------------------------------------
ALTER TABLE tbl_audit_log ADD COLUMN  tag_tsv tsvector  GENERATED ALWAYS AS (to_tsvector('english',coalesce(tag,''))) STORED;
-- Create INDEX---------------------------------------------------------------------------------------------------------------
CREATE INDEX tbl_audit_log_tag_tsv_index ON tbl_audit_log USING GIN (tag_tsv);
-- Search Data----------------------------------------------------------------------------------------------------------------
SELECT * from tbl_audit_log, to_tsquery('Item-1186406') query where query @@ (tag_tsv);
------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
