USE [epl343_team2]
GO
ALTER TABLE [dbo].[Transactions] DROP CONSTRAINT [FK_trans_PalletID]
GO
ALTER TABLE [dbo].[Transactions] DROP CONSTRAINT [FK_trans_Client]
GO
ALTER TABLE [dbo].[Pallet] DROP CONSTRAINT [FK_Pallet_Warehouse]
GO
ALTER TABLE [dbo].[Pallet] DROP CONSTRAINT [FK_Pallet_Client]
GO
ALTER TABLE [dbo].[Authentication] DROP CONSTRAINT [FK_Auth_Employee]
GO
/****** Object:  Table [dbo].[Warehouse]    Script Date: 23/11/2019 00:19:17 ******/
DROP TABLE [dbo].[Warehouse]
GO
/****** Object:  Table [dbo].[Transactions]    Script Date: 23/11/2019 00:19:17 ******/
DROP TABLE [dbo].[Transactions]
GO
/****** Object:  Table [dbo].[Pallet]    Script Date: 23/11/2019 00:19:17 ******/
DROP TABLE [dbo].[Pallet]
GO
/****** Object:  Table [dbo].[LogFile]    Script Date: 23/11/2019 00:19:17 ******/
DROP TABLE [dbo].[LogFile]
GO
/****** Object:  Table [dbo].[Employee]    Script Date: 23/11/2019 00:19:18 ******/
DROP TABLE [dbo].[Employee]
GO
/****** Object:  Table [dbo].[Client]    Script Date: 23/11/2019 00:19:18 ******/
DROP TABLE [dbo].[Client]
GO
/****** Object:  Table [dbo].[Authentication]    Script Date: 23/11/2019 00:19:18 ******/
DROP TABLE [dbo].[Authentication]
GO
