CREATE OR REPLACE FUNCTION APPS.fixed_img(p_blob       BLOB,

                                     in_width     NUMBER,

                                     in_height    NUMBER)

   RETURN BLOB

IS

   vimagedata    BLOB;

   vsizedimage   BLOB;

BEGIN

   vimagedata := p_blob;

   DBMS_LOB.createtemporary(vsizedimage, FALSE, DBMS_LOB.call);

   ordsys.ordimage.processcopy(vimagedata,

                               'fixedScale=' || in_width || ' ' || in_height,

                               vsizedimage);

   RETURN vsizedimage;

END;
/

