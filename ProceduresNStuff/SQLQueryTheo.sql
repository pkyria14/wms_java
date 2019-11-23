DROP PROCEDURE ClientHistory

CREATE PROCEDURE ClientHistory
@CliendId int
AS
BEGIN
	SELECT T.TransactionID,T.TransDate,T.Price
	FROM dbo.Transactions T
	WHERE (T.ClientID = @CliendId AND T.Price IS NOT NULL)
END

-----------------------------------------------------------------------------------------

DROP PROCEDURE NotifyFood

CREATE PROCEDURE NotifyFood
AS
BEGIN
	SELECT P.PalletID,P.WarehouseID,P.Position,P.Clientid,P.ExpirDate
	FROM dbo.Pallet P
	WHERE P.IsFood = 1 AND getdate() <= P.ExpirDate AND (DATEDIFF(day,CONVERT(VARCHAR(10), getdate(), 111),CONVERT(VARCHAR(10), P.ExpirDate, 111)) <= 30)
END

------------------------------------------------------------------------------------------------------------------------------
DROP PROCEDURE PalletIdle

CREATE PROCEDURE PalletIdle
AS
BEGIN
	SELECT P.PalletID,P.WarehouseID,P.Position,P.Clientid,P.ImportDate
	FROM dbo.Pallet P
	WHERE (DATEDIFF(day,CONVERT(VARCHAR(10), P.ImportDate, 111),CONVERT(VARCHAR(10), getdate(), 111)) >= 120)
END

exec PalletIdle

------------------------------------------------------------------------------------------------------------------------
DROP PROCEDURE Auth

CREATE PROCEDURE Auth
@username varchar(30),@password varchar(30)
AS
BEGIN
	IF EXISTS(
		SELECT A.SSN
		FROM dbo.Authentication A
		WHERE A.Username = @username AND A.Password = @password)
	BEGIN 
		SELECT A.SSN
		FROM dbo.Authentication A
		WHERE A.Username = @username AND A.Password = @password
	END
	ELSE
	BEGIN
		SELECT 0000
	END
END

DECLARE @username varchar(30),@password varchar(30)
SET @username = 'molagene1'
SET @password = 'hmLcP6g'
exec Auth @username,@password

------------------------------------------------------------------------------------------------------------------------------

DROP PROCEDURE NotifyFull

CREATE PROCEDURE NotifyFull
AS
BEGIN
	DECLARE @Capacity int
	SET @Capacity = (
			SELECT W.Capacity
			FROM dbo.Warehouse W
			WHERE W.WarehouseID = 1)

	DECLARE @Items int
	SET @Items = (
			SELECT COUNT(*)
			FROM dbo.Pallet P
			WHERE P.ExportDate >= getdate() and P.WarehouseID = 1)
	SELECT @Capacity - @Items
END

---------------------------------------------------------------------------------------------------------------------------------

DROP PROCEDURE SearchItemByClient

CREATE PROCEDURE SearchItemByClient
@ClientID int
AS
BEGIN
SELECT 	P.*												
FROM dbo.Pallet P
WHERE @ClientID = P.Clientid
END


DROP PROCEDURE SearchItemByPallet

CREATE PROCEDURE SearchItemByPallet
@PalletID int
AS
BEGIN
SELECT 	P.*										
FROM dbo.Pallet P
WHERE @PalletID = P.PalletID
END


DROP PROCEDURE SearchItemByPosition

CREATE PROCEDURE SearchItemByPosition
@position int
AS
BEGIN
SELECT 	P.*													
FROM dbo.Pallet P
WHERE @position = P.Position
END

DECLARE @position INT
SET @position = 104
EXEC SearchItemByPosition @position

--------------------------------------------------------------------------------------------------------------------

DROP PROCEDURE GetCost

CREATE PROCEDURE GetCost
@PalletID int
AS
BEGIN
	SELECT P.ExtraCost, P.BasicCost, P.TotalCost
	FROM dbo.Pallet P,DBO.Transactions t
	WHERE P.PalletID = @PalletID
END


-------------------------------------------------------------------------------------------------------------------
DROP PROCEDURE InsertTrans

CREATE PROCEDURE InsertTrans
@ClientID int,@price int
AS
BEGIN
	DECLARE @TransID int
	INSERT INTO dbo.Transactions(ClientID,Price,TransDate) VALUES (@ClientID,@price,getdate())
	SET @TransID = SCOPE_IDENTITY()
	RETURN @TransID
END
