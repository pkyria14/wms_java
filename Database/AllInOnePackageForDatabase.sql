---------------------------------

GO
ALTER TABLE [dbo].[TransPallet] DROP CONSTRAINT [FK_transPallet_Transactions]
GO
ALTER TABLE [dbo].[TransPallet] DROP CONSTRAINT [FK_transPallet_PalletID]
GO
ALTER TABLE [dbo].[Transactions] DROP CONSTRAINT [FK_trans_Client]
GO
ALTER TABLE [dbo].[Pallet] DROP CONSTRAINT [FK_Pallet_Warehouse]
GO
ALTER TABLE [dbo].[Pallet] DROP CONSTRAINT [FK_Pallet_Client]
GO
ALTER TABLE [dbo].[Authentication] DROP CONSTRAINT [FK_Auth_Employee]
GO

DROP TABLE [dbo].[Warehouse]
GO

DROP TABLE [dbo].[TransPallet]
GO

DROP TABLE [dbo].[Transactions]
GO

DROP TABLE [dbo].[Pallet]
GO

DROP TABLE [dbo].[LogFile]
GO

DROP TABLE [dbo].[Employee]
GO

DROP TABLE [dbo].[Client]
GO

DROP TABLE [dbo].[Authentication]
GO


--------------------------------------------------------------------

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
  [Position] [smallint] NOT NULL , 
  [WarehouseID] [smallint] NOT NULL,
  [ClientID][int]  NULL,
  [ImportDate] [date] NOT NULL,
  [ExportDate] [date] NOT NULL,
  [IsFood] [bit] NOT NULL,
  [ExpirDate] [date] NULL,
  [BasicCost][smallmoney] NOT NULL,
  [ExtraCost] [smallmoney] NOT NULL, 
  [TotalCost] [smallmoney]  NULL ,	  
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



ALTER TABLE dbo.[Warehouse] ADD CONSTRAINT wCapacity
CHECK ( [Capacity] >=0 AND [Capacity] <= 1000 );

ALTER TABLE dbo.[Pallet] ADD CONSTRAINT pPallet
CHECK ( ([Position] % 100) <= 40 );



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


----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

INSERT INTO dbo.Client(ID,Fname,Lname,DateOfBirth,Email,PhoneNumber,HomeNumber,Address) VALUES (800341,'Lisha','Maleham','1969-09-22','lmaleham0@usda.gov',99711495,24683417,'29479 Hoepker Point');
INSERT INTO dbo.Client(ID,Fname,Lname,DateOfBirth,Email,PhoneNumber,HomeNumber,Address) VALUES (268011,'Reyna','Abberley','1978-01-28','rabberley1@shareasale.com',99163894,24124694,'68 Vahlen Street');
INSERT INTO dbo.Client(ID,Fname,Lname,DateOfBirth,Email,PhoneNumber,HomeNumber,Address) VALUES (962498,'Audra','Dodd','1982-11-28','adodd2@vimeo.com',99497138,25016415,'08416 Nancy Lane');
INSERT INTO dbo.Client(ID,Fname,Lname,DateOfBirth,Email,PhoneNumber,HomeNumber,Address) VALUES (430909,'Lelia','Darte','1969-03-15','ldarte3@engadget.com',99049806,23274397,'6 Pawling Hill');
INSERT INTO dbo.Client(ID,Fname,Lname,DateOfBirth,Email,PhoneNumber,HomeNumber,Address) VALUES (259543,'Louis','De Angelo','1978-02-19','ldeangelo4@networksolutions.com',99278400,23176316,'5830 Muir Trail');
INSERT INTO dbo.Client(ID,Fname,Lname,DateOfBirth,Email,PhoneNumber,HomeNumber,Address) VALUES (765764,'Gabriel','Sygroves','1965-03-09','gsygroves5@weebly.com',99932641,24261012,'62150 Annamark Terrace');
INSERT INTO dbo.Client(ID,Fname,Lname,DateOfBirth,Email,PhoneNumber,HomeNumber,Address) VALUES (733283,'Ayn','Coggin','1965-03-11','acoggin6@pbs.org',99804241,25127512,'41590 Corben Point');
INSERT INTO dbo.Client(ID,Fname,Lname,DateOfBirth,Email,PhoneNumber,HomeNumber,Address) VALUES (339510,'Sela','Thomann','1980-08-15','sthomann7@sbwire.com',99739764,25407524,'6199 Warner Street');
INSERT INTO dbo.Client(ID,Fname,Lname,DateOfBirth,Email,PhoneNumber,HomeNumber,Address) VALUES (492399,'Noby','Dinsale','1978-04-20','ndinsale8@webs.com',99399728,23238128,'8 Mifflin Place');
INSERT INTO dbo.Client(ID,Fname,Lname,DateOfBirth,Email,PhoneNumber,HomeNumber,Address) VALUES (456429,'Jamil','Meugens','1997-10-29','jmeugens9@ucla.edu',99303905,22102922,'8557 Havey Alley');
INSERT INTO dbo.Client(ID,Fname,Lname,DateOfBirth,Email,PhoneNumber,HomeNumber,Address) VALUES (291141,'Franni','Medeway','1998-01-22','fmedewaya@123-reg.co.uk',99164527,25421727,'9111 Hudson Terrace');
INSERT INTO dbo.Client(ID,Fname,Lname,DateOfBirth,Email,PhoneNumber,HomeNumber,Address) VALUES (611779,'Burlie','Hepher','1978-04-26','bhepherb@devhub.com',99022450,23612855,'65 Buena Vista Road');
INSERT INTO dbo.Client(ID,Fname,Lname,DateOfBirth,Email,PhoneNumber,HomeNumber,Address) VALUES (553698,'Sig','Leathart','1979-06-25','sleathartc@pbs.org',99407457,25642815,'7996 Iowa Drive');
INSERT INTO dbo.Client(ID,Fname,Lname,DateOfBirth,Email,PhoneNumber,HomeNumber,Address) VALUES (313819,'Jessica','Westlake','1988-10-13','jwestlaked@1und1.de',99804456,25110285,'7 Mitchell Road');
INSERT INTO dbo.Client(ID,Fname,Lname,DateOfBirth,Email,PhoneNumber,HomeNumber,Address) VALUES (535723,'Belle','Gamon','1979-02-20','bgamone@hibu.com',99081734,25972767,'757 Meadow Vale Park');
INSERT INTO dbo.Client(ID,Fname,Lname,DateOfBirth,Email,PhoneNumber,HomeNumber,Address) VALUES (903363,'Wheeler','Morrant','1965-05-11','wmorrantf@barnesandnoble.com',99176283,24085234,'1017 Summit Court');
INSERT INTO dbo.Client(ID,Fname,Lname,DateOfBirth,Email,PhoneNumber,HomeNumber,Address) VALUES (506808,'Shirlene','Guichard','1993-01-06','sguichardg@wsj.com',99990330,24376066,'0322 Michigan Lane');
INSERT INTO dbo.Client(ID,Fname,Lname,DateOfBirth,Email,PhoneNumber,HomeNumber,Address) VALUES (267604,'Cyndy','McPaike','1969-05-24','cmcpaikeh@yahoo.co.jp',99983913,22935194,'2121 Crownhardt Way');
INSERT INTO dbo.Client(ID,Fname,Lname,DateOfBirth,Email,PhoneNumber,HomeNumber,Address) VALUES (343720,'Noell','Shulver','1984-09-06','nshulveri@patch.com',99745546,22948282,'53 Autumn Leaf Street');
INSERT INTO dbo.Client(ID,Fname,Lname,DateOfBirth,Email,PhoneNumber,HomeNumber,Address) VALUES (699753,'Selene','McCaughen','1962-03-09','smccaughenj@cpanel.net',99265465,23221768,'6 Pennsylvania Alley');
INSERT INTO dbo.Client(ID,Fname,Lname,DateOfBirth,Email,PhoneNumber,HomeNumber,Address) VALUES (930089,'Ulrica','Mosco','1995-02-21','umoscok@walmart.com',99980657,22902982,'169 Gina Park');
INSERT INTO dbo.Client(ID,Fname,Lname,DateOfBirth,Email,PhoneNumber,HomeNumber,Address) VALUES (547385,'Hort','Kirkwood','1982-11-21','hkirkwoodl@skype.com',99622705,25335457,'91175 Hoepker Point');
INSERT INTO dbo.Client(ID,Fname,Lname,DateOfBirth,Email,PhoneNumber,HomeNumber,Address) VALUES (664922,'Arlene','Meininger','1976-04-12','ameiningerm@ucla.edu',99498703,24165553,'021 Fieldstone Place');
INSERT INTO dbo.Client(ID,Fname,Lname,DateOfBirth,Email,PhoneNumber,HomeNumber,Address) VALUES (595251,'Benoit','Caws','1987-03-15','bcawsn@disqus.com',99293309,22948217,'089 Dorton Center');
INSERT INTO dbo.Client(ID,Fname,Lname,DateOfBirth,Email,PhoneNumber,HomeNumber,Address) VALUES (126639,'Tabbi','Eyam','1968-03-11','teyamo@nationalgeographic.com',99485540,24174042,'43 Maple Lane');
INSERT INTO dbo.Client(ID,Fname,Lname,DateOfBirth,Email,PhoneNumber,HomeNumber,Address) VALUES (660900,'Peirce','Grzelak','1981-08-11','pgrzelakp@usda.gov',99983390,22642146,'9289 Esker Crossing');
INSERT INTO dbo.Client(ID,Fname,Lname,DateOfBirth,Email,PhoneNumber,HomeNumber,Address) VALUES (177735,'Gaile','Bertelet','1997-06-01','gberteletq@cdbaby.com',99109867,22259798,'5343 Canary Terrace');
INSERT INTO dbo.Client(ID,Fname,Lname,DateOfBirth,Email,PhoneNumber,HomeNumber,Address) VALUES (793670,'Blondell','Foss','1976-07-18','bfossr@nbcnews.com',99295690,25727714,'33940 Sunnyside Crossing');
INSERT INTO dbo.Client(ID,Fname,Lname,DateOfBirth,Email,PhoneNumber,HomeNumber,Address) VALUES (810593,'Eldon','Mee','1962-04-14','emees@ezinearticles.com',99631930,22228378,'82316 Doe Crossing Circle');
INSERT INTO dbo.Client(ID,Fname,Lname,DateOfBirth,Email,PhoneNumber,HomeNumber,Address) VALUES (348271,'Saree','Hamly','1972-12-30','shamlyt@craigslist.org',99338671,22286440,'2940 Kingsford Road');
INSERT INTO dbo.Client(ID,Fname,Lname,DateOfBirth,Email,PhoneNumber,HomeNumber,Address) VALUES (557496,'Lorine','Hamil','1997-10-22','lhamilu@marriott.com',99433782,23918337,'084 Lawn Court');
INSERT INTO dbo.Client(ID,Fname,Lname,DateOfBirth,Email,PhoneNumber,HomeNumber,Address) VALUES (285130,'Zack','Kivlehan','1964-07-05','zkivlehanv@home.pl',99487309,25717199,'866 Roxbury Hill');
INSERT INTO dbo.Client(ID,Fname,Lname,DateOfBirth,Email,PhoneNumber,HomeNumber,Address) VALUES (879220,'Marcelo','Richings','1967-05-11','mrichingsw@homestead.com',99861757,22958593,'099 Logan Park');
INSERT INTO dbo.Client(ID,Fname,Lname,DateOfBirth,Email,PhoneNumber,HomeNumber,Address) VALUES (317794,'Birdie','Clampin','1967-04-10','bclampinx@geocities.com',99492969,23588000,'89 Eagle Crest Place');
INSERT INTO dbo.Client(ID,Fname,Lname,DateOfBirth,Email,PhoneNumber,HomeNumber,Address) VALUES (800364,'Phillipp','Tantum','1975-05-31','ptantumy@usgs.gov',99329196,23766028,'7837 Schlimgen Road');
INSERT INTO dbo.Client(ID,Fname,Lname,DateOfBirth,Email,PhoneNumber,HomeNumber,Address) VALUES (487506,'Mel','Hradsky','1989-04-08','mhradskyz@bluehost.com',99989547,22798022,'880 Texas Junction');
INSERT INTO dbo.Client(ID,Fname,Lname,DateOfBirth,Email,PhoneNumber,HomeNumber,Address) VALUES (692825,'Adan','Kaasman','1982-04-22','akaasman10@twitpic.com',99432865,23347354,'82820 Kingsford Road');
INSERT INTO dbo.Client(ID,Fname,Lname,DateOfBirth,Email,PhoneNumber,HomeNumber,Address) VALUES (803505,'Brendis','Attenborough','1964-08-23','battenborough11@dmoz.org',99808871,23764160,'88400 Mandrake Circle');
INSERT INTO dbo.Client(ID,Fname,Lname,DateOfBirth,Email,PhoneNumber,HomeNumber,Address) VALUES (916936,'Kellsie','Whiffin','1993-03-26','kwhiffin12@is.gd',99516998,22436574,'85 East Avenue');
INSERT INTO dbo.Client(ID,Fname,Lname,DateOfBirth,Email,PhoneNumber,HomeNumber,Address) VALUES (994385,'Mattias','Lumley','1973-11-17','mlumley13@npr.org',99319096,25068473,'5 Dixon Court');
INSERT INTO dbo.Client(ID,Fname,Lname,DateOfBirth,Email,PhoneNumber,HomeNumber,Address) VALUES (250221,'Nathalie','Plowell','1962-12-02','nplowell14@skype.com',99240903,23486785,'25653 Reinke Drive');
INSERT INTO dbo.Client(ID,Fname,Lname,DateOfBirth,Email,PhoneNumber,HomeNumber,Address) VALUES (514942,'Gui','Newe','1972-01-13','gnewe15@timesonline.co.uk',99279211,25678079,'032 Rieder Alley');
INSERT INTO dbo.Client(ID,Fname,Lname,DateOfBirth,Email,PhoneNumber,HomeNumber,Address) VALUES (123022,'Jillian','Harget','1967-10-24','jharget16@canalblog.com',99346773,24846995,'3115 Fremont Parkway');
INSERT INTO dbo.Client(ID,Fname,Lname,DateOfBirth,Email,PhoneNumber,HomeNumber,Address) VALUES (984783,'Con','O''Mannion','1973-10-09','comannion17@narod.ru',99817852,22878813,'5084 Transport Junction');
INSERT INTO dbo.Client(ID,Fname,Lname,DateOfBirth,Email,PhoneNumber,HomeNumber,Address) VALUES (850568,'Diane','Semple','1975-04-14','dsemple18@gravatar.com',99478621,25357339,'2 North Crossing');
INSERT INTO dbo.Client(ID,Fname,Lname,DateOfBirth,Email,PhoneNumber,HomeNumber,Address) VALUES (114641,'Lanette','Pentycost','1972-11-25','lpentycost19@cdc.gov',99634291,24138464,'5850 Arkansas Junction');
INSERT INTO dbo.Client(ID,Fname,Lname,DateOfBirth,Email,PhoneNumber,HomeNumber,Address) VALUES (853461,'Kiah','Eddie','1967-12-14','keddie1a@usa.gov',99075612,25434540,'1529 Fulton Avenue');
INSERT INTO dbo.Client(ID,Fname,Lname,DateOfBirth,Email,PhoneNumber,HomeNumber,Address) VALUES (205573,'Erina','Cowtherd','1961-06-08','ecowtherd1b@tumblr.com',99981375,23901867,'0 Straubel Avenue');
INSERT INTO dbo.Client(ID,Fname,Lname,DateOfBirth,Email,PhoneNumber,HomeNumber,Address) VALUES (470355,'Murdoch','Elcy','1961-04-26','melcy1c@51.la',99210407,23538571,'8 Homewood Trail');
INSERT INTO dbo.Client(ID,Fname,Lname,DateOfBirth,Email,PhoneNumber,HomeNumber,Address) VALUES (106830,'Ellyn','Dreamer','1982-07-29','edreamer1d@wikimedia.org',99107677,23383757,'76243 Waywood Terrace');
INSERT INTO dbo.Client(ID,Fname,Lname,DateOfBirth,Email,PhoneNumber,HomeNumber,Address) VALUES (795904,'Sigismundo','Shurmer','1983-02-10','sshurmer1e@xing.com',99964561,23405247,'08 Reinke Alley');
INSERT INTO dbo.Client(ID,Fname,Lname,DateOfBirth,Email,PhoneNumber,HomeNumber,Address) VALUES (747952,'Kienan','Copcutt','1994-01-15','kcopcutt1f@nba.com',99356519,24770675,'15 Superior Street');
INSERT INTO dbo.Client(ID,Fname,Lname,DateOfBirth,Email,PhoneNumber,HomeNumber,Address) VALUES (813346,'Tierney','Dring','1972-05-04','tdring1g@oakley.com',99177853,24008622,'22926 Forest Hill');
INSERT INTO dbo.Client(ID,Fname,Lname,DateOfBirth,Email,PhoneNumber,HomeNumber,Address) VALUES (463857,'Nestor','Latham','1995-10-07','nlatham1h@ebay.com',99650705,25997930,'0 Cody Park');
INSERT INTO dbo.Client(ID,Fname,Lname,DateOfBirth,Email,PhoneNumber,HomeNumber,Address) VALUES (382414,'Elwyn','LAbbet','1970-08-08','elabbet1i@cafepress.com',99380735,23754090,'54907 Linden Street');
INSERT INTO dbo.Client(ID,Fname,Lname,DateOfBirth,Email,PhoneNumber,HomeNumber,Address) VALUES (371868,'Orbadiah','Colter','1963-05-27','ocolter1j@sakura.ne.jp',99036430,25046671,'36 Chinook Terrace');
INSERT INTO dbo.Client(ID,Fname,Lname,DateOfBirth,Email,PhoneNumber,HomeNumber,Address) VALUES (885804,'Mallory','Hunnawill','1968-01-06','mhunnawill1k@sun.com',99810024,24046475,'3810 Hanson Alley');
INSERT INTO dbo.Client(ID,Fname,Lname,DateOfBirth,Email,PhoneNumber,HomeNumber,Address) VALUES (763136,'Jacinthe','Mylchreest','1995-02-11','jmylchreest1l@latimes.com',99553781,24690816,'2 Sage Avenue');
INSERT INTO dbo.Client(ID,Fname,Lname,DateOfBirth,Email,PhoneNumber,HomeNumber,Address) VALUES (521995,'Aloise','Tildesley','1964-10-30','atildesley1m@cisco.com',99971543,24474285,'38366 Westport Center');
INSERT INTO dbo.Client(ID,Fname,Lname,DateOfBirth,Email,PhoneNumber,HomeNumber,Address) VALUES (942887,'Honey','Jonuzi','1968-03-24','hjonuzi1n@va.gov',99382676,22926715,'5809 Hintze Terrace');
INSERT INTO dbo.Client(ID,Fname,Lname,DateOfBirth,Email,PhoneNumber,HomeNumber,Address) VALUES (585922,'Dorotea','Cayley','1984-01-26','dcayley1o@hatena.ne.jp',99647780,24340214,'74 Drewry Drive');
INSERT INTO dbo.Client(ID,Fname,Lname,DateOfBirth,Email,PhoneNumber,HomeNumber,Address) VALUES (470973,'Babb','Trussell','1982-04-21','btrussell1p@mozilla.org',99901740,22163657,'47946 Cottonwood Road');
INSERT INTO dbo.Client(ID,Fname,Lname,DateOfBirth,Email,PhoneNumber,HomeNumber,Address) VALUES (593630,'Sayre','Woodhouse','1976-10-22','swoodhouse1q@imageshack.us',99553898,24612615,'28949 Eagle Crest Court');
INSERT INTO dbo.Client(ID,Fname,Lname,DateOfBirth,Email,PhoneNumber,HomeNumber,Address) VALUES (578882,'Celie','Jenking','1974-07-24','cjenking1r@archive.org',99743781,22228942,'2080 Granby Road');
INSERT INTO dbo.Client(ID,Fname,Lname,DateOfBirth,Email,PhoneNumber,HomeNumber,Address) VALUES (899310,'Nana','Redington','1961-05-21','nredington1s@weibo.com',99909309,24142917,'2 Sherman Center');
INSERT INTO dbo.Client(ID,Fname,Lname,DateOfBirth,Email,PhoneNumber,HomeNumber,Address) VALUES (159342,'Valentijn','Fauguel','1977-06-09','vfauguel1t@sciencedaily.com',99544345,23581569,'18 Graedel Park');
INSERT INTO dbo.Client(ID,Fname,Lname,DateOfBirth,Email,PhoneNumber,HomeNumber,Address) VALUES (988447,'Pippo','Melin','1971-05-05','pmelin1u@mail.ru',99542778,24357309,'88 Graceland Crossing');
INSERT INTO dbo.Client(ID,Fname,Lname,DateOfBirth,Email,PhoneNumber,HomeNumber,Address) VALUES (768853,'Ruggiero','Mulqueen','1976-07-26','rmulqueen1v@qq.com',99788974,22393523,'1 Anhalt Way');
INSERT INTO dbo.Client(ID,Fname,Lname,DateOfBirth,Email,PhoneNumber,HomeNumber,Address) VALUES (603494,'Tedie','Broderick','1961-12-23','tbroderick1w@usatoday.com',99489350,22262625,'79325 Myrtle Point');
INSERT INTO dbo.Client(ID,Fname,Lname,DateOfBirth,Email,PhoneNumber,HomeNumber,Address) VALUES (479717,'Malanie','Merigon','1976-07-21','mmerigon1x@disqus.com',99971458,25570728,'08453 Burrows Circle');
INSERT INTO dbo.Client(ID,Fname,Lname,DateOfBirth,Email,PhoneNumber,HomeNumber,Address) VALUES (144241,'Olympie','Andrieu','1985-08-01','oandrieu1y@naver.com',99351534,23595843,'68266 Ilene Plaza');
INSERT INTO dbo.Client(ID,Fname,Lname,DateOfBirth,Email,PhoneNumber,HomeNumber,Address) VALUES (881770,'Tildie','Catlow','1972-11-04','tcatlow1z@intel.com',99938371,22080033,'649 Novick Alley');
INSERT INTO dbo.Client(ID,Fname,Lname,DateOfBirth,Email,PhoneNumber,HomeNumber,Address) VALUES (108641,'Goldy','Scrowby','1992-04-23','gscrowby20@networksolutions.com',99089883,22750573,'0 Holmberg Street');
INSERT INTO dbo.Client(ID,Fname,Lname,DateOfBirth,Email,PhoneNumber,HomeNumber,Address) VALUES (351282,'Gina','Slyne','1998-05-08','gslyne21@cisco.com',99007867,23115079,'9609 Eliot Trail');
INSERT INTO dbo.Client(ID,Fname,Lname,DateOfBirth,Email,PhoneNumber,HomeNumber,Address) VALUES (230561,'Ambrosius','Oliphand','1973-08-24','aoliphand22@fda.gov',99302112,24848063,'4174 Truax Junction');
INSERT INTO dbo.Client(ID,Fname,Lname,DateOfBirth,Email,PhoneNumber,HomeNumber,Address) VALUES (901269,'Dido','Bidgood','1971-01-04','dbidgood23@blogtalkradio.com',99289523,24257934,'151 Golf Trail');
INSERT INTO dbo.Client(ID,Fname,Lname,DateOfBirth,Email,PhoneNumber,HomeNumber,Address) VALUES (970764,'Clarabelle','Grinter','1992-09-10','cgrinter24@ucoz.com',99033300,23773576,'99720 Dryden Place');
INSERT INTO dbo.Client(ID,Fname,Lname,DateOfBirth,Email,PhoneNumber,HomeNumber,Address) VALUES (731180,'Karolina','Fowley','1965-08-13','kfowley25@army.mil',99445616,24095508,'45059 Huxley Road');
INSERT INTO dbo.Client(ID,Fname,Lname,DateOfBirth,Email,PhoneNumber,HomeNumber,Address) VALUES (117028,'Arline','Dilon','1965-12-18','adilon26@reddit.com',99540833,23638432,'2595 Jana Circle');
INSERT INTO dbo.Client(ID,Fname,Lname,DateOfBirth,Email,PhoneNumber,HomeNumber,Address) VALUES (770532,'Burnaby','Ellens','1977-01-15','bellens27@patch.com',99421279,25365214,'94 Sunbrook Plaza');
INSERT INTO dbo.Client(ID,Fname,Lname,DateOfBirth,Email,PhoneNumber,HomeNumber,Address) VALUES (352517,'Far','Tilliards','1964-12-10','ftilliards28@w3.org',99020116,23163620,'3 Mayer Alley');
INSERT INTO dbo.Client(ID,Fname,Lname,DateOfBirth,Email,PhoneNumber,HomeNumber,Address) VALUES (739819,'Edie','Fierro','1978-01-17','efierro29@miitbeian.gov.cn',99722228,24589091,'1 Fieldstone Pass');
INSERT INTO dbo.Client(ID,Fname,Lname,DateOfBirth,Email,PhoneNumber,HomeNumber,Address) VALUES (519138,'Archer','Kerne','1984-01-22','akerne2a@google.com',99283636,24210387,'8858 Dakota Terrace');
INSERT INTO dbo.Client(ID,Fname,Lname,DateOfBirth,Email,PhoneNumber,HomeNumber,Address) VALUES (998429,'Aloin','Dominichetti','1966-08-19','adominichetti2b@goodreads.com',99808645,25260668,'097 Granby Road');
INSERT INTO dbo.Client(ID,Fname,Lname,DateOfBirth,Email,PhoneNumber,HomeNumber,Address) VALUES (827632,'Berty','Lanktree','1964-02-16','blanktree2c@myspace.com',99802111,23901149,'829 Bluestem Drive');
INSERT INTO dbo.Client(ID,Fname,Lname,DateOfBirth,Email,PhoneNumber,HomeNumber,Address) VALUES (415119,'Rossy','Diss','1966-09-15','rdiss2d@arstechnica.com',99128296,24796930,'98013 Clyde Gallagher Plaza');
INSERT INTO dbo.Client(ID,Fname,Lname,DateOfBirth,Email,PhoneNumber,HomeNumber,Address) VALUES (171283,'Tadeas','Espinheira','1972-04-26','tespinheira2e@netlog.com',99315043,23497288,'11024 Loomis Lane');
INSERT INTO dbo.Client(ID,Fname,Lname,DateOfBirth,Email,PhoneNumber,HomeNumber,Address) VALUES (289403,'Adey','Dansey','1985-04-17','adansey2f@wikipedia.org',99281299,23233511,'472 Ohio Avenue');
INSERT INTO dbo.Client(ID,Fname,Lname,DateOfBirth,Email,PhoneNumber,HomeNumber,Address) VALUES (304400,'Meara','Faier','1979-11-02','mfaier2g@mozilla.com',99644378,24391707,'76592 Warner Center');
INSERT INTO dbo.Client(ID,Fname,Lname,DateOfBirth,Email,PhoneNumber,HomeNumber,Address) VALUES (862575,'Leonardo','Thurlby','1984-08-09','lthurlby2h@ed.gov',99850991,24666043,'9855 Armistice Way');
INSERT INTO dbo.Client(ID,Fname,Lname,DateOfBirth,Email,PhoneNumber,HomeNumber,Address) VALUES (133893,'Emory','Galea','1981-01-19','egalea2i@umn.edu',99699686,25268802,'6453 Bunker Hill Pass');
INSERT INTO dbo.Client(ID,Fname,Lname,DateOfBirth,Email,PhoneNumber,HomeNumber,Address) VALUES (798930,'Enid','Hafford','1985-02-13','ehafford2j@drupal.org',99795240,23713082,'939 Doe Crossing Alley');
INSERT INTO dbo.Client(ID,Fname,Lname,DateOfBirth,Email,PhoneNumber,HomeNumber,Address) VALUES (778351,'Kirstin','Slevin','1971-07-03','kslevin2k@nationalgeographic.com',99694382,23242187,'7 Raven Road');
INSERT INTO dbo.Client(ID,Fname,Lname,DateOfBirth,Email,PhoneNumber,HomeNumber,Address) VALUES (746901,'Ginevra','Narey','1966-06-06','gnarey2l@canalblog.com',99520506,24040477,'9137 Susan Point');
INSERT INTO dbo.Client(ID,Fname,Lname,DateOfBirth,Email,PhoneNumber,HomeNumber,Address) VALUES (824205,'Carole','Brabon','1982-01-11','cbrabon2m@ted.com',99212723,22515127,'75449 Holmberg Way');
INSERT INTO dbo.Client(ID,Fname,Lname,DateOfBirth,Email,PhoneNumber,HomeNumber,Address) VALUES (689444,'Sibbie','Sturt','1973-03-28','ssturt2n@wikispaces.com',99726212,24106969,'541 Trailsway Crossing');
INSERT INTO dbo.Client(ID,Fname,Lname,DateOfBirth,Email,PhoneNumber,HomeNumber,Address) VALUES (118499,'Marj','Lisciardelli','1990-07-25','mlisciardelli2o@gnu.org',99994613,23814944,'10043 Twin Pines Terrace');
INSERT INTO dbo.Client(ID,Fname,Lname,DateOfBirth,Email,PhoneNumber,HomeNumber,Address) VALUES (921395,'Sephira','Boydon','1963-05-06','sboydon2p@businesswire.com',99210359,22107783,'64902 Blaine Place');
INSERT INTO dbo.Client(ID,Fname,Lname,DateOfBirth,Email,PhoneNumber,HomeNumber,Address) VALUES (633765,'Kelley','Adams','1985-12-25','kadams2q@cafepress.com',99419861,25913877,'1 Dixon Plaza');
INSERT INTO dbo.Client(ID,Fname,Lname,DateOfBirth,Email,PhoneNumber,HomeNumber,Address) VALUES (476367,'Padriac','Plowright','1963-12-10','pplowright2r@liveinternet.ru',99624240,24281618,'01 Onsgard Trail');
INSERT INTO dbo.Client(ID,Fname,Lname,DateOfBirth,Email,PhoneNumber,HomeNumber,Address) VALUES (912278,'Ailis','Pendered','1997-12-08','apendered2s@amazon.co.uk',99610835,22852903,'57 Pierstorff Parkway');
INSERT INTO dbo.Client(ID,Fname,Lname,DateOfBirth,Email,PhoneNumber,HomeNumber,Address) VALUES (751584,'Devi','Aistrop','1974-12-21','daistrop2t@unc.edu',99324447,22276115,'01 John Wall Terrace');
INSERT INTO dbo.Client(ID,Fname,Lname,DateOfBirth,Email,PhoneNumber,HomeNumber,Address) VALUES (153015,'Kerby','Baine','1964-12-28','kbaine2u@domainmarket.com',99824247,24076099,'610 Texas Avenue');
INSERT INTO dbo.Client(ID,Fname,Lname,DateOfBirth,Email,PhoneNumber,HomeNumber,Address) VALUES (606239,'Kassey','Josskoviz','1997-05-26','kjosskoviz2v@omniture.com',99702538,22303344,'4437 Autumn Leaf Crossing');
INSERT INTO dbo.Client(ID,Fname,Lname,DateOfBirth,Email,PhoneNumber,HomeNumber,Address) VALUES (274882,'Lilli','Rathke','1971-07-17','lrathke2w@woothemes.com',99473137,24421031,'49 Granby Drive');
INSERT INTO dbo.Client(ID,Fname,Lname,DateOfBirth,Email,PhoneNumber,HomeNumber,Address) VALUES (179644,'Danell','Kobiera','1976-08-08','dkobiera2x@multiply.com',99771548,25451333,'23126 Paget Court');
INSERT INTO dbo.Client(ID,Fname,Lname,DateOfBirth,Email,PhoneNumber,HomeNumber,Address) VALUES (842573,'Elwyn','Abrahamsohn','1980-06-14','eabrahamsohn2y@cbslocal.com',99045839,22687628,'3473 Lighthouse Bay Junction');
INSERT INTO dbo.Client(ID,Fname,Lname,DateOfBirth,Email,PhoneNumber,HomeNumber,Address) VALUES (762803,'Fons','Peare','1981-08-01','fpeare2z@gnu.org',99408374,25996706,'5 Badeau Junction');
INSERT INTO dbo.Client(ID,Fname,Lname,DateOfBirth,Email,PhoneNumber,HomeNumber,Address) VALUES (572024,'Valry','Genner','1972-06-24','vgenner30@tripod.com',99024123,24999741,'157 Clyde Gallagher Alley');
INSERT INTO dbo.Client(ID,Fname,Lname,DateOfBirth,Email,PhoneNumber,HomeNumber,Address) VALUES (143277,'Aurie','Fennessy','1978-06-06','afennessy31@prweb.com',99874537,23753649,'7485 Forest Dale Alley');
INSERT INTO dbo.Client(ID,Fname,Lname,DateOfBirth,Email,PhoneNumber,HomeNumber,Address) VALUES (275351,'Merola','Taylorson','1994-08-31','mtaylorson32@mapquest.com',99254309,22698236,'1163 Columbus Alley');
INSERT INTO dbo.Client(ID,Fname,Lname,DateOfBirth,Email,PhoneNumber,HomeNumber,Address) VALUES (357095,'Pammie','Heineken','1969-07-04','pheineken33@reuters.com',99549673,24418336,'318 Harper Park');
INSERT INTO dbo.Client(ID,Fname,Lname,DateOfBirth,Email,PhoneNumber,HomeNumber,Address) VALUES (338671,'Ferd','Kemwal','1964-10-01','fkemwal34@hugedomains.com',99778669,25173438,'0 Sundown Street');
INSERT INTO dbo.Client(ID,Fname,Lname,DateOfBirth,Email,PhoneNumber,HomeNumber,Address) VALUES (467435,'Peyter','Breadmore','1977-07-20','pbreadmore35@army.mil',99736972,25365400,'02 Schlimgen Point');
INSERT INTO dbo.Client(ID,Fname,Lname,DateOfBirth,Email,PhoneNumber,HomeNumber,Address) VALUES (611760,'Bink','Bracken','1996-07-08','bbracken36@ovh.net',99011503,22218547,'07472 Parkside Avenue');
INSERT INTO dbo.Client(ID,Fname,Lname,DateOfBirth,Email,PhoneNumber,HomeNumber,Address) VALUES (983495,'Drake','Yewdall','1989-12-06','dyewdall37@usatoday.com',99643923,23226677,'211 Truax Avenue');
INSERT INTO dbo.Client(ID,Fname,Lname,DateOfBirth,Email,PhoneNumber,HomeNumber,Address) VALUES (431483,'Jacklin','Hawford','1992-05-29','jhawford38@discuz.net',99042195,24349876,'90 Fairview Point');
INSERT INTO dbo.Client(ID,Fname,Lname,DateOfBirth,Email,PhoneNumber,HomeNumber,Address) VALUES (962302,'Cliff','Belle','1995-07-16','cbelle39@nhs.uk',99644144,24306647,'9393 Bellgrove Point');
INSERT INTO dbo.Client(ID,Fname,Lname,DateOfBirth,Email,PhoneNumber,HomeNumber,Address) VALUES (194552,'Carri','Baraja','1967-11-02','cbaraja3a@epa.gov',99518191,24140344,'72308 Butternut Circle');
INSERT INTO dbo.Client(ID,Fname,Lname,DateOfBirth,Email,PhoneNumber,HomeNumber,Address) VALUES (349474,'Leshia','Delbergue','1988-08-05','ldelbergue3b@comsenz.com',99673122,25699414,'73039 Rowland Parkway');
INSERT INTO dbo.Client(ID,Fname,Lname,DateOfBirth,Email,PhoneNumber,HomeNumber,Address) VALUES (430879,'Gill','Banbrook','1995-02-14','gbanbrook3c@vistaprint.com',99989327,22144028,'4 Northland Plaza');
INSERT INTO dbo.Client(ID,Fname,Lname,DateOfBirth,Email,PhoneNumber,HomeNumber,Address) VALUES (870564,'Randal','Derges','1969-10-30','rderges3d@xinhuanet.com',99324336,22073597,'8050 Memorial Plaza');
INSERT INTO dbo.Client(ID,Fname,Lname,DateOfBirth,Email,PhoneNumber,HomeNumber,Address) VALUES (141353,'Jessamine','Ivanin','1975-01-01','jivanin3e@wp.com',99713420,24700545,'20 Troy Way');
INSERT INTO dbo.Client(ID,Fname,Lname,DateOfBirth,Email,PhoneNumber,HomeNumber,Address) VALUES (270422,'Kerrill','Siegertsz','1973-10-09','ksiegertsz3f@nymag.com',99129602,22328689,'66515 Washington Trail');
INSERT INTO dbo.Client(ID,Fname,Lname,DateOfBirth,Email,PhoneNumber,HomeNumber,Address) VALUES (232428,'Jacki','Moland','1971-09-09','jmoland3g@gmpg.org',99101132,24964716,'895 Sachs Terrace');
INSERT INTO dbo.Client(ID,Fname,Lname,DateOfBirth,Email,PhoneNumber,HomeNumber,Address) VALUES (317156,'Sadella','Farebrother','1970-07-04','sfarebrother3h@dyndns.org',99456083,22588909,'64 Derek Lane');
INSERT INTO dbo.Client(ID,Fname,Lname,DateOfBirth,Email,PhoneNumber,HomeNumber,Address) VALUES (226721,'Camala','Mangion','1969-02-11','cmangion3i@godaddy.com',99875593,24006979,'52743 7th Road');
INSERT INTO dbo.Client(ID,Fname,Lname,DateOfBirth,Email,PhoneNumber,HomeNumber,Address) VALUES (452007,'Tiffanie','Bwy','1982-02-04','tbwy3j@icio.us',99998324,22541785,'2717 Sutherland Circle');
INSERT INTO dbo.Client(ID,Fname,Lname,DateOfBirth,Email,PhoneNumber,HomeNumber,Address) VALUES (368924,'Minor','Hardan','1970-05-17','mhardan3k@4shared.com',99599893,23761249,'166 Dwight Alley');
INSERT INTO dbo.Client(ID,Fname,Lname,DateOfBirth,Email,PhoneNumber,HomeNumber,Address) VALUES (112982,'Bernardine','Bortolomei','1962-10-23','bbortolomei3l@stanford.edu',99483765,25161174,'2 Wayridge Circle');
INSERT INTO dbo.Client(ID,Fname,Lname,DateOfBirth,Email,PhoneNumber,HomeNumber,Address) VALUES (656225,'Feliza','Purdy','1973-09-13','fpurdy3m@soup.io',99591949,23794980,'250 Anzinger Trail');
INSERT INTO dbo.Client(ID,Fname,Lname,DateOfBirth,Email,PhoneNumber,HomeNumber,Address) VALUES (101302,'Constantia','Edward','1973-05-08','cedward3n@bigcartel.com',99542149,22312184,'932 Northport Plaza');
INSERT INTO dbo.Client(ID,Fname,Lname,DateOfBirth,Email,PhoneNumber,HomeNumber,Address) VALUES (181571,'Nickola','Antonazzi','1981-04-13','nantonazzi3o@tumblr.com',99339642,25094247,'851 Darwin Center');
INSERT INTO dbo.Client(ID,Fname,Lname,DateOfBirth,Email,PhoneNumber,HomeNumber,Address) VALUES (764533,'Willem','Lindfors','1982-11-17','wlindfors3p@vk.com',99368377,23167354,'8574 Elgar Trail');
INSERT INTO dbo.Client(ID,Fname,Lname,DateOfBirth,Email,PhoneNumber,HomeNumber,Address) VALUES (777789,'Filia','McNeillie','1973-04-27','fmcneillie3q@about.me',99935525,23417532,'59 Kedzie Lane');
INSERT INTO dbo.Client(ID,Fname,Lname,DateOfBirth,Email,PhoneNumber,HomeNumber,Address) VALUES (231401,'Gertrud','Bohje','1985-05-07','gbohje3r@oaic.gov.au',99530643,22186852,'2070 Clemons Hill');
INSERT INTO dbo.Client(ID,Fname,Lname,DateOfBirth,Email,PhoneNumber,HomeNumber,Address) VALUES (199689,'Katlin','Hallybone','1977-05-29','khallybone3s@scientificamerican.com',99098694,25138589,'75888 Lotheville Avenue');
INSERT INTO dbo.Client(ID,Fname,Lname,DateOfBirth,Email,PhoneNumber,HomeNumber,Address) VALUES (640896,'Corinna','Kirvell','1990-08-26','ckirvell3t@europa.eu',99222975,23788592,'7 Kinsman Hill');
INSERT INTO dbo.Client(ID,Fname,Lname,DateOfBirth,Email,PhoneNumber,HomeNumber,Address) VALUES (394971,'Christy','McDonagh','1960-11-28','cmcdonagh3u@theatlantic.com',99312110,22589908,'82483 Heath Way');
INSERT INTO dbo.Client(ID,Fname,Lname,DateOfBirth,Email,PhoneNumber,HomeNumber,Address) VALUES (802791,'Emera','Hobben','1996-10-16','ehobben3v@cbslocal.com',99366968,23210114,'0 International Avenue');
INSERT INTO dbo.Client(ID,Fname,Lname,DateOfBirth,Email,PhoneNumber,HomeNumber,Address) VALUES (432084,'Clevie','Senn','1990-07-29','csenn3w@home.pl',99188719,22295831,'53 Meadow Vale Way');
INSERT INTO dbo.Client(ID,Fname,Lname,DateOfBirth,Email,PhoneNumber,HomeNumber,Address) VALUES (536798,'Nichols','Tingcomb','1993-03-23','ntingcomb3x@google.com.br',99841198,23796668,'00 Jay Parkway');
INSERT INTO dbo.Client(ID,Fname,Lname,DateOfBirth,Email,PhoneNumber,HomeNumber,Address) VALUES (818519,'Berkie','Appleford','1982-04-24','bappleford3y@state.gov',99409144,23760751,'98 David Alley');
INSERT INTO dbo.Client(ID,Fname,Lname,DateOfBirth,Email,PhoneNumber,HomeNumber,Address) VALUES (869516,'Marleah','Senecaux','1968-01-01','msenecaux3z@hatena.ne.jp',99923376,24990381,'93465 Mariners Cove Lane');
INSERT INTO dbo.Client(ID,Fname,Lname,DateOfBirth,Email,PhoneNumber,HomeNumber,Address) VALUES (413912,'Lotte','Viccars','1970-07-13','lviccars40@alibaba.com',99237118,25939717,'4 International Avenue');
INSERT INTO dbo.Client(ID,Fname,Lname,DateOfBirth,Email,PhoneNumber,HomeNumber,Address) VALUES (335333,'Mirabella','Jorgensen','1989-10-02','mjorgensen41@mtv.com',99930944,24428796,'61 Birchwood Way');
INSERT INTO dbo.Client(ID,Fname,Lname,DateOfBirth,Email,PhoneNumber,HomeNumber,Address) VALUES (724727,'Dotti','Wabb','1976-07-22','dwabb42@cbslocal.com',99841548,23094708,'960 Tony Court');
INSERT INTO dbo.Client(ID,Fname,Lname,DateOfBirth,Email,PhoneNumber,HomeNumber,Address) VALUES (458711,'Ariadne','Curston','1966-11-16','acurston43@mapquest.com',99206147,25393977,'32 Michigan Way');
INSERT INTO dbo.Client(ID,Fname,Lname,DateOfBirth,Email,PhoneNumber,HomeNumber,Address) VALUES (998942,'Anestassia','Boulder','1964-04-26','aboulder44@google.co.jp',99121608,24451869,'8 Dorton Pass');
INSERT INTO dbo.Client(ID,Fname,Lname,DateOfBirth,Email,PhoneNumber,HomeNumber,Address) VALUES (576708,'Orson','Danilenko','1982-08-11','odanilenko45@ucsd.edu',99387471,25091229,'7557 Continental Road');
INSERT INTO dbo.Client(ID,Fname,Lname,DateOfBirth,Email,PhoneNumber,HomeNumber,Address) VALUES (506142,'Elga','Rickett','1985-04-21','erickett46@usda.gov',99024277,23467603,'659 Mendota Lane');
INSERT INTO dbo.Client(ID,Fname,Lname,DateOfBirth,Email,PhoneNumber,HomeNumber,Address) VALUES (527301,'Winna','Fitzroy','1976-09-03','wfitzroy47@wp.com',99706397,25462149,'2 Sunfield Junction');
INSERT INTO dbo.Client(ID,Fname,Lname,DateOfBirth,Email,PhoneNumber,HomeNumber,Address) VALUES (122707,'Marcelle','Bolan','1978-02-11','mbolan48@google.com.hk',99584108,24655254,'60 Dwight Park');
INSERT INTO dbo.Client(ID,Fname,Lname,DateOfBirth,Email,PhoneNumber,HomeNumber,Address) VALUES (396926,'Dode','Toombes','1974-09-29','dtoombes49@narod.ru',99699646,23416432,'7 Hovde Place');
INSERT INTO dbo.Client(ID,Fname,Lname,DateOfBirth,Email,PhoneNumber,HomeNumber,Address) VALUES (624371,'Emmy','Warratt','1981-04-01','ewarratt4a@sina.com.cn',99868703,25826651,'12397 Novick Pass');
INSERT INTO dbo.Client(ID,Fname,Lname,DateOfBirth,Email,PhoneNumber,HomeNumber,Address) VALUES (281127,'Madelle','Fitchew','1986-01-02','mfitchew4b@ucoz.com',99300217,23656698,'6489 Stuart Alley');
INSERT INTO dbo.Client(ID,Fname,Lname,DateOfBirth,Email,PhoneNumber,HomeNumber,Address) VALUES (851500,'Bettye','Craighead','1969-11-26','bcraighead4c@hhs.gov',99808046,22627492,'1582 Straubel Center');
INSERT INTO dbo.Client(ID,Fname,Lname,DateOfBirth,Email,PhoneNumber,HomeNumber,Address) VALUES (933954,'Adrea','Trench','1972-02-07','atrench4d@smugmug.com',99489680,22534356,'292 Memorial Place');
INSERT INTO dbo.Client(ID,Fname,Lname,DateOfBirth,Email,PhoneNumber,HomeNumber,Address) VALUES (161828,'Levey','Westhofer','1960-11-23','lwesthofer4e@jigsy.com',99200663,22251617,'839 Moose Drive');
INSERT INTO dbo.Client(ID,Fname,Lname,DateOfBirth,Email,PhoneNumber,HomeNumber,Address) VALUES (779887,'Hortense','Oliffe','1993-11-29','holiffe4f@omniture.com',99649086,22622927,'59957 Clove Terrace');
INSERT INTO dbo.Client(ID,Fname,Lname,DateOfBirth,Email,PhoneNumber,HomeNumber,Address) VALUES (953426,'Gwendolyn','Sabine','1975-03-25','gsabine4g@wisc.edu',99036028,22527188,'45 Amoth Park');
INSERT INTO dbo.Client(ID,Fname,Lname,DateOfBirth,Email,PhoneNumber,HomeNumber,Address) VALUES (171710,'Maxi','Cottom','1992-11-14','mcottom4h@mayoclinic.com',99050660,24328665,'810 Beilfuss Plaza');
INSERT INTO dbo.Client(ID,Fname,Lname,DateOfBirth,Email,PhoneNumber,HomeNumber,Address) VALUES (612245,'Guss','Pitcock','1973-04-26','gpitcock4i@typepad.com',99377668,25284106,'28322 Oxford Terrace');
INSERT INTO dbo.Client(ID,Fname,Lname,DateOfBirth,Email,PhoneNumber,HomeNumber,Address) VALUES (372836,'Eva','Busson','1967-12-10','ebusson4j@imgur.com',99636402,22623196,'12343 Orin Alley');
INSERT INTO dbo.Client(ID,Fname,Lname,DateOfBirth,Email,PhoneNumber,HomeNumber,Address) VALUES (132401,'Eugenia','Greensite','1985-12-30','egreensite4k@lulu.com',99207455,24492978,'581 David Park');
INSERT INTO dbo.Client(ID,Fname,Lname,DateOfBirth,Email,PhoneNumber,HomeNumber,Address) VALUES (326325,'Zedekiah','Caukill','1989-12-17','zcaukill4l@jimdo.com',99830391,25905746,'469 Del Mar Park');
INSERT INTO dbo.Client(ID,Fname,Lname,DateOfBirth,Email,PhoneNumber,HomeNumber,Address) VALUES (364390,'Dan','Ker','1982-10-27','dker4m@list-manage.com',99812255,24185733,'06430 Towne Street');
INSERT INTO dbo.Client(ID,Fname,Lname,DateOfBirth,Email,PhoneNumber,HomeNumber,Address) VALUES (582495,'Zacharie','Haggata','1976-04-07','zhaggata4n@jugem.jp',99283927,23938048,'80 Lindbergh Pass');
INSERT INTO dbo.Client(ID,Fname,Lname,DateOfBirth,Email,PhoneNumber,HomeNumber,Address) VALUES (820054,'Boonie','Sangwine','1987-03-06','bsangwine4o@dell.com',99817628,22319536,'41804 Talmadge Avenue');
INSERT INTO dbo.Client(ID,Fname,Lname,DateOfBirth,Email,PhoneNumber,HomeNumber,Address) VALUES (197520,'Ernesta','Logie','1962-02-05','elogie4p@kickstarter.com',99032642,22065584,'0754 Golf Junction');
INSERT INTO dbo.Client(ID,Fname,Lname,DateOfBirth,Email,PhoneNumber,HomeNumber,Address) VALUES (653972,'Bridgette','Tockell','1973-07-14','btockell4q@disqus.com',99839593,23814922,'653 Utah Lane');
INSERT INTO dbo.Client(ID,Fname,Lname,DateOfBirth,Email,PhoneNumber,HomeNumber,Address) VALUES (546741,'Kayle','Ribchester','1987-06-14','kribchester4r@ow.ly',99201923,23891727,'87 West Center');
INSERT INTO dbo.Client(ID,Fname,Lname,DateOfBirth,Email,PhoneNumber,HomeNumber,Address) VALUES (257512,'Casar','Bisiker','1977-04-25','cbisiker4s@opensource.org',99374956,25479038,'41657 Claremont Terrace');
INSERT INTO dbo.Client(ID,Fname,Lname,DateOfBirth,Email,PhoneNumber,HomeNumber,Address) VALUES (633221,'Renault','Bulch','1968-06-22','rbulch4t@sfgate.com',99112652,25817821,'3734 Alpine Trail');
INSERT INTO dbo.Client(ID,Fname,Lname,DateOfBirth,Email,PhoneNumber,HomeNumber,Address) VALUES (136473,'Sharyl','Pettigrew','1964-12-24','spettigrew4u@noaa.gov',99919018,25810908,'67 Burrows Road');
INSERT INTO dbo.Client(ID,Fname,Lname,DateOfBirth,Email,PhoneNumber,HomeNumber,Address) VALUES (623670,'Antonino','O''Corrin','1967-03-04','aocorrin4v@vkontakte.ru',99575137,24074172,'32571 Alpine Street');
INSERT INTO dbo.Client(ID,Fname,Lname,DateOfBirth,Email,PhoneNumber,HomeNumber,Address) VALUES (826914,'Candice','Purdey','1970-07-22','cpurdey4w@chicagotribune.com',99860116,23513108,'44275 Cardinal Parkway');
INSERT INTO dbo.Client(ID,Fname,Lname,DateOfBirth,Email,PhoneNumber,HomeNumber,Address) VALUES (638822,'Kakalina','Cortnay','1970-12-11','kcortnay4x@bing.com',99979268,23669303,'28 Autumn Leaf Alley');
INSERT INTO dbo.Client(ID,Fname,Lname,DateOfBirth,Email,PhoneNumber,HomeNumber,Address) VALUES (130541,'Mic','Coolahan','1968-01-30','mcoolahan4y@bbc.co.uk',99785042,24217229,'05322 Tennyson Terrace');
INSERT INTO dbo.Client(ID,Fname,Lname,DateOfBirth,Email,PhoneNumber,HomeNumber,Address) VALUES (597566,'Rheta','Wayland','1977-01-29','rwayland4z@etsy.com',99920244,23783023,'73105 Mallory Avenue');
INSERT INTO dbo.Client(ID,Fname,Lname,DateOfBirth,Email,PhoneNumber,HomeNumber,Address) VALUES (480697,'Cleavland','Jessup','1973-12-23','cjessup50@jimdo.com',99474204,22988728,'12083 Northridge Place');
INSERT INTO dbo.Client(ID,Fname,Lname,DateOfBirth,Email,PhoneNumber,HomeNumber,Address) VALUES (886693,'Aubrey','Issakov','1992-11-15','aissakov51@a8.net',99915503,22699640,'67 Rusk Court');
INSERT INTO dbo.Client(ID,Fname,Lname,DateOfBirth,Email,PhoneNumber,HomeNumber,Address) VALUES (762358,'Rania','Cawkill','1978-09-08','rcawkill52@zdnet.com',99473082,25767139,'76853 Clyde Gallagher Street');
INSERT INTO dbo.Client(ID,Fname,Lname,DateOfBirth,Email,PhoneNumber,HomeNumber,Address) VALUES (299036,'Lambert','Diddams','1961-04-20','ldiddams53@ovh.net',99441567,22020095,'419 Ronald Regan Pass');
INSERT INTO dbo.Client(ID,Fname,Lname,DateOfBirth,Email,PhoneNumber,HomeNumber,Address) VALUES (460523,'Henka','Kipling','1998-11-01','hkipling54@chicagotribune.com',99129359,22883580,'0228 Green Ridge Way');
INSERT INTO dbo.Client(ID,Fname,Lname,DateOfBirth,Email,PhoneNumber,HomeNumber,Address) VALUES (249901,'Emmy','Wilcinskis','1961-11-12','ewilcinskis55@wisc.edu',99984967,24804894,'039 Trailsway Court');
INSERT INTO dbo.Client(ID,Fname,Lname,DateOfBirth,Email,PhoneNumber,HomeNumber,Address) VALUES (747654,'Shannan','Gumby','1990-07-24','sgumby56@wired.com',99306901,25378855,'4730 Summerview Crossing');
INSERT INTO dbo.Client(ID,Fname,Lname,DateOfBirth,Email,PhoneNumber,HomeNumber,Address) VALUES (949966,'Jaye','Seneschal','1980-09-13','jseneschal57@printfriendly.com',99853096,22950127,'7 Marquette Road');
INSERT INTO dbo.Client(ID,Fname,Lname,DateOfBirth,Email,PhoneNumber,HomeNumber,Address) VALUES (423278,'Gayleen','Hamman','1969-10-07','ghamman58@w3.org',99180058,22434731,'00 Cascade Place');
INSERT INTO dbo.Client(ID,Fname,Lname,DateOfBirth,Email,PhoneNumber,HomeNumber,Address) VALUES (992999,'Shane','MacRinn','1981-04-15','smacrinn59@amazon.de',99509758,23828233,'495 Buena Vista Court');
INSERT INTO dbo.Client(ID,Fname,Lname,DateOfBirth,Email,PhoneNumber,HomeNumber,Address) VALUES (885539,'Vernen','Breakwell','1993-05-02','vbreakwell5a@harvard.edu',99538944,24628047,'986 Knutson Plaza');
INSERT INTO dbo.Client(ID,Fname,Lname,DateOfBirth,Email,PhoneNumber,HomeNumber,Address) VALUES (247799,'Lawton','Nevins','1998-06-09','lnevins5b@wiley.com',99324127,22243139,'6 Bonner Pass');
INSERT INTO dbo.Client(ID,Fname,Lname,DateOfBirth,Email,PhoneNumber,HomeNumber,Address) VALUES (914858,'Christiano','Langforth','1989-11-17','clangforth5c@ox.ac.uk',99309510,24199324,'875 Ilene Road');
INSERT INTO dbo.Client(ID,Fname,Lname,DateOfBirth,Email,PhoneNumber,HomeNumber,Address) VALUES (444162,'Jarret','Gordge','1966-08-21','jgordge5d@utexas.edu',99163592,24391524,'9396 Sugar Road');
INSERT INTO dbo.Client(ID,Fname,Lname,DateOfBirth,Email,PhoneNumber,HomeNumber,Address) VALUES (860545,'Nicholle','Ruddy','1977-05-05','nruddy5e@imgur.com',99990202,22907387,'3605 Mallard Park');
INSERT INTO dbo.Client(ID,Fname,Lname,DateOfBirth,Email,PhoneNumber,HomeNumber,Address) VALUES (877784,'Hymie','Franca','1972-05-09','hfranca5f@ustream.tv',99442374,22869508,'5 International Trail');
INSERT INTO dbo.Client(ID,Fname,Lname,DateOfBirth,Email,PhoneNumber,HomeNumber,Address) VALUES (117299,'Dyan','Neames','1993-04-10','dneames5g@amazon.com',99891044,22004925,'8 Londonderry Street');
INSERT INTO dbo.Client(ID,Fname,Lname,DateOfBirth,Email,PhoneNumber,HomeNumber,Address) VALUES (161787,'Ravid','Kastel','1985-10-01','rkastel5h@furl.net',99773643,25151531,'362 Golf Alley');
INSERT INTO dbo.Client(ID,Fname,Lname,DateOfBirth,Email,PhoneNumber,HomeNumber,Address) VALUES (275519,'Bradly','Skottle','1975-03-22','bskottle5i@over-blog.com',99591682,25025130,'7671 Homewood Lane');
INSERT INTO dbo.Client(ID,Fname,Lname,DateOfBirth,Email,PhoneNumber,HomeNumber,Address) VALUES (852542,'Gerhardt','Giroldo','1970-05-23','ggiroldo5j@uiuc.edu',99762776,25793078,'63 Nelson Road');



