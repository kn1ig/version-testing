USE [AdventureWorks2019]
GO
/****** Object:  Schema [Purchasing]    Script Date: 1/21/2024 10:26:51 PM ******/
CREATE SCHEMA [Purchasing]
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Contains objects related to vendors and purchase orders.' , @level0type=N'SCHEMA',@level0name=N'Purchasing'
GO
