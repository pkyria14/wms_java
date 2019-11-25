DROP PROCEDURE ClientInsert
GO
CREATE PROCEDURE  ClientInsert
@ID int, @fname nvarchar(20),@Lname nvarchar(20), @DoB date, @Email nvarchar(30),
@PhoneN int, @HomeN int, @Address nvarchar(80)
As
Begin

Insert Into dbo.Client(ID, Fname,Lname,DateOfBirth,Email,PhoneNumber,HomeNumber,Address) values(@ID,@fname, @Lname, @DoB,@Email,@PhoneN,@HomeN,@Address)

return @ID
end

GO

Drop Procedure ClientUpdateEmail
GO
Create procedure ClientUpdateEmail
@ID int , @Email nvarchar(30)
As
begin
update dbo.Client
set Email=@Email
where ID=@ID
return @ID
END

go

-----------------------------------------
Drop Procedure ClientUpdatePersonalPhone
GO

Create procedure ClientUpdatePersonalPhone
@ID int , @Phone int
As
begin
update dbo.Client
set PhoneNumber=@Phone
where ID=@ID
return @ID
END

GO

------------------------------------------
Drop Procedure ClientUpdateResidentHome
GO

Create procedure ClientUpdateResidentHome
@ID int , @Phone int
As
begin
update dbo.Client
set HomeNumber=@Phone
where ID=@ID
return @ID
END

GO


-----------------------------------
Drop Procedure ClientUpdateAddress

GO
Create procedure ClientUpdateAddress
@ID int , @Address nvarchar(80)
As
begin
update dbo.Client
set Address=@Address
where ID=@ID
return @ID
END

GO


-------------------------
Drop Procedure ClientDelete

go

Create Procedure ClientDelete
@ID int
as
begin
delete
from dbo.Client
where ID=@ID
end

go

--------------------------
Drop procedure ClientShow
GO

Create Procedure ClientShow
@ID int
as 
begin
select *
from dbo.Client
where dbo.client.ID=@ID
END

GO



drop procedure PalletInsert

Go

Create Procedure PalletInsert
@Position smallint,
@WarehouseID smallint,
@ClientID int ,
@ExportDate date,
@isFood bit,
@ExpirDate date,
@BasicCost smallmoney,
@ExtraCost smallmoney
AS
Declare @ImportDate date = GETDATE()
Declare @PalletID int
Begin
IF Exists (select * from dbo.Pallet P where p.Position = @position AND p.ExportDate >= @ImportDate)
	Begin
		RAISERROR ('Position is taken',15,1);
	end
ELSE
  Begin
	INSERT INTO dbo.Pallet (Position,WarehouseID,ClientID,ImportDate,ExportDate,IsFood,ExpirDate,BasicCost,ExtraCost,TotalCost) VALUES (@Position,@WarehouseID,@ClientID,@ImportDate,@ExportDate,@isFood,@ExpirDate,@BasicCost,@ExtraCost,@BasicCost+@ExtraCost)
    SET @PalletID = SCOPE_IDENTITY() 
	Return @PalletID
  end
end
Go

drop procedure PalletUpdatePosition

Go

Create procedure PalletUpdatePosition
@PalletID int,@position smallint
As
BEGIN
IF Exists (select * from dbo.Pallet P where p.Position = @position AND p.ExportDate >= GETDATE())
	Begin
		RAISERROR ('Position is taken',15,1);
	end
ELSE
   Begin
   update dbo.Pallet 
   SET Position=@position
   where PalletID = @PalletID
   Return @PalletID
   end
END


GO

drop procedure PalletUpdateExportDate

Go


Create procedure PalletUpdateExportDate
@PalletID int,@exportdate date
As
 Begin
   update dbo.Pallet 
   SET ExportDate=@exportdate
   where PalletID = @PalletID
   Return @PalletID
 end

 GO



--update extracost changes totalcost too also cant change it if the palletID exist in a transaction
drop procedure PalletUpdateExtraCost

Go

