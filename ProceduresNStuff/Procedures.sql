
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

--Show and delete are left