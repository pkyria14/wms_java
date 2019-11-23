
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

select * 
from dbo.Pallet
where ExportDate > GETDATE()