Create procedure PalletUpdateExtraCost
@PalletID int,@extracost smallint
As
BEGIN
IF Exists (select * from dbo.TransPallet P where PalletID=@PalletID)
	Begin
		RAISERROR ('Cant change the price of the product when the transaction has been made.',15,1);
	end
ELSE
   Begin
   update dbo.Pallet 
   SET ExtraCost=@extracost
   where PalletID = @PalletID
   update dbo.Pallet
   SET totalcost = @extracost + BasicCost
   where PalletID = @PalletID
   Return @PalletID
   end
END

GO 

drop procedure PalletShow

Go

create procedure PalletShow
@PalletID int
AS
Begin
Select *
from dbo.Pallet
where PalletID = @PalletID
End

GO

drop procedure PalletDelete

Go

create procedure PalletDelete
@PalletID int
AS
Begin
Delete
from dbo.Pallet
where PalletID = @PalletID
End
GO

--------
---Employee---

drop procedure EmployeeInsert

Go
Create Procedure EmployeeInsert
@SSN int,
@ID int,
@FName nvarchar(20),
@LName nvarchar(20),
@DateOfBirth date ,
@Email nvarchar(30),
@Position nvarchar(50) ,    
@PhoneNumber int ,
@HomeNumber int,
@Address nvarchar(80),
@Salary smallmoney ,
@IsAdmin bit ,
@username nvarchar(30),
@password nvarchar(30)
AS
 Begin
	INSERT INTO dbo.Employee (SSN,ID,LNAME,FNAME,DATEOFBIRTH,Email,POSITION,PHONENUMBER,HOMENUMBER,ADDRESS,SALARY,ISADMIN) VALUES (@SSN,@ID,@LNAME,@FNAME,@DATEOFBIRTH,@email,@POSITION,@PHONENUMBER,@HOMENUMBER,@ADDRESS,@SALARY,@ISADMIN)
	INSERT INTO dbo.Authentication (Username,Password) VALUES (@username,@password)
	Return @SSN 
 end

Go


drop procedure EmployeeUpdateEmail

GO

Create procedure EmployeeUpdateEmail
@SSN int,@Email nvarchar(30)
As
begin
IF EXISTS (select * from dbo.Employee where SSN=@SSN) 
  Begin
   update dbo.Employee
   SET Email=@email
   where SSN = @SSN
   Return @SSN
  end
ELSE
  begin
  RAISERROR ('The SSN doesnt exist.',15,1);
  end
 end
 GO


drop procedure EmployeeUpdatePosition
GO

Create procedure EmployeeUpdatePosition
@SSN int, @Position nvarchar(50)
As
begin
IF EXISTS (select * from dbo.Employee where SSN=@SSN) 
  Begin
   update dbo.Employee
   SET Position=@Position
   where SSN = @SSN
   Return @SSN
  end
ELSE
  begin
  RAISERROR ('The SSN doesnt exist.',15,1);
  end
 end
 GO

   drop procedure EmployeeUpdatePhoneNumber
  Go

Create procedure EmployeeUpdatePhoneNumber
@SSN int, @PhoneNumber int
As
begin
IF EXISTS (select * from dbo.Employee where SSN=@SSN) 
  Begin
   update dbo.Employee
   SET PhoneNumber=@PhoneNumber
   where SSN = @SSN
   Return @SSN
  end
ELSE
  begin
  RAISERROR ('The SSN doesnt exist.',15,1);
  end
 end
 GO

   drop procedure EmployeeUpdateSalary
  Go

Create procedure EmployeeUpdateSalary
@SSN int, @Salary int
As
begin
IF EXISTS (select * from dbo.Employee where SSN=@SSN) 
  Begin
   update dbo.Employee
   SET Salary=@Salary
   where SSN = @SSN
   Return @SSN
  end
ELSE
  begin
  RAISERROR ('The SSN doesnt exist.',15,1);
  end
 end
 GO

  drop procedure EmployeeUpdateAddress
  Go
 Create procedure EmployeeUpdateAddress
