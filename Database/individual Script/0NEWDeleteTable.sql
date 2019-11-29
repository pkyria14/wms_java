
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
/****** Object:  Table [dbo].[Warehouse]    Script Date: 11/23/2019 10:35:11 AM ******/
DROP TABLE [dbo].[Warehouse]
GO
/****** Object:  Table [dbo].[TransPallet]    Script Date: 11/23/2019 10:35:11 AM ******/
DROP TABLE [dbo].[TransPallet]
GO
/****** Object:  Table [dbo].[Transactions]    Script Date: 11/23/2019 10:35:11 AM ******/
DROP TABLE [dbo].[Transactions]
GO
/****** Object:  Table [dbo].[Pallet]    Script Date: 11/23/2019 10:35:11 AM ******/
DROP TABLE [dbo].[Pallet]
GO
/****** Object:  Table [dbo].[LogFile]    Script Date: 11/23/2019 10:35:11 AM ******/
DROP TABLE [dbo].[LogFile]
GO
/****** Object:  Table [dbo].[Employee]    Script Date: 11/23/2019 10:35:11 AM ******/
DROP TABLE [dbo].[Employee]
GO
/****** Object:  Table [dbo].[Client]    Script Date: 11/23/2019 10:35:11 AM ******/
DROP TABLE [dbo].[Client]
GO
/****** Object:  Table [dbo].[Authentication]    Script Date: 11/23/2019 10:35:11 AM ******/
DROP TABLE [dbo].[Authentication]
GO
