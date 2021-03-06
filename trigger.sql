/*TRIGGER ĐỂ GIẢM SỐ SÁCH TRONG KHO KHI MƯỢN*/
CREATE TRIGGER TRG_MUONSACH_INSERT
ON PHIEUYEUCAU
FOR INSERT
AS
 DECLARE @SL_CON INT /* SỐ LƯỢNG SACH CON */
 DECLARE @SL_MUON INT /* SỐ LƯỢNG SACH MUON */
 DECLARE @MASACH INT /* MÃ SACH */
 SELECT @MASACH=MASACH,@SL_MUON=SOLUONGMUON
 FROM INSERTED

 SELECT @SL_CON = SOLUONGSACHCON
 FROM SACH WHERE @MASACH=MASACH
 /*NẾU SỐ LƯỢNG HÀNG HIỆN CÓ NHỎ HƠN SỐ LƯỢNG MƯỢN
 THÌ HUỶ BỎ THAO TÁC BỔ SUNG DỮ LIỆU */

 IF @SL_CON<@SL_MUON
 ROLLBACK TRANSACTION
 /* NẾU DỮ LIỆU HỢP LỆ
 THÌ GIẢM SỐ LƯỢNG HÀNG HIỆN CÓ */
 ELSE
 UPDATE SACH
 SET SOLUONGSACHCON=SOLUONGSACHCON-@SL_MUON
 WHERE MASACH=@MASACH 

 /*TRIGGER ĐỂ TĂNG SỐ SÁCH TRONG KHO KHI TRẢ*/
CREATE TRIGGER TRG_MUONSACH_DELETE
ON PHIEUYEUCAU
FOR DELETE
AS
 DECLARE @SL_CON INT /* SỐ LƯỢNG SACH CON */
 DECLARE @SL_MUON INT /* SỐ LƯỢNG SACH MUON */
 DECLARE @MASACH INT /* MÃ SACH */
 SELECT @MASACH=MASACH,@SL_MUON=SOLUONGMUON
 FROM DELETED

 SELECT @SL_CON = SOLUONGSACHCON
 FROM SACH WHERE @MASACH=MASACH

 UPDATE SACH
 SET SOLUONGSACHCON=SOLUONGSACHCON+@SL_MUON
 WHERE MASACH=@MASACH 

/*TRIGGER ĐỂ THAY ĐỔI SỐ SÁCH TRONG KHO KHI UPDATE SỐ LƯỢNG MƯỢN*/
CREATE TRIGGER TRG_MUONSACH_UPDATE
ON PHIEUYEUCAU
FOR UPDATE
AS
DECLARE @SL_MUON INT /* SỐ LƯỢNG SACH THEM */
DECLARE @MASACH INT /* SỐ LƯỢNG SACH THEM */
DECLARE @SL_XOA INT /* SỐ LƯỢNG SACH XOA */
DECLARE @SL_CON INT /* SỐ LƯỢNG SACH CON */
DECLARE @SL_TONG INT /* SỐ LƯỢNG SACH TONG */
 SELECT @SL_MUON=SOLUONGMUON
 FROM INSERTED 
  SELECT @SL_XOA=SOLUONGMUON
 FROM DELETED 
  SELECT @SL_CON=SOLUONGSACHCON
 FROM SACH WHERE @MASACH=MASACH

 SET @SL_TONG=@SL_CON-@SL_MUON+@SL_XOA
 IF @SL_TONG<0
 ROLLBACK TRANSACTION
ELSE IF UPDATE(SOLUONGMUON)
 UPDATE SACH
 SET SOLUONGSACHCON = SOLUONGSACHCON -
 (INSERTED.SOLUONGMUON-DELETED.SOLUONGMUON)
 FROM (DELETED INNER JOIN INSERTED ON
 DELETED.SOPHIEU = INSERTED.SOPHIEU) INNER JOIN SACH
 ON SACH.MASACH = DELETED.MASACH 

 /*TRIGGER ĐỂ KHÔNG CHO MƯỢN VƯỢT QUÁ SỐ LƯỢNG CHO PHÉP*/
 CREATE TRIGGER TRG_MUONSACHVUOTSL_INSERT
ON PHIEUYEUCAU
FOR INSERT
AS
DECLARE @MADOCGIA INT /* MA ĐỘC GIẢ */
DECLARE @SL_MUON INT /* SỐ LƯỢNG SACH MUON */
DECLARE @SL_DUOCMUON INT /* SỐ LƯỢNG SÁCH ĐƯỢC MƯỢN */
 SELECT @SL_MUON=SOLUONGMUON, @MADOCGIA=MADOCGIA
 FROM INSERTED

SELECT @SL_DUOCMUON=SOLUONGSACHDUOCMUON
 FROM DOCGIA

  /*NẾU SỐ LƯỢNG HÀNG HIỆN CÓ NHỎ HƠN SỐ LƯỢNG MƯỢN
 THÌ HUỶ BỎ THAO TÁC BỔ SUNG DỮ LIỆU */

 IF @SL_DUOCMUON<@SL_MUON 
 ROLLBACK TRANSACTION
 /* NẾU DỮ LIỆU HỢP LỆ
 THÌ GIẢM SỐ LƯỢNG HÀNG HIỆN CÓ */
 ELSE
 UPDATE DOCGIA
 SET SOLUONGSACHDUOCMUON=SOLUONGSACHDUOCMUON-@SL_MUON
 WHERE MADOCGIA=@MADOCGIA


 /*TRIGGER ĐỂ TĂNG SỐ LƯỢNG ĐƯỢC MƯỢN CỦA ĐỘC GIẢ KHI TRẢ*/
CREATE TRIGGER TRG_MUONSACHSOLUONGMUON_DELETE
ON PHIEUYEUCAU
FOR DELETE
AS
 DECLARE @SL_DUOCMUON INT /* SỐ LƯỢNG SACH ĐƯỢC MƯỢN */
 DECLARE @SL_MUON INT /* SỐ LƯỢNG SACH MUON */
 DECLARE @MADOCGIA INT /* MÃ ĐỘC GIẢ */
 SELECT @MADOCGIA=MADOCGIA,@SL_MUON=SOLUONGMUON
 FROM DELETED

 SELECT @SL_DUOCMUON=SOLUONGSACHDUOCMUON
 FROM DOCGIA WHERE @MADOCGIA=MADOCGIA

 UPDATE DOCGIA
 SET SOLUONGSACHDUOCMUON=SOLUONGSACHDUOCMUON+@SL_MUON
 WHERE MADOCGIA=@MADOCGIA

