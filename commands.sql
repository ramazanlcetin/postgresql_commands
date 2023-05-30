--Create Custom Type (Özel Tip Oluşturma)
CREATE TYPE public."enum_publication_type" 
AS ENUM ('RESEARCH','COMPILATION','FACT_PRESENTATION','OTHER','BOOK_PRESENTATION','CORRECTION',
                                                    'EDITORIAL','LETTER','LETTER_TO_EDITOR','MEETING_SUMMARY','REPORT','RETRACTED','SHORT_REPORT','TRANSLATION');

--Add Property On Custom Type (Özel Tipe Veri Veri Ekleme)
ALTER TYPE enum_publication_type ADD VALUE  IF NOT EXISTS  'NOTE';
