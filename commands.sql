--Create Custom Type (Özel Tip Oluşturma)
CREATE TYPE public."enum_publication_type" 
AS ENUM ('RESEARCH','COMPILATION','FACT_PRESENTATION','OTHER','BOOK_PRESENTATION','CORRECTION',
                                                    'EDITORIAL','LETTER','LETTER_TO_EDITOR','MEETING_SUMMARY','REPORT','RETRACTED','SHORT_REPORT','TRANSLATION');

--Add Property On Custom Type (Özel Tipe Veri Veri Ekleme)
ALTER TYPE enum_publication_type ADD VALUE  IF NOT EXISTS  'NOTE';


-- Other DB connect table of view (Başka bir DB üzerindeki tabloyu view olarak bağlama)
CREATE OR REPLACE VIEW public.vw_user_list
AS SELECT t1.id,
    t1.first_name,
    t1.last_name,
    t1.email,
    t1.old_id,
    t1.enabled,
    (t1.first_name::text || ' '::text) || t1.last_name::text AS fullname
   FROM dblink('host=mydomain.address dbname=DB_NAME  
               user=USER_NAME password=PASSWORD'::text, 
               'select u.id,u.first_name,u.last_name,u.email,u.enabled from tbl_user_list as u'::text) 
               t1(id character varying, first_name character varying, last_name character varying, email character varying, enabled boolean);
