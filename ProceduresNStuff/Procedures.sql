
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

declare @Position smallint =103,
@WarehouseID smallint =1,
@ClientID int = 798930 ,
@ExportDate date = '2019-12-01',
@isFood bit=0,
@ExpirDate date = NULL,
@BasicCost smallmoney = 100,
@ExtraCost smallmoney =10,
@outp int
exec @outp = PalletInsert @Position ,
@WarehouseID , @ClientID ,
@ExportDate ,
@isFood ,
@ExpirDate ,
@BasicCost ,
@ExtraCost 

select 'outp' = @outp

GO

--FREE POSITIONS
select * 
from dbo.Pallet
where ExportDate > GETDATE()


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
declare @PalletID int = 2 , @Position smallint =104,
@outp int
exec @outp = PalletUpdatePosition @PalletID, @Position 
select 'outp' = @outp

GO

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

 declare @PalletID int = 2 , @exportdate date = '2019-01-01',
@outp int
exec @outp = PalletUpdateExportDate @PalletID, @exportdate
select 'outp' = @outp

GO


--update extracost changes totalcost too also cant change it if the palletID exist in a transaction

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

 declare @PalletID int = 1 , @extracost int = 150,
@outp int
exec @outp = PalletUpdateExtraCost @PalletID, @extracost
select 'outp' = @outp

select * from Pallet


create procedure PalletShow
@PalletID int
AS
Begin
Select *
from dbo.Pallet
where PalletID = @PalletID
End
GO



Declare @PalletID int=2 exec PalletShow @palletID


create procedure PalletDelete
@PalletID int
AS
Begin
Delete
from dbo.Pallet
where PalletID = @PalletID
End
GO


Declare @PalletID int=2 exec PalletDelete @palletID
--Show and delete are left

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
@IsAdmin bit 
AS
 Begin
	INSERT INTO dbo.Employee (SSN,ID,LNAME,FNAME,DATEOFBIRTH,Email,POSITION,PHONENUMBER,HOMENUMBER,ADDRESS,SALARY,ISADMIN) VALUES (@SSN,@ID,@LNAME,@FNAME,@DATEOFBIRTH,@email,@POSITION,@PHONENUMBER,@HOMENUMBER,@ADDRESS,@SALARY,@ISADMIN)
	Return @SSN 
 end

Go

declare 
@SSN int = 1234567,
@ID int = 123456,
@FName nvarchar(20) = 'Hey',
@LName nvarchar(20) = 'Delilah',
@DateOfBirth date = '2019-01-01',
@Email nvarchar(30) = 'Sup@bestemail.com' ,
@Position nvarchar(50) = 'CEO',    
@PhoneNumber int =99666666,
@HomeNumber int = 24724666,
@Address nvarchar(80)= 'How are you?',
@Salary smallmoney = 99999,
@IsAdmin bit = 1,
@outp int
exec @outp = EmployeeInsert @SSN,
@ID ,
@FName ,
@LName ,
@DateOfBirth ,
@email,
@Position  ,   
@PhoneNumber ,
@HomeNumber ,
@Address ,
@Salary ,
@IsAdmin 
select 'outp' = @outp

GO

select *
from dbo.Employee

drop procedure EmployeeUpdateEmail

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


 declare @SSN int = 123457 , @email nvarchar(30) = 'evenbetter@email.com',
@outp int
exec @outp = EmployeeUpdateEmail @SSN, @email
select 'outp' = @outp

GO

drop procedure EmployeeUpdatePosition

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

  declare @SSN int = 1234567 , @Position nvarchar(50) = 'GOD',
@outp int
exec @outp = EmployeeUpdatePosition @SSN, @Position
select 'outp' = @outp

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

 create procedure EmployeeShow
@SSN int
AS
Begin
Select *
from dbo.Employee
where SSN = @SSN
End
GO



Declare @PalletID int=2 exec PalletShow @palletID


create procedure EmployeeDelete
@SSN int
AS
Begin
Delete
from dbo.Employee
where SSN= @SSN
End
GO
