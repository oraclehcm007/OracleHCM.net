CREATE OR REPLACE FUNCTION APPS.to_base64 (p_blob_in IN BLOB)
   RETURN CLOB
IS
   v_clob             CLOB;
   v_result           CLOB;
   v_offset           INTEGER;
   v_chunk_size       BINARY_INTEGER := (48 / 4) * 3;
   v_buffer_varchar   VARCHAR2 (48);
   v_buffer_raw       RAW (48);
BEGIN
/* --Ketan
Use only case of image conversion
*/
   IF p_blob_in IS NULL
   THEN
      RETURN NULL;
   END IF;

   DBMS_LOB.createtemporary (v_clob, TRUE);

   v_offset := 1;

   FOR i IN 1 .. CEIL (DBMS_LOB.getlength (p_blob_in) / v_chunk_size)
   LOOP
      DBMS_LOB.read (p_blob_in,
                     v_chunk_size,
                     v_offset,
                     v_buffer_raw);
      v_buffer_raw := UTL_ENCODE.base64_encode (v_buffer_raw);
      v_buffer_varchar := UTL_RAW.cast_to_varchar2 (v_buffer_raw);
      DBMS_LOB.writeappend (v_clob,
                            LENGTH (v_buffer_varchar),
                            v_buffer_varchar);
      v_offset := v_offset + v_chunk_size;

   END LOOP;

   v_result := v_clob;
   DBMS_LOB.freetemporary (v_clob);
   RETURN v_result;
   exception
   when others then
   DBMS_LOB.freetemporary (v_clob);
   return null;
END;
/

