--TABLES
CREATE TABLE [dbo].[Employee](
	[SSN] [int] NOT NULL,
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
  [SSN] [int] NOT NULL,
  [Username] [nvarchar](30) NOT NULL,
  [Password] [nvarchar](30) NOT NULL,
  CONSTRAINT [PKAuthentication] PRIMARY KEY 
  ([Username] ASC)
)

CREATE TABLE dbo.[Client](
	[ID] [int] NOT NULL,
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

CREATE TABLE dbo.[Transcactions](
  [TranscactionID] [int] IDENTITY(1,1), 
  [TransDate] [date] NOT NULL,
  [Price] [smallmoney] NOT NULL,
  [ClientID] [int] NOT NULL,
  [PalletID] [smallint] NOT NULL
  CONSTRAINT [PKtranscactions] PRIMARY KEY 
  ([TranscactionID] ASC)
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
  [Position] [smallint] NOT NULL UNIQUE,
  [WarehouseID] [smallint] NOT NULL,
  [Clientid][int] NOT NULL,
  [ImportDate] [date] NOT NULL,
  [ExportDate] [date] NOT NULL,
  [IsFood] [bit] NOT NULL,
  [ExpirDate] [date] NOT NULL,
  [TotalCost] [smallmoney] NOT NULL,
  [BasicCost][smallmoney] NOT NULL,
  [ExtraCost] [smallmoney] NOT NULL
  CONSTRAINT [PKpallet] PRIMARY KEY
  ([PalletID] ASC)
)

CREATE TABLE dbo.[LogFile](
	[LogFileNo] [int] IDENTITY(1,1),
	[Date] [date] NOT NULL,
	[Report] [Text] NOT NULL
	CONSTRAINT [PKLogFile] PRIMARY KEY
    ([LogFileNo] ASC)
)

--CONSTRAINTS 

ALTER TABLE dbo.[Employee] ADD CONSTRAINT ePhones
CHECK ( [PhoneNumber] LIKE '[0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9]'
	AND [HomeNumber] LIKE '[0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9]');

ALTER TABLE dbo.[Employee] ADD CONSTRAINT eSalary
CHECK ( [Salary] >= 0);

ALTER TABLE dbo.[Client] ADD CONSTRAINT cPhones
CHECK ( [PhoneNumber] LIKE '[0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9]'
	AND [HomeNumber] LIKE '[0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9]');

ALTER TABLE dbo.[Transcactions] ADD CONSTRAINT tPrice
CHECK ( [Price] >=0 );

ALTER TABLE dbo.[Warehouse] ADD CONSTRAINT wCapacity
CHECK ( [Capacity] >=0 AND [Capacity] <= 1000 );

ALTER TABLE dbo.[Pallet] ADD CONSTRAINT pPallet
CHECK ( ([Position] % 100) < 40 );

ALTER TABLE dbo.[Pallet] ADD CONSTRAINT costPallet
CHECK ( [TotalCost] = [BasicCost] + [ExtraCost]);

ALTER TABLE dbo.[Pallet] ADD CONSTRAINT datePallet
CHECK ( [ImportDate] < [ExportDate] AND [ImportDate] < [ExpirDate]);

--FOREIGN KEYS

ALTER TABLE [dbo].[Authentication] WITH CHECK
ADD CONSTRAINT [FK_Auth_Employee] FOREIGN KEY ([SSN])
REFERENCES [dbo].[Employee] ([SSN]);

ALTER TABLE [dbo].[Transcactions] WITH CHECK
ADD CONSTRAINT [FK_trans_Client] FOREIGN KEY ([ClientID])
REFERENCES [dbo].[Client] ([ID]);

ALTER TABLE [dbo].[Transcactions] WITH CHECK
ADD CONSTRAINT [FK_trans_PalletID] FOREIGN KEY ([PalletID])
REFERENCES [dbo].[Pallet] ([PalletID]);

ALTER TABLE [dbo].[Pallet] WITH CHECK
ADD CONSTRAINT [FK_Pallet_Warehouse] FOREIGN KEY ([WarehouseID])
REFERENCES [dbo].[Warehouse] ([WarehouseID]);

ALTER TABLE [dbo].[Pallet] WITH CHECK
ADD CONSTRAINT [FK_Pallet_Client] FOREIGN KEY ([Clientid])
REFERENCES [dbo].[Client] ([ID]);