--------------------------------------------------------------------------------------------------------------------------------------------------------------




INSERT INTO Employee(Fname,Lname,ID,DateOfBirth,Email,Position,SSN,PhoneNumber,HomeNumber,Address,Salary,IsAdmin) VALUES ('Marios','Pitsiali',190312,'08/07/1979','mpitsi04@cs.ucy.ac.cy','Employee',7806502,99620281,24476913,'36 Lukken Park',1500,1);
INSERT INTO Employee(Fname,Lname,ID,DateOfBirth,Email,Position,SSN,PhoneNumber,HomeNumber,Address,Salary,IsAdmin) VALUES ('Theodoros','Solomou',575996,'07/11/1976','tsolom01@cs.ucy.ac.cy','Manager',9642963,99241263,23618714,'9003 Dexter Street',2500,1);
INSERT INTO Employee(Fname,Lname,ID,DateOfBirth,Email,Position,SSN,PhoneNumber,HomeNumber,Address,Salary,IsAdmin) VALUES ('Kakos','Georgiou',841367,'06/06/1984','kgeorg@cs.ucy.ac.cy','CE0',9333637,99774753,22850732,'123 Fairview Hill',10000,1);
INSERT INTO Employee(Fname,Lname,ID,DateOfBirth,Email,Position,SSN,PhoneNumber,HomeNumber,Address,Salary,IsAdmin) VALUES ('Panayiotis','Vasiliou',414265,'06/10/1974','pvasil01@cs.ucy.ac.cy','Employee',3859319,99840892,24168194,'845 Old Gate Drive',1700,1);
INSERT INTO Employee(Fname,Lname,ID,DateOfBirth,Email,Position,SSN,PhoneNumber,HomeNumber,Address,Salary,IsAdmin) VALUES ('Michael Angelos','Pittakaras',178052,'12/06/1988','mpitta@cs.ucy.ac.cy','Employee',7614855,99110755,25570926,'5 American Ash Avenue',1400,1);
INSERT INTO Employee(Fname,Lname,ID,DateOfBirth,Email,Position,SSN,PhoneNumber,HomeNumber,Address,Salary,IsAdmin) VALUES ('Panayiotis','Kyriakou',290725,'01/03/1974','pkyria14@cs.ucy.ac.cy','Manager',3431784,99815937,25858954,'6101 Shasta Plaza',2950,1);
INSERT INTO Employee(Fname,Lname,ID,DateOfBirth,Email,Position,SSN,PhoneNumber,HomeNumber,Address,Salary,IsAdmin) VALUES ('Georgia','Kapitsaki',218590,'10/09/1988','gkapi@cs.ucy.ac.cy','Software Inspestor',2715285,99135214,22357492,'University of Cyprus',5000,1);
INSERT INTO Employee(Fname,Lname,ID,DateOfBirth,Email,Position,SSN,PhoneNumber,HomeNumber,Address,Salary,IsAdmin) VALUES ('Sonny','Sawle',855138,'08/01/1969','ssawle7@who.int','Employee',3828475,99271315,25427794,'17426 Norway Maple Trail',1200,0);
INSERT INTO Employee(Fname,Lname,ID,DateOfBirth,Email,Position,SSN,PhoneNumber,HomeNumber,Address,Salary,IsAdmin) VALUES ('Jaquenetta','Mewha',139993,'09/06/1957','jmewha8@php.net','Employee',5457484,99438816,24225538,'87969 Debs Court',1404,0);
INSERT INTO Employee(Fname,Lname,ID,DateOfBirth,Email,Position,SSN,PhoneNumber,HomeNumber,Address,Salary,IsAdmin) VALUES ('Matilde','Drohane',388531,'06/12/1993','mdrohane9@upenn.edu','Manager',2343581,99774751,23108568,'8002 Blaine Alley',2985,0);


--------------------------------------------------------------------------

INSERT INTO Warehouse(Location,Capacity) VALUES ('Dali',240);


----------------------------------------------------------------------------------------------------------

INSERT INTO Authentication(SSN,Username,Password) VALUES (7806502,'mpitsi04','123456789');
INSERT INTO Authentication(SSN,Username,Password) VALUES (9642963,'tsolom01','123456789');
INSERT INTO Authentication(SSN,Username,Password) VALUES (9333637,'kgeorg01','12345');
INSERT INTO Authentication(SSN,Username,Password) VALUES (3859319,'pvasil01','123456789');
INSERT INTO Authentication(SSN,Username,Password) VALUES (7614855,'mpitta01','123456789');
INSERT INTO Authentication(SSN,Username,Password) VALUES (3431784,'pkyria14','123456789');
INSERT INTO Authentication(SSN,Username,Password) VALUES (2715285,'gkapi','1234');
INSERT INTO Authentication(SSN,Username,Password) VALUES (3828475,'employee2','123456789');
INSERT INTO Authentication(SSN,Username,Password) VALUES (5457484,'employee3','123456789');
INSERT INTO Authentication(SSN,Username,Password) VALUES (2343581,'employee4','123456789');



----------------------------------------------------------------------------------------------------

