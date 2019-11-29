CREATE TABLE [dbo].[Employee](
	[SSN] [int] NOT NULL default 0,
	[ID] [int] UNIQUE,
	[Fname] [nvarchar](20) NOT NULL,
	[Lname] [nvarchar](30) NOT NULL,
	[DateOfBirth] [date] NOT NULL,
	[Email] [nvarchar](30) NOT NULL,
	[Position] [nvarchar](50) NOT NULL,    
	[PhoneNumber] [int] NOT NULL,
	[HomeNumber] [int] NOT NULL,
	[Address] [nvarchar](80) NOT NULL,
	[Salary] [smallmoney] NULL,
	[IsAdmin] [bit] NOT NULL
	CONSTRAINT [PK_EMPLOYEE] PRIMARY KEY 
	([SSN] ASC)
)

CREATE TABLE dbo.[Authentication](
  [SSN] [int] NOT NULL default 0,
  [Username] [nvarchar](30) NOT NULL,
  [Password] [nvarchar](30) NOT NULL,
  CONSTRAINT [PKAuthentication] PRIMARY KEY 
  ([Username] ASC)
)

CREATE TABLE dbo.[Client](
	[ID] [int] NOT NULL default 0 ,
	[Fname] [nvarchar](20) NOT NULL,
	[Lname] [nvarchar](30) NOT NULL,
	[DateOfBirth] [date] NOT NULL,
	[Email] [nvarchar](30) NOT NULL,
	[PhoneNumber] [int] NOT NULL,
	[HomeNumber] [int] NOT NULL,
	[Address] [nvarchar](80) NOT NULL,
  CONSTRAINT [PKClient] PRIMARY KEY 
  ([ID] ASC)
)

CREATE TABLE dbo.[Transactions](
  [TransactionID] [int] IDENTITY(1,1) , 
  [TransDate] [date] NOT NULL,
  [Price] [smallmoney]  NULL, --its calculated on its own
  [ClientID] [int] NOT NULL,
  CONSTRAINT [PKtransactions] PRIMARY KEY 
  ([TransactionID] ASC)
)


--New table 
Create Table dbo.TransPallet (
 [TransactionID] [int] NOT NULL,
 [PalletID] [smallint] UNIQUE  NOT NULL,
)


CREATE TABLE dbo.[Warehouse](
  [WarehouseID] [smallint] IDENTITY(1,1),
  [Location] [nvarchar](30) NOT NULL,
  [Capacity] [smallint] NOT NULL
  CONSTRAINT [PKwarehouse] PRIMARY KEY 
  ([WarehouseID] ASC)
)


CREATE TABLE dbo.[Pallet](
  [PalletID] [smallint] IDENTITY(1,1),
  [Position] [smallint] NOT NULL , --have to check in in procedure
  [WarehouseID] [smallint] NOT NULL,
  [ClientID][int]  NULL,
  [ImportDate] [date] NOT NULL,
  [ExportDate] [date] NOT NULL,
  [IsFood] [bit] NOT NULL,
  [ExpirDate] [date] NULL,
  [BasicCost][smallmoney] NOT NULL,
  [ExtraCost] [smallmoney] NOT NULL, 
  [TotalCost] [smallmoney]  NULL ,	-- Calculate in insert procedure	  
  CONSTRAINT [PKpallet] PRIMARY KEY
  ([PalletID] ASC)
)


CREATE TABLE dbo.[LogFile](
	[LogFileNo] [int] IDENTITY(1,1),
	[Date] [datetime] NOT NULL,
	[Report] varchar(MAX) NOT NULL
	CONSTRAINT [PKLogFile] PRIMARY KEY
    ([LogFileNo] ASC)
)


--Triggers


GO
Create Trigger CalculateTransCost on TransPallet
After insert
AS
begin
Declare @cost int , @price int
SET @cost = (
Select TotalCost from dbo.Pallet P where P.PalletID = (Select PalletID from inserted)
)
SET @price = (
Select price from dbo.Transactions T where TransactionID = (Select TransactionID from inserted)
)
IF (@price IS NULL) SET @price =0

UPDATE dbo.Transactions 
SET Price = @price + @cost where TransactionID = (Select TransactionID from inserted)
end
GO



--CONSTRAINTS 

ALTER TABLE dbo.[Employee] ADD CONSTRAINT ePhones
CHECK ( [PhoneNumber] LIKE '[0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9]'
	AND [HomeNumber] LIKE '[0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9]');

ALTER TABLE dbo.[Employee] ADD CONSTRAINT eSalary
CHECK ( [Salary] >= 0);

ALTER TABLE dbo.[Client] ADD CONSTRAINT cPhones
CHECK ( [PhoneNumber] LIKE '[0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9]'
	AND [HomeNumber] LIKE '[0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9]');

--ALTER TABLE dbo.[Transactions] ADD CONSTRAINT tPrice
--CHECK ( [Price] >=0 );

ALTER TABLE dbo.[Warehouse] ADD CONSTRAINT wCapacity
CHECK ( [Capacity] >=0 AND [Capacity] <= 1000 );

ALTER TABLE dbo.[Pallet] ADD CONSTRAINT pPallet
CHECK ( ([Position] % 100) <= 40 );

--ALTER TABLE dbo.[Pallet] ADD CONSTRAINT costPallet
--CHECK ( [TotalCost] = [BasicCost] + [ExtraCost]);

ALTER TABLE dbo.[Pallet] ADD CONSTRAINT datePallet
CHECK ( [ImportDate] < [ExportDate] AND [ImportDate] < [ExpirDate]);

--FOREIGN KEYS

ALTER TABLE [dbo].[Authentication] WITH CHECK
ADD CONSTRAINT [FK_Auth_Employee] FOREIGN KEY ([SSN])
REFERENCES [dbo].[Employee] ([SSN]) ON DELETE CASCADE ;



ALTER TABLE [dbo].[TransPallet] WITH CHECK
ADD CONSTRAINT [FK_transPallet_Transactions] FOREIGN KEY ([TransactionID])
REFERENCES [dbo].[Transactions] ([TransactionID]) ON DELETE CASCADE ;

ALTER TABLE [dbo].[TransPallet] WITH CHECK
ADD CONSTRAINT [FK_transPallet_PalletID] FOREIGN KEY ([PalletID])
REFERENCES [dbo].[Pallet] ([PalletID]) ON DELETE CASCADE  ;

ALTER TABLE [dbo].[Pallet] WITH CHECK
ADD CONSTRAINT [FK_Pallet_Warehouse] FOREIGN KEY ([WarehouseID])
REFERENCES [dbo].[Warehouse] ([WarehouseID]) ON DELETE CASCADE   ;

ALTER TABLE [dbo].[Pallet] WITH CHECK
ADD CONSTRAINT [FK_Pallet_Client] FOREIGN KEY ([ClientID])
REFERENCES [dbo].[Client] ([ID]) ON DELETE SET NULL ;

ALTER TABLE [dbo].[Transactions] WITH CHECK
ADD CONSTRAINT [FK_trans_Client] FOREIGN KEY ([ClientID])
REFERENCES [dbo].[Client] ([ID]) ON DELETE CASCADE ;