@SSN int, @Address nvarchar(80)
As
begin
IF EXISTS (select * from dbo.Employee where SSN=@SSN) 
  Begin
   update dbo.Employee
   SET Address=@Address
   where SSN = @SSN
   Return @SSN
  end
ELSE
  begin
  RAISERROR ('The SSN doesnt exist.',15,1);
  end
 end
 GO

 drop procedure EmployeeUpdateisAdmin

 Go
 Create procedure EmployeeUpdateisAdmin
@SSN int, @isAdmin bit
As
begin
IF EXISTS (select * from dbo.Employee where SSN=@SSN) 
  Begin
   update dbo.Employee
   SET isAdmin=@isAdmin
   where SSN = @SSN
   Return @SSN
  end
ELSE
  begin
  RAISERROR ('The SSN doesnt exist.',15,1);
  end
 end

 GO

 DROP PROCEDURE EmployeeShow
 go
 create procedure EmployeeShow
@SSN int
AS
Begin
Select *
from dbo.Employee
where SSN = @SSN
End
GO


DROP PROCEDURE EmployeeDelete
Go
create procedure EmployeeDelete
@SSN int
AS
Begin
Delete
from dbo.Employee
where SSN= @SSN
End
GO

DROP PROCEDURE printClient
Go
create procedure printClient
As
begin
select * from dbo.Client
end

Go

DROP PROCEDURE printEmployee

create procedure printEmployee
As
begin
select * from dbo.Employee
end

GO

DROP PROCEDURE printPallet
Go
create procedure printPallet
As
begin
select * from dbo.Pallet
end

GO

DROP PROCEDURE printTransactions
Go
create procedure printTransactions
As
begin
select * from dbo.Transactions
end

GO

DROP PROCEDURE printPallet

GO

create procedure printTransPallet
As
begin
select * from dbo.TransPallet
end
GO

DROP PROCEDURE printWarehouse
go

create procedure printWarehouse
As
begin
select * from dbo.Warehouse
end
GO

DROP PROCEDURE ClientHistory

GO

CREATE PROCEDURE ClientHistory
@CliendId int
AS
BEGIN
	SELECT T.TransactionID,T.TransDate,T.Price
	FROM dbo.Transactions T
	WHERE (T.ClientID = @CliendId AND T.Price IS NOT NULL)
END

-----------------------------------------------------------------------------------------

GO

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

GO

------------------------------------------------------------------------------------------------------------------------
DROP PROCEDURE Auth

GO

CREATE PROCEDURE Auth
@username varchar(30),@password varchar(30)
AS
BEGIN
	IF EXISTS(
		SELECT A.SSN
		FROM dbo.Authentication A
		WHERE A.Username = @username AND A.Password = @password)
	BEGIN 
		Return (SELECT A.SSN
		FROM dbo.Authentication A
		WHERE A.Username = @username AND A.Password = @password)
	END
	ELSE
	BEGIN
		return 0000
	END
END

GO
------------------------------------------------------------------------------------------------------------------------------

DROP PROCEDURE NotifyFull

go

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
go
DROP PROCEDURE SearchItemByClient

GO
CREATE PROCEDURE SearchItemByClient
@ClientID int
AS
BEGIN
SELECT 	P.*												
FROM dbo.Pallet P
WHERE @ClientID = P.Clientid
END

go


DROP PROCEDURE SearchItemByPosition
go
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

go
DROP PROCEDURE GetCost

go
CREATE PROCEDURE GetCost
@PalletID int
AS
BEGIN
	SELECT P.ExtraCost, P.BasicCost, P.TotalCost
	FROM dbo.Pallet P,DBO.Transactions t
	WHERE P.PalletID = @PalletID
END

go
-------------------------------------------------------------------------------------------------------------------
DROP PROCEDURE InsertTrans
GO
CREATE PROCEDURE InsertTrans
@ClientID int,@price int
AS
BEGIN
	DECLARE @TransID int
	INSERT INTO dbo.Transactions(ClientID,Price,TransDate) VALUES (@ClientID,@price,getdate())
	SET @TransID = SCOPE_IDENTITY()
	RETURN @TransID
END