INSERT INTO Pallet(Position,WarehouseID,ClientID,ImportDate,ExportDate,IsFood,ExpirDate,BasicCost,ExtraCost,TotalCost) VALUES (101,1,689444,'2016-05-19','2016-10-15',0,NULL,1274,112,1386);
INSERT INTO Pallet(Position,WarehouseID,ClientID,ImportDate,ExportDate,IsFood,ExpirDate,BasicCost,ExtraCost,TotalCost) VALUES (102,1,921395,'2016-09-07','2016-12-23',1,'2020-01-03',919,149,1068);
INSERT INTO Pallet(Position,WarehouseID,ClientID,ImportDate,ExportDate,IsFood,ExpirDate,BasicCost,ExtraCost,TotalCost) VALUES (103,1,161828,'2016-02-02','2016-02-18',0,NULL,2164,65,2229);
INSERT INTO Pallet(Position,WarehouseID,ClientID,ImportDate,ExportDate,IsFood,ExpirDate,BasicCost,ExtraCost,TotalCost) VALUES (104,1,291141,'2016-10-24','2017-04-01',0,NULL,1700,160,1860);
INSERT INTO Pallet(Position,WarehouseID,ClientID,ImportDate,ExportDate,IsFood,ExpirDate,BasicCost,ExtraCost,TotalCost) VALUES (105,1,460523,'2016-07-24','2016-08-10',0,NULL,934,118,1052);
INSERT INTO Pallet(Position,WarehouseID,ClientID,ImportDate,ExportDate,IsFood,ExpirDate,BasicCost,ExtraCost,TotalCost) VALUES (106,1,930089,'2016-11-15','2016-12-06',0,NULL,2174,60,2234);
INSERT INTO Pallet(Position,WarehouseID,ClientID,ImportDate,ExportDate,IsFood,ExpirDate,BasicCost,ExtraCost,TotalCost) VALUES (107,1,881770,'2016-07-16','2016-11-03',0,NULL,183,55,238);
INSERT INTO Pallet(Position,WarehouseID,ClientID,ImportDate,ExportDate,IsFood,ExpirDate,BasicCost,ExtraCost,TotalCost) VALUES (108,1,689444,'2016-11-22','2017-06-18',0,NULL,2152,139,2291);
INSERT INTO Pallet(Position,WarehouseID,ClientID,ImportDate,ExportDate,IsFood,ExpirDate,BasicCost,ExtraCost,TotalCost) VALUES (109,1,396926,'2016-08-24','2016-12-16',1,'2020-11-08',491,102,593);
INSERT INTO Pallet(Position,WarehouseID,ClientID,ImportDate,ExportDate,IsFood,ExpirDate,BasicCost,ExtraCost,TotalCost) VALUES (110,1,382414,'2016-04-23','2016-08-12',1,'2020-10-05',509,48,557);
INSERT INTO Pallet(Position,WarehouseID,ClientID,ImportDate,ExportDate,IsFood,ExpirDate,BasicCost,ExtraCost,TotalCost) VALUES (111,1,942887,'2016-01-10','2016-01-20',1,'2020-12-23',1041,177,1218);
INSERT INTO Pallet(Position,WarehouseID,ClientID,ImportDate,ExportDate,IsFood,ExpirDate,BasicCost,ExtraCost,TotalCost) VALUES (112,1,122707,'2016-01-27','2016-07-26',1,'2020-10-02',880,161,1041);
INSERT INTO Pallet(Position,WarehouseID,ClientID,ImportDate,ExportDate,IsFood,ExpirDate,BasicCost,ExtraCost,TotalCost) VALUES (113,1,268011,'2016-07-12','2017-04-17',0,NULL,500,149,649);
INSERT INTO Pallet(Position,WarehouseID,ClientID,ImportDate,ExportDate,IsFood,ExpirDate,BasicCost,ExtraCost,TotalCost) VALUES (114,1,492399,'2016-07-28','2017-03-13',0,NULL,1523,115,1638);
INSERT INTO Pallet(Position,WarehouseID,ClientID,ImportDate,ExportDate,IsFood,ExpirDate,BasicCost,ExtraCost,TotalCost) VALUES (115,1,852542,'2016-07-03','2016-12-26',0,NULL,1350,163,1513);
INSERT INTO Pallet(Position,WarehouseID,ClientID,ImportDate,ExportDate,IsFood,ExpirDate,BasicCost,ExtraCost,TotalCost) VALUES (116,1,633765,'2016-05-31','2016-11-15',1,'2020-06-20',1797,21,1818);
INSERT INTO Pallet(Position,WarehouseID,ClientID,ImportDate,ExportDate,IsFood,ExpirDate,BasicCost,ExtraCost,TotalCost) VALUES (117,1,800341,'2016-11-20','2017-08-30',0,NULL,2232,159,2391);
INSERT INTO Pallet(Position,WarehouseID,ClientID,ImportDate,ExportDate,IsFood,ExpirDate,BasicCost,ExtraCost,TotalCost) VALUES (118,1,249901,'2016-09-12','2017-03-20',1,'2021-03-19',2220,85,2305);
INSERT INTO Pallet(Position,WarehouseID,ClientID,ImportDate,ExportDate,IsFood,ExpirDate,BasicCost,ExtraCost,TotalCost) VALUES (119,1,850568,'2016-11-20','2017-07-02',1,'2021-01-12',2387,70,2457);
INSERT INTO Pallet(Position,WarehouseID,ClientID,ImportDate,ExportDate,IsFood,ExpirDate,BasicCost,ExtraCost,TotalCost) VALUES (120,1,611779,'2016-02-27','2016-03-04',1,'2020-10-12',200,170,370);
INSERT INTO Pallet(Position,WarehouseID,ClientID,ImportDate,ExportDate,IsFood,ExpirDate,BasicCost,ExtraCost,TotalCost) VALUES (121,1,699753,'2016-05-20','2017-02-04',0,NULL,889,22,911);
INSERT INTO Pallet(Position,WarehouseID,ClientID,ImportDate,ExportDate,IsFood,ExpirDate,BasicCost,ExtraCost,TotalCost) VALUES (122,1,818519,'2016-10-05','2016-10-28',0,NULL,310,50,360);
INSERT INTO Pallet(Position,WarehouseID,ClientID,ImportDate,ExportDate,IsFood,ExpirDate,BasicCost,ExtraCost,TotalCost) VALUES (123,1,270422,'2016-07-09','2016-10-17',1,'2020-08-27',1912,83,1995);
INSERT INTO Pallet(Position,WarehouseID,ClientID,ImportDate,ExportDate,IsFood,ExpirDate,BasicCost,ExtraCost,TotalCost) VALUES (124,1,281127,'2016-04-06','2016-06-04',1,'2021-02-21',1450,111,1561);
INSERT INTO Pallet(Position,WarehouseID,ClientID,ImportDate,ExportDate,IsFood,ExpirDate,BasicCost,ExtraCost,TotalCost) VALUES (125,1,553698,'2016-03-21','2016-03-28',0,NULL,1805,118,1923);
INSERT INTO Pallet(Position,WarehouseID,ClientID,ImportDate,ExportDate,IsFood,ExpirDate,BasicCost,ExtraCost,TotalCost) VALUES (126,1,800341,'2016-02-25','2016-08-04',1,'2019-09-11',2381,194,2575);
INSERT INTO Pallet(Position,WarehouseID,ClientID,ImportDate,ExportDate,IsFood,ExpirDate,BasicCost,ExtraCost,TotalCost) VALUES (127,1,578882,'2016-12-13','2017-09-05',0,NULL,797,49,846);
INSERT INTO Pallet(Position,WarehouseID,ClientID,ImportDate,ExportDate,IsFood,ExpirDate,BasicCost,ExtraCost,TotalCost) VALUES (128,1,249901,'2016-04-19','2016-12-14',1,'2020-09-27',174,179,353);
INSERT INTO Pallet(Position,WarehouseID,ClientID,ImportDate,ExportDate,IsFood,ExpirDate,BasicCost,ExtraCost,TotalCost) VALUES (129,1,396926,'2016-01-07','2016-08-12',0,NULL,470,171,641);
INSERT INTO Pallet(Position,WarehouseID,ClientID,ImportDate,ExportDate,IsFood,ExpirDate,BasicCost,ExtraCost,TotalCost) VALUES (130,1,593630,'2016-10-02','2017-06-30',0,NULL,2201,62,2263);
INSERT INTO Pallet(Position,WarehouseID,ClientID,ImportDate,ExportDate,IsFood,ExpirDate,BasicCost,ExtraCost,TotalCost) VALUES (131,1,664922,'2016-01-09','2016-05-20',0,NULL,2153,27,2180);
INSERT INTO Pallet(Position,WarehouseID,ClientID,ImportDate,ExportDate,IsFood,ExpirDate,BasicCost,ExtraCost,TotalCost) VALUES (132,1,364390,'2016-12-14','2017-04-21',1,'2019-10-20',762,49,811);
INSERT INTO Pallet(Position,WarehouseID,ClientID,ImportDate,ExportDate,IsFood,ExpirDate,BasicCost,ExtraCost,TotalCost) VALUES (133,1,289403,'2016-06-29','2016-08-03',1,'2021-03-04',2154,20,2174);
INSERT INTO Pallet(Position,WarehouseID,ClientID,ImportDate,ExportDate,IsFood,ExpirDate,BasicCost,ExtraCost,TotalCost) VALUES (134,1,901269,'2016-03-10','2016-10-16',1,'2019-06-15',2436,123,2559);
INSERT INTO Pallet(Position,WarehouseID,ClientID,ImportDate,ExportDate,IsFood,ExpirDate,BasicCost,ExtraCost,TotalCost) VALUES (135,1,984783,'2016-04-11','2016-07-11',1,'2019-09-18',1107,36,1143);
INSERT INTO Pallet(Position,WarehouseID,ClientID,ImportDate,ExportDate,IsFood,ExpirDate,BasicCost,ExtraCost,TotalCost) VALUES (136,1,382414,'2016-07-18','2016-10-23',0,NULL,1462,54,1516);
INSERT INTO Pallet(Position,WarehouseID,ClientID,ImportDate,ExportDate,IsFood,ExpirDate,BasicCost,ExtraCost,TotalCost) VALUES (137,1,942887,'2016-09-13','2016-09-26',0,NULL,382,153,535);
INSERT INTO Pallet(Position,WarehouseID,ClientID,ImportDate,ExportDate,IsFood,ExpirDate,BasicCost,ExtraCost,TotalCost) VALUES (138,1,818519,'2016-11-22','2017-05-23',1,'2020-06-06',1234,139,1373);
INSERT INTO Pallet(Position,WarehouseID,ClientID,ImportDate,ExportDate,IsFood,ExpirDate,BasicCost,ExtraCost,TotalCost) VALUES (139,1,364390,'2016-10-25','2017-06-18',1,'2020-03-08',2410,92,2502);
INSERT INTO Pallet(Position,WarehouseID,ClientID,ImportDate,ExportDate,IsFood,ExpirDate,BasicCost,ExtraCost,TotalCost) VALUES (140,1,633221,'2016-05-13','2017-03-04',0,NULL,1374,111,1485);
INSERT INTO Pallet(Position,WarehouseID,ClientID,ImportDate,ExportDate,IsFood,ExpirDate,BasicCost,ExtraCost,TotalCost) VALUES (201,1,470355,'2016-09-03','2017-06-30',1,'2020-06-17',1670,175,1845);
INSERT INTO Pallet(Position,WarehouseID,ClientID,ImportDate,ExportDate,IsFood,ExpirDate,BasicCost,ExtraCost,TotalCost) VALUES (202,1,304400,'2016-10-09','2016-11-05',1,'2020-06-11',1177,126,1303);
INSERT INTO Pallet(Position,WarehouseID,ClientID,ImportDate,ExportDate,IsFood,ExpirDate,BasicCost,ExtraCost,TotalCost) VALUES (203,1,606239,'2016-06-25','2017-02-16',0,NULL,545,118,663);
INSERT INTO Pallet(Position,WarehouseID,ClientID,ImportDate,ExportDate,IsFood,ExpirDate,BasicCost,ExtraCost,TotalCost) VALUES (204,1,747654,'2016-12-11','2017-05-19',1,'2020-08-17',1179,95,1274);
INSERT INTO Pallet(Position,WarehouseID,ClientID,ImportDate,ExportDate,IsFood,ExpirDate,BasicCost,ExtraCost,TotalCost) VALUES (205,1,764533,'2016-01-01','2016-10-18',0,NULL,1175,87,1262);
INSERT INTO Pallet(Position,WarehouseID,ClientID,ImportDate,ExportDate,IsFood,ExpirDate,BasicCost,ExtraCost,TotalCost) VALUES (206,1,660900,'2016-09-12','2017-02-03',0,NULL,959,91,1050);
INSERT INTO Pallet(Position,WarehouseID,ClientID,ImportDate,ExportDate,IsFood,ExpirDate,BasicCost,ExtraCost,TotalCost) VALUES (207,1,122707,'2016-06-10','2016-09-22',0,NULL,1656,187,1843);
INSERT INTO Pallet(Position,WarehouseID,ClientID,ImportDate,ExportDate,IsFood,ExpirDate,BasicCost,ExtraCost,TotalCost) VALUES (208,1,998942,'2016-02-09','2016-11-04',0,NULL,1780,182,1962);
INSERT INTO Pallet(Position,WarehouseID,ClientID,ImportDate,ExportDate,IsFood,ExpirDate,BasicCost,ExtraCost,TotalCost) VALUES (209,1,394971,'2016-12-08','2017-02-13',1,'2021-02-10',732,54,786);
INSERT INTO Pallet(Position,WarehouseID,ClientID,ImportDate,ExportDate,IsFood,ExpirDate,BasicCost,ExtraCost,TotalCost) VALUES (210,1,689444,'2016-08-10','2017-04-05',1,'2020-12-14',1355,93,1448);
INSERT INTO Pallet(Position,WarehouseID,ClientID,ImportDate,ExportDate,IsFood,ExpirDate,BasicCost,ExtraCost,TotalCost) VALUES (211,1,921395,'2016-07-10','2016-07-28',1,'2020-11-09',1040,154,1194);
INSERT INTO Pallet(Position,WarehouseID,ClientID,ImportDate,ExportDate,IsFood,ExpirDate,BasicCost,ExtraCost,TotalCost) VALUES (212,1,161828,'2016-02-23','2016-11-21',1,'2020-10-30',1592,27,1619);
INSERT INTO Pallet(Position,WarehouseID,ClientID,ImportDate,ExportDate,IsFood,ExpirDate,BasicCost,ExtraCost,TotalCost) VALUES (213,1,291141,'2016-10-12','2017-04-11',0,NULL,1651,140,1791);
INSERT INTO Pallet(Position,WarehouseID,ClientID,ImportDate,ExportDate,IsFood,ExpirDate,BasicCost,ExtraCost,TotalCost) VALUES (214,1,460523,'2016-11-05','2017-03-19',1,'2020-11-24',1204,156,1360);
INSERT INTO Pallet(Position,WarehouseID,ClientID,ImportDate,ExportDate,IsFood,ExpirDate,BasicCost,ExtraCost,TotalCost) VALUES (215,1,930089,'2016-07-16','2017-04-06',1,'2020-07-07',2354,57,2411);
INSERT INTO Pallet(Position,WarehouseID,ClientID,ImportDate,ExportDate,IsFood,ExpirDate,BasicCost,ExtraCost,TotalCost) VALUES (216,1,881770,'2016-05-30','2016-11-23',1,'2020-04-11',1539,158,1697);
INSERT INTO Pallet(Position,WarehouseID,ClientID,ImportDate,ExportDate,IsFood,ExpirDate,BasicCost,ExtraCost,TotalCost) VALUES (217,1,689444,'2016-01-10','2016-02-11',0,NULL,2032,67,2099);
INSERT INTO Pallet(Position,WarehouseID,ClientID,ImportDate,ExportDate,IsFood,ExpirDate,BasicCost,ExtraCost,TotalCost) VALUES (218,1,396926,'2016-03-07','2016-10-30',1,'2019-12-19',1513,193,1706);
INSERT INTO Pallet(Position,WarehouseID,ClientID,ImportDate,ExportDate,IsFood,ExpirDate,BasicCost,ExtraCost,TotalCost) VALUES (219,1,382414,'2016-08-31','2016-10-10',1,'2021-01-11',1375,167,1542);
INSERT INTO Pallet(Position,WarehouseID,ClientID,ImportDate,ExportDate,IsFood,ExpirDate,BasicCost,ExtraCost,TotalCost) VALUES (220,1,942887,'2016-12-10','2017-04-28',0,NULL,204,185,389);
INSERT INTO Pallet(Position,WarehouseID,ClientID,ImportDate,ExportDate,IsFood,ExpirDate,BasicCost,ExtraCost,TotalCost) VALUES (221,1,122707,'2016-09-17','2017-06-18',0,NULL,2015,171,2186);
INSERT INTO Pallet(Position,WarehouseID,ClientID,ImportDate,ExportDate,IsFood,ExpirDate,BasicCost,ExtraCost,TotalCost) VALUES (222,1,268011,'2016-03-12','2016-04-30',1,'2019-12-14',1183,168,1351);
INSERT INTO Pallet(Position,WarehouseID,ClientID,ImportDate,ExportDate,IsFood,ExpirDate,BasicCost,ExtraCost,TotalCost) VALUES (223,1,492399,'2016-07-11','2017-03-04',0,NULL,299,112,411);
INSERT INTO Pallet(Position,WarehouseID,ClientID,ImportDate,ExportDate,IsFood,ExpirDate,BasicCost,ExtraCost,TotalCost) VALUES (224,1,852542,'2016-08-21','2016-09-24',1,'2020-10-20',1316,84,1400);
INSERT INTO Pallet(Position,WarehouseID,ClientID,ImportDate,ExportDate,IsFood,ExpirDate,BasicCost,ExtraCost,TotalCost) VALUES (225,1,633765,'2016-02-25','2016-04-24',0,NULL,2161,123,2284);
INSERT INTO Pallet(Position,WarehouseID,ClientID,ImportDate,ExportDate,IsFood,ExpirDate,BasicCost,ExtraCost,TotalCost) VALUES (226,1,800341,'2016-09-28','2016-12-11',1,'2020-09-12',634,197,831);
INSERT INTO Pallet(Position,WarehouseID,ClientID,ImportDate,ExportDate,IsFood,ExpirDate,BasicCost,ExtraCost,TotalCost) VALUES (227,1,249901,'2016-04-30','2016-06-30',1,'2019-09-09',705,140,845);
INSERT INTO Pallet(Position,WarehouseID,ClientID,ImportDate,ExportDate,IsFood,ExpirDate,BasicCost,ExtraCost,TotalCost) VALUES (228,1,850568,'2016-01-28','2016-09-01',0,NULL,257,112,369);
INSERT INTO Pallet(Position,WarehouseID,ClientID,ImportDate,ExportDate,IsFood,ExpirDate,BasicCost,ExtraCost,TotalCost) VALUES (229,1,611779,'2016-01-21','2016-04-01',0,NULL,1172,89,1261);
INSERT INTO Pallet(Position,WarehouseID,ClientID,ImportDate,ExportDate,IsFood,ExpirDate,BasicCost,ExtraCost,TotalCost) VALUES (230,1,699753,'2016-08-28','2016-09-26',1,'2021-03-06',1363,42,1405);
INSERT INTO Pallet(Position,WarehouseID,ClientID,ImportDate,ExportDate,IsFood,ExpirDate,BasicCost,ExtraCost,TotalCost) VALUES (231,1,818519,'2016-02-25','2016-11-19',1,'2021-01-25',211,152,363);
INSERT INTO Pallet(Position,WarehouseID,ClientID,ImportDate,ExportDate,IsFood,ExpirDate,BasicCost,ExtraCost,TotalCost) VALUES (232,1,270422,'2016-08-06','2016-11-23',0,NULL,1323,42,1365);
INSERT INTO Pallet(Position,WarehouseID,ClientID,ImportDate,ExportDate,IsFood,ExpirDate,BasicCost,ExtraCost,TotalCost) VALUES (233,1,281127,'2016-01-06','2016-01-14',0,NULL,2194,156,2350);
INSERT INTO Pallet(Position,WarehouseID,ClientID,ImportDate,ExportDate,IsFood,ExpirDate,BasicCost,ExtraCost,TotalCost) VALUES (234,1,553698,'2016-01-05','2016-10-21',1,'2021-01-29',1863,93,1956);
INSERT INTO Pallet(Position,WarehouseID,ClientID,ImportDate,ExportDate,IsFood,ExpirDate,BasicCost,ExtraCost,TotalCost) VALUES (235,1,800341,'2016-02-12','2016-05-02',1,'2019-09-05',1012,62,1074);
INSERT INTO Pallet(Position,WarehouseID,ClientID,ImportDate,ExportDate,IsFood,ExpirDate,BasicCost,ExtraCost,TotalCost) VALUES (236,1,578882,'2016-05-01','2016-12-09',1,'2020-06-25',1404,88,1492);
INSERT INTO Pallet(Position,WarehouseID,ClientID,ImportDate,ExportDate,IsFood,ExpirDate,BasicCost,ExtraCost,TotalCost) VALUES (237,1,249901,'2016-12-09','2017-03-23',0,NULL,1920,117,2037);
INSERT INTO Pallet(Position,WarehouseID,ClientID,ImportDate,ExportDate,IsFood,ExpirDate,BasicCost,ExtraCost,TotalCost) VALUES (238,1,396926,'2016-04-14','2016-04-29',1,'2020-03-08',1072,31,1103);
INSERT INTO Pallet(Position,WarehouseID,ClientID,ImportDate,ExportDate,IsFood,ExpirDate,BasicCost,ExtraCost,TotalCost) VALUES (239,1,593630,'2016-11-03','2017-05-10',0,NULL,208,64,272);
INSERT INTO Pallet(Position,WarehouseID,ClientID,ImportDate,ExportDate,IsFood,ExpirDate,BasicCost,ExtraCost,TotalCost) VALUES (240,1,664922,'2016-03-02','2016-05-29',1,'2020-02-13',583,64,647);
INSERT INTO Pallet(Position,WarehouseID,ClientID,ImportDate,ExportDate,IsFood,ExpirDate,BasicCost,ExtraCost,TotalCost) VALUES (301,1,364390,'2016-06-02','2016-12-21',1,'2019-11-19',1466,96,1562);
INSERT INTO Pallet(Position,WarehouseID,ClientID,ImportDate,ExportDate,IsFood,ExpirDate,BasicCost,ExtraCost,TotalCost) VALUES (302,1,289403,'2016-12-18','2017-07-28',0,NULL,1751,139,1890);
INSERT INTO Pallet(Position,WarehouseID,ClientID,ImportDate,ExportDate,IsFood,ExpirDate,BasicCost,ExtraCost,TotalCost) VALUES (303,1,901269,'2016-04-05','2016-10-05',1,'2020-04-12',591,177,768);
INSERT INTO Pallet(Position,WarehouseID,ClientID,ImportDate,ExportDate,IsFood,ExpirDate,BasicCost,ExtraCost,TotalCost) VALUES (304,1,984783,'2016-05-29','2017-01-14',1,'2020-10-23',863,166,1029);
INSERT INTO Pallet(Position,WarehouseID,ClientID,ImportDate,ExportDate,IsFood,ExpirDate,BasicCost,ExtraCost,TotalCost) VALUES (305,1,382414,'2016-04-27','2017-01-05',0,NULL,1507,83,1590);
INSERT INTO Pallet(Position,WarehouseID,ClientID,ImportDate,ExportDate,IsFood,ExpirDate,BasicCost,ExtraCost,TotalCost) VALUES (306,1,942887,'2016-07-03','2017-02-17',0,NULL,2416,180,2596);
INSERT INTO Pallet(Position,WarehouseID,ClientID,ImportDate,ExportDate,IsFood,ExpirDate,BasicCost,ExtraCost,TotalCost) VALUES (307,1,818519,'2016-10-21','2017-08-15',1,'2020-05-11',932,80,1012);
INSERT INTO Pallet(Position,WarehouseID,ClientID,ImportDate,ExportDate,IsFood,ExpirDate,BasicCost,ExtraCost,TotalCost) VALUES (308,1,364390,'2016-06-05','2016-07-07',0,NULL,50,164,214);
INSERT INTO Pallet(Position,WarehouseID,ClientID,ImportDate,ExportDate,IsFood,ExpirDate,BasicCost,ExtraCost,TotalCost) VALUES (309,1,633221,'2016-10-15','2016-12-19',1,'2020-08-05',2263,53,2316);
INSERT INTO Pallet(Position,WarehouseID,ClientID,ImportDate,ExportDate,IsFood,ExpirDate,BasicCost,ExtraCost,TotalCost) VALUES (310,1,470355,'2016-10-24','2016-12-01',1,'2021-03-06',237,73,310);
INSERT INTO Pallet(Position,WarehouseID,ClientID,ImportDate,ExportDate,IsFood,ExpirDate,BasicCost,ExtraCost,TotalCost) VALUES (311,1,304400,'2016-09-27','2016-12-19',1,'2019-10-30',1031,55,1086);
INSERT INTO Pallet(Position,WarehouseID,ClientID,ImportDate,ExportDate,IsFood,ExpirDate,BasicCost,ExtraCost,TotalCost) VALUES (312,1,606239,'2016-02-16','2016-10-19',0,NULL,62,102,164);
INSERT INTO Pallet(Position,WarehouseID,ClientID,ImportDate,ExportDate,IsFood,ExpirDate,BasicCost,ExtraCost,TotalCost) VALUES (313,1,747654,'2016-12-04','2017-05-05',1,'2019-06-08',69,148,217);
INSERT INTO Pallet(Position,WarehouseID,ClientID,ImportDate,ExportDate,IsFood,ExpirDate,BasicCost,ExtraCost,TotalCost) VALUES (314,1,764533,'2016-05-26','2016-08-31',1,'2019-05-26',822,178,1000);
INSERT INTO Pallet(Position,WarehouseID,ClientID,ImportDate,ExportDate,IsFood,ExpirDate,BasicCost,ExtraCost,TotalCost) VALUES (315,1,660900,'2016-12-03','2017-09-20',1,'2019-09-27',87,155,242);
INSERT INTO Pallet(Position,WarehouseID,ClientID,ImportDate,ExportDate,IsFood,ExpirDate,BasicCost,ExtraCost,TotalCost) VALUES (316,1,122707,'2016-01-23','2016-03-17',1,'2019-06-13',937,39,976);
INSERT INTO Pallet(Position,WarehouseID,ClientID,ImportDate,ExportDate,IsFood,ExpirDate,BasicCost,ExtraCost,TotalCost) VALUES (317,1,998942,'2016-11-10','2017-07-18',0,NULL,1876,112,1988);
INSERT INTO Pallet(Position,WarehouseID,ClientID,ImportDate,ExportDate,IsFood,ExpirDate,BasicCost,ExtraCost,TotalCost) VALUES (318,1,394971,'2016-03-22','2017-01-02',0,NULL,1846,140,1986);
INSERT INTO Pallet(Position,WarehouseID,ClientID,ImportDate,ExportDate,IsFood,ExpirDate,BasicCost,ExtraCost,TotalCost) VALUES (319,1,764533,'2016-06-20','2016-08-11',1,'2020-03-11',1347,66,1413);
INSERT INTO Pallet(Position,WarehouseID,ClientID,ImportDate,ExportDate,IsFood,ExpirDate,BasicCost,ExtraCost,TotalCost) VALUES (320,1,479717,'2016-05-21','2016-11-10',1,'2020-04-17',1937,158,2095);
INSERT INTO Pallet(Position,WarehouseID,ClientID,ImportDate,ExportDate,IsFood,ExpirDate,BasicCost,ExtraCost,TotalCost) VALUES (321,1,914858,'2016-02-13','2016-10-18',0,NULL,1082,37,1119);
INSERT INTO Pallet(Position,WarehouseID,ClientID,ImportDate,ExportDate,IsFood,ExpirDate,BasicCost,ExtraCost,TotalCost) VALUES (322,1,352517,'2016-03-19','2016-08-24',1,'2020-03-29',272,115,387);
INSERT INTO Pallet(Position,WarehouseID,ClientID,ImportDate,ExportDate,IsFood,ExpirDate,BasicCost,ExtraCost,TotalCost) VALUES (323,1,470355,'2016-05-28','2016-06-19',0,NULL,694,77,771);
INSERT INTO Pallet(Position,WarehouseID,ClientID,ImportDate,ExportDate,IsFood,ExpirDate,BasicCost,ExtraCost,TotalCost) VALUES (324,1,250221,'2016-01-23','2016-07-21',0,NULL,763,59,822);
INSERT INTO Pallet(Position,WarehouseID,ClientID,ImportDate,ExportDate,IsFood,ExpirDate,BasicCost,ExtraCost,TotalCost) VALUES (325,1,143277,'2016-04-05','2016-05-30',0,NULL,256,30,286);
INSERT INTO Pallet(Position,WarehouseID,ClientID,ImportDate,ExportDate,IsFood,ExpirDate,BasicCost,ExtraCost,TotalCost) VALUES (326,1,983495,'2016-02-18','2016-08-18',0,NULL,766,64,830);
INSERT INTO Pallet(Position,WarehouseID,ClientID,ImportDate,ExportDate,IsFood,ExpirDate,BasicCost,ExtraCost,TotalCost) VALUES (327,1,595251,'2016-04-28','2016-10-09',0,NULL,780,160,940);
INSERT INTO Pallet(Position,WarehouseID,ClientID,ImportDate,ExportDate,IsFood,ExpirDate,BasicCost,ExtraCost,TotalCost) VALUES (328,1,452007,'2016-04-08','2016-12-30',1,'2021-01-09',1317,161,1478);
INSERT INTO Pallet(Position,WarehouseID,ClientID,ImportDate,ExportDate,IsFood,ExpirDate,BasicCost,ExtraCost,TotalCost) VALUES (329,1,527301,'2016-04-14','2016-05-04',1,'2020-04-02',566,135,701);
INSERT INTO Pallet(Position,WarehouseID,ClientID,ImportDate,ExportDate,IsFood,ExpirDate,BasicCost,ExtraCost,TotalCost) VALUES (330,1,914858,'2016-12-30','2017-04-27',0,NULL,477,58,535);
INSERT INTO Pallet(Position,WarehouseID,ClientID,ImportDate,ExportDate,IsFood,ExpirDate,BasicCost,ExtraCost,TotalCost) VALUES (331,1,275519,'2016-01-24','2016-10-13',1,'2020-02-27',2094,23,2117);
INSERT INTO Pallet(Position,WarehouseID,ClientID,ImportDate,ExportDate,IsFood,ExpirDate,BasicCost,ExtraCost,TotalCost) VALUES (332,1,746901,'2016-08-12','2017-04-12',1,'2020-02-09',541,188,729);
INSERT INTO Pallet(Position,WarehouseID,ClientID,ImportDate,ExportDate,IsFood,ExpirDate,BasicCost,ExtraCost,TotalCost) VALUES (333,1,862575,'2016-09-07','2016-12-15',1,'2019-09-16',1897,122,2019);
INSERT INTO Pallet(Position,WarehouseID,ClientID,ImportDate,ExportDate,IsFood,ExpirDate,BasicCost,ExtraCost,TotalCost) VALUES (334,1,733283,'2016-01-18','2016-08-10',1,'2019-08-30',1494,137,1631);
INSERT INTO Pallet(Position,WarehouseID,ClientID,ImportDate,ExportDate,IsFood,ExpirDate,BasicCost,ExtraCost,TotalCost) VALUES (335,1,582495,'2016-03-22','2016-12-11',0,NULL,1529,37,1566);
INSERT INTO Pallet(Position,WarehouseID,ClientID,ImportDate,ExportDate,IsFood,ExpirDate,BasicCost,ExtraCost,TotalCost) VALUES (336,1,576708,'2016-02-02','2016-02-23',1,'2020-06-01',1129,157,1286);
INSERT INTO Pallet(Position,WarehouseID,ClientID,ImportDate,ExportDate,IsFood,ExpirDate,BasicCost,ExtraCost,TotalCost) VALUES (337,1,912278,'2016-07-25','2017-02-12',0,NULL,1145,116,1261);
INSERT INTO Pallet(Position,WarehouseID,ClientID,ImportDate,ExportDate,IsFood,ExpirDate,BasicCost,ExtraCost,TotalCost) VALUES (338,1,268011,'2016-09-10','2017-03-30',0,NULL,111,109,220);
INSERT INTO Pallet(Position,WarehouseID,ClientID,ImportDate,ExportDate,IsFood,ExpirDate,BasicCost,ExtraCost,TotalCost) VALUES (339,1,452007,'2016-04-22','2016-05-14',1,'2020-08-12',2264,37,2301);
INSERT INTO Pallet(Position,WarehouseID,ClientID,ImportDate,ExportDate,IsFood,ExpirDate,BasicCost,ExtraCost,TotalCost) VALUES (340,1,492399,'2016-07-27','2016-08-09',0,NULL,2459,83,2542);
INSERT INTO Pallet(Position,WarehouseID,ClientID,ImportDate,ExportDate,IsFood,ExpirDate,BasicCost,ExtraCost,TotalCost) VALUES (401,1,970764,'2016-06-10','2016-07-26',0,NULL,829,100,929);
INSERT INTO Pallet(Position,WarehouseID,ClientID,ImportDate,ExportDate,IsFood,ExpirDate,BasicCost,ExtraCost,TotalCost) VALUES (402,1,112982,'2016-02-16','2016-11-12',1,'2020-05-17',482,123,605);
INSERT INTO Pallet(Position,WarehouseID,ClientID,ImportDate,ExportDate,IsFood,ExpirDate,BasicCost,ExtraCost,TotalCost) VALUES (403,1,352517,'2016-08-15','2016-09-28',0,NULL,1101,111,1212);
INSERT INTO Pallet(Position,WarehouseID,ClientID,ImportDate,ExportDate,IsFood,ExpirDate,BasicCost,ExtraCost,TotalCost) VALUES (404,1,724727,'2016-09-10','2017-05-20',1,'2020-11-28',2434,86,2520);
INSERT INTO Pallet(Position,WarehouseID,ClientID,ImportDate,ExportDate,IsFood,ExpirDate,BasicCost,ExtraCost,TotalCost) VALUES (405,1,470355,'2016-06-15','2016-07-27',0,NULL,2313,51,2364);
INSERT INTO Pallet(Position,WarehouseID,ClientID,ImportDate,ExportDate,IsFood,ExpirDate,BasicCost,ExtraCost,TotalCost) VALUES (406,1,901269,'2016-01-17','2016-05-07',0,NULL,2079,163,2242);
INSERT INTO Pallet(Position,WarehouseID,ClientID,ImportDate,ExportDate,IsFood,ExpirDate,BasicCost,ExtraCost,TotalCost) VALUES (407,1,633221,'2016-12-16','2017-01-24',0,NULL,912,177,1089);
INSERT INTO Pallet(Position,WarehouseID,ClientID,ImportDate,ExportDate,IsFood,ExpirDate,BasicCost,ExtraCost,TotalCost) VALUES (408,1,231401,'2016-05-16','2017-02-05',0,NULL,907,58,965);
INSERT INTO Pallet(Position,WarehouseID,ClientID,ImportDate,ExportDate,IsFood,ExpirDate,BasicCost,ExtraCost,TotalCost) VALUES (409,1,970764,'2016-06-05','2016-08-21',1,'2020-10-12',2013,169,2182);
INSERT INTO Pallet(Position,WarehouseID,ClientID,ImportDate,ExportDate,IsFood,ExpirDate,BasicCost,ExtraCost,TotalCost) VALUES (410,1,983495,'2016-11-07','2017-05-17',1,'2020-01-14',1633,196,1829);
INSERT INTO Pallet(Position,WarehouseID,ClientID,ImportDate,ExportDate,IsFood,ExpirDate,BasicCost,ExtraCost,TotalCost) VALUES (411,1,660900,'2016-06-01','2016-07-21',0,NULL,586,92,678);
INSERT INTO Pallet(Position,WarehouseID,ClientID,ImportDate,ExportDate,IsFood,ExpirDate,BasicCost,ExtraCost,TotalCost) VALUES (412,1,593630,'2016-04-23','2016-08-04',0,NULL,617,193,810);
INSERT INTO Pallet(Position,WarehouseID,ClientID,ImportDate,ExportDate,IsFood,ExpirDate,BasicCost,ExtraCost,TotalCost) VALUES (413,1,117299,'2016-06-01','2016-08-10',0,NULL,1579,142,1721);
INSERT INTO Pallet(Position,WarehouseID,ClientID,ImportDate,ExportDate,IsFood,ExpirDate,BasicCost,ExtraCost,TotalCost) VALUES (414,1,611779,'2016-05-28','2017-01-12',0,NULL,1339,42,1381);
INSERT INTO Pallet(Position,WarehouseID,ClientID,ImportDate,ExportDate,IsFood,ExpirDate,BasicCost,ExtraCost,TotalCost) VALUES (415,1,267604,'2016-09-16','2017-01-10',1,'2020-09-26',1597,100,1697);
INSERT INTO Pallet(Position,WarehouseID,ClientID,ImportDate,ExportDate,IsFood,ExpirDate,BasicCost,ExtraCost,TotalCost) VALUES (416,1,777789,'2016-06-30','2016-08-22',0,NULL,436,80,516);
INSERT INTO Pallet(Position,WarehouseID,ClientID,ImportDate,ExportDate,IsFood,ExpirDate,BasicCost,ExtraCost,TotalCost) VALUES (417,1,640896,'2016-09-17','2017-04-05',0,NULL,710,127,837);
INSERT INTO Pallet(Position,WarehouseID,ClientID,ImportDate,ExportDate,IsFood,ExpirDate,BasicCost,ExtraCost,TotalCost) VALUES (418,1,114641,'2016-09-19','2017-01-22',1,'2020-11-14',1084,79,1163);
INSERT INTO Pallet(Position,WarehouseID,ClientID,ImportDate,ExportDate,IsFood,ExpirDate,BasicCost,ExtraCost,TotalCost) VALUES (419,1,444162,'2016-04-26','2016-12-02',0,NULL,370,154,524);
INSERT INTO Pallet(Position,WarehouseID,ClientID,ImportDate,ExportDate,IsFood,ExpirDate,BasicCost,ExtraCost,TotalCost) VALUES (420,1,153015,'2016-10-04','2017-06-17',0,NULL,2266,97,2363);
INSERT INTO Pallet(Position,WarehouseID,ClientID,ImportDate,ExportDate,IsFood,ExpirDate,BasicCost,ExtraCost,TotalCost) VALUES (421,1,335333,'2016-04-30','2016-08-03',0,NULL,1555,189,1744);
INSERT INTO Pallet(Position,WarehouseID,ClientID,ImportDate,ExportDate,IsFood,ExpirDate,BasicCost,ExtraCost,TotalCost) VALUES (422,1,230561,'2016-03-12','2016-07-21',1,'2020-06-02',1010,29,1039);
INSERT INTO Pallet(Position,WarehouseID,ClientID,ImportDate,ExportDate,IsFood,ExpirDate,BasicCost,ExtraCost,TotalCost) VALUES (423,1,117299,'2016-12-14','2017-09-26',1,'2019-06-30',1743,121,1864);
INSERT INTO Pallet(Position,WarehouseID,ClientID,ImportDate,ExportDate,IsFood,ExpirDate,BasicCost,ExtraCost,TotalCost) VALUES (424,1,487506,'2016-06-12','2017-03-09',1,'2020-12-02',1916,162,2078);
INSERT INTO Pallet(Position,WarehouseID,ClientID,ImportDate,ExportDate,IsFood,ExpirDate,BasicCost,ExtraCost,TotalCost) VALUES (425,1,962302,'2016-07-28','2017-03-16',1,'2019-10-16',2015,124,2139);
INSERT INTO Pallet(Position,WarehouseID,ClientID,ImportDate,ExportDate,IsFood,ExpirDate,BasicCost,ExtraCost,TotalCost) VALUES (426,1,916936,'2016-06-30','2017-03-10',0,NULL,2156,160,2316);
INSERT INTO Pallet(Position,WarehouseID,ClientID,ImportDate,ExportDate,IsFood,ExpirDate,BasicCost,ExtraCost,TotalCost) VALUES (427,1,798930,'2016-12-03','2017-06-15',0,NULL,2140,44,2184);
INSERT INTO Pallet(Position,WarehouseID,ClientID,ImportDate,ExportDate,IsFood,ExpirDate,BasicCost,ExtraCost,TotalCost) VALUES (428,1,879220,'2016-10-22','2016-12-02',0,NULL,1345,128,1473);
INSERT INTO Pallet(Position,WarehouseID,ClientID,ImportDate,ExportDate,IsFood,ExpirDate,BasicCost,ExtraCost,TotalCost) VALUES (429,1,536798,'2016-01-15','2016-07-20',0,NULL,763,25,788);
INSERT INTO Pallet(Position,WarehouseID,ClientID,ImportDate,ExportDate,IsFood,ExpirDate,BasicCost,ExtraCost,TotalCost) VALUES (430,1,123022,'2016-09-25','2016-10-28',0,NULL,479,91,570);
INSERT INTO Pallet(Position,WarehouseID,ClientID,ImportDate,ExportDate,IsFood,ExpirDate,BasicCost,ExtraCost,TotalCost) VALUES (431,1,535723,'2016-05-18','2016-11-29',0,NULL,2426,122,2548);
INSERT INTO Pallet(Position,WarehouseID,ClientID,ImportDate,ExportDate,IsFood,ExpirDate,BasicCost,ExtraCost,TotalCost) VALUES (432,1,798930,'2016-02-03','2016-09-05',1,'2020-05-21',845,188,1033);
INSERT INTO Pallet(Position,WarehouseID,ClientID,ImportDate,ExportDate,IsFood,ExpirDate,BasicCost,ExtraCost,TotalCost) VALUES (433,1,257512,'2016-03-21','2016-12-31',0,NULL,500,114,614);
INSERT INTO Pallet(Position,WarehouseID,ClientID,ImportDate,ExportDate,IsFood,ExpirDate,BasicCost,ExtraCost,TotalCost) VALUES (434,1,768853,'2016-06-07','2017-03-03',1,'2021-03-04',116,37,153);
INSERT INTO Pallet(Position,WarehouseID,ClientID,ImportDate,ExportDate,IsFood,ExpirDate,BasicCost,ExtraCost,TotalCost) VALUES (435,1,793670,'2016-07-24','2016-11-23',1,'2019-08-11',695,164,859);
INSERT INTO Pallet(Position,WarehouseID,ClientID,ImportDate,ExportDate,IsFood,ExpirDate,BasicCost,ExtraCost,TotalCost) VALUES (436,1,467435,'2016-01-13','2016-07-29',1,'2021-02-27',1278,138,1416);
INSERT INTO Pallet(Position,WarehouseID,ClientID,ImportDate,ExportDate,IsFood,ExpirDate,BasicCost,ExtraCost,TotalCost) VALUES (437,1,351282,'2016-01-08','2016-06-25',1,'2019-07-19',242,158,400);
INSERT INTO Pallet(Position,WarehouseID,ClientID,ImportDate,ExportDate,IsFood,ExpirDate,BasicCost,ExtraCost,TotalCost) VALUES (438,1,415119,'2016-08-06','2016-11-26',1,'2020-04-21',1175,53,1228);
INSERT INTO Pallet(Position,WarehouseID,ClientID,ImportDate,ExportDate,IsFood,ExpirDate,BasicCost,ExtraCost,TotalCost) VALUES (439,1,813346,'2016-07-11','2016-09-21',0,NULL,1167,200,1367);
INSERT INTO Pallet(Position,WarehouseID,ClientID,ImportDate,ExportDate,IsFood,ExpirDate,BasicCost,ExtraCost,TotalCost) VALUES (440,1,731180,'2016-06-12','2016-08-21',0,NULL,1861,165,2026);
INSERT INTO Pallet(Position,WarehouseID,ClientID,ImportDate,ExportDate,IsFood,ExpirDate,BasicCost,ExtraCost,TotalCost) VALUES (501,1,194552,'2016-05-10','2016-07-07',1,'2020-11-24',1860,45,1905);
INSERT INTO Pallet(Position,WarehouseID,ClientID,ImportDate,ExportDate,IsFood,ExpirDate,BasicCost,ExtraCost,TotalCost) VALUES (502,1,826914,'2016-05-08','2016-08-04',1,'2020-07-26',2425,139,2564);
INSERT INTO Pallet(Position,WarehouseID,ClientID,ImportDate,ExportDate,IsFood,ExpirDate,BasicCost,ExtraCost,TotalCost) VALUES (503,1,372836,'2016-11-01','2016-11-20',1,'2019-09-27',1117,73,1190);
INSERT INTO Pallet(Position,WarehouseID,ClientID,ImportDate,ExportDate,IsFood,ExpirDate,BasicCost,ExtraCost,TotalCost) VALUES (504,1,611760,'2016-08-29','2017-06-11',0,NULL,1707,104,1811);
INSERT INTO Pallet(Position,WarehouseID,ClientID,ImportDate,ExportDate,IsFood,ExpirDate,BasicCost,ExtraCost,TotalCost) VALUES (505,1,881770,'2016-08-01','2016-12-10',1,'2020-07-31',1132,43,1175);
INSERT INTO Pallet(Position,WarehouseID,ClientID,ImportDate,ExportDate,IsFood,ExpirDate,BasicCost,ExtraCost,TotalCost) VALUES (506,1,582495,'2016-12-22','2017-01-22',0,NULL,55,38,93);
INSERT INTO Pallet(Position,WarehouseID,ClientID,ImportDate,ExportDate,IsFood,ExpirDate,BasicCost,ExtraCost,TotalCost) VALUES (507,1,546741,'2016-09-25','2017-01-15',0,NULL,504,154,658);
INSERT INTO Pallet(Position,WarehouseID,ClientID,ImportDate,ExportDate,IsFood,ExpirDate,BasicCost,ExtraCost,TotalCost) VALUES (508,1,886693,'2016-03-29','2016-09-22',0,NULL,423,25,448);
INSERT INTO Pallet(Position,WarehouseID,ClientID,ImportDate,ExportDate,IsFood,ExpirDate,BasicCost,ExtraCost,TotalCost) VALUES (509,1,611779,'2016-09-20','2016-11-21',1,'2019-10-10',1145,96,1241);
INSERT INTO Pallet(Position,WarehouseID,ClientID,ImportDate,ExportDate,IsFood,ExpirDate,BasicCost,ExtraCost,TotalCost) VALUES (510,1,275351,'2016-10-14','2017-01-26',0,NULL,1867,116,1983);
INSERT INTO Pallet(Position,WarehouseID,ClientID,ImportDate,ExportDate,IsFood,ExpirDate,BasicCost,ExtraCost,TotalCost) VALUES (511,1,514942,'2016-04-14','2016-10-13',1,'2021-01-24',553,173,726);
INSERT INTO Pallet(Position,WarehouseID,ClientID,ImportDate,ExportDate,IsFood,ExpirDate,BasicCost,ExtraCost,TotalCost) VALUES (512,1,108641,'2016-05-27','2017-01-23',1,'2019-09-19',2321,84,2405);
INSERT INTO Pallet(Position,WarehouseID,ClientID,ImportDate,ExportDate,IsFood,ExpirDate,BasicCost,ExtraCost,TotalCost) VALUES (513,1,519138,'2016-11-21','2017-06-29',0,NULL,692,133,825);
INSERT INTO Pallet(Position,WarehouseID,ClientID,ImportDate,ExportDate,IsFood,ExpirDate,BasicCost,ExtraCost,TotalCost) VALUES (514,1,751584,'2016-04-04','2016-05-14',1,'2019-06-17',1014,68,1082);
INSERT INTO Pallet(Position,WarehouseID,ClientID,ImportDate,ExportDate,IsFood,ExpirDate,BasicCost,ExtraCost,TotalCost) VALUES (515,1,921395,'2016-01-09','2016-11-01',0,NULL,1268,94,1362);
INSERT INTO Pallet(Position,WarehouseID,ClientID,ImportDate,ExportDate,IsFood,ExpirDate,BasicCost,ExtraCost,TotalCost) VALUES (516,1,983495,'2016-11-27','2017-08-12',0,NULL,1394,53,1447);
INSERT INTO Pallet(Position,WarehouseID,ClientID,ImportDate,ExportDate,IsFood,ExpirDate,BasicCost,ExtraCost,TotalCost) VALUES (517,1,372836,'2016-10-24','2017-05-31',1,'2020-10-17',1227,175,1402);
INSERT INTO Pallet(Position,WarehouseID,ClientID,ImportDate,ExportDate,IsFood,ExpirDate,BasicCost,ExtraCost,TotalCost) VALUES (518,1,372836,'2016-04-16','2016-09-05',1,'2020-04-23',778,45,823);
INSERT INTO Pallet(Position,WarehouseID,ClientID,ImportDate,ExportDate,IsFood,ExpirDate,BasicCost,ExtraCost,TotalCost) VALUES (519,1,699753,'2016-06-28','2017-02-28',0,NULL,215,116,331);
INSERT INTO Pallet(Position,WarehouseID,ClientID,ImportDate,ExportDate,IsFood,ExpirDate,BasicCost,ExtraCost,TotalCost) VALUES (520,1,994385,'2016-10-30','2017-02-06',0,NULL,631,41,672);
INSERT INTO Pallet(Position,WarehouseID,ClientID,ImportDate,ExportDate,IsFood,ExpirDate,BasicCost,ExtraCost,TotalCost) VALUES (521,1,372836,'2016-07-22','2017-03-20',0,NULL,1371,141,1512);
INSERT INTO Pallet(Position,WarehouseID,ClientID,ImportDate,ExportDate,IsFood,ExpirDate,BasicCost,ExtraCost,TotalCost) VALUES (522,1,205573,'2016-01-24','2016-02-29',0,NULL,1747,182,1929);
INSERT INTO Pallet(Position,WarehouseID,ClientID,ImportDate,ExportDate,IsFood,ExpirDate,BasicCost,ExtraCost,TotalCost) VALUES (523,1,194552,'2016-11-30','2017-06-18',1,'2020-05-24',1841,109,1950);
INSERT INTO Pallet(Position,WarehouseID,ClientID,ImportDate,ExportDate,IsFood,ExpirDate,BasicCost,ExtraCost,TotalCost) VALUES (524,1,547385,'2016-01-15','2016-07-22',1,'2020-01-03',1398,110,1508);
INSERT INTO Pallet(Position,WarehouseID,ClientID,ImportDate,ExportDate,IsFood,ExpirDate,BasicCost,ExtraCost,TotalCost) VALUES (525,1,130541,'2016-01-31','2016-04-10',1,'2020-08-28',200,133,333);
INSERT INTO Pallet(Position,WarehouseID,ClientID,ImportDate,ExportDate,IsFood,ExpirDate,BasicCost,ExtraCost,TotalCost) VALUES (526,1,259543,'2016-06-23','2017-01-10',1,'2021-03-02',2295,141,2436);
INSERT INTO Pallet(Position,WarehouseID,ClientID,ImportDate,ExportDate,IsFood,ExpirDate,BasicCost,ExtraCost,TotalCost) VALUES (527,1,689444,'2016-08-17','2017-06-01',1,'2020-01-04',2086,77,2163);
INSERT INTO Pallet(Position,WarehouseID,ClientID,ImportDate,ExportDate,IsFood,ExpirDate,BasicCost,ExtraCost,TotalCost) VALUES (528,1,970764,'2016-10-15','2017-07-05',0,NULL,2071,94,2165);
INSERT INTO Pallet(Position,WarehouseID,ClientID,ImportDate,ExportDate,IsFood,ExpirDate,BasicCost,ExtraCost,TotalCost) VALUES (529,1,988447,'2016-04-10','2017-01-29',0,NULL,85,178,263);
INSERT INTO Pallet(Position,WarehouseID,ClientID,ImportDate,ExportDate,IsFood,ExpirDate,BasicCost,ExtraCost,TotalCost) VALUES (530,1,274882,'2016-07-22','2017-04-02',0,NULL,70,43,113);
INSERT INTO Pallet(Position,WarehouseID,ClientID,ImportDate,ExportDate,IsFood,ExpirDate,BasicCost,ExtraCost,TotalCost) VALUES (531,1,118499,'2016-07-14','2016-12-17',0,NULL,552,173,725);
INSERT INTO Pallet(Position,WarehouseID,ClientID,ImportDate,ExportDate,IsFood,ExpirDate,BasicCost,ExtraCost,TotalCost) VALUES (532,1,270422,'2016-08-01','2016-11-21',0,NULL,180,187,367);
INSERT INTO Pallet(Position,WarehouseID,ClientID,ImportDate,ExportDate,IsFood,ExpirDate,BasicCost,ExtraCost,TotalCost) VALUES (533,1,862575,'2016-11-12','2017-08-06',1,'2021-02-14',1412,76,1488);
INSERT INTO Pallet(Position,WarehouseID,ClientID,ImportDate,ExportDate,IsFood,ExpirDate,BasicCost,ExtraCost,TotalCost) VALUES (534,1,656225,'2016-03-22','2017-01-01',1,'2020-05-10',2195,101,2296);
INSERT INTO Pallet(Position,WarehouseID,ClientID,ImportDate,ExportDate,IsFood,ExpirDate,BasicCost,ExtraCost,TotalCost) VALUES (535,1,747952,'2016-08-15','2017-02-09',0,NULL,1721,106,1827);
INSERT INTO Pallet(Position,WarehouseID,ClientID,ImportDate,ExportDate,IsFood,ExpirDate,BasicCost,ExtraCost,TotalCost) VALUES (536,1,557496,'2016-10-13','2017-02-12',1,'2021-02-16',1059,152,1211);
INSERT INTO Pallet(Position,WarehouseID,ClientID,ImportDate,ExportDate,IsFood,ExpirDate,BasicCost,ExtraCost,TotalCost) VALUES (537,1,916936,'2016-07-22','2016-09-13',0,NULL,913,52,965);
INSERT INTO Pallet(Position,WarehouseID,ClientID,ImportDate,ExportDate,IsFood,ExpirDate,BasicCost,ExtraCost,TotalCost) VALUES (538,1,199689,'2016-12-30','2017-06-14',0,NULL,681,107,788);
INSERT INTO Pallet(Position,WarehouseID,ClientID,ImportDate,ExportDate,IsFood,ExpirDate,BasicCost,ExtraCost,TotalCost) VALUES (539,1,916936,'2016-09-24','2016-12-01',0,NULL,1039,27,1066);
INSERT INTO Pallet(Position,WarehouseID,ClientID,ImportDate,ExportDate,IsFood,ExpirDate,BasicCost,ExtraCost,TotalCost) VALUES (540,1,547385,'2016-06-07','2017-01-31',1,'2019-06-13',1555,123,1678);
INSERT INTO Pallet(Position,WarehouseID,ClientID,ImportDate,ExportDate,IsFood,ExpirDate,BasicCost,ExtraCost,TotalCost) VALUES (601,1,506142,'2016-03-08','2016-05-16',0,NULL,1238,52,1290);
INSERT INTO Pallet(Position,WarehouseID,ClientID,ImportDate,ExportDate,IsFood,ExpirDate,BasicCost,ExtraCost,TotalCost) VALUES (602,1,612245,'2016-06-16','2016-07-27',1,'2021-02-23',2441,126,2567);
INSERT INTO Pallet(Position,WarehouseID,ClientID,ImportDate,ExportDate,IsFood,ExpirDate,BasicCost,ExtraCost,TotalCost) VALUES (603,1,640896,'2016-05-21','2017-03-03',1,'2021-02-10',1794,194,1988);
INSERT INTO Pallet(Position,WarehouseID,ClientID,ImportDate,ExportDate,IsFood,ExpirDate,BasicCost,ExtraCost,TotalCost) VALUES (604,1,352517,'2016-09-09','2017-02-26',1,'2020-12-19',1557,100,1657);
INSERT INTO Pallet(Position,WarehouseID,ClientID,ImportDate,ExportDate,IsFood,ExpirDate,BasicCost,ExtraCost,TotalCost) VALUES (605,1,546741,'2016-01-30','2016-11-06',0,NULL,1523,160,1683);
INSERT INTO Pallet(Position,WarehouseID,ClientID,ImportDate,ExportDate,IsFood,ExpirDate,BasicCost,ExtraCost,TotalCost) VALUES (606,1,480697,'2016-06-05','2016-07-08',1,'2019-07-30',2474,51,2525);
INSERT INTO Pallet(Position,WarehouseID,ClientID,ImportDate,ExportDate,IsFood,ExpirDate,BasicCost,ExtraCost,TotalCost) VALUES (607,1,942887,'2016-06-19','2016-07-09',0,NULL,1947,147,2094);
INSERT INTO Pallet(Position,WarehouseID,ClientID,ImportDate,ExportDate,IsFood,ExpirDate,BasicCost,ExtraCost,TotalCost) VALUES (608,1,842573,'2016-05-02','2016-06-28',1,'2020-09-07',2023,114,2137);
INSERT INTO Pallet(Position,WarehouseID,ClientID,ImportDate,ExportDate,IsFood,ExpirDate,BasicCost,ExtraCost,TotalCost) VALUES (609,1,123022,'2016-07-21','2016-12-01',0,NULL,984,34,1018);
INSERT INTO Pallet(Position,WarehouseID,ClientID,ImportDate,ExportDate,IsFood,ExpirDate,BasicCost,ExtraCost,TotalCost) VALUES (610,1,970764,'2016-04-30','2016-05-15',1,'2020-10-06',344,195,539);
INSERT INTO Pallet(Position,WarehouseID,ClientID,ImportDate,ExportDate,IsFood,ExpirDate,BasicCost,ExtraCost,TotalCost) VALUES (611,1,199689,'2016-01-03','2016-10-27',1,'2019-06-02',554,40,594);
INSERT INTO Pallet(Position,WarehouseID,ClientID,ImportDate,ExportDate,IsFood,ExpirDate,BasicCost,ExtraCost,TotalCost) VALUES (612,1,998942,'2016-03-25','2016-07-06',1,'2020-04-30',2030,20,2050);
INSERT INTO Pallet(Position,WarehouseID,ClientID,ImportDate,ExportDate,IsFood,ExpirDate,BasicCost,ExtraCost,TotalCost) VALUES (613,1,161828,'2016-09-22','2017-02-06',0,NULL,2415,50,2465);
INSERT INTO Pallet(Position,WarehouseID,ClientID,ImportDate,ExportDate,IsFood,ExpirDate,BasicCost,ExtraCost,TotalCost) VALUES (614,1,692825,'2016-10-28','2016-11-07',1,'2019-07-18',1303,47,1350);
INSERT INTO Pallet(Position,WarehouseID,ClientID,ImportDate,ExportDate,IsFood,ExpirDate,BasicCost,ExtraCost,TotalCost) VALUES (615,1,916936,'2016-02-19','2016-09-07',0,NULL,2146,198,2344);
INSERT INTO Pallet(Position,WarehouseID,ClientID,ImportDate,ExportDate,IsFood,ExpirDate,BasicCost,ExtraCost,TotalCost) VALUES (616,1,546741,'2016-09-06','2017-05-13',1,'2020-12-10',465,170,635);
INSERT INTO Pallet(Position,WarehouseID,ClientID,ImportDate,ExportDate,IsFood,ExpirDate,BasicCost,ExtraCost,TotalCost) VALUES (617,1,578882,'2016-10-21','2017-02-11',0,NULL,1160,142,1302);
INSERT INTO Pallet(Position,WarehouseID,ClientID,ImportDate,ExportDate,IsFood,ExpirDate,BasicCost,ExtraCost,TotalCost) VALUES (618,1,396926,'2016-01-17','2016-03-07',0,NULL,141,79,220);
INSERT INTO Pallet(Position,WarehouseID,ClientID,ImportDate,ExportDate,IsFood,ExpirDate,BasicCost,ExtraCost,TotalCost) VALUES (619,1,576708,'2016-09-18','2017-05-26',1,'2019-08-31',1248,82,1330);
INSERT INTO Pallet(Position,WarehouseID,ClientID,ImportDate,ExportDate,IsFood,ExpirDate,BasicCost,ExtraCost,TotalCost) VALUES (620,1,638822,'2016-04-20','2016-07-09',1,'2020-02-26',322,41,363);
INSERT INTO Pallet(Position,WarehouseID,ClientID,ImportDate,ExportDate,IsFood,ExpirDate,BasicCost,ExtraCost,TotalCost) VALUES (621,1,916936,'2016-09-15','2016-09-28',1,'2020-07-06',1023,161,1184);
INSERT INTO Pallet(Position,WarehouseID,ClientID,ImportDate,ExportDate,IsFood,ExpirDate,BasicCost,ExtraCost,TotalCost) VALUES (622,1,357095,'2016-09-23','2016-12-28',1,'2019-06-28',2232,113,2345);
INSERT INTO Pallet(Position,WarehouseID,ClientID,ImportDate,ExportDate,IsFood,ExpirDate,BasicCost,ExtraCost,TotalCost) VALUES (623,1,415119,'2016-04-16','2016-12-16',1,'2020-06-01',1303,122,1425);
INSERT INTO Pallet(Position,WarehouseID,ClientID,ImportDate,ExportDate,IsFood,ExpirDate,BasicCost,ExtraCost,TotalCost) VALUES (624,1,901269,'2016-09-10','2017-05-22',0,NULL,534,84,618);
INSERT INTO Pallet(Position,WarehouseID,ClientID,ImportDate,ExportDate,IsFood,ExpirDate,BasicCost,ExtraCost,TotalCost) VALUES (625,1,912278,'2016-12-13','2017-10-01',0,NULL,1515,131,1646);
INSERT INTO Pallet(Position,WarehouseID,ClientID,ImportDate,ExportDate,IsFood,ExpirDate,BasicCost,ExtraCost,TotalCost) VALUES (626,1,232428,'2016-06-03','2017-01-25',1,'2020-11-26',739,80,819);
INSERT INTO Pallet(Position,WarehouseID,ClientID,ImportDate,ExportDate,IsFood,ExpirDate,BasicCost,ExtraCost,TotalCost) VALUES (627,1,962498,'2016-03-10','2016-10-05',0,NULL,656,108,764);
INSERT INTO Pallet(Position,WarehouseID,ClientID,ImportDate,ExportDate,IsFood,ExpirDate,BasicCost,ExtraCost,TotalCost) VALUES (628,1,606239,'2016-04-18','2016-07-22',0,NULL,2469,138,2607);
INSERT INTO Pallet(Position,WarehouseID,ClientID,ImportDate,ExportDate,IsFood,ExpirDate,BasicCost,ExtraCost,TotalCost) VALUES (629,1,914858,'2016-05-07','2016-11-05',1,'2021-01-26',2159,157,2316);
INSERT INTO Pallet(Position,WarehouseID,ClientID,ImportDate,ExportDate,IsFood,ExpirDate,BasicCost,ExtraCost,TotalCost) VALUES (630,1,368924,'2016-06-17','2017-04-07',0,NULL,155,43,198);
INSERT INTO Pallet(Position,WarehouseID,ClientID,ImportDate,ExportDate,IsFood,ExpirDate,BasicCost,ExtraCost,TotalCost) VALUES (631,1,983495,'2016-01-16','2016-07-03',1,'2019-08-09',2165,25,2190);
INSERT INTO Pallet(Position,WarehouseID,ClientID,ImportDate,ExportDate,IsFood,ExpirDate,BasicCost,ExtraCost,TotalCost) VALUES (632,1,467435,'2016-05-28','2017-01-14',1,'2019-07-09',2363,134,2497);
INSERT INTO Pallet(Position,WarehouseID,ClientID,ImportDate,ExportDate,IsFood,ExpirDate,BasicCost,ExtraCost,TotalCost) VALUES (633,1,576708,'2016-08-07','2016-12-01',0,NULL,1007,191,1198);
INSERT INTO Pallet(Position,WarehouseID,ClientID,ImportDate,ExportDate,IsFood,ExpirDate,BasicCost,ExtraCost,TotalCost) VALUES (634,1,141353,'2016-08-04','2016-10-09',1,'2020-05-21',69,38,107);
INSERT INTO Pallet(Position,WarehouseID,ClientID,ImportDate,ExportDate,IsFood,ExpirDate,BasicCost,ExtraCost,TotalCost) VALUES (635,1,161828,'2016-05-28','2016-09-08',0,NULL,546,77,623);
INSERT INTO Pallet(Position,WarehouseID,ClientID,ImportDate,ExportDate,IsFood,ExpirDate,BasicCost,ExtraCost,TotalCost) VALUES (636,1,230561,'2016-01-30','2016-06-12',0,NULL,1860,143,2003);
INSERT INTO Pallet(Position,WarehouseID,ClientID,ImportDate,ExportDate,IsFood,ExpirDate,BasicCost,ExtraCost,TotalCost) VALUES (637,1,692825,'2016-02-21','2016-06-22',1,'2020-03-31',1239,144,1383);
INSERT INTO Pallet(Position,WarehouseID,ClientID,ImportDate,ExportDate,IsFood,ExpirDate,BasicCost,ExtraCost,TotalCost) VALUES (638,1,810593,'2016-04-10','2016-05-28',0,NULL,747,73,820);
INSERT INTO Pallet(Position,WarehouseID,ClientID,ImportDate,ExportDate,IsFood,ExpirDate,BasicCost,ExtraCost,TotalCost) VALUES (639,1,313819,'2016-05-17','2017-01-02',0,NULL,1976,188,2164);
INSERT INTO Pallet(Position,WarehouseID,ClientID,ImportDate,ExportDate,IsFood,ExpirDate,BasicCost,ExtraCost,TotalCost) VALUES (640,1,885804,'2016-03-30','2016-08-13',0,NULL,2049,114,2163);
INSERT INTO Pallet(Position,WarehouseID,ClientID,ImportDate,ExportDate,IsFood,ExpirDate,BasicCost,ExtraCost,TotalCost) VALUES (101,1,479717,'2019-10-23','2020-01-23',1,'2020-12-06',1644,90,1734);
INSERT INTO Pallet(Position,WarehouseID,ClientID,ImportDate,ExportDate,IsFood,ExpirDate,BasicCost,ExtraCost,TotalCost) VALUES (102,1,850568,'2019-09-16','2020-03-27',0,NULL,644,153,797);
INSERT INTO Pallet(Position,WarehouseID,ClientID,ImportDate,ExportDate,IsFood,ExpirDate,BasicCost,ExtraCost,TotalCost) VALUES (103,1,914858,'2019-07-27','2020-04-30',1,'2020-12-05',1757,65,1822);
INSERT INTO Pallet(Position,WarehouseID,ClientID,ImportDate,ExportDate,IsFood,ExpirDate,BasicCost,ExtraCost,TotalCost) VALUES (104,1,317794,'2019-04-19','2019-11-18',1,'2019-09-04',641,45,686);
INSERT INTO Pallet(Position,WarehouseID,ClientID,ImportDate,ExportDate,IsFood,ExpirDate,BasicCost,ExtraCost,TotalCost) VALUES (105,1,660900,'2018-11-17','2019-01-08',0,NULL,1290,22,1312);
INSERT INTO Pallet(Position,WarehouseID,ClientID,ImportDate,ExportDate,IsFood,ExpirDate,BasicCost,ExtraCost,TotalCost) VALUES (106,1,826914,'2018-05-17','2019-01-31',0,NULL,1716,84,1800);
INSERT INTO Pallet(Position,WarehouseID,ClientID,ImportDate,ExportDate,IsFood,ExpirDate,BasicCost,ExtraCost,TotalCost) VALUES (107,1,765764,'2018-06-09','2019-02-25',1,'2019-09-21',1492,69,1561);
INSERT INTO Pallet(Position,WarehouseID,ClientID,ImportDate,ExportDate,IsFood,ExpirDate,BasicCost,ExtraCost,TotalCost) VALUES (108,1,352517,'2018-02-09','2018-11-07',1,'2020-02-10',2341,102,2443);
INSERT INTO Pallet(Position,WarehouseID,ClientID,ImportDate,ExportDate,IsFood,ExpirDate,BasicCost,ExtraCost,TotalCost) VALUES (109,1,903363,'2019-11-08','2020-04-13',0,NULL,1392,176,1568);
INSERT INTO Pallet(Position,WarehouseID,ClientID,ImportDate,ExportDate,IsFood,ExpirDate,BasicCost,ExtraCost,TotalCost) VALUES (110,1,724727,'2018-06-21','2019-02-14',1,'2020-07-14',1914,197,2111);
INSERT INTO Pallet(Position,WarehouseID,ClientID,ImportDate,ExportDate,IsFood,ExpirDate,BasicCost,ExtraCost,TotalCost) VALUES (111,1,415119,'2018-02-17','2018-04-01',0,NULL,2183,57,2240);
INSERT INTO Pallet(Position,WarehouseID,ClientID,ImportDate,ExportDate,IsFood,ExpirDate,BasicCost,ExtraCost,TotalCost) VALUES (112,1,368924,'2018-12-18','2019-02-27',1,'2021-01-22',325,170,495);
INSERT INTO Pallet(Position,WarehouseID,ClientID,ImportDate,ExportDate,IsFood,ExpirDate,BasicCost,ExtraCost,TotalCost) VALUES (113,1,506808,'2019-07-15','2020-01-15',1,'2020-07-31',1326,54,1380);
INSERT INTO Pallet(Position,WarehouseID,ClientID,ImportDate,ExportDate,IsFood,ExpirDate,BasicCost,ExtraCost,TotalCost) VALUES (114,1,770532,'2019-09-11','2020-05-05',1,'2019-05-27',2217,137,2354);
INSERT INTO Pallet(Position,WarehouseID,ClientID,ImportDate,ExportDate,IsFood,ExpirDate,BasicCost,ExtraCost,TotalCost) VALUES (115,1,853461,'2018-12-02','2019-02-02',1,'2021-01-03',895,161,1056);
INSERT INTO Pallet(Position,WarehouseID,ClientID,ImportDate,ExportDate,IsFood,ExpirDate,BasicCost,ExtraCost,TotalCost) VALUES (116,1,133893,'2018-04-30','2019-01-19',1,'2019-10-13',1889,31,1920);
INSERT INTO Pallet(Position,WarehouseID,ClientID,ImportDate,ExportDate,IsFood,ExpirDate,BasicCost,ExtraCost,TotalCost) VALUES (117,1,159342,'2019-10-09','2020-05-11',0,NULL,304,149,453);
INSERT INTO Pallet(Position,WarehouseID,ClientID,ImportDate,ExportDate,IsFood,ExpirDate,BasicCost,ExtraCost,TotalCost) VALUES (118,1,479717,'2018-10-11','2019-07-08',0,NULL,2471,140,2611);
INSERT INTO Pallet(Position,WarehouseID,ClientID,ImportDate,ExportDate,IsFood,ExpirDate,BasicCost,ExtraCost,TotalCost) VALUES (119,1,232428,'2019-06-25','2019-09-19',1,'2019-08-01',2433,41,2474);
INSERT INTO Pallet(Position,WarehouseID,ClientID,ImportDate,ExportDate,IsFood,ExpirDate,BasicCost,ExtraCost,TotalCost) VALUES (120,1,578882,'2019-08-28','2020-06-16',0,NULL,1941,38,1979);
INSERT INTO Pallet(Position,WarehouseID,ClientID,ImportDate,ExportDate,IsFood,ExpirDate,BasicCost,ExtraCost,TotalCost) VALUES (121,1,430909,'2018-09-17','2019-01-19',0,NULL,1093,121,1214);
INSERT INTO Pallet(Position,WarehouseID,ClientID,ImportDate,ExportDate,IsFood,ExpirDate,BasicCost,ExtraCost,TotalCost) VALUES (122,1,962498,'2018-06-23','2019-04-16',0,NULL,2248,90,2338);
INSERT INTO Pallet(Position,WarehouseID,ClientID,ImportDate,ExportDate,IsFood,ExpirDate,BasicCost,ExtraCost,TotalCost) VALUES (123,1,285130,'2019-04-04','2020-01-24',1,'2020-09-05',1767,168,1935);
INSERT INTO Pallet(Position,WarehouseID,ClientID,ImportDate,ExportDate,IsFood,ExpirDate,BasicCost,ExtraCost,TotalCost) VALUES (124,1,623670,'2018-10-07','2018-11-09',1,'2019-12-06',2226,119,2345);
INSERT INTO Pallet(Position,WarehouseID,ClientID,ImportDate,ExportDate,IsFood,ExpirDate,BasicCost,ExtraCost,TotalCost) VALUES (125,1,432084,'2018-04-11','2018-11-22',1,'2020-05-22',1146,200,1346);
INSERT INTO Pallet(Position,WarehouseID,ClientID,ImportDate,ExportDate,IsFood,ExpirDate,BasicCost,ExtraCost,TotalCost) VALUES (126,1,739819,'2018-10-09','2019-06-07',0,NULL,376,72,448);
INSERT INTO Pallet(Position,WarehouseID,ClientID,ImportDate,ExportDate,IsFood,ExpirDate,BasicCost,ExtraCost,TotalCost) VALUES (127,1,546741,'2019-05-24','2019-11-30',1,'2020-07-23',1102,94,1196);
INSERT INTO Pallet(Position,WarehouseID,ClientID,ImportDate,ExportDate,IsFood,ExpirDate,BasicCost,ExtraCost,TotalCost) VALUES (128,1,352517,'2019-02-04','2019-02-22',1,'2019-06-05',839,84,923);
INSERT INTO Pallet(Position,WarehouseID,ClientID,ImportDate,ExportDate,IsFood,ExpirDate,BasicCost,ExtraCost,TotalCost) VALUES (129,1,267604,'2018-04-02','2018-10-13',0,NULL,706,147,853);
INSERT INTO Pallet(Position,WarehouseID,ClientID,ImportDate,ExportDate,IsFood,ExpirDate,BasicCost,ExtraCost,TotalCost) VALUES (130,1,153015,'2018-09-10','2019-01-31',1,'2020-11-07',2452,103,2555);
INSERT INTO Pallet(Position,WarehouseID,ClientID,ImportDate,ExportDate,IsFood,ExpirDate,BasicCost,ExtraCost,TotalCost) VALUES (131,1,612245,'2018-09-06','2018-10-12',1,'2019-07-26',1020,144,1164);
INSERT INTO Pallet(Position,WarehouseID,ClientID,ImportDate,ExportDate,IsFood,ExpirDate,BasicCost,ExtraCost,TotalCost) VALUES (132,1,106830,'2018-12-10','2019-09-08',1,'2020-01-28',1935,48,1983);
INSERT INTO Pallet(Position,WarehouseID,ClientID,ImportDate,ExportDate,IsFood,ExpirDate,BasicCost,ExtraCost,TotalCost) VALUES (133,1,746901,'2018-12-17','2019-03-21',1,'2020-11-30',1650,89,1739);
INSERT INTO Pallet(Position,WarehouseID,ClientID,ImportDate,ExportDate,IsFood,ExpirDate,BasicCost,ExtraCost,TotalCost) VALUES (134,1,257512,'2019-10-04','2019-10-16',1,'2020-06-22',1424,55,1479);
INSERT INTO Pallet(Position,WarehouseID,ClientID,ImportDate,ExportDate,IsFood,ExpirDate,BasicCost,ExtraCost,TotalCost) VALUES (135,1,143277,'2019-06-30','2019-12-11',1,'2020-11-12',1108,197,1305);
INSERT INTO Pallet(Position,WarehouseID,ClientID,ImportDate,ExportDate,IsFood,ExpirDate,BasicCost,ExtraCost,TotalCost) VALUES (136,1,611779,'2019-02-09','2019-11-15',0,NULL,201,28,229);
INSERT INTO Pallet(Position,WarehouseID,ClientID,ImportDate,ExportDate,IsFood,ExpirDate,BasicCost,ExtraCost,TotalCost) VALUES (137,1,576708,'2019-03-21','2020-01-12',1,'2019-08-29',2154,192,2346);
INSERT INTO Pallet(Position,WarehouseID,ClientID,ImportDate,ExportDate,IsFood,ExpirDate,BasicCost,ExtraCost,TotalCost) VALUES (138,1,351282,'2018-01-17','2018-06-07',1,'2020-07-23',1303,56,1359);
INSERT INTO Pallet(Position,WarehouseID,ClientID,ImportDate,ExportDate,IsFood,ExpirDate,BasicCost,ExtraCost,TotalCost) VALUES (139,1,746901,'2019-07-04','2020-01-11',0,NULL,1894,72,1966);
INSERT INTO Pallet(Position,WarehouseID,ClientID,ImportDate,ExportDate,IsFood,ExpirDate,BasicCost,ExtraCost,TotalCost) VALUES (140,1,988447,'2018-04-28','2018-09-30',0,NULL,229,142,371);
INSERT INTO Pallet(Position,WarehouseID,ClientID,ImportDate,ExportDate,IsFood,ExpirDate,BasicCost,ExtraCost,TotalCost) VALUES (201,1,994385,'2019-03-22','2019-06-08',1,'2019-10-20',259,75,334);
INSERT INTO Pallet(Position,WarehouseID,ClientID,ImportDate,ExportDate,IsFood,ExpirDate,BasicCost,ExtraCost,TotalCost) VALUES (202,1,460523,'2019-01-17','2019-03-29',1,'2019-10-21',2286,174,2460);
INSERT INTO Pallet(Position,WarehouseID,ClientID,ImportDate,ExportDate,IsFood,ExpirDate,BasicCost,ExtraCost,TotalCost) VALUES (203,1,853461,'2018-11-13','2019-05-06',0,NULL,1374,86,1460);
INSERT INTO Pallet(Position,WarehouseID,ClientID,ImportDate,ExportDate,IsFood,ExpirDate,BasicCost,ExtraCost,TotalCost) VALUES (204,1,460523,'2019-11-22','2020-02-14',1,'2019-11-29',816,178,994);
INSERT INTO Pallet(Position,WarehouseID,ClientID,ImportDate,ExportDate,IsFood,ExpirDate,BasicCost,ExtraCost,TotalCost) VALUES (205,1,860545,'2019-09-05','2020-02-12',0,NULL,1139,44,1183);
INSERT INTO Pallet(Position,WarehouseID,ClientID,ImportDate,ExportDate,IsFood,ExpirDate,BasicCost,ExtraCost,TotalCost) VALUES (206,1,633221,'2019-08-20','2020-04-13',1,'2020-06-15',746,72,818);
INSERT INTO Pallet(Position,WarehouseID,ClientID,ImportDate,ExportDate,IsFood,ExpirDate,BasicCost,ExtraCost,TotalCost) VALUES (207,1,299036,'2018-04-09','2018-08-18',1,'2019-10-03',469,171,640);
INSERT INTO Pallet(Position,WarehouseID,ClientID,ImportDate,ExportDate,IsFood,ExpirDate,BasicCost,ExtraCost,TotalCost) VALUES (208,1,232428,'2019-04-12','2019-10-18',0,NULL,2186,84,2270);
INSERT INTO Pallet(Position,WarehouseID,ClientID,ImportDate,ExportDate,IsFood,ExpirDate,BasicCost,ExtraCost,TotalCost) VALUES (209,1,572024,'2019-07-26','2020-03-08',1,'2020-11-16',1128,181,1309);
INSERT INTO Pallet(Position,WarehouseID,ClientID,ImportDate,ExportDate,IsFood,ExpirDate,BasicCost,ExtraCost,TotalCost) VALUES (210,1,179644,'2019-02-06','2019-04-21',1,'2020-12-28',1945,160,2105);
INSERT INTO Pallet(Position,WarehouseID,ClientID,ImportDate,ExportDate,IsFood,ExpirDate,BasicCost,ExtraCost,TotalCost) VALUES (211,1,171710,'2019-03-25','2019-07-17',0,NULL,1075,148,1223);
INSERT INTO Pallet(Position,WarehouseID,ClientID,ImportDate,ExportDate,IsFood,ExpirDate,BasicCost,ExtraCost,TotalCost) VALUES (212,1,506142,'2019-09-11','2020-06-15',1,'2020-12-12',1672,49,1721);
INSERT INTO Pallet(Position,WarehouseID,ClientID,ImportDate,ExportDate,IsFood,ExpirDate,BasicCost,ExtraCost,TotalCost) VALUES (213,1,595251,'2019-05-13','2019-06-19',1,'2019-07-17',1310,172,1482);
INSERT INTO Pallet(Position,WarehouseID,ClientID,ImportDate,ExportDate,IsFood,ExpirDate,BasicCost,ExtraCost,TotalCost) VALUES (214,1,231401,'2018-02-26','2018-05-15',1,'2021-01-23',1168,151,1319);
INSERT INTO Pallet(Position,WarehouseID,ClientID,ImportDate,ExportDate,IsFood,ExpirDate,BasicCost,ExtraCost,TotalCost) VALUES (215,1,232428,'2018-08-17','2018-12-17',1,'2019-08-11',1766,144,1910);
INSERT INTO Pallet(Position,WarehouseID,ClientID,ImportDate,ExportDate,IsFood,ExpirDate,BasicCost,ExtraCost,TotalCost) VALUES (216,1,108641,'2018-11-15','2019-02-16',0,NULL,513,173,686);
INSERT INTO Pallet(Position,WarehouseID,ClientID,ImportDate,ExportDate,IsFood,ExpirDate,BasicCost,ExtraCost,TotalCost) VALUES (217,1,930089,'2018-12-08','2019-08-05',1,'2020-02-08',1645,156,1801);
INSERT INTO Pallet(Position,WarehouseID,ClientID,ImportDate,ExportDate,IsFood,ExpirDate,BasicCost,ExtraCost,TotalCost) VALUES (218,1,879220,'2019-07-15','2020-04-06',0,NULL,1630,100,1730);
INSERT INTO Pallet(Position,WarehouseID,ClientID,ImportDate,ExportDate,IsFood,ExpirDate,BasicCost,ExtraCost,TotalCost) VALUES (219,1,268011,'2019-08-20','2020-05-20',0,NULL,2033,80,2113);
INSERT INTO Pallet(Position,WarehouseID,ClientID,ImportDate,ExportDate,IsFood,ExpirDate,BasicCost,ExtraCost,TotalCost) VALUES (220,1,870564,'2019-07-06','2019-11-03',0,NULL,2371,49,2420);
INSERT INTO Pallet(Position,WarehouseID,ClientID,ImportDate,ExportDate,IsFood,ExpirDate,BasicCost,ExtraCost,TotalCost) VALUES (221,1,813346,'2019-07-13','2020-02-15',1,'2019-10-20',2012,147,2159);
INSERT INTO Pallet(Position,WarehouseID,ClientID,ImportDate,ExportDate,IsFood,ExpirDate,BasicCost,ExtraCost,TotalCost) VALUES (222,1,275351,'2018-06-02','2019-03-09',0,NULL,2243,130,2373);
INSERT INTO Pallet(Position,WarehouseID,ClientID,ImportDate,ExportDate,IsFood,ExpirDate,BasicCost,ExtraCost,TotalCost) VALUES (223,1,275351,'2019-08-05','2019-11-04',1,'2020-03-23',1490,53,1543);
INSERT INTO Pallet(Position,WarehouseID,ClientID,ImportDate,ExportDate,IsFood,ExpirDate,BasicCost,ExtraCost,TotalCost) VALUES (224,1,231401,'2019-05-16','2020-01-21',1,'2021-02-26',764,108,872);
INSERT INTO Pallet(Position,WarehouseID,ClientID,ImportDate,ExportDate,IsFood,ExpirDate,BasicCost,ExtraCost,TotalCost) VALUES (225,1,800341,'2018-04-25','2018-05-14',0,NULL,1721,92,1813);
INSERT INTO Pallet(Position,WarehouseID,ClientID,ImportDate,ExportDate,IsFood,ExpirDate,BasicCost,ExtraCost,TotalCost) VALUES (226,1,153015,'2018-02-23','2018-08-23',1,'2020-05-10',527,64,591);
INSERT INTO Pallet(Position,WarehouseID,ClientID,ImportDate,ExportDate,IsFood,ExpirDate,BasicCost,ExtraCost,TotalCost) VALUES (227,1,731180,'2019-11-13','2020-08-15',1,'2021-02-09',930,166,1096);
INSERT INTO Pallet(Position,WarehouseID,ClientID,ImportDate,ExportDate,IsFood,ExpirDate,BasicCost,ExtraCost,TotalCost) VALUES (228,1,123022,'2019-04-26','2019-06-26',1,'2019-05-26',240,136,376);
INSERT INTO Pallet(Position,WarehouseID,ClientID,ImportDate,ExportDate,IsFood,ExpirDate,BasicCost,ExtraCost,TotalCost) VALUES (229,1,862575,'2018-08-16','2018-08-31',0,NULL,839,30,869);
INSERT INTO Pallet(Position,WarehouseID,ClientID,ImportDate,ExportDate,IsFood,ExpirDate,BasicCost,ExtraCost,TotalCost) VALUES (230,1,432084,'2018-01-31','2018-09-13',0,NULL,1509,91,1600);
INSERT INTO Pallet(Position,WarehouseID,ClientID,ImportDate,ExportDate,IsFood,ExpirDate,BasicCost,ExtraCost,TotalCost) VALUES (231,1,765764,'2018-12-02','2019-05-12',0,NULL,2286,55,2341);
INSERT INTO Pallet(Position,WarehouseID,ClientID,ImportDate,ExportDate,IsFood,ExpirDate,BasicCost,ExtraCost,TotalCost) VALUES (232,1,364390,'2018-07-29','2018-11-02',0,NULL,292,159,451);
INSERT INTO Pallet(Position,WarehouseID,ClientID,ImportDate,ExportDate,IsFood,ExpirDate,BasicCost,ExtraCost,TotalCost) VALUES (233,1,553698,'2019-06-27','2019-08-27',1,'2020-06-18',1504,109,1613);
INSERT INTO Pallet(Position,WarehouseID,ClientID,ImportDate,ExportDate,IsFood,ExpirDate,BasicCost,ExtraCost,TotalCost) VALUES (234,1,582495,'2018-09-25','2018-12-29',1,'2019-08-16',111,102,213);
INSERT INTO Pallet(Position,WarehouseID,ClientID,ImportDate,ExportDate,IsFood,ExpirDate,BasicCost,ExtraCost,TotalCost) VALUES (235,1,824205,'2019-02-02','2019-07-30',0,NULL,987,113,1100);
INSERT INTO Pallet(Position,WarehouseID,ClientID,ImportDate,ExportDate,IsFood,ExpirDate,BasicCost,ExtraCost,TotalCost) VALUES (236,1,281127,'2018-10-26','2019-04-22',0,NULL,1905,191,2096);
INSERT INTO Pallet(Position,WarehouseID,ClientID,ImportDate,ExportDate,IsFood,ExpirDate,BasicCost,ExtraCost,TotalCost) VALUES (237,1,747654,'2019-02-19','2019-05-12',1,'2020-02-04',2330,170,2500);
INSERT INTO Pallet(Position,WarehouseID,ClientID,ImportDate,ExportDate,IsFood,ExpirDate,BasicCost,ExtraCost,TotalCost) VALUES (238,1,612245,'2018-11-01','2019-05-13',1,'2020-11-21',1348,130,1478);
INSERT INTO Pallet(Position,WarehouseID,ClientID,ImportDate,ExportDate,IsFood,ExpirDate,BasicCost,ExtraCost,TotalCost) VALUES (239,1,746901,'2018-06-12','2018-09-30',1,'2020-12-22',1489,104,1593);
INSERT INTO Pallet(Position,WarehouseID,ClientID,ImportDate,ExportDate,IsFood,ExpirDate,BasicCost,ExtraCost,TotalCost) VALUES (240,1,746901,'2018-06-03','2018-06-20',1,'2021-02-10',1498,199,1697);
INSERT INTO Pallet(Position,WarehouseID,ClientID,ImportDate,ExportDate,IsFood,ExpirDate,BasicCost,ExtraCost,TotalCost) VALUES (301,1,764533,'2019-08-11','2019-12-26',1,'2019-08-30',295,158,453);
INSERT INTO Pallet(Position,WarehouseID,ClientID,ImportDate,ExportDate,IsFood,ExpirDate,BasicCost,ExtraCost,TotalCost) VALUES (302,1,949966,'2018-02-05','2018-05-12',1,'2021-02-18',749,103,852);
INSERT INTO Pallet(Position,WarehouseID,ClientID,ImportDate,ExportDate,IsFood,ExpirDate,BasicCost,ExtraCost,TotalCost) VALUES (303,1,998942,'2019-08-28','2019-12-25',0,NULL,533,136,669);
INSERT INTO Pallet(Position,WarehouseID,ClientID,ImportDate,ExportDate,IsFood,ExpirDate,BasicCost,ExtraCost,TotalCost) VALUES (304,1,881770,'2018-12-09','2019-06-10',1,'2021-01-18',2210,121,2331);
INSERT INTO Pallet(Position,WarehouseID,ClientID,ImportDate,ExportDate,IsFood,ExpirDate,BasicCost,ExtraCost,TotalCost) VALUES (305,1,338671,'2019-04-30','2019-10-27',1,'2019-10-12',2119,113,2232);
INSERT INTO Pallet(Position,WarehouseID,ClientID,ImportDate,ExportDate,IsFood,ExpirDate,BasicCost,ExtraCost,TotalCost) VALUES (306,1,335333,'2018-06-27','2018-09-10',1,'2020-03-01',1707,97,1804);
INSERT INTO Pallet(Position,WarehouseID,ClientID,ImportDate,ExportDate,IsFood,ExpirDate,BasicCost,ExtraCost,TotalCost) VALUES (307,1,181571,'2019-03-01','2019-03-12',1,'2020-03-24',977,101,1078);
INSERT INTO Pallet(Position,WarehouseID,ClientID,ImportDate,ExportDate,IsFood,ExpirDate,BasicCost,ExtraCost,TotalCost) VALUES (308,1,582495,'2019-07-16','2020-01-03',1,'2021-02-24',2050,88,2138);
INSERT INTO Pallet(Position,WarehouseID,ClientID,ImportDate,ExportDate,IsFood,ExpirDate,BasicCost,ExtraCost,TotalCost) VALUES (309,1,779887,'2018-07-13','2019-02-17',1,'2019-08-21',1084,99,1183);
INSERT INTO Pallet(Position,WarehouseID,ClientID,ImportDate,ExportDate,IsFood,ExpirDate,BasicCost,ExtraCost,TotalCost) VALUES (310,1,108641,'2019-10-26','2020-05-26',1,'2020-08-28',1452,193,1645);
INSERT INTO Pallet(Position,WarehouseID,ClientID,ImportDate,ExportDate,IsFood,ExpirDate,BasicCost,ExtraCost,TotalCost) VALUES (311,1,514942,'2019-02-28','2019-06-06',1,'2020-05-25',2356,174,2530);
INSERT INTO Pallet(Position,WarehouseID,ClientID,ImportDate,ExportDate,IsFood,ExpirDate,BasicCost,ExtraCost,TotalCost) VALUES (312,1,853461,'2018-08-20','2019-06-02',1,'2019-06-28',1507,73,1580);
INSERT INTO Pallet(Position,WarehouseID,ClientID,ImportDate,ExportDate,IsFood,ExpirDate,BasicCost,ExtraCost,TotalCost) VALUES (313,1,557496,'2018-11-27','2019-03-27',1,'2020-11-30',348,174,522);
INSERT INTO Pallet(Position,WarehouseID,ClientID,ImportDate,ExportDate,IsFood,ExpirDate,BasicCost,ExtraCost,TotalCost) VALUES (314,1,813346,'2019-09-24','2019-11-10',1,'2020-06-20',1808,143,1951);
INSERT INTO Pallet(Position,WarehouseID,ClientID,ImportDate,ExportDate,IsFood,ExpirDate,BasicCost,ExtraCost,TotalCost) VALUES (315,1,546741,'2018-10-31','2018-11-20',1,'2021-02-16',1185,157,1342);
INSERT INTO Pallet(Position,WarehouseID,ClientID,ImportDate,ExportDate,IsFood,ExpirDate,BasicCost,ExtraCost,TotalCost) VALUES (316,1,117299,'2018-11-08','2019-07-04',0,NULL,1790,113,1903);
INSERT INTO Pallet(Position,WarehouseID,ClientID,ImportDate,ExportDate,IsFood,ExpirDate,BasicCost,ExtraCost,TotalCost) VALUES (317,1,230561,'2018-02-24','2018-07-25',1,'2020-05-02',1018,63,1081);
INSERT INTO Pallet(Position,WarehouseID,ClientID,ImportDate,ExportDate,IsFood,ExpirDate,BasicCost,ExtraCost,TotalCost) VALUES (318,1,764533,'2019-02-05','2019-08-17',1,'2020-03-25',2086,57,2143);
INSERT INTO Pallet(Position,WarehouseID,ClientID,ImportDate,ExportDate,IsFood,ExpirDate,BasicCost,ExtraCost,TotalCost) VALUES (319,1,108641,'2019-08-06','2020-05-20',0,NULL,2252,67,2319);
INSERT INTO Pallet(Position,WarehouseID,ClientID,ImportDate,ExportDate,IsFood,ExpirDate,BasicCost,ExtraCost,TotalCost) VALUES (320,1,117299,'2019-06-14','2019-09-16',0,NULL,2360,135,2495);
INSERT INTO Pallet(Position,WarehouseID,ClientID,ImportDate,ExportDate,IsFood,ExpirDate,BasicCost,ExtraCost,TotalCost) VALUES (321,1,852542,'2018-04-17','2018-06-30',0,NULL,236,199,435);
INSERT INTO Pallet(Position,WarehouseID,ClientID,ImportDate,ExportDate,IsFood,ExpirDate,BasicCost,ExtraCost,TotalCost) VALUES (322,1,899310,'2018-10-24','2019-07-05',1,'2020-01-22',60,38,98);
INSERT INTO Pallet(Position,WarehouseID,ClientID,ImportDate,ExportDate,IsFood,ExpirDate,BasicCost,ExtraCost,TotalCost) VALUES (323,1,430879,'2019-03-29','2019-09-09',0,NULL,1420,113,1533);
INSERT INTO Pallet(Position,WarehouseID,ClientID,ImportDate,ExportDate,IsFood,ExpirDate,BasicCost,ExtraCost,TotalCost) VALUES (324,1,638822,'2018-08-11','2019-02-02',0,NULL,576,63,639);
INSERT INTO Pallet(Position,WarehouseID,ClientID,ImportDate,ExportDate,IsFood,ExpirDate,BasicCost,ExtraCost,TotalCost) VALUES (325,1,281127,'2019-09-16','2020-04-09',0,NULL,2206,64,2270);
INSERT INTO Pallet(Position,WarehouseID,ClientID,ImportDate,ExportDate,IsFood,ExpirDate,BasicCost,ExtraCost,TotalCost) VALUES (326,1,820054,'2019-06-05','2020-03-27',1,'2020-01-18',2260,165,2425);
INSERT INTO Pallet(Position,WarehouseID,ClientID,ImportDate,ExportDate,IsFood,ExpirDate,BasicCost,ExtraCost,TotalCost) VALUES (327,1,458711,'2018-06-19','2018-09-30',0,NULL,1577,110,1687);
INSERT INTO Pallet(Position,WarehouseID,ClientID,ImportDate,ExportDate,IsFood,ExpirDate,BasicCost,ExtraCost,TotalCost) VALUES (328,1,197520,'2018-03-14','2018-10-17',0,NULL,1222,177,1399);
INSERT INTO Pallet(Position,WarehouseID,ClientID,ImportDate,ExportDate,IsFood,ExpirDate,BasicCost,ExtraCost,TotalCost) VALUES (329,1,942887,'2018-06-20','2018-12-22',1,'2020-08-22',927,159,1086);
INSERT INTO Pallet(Position,WarehouseID,ClientID,ImportDate,ExportDate,IsFood,ExpirDate,BasicCost,ExtraCost,TotalCost) VALUES (330,1,826914,'2019-04-27','2019-05-10',1,'2020-11-28',2111,94,2205);
INSERT INTO Pallet(Position,WarehouseID,ClientID,ImportDate,ExportDate,IsFood,ExpirDate,BasicCost,ExtraCost,TotalCost) VALUES (331,1,430909,'2018-03-29','2018-07-31',1,'2020-06-21',1130,182,1312);
INSERT INTO Pallet(Position,WarehouseID,ClientID,ImportDate,ExportDate,IsFood,ExpirDate,BasicCost,ExtraCost,TotalCost) VALUES (332,1,611779,'2018-08-11','2018-10-30',0,NULL,484,166,650);
INSERT INTO Pallet(Position,WarehouseID,ClientID,ImportDate,ExportDate,IsFood,ExpirDate,BasicCost,ExtraCost,TotalCost) VALUES (333,1,779887,'2019-08-07','2019-09-02',0,NULL,1912,66,1978);
INSERT INTO Pallet(Position,WarehouseID,ClientID,ImportDate,ExportDate,IsFood,ExpirDate,BasicCost,ExtraCost,TotalCost) VALUES (334,1,764533,'2018-11-08','2018-11-28',0,NULL,269,160,429);
INSERT INTO Pallet(Position,WarehouseID,ClientID,ImportDate,ExportDate,IsFood,ExpirDate,BasicCost,ExtraCost,TotalCost) VALUES (335,1,751584,'2018-01-05','2018-03-13',0,NULL,1653,95,1748);
INSERT INTO Pallet(Position,WarehouseID,ClientID,ImportDate,ExportDate,IsFood,ExpirDate,BasicCost,ExtraCost,TotalCost) VALUES (336,1,611760,'2018-12-08','2019-10-02',0,NULL,1941,115,2056);
INSERT INTO Pallet(Position,WarehouseID,ClientID,ImportDate,ExportDate,IsFood,ExpirDate,BasicCost,ExtraCost,TotalCost) VALUES (337,1,762358,'2019-07-26','2019-08-30',1,'2019-11-27',139,174,313);
INSERT INTO Pallet(Position,WarehouseID,ClientID,ImportDate,ExportDate,IsFood,ExpirDate,BasicCost,ExtraCost,TotalCost) VALUES (338,1,984783,'2019-11-14','2020-01-14',0,NULL,226,172,398);
INSERT INTO Pallet(Position,WarehouseID,ClientID,ImportDate,ExportDate,IsFood,ExpirDate,BasicCost,ExtraCost,TotalCost) VALUES (339,1,536798,'2019-02-21','2019-07-02',1,'2019-06-06',791,31,822);
INSERT INTO Pallet(Position,WarehouseID,ClientID,ImportDate,ExportDate,IsFood,ExpirDate,BasicCost,ExtraCost,TotalCost) VALUES (340,1,232428,'2018-12-24','2019-09-03',1,'2020-04-06',873,141,1014);
INSERT INTO Pallet(Position,WarehouseID,ClientID,ImportDate,ExportDate,IsFood,ExpirDate,BasicCost,ExtraCost,TotalCost) VALUES (401,1,778351,'2018-05-16','2019-01-16',0,NULL,1098,38,1136);
INSERT INTO Pallet(Position,WarehouseID,ClientID,ImportDate,ExportDate,IsFood,ExpirDate,BasicCost,ExtraCost,TotalCost) VALUES (402,1,860545,'2019-10-19','2019-12-25',1,'2021-02-09',2145,180,2325);
INSERT INTO Pallet(Position,WarehouseID,ClientID,ImportDate,ExportDate,IsFood,ExpirDate,BasicCost,ExtraCost,TotalCost) VALUES (403,1,199689,'2019-03-06','2019-10-19',0,NULL,2089,141,2230);
INSERT INTO Pallet(Position,WarehouseID,ClientID,ImportDate,ExportDate,IsFood,ExpirDate,BasicCost,ExtraCost,TotalCost) VALUES (404,1,415119,'2019-03-10','2019-10-14',1,'2019-06-18',1429,125,1554);
INSERT INTO Pallet(Position,WarehouseID,ClientID,ImportDate,ExportDate,IsFood,ExpirDate,BasicCost,ExtraCost,TotalCost) VALUES (405,1,803505,'2019-08-02','2020-01-29',1,'2020-04-27',2231,186,2417);
INSERT INTO Pallet(Position,WarehouseID,ClientID,ImportDate,ExportDate,IsFood,ExpirDate,BasicCost,ExtraCost,TotalCost) VALUES (406,1,339510,'2019-11-16','2020-06-10',0,NULL,1817,183,2000);
INSERT INTO Pallet(Position,WarehouseID,ClientID,ImportDate,ExportDate,IsFood,ExpirDate,BasicCost,ExtraCost,TotalCost) VALUES (407,1,886693,'2018-02-20','2018-04-22',1,'2020-03-30',477,159,636);
INSERT INTO Pallet(Position,WarehouseID,ClientID,ImportDate,ExportDate,IsFood,ExpirDate,BasicCost,ExtraCost,TotalCost) VALUES (408,1,226721,'2018-06-19','2019-01-01',0,NULL,1064,62,1126);
INSERT INTO Pallet(Position,WarehouseID,ClientID,ImportDate,ExportDate,IsFood,ExpirDate,BasicCost,ExtraCost,TotalCost) VALUES (409,1,779887,'2019-03-29','2019-11-16',1,'2020-08-30',1541,61,1602);
INSERT INTO Pallet(Position,WarehouseID,ClientID,ImportDate,ExportDate,IsFood,ExpirDate,BasicCost,ExtraCost,TotalCost) VALUES (410,1,731180,'2018-03-25','2018-08-01',0,NULL,482,170,652);
INSERT INTO Pallet(Position,WarehouseID,ClientID,ImportDate,ExportDate,IsFood,ExpirDate,BasicCost,ExtraCost,TotalCost) VALUES (411,1,870564,'2018-11-14','2019-08-26',1,'2021-02-05',1922,133,2055);
INSERT INTO Pallet(Position,WarehouseID,ClientID,ImportDate,ExportDate,IsFood,ExpirDate,BasicCost,ExtraCost,TotalCost) VALUES (412,1,205573,'2019-01-24','2019-02-13',0,NULL,948,170,1118);
INSERT INTO Pallet(Position,WarehouseID,ClientID,ImportDate,ExportDate,IsFood,ExpirDate,BasicCost,ExtraCost,TotalCost) VALUES (413,1,394971,'2018-03-08','2018-06-21',0,NULL,2427,64,2491);
INSERT INTO Pallet(Position,WarehouseID,ClientID,ImportDate,ExportDate,IsFood,ExpirDate,BasicCost,ExtraCost,TotalCost) VALUES (414,1,313819,'2018-08-01','2019-05-04',0,NULL,92,38,130);
INSERT INTO Pallet(Position,WarehouseID,ClientID,ImportDate,ExportDate,IsFood,ExpirDate,BasicCost,ExtraCost,TotalCost) VALUES (415,1,268011,'2019-01-30','2019-06-15',1,'2020-08-16',71,131,202);
INSERT INTO Pallet(Position,WarehouseID,ClientID,ImportDate,ExportDate,IsFood,ExpirDate,BasicCost,ExtraCost,TotalCost) VALUES (416,1,998429,'2019-01-15','2019-10-22',1,'2019-11-20',2004,37,2041);
INSERT INTO Pallet(Position,WarehouseID,ClientID,ImportDate,ExportDate,IsFood,ExpirDate,BasicCost,ExtraCost,TotalCost) VALUES (417,1,692825,'2019-04-19','2019-12-06',0,NULL,301,121,422);
INSERT INTO Pallet(Position,WarehouseID,ClientID,ImportDate,ExportDate,IsFood,ExpirDate,BasicCost,ExtraCost,TotalCost) VALUES (418,1,177735,'2018-08-18','2018-08-27',1,'2019-12-21',2209,20,2229);
INSERT INTO Pallet(Position,WarehouseID,ClientID,ImportDate,ExportDate,IsFood,ExpirDate,BasicCost,ExtraCost,TotalCost) VALUES (419,1,205573,'2019-09-22','2020-02-29',0,NULL,1713,183,1896);
INSERT INTO Pallet(Position,WarehouseID,ClientID,ImportDate,ExportDate,IsFood,ExpirDate,BasicCost,ExtraCost,TotalCost) VALUES (420,1,881770,'2019-09-04','2019-12-29',1,'2019-06-22',2028,35,2063);
INSERT INTO Pallet(Position,WarehouseID,ClientID,ImportDate,ExportDate,IsFood,ExpirDate,BasicCost,ExtraCost,TotalCost) VALUES (421,1,827632,'2018-01-22','2018-06-11',1,'2020-04-20',1836,168,2004);
INSERT INTO Pallet(Position,WarehouseID,ClientID,ImportDate,ExportDate,IsFood,ExpirDate,BasicCost,ExtraCost,TotalCost) VALUES (422,1,850568,'2019-01-16','2019-09-14',1,'2021-03-16',967,23,990);
INSERT INTO Pallet(Position,WarehouseID,ClientID,ImportDate,ExportDate,IsFood,ExpirDate,BasicCost,ExtraCost,TotalCost) VALUES (423,1,800364,'2018-03-08','2018-09-01',0,NULL,320,41,361);
INSERT INTO Pallet(Position,WarehouseID,ClientID,ImportDate,ExportDate,IsFood,ExpirDate,BasicCost,ExtraCost,TotalCost) VALUES (424,1,585922,'2019-03-03','2019-03-28',0,NULL,1266,136,1402);
INSERT INTO Pallet(Position,WarehouseID,ClientID,ImportDate,ExportDate,IsFood,ExpirDate,BasicCost,ExtraCost,TotalCost) VALUES (425,1,413912,'2018-10-15','2019-02-06',1,'2019-07-13',465,169,634);
INSERT INTO Pallet(Position,WarehouseID,ClientID,ImportDate,ExportDate,IsFood,ExpirDate,BasicCost,ExtraCost,TotalCost) VALUES (426,1,275519,'2019-01-20','2019-02-02',0,NULL,597,64,661);
INSERT INTO Pallet(Position,WarehouseID,ClientID,ImportDate,ExportDate,IsFood,ExpirDate,BasicCost,ExtraCost,TotalCost) VALUES (427,1,430909,'2019-07-03','2019-09-08',1,'2020-09-11',2432,34,2466);
INSERT INTO Pallet(Position,WarehouseID,ClientID,ImportDate,ExportDate,IsFood,ExpirDate,BasicCost,ExtraCost,TotalCost) VALUES (428,1,317794,'2018-11-07','2019-03-28',1,'2020-01-18',1521,169,1690);
INSERT INTO Pallet(Position,WarehouseID,ClientID,ImportDate,ExportDate,IsFood,ExpirDate,BasicCost,ExtraCost,TotalCost) VALUES (429,1,739819,'2019-02-19','2019-11-22',1,'2019-08-18',2280,100,2380);
INSERT INTO Pallet(Position,WarehouseID,ClientID,ImportDate,ExportDate,IsFood,ExpirDate,BasicCost,ExtraCost,TotalCost) VALUES (430,1,177735,'2019-04-16','2019-04-28',1,'2020-08-08',2031,86,2117);
INSERT INTO Pallet(Position,WarehouseID,ClientID,ImportDate,ExportDate,IsFood,ExpirDate,BasicCost,ExtraCost,TotalCost) VALUES (431,1,161828,'2019-04-08','2020-01-23',1,'2019-11-10',2165,65,2230);
INSERT INTO Pallet(Position,WarehouseID,ClientID,ImportDate,ExportDate,IsFood,ExpirDate,BasicCost,ExtraCost,TotalCost) VALUES (432,1,143277,'2018-06-26','2018-07-26',0,NULL,106,165,271);
INSERT INTO Pallet(Position,WarehouseID,ClientID,ImportDate,ExportDate,IsFood,ExpirDate,BasicCost,ExtraCost,TotalCost) VALUES (433,1,914858,'2018-04-07','2019-01-24',0,NULL,809,186,995);
INSERT INTO Pallet(Position,WarehouseID,ClientID,ImportDate,ExportDate,IsFood,ExpirDate,BasicCost,ExtraCost,TotalCost) VALUES (434,1,949966,'2018-02-13','2018-07-27',1,'2020-10-10',430,70,500);
INSERT INTO Pallet(Position,WarehouseID,ClientID,ImportDate,ExportDate,IsFood,ExpirDate,BasicCost,ExtraCost,TotalCost) VALUES (435,1,268011,'2018-05-23','2018-10-30',0,NULL,1115,71,1186);
INSERT INTO Pallet(Position,WarehouseID,ClientID,ImportDate,ExportDate,IsFood,ExpirDate,BasicCost,ExtraCost,TotalCost) VALUES (436,1,800341,'2018-10-01','2018-11-01',1,'2019-08-01',1188,99,1287);
INSERT INTO Pallet(Position,WarehouseID,ClientID,ImportDate,ExportDate,IsFood,ExpirDate,BasicCost,ExtraCost,TotalCost) VALUES (437,1,751584,'2018-08-30','2018-10-17',1,'2019-07-25',2143,97,2240);
INSERT INTO Pallet(Position,WarehouseID,ClientID,ImportDate,ExportDate,IsFood,ExpirDate,BasicCost,ExtraCost,TotalCost) VALUES (438,1,108641,'2018-02-17','2018-06-12',1,'2020-07-14',1972,147,2119);
INSERT INTO Pallet(Position,WarehouseID,ClientID,ImportDate,ExportDate,IsFood,ExpirDate,BasicCost,ExtraCost,TotalCost) VALUES (439,1,521995,'2019-07-17','2020-02-27',1,'2020-11-21',1127,116,1243);
INSERT INTO Pallet(Position,WarehouseID,ClientID,ImportDate,ExportDate,IsFood,ExpirDate,BasicCost,ExtraCost,TotalCost) VALUES (440,1,179644,'2019-06-11','2019-11-18',0,NULL,1892,116,2008);
INSERT INTO Pallet(Position,WarehouseID,ClientID,ImportDate,ExportDate,IsFood,ExpirDate,BasicCost,ExtraCost,TotalCost) VALUES (501,1,746901,'2019-05-01','2019-12-14',0,NULL,1928,121,2049);
INSERT INTO Pallet(Position,WarehouseID,ClientID,ImportDate,ExportDate,IsFood,ExpirDate,BasicCost,ExtraCost,TotalCost) VALUES (502,1,247799,'2018-08-13','2019-04-14',0,NULL,297,38,335);
INSERT INTO Pallet(Position,WarehouseID,ClientID,ImportDate,ExportDate,IsFood,ExpirDate,BasicCost,ExtraCost,TotalCost) VALUES (503,1,270422,'2019-06-16','2019-09-19',1,'2020-08-05',907,102,1009);
INSERT INTO Pallet(Position,WarehouseID,ClientID,ImportDate,ExportDate,IsFood,ExpirDate,BasicCost,ExtraCost,TotalCost) VALUES (504,1,611779,'2019-06-30','2019-08-10',0,NULL,1288,21,1309);
INSERT INTO Pallet(Position,WarehouseID,ClientID,ImportDate,ExportDate,IsFood,ExpirDate,BasicCost,ExtraCost,TotalCost) VALUES (505,1,492399,'2018-05-22','2018-06-10',0,NULL,447,131,578);
INSERT INTO Pallet(Position,WarehouseID,ClientID,ImportDate,ExportDate,IsFood,ExpirDate,BasicCost,ExtraCost,TotalCost) VALUES (506,1,133893,'2018-01-12','2018-10-14',1,'2020-12-16',1053,130,1183);
INSERT INTO Pallet(Position,WarehouseID,ClientID,ImportDate,ExportDate,IsFood,ExpirDate,BasicCost,ExtraCost,TotalCost) VALUES (507,1,762358,'2019-07-31','2019-11-21',1,'2020-06-18',2042,132,2174);
INSERT INTO Pallet(Position,WarehouseID,ClientID,ImportDate,ExportDate,IsFood,ExpirDate,BasicCost,ExtraCost,TotalCost) VALUES (508,1,348271,'2019-06-29','2020-02-11',1,'2020-12-29',1872,166,2038);
INSERT INTO Pallet(Position,WarehouseID,ClientID,ImportDate,ExportDate,IsFood,ExpirDate,BasicCost,ExtraCost,TotalCost) VALUES (509,1,413912,'2019-07-25','2020-02-15',1,'2020-09-08',1969,108,2077);
INSERT INTO Pallet(Position,WarehouseID,ClientID,ImportDate,ExportDate,IsFood,ExpirDate,BasicCost,ExtraCost,TotalCost) VALUES (510,1,130541,'2019-11-15','2020-08-21',0,NULL,674,107,781);
INSERT INTO Pallet(Position,WarehouseID,ClientID,ImportDate,ExportDate,IsFood,ExpirDate,BasicCost,ExtraCost,TotalCost) VALUES (511,1,653972,'2018-09-06','2019-02-04',0,NULL,772,194,966);
INSERT INTO Pallet(Position,WarehouseID,ClientID,ImportDate,ExportDate,IsFood,ExpirDate,BasicCost,ExtraCost,TotalCost) VALUES (512,1,349474,'2019-11-05','2019-11-24',1,'2021-02-15',1618,137,1755);
INSERT INTO Pallet(Position,WarehouseID,ClientID,ImportDate,ExportDate,IsFood,ExpirDate,BasicCost,ExtraCost,TotalCost) VALUES (513,1,762358,'2018-02-12','2018-07-30',1,'2019-09-27',1440,121,1561);
INSERT INTO Pallet(Position,WarehouseID,ClientID,ImportDate,ExportDate,IsFood,ExpirDate,BasicCost,ExtraCost,TotalCost) VALUES (514,1,795904,'2018-12-15','2019-05-04',0,NULL,1686,47,1733);
INSERT INTO Pallet(Position,WarehouseID,ClientID,ImportDate,ExportDate,IsFood,ExpirDate,BasicCost,ExtraCost,TotalCost) VALUES (515,1,881770,'2018-11-05','2019-06-02',1,'2019-09-30',85,79,164);
INSERT INTO Pallet(Position,WarehouseID,ClientID,ImportDate,ExportDate,IsFood,ExpirDate,BasicCost,ExtraCost,TotalCost) VALUES (516,1,942887,'2019-07-28','2020-02-07',1,'2021-01-19',1121,23,1144);
INSERT INTO Pallet(Position,WarehouseID,ClientID,ImportDate,ExportDate,IsFood,ExpirDate,BasicCost,ExtraCost,TotalCost) VALUES (517,1,257512,'2019-09-09','2019-11-26',1,'2019-08-12',1477,65,1542);
INSERT INTO Pallet(Position,WarehouseID,ClientID,ImportDate,ExportDate,IsFood,ExpirDate,BasicCost,ExtraCost,TotalCost) VALUES (518,1,877784,'2018-06-26','2019-04-12',0,NULL,1027,25,1052);
INSERT INTO Pallet(Position,WarehouseID,ClientID,ImportDate,ExportDate,IsFood,ExpirDate,BasicCost,ExtraCost,TotalCost) VALUES (519,1,467435,'2019-02-12','2019-07-25',1,'2020-06-23',2381,53,2434);
INSERT INTO Pallet(Position,WarehouseID,ClientID,ImportDate,ExportDate,IsFood,ExpirDate,BasicCost,ExtraCost,TotalCost) VALUES (520,1,800364,'2018-04-29','2018-08-26',0,NULL,524,29,553);
INSERT INTO Pallet(Position,WarehouseID,ClientID,ImportDate,ExportDate,IsFood,ExpirDate,BasicCost,ExtraCost,TotalCost) VALUES (521,1,141353,'2019-06-04','2019-07-01',1,'2019-10-20',294,97,391);
INSERT INTO Pallet(Position,WarehouseID,ClientID,ImportDate,ExportDate,IsFood,ExpirDate,BasicCost,ExtraCost,TotalCost) VALUES (522,1,519138,'2019-03-07','2019-09-19',1,'2020-05-17',1903,142,2045);
INSERT INTO Pallet(Position,WarehouseID,ClientID,ImportDate,ExportDate,IsFood,ExpirDate,BasicCost,ExtraCost,TotalCost) VALUES (523,1,181571,'2019-07-03','2020-02-23',1,'2021-02-09',798,164,962);
INSERT INTO Pallet(Position,WarehouseID,ClientID,ImportDate,ExportDate,IsFood,ExpirDate,BasicCost,ExtraCost,TotalCost) VALUES (524,1,795904,'2018-07-01','2019-03-14',1,'2021-02-24',1264,68,1332);
INSERT INTO Pallet(Position,WarehouseID,ClientID,ImportDate,ExportDate,IsFood,ExpirDate,BasicCost,ExtraCost,TotalCost) VALUES (525,1,452007,'2019-11-02','2020-03-10',1,'2020-09-10',1750,191,1941);
INSERT INTO Pallet(Position,WarehouseID,ClientID,ImportDate,ExportDate,IsFood,ExpirDate,BasicCost,ExtraCost,TotalCost) VALUES (526,1,114641,'2019-01-07','2019-02-27',1,'2019-08-19',998,94,1092);
INSERT INTO Pallet(Position,WarehouseID,ClientID,ImportDate,ExportDate,IsFood,ExpirDate,BasicCost,ExtraCost,TotalCost) VALUES (527,1,793670,'2018-03-27','2019-01-19',0,NULL,1763,101,1864);
INSERT INTO Pallet(Position,WarehouseID,ClientID,ImportDate,ExportDate,IsFood,ExpirDate,BasicCost,ExtraCost,TotalCost) VALUES (528,1,257512,'2018-11-29','2018-12-08',0,NULL,988,50,1038);
INSERT INTO Pallet(Position,WarehouseID,ClientID,ImportDate,ExportDate,IsFood,ExpirDate,BasicCost,ExtraCost,TotalCost) VALUES (529,1,230561,'2018-06-12','2019-02-21',1,'2020-02-22',592,72,664);
INSERT INTO Pallet(Position,WarehouseID,ClientID,ImportDate,ExportDate,IsFood,ExpirDate,BasicCost,ExtraCost,TotalCost) VALUES (530,1,800364,'2019-11-22','2020-07-29',1,'2019-08-31',1298,132,1430);
INSERT INTO Pallet(Position,WarehouseID,ClientID,ImportDate,ExportDate,IsFood,ExpirDate,BasicCost,ExtraCost,TotalCost) VALUES (531,1,578882,'2019-11-09','2020-03-15',0,NULL,1863,101,1964);
INSERT INTO Pallet(Position,WarehouseID,ClientID,ImportDate,ExportDate,IsFood,ExpirDate,BasicCost,ExtraCost,TotalCost) VALUES (532,1,633765,'2018-11-09','2018-12-31',1,'2020-03-26',1927,42,1969);
INSERT INTO Pallet(Position,WarehouseID,ClientID,ImportDate,ExportDate,IsFood,ExpirDate,BasicCost,ExtraCost,TotalCost) VALUES (533,1,270422,'2019-09-02','2020-06-27',0,NULL,624,136,760);
INSERT INTO Pallet(Position,WarehouseID,ClientID,ImportDate,ExportDate,IsFood,ExpirDate,BasicCost,ExtraCost,TotalCost) VALUES (534,1,885539,'2019-02-23','2019-12-13',1,'2020-05-03',1276,172,1448);
INSERT INTO Pallet(Position,WarehouseID,ClientID,ImportDate,ExportDate,IsFood,ExpirDate,BasicCost,ExtraCost,TotalCost) VALUES (535,1,205573,'2018-08-27','2019-05-15',1,'2019-06-07',722,157,879);
INSERT INTO Pallet(Position,WarehouseID,ClientID,ImportDate,ExportDate,IsFood,ExpirDate,BasicCost,ExtraCost,TotalCost) VALUES (536,1,467435,'2019-01-30','2019-06-02',0,NULL,1495,72,1567);
INSERT INTO Pallet(Position,WarehouseID,ClientID,ImportDate,ExportDate,IsFood,ExpirDate,BasicCost,ExtraCost,TotalCost) VALUES (537,1,800364,'2018-11-11','2019-02-02',0,NULL,1633,95,1728);
INSERT INTO Pallet(Position,WarehouseID,ClientID,ImportDate,ExportDate,IsFood,ExpirDate,BasicCost,ExtraCost,TotalCost) VALUES (538,1,132401,'2018-06-21','2018-11-06',1,'2020-06-25',746,81,827);
INSERT INTO Pallet(Position,WarehouseID,ClientID,ImportDate,ExportDate,IsFood,ExpirDate,BasicCost,ExtraCost,TotalCost) VALUES (539,1,852542,'2019-07-05','2019-08-19',1,'2019-12-30',2123,23,2146);
INSERT INTO Pallet(Position,WarehouseID,ClientID,ImportDate,ExportDate,IsFood,ExpirDate,BasicCost,ExtraCost,TotalCost) VALUES (540,1,143277,'2019-06-02','2020-01-01',1,'2021-01-30',725,85,810);
INSERT INTO Pallet(Position,WarehouseID,ClientID,ImportDate,ExportDate,IsFood,ExpirDate,BasicCost,ExtraCost,TotalCost) VALUES (601,1,492399,'2018-07-24','2019-02-21',0,NULL,847,78,925);
INSERT INTO Pallet(Position,WarehouseID,ClientID,ImportDate,ExportDate,IsFood,ExpirDate,BasicCost,ExtraCost,TotalCost) VALUES (602,1,430879,'2019-06-17','2019-12-25',1,'2020-05-08',2421,185,2606);
INSERT INTO Pallet(Position,WarehouseID,ClientID,ImportDate,ExportDate,IsFood,ExpirDate,BasicCost,ExtraCost,TotalCost) VALUES (603,1,862575,'2019-09-04','2020-05-01',1,'2019-10-15',1818,92,1910);
INSERT INTO Pallet(Position,WarehouseID,ClientID,ImportDate,ExportDate,IsFood,ExpirDate,BasicCost,ExtraCost,TotalCost) VALUES (604,1,382414,'2019-03-02','2019-05-14',1,'2021-01-22',1129,133,1262);
INSERT INTO Pallet(Position,WarehouseID,ClientID,ImportDate,ExportDate,IsFood,ExpirDate,BasicCost,ExtraCost,TotalCost) VALUES (605,1,901269,'2019-03-13','2019-11-23',1,'2020-05-26',302,162,464);
INSERT INTO Pallet(Position,WarehouseID,ClientID,ImportDate,ExportDate,IsFood,ExpirDate,BasicCost,ExtraCost,TotalCost) VALUES (606,1,179644,'2019-10-04','2020-02-27',1,'2020-11-17',376,172,548);
INSERT INTO Pallet(Position,WarehouseID,ClientID,ImportDate,ExportDate,IsFood,ExpirDate,BasicCost,ExtraCost,TotalCost) VALUES (607,1,349474,'2019-04-29','2019-06-16',1,'2020-04-27',800,33,833);
INSERT INTO Pallet(Position,WarehouseID,ClientID,ImportDate,ExportDate,IsFood,ExpirDate,BasicCost,ExtraCost,TotalCost) VALUES (608,1,117299,'2018-04-07','2018-05-14',1,'2021-01-15',2189,131,2320);
INSERT INTO Pallet(Position,WarehouseID,ClientID,ImportDate,ExportDate,IsFood,ExpirDate,BasicCost,ExtraCost,TotalCost) VALUES (609,1,810593,'2019-11-17','2020-05-01',1,'2020-11-30',1769,38,1807);
INSERT INTO Pallet(Position,WarehouseID,ClientID,ImportDate,ExportDate,IsFood,ExpirDate,BasicCost,ExtraCost,TotalCost) VALUES (610,1,467435,'2018-03-05','2018-07-17',0,NULL,222,168,390);
INSERT INTO Pallet(Position,WarehouseID,ClientID,ImportDate,ExportDate,IsFood,ExpirDate,BasicCost,ExtraCost,TotalCost) VALUES (611,1,885539,'2018-10-28','2019-07-21',1,'2020-05-22',418,157,575);
INSERT INTO Pallet(Position,WarehouseID,ClientID,ImportDate,ExportDate,IsFood,ExpirDate,BasicCost,ExtraCost,TotalCost) VALUES (612,1,751584,'2018-08-17','2018-12-30',0,NULL,105,45,150);
INSERT INTO Pallet(Position,WarehouseID,ClientID,ImportDate,ExportDate,IsFood,ExpirDate,BasicCost,ExtraCost,TotalCost) VALUES (613,1,199689,'2019-07-01','2019-07-31',1,'2021-01-02',506,90,596);
INSERT INTO Pallet(Position,WarehouseID,ClientID,ImportDate,ExportDate,IsFood,ExpirDate,BasicCost,ExtraCost,TotalCost) VALUES (614,1,850568,'2019-10-09','2020-08-03',1,'2020-08-14',2265,97,2362);
INSERT INTO Pallet(Position,WarehouseID,ClientID,ImportDate,ExportDate,IsFood,ExpirDate,BasicCost,ExtraCost,TotalCost) VALUES (615,1,194552,'2018-08-11','2018-09-25',1,'2019-06-03',2249,119,2368);
INSERT INTO Pallet(Position,WarehouseID,ClientID,ImportDate,ExportDate,IsFood,ExpirDate,BasicCost,ExtraCost,TotalCost) VALUES (616,1,108641,'2018-12-29','2019-05-24',1,'2019-10-24',2383,150,2533);
INSERT INTO Pallet(Position,WarehouseID,ClientID,ImportDate,ExportDate,IsFood,ExpirDate,BasicCost,ExtraCost,TotalCost) VALUES (617,1,851500,'2018-06-05','2018-10-17',0,NULL,300,53,353);
INSERT INTO Pallet(Position,WarehouseID,ClientID,ImportDate,ExportDate,IsFood,ExpirDate,BasicCost,ExtraCost,TotalCost) VALUES (618,1,633221,'2019-04-21','2019-05-15',0,NULL,444,89,533);
INSERT INTO Pallet(Position,WarehouseID,ClientID,ImportDate,ExportDate,IsFood,ExpirDate,BasicCost,ExtraCost,TotalCost) VALUES (619,1,842573,'2018-05-20','2018-09-24',1,'2021-02-06',1956,22,1978);
INSERT INTO Pallet(Position,WarehouseID,ClientID,ImportDate,ExportDate,IsFood,ExpirDate,BasicCost,ExtraCost,TotalCost) VALUES (620,1,881770,'2019-05-18','2019-10-22',0,NULL,2436,84,2520);
INSERT INTO Pallet(Position,WarehouseID,ClientID,ImportDate,ExportDate,IsFood,ExpirDate,BasicCost,ExtraCost,TotalCost) VALUES (621,1,452007,'2019-10-03','2019-11-29',1,'2020-03-13',79,122,201);
INSERT INTO Pallet(Position,WarehouseID,ClientID,ImportDate,ExportDate,IsFood,ExpirDate,BasicCost,ExtraCost,TotalCost) VALUES (622,1,623670,'2018-02-20','2018-03-10',0,NULL,904,160,1064);
INSERT INTO Pallet(Position,WarehouseID,ClientID,ImportDate,ExportDate,IsFood,ExpirDate,BasicCost,ExtraCost,TotalCost) VALUES (623,1,818519,'2018-04-30','2018-08-04',0,NULL,2218,197,2415);
INSERT INTO Pallet(Position,WarehouseID,ClientID,ImportDate,ExportDate,IsFood,ExpirDate,BasicCost,ExtraCost,TotalCost) VALUES (624,1,603494,'2018-07-09','2019-04-24',0,NULL,1830,128,1958);
INSERT INTO Pallet(Position,WarehouseID,ClientID,ImportDate,ExportDate,IsFood,ExpirDate,BasicCost,ExtraCost,TotalCost) VALUES (625,1,747654,'2019-06-26','2020-01-21',1,'2020-12-09',1850,179,2029);
INSERT INTO Pallet(Position,WarehouseID,ClientID,ImportDate,ExportDate,IsFood,ExpirDate,BasicCost,ExtraCost,TotalCost) VALUES (626,1,122707,'2018-10-12','2019-01-06',1,'2019-09-21',815,64,879);
INSERT INTO Pallet(Position,WarehouseID,ClientID,ImportDate,ExportDate,IsFood,ExpirDate,BasicCost,ExtraCost,TotalCost) VALUES (627,1,452007,'2018-05-09','2018-09-12',0,NULL,1108,39,1147);
INSERT INTO Pallet(Position,WarehouseID,ClientID,ImportDate,ExportDate,IsFood,ExpirDate,BasicCost,ExtraCost,TotalCost) VALUES (628,1,747952,'2019-03-23','2019-04-11',0,NULL,1894,93,1987);
INSERT INTO Pallet(Position,WarehouseID,ClientID,ImportDate,ExportDate,IsFood,ExpirDate,BasicCost,ExtraCost,TotalCost) VALUES (629,1,778351,'2018-03-26','2018-10-09',1,'2020-04-23',532,123,655);
INSERT INTO Pallet(Position,WarehouseID,ClientID,ImportDate,ExportDate,IsFood,ExpirDate,BasicCost,ExtraCost,TotalCost) VALUES (630,1,423278,'2018-11-20','2019-09-08',0,NULL,1609,198,1807);
INSERT INTO Pallet(Position,WarehouseID,ClientID,ImportDate,ExportDate,IsFood,ExpirDate,BasicCost,ExtraCost,TotalCost) VALUES (631,1,879220,'2018-01-29','2018-08-18',0,NULL,1396,170,1566);
INSERT INTO Pallet(Position,WarehouseID,ClientID,ImportDate,ExportDate,IsFood,ExpirDate,BasicCost,ExtraCost,TotalCost) VALUES (632,1,299036,'2019-10-09','2020-07-15',1,'2019-11-01',2243,148,2391);
INSERT INTO Pallet(Position,WarehouseID,ClientID,ImportDate,ExportDate,IsFood,ExpirDate,BasicCost,ExtraCost,TotalCost) VALUES (633,1,640896,'2018-09-16','2019-05-09',0,NULL,1231,23,1254);
INSERT INTO Pallet(Position,WarehouseID,ClientID,ImportDate,ExportDate,IsFood,ExpirDate,BasicCost,ExtraCost,TotalCost) VALUES (634,1,536798,'2019-09-19','2019-12-10',0,NULL,1806,160,1966);
INSERT INTO Pallet(Position,WarehouseID,ClientID,ImportDate,ExportDate,IsFood,ExpirDate,BasicCost,ExtraCost,TotalCost) VALUES (635,1,313819,'2018-08-06','2019-05-29',1,'2020-08-12',1952,125,2077);
INSERT INTO Pallet(Position,WarehouseID,ClientID,ImportDate,ExportDate,IsFood,ExpirDate,BasicCost,ExtraCost,TotalCost) VALUES (636,1,764533,'2018-11-18','2019-04-21',0,NULL,1609,73,1682);
INSERT INTO Pallet(Position,WarehouseID,ClientID,ImportDate,ExportDate,IsFood,ExpirDate,BasicCost,ExtraCost,TotalCost) VALUES (637,1,768853,'2019-07-14','2020-02-19',0,NULL,2264,122,2386);
INSERT INTO Pallet(Position,WarehouseID,ClientID,ImportDate,ExportDate,IsFood,ExpirDate,BasicCost,ExtraCost,TotalCost) VALUES (638,1,250221,'2018-05-22','2018-08-14',0,NULL,2399,73,2472);
INSERT INTO Pallet(Position,WarehouseID,ClientID,ImportDate,ExportDate,IsFood,ExpirDate,BasicCost,ExtraCost,TotalCost) VALUES (639,1,467435,'2019-09-29','2019-12-12',1,'2019-07-05',1950,116,2066);
INSERT INTO Pallet(Position,WarehouseID,ClientID,ImportDate,ExportDate,IsFood,ExpirDate,BasicCost,ExtraCost,TotalCost) VALUES (640,1,903363,'2019-02-03','2019-05-21',1,'2020-02-11',1495,99,1594);





----------------------------------------------------------------------------------------

INSERT INTO dbo.Transactions(TransDate,Price,ClientID) VALUES ('2019-04-07',498,800341);
INSERT INTO dbo.Transactions(TransDate,Price,ClientID) VALUES ('2019-07-06',323,268011);
INSERT INTO dbo.Transactions(TransDate,Price,ClientID) VALUES ('2018-12-23',271,962498);
INSERT INTO dbo.Transactions(TransDate,Price,ClientID) VALUES ('2019-03-26',414,430909);
INSERT INTO dbo.Transactions(TransDate,Price,ClientID) VALUES ('2019-08-25',577,259543);
INSERT INTO dbo.Transactions(TransDate,Price,ClientID) VALUES ('2019-08-09',560,765764);
INSERT INTO dbo.Transactions(TransDate,Price,ClientID) VALUES ('2018-12-30',716,733283);
INSERT INTO dbo.Transactions(TransDate,Price,ClientID) VALUES ('2019-01-22',793,339510);
INSERT INTO dbo.Transactions(TransDate,Price,ClientID) VALUES ('2018-12-17',317,492399);
INSERT INTO dbo.Transactions(TransDate,Price,ClientID) VALUES ('2018-12-21',522,456429);
INSERT INTO dbo.Transactions(TransDate,Price,ClientID) VALUES ('2019-01-24',486,291141);
INSERT INTO dbo.Transactions(TransDate,Price,ClientID) VALUES ('2019-08-02',190,611779);
INSERT INTO dbo.Transactions(TransDate,Price,ClientID) VALUES ('2019-10-08',379,553698);
INSERT INTO dbo.Transactions(TransDate,Price,ClientID) VALUES ('2019-08-16',949,313819);
INSERT INTO dbo.Transactions(TransDate,Price,ClientID) VALUES ('2018-12-15',641,535723);
INSERT INTO dbo.Transactions(TransDate,Price,ClientID) VALUES ('2019-10-30',854,903363);
INSERT INTO dbo.Transactions(TransDate,Price,ClientID) VALUES ('2018-12-22',842,506808);
INSERT INTO dbo.Transactions(TransDate,Price,ClientID) VALUES ('2019-05-22',323,267604);
INSERT INTO dbo.Transactions(TransDate,Price,ClientID) VALUES ('2019-09-03',332,343720);
INSERT INTO dbo.Transactions(TransDate,Price,ClientID) VALUES ('2019-04-05',986,699753);
INSERT INTO dbo.Transactions(TransDate,Price,ClientID) VALUES ('2019-08-19',905,930089);
INSERT INTO dbo.Transactions(TransDate,Price,ClientID) VALUES ('2019-10-04',532,547385);
INSERT INTO dbo.Transactions(TransDate,Price,ClientID) VALUES ('2019-07-29',317,664922);
INSERT INTO dbo.Transactions(TransDate,Price,ClientID) VALUES ('2019-02-15',795,595251);
INSERT INTO dbo.Transactions(TransDate,Price,ClientID) VALUES ('2019-07-05',52,126639);
INSERT INTO dbo.Transactions(TransDate,Price,ClientID) VALUES ('2019-04-04',265,660900);
INSERT INTO dbo.Transactions(TransDate,Price,ClientID) VALUES ('2019-02-11',628,177735);
INSERT INTO dbo.Transactions(TransDate,Price,ClientID) VALUES ('2018-11-23',441,793670);
INSERT INTO dbo.Transactions(TransDate,Price,ClientID) VALUES ('2019-09-29',446,810593);
INSERT INTO dbo.Transactions(TransDate,Price,ClientID) VALUES ('2019-05-22',114,348271);
INSERT INTO dbo.Transactions(TransDate,Price,ClientID) VALUES ('2019-01-20',73,557496);
INSERT INTO dbo.Transactions(TransDate,Price,ClientID) VALUES ('2019-11-02',568,285130);
INSERT INTO dbo.Transactions(TransDate,Price,ClientID) VALUES ('2019-02-09',988,879220);
INSERT INTO dbo.Transactions(TransDate,Price,ClientID) VALUES ('2018-12-18',468,317794);
INSERT INTO dbo.Transactions(TransDate,Price,ClientID) VALUES ('2018-11-24',178,800364);
INSERT INTO dbo.Transactions(TransDate,Price,ClientID) VALUES ('2019-10-07',824,487506);
INSERT INTO dbo.Transactions(TransDate,Price,ClientID) VALUES ('2019-02-15',157,692825);
INSERT INTO dbo.Transactions(TransDate,Price,ClientID) VALUES ('2019-08-05',807,803505);
INSERT INTO dbo.Transactions(TransDate,Price,ClientID) VALUES ('2019-05-29',665,916936);
INSERT INTO dbo.Transactions(TransDate,Price,ClientID) VALUES ('2019-04-20',735,994385);
INSERT INTO dbo.Transactions(TransDate,Price,ClientID) VALUES ('2019-07-24',307,250221);
INSERT INTO dbo.Transactions(TransDate,Price,ClientID) VALUES ('2019-09-01',209,514942);
INSERT INTO dbo.Transactions(TransDate,Price,ClientID) VALUES ('2019-10-13',688,123022);
INSERT INTO dbo.Transactions(TransDate,Price,ClientID) VALUES ('2018-12-18',112,984783);
INSERT INTO dbo.Transactions(TransDate,Price,ClientID) VALUES ('2019-05-19',836,850568);
INSERT INTO dbo.Transactions(TransDate,Price,ClientID) VALUES ('2019-07-28',304,114641);
INSERT INTO dbo.Transactions(TransDate,Price,ClientID) VALUES ('2019-04-19',406,853461);
INSERT INTO dbo.Transactions(TransDate,Price,ClientID) VALUES ('2018-12-18',537,205573);
INSERT INTO dbo.Transactions(TransDate,Price,ClientID) VALUES ('2019-10-31',189,470355);
INSERT INTO dbo.Transactions(TransDate,Price,ClientID) VALUES ('2019-08-05',644,800341);
INSERT INTO dbo.Transactions(TransDate,Price,ClientID) VALUES ('2019-04-11',674,268011);
INSERT INTO dbo.Transactions(TransDate,Price,ClientID) VALUES ('2019-04-07',760,962498);
INSERT INTO dbo.Transactions(TransDate,Price,ClientID) VALUES ('2019-05-05',252,430909);
INSERT INTO dbo.Transactions(TransDate,Price,ClientID) VALUES ('2019-06-16',120,259543);
INSERT INTO dbo.Transactions(TransDate,Price,ClientID) VALUES ('2019-07-02',279,765764);
INSERT INTO dbo.Transactions(TransDate,Price,ClientID) VALUES ('2019-02-28',937,733283);
INSERT INTO dbo.Transactions(TransDate,Price,ClientID) VALUES ('2019-08-20',880,339510);
INSERT INTO dbo.Transactions(TransDate,Price,ClientID) VALUES ('2019-03-02',367,492399);
INSERT INTO dbo.Transactions(TransDate,Price,ClientID) VALUES ('2019-02-10',752,456429);
INSERT INTO dbo.Transactions(TransDate,Price,ClientID) VALUES ('2019-08-31',589,291141);
INSERT INTO dbo.Transactions(TransDate,Price,ClientID) VALUES ('2019-11-20',262,611779);
INSERT INTO dbo.Transactions(TransDate,Price,ClientID) VALUES ('2018-12-24',897,553698);
INSERT INTO dbo.Transactions(TransDate,Price,ClientID) VALUES ('2019-08-03',529,313819);
INSERT INTO dbo.Transactions(TransDate,Price,ClientID) VALUES ('2019-09-13',322,535723);
INSERT INTO dbo.Transactions(TransDate,Price,ClientID) VALUES ('2019-05-12',685,903363);
INSERT INTO dbo.Transactions(TransDate,Price,ClientID) VALUES ('2019-10-09',833,506808);
INSERT INTO dbo.Transactions(TransDate,Price,ClientID) VALUES ('2019-03-22',509,267604);
INSERT INTO dbo.Transactions(TransDate,Price,ClientID) VALUES ('2019-02-14',893,343720);
INSERT INTO dbo.Transactions(TransDate,Price,ClientID) VALUES ('2019-02-07',359,699753);
INSERT INTO dbo.Transactions(TransDate,Price,ClientID) VALUES ('2018-11-29',755,930089);
INSERT INTO dbo.Transactions(TransDate,Price,ClientID) VALUES ('2019-09-26',729,547385);
INSERT INTO dbo.Transactions(TransDate,Price,ClientID) VALUES ('2019-08-04',759,664922);
INSERT INTO dbo.Transactions(TransDate,Price,ClientID) VALUES ('2019-09-25',967,595251);
INSERT INTO dbo.Transactions(TransDate,Price,ClientID) VALUES ('2019-04-30',281,126639);
INSERT INTO dbo.Transactions(TransDate,Price,ClientID) VALUES ('2019-11-10',335,660900);
INSERT INTO dbo.Transactions(TransDate,Price,ClientID) VALUES ('2019-04-05',537,177735);
INSERT INTO dbo.Transactions(TransDate,Price,ClientID) VALUES ('2019-02-22',329,793670);
INSERT INTO dbo.Transactions(TransDate,Price,ClientID) VALUES ('2019-06-26',811,810593);
INSERT INTO dbo.Transactions(TransDate,Price,ClientID) VALUES ('2019-01-28',519,348271);
INSERT INTO dbo.Transactions(TransDate,Price,ClientID) VALUES ('2018-12-27',173,557496);
INSERT INTO dbo.Transactions(TransDate,Price,ClientID) VALUES ('2019-06-10',729,285130);
INSERT INTO dbo.Transactions(TransDate,Price,ClientID) VALUES ('2019-01-11',148,879220);
INSERT INTO dbo.Transactions(TransDate,Price,ClientID) VALUES ('2019-03-07',706,317794);
INSERT INTO dbo.Transactions(TransDate,Price,ClientID) VALUES ('2019-08-15',464,800364);
INSERT INTO dbo.Transactions(TransDate,Price,ClientID) VALUES ('2019-11-01',974,487506);
INSERT INTO dbo.Transactions(TransDate,Price,ClientID) VALUES ('2019-01-02',591,692825);
INSERT INTO dbo.Transactions(TransDate,Price,ClientID) VALUES ('2019-07-27',601,803505);
INSERT INTO dbo.Transactions(TransDate,Price,ClientID) VALUES ('2019-09-22',676,916936);
INSERT INTO dbo.Transactions(TransDate,Price,ClientID) VALUES ('2019-07-29',414,994385);
INSERT INTO dbo.Transactions(TransDate,Price,ClientID) VALUES ('2019-07-29',551,250221);
INSERT INTO dbo.Transactions(TransDate,Price,ClientID) VALUES ('2019-07-22',309,514942);
INSERT INTO dbo.Transactions(TransDate,Price,ClientID) VALUES ('2019-11-14',507,123022);
INSERT INTO dbo.Transactions(TransDate,Price,ClientID) VALUES ('2019-09-11',909,984783);
INSERT INTO dbo.Transactions(TransDate,Price,ClientID) VALUES ('2019-10-01',206,850568);
INSERT INTO dbo.Transactions(TransDate,Price,ClientID) VALUES ('2019-05-18',510,114641);
INSERT INTO dbo.Transactions(TransDate,Price,ClientID) VALUES ('2019-11-12',92,853461);
INSERT INTO dbo.Transactions(TransDate,Price,ClientID) VALUES ('2019-07-21',656,205573);
INSERT INTO dbo.Transactions(TransDate,Price,ClientID) VALUES ('2018-12-02',492,470355);
INSERT INTO dbo.Transactions(TransDate,Price,ClientID) VALUES ('2019-10-03',253,106830);
INSERT INTO dbo.Transactions(TransDate,Price,ClientID) VALUES ('2019-01-10',468,795904);
INSERT INTO dbo.Transactions(TransDate,Price,ClientID) VALUES ('2019-01-03',572,747952);
INSERT INTO dbo.Transactions(TransDate,Price,ClientID) VALUES ('2018-11-29',167,813346);
INSERT INTO dbo.Transactions(TransDate,Price,ClientID) VALUES ('2019-06-06',189,463857);
INSERT INTO dbo.Transactions(TransDate,Price,ClientID) VALUES ('2019-03-07',231,382414);
INSERT INTO dbo.Transactions(TransDate,Price,ClientID) VALUES ('2018-12-28',811,371868);
INSERT INTO dbo.Transactions(TransDate,Price,ClientID) VALUES ('2019-01-08',857,885804);
INSERT INTO dbo.Transactions(TransDate,Price,ClientID) VALUES ('2019-09-07',885,763136);
INSERT INTO dbo.Transactions(TransDate,Price,ClientID) VALUES ('2019-09-21',529,521995);
INSERT INTO dbo.Transactions(TransDate,Price,ClientID) VALUES ('2019-08-15',407,942887);
INSERT INTO dbo.Transactions(TransDate,Price,ClientID) VALUES ('2019-02-14',409,585922);
INSERT INTO dbo.Transactions(TransDate,Price,ClientID) VALUES ('2019-03-28',892,470973);
INSERT INTO dbo.Transactions(TransDate,Price,ClientID) VALUES ('2019-07-08',838,593630);
INSERT INTO dbo.Transactions(TransDate,Price,ClientID) VALUES ('2019-10-29',338,578882);
INSERT INTO dbo.Transactions(TransDate,Price,ClientID) VALUES ('2019-05-11',803,899310);
INSERT INTO dbo.Transactions(TransDate,Price,ClientID) VALUES ('2019-08-27',837,159342);
INSERT INTO dbo.Transactions(TransDate,Price,ClientID) VALUES ('2018-12-24',531,988447);
INSERT INTO dbo.Transactions(TransDate,Price,ClientID) VALUES ('2019-10-27',935,768853);
INSERT INTO dbo.Transactions(TransDate,Price,ClientID) VALUES ('2019-11-02',893,603494);
INSERT INTO dbo.Transactions(TransDate,Price,ClientID) VALUES ('2019-08-22',376,479717);
INSERT INTO dbo.Transactions(TransDate,Price,ClientID) VALUES ('2019-08-22',109,144241);
INSERT INTO dbo.Transactions(TransDate,Price,ClientID) VALUES ('2019-10-10',841,881770);
INSERT INTO dbo.Transactions(TransDate,Price,ClientID) VALUES ('2019-04-12',842,108641);
INSERT INTO dbo.Transactions(TransDate,Price,ClientID) VALUES ('2018-11-25',896,351282);
INSERT INTO dbo.Transactions(TransDate,Price,ClientID) VALUES ('2019-07-24',107,230561);
INSERT INTO dbo.Transactions(TransDate,Price,ClientID) VALUES ('2018-12-09',987,901269);
INSERT INTO dbo.Transactions(TransDate,Price,ClientID) VALUES ('2019-04-17',470,970764);
INSERT INTO dbo.Transactions(TransDate,Price,ClientID) VALUES ('2019-05-04',784,731180);
INSERT INTO dbo.Transactions(TransDate,Price,ClientID) VALUES ('2019-03-09',605,117028);
INSERT INTO dbo.Transactions(TransDate,Price,ClientID) VALUES ('2019-05-15',469,770532);
INSERT INTO dbo.Transactions(TransDate,Price,ClientID) VALUES ('2019-03-14',894,352517);
INSERT INTO dbo.Transactions(TransDate,Price,ClientID) VALUES ('2019-05-06',309,739819);
INSERT INTO dbo.Transactions(TransDate,Price,ClientID) VALUES ('2019-04-12',86,519138);
INSERT INTO dbo.Transactions(TransDate,Price,ClientID) VALUES ('2019-06-03',359,998429);
INSERT INTO dbo.Transactions(TransDate,Price,ClientID) VALUES ('2019-05-20',568,827632);
INSERT INTO dbo.Transactions(TransDate,Price,ClientID) VALUES ('2019-08-24',868,415119);
INSERT INTO dbo.Transactions(TransDate,Price,ClientID) VALUES ('2019-07-03',215,171283);
INSERT INTO dbo.Transactions(TransDate,Price,ClientID) VALUES ('2019-04-13',245,289403);
INSERT INTO dbo.Transactions(TransDate,Price,ClientID) VALUES ('2019-01-14',962,304400);
INSERT INTO dbo.Transactions(TransDate,Price,ClientID) VALUES ('2019-10-22',566,862575);
INSERT INTO dbo.Transactions(TransDate,Price,ClientID) VALUES ('2019-07-06',832,133893);
INSERT INTO dbo.Transactions(TransDate,Price,ClientID) VALUES ('2019-07-04',653,798930);
INSERT INTO dbo.Transactions(TransDate,Price,ClientID) VALUES ('2019-01-03',167,778351);
INSERT INTO dbo.Transactions(TransDate,Price,ClientID) VALUES ('2019-03-16',480,746901);
INSERT INTO dbo.Transactions(TransDate,Price,ClientID) VALUES ('2019-02-13',241,824205);
INSERT INTO dbo.Transactions(TransDate,Price,ClientID) VALUES ('2019-10-02',548,689444);
INSERT INTO dbo.Transactions(TransDate,Price,ClientID) VALUES ('2019-03-01',986,118499);
INSERT INTO dbo.Transactions(TransDate,Price,ClientID) VALUES ('2019-10-20',500,921395);
INSERT INTO dbo.Transactions(TransDate,Price,ClientID) VALUES ('2019-08-16',913,633765);
INSERT INTO dbo.Transactions(TransDate,Price,ClientID) VALUES ('2019-01-30',956,476367);
INSERT INTO dbo.Transactions(TransDate,Price,ClientID) VALUES ('2019-01-24',230,912278);
INSERT INTO dbo.Transactions(TransDate,Price,ClientID) VALUES ('2019-06-01',945,751584);
INSERT INTO dbo.Transactions(TransDate,Price,ClientID) VALUES ('2019-10-05',872,153015);
INSERT INTO dbo.Transactions(TransDate,Price,ClientID) VALUES ('2019-02-19',322,606239);
INSERT INTO dbo.Transactions(TransDate,Price,ClientID) VALUES ('2019-04-18',746,274882);
INSERT INTO dbo.Transactions(TransDate,Price,ClientID) VALUES ('2019-11-11',640,179644);
INSERT INTO dbo.Transactions(TransDate,Price,ClientID) VALUES ('2019-10-06',146,842573);
INSERT INTO dbo.Transactions(TransDate,Price,ClientID) VALUES ('2018-11-23',280,762803);
INSERT INTO dbo.Transactions(TransDate,Price,ClientID) VALUES ('2019-05-10',980,572024);
INSERT INTO dbo.Transactions(TransDate,Price,ClientID) VALUES ('2018-11-24',187,143277);
INSERT INTO dbo.Transactions(TransDate,Price,ClientID) VALUES ('2019-05-04',843,275351);
INSERT INTO dbo.Transactions(TransDate,Price,ClientID) VALUES ('2019-10-22',164,357095);
INSERT INTO dbo.Transactions(TransDate,Price,ClientID) VALUES ('2019-09-10',460,338671);
INSERT INTO dbo.Transactions(TransDate,Price,ClientID) VALUES ('2018-12-06',465,467435);
INSERT INTO dbo.Transactions(TransDate,Price,ClientID) VALUES ('2019-01-21',972,611760);
INSERT INTO dbo.Transactions(TransDate,Price,ClientID) VALUES ('2019-05-01',406,983495);
INSERT INTO dbo.Transactions(TransDate,Price,ClientID) VALUES ('2019-06-11',951,431483);
INSERT INTO dbo.Transactions(TransDate,Price,ClientID) VALUES ('2018-12-20',417,962302);
INSERT INTO dbo.Transactions(TransDate,Price,ClientID) VALUES ('2019-01-13',741,194552);
INSERT INTO dbo.Transactions(TransDate,Price,ClientID) VALUES ('2019-10-17',539,349474);
INSERT INTO dbo.Transactions(TransDate,Price,ClientID) VALUES ('2019-03-24',493,430879);
INSERT INTO dbo.Transactions(TransDate,Price,ClientID) VALUES ('2019-08-23',612,870564);
INSERT INTO dbo.Transactions(TransDate,Price,ClientID) VALUES ('2019-06-26',173,141353);
INSERT INTO dbo.Transactions(TransDate,Price,ClientID) VALUES ('2018-12-08',156,270422);
INSERT INTO dbo.Transactions(TransDate,Price,ClientID) VALUES ('2019-04-24',487,232428);
INSERT INTO dbo.Transactions(TransDate,Price,ClientID) VALUES ('2019-10-26',84,317156);
INSERT INTO dbo.Transactions(TransDate,Price,ClientID) VALUES ('2019-11-03',146,226721);
INSERT INTO dbo.Transactions(TransDate,Price,ClientID) VALUES ('2019-01-09',969,452007);
INSERT INTO dbo.Transactions(TransDate,Price,ClientID) VALUES ('2019-02-08',324,368924);
INSERT INTO dbo.Transactions(TransDate,Price,ClientID) VALUES ('2019-05-20',869,112982);
INSERT INTO dbo.Transactions(TransDate,Price,ClientID) VALUES ('2019-06-06',441,656225);
INSERT INTO dbo.Transactions(TransDate,Price,ClientID) VALUES ('2019-01-26',83,101302);
INSERT INTO dbo.Transactions(TransDate,Price,ClientID) VALUES ('2019-03-03',470,181571);
INSERT INTO dbo.Transactions(TransDate,Price,ClientID) VALUES ('2019-01-22',341,764533);
INSERT INTO dbo.Transactions(TransDate,Price,ClientID) VALUES ('2019-02-24',152,777789);
INSERT INTO dbo.Transactions(TransDate,Price,ClientID) VALUES ('2018-12-01',657,231401);
INSERT INTO dbo.Transactions(TransDate,Price,ClientID) VALUES ('2019-07-03',438,199689);
INSERT INTO dbo.Transactions(TransDate,Price,ClientID) VALUES ('2018-12-31',63,640896);
INSERT INTO dbo.Transactions(TransDate,Price,ClientID) VALUES ('2019-11-08',167,394971);
INSERT INTO dbo.Transactions(TransDate,Price,ClientID) VALUES ('2019-04-13',584,802791);
INSERT INTO dbo.Transactions(TransDate,Price,ClientID) VALUES ('2019-08-07',773,432084);
INSERT INTO dbo.Transactions(TransDate,Price,ClientID) VALUES ('2019-10-05',156,536798);
INSERT INTO dbo.Transactions(TransDate,Price,ClientID) VALUES ('2019-09-08',462,818519);
INSERT INTO dbo.Transactions(TransDate,Price,ClientID) VALUES ('2019-09-23',65,869516);
INSERT INTO dbo.Transactions(TransDate,Price,ClientID) VALUES ('2019-03-31',586,413912);
INSERT INTO dbo.Transactions(TransDate,Price,ClientID) VALUES ('2019-07-26',262,335333);
INSERT INTO dbo.Transactions(TransDate,Price,ClientID) VALUES ('2019-05-18',788,724727);
INSERT INTO dbo.Transactions(TransDate,Price,ClientID) VALUES ('2019-09-04',539,458711);
INSERT INTO dbo.Transactions(TransDate,Price,ClientID) VALUES ('2019-05-21',415,998942);
INSERT INTO dbo.Transactions(TransDate,Price,ClientID) VALUES ('2019-01-22',907,998942);
INSERT INTO dbo.Transactions(TransDate,Price,ClientID) VALUES ('2019-10-04',478,998942);






------------------------------------------------------------------------------------------------------

GO
INSERT [dbo].[TransPallet] ([TransactionID], [PalletID]) VALUES (1, 18)
GO
INSERT [dbo].[TransPallet] ([TransactionID], [PalletID]) VALUES (1, 27)
GO
INSERT [dbo].[TransPallet] ([TransactionID], [PalletID]) VALUES (1, 67)
GO
INSERT [dbo].[TransPallet] ([TransactionID], [PalletID]) VALUES (1, 76)
GO
INSERT [dbo].[TransPallet] ([TransactionID], [PalletID]) VALUES (1, 306)
GO
INSERT [dbo].[TransPallet] ([TransactionID], [PalletID]) VALUES (1, 397)
GO
INSERT [dbo].[TransPallet] ([TransactionID], [PalletID]) VALUES (2, 14)
GO
INSERT [dbo].[TransPallet] ([TransactionID], [PalletID]) VALUES (2, 63)
GO
INSERT [dbo].[TransPallet] ([TransactionID], [PalletID]) VALUES (2, 119)
GO
INSERT [dbo].[TransPallet] ([TransactionID], [PalletID]) VALUES (2, 300)
GO
INSERT [dbo].[TransPallet] ([TransactionID], [PalletID]) VALUES (2, 376)
GO
INSERT [dbo].[TransPallet] ([TransactionID], [PalletID]) VALUES (2, 396)
GO
INSERT [dbo].[TransPallet] ([TransactionID], [PalletID]) VALUES (3, 228)
GO
INSERT [dbo].[TransPallet] ([TransactionID], [PalletID]) VALUES (3, 263)
GO
INSERT [dbo].[TransPallet] ([TransactionID], [PalletID]) VALUES (4, 262)
GO
INSERT [dbo].[TransPallet] ([TransactionID], [PalletID]) VALUES (4, 352)
GO
INSERT [dbo].[TransPallet] ([TransactionID], [PalletID]) VALUES (4, 388)
GO
INSERT [dbo].[TransPallet] ([TransactionID], [PalletID]) VALUES (6, 248)
GO
INSERT [dbo].[TransPallet] ([TransactionID], [PalletID]) VALUES (6, 312)
GO
INSERT [dbo].[TransPallet] ([TransactionID], [PalletID]) VALUES (7, 115)
GO
INSERT [dbo].[TransPallet] ([TransactionID], [PalletID]) VALUES (8, 367)
GO
INSERT [dbo].[TransPallet] ([TransactionID], [PalletID]) VALUES (9, 15)
GO
INSERT [dbo].[TransPallet] ([TransactionID], [PalletID]) VALUES (9, 64)
GO
INSERT [dbo].[TransPallet] ([TransactionID], [PalletID]) VALUES (9, 121)
GO
INSERT [dbo].[TransPallet] ([TransactionID], [PalletID]) VALUES (9, 406)
GO
INSERT [dbo].[TransPallet] ([TransactionID], [PalletID]) VALUES (9, 442)
GO
INSERT [dbo].[TransPallet] ([TransactionID], [PalletID]) VALUES (11, 5)
GO
INSERT [dbo].[TransPallet] ([TransactionID], [PalletID]) VALUES (11, 54)
GO
INSERT [dbo].[TransPallet] ([TransactionID], [PalletID]) VALUES (12, 21)
GO
INSERT [dbo].[TransPallet] ([TransactionID], [PalletID]) VALUES (12, 70)
GO
INSERT [dbo].[TransPallet] ([TransactionID], [PalletID]) VALUES (12, 135)
GO
INSERT [dbo].[TransPallet] ([TransactionID], [PalletID]) VALUES (12, 170)
GO
INSERT [dbo].[TransPallet] ([TransactionID], [PalletID]) VALUES (12, 277)
GO
INSERT [dbo].[TransPallet] ([TransactionID], [PalletID]) VALUES (12, 353)
GO
INSERT [dbo].[TransPallet] ([TransactionID], [PalletID]) VALUES (12, 405)
GO
INSERT [dbo].[TransPallet] ([TransactionID], [PalletID]) VALUES (13, 26)
GO
INSERT [dbo].[TransPallet] ([TransactionID], [PalletID]) VALUES (13, 75)
GO
INSERT [dbo].[TransPallet] ([TransactionID], [PalletID]) VALUES (13, 314)
GO
INSERT [dbo].[TransPallet] ([TransactionID], [PalletID]) VALUES (14, 240)
GO
INSERT [dbo].[TransPallet] ([TransactionID], [PalletID]) VALUES (14, 375)
GO
INSERT [dbo].[TransPallet] ([TransactionID], [PalletID]) VALUES (14, 476)
GO
INSERT [dbo].[TransPallet] ([TransactionID], [PalletID]) VALUES (15, 152)
GO
INSERT [dbo].[TransPallet] ([TransactionID], [PalletID]) VALUES (16, 250)
GO
INSERT [dbo].[TransPallet] ([TransactionID], [PalletID]) VALUES (16, 481)
GO
INSERT [dbo].[TransPallet] ([TransactionID], [PalletID]) VALUES (17, 254)
GO
INSERT [dbo].[TransPallet] ([TransactionID], [PalletID]) VALUES (18, 136)
GO
INSERT [dbo].[TransPallet] ([TransactionID], [PalletID]) VALUES (18, 270)
GO
INSERT [dbo].[TransPallet] ([TransactionID], [PalletID]) VALUES (20, 22)
GO
INSERT [dbo].[TransPallet] ([TransactionID], [PalletID]) VALUES (20, 71)
GO
INSERT [dbo].[TransPallet] ([TransactionID], [PalletID]) VALUES (20, 180)
GO
INSERT [dbo].[TransPallet] ([TransactionID], [PalletID]) VALUES (21, 7)
GO
INSERT [dbo].[TransPallet] ([TransactionID], [PalletID]) VALUES (21, 56)
GO
INSERT [dbo].[TransPallet] ([TransactionID], [PalletID]) VALUES (21, 298)
GO
INSERT [dbo].[TransPallet] ([TransactionID], [PalletID]) VALUES (22, 185)
GO
INSERT [dbo].[TransPallet] ([TransactionID], [PalletID]) VALUES (22, 201)
GO
INSERT [dbo].[TransPallet] ([TransactionID], [PalletID]) VALUES (23, 32)
GO
INSERT [dbo].[TransPallet] ([TransactionID], [PalletID]) VALUES (23, 81)
GO
INSERT [dbo].[TransPallet] ([TransactionID], [PalletID]) VALUES (24, 108)
GO
INSERT [dbo].[TransPallet] ([TransactionID], [PalletID]) VALUES (24, 294)
GO
INSERT [dbo].[TransPallet] ([TransactionID], [PalletID]) VALUES (26, 47)
GO
INSERT [dbo].[TransPallet] ([TransactionID], [PalletID]) VALUES (26, 96)
GO
INSERT [dbo].[TransPallet] ([TransactionID], [PalletID]) VALUES (26, 132)
GO
INSERT [dbo].[TransPallet] ([TransactionID], [PalletID]) VALUES (26, 246)
GO
INSERT [dbo].[TransPallet] ([TransactionID], [PalletID]) VALUES (27, 379)
GO
INSERT [dbo].[TransPallet] ([TransactionID], [PalletID]) VALUES (27, 391)
GO
INSERT [dbo].[TransPallet] ([TransactionID], [PalletID]) VALUES (28, 156)
GO
INSERT [dbo].[TransPallet] ([TransactionID], [PalletID]) VALUES (28, 428)
GO
INSERT [dbo].[TransPallet] ([TransactionID], [PalletID]) VALUES (29, 239)
GO
INSERT [dbo].[TransPallet] ([TransactionID], [PalletID]) VALUES (29, 450)
GO
INSERT [dbo].[TransPallet] ([TransactionID], [PalletID]) VALUES (30, 409)
GO
INSERT [dbo].[TransPallet] ([TransactionID], [PalletID]) VALUES (31, 197)
GO
INSERT [dbo].[TransPallet] ([TransactionID], [PalletID]) VALUES (31, 334)
GO
INSERT [dbo].[TransPallet] ([TransactionID], [PalletID]) VALUES (32, 264)
GO
INSERT [dbo].[TransPallet] ([TransactionID], [PalletID]) VALUES (33, 149)
GO
INSERT [dbo].[TransPallet] ([TransactionID], [PalletID]) VALUES (33, 299)
GO
INSERT [dbo].[TransPallet] ([TransactionID], [PalletID]) VALUES (33, 472)
GO
INSERT [dbo].[TransPallet] ([TransactionID], [PalletID]) VALUES (34, 245)
GO
INSERT [dbo].[TransPallet] ([TransactionID], [PalletID]) VALUES (34, 389)
GO
INSERT [dbo].[TransPallet] ([TransactionID], [PalletID]) VALUES (35, 384)
GO
INSERT [dbo].[TransPallet] ([TransactionID], [PalletID]) VALUES (35, 421)
GO
INSERT [dbo].[TransPallet] ([TransactionID], [PalletID]) VALUES (35, 438)
GO
INSERT [dbo].[TransPallet] ([TransactionID], [PalletID]) VALUES (36, 145)
GO
INSERT [dbo].[TransPallet] ([TransactionID], [PalletID]) VALUES (37, 215)
GO
INSERT [dbo].[TransPallet] ([TransactionID], [PalletID]) VALUES (37, 238)
GO
INSERT [dbo].[TransPallet] ([TransactionID], [PalletID]) VALUES (37, 378)
GO
INSERT [dbo].[TransPallet] ([TransactionID], [PalletID]) VALUES (38, 366)
GO
INSERT [dbo].[TransPallet] ([TransactionID], [PalletID]) VALUES (39, 147)
GO
INSERT [dbo].[TransPallet] ([TransactionID], [PalletID]) VALUES (39, 198)
GO
INSERT [dbo].[TransPallet] ([TransactionID], [PalletID]) VALUES (39, 200)
GO
INSERT [dbo].[TransPallet] ([TransactionID], [PalletID]) VALUES (39, 216)
GO
INSERT [dbo].[TransPallet] ([TransactionID], [PalletID]) VALUES (39, 222)
GO
INSERT [dbo].[TransPallet] ([TransactionID], [PalletID]) VALUES (40, 181)
GO
INSERT [dbo].[TransPallet] ([TransactionID], [PalletID]) VALUES (40, 282)
GO
INSERT [dbo].[TransPallet] ([TransactionID], [PalletID]) VALUES (41, 105)
GO
INSERT [dbo].[TransPallet] ([TransactionID], [PalletID]) VALUES (41, 479)
GO
INSERT [dbo].[TransPallet] ([TransactionID], [PalletID]) VALUES (42, 172)
GO
INSERT [dbo].[TransPallet] ([TransactionID], [PalletID]) VALUES (42, 332)
GO
INSERT [dbo].[TransPallet] ([TransactionID], [PalletID]) VALUES (43, 151)
GO
INSERT [dbo].[TransPallet] ([TransactionID], [PalletID]) VALUES (43, 210)
GO
INSERT [dbo].[TransPallet] ([TransactionID], [PalletID]) VALUES (43, 309)
GO
INSERT [dbo].[TransPallet] ([TransactionID], [PalletID]) VALUES (44, 36)
GO
INSERT [dbo].[TransPallet] ([TransactionID], [PalletID]) VALUES (44, 85)
GO
INSERT [dbo].[TransPallet] ([TransactionID], [PalletID]) VALUES (44, 359)
GO
INSERT [dbo].[TransPallet] ([TransactionID], [PalletID]) VALUES (45, 20)
GO
INSERT [dbo].[TransPallet] ([TransactionID], [PalletID]) VALUES (45, 69)
GO
INSERT [dbo].[TransPallet] ([TransactionID], [PalletID]) VALUES (45, 243)
GO
INSERT [dbo].[TransPallet] ([TransactionID], [PalletID]) VALUES (45, 383)
GO
INSERT [dbo].[TransPallet] ([TransactionID], [PalletID]) VALUES (45, 455)
GO
INSERT [dbo].[TransPallet] ([TransactionID], [PalletID]) VALUES (46, 139)
GO
INSERT [dbo].[TransPallet] ([TransactionID], [PalletID]) VALUES (46, 427)
GO
INSERT [dbo].[TransPallet] ([TransactionID], [PalletID]) VALUES (47, 256)
GO
INSERT [dbo].[TransPallet] ([TransactionID], [PalletID]) VALUES (47, 284)
GO
INSERT [dbo].[TransPallet] ([TransactionID], [PalletID]) VALUES (47, 333)
GO
INSERT [dbo].[TransPallet] ([TransactionID], [PalletID]) VALUES (48, 183)
GO
INSERT [dbo].[TransPallet] ([TransactionID], [PalletID]) VALUES (48, 373)
GO
INSERT [dbo].[TransPallet] ([TransactionID], [PalletID]) VALUES (48, 380)
GO
INSERT [dbo].[TransPallet] ([TransactionID], [PalletID]) VALUES (48, 436)
GO
INSERT [dbo].[TransPallet] ([TransactionID], [PalletID]) VALUES (49, 42)
GO
INSERT [dbo].[TransPallet] ([TransactionID], [PalletID]) VALUES (49, 91)
GO
INSERT [dbo].[TransPallet] ([TransactionID], [PalletID]) VALUES (49, 104)
GO
INSERT [dbo].[TransPallet] ([TransactionID], [PalletID]) VALUES (49, 126)
GO
INSERT [dbo].[TransPallet] ([TransactionID], [PalletID]) VALUES (99, 273)
GO
INSERT [dbo].[TransPallet] ([TransactionID], [PalletID]) VALUES (100, 415)
GO
INSERT [dbo].[TransPallet] ([TransactionID], [PalletID]) VALUES (100, 425)
GO
INSERT [dbo].[TransPallet] ([TransactionID], [PalletID]) VALUES (101, 196)
GO
INSERT [dbo].[TransPallet] ([TransactionID], [PalletID]) VALUES (101, 469)
GO
INSERT [dbo].[TransPallet] ([TransactionID], [PalletID]) VALUES (102, 160)
GO
INSERT [dbo].[TransPallet] ([TransactionID], [PalletID]) VALUES (102, 302)
GO
INSERT [dbo].[TransPallet] ([TransactionID], [PalletID]) VALUES (102, 335)
GO
INSERT [dbo].[TransPallet] ([TransactionID], [PalletID]) VALUES (104, 11)
GO
INSERT [dbo].[TransPallet] ([TransactionID], [PalletID]) VALUES (104, 37)
GO
INSERT [dbo].[TransPallet] ([TransactionID], [PalletID]) VALUES (104, 60)
GO
INSERT [dbo].[TransPallet] ([TransactionID], [PalletID]) VALUES (104, 86)
GO
INSERT [dbo].[TransPallet] ([TransactionID], [PalletID]) VALUES (104, 445)
GO
INSERT [dbo].[TransPallet] ([TransactionID], [PalletID]) VALUES (106, 241)
GO
INSERT [dbo].[TransPallet] ([TransactionID], [PalletID]) VALUES (108, 400)
GO
INSERT [dbo].[TransPallet] ([TransactionID], [PalletID]) VALUES (109, 12)
GO
INSERT [dbo].[TransPallet] ([TransactionID], [PalletID]) VALUES (109, 38)
GO
INSERT [dbo].[TransPallet] ([TransactionID], [PalletID]) VALUES (109, 61)
GO
INSERT [dbo].[TransPallet] ([TransactionID], [PalletID]) VALUES (109, 87)
GO
INSERT [dbo].[TransPallet] ([TransactionID], [PalletID]) VALUES (109, 208)
GO
INSERT [dbo].[TransPallet] ([TransactionID], [PalletID]) VALUES (109, 350)
GO
INSERT [dbo].[TransPallet] ([TransactionID], [PalletID]) VALUES (109, 417)
GO
INSERT [dbo].[TransPallet] ([TransactionID], [PalletID]) VALUES (110, 385)
GO
INSERT [dbo].[TransPallet] ([TransactionID], [PalletID]) VALUES (112, 31)
GO
INSERT [dbo].[TransPallet] ([TransactionID], [PalletID]) VALUES (112, 80)
GO
INSERT [dbo].[TransPallet] ([TransactionID], [PalletID]) VALUES (112, 133)
GO
INSERT [dbo].[TransPallet] ([TransactionID], [PalletID]) VALUES (113, 28)
GO
INSERT [dbo].[TransPallet] ([TransactionID], [PalletID]) VALUES (113, 77)
GO
INSERT [dbo].[TransPallet] ([TransactionID], [PalletID]) VALUES (113, 218)
GO
INSERT [dbo].[TransPallet] ([TransactionID], [PalletID]) VALUES (113, 261)
GO
INSERT [dbo].[TransPallet] ([TransactionID], [PalletID]) VALUES (113, 432)
GO
INSERT [dbo].[TransPallet] ([TransactionID], [PalletID]) VALUES (114, 343)
GO
INSERT [dbo].[TransPallet] ([TransactionID], [PalletID]) VALUES (115, 258)
GO
INSERT [dbo].[TransPallet] ([TransactionID], [PalletID]) VALUES (116, 190)
GO
INSERT [dbo].[TransPallet] ([TransactionID], [PalletID]) VALUES (116, 281)
GO
INSERT [dbo].[TransPallet] ([TransactionID], [PalletID]) VALUES (117, 155)
GO
INSERT [dbo].[TransPallet] ([TransactionID], [PalletID]) VALUES (117, 478)
GO
INSERT [dbo].[TransPallet] ([TransactionID], [PalletID]) VALUES (118, 465)
GO
INSERT [dbo].[TransPallet] ([TransactionID], [PalletID]) VALUES (119, 101)
GO
INSERT [dbo].[TransPallet] ([TransactionID], [PalletID]) VALUES (119, 242)
GO
INSERT [dbo].[TransPallet] ([TransactionID], [PalletID]) VALUES (119, 259)
GO
INSERT [dbo].[TransPallet] ([TransactionID], [PalletID]) VALUES (121, 8)
GO
INSERT [dbo].[TransPallet] ([TransactionID], [PalletID]) VALUES (121, 57)
GO
INSERT [dbo].[TransPallet] ([TransactionID], [PalletID]) VALUES (121, 166)
GO
INSERT [dbo].[TransPallet] ([TransactionID], [PalletID]) VALUES (121, 325)
GO
INSERT [dbo].[TransPallet] ([TransactionID], [PalletID]) VALUES (121, 416)
GO
INSERT [dbo].[TransPallet] ([TransactionID], [PalletID]) VALUES (121, 461)
GO
INSERT [dbo].[TransPallet] ([TransactionID], [PalletID]) VALUES (123, 158)
GO
INSERT [dbo].[TransPallet] ([TransactionID], [PalletID]) VALUES (123, 279)
GO
INSERT [dbo].[TransPallet] ([TransactionID], [PalletID]) VALUES (124, 143)
GO
INSERT [dbo].[TransPallet] ([TransactionID], [PalletID]) VALUES (124, 237)
GO
INSERT [dbo].[TransPallet] ([TransactionID], [PalletID]) VALUES (124, 338)
GO
INSERT [dbo].[TransPallet] ([TransactionID], [PalletID]) VALUES (124, 430)
GO
INSERT [dbo].[TransPallet] ([TransactionID], [PalletID]) VALUES (125, 35)
GO
INSERT [dbo].[TransPallet] ([TransactionID], [PalletID]) VALUES (125, 84)
GO
INSERT [dbo].[TransPallet] ([TransactionID], [PalletID]) VALUES (125, 127)
GO
INSERT [dbo].[TransPallet] ([TransactionID], [PalletID]) VALUES (125, 225)
GO
INSERT [dbo].[TransPallet] ([TransactionID], [PalletID]) VALUES (125, 446)
GO
INSERT [dbo].[TransPallet] ([TransactionID], [PalletID]) VALUES (126, 122)
GO
INSERT [dbo].[TransPallet] ([TransactionID], [PalletID]) VALUES (126, 130)
GO
INSERT [dbo].[TransPallet] ([TransactionID], [PalletID]) VALUES (126, 189)
GO
INSERT [dbo].[TransPallet] ([TransactionID], [PalletID]) VALUES (126, 211)
GO
INSERT [dbo].[TransPallet] ([TransactionID], [PalletID]) VALUES (127, 161)
GO
INSERT [dbo].[TransPallet] ([TransactionID], [PalletID]) VALUES (127, 308)
GO
INSERT [dbo].[TransPallet] ([TransactionID], [PalletID]) VALUES (127, 371)
GO
INSERT [dbo].[TransPallet] ([TransactionID], [PalletID]) VALUES (130, 103)
GO
INSERT [dbo].[TransPallet] ([TransactionID], [PalletID]) VALUES (130, 124)
GO
INSERT [dbo].[TransPallet] ([TransactionID], [PalletID]) VALUES (130, 205)
GO
INSERT [dbo].[TransPallet] ([TransactionID], [PalletID]) VALUES (130, 249)
GO
INSERT [dbo].[TransPallet] ([TransactionID], [PalletID]) VALUES (130, 269)
GO
INSERT [dbo].[TransPallet] ([TransactionID], [PalletID]) VALUES (131, 267)
GO
INSERT [dbo].[TransPallet] ([TransactionID], [PalletID]) VALUES (131, 390)
GO
INSERT [dbo].[TransPallet] ([TransactionID], [PalletID]) VALUES (132, 174)
GO
INSERT [dbo].[TransPallet] ([TransactionID], [PalletID]) VALUES (132, 423)
GO
INSERT [dbo].[TransPallet] ([TransactionID], [PalletID]) VALUES (133, 377)
GO
INSERT [dbo].[TransPallet] ([TransactionID], [PalletID]) VALUES (134, 382)
GO
INSERT [dbo].[TransPallet] ([TransactionID], [PalletID]) VALUES (135, 159)
GO
INSERT [dbo].[TransPallet] ([TransactionID], [PalletID]) VALUES (135, 224)
GO
INSERT [dbo].[TransPallet] ([TransactionID], [PalletID]) VALUES (135, 252)
GO
INSERT [dbo].[TransPallet] ([TransactionID], [PalletID]) VALUES (135, 365)
GO
INSERT [dbo].[TransPallet] ([TransactionID], [PalletID]) VALUES (137, 34)
GO
INSERT [dbo].[TransPallet] ([TransactionID], [PalletID]) VALUES (137, 83)
GO
INSERT [dbo].[TransPallet] ([TransactionID], [PalletID]) VALUES (138, 43)
GO
INSERT [dbo].[TransPallet] ([TransactionID], [PalletID]) VALUES (138, 92)
GO
INSERT [dbo].[TransPallet] ([TransactionID], [PalletID]) VALUES (139, 114)
GO
INSERT [dbo].[TransPallet] ([TransactionID], [PalletID]) VALUES (139, 194)
GO
INSERT [dbo].[TransPallet] ([TransactionID], [PalletID]) VALUES (139, 310)
GO
INSERT [dbo].[TransPallet] ([TransactionID], [PalletID]) VALUES (139, 444)
GO
INSERT [dbo].[TransPallet] ([TransactionID], [PalletID]) VALUES (140, 257)
GO
INSERT [dbo].[TransPallet] ([TransactionID], [PalletID]) VALUES (140, 407)
GO
INSERT [dbo].[TransPallet] ([TransactionID], [PalletID]) VALUES (141, 148)
GO
INSERT [dbo].[TransPallet] ([TransactionID], [PalletID]) VALUES (141, 153)
GO
INSERT [dbo].[TransPallet] ([TransactionID], [PalletID]) VALUES (143, 113)
GO
INSERT [dbo].[TransPallet] ([TransactionID], [PalletID]) VALUES (143, 274)
GO
INSERT [dbo].[TransPallet] ([TransactionID], [PalletID]) VALUES (143, 280)
GO
INSERT [dbo].[TransPallet] ([TransactionID], [PalletID]) VALUES (143, 320)
GO
INSERT [dbo].[TransPallet] ([TransactionID], [PalletID]) VALUES (143, 321)
GO
INSERT [dbo].[TransPallet] ([TransactionID], [PalletID]) VALUES (143, 402)
GO
INSERT [dbo].[TransPallet] ([TransactionID], [PalletID]) VALUES (144, 316)
GO
INSERT [dbo].[TransPallet] ([TransactionID], [PalletID]) VALUES (145, 2)
GO
INSERT [dbo].[TransPallet] ([TransactionID], [PalletID]) VALUES (145, 9)
GO
INSERT [dbo].[TransPallet] ([TransactionID], [PalletID]) VALUES (145, 51)
GO
INSERT [dbo].[TransPallet] ([TransactionID], [PalletID]) VALUES (145, 58)
GO
INSERT [dbo].[TransPallet] ([TransactionID], [PalletID]) VALUES (145, 188)
GO
INSERT [dbo].[TransPallet] ([TransactionID], [PalletID]) VALUES (146, 192)
GO
INSERT [dbo].[TransPallet] ([TransactionID], [PalletID]) VALUES (147, 52)
GO
INSERT [dbo].[TransPallet] ([TransactionID], [PalletID]) VALUES (147, 176)
GO
INSERT [dbo].[TransPallet] ([TransactionID], [PalletID]) VALUES (148, 17)
GO
INSERT [dbo].[TransPallet] ([TransactionID], [PalletID]) VALUES (148, 66)
GO
INSERT [dbo].[TransPallet] ([TransactionID], [PalletID]) VALUES (148, 433)
GO
INSERT [dbo].[TransPallet] ([TransactionID], [PalletID]) VALUES (150, 118)
GO
INSERT [dbo].[TransPallet] ([TransactionID], [PalletID]) VALUES (150, 226)
GO
INSERT [dbo].[TransPallet] ([TransactionID], [PalletID]) VALUES (151, 175)
GO
INSERT [dbo].[TransPallet] ([TransactionID], [PalletID]) VALUES (151, 356)
GO
INSERT [dbo].[TransPallet] ([TransactionID], [PalletID]) VALUES (151, 398)
GO
INSERT [dbo].[TransPallet] ([TransactionID], [PalletID]) VALUES (151, 453)
GO
INSERT [dbo].[TransPallet] ([TransactionID], [PalletID]) VALUES (152, 141)
GO
INSERT [dbo].[TransPallet] ([TransactionID], [PalletID]) VALUES (152, 271)
GO
INSERT [dbo].[TransPallet] ([TransactionID], [PalletID]) VALUES (152, 307)
GO
INSERT [dbo].[TransPallet] ([TransactionID], [PalletID]) VALUES (153, 44)
GO
INSERT [dbo].[TransPallet] ([TransactionID], [PalletID]) VALUES (153, 93)
GO
INSERT [dbo].[TransPallet] ([TransactionID], [PalletID]) VALUES (153, 229)
GO
INSERT [dbo].[TransPallet] ([TransactionID], [PalletID]) VALUES (154, 191)
GO
INSERT [dbo].[TransPallet] ([TransactionID], [PalletID]) VALUES (155, 291)
GO
INSERT [dbo].[TransPallet] ([TransactionID], [PalletID]) VALUES (155, 401)
GO
INSERT [dbo].[TransPallet] ([TransactionID], [PalletID]) VALUES (155, 447)
GO
INSERT [dbo].[TransPallet] ([TransactionID], [PalletID]) VALUES (156, 209)
GO
INSERT [dbo].[TransPallet] ([TransactionID], [PalletID]) VALUES (156, 460)
GO
INSERT [dbo].[TransPallet] ([TransactionID], [PalletID]) VALUES (158, 290)
GO
INSERT [dbo].[TransPallet] ([TransactionID], [PalletID]) VALUES (159, 106)
GO
INSERT [dbo].[TransPallet] ([TransactionID], [PalletID]) VALUES (159, 276)
GO
INSERT [dbo].[TransPallet] ([TransactionID], [PalletID]) VALUES (159, 393)
GO
INSERT [dbo].[TransPallet] ([TransactionID], [PalletID]) VALUES (159, 441)
GO
INSERT [dbo].[TransPallet] ([TransactionID], [PalletID]) VALUES (160, 171)
GO
INSERT [dbo].[TransPallet] ([TransactionID], [PalletID]) VALUES (160, 303)
GO
INSERT [dbo].[TransPallet] ([TransactionID], [PalletID]) VALUES (160, 304)
GO
INSERT [dbo].[TransPallet] ([TransactionID], [PalletID]) VALUES (161, 223)
GO
INSERT [dbo].[TransPallet] ([TransactionID], [PalletID]) VALUES (162, 326)
GO
INSERT [dbo].[TransPallet] ([TransactionID], [PalletID]) VALUES (163, 157)
GO
INSERT [dbo].[TransPallet] ([TransactionID], [PalletID]) VALUES (163, 233)
GO
INSERT [dbo].[TransPallet] ([TransactionID], [PalletID]) VALUES (163, 420)
GO
INSERT [dbo].[TransPallet] ([TransactionID], [PalletID]) VALUES (163, 437)
GO
INSERT [dbo].[TransPallet] ([TransactionID], [PalletID]) VALUES (163, 451)
GO
INSERT [dbo].[TransPallet] ([TransactionID], [PalletID]) VALUES (164, 165)
GO
INSERT [dbo].[TransPallet] ([TransactionID], [PalletID]) VALUES (164, 357)
GO
INSERT [dbo].[TransPallet] ([TransactionID], [PalletID]) VALUES (165, 107)
GO
INSERT [dbo].[TransPallet] ([TransactionID], [PalletID]) VALUES (165, 131)
GO
INSERT [dbo].[TransPallet] ([TransactionID], [PalletID]) VALUES (165, 177)
GO
INSERT [dbo].[TransPallet] ([TransactionID], [PalletID]) VALUES (165, 232)
GO
INSERT [dbo].[TransPallet] ([TransactionID], [PalletID]) VALUES (167, 146)
GO
INSERT [dbo].[TransPallet] ([TransactionID], [PalletID]) VALUES (168, 162)
GO
INSERT [dbo].[TransPallet] ([TransactionID], [PalletID]) VALUES (168, 184)
GO
INSERT [dbo].[TransPallet] ([TransactionID], [PalletID]) VALUES (168, 456)
GO
INSERT [dbo].[TransPallet] ([TransactionID], [PalletID]) VALUES (169, 413)
GO
INSERT [dbo].[TransPallet] ([TransactionID], [PalletID]) VALUES (169, 448)
GO
INSERT [dbo].[TransPallet] ([TransactionID], [PalletID]) VALUES (170, 344)
GO
INSERT [dbo].[TransPallet] ([TransactionID], [PalletID]) VALUES (170, 443)
GO
INSERT [dbo].[TransPallet] ([TransactionID], [PalletID]) VALUES (171, 301)
GO
INSERT [dbo].[TransPallet] ([TransactionID], [PalletID]) VALUES (171, 372)
GO
INSERT [dbo].[TransPallet] ([TransactionID], [PalletID]) VALUES (172, 235)
GO
INSERT [dbo].[TransPallet] ([TransactionID], [PalletID]) VALUES (172, 422)
GO
INSERT [dbo].[TransPallet] ([TransactionID], [PalletID]) VALUES (173, 24)
GO
INSERT [dbo].[TransPallet] ([TransactionID], [PalletID]) VALUES (173, 73)
GO
INSERT [dbo].[TransPallet] ([TransactionID], [PalletID]) VALUES (173, 193)
GO
INSERT [dbo].[TransPallet] ([TransactionID], [PalletID]) VALUES (173, 404)
GO
INSERT [dbo].[TransPallet] ([TransactionID], [PalletID]) VALUES (173, 434)
GO
INSERT [dbo].[TransPallet] ([TransactionID], [PalletID]) VALUES (174, 227)
GO
INSERT [dbo].[TransPallet] ([TransactionID], [PalletID]) VALUES (174, 260)
GO
INSERT [dbo].[TransPallet] ([TransactionID], [PalletID]) VALUES (174, 289)
GO
INSERT [dbo].[TransPallet] ([TransactionID], [PalletID]) VALUES (174, 296)
GO
INSERT [dbo].[TransPallet] ([TransactionID], [PalletID]) VALUES (174, 361)
GO
INSERT [dbo].[TransPallet] ([TransactionID], [PalletID]) VALUES (176, 369)
GO
INSERT [dbo].[TransPallet] ([TransactionID], [PalletID]) VALUES (177, 109)
GO
INSERT [dbo].[TransPallet] ([TransactionID], [PalletID]) VALUES (177, 120)
GO
INSERT [dbo].[TransPallet] ([TransactionID], [PalletID]) VALUES (177, 426)
GO
INSERT [dbo].[TransPallet] ([TransactionID], [PalletID]) VALUES (177, 462)
GO
INSERT [dbo].[TransPallet] ([TransactionID], [PalletID]) VALUES (177, 468)
GO
INSERT [dbo].[TransPallet] ([TransactionID], [PalletID]) VALUES (178, 231)
GO
INSERT [dbo].[TransPallet] ([TransactionID], [PalletID]) VALUES (178, 253)
GO
INSERT [dbo].[TransPallet] ([TransactionID], [PalletID]) VALUES (179, 123)
GO
INSERT [dbo].[TransPallet] ([TransactionID], [PalletID]) VALUES (180, 195)
GO
INSERT [dbo].[TransPallet] ([TransactionID], [PalletID]) VALUES (182, 328)
GO
INSERT [dbo].[TransPallet] ([TransactionID], [PalletID]) VALUES (182, 424)
GO
INSERT [dbo].[TransPallet] ([TransactionID], [PalletID]) VALUES (183, 46)
GO
INSERT [dbo].[TransPallet] ([TransactionID], [PalletID]) VALUES (183, 95)
GO
INSERT [dbo].[TransPallet] ([TransactionID], [PalletID]) VALUES (183, 100)
GO
INSERT [dbo].[TransPallet] ([TransactionID], [PalletID]) VALUES (183, 322)
GO
INSERT [dbo].[TransPallet] ([TransactionID], [PalletID]) VALUES (183, 339)
GO
INSERT [dbo].[TransPallet] ([TransactionID], [PalletID]) VALUES (183, 355)
GO
INSERT [dbo].[TransPallet] ([TransactionID], [PalletID]) VALUES (183, 477)
GO
INSERT [dbo].[TransPallet] ([TransactionID], [PalletID]) VALUES (184, 137)
GO
INSERT [dbo].[TransPallet] ([TransactionID], [PalletID]) VALUES (185, 129)
GO
INSERT [dbo].[TransPallet] ([TransactionID], [PalletID]) VALUES (185, 295)
GO
INSERT [dbo].[TransPallet] ([TransactionID], [PalletID]) VALUES (185, 305)
GO
INSERT [dbo].[TransPallet] ([TransactionID], [PalletID]) VALUES (187, 138)
GO
INSERT [dbo].[TransPallet] ([TransactionID], [PalletID]) VALUES (187, 204)
GO
INSERT [dbo].[TransPallet] ([TransactionID], [PalletID]) VALUES (187, 474)
GO
INSERT [dbo].[TransPallet] ([TransactionID], [PalletID]) VALUES (188, 50)
GO
INSERT [dbo].[TransPallet] ([TransactionID], [PalletID]) VALUES (188, 99)
GO
INSERT [dbo].[TransPallet] ([TransactionID], [PalletID]) VALUES (188, 374)
GO
INSERT [dbo].[TransPallet] ([TransactionID], [PalletID]) VALUES (190, 266)
GO
INSERT [dbo].[TransPallet] ([TransactionID], [PalletID]) VALUES (190, 311)
GO
INSERT [dbo].[TransPallet] ([TransactionID], [PalletID]) VALUES (191, 150)
GO
INSERT [dbo].[TransPallet] ([TransactionID], [PalletID]) VALUES (191, 360)
GO
INSERT [dbo].[TransPallet] ([TransactionID], [PalletID]) VALUES (191, 475)
GO
INSERT [dbo].[TransPallet] ([TransactionID], [PalletID]) VALUES (192, 23)
GO
INSERT [dbo].[TransPallet] ([TransactionID], [PalletID]) VALUES (192, 39)
GO
INSERT [dbo].[TransPallet] ([TransactionID], [PalletID]) VALUES (192, 72)
GO
INSERT [dbo].[TransPallet] ([TransactionID], [PalletID]) VALUES (192, 88)
GO
INSERT [dbo].[TransPallet] ([TransactionID], [PalletID]) VALUES (192, 464)
GO
INSERT [dbo].[TransPallet] ([TransactionID], [PalletID]) VALUES (194, 386)
GO
INSERT [dbo].[TransPallet] ([TransactionID], [PalletID]) VALUES (194, 410)
GO
INSERT [dbo].[TransPallet] ([TransactionID], [PalletID]) VALUES (195, 142)
GO
INSERT [dbo].[TransPallet] ([TransactionID], [PalletID]) VALUES (195, 327)
GO
INSERT [dbo].[TransPallet] ([TransactionID], [PalletID]) VALUES (196, 125)
GO
INSERT [dbo].[TransPallet] ([TransactionID], [PalletID]) VALUES (196, 251)
GO
INSERT [dbo].[TransPallet] ([TransactionID], [PalletID]) VALUES (197, 348)
GO
INSERT [dbo].[TransPallet] ([TransactionID], [PalletID]) VALUES (198, 49)
GO
INSERT [dbo].[TransPallet] ([TransactionID], [PalletID]) VALUES (198, 98)
GO
INSERT [dbo].[TransPallet] ([TransactionID], [PalletID]) VALUES (198, 213)
GO
INSERT [dbo].[TransPallet] ([TransactionID], [PalletID]) VALUES (198, 324)
GO


-----------------------------------------------------------------------------------------
drop procedure showLog
go
create procedure showLog
As
begin
select * from dbo.LogFile
end

go


go
------------------------------
DROP PROCEDURE ClientInsert
GO

CREATE PROCEDURE  ClientInsert
@ID int, @fname nvarchar(20),@Lname nvarchar(20), @DoB date, @Email nvarchar(30),
@PhoneN int, @HomeN int, @Address nvarchar(80),@SSN int
As
Begin

Insert Into dbo.Client(ID, Fname,Lname,DateOfBirth,Email,PhoneNumber,HomeNumber,Address) values(@ID,@fname, @Lname, @DoB,@Email,@PhoneN,@HomeN,@Address)
insert into dbo.LogFile(Date,Report)VALUES (GETDATE() , CONCAT ( 'User with  ' , @SSN ,' has added Client ' , @ID , ' and with name ' ,@fname , '  ' , @Lname) )
return @ID 
end

GO

Drop Procedure ClientUpdateEmail
GO
Create procedure ClientUpdateEmail
@ID int , @Email nvarchar(30) , @SSN INT
As
begin
update dbo.Client
set Email=@Email
where ID=@ID
insert into dbo.LogFile(Date,Report)VALUES (GETDATE() , CONCAT ( 'User with  ' , @SSN ,' has updated the email of Client ' , @ID ,' to ' , @email) )
return @ID
END

go

-----------------------------------------
Drop Procedure ClientUpdatePersonalPhone
GO

Create procedure ClientUpdatePersonalPhone
@ID int , @Phone int , @SSN int 
As
begin
update dbo.Client
set PhoneNumber=@Phone
where ID=@ID
insert into dbo.LogFile(Date,Report)VALUES (GETDATE() , CONCAT ('User with  ' , @SSN ,' has updated the PersonalPhone of Client ' , @ID , ' to ' ,@Phone) )
return @ID
END

GO

------------------------------------------
Drop Procedure ClientUpdateResidentHome
GO

Create procedure ClientUpdateResidentHome
@ID int , @Phone int , @ssn int
As
begin
update dbo.Client
set HomeNumber=@Phone
where ID=@ID
insert into dbo.LogFile(Date,Report)VALUES (GETDATE() , CONCAT ( 'User with  ' , @SSN ,' has updated the ResidentPhone of Client ' , @ID , ' to ' ,@Phone) )
return @ID

END

GO


-----------------------------------
Drop Procedure ClientUpdateAddress

GO
Create procedure ClientUpdateAddress
@ID int , @Address nvarchar(80) , @SSN int
As
begin
update dbo.Client
set Address=@Address
where ID=@ID
insert into dbo.LogFile(Date,Report)VALUES (GETDATE() , CONCAT ( 'User with  ' , @SSN ,' has updated the address of Client ' , @ID , ' to ' , @Address) )
return @ID

END

GO


-------------------------
Drop Procedure ClientDelete

go

Create Procedure ClientDelete
@ID int , @SSN int
as
begin
if EXISTS (select * from dbo.Client where ID=@id) 
 begin
 declare @name nvarchar(50)
 set @name = (select Fname + ' ' + Lname from dbo.Client where ID = @ID)
 delete
 from dbo.Client
 where ID=@ID 
 insert into dbo.LogFile(Date,Report)VALUES (GETDATE() , CONCAT ( 'User with  ' , @SSN ,' has deleted Client ' , @ID , ' with name ' , @name) )
 Return @ID
 end
else return 0

end
go

--------------------------
Drop procedure ClientShow
GO

Create Procedure ClientShow
@ID int
as 
BEGIN
	if EXISTS (select * from dbo.Client where ID=@id)
 begin
	select *
	from dbo.Client
	where dbo.client.ID=@ID
 end
else 
 begin
RAISERROR ('Error',15,1);
 end
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
@ExtraCost smallmoney,
@SSN int
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
	insert into dbo.LogFile(Date,Report)VALUES (GETDATE() , CONCAT ( 'User with  ' , @SSN ,' has inserted Pallet ' , @PalletID , ' at position ' , @Position) )
	Return @PalletID
	
  end
end
Go

drop procedure PalletUpdatePosition

Go

Create procedure PalletUpdatePosition
@PalletID int,@position smallint , @SSN int
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
      insert into dbo.LogFile(Date,Report)VALUES (GETDATE() , CONCAT ( 'User with  ' , @SSN ,' has updated Position of Pallet' , @PalletID , ' to ', @position)  )
   Return @PalletID

   end
END


GO

drop procedure PalletUpdateExportDate

Go


Create procedure PalletUpdateExportDate
@PalletID int,@exportdate date ,  @SSN int
As
 Begin
   update dbo.Pallet 
   SET ExportDate=@exportdate
   where PalletID = @PalletID
      insert into dbo.LogFile(Date,Report)VALUES (GETDATE() , CONCAT ( 'User with  ' , @SSN ,' has updated export date of Pallet ' , @PalletID , ' to ' , @exportdate) )
   Return @PalletID

 end

 GO



--update extracost changes totalcost too also cant change it if the palletID exist in a transaction
drop procedure PalletUpdateExtraCost

Go

Create procedure PalletUpdateExtraCost
@PalletID int,@extracost smallint , @SSN int
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
      insert into dbo.LogFile(Date,Report)VALUES (GETDATE() , CONCAT ( 'User with  ' , @SSN ,' has updated Extra Cost of Pallet ' , @PalletID , ' to ' , @extracost ) )
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
IF EXISTS (Select * from dbo.Pallet where PalletID = @PalletID)
 begin
 Select *
 from dbo.Pallet
 where PalletID = @PalletID
 end
 else 
 RAISERROR ('Error',15,1);
End

GO

drop procedure PalletDelete

Go

create procedure PalletDelete
@PalletID int , @SSN int
AS
Begin
if EXISTS  (select * from dbo.Pallet where PalletID = @PalletID)
begin
 Delete
 from dbo.Pallet
 where PalletID = @PalletID
  insert into dbo.LogFile(Date,Report)VALUES (GETDATE() , CONCAT ( 'User with  ' , @SSN ,' has deleted Pallet ' , @PalletID) )
 return @palletID

end
else return 0
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
@password nvarchar(30),
@SSN2 int
AS
 Begin
	INSERT INTO dbo.Employee (SSN,ID,LNAME,FNAME,DATEOFBIRTH,Email,POSITION,PHONENUMBER,HOMENUMBER,ADDRESS,SALARY,ISADMIN) VALUES (@SSN,@ID,@LNAME,@FNAME,@DATEOFBIRTH,@email,@POSITION,@PHONENUMBER,@HOMENUMBER,@ADDRESS,@SALARY,@ISADMIN)
	insert into dbo.Authentication (SSN,Username,Password) VALUES (@SSN,@username,@password)
	insert into dbo.LogFile(Date,Report)VALUES (GETDATE() , CONCAT ( 'User with  ' , @SSN2 ,' has inserted Employee with ' , @SSN , ' and Name ' , @FName , ' ',@LName) )
	Return @SSN 
 end

Go


drop procedure EmployeeUpdateEmail

GO

Create procedure EmployeeUpdateEmail
@SSN int,@Email nvarchar(30) , @SSN2 int
As
begin
IF EXISTS (select * from dbo.Employee where SSN=@SSN) 
  Begin
   update dbo.Employee
   SET Email=@email
   where SSN = @SSN
      insert into dbo.LogFile(Date,Report)VALUES (GETDATE() , CONCAT ( 'User with  ' , @SSN2 ,' has updated Email of Employee with ' , @SSN , ' to ' ,@Email) )
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
@SSN int, @Position nvarchar(50) , @SSN2 int
As
begin
IF EXISTS (select * from dbo.Employee where SSN=@SSN) 
  Begin
   update dbo.Employee
   SET Position=@Position
   where SSN = @SSN
      insert into dbo.LogFile(Date,Report)VALUES (GETDATE() , CONCAT ( 'User with  ' , @SSN2 ,' has updated position of Employee with ' , @SSN , ' to ' , @Position) )
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
@SSN int, @PhoneNumber int , @SSN2 int
As
begin
IF EXISTS (select * from dbo.Employee where SSN=@SSN) 
  Begin
   update dbo.Employee
   SET PhoneNumber=@PhoneNumber
   where SSN = @SSN
      insert into dbo.LogFile(Date,Report)VALUES (GETDATE() , CONCAT ( 'User with  ' , @SSN2 ,' has updated PhoneNumber of Employee with ' , @SSN , ' to ' , @PhoneNumber)  )
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
@SSN int, @Salary int , @SSN2 int
As
begin
IF EXISTS (select * from dbo.Employee where SSN=@SSN) 
  Begin
   update dbo.Employee
   SET Salary=@Salary
   where SSN = @SSN
      insert into dbo.LogFile(Date,Report)VALUES (GETDATE() , CONCAT ( 'User with  ' , @SSN2 ,' has updated Salary of Employee with ' , @SSN , ' to ' , @Salary) )
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
@SSN int, @Address nvarchar(80) , @SSN2 int
As
begin
IF EXISTS (select * from dbo.Employee where SSN=@SSN) 
  Begin
   update dbo.Employee
   SET Address=@Address
   where SSN = @SSN
      insert into dbo.LogFile(Date,Report)VALUES (GETDATE() , CONCAT ( 'User with  ' , @SSN2 ,' has updated Address of Employee with ' , @SSN , ' to ', @Address) )
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
@SSN int, @isAdmin bit , @SSN2 int
As
begin
IF EXISTS (select * from dbo.Employee where SSN=@SSN) 
  Begin
   update dbo.Employee
   SET isAdmin=@isAdmin
   where SSN = @SSN
      insert into dbo.LogFile(Date,Report)VALUES (GETDATE() , CONCAT ( 'User with  ' , @SSN2 ,' has made admin the Employee with ' , @SSN) )
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
IF EXISTS (Select * from dbo.Employee where SSN = @SSN )
 begin
 Select *
 from dbo.Employee
 where SSN = @SSN
 end
 else 
 RAISERROR ('Error',15,1);
End
GO


DROP PROCEDURE EmployeeDelete
Go
create procedure EmployeeDelete
@SSN int , @SSN2 int
AS
Begin
if EXISTS (select * from dbo.Employee where SSN=@SSN)
 begin
  Declare @name nvarchar(50)
 set @name = (select Fname + ' ' + Lname from dbo.Employee where SSN = @SSN)
 Delete
 from dbo.Employee
 where SSN= @SSN
 insert into dbo.LogFile(Date,Report)VALUES (GETDATE() , CONCAT ( 'User with  ' , @SSN2 ,' has deleted Employee with ' , @SSN, ' and name ' , @name) )
 return @SSN

 end
 else return 0
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
GO
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

DROP PROCEDURE printTransPallet

GO

drop procedure printTransPallet 
Go
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
IF EXISTS (	SELECT T.TransactionID,T.TransDate,T.Price
	FROM dbo.Transactions T
	WHERE (T.ClientID = @CliendId AND T.Price IS NOT NULL))
 begin
	SELECT T.TransactionID,T.TransDate,T.Price
	FROM dbo.Transactions T
	WHERE (T.ClientID = @CliendId AND T.Price IS NOT NULL)
 end
 else RAISERROR ('Error',15,1)
END

-----------------------------------------------------------------------------------------

GO
drop procedure NotifyFood

go
CREATE PROCEDURE NotifyFood
AS
BEGIN
IF EXISTS (	SELECT P.PalletID,P.WarehouseID,P.Position,P.Clientid,P.ExpirDate
	FROM dbo.Pallet P
	WHERE P.IsFood = 1 AND getdate() <= P.ExpirDate AND (DATEDIFF(day,CONVERT(VARCHAR(10), getdate(), 111),CONVERT(VARCHAR(10), P.ExpirDate, 111)) <= 30))
 begin
	SELECT P.PalletID,P.WarehouseID,P.Position,P.Clientid,P.ExpirDate
	FROM dbo.Pallet P
	WHERE P.IsFood = 1 AND getdate() <= P.ExpirDate AND (DATEDIFF(day,CONVERT(VARCHAR(10), getdate(), 111),CONVERT(VARCHAR(10), P.ExpirDate, 111)) <= 30)
 end
else RAISERROR ('Error',15,1)
END

go 
------------------------------------------------------------------------------------------------------------------------------
DROP PROCEDURE PalletIdle

GO

CREATE PROCEDURE PalletIdle
AS
BEGIN
IF EXISTS (	SELECT P.PalletID,P.WarehouseID,P.Position,P.Clientid,P.ImportDate
	FROM dbo.Pallet P
	WHERE (DATEDIFF(day,CONVERT(VARCHAR(10), P.ImportDate, 111),CONVERT(VARCHAR(10), getdate(), 111)) >= 30) AND ExportDate > GETDATE()) 
 begin
	SELECT P.PalletID,P.WarehouseID,P.Position,P.Clientid,P.ImportDate
	FROM dbo.Pallet P
	WHERE (DATEDIFF(day,CONVERT(VARCHAR(10), P.ImportDate, 111),CONVERT(VARCHAR(10), getdate(), 111)) >= 30 AND ExportDate > GETDATE())
 end
else RAISERROR ('Error',15,1)
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
		insert into dbo.LogFile(Date,Report)VALUES (GETDATE() , CONCAT ( 'User with username: ' , @username ,' has logged in.') )
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
	Return( @Capacity - @Items)
END

---------------------------------------------------------------------------------------------------------------------------------
go
DROP PROCEDURE SearchItemByClient


GO
CREATE PROCEDURE SearchItemByClient
@ClientID int
AS
BEGIN
 IF EXISTS (SELECT 	P.*												
FROM dbo.Pallet P
WHERE @ClientID = P.Clientid)
 begin
SELECT 	P.*												
FROM dbo.Pallet P
WHERE @ClientID = P.Clientid
 end
ELSE RAISERROR('Error',15,1)
END

go


DROP PROCEDURE SearchItemByPosition
go
CREATE PROCEDURE SearchItemByPosition
@position int
AS
BEGIN
IF EXISTS (SELECT 	P.*													
FROM dbo.Pallet P
WHERE @position = P.Position)
 begin
SELECT 	P.*													
FROM dbo.Pallet P
WHERE @position = P.Position
 end
 ELSE RAISERROR('Error',15,1)
END


--------------------------------------------------------------------------------------------------------------------

go
DROP PROCEDURE GetCost

go
CREATE PROCEDURE GetCost
@PalletID int
AS
BEGIN
IF EXISTS (	SELECT P.ExtraCost, P.BasicCost, P.TotalCost
	FROM dbo.Pallet P,DBO.Transactions t
	WHERE P.PalletID = @PalletID)
 begin
	SELECT P.ExtraCost, P.BasicCost, P.TotalCost
	FROM dbo.Pallet P,DBO.Transactions t
	WHERE P.PalletID = @PalletID
 end
 ELSE  RAISERROR('Error',15,1)
END

go
-------------------------------------------------------------------------------------------------------------------
DROP PROCEDURE InsertTrans
GO
CREATE PROCEDURE InsertTrans
@PalletID int,@price int , @SSN int
AS
BEGIN
	DECLARE @TransID int
	INSERT INTO dbo.Transactions(PalletID,Price,TransDate) VALUES (@ClientID,@price,getdate())
	SET @TransID = SCOPE_IDENTITY()
	insert into dbo.LogFile(Date,Report)VALUES (GETDATE() , CONCAT ( 'User with SSN ' , @ssn , ' has inserted a transaction with ID ' , @TransID , ' and price ' , @price) )
	RETURN @TransID
END

go