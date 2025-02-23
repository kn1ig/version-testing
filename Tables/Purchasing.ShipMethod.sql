SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [Purchasing].[ShipMethod](
	[ShipMethodID] [int] IDENTITY(1,1) NOT NULL,
	[Name] [dbo].[Name] NOT NULL,
	[ShipBase] [money] NOT NULL,
	[ShipRate] [money] NOT NULL,
	[rowguid] [uniqueidentifier] ROWGUIDCOL  NOT NULL,
	[ModifiedDate] [datetime] NOT NULL,
 CONSTRAINT [PK_ShipMethod_ShipMethodID] PRIMARY KEY CLUSTERED 
(
	[ShipMethodID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
ALTER TABLE [Purchasing].[ShipMethod] ADD  CONSTRAINT [DF_ShipMethod_ShipBase]  DEFAULT ((0.00)) FOR [ShipBase]
GO
ALTER TABLE [Purchasing].[ShipMethod] ADD  CONSTRAINT [DF_ShipMethod_ShipRate]  DEFAULT ((0.00)) FOR [ShipRate]
GO
ALTER TABLE [Purchasing].[ShipMethod] ADD  CONSTRAINT [DF_ShipMethod_rowguid]  DEFAULT (newid()) FOR [rowguid]
GO
ALTER TABLE [Purchasing].[ShipMethod] ADD  CONSTRAINT [DF_ShipMethod_ModifiedDate]  DEFAULT (getdate()) FOR [ModifiedDate]
GO
ALTER TABLE [Purchasing].[ShipMethod]  WITH CHECK ADD  CONSTRAINT [CK_ShipMethod_ShipBase] CHECK  (([ShipBase]>(0.00)))
GO
ALTER TABLE [Purchasing].[ShipMethod] CHECK CONSTRAINT [CK_ShipMethod_ShipBase]
GO
ALTER TABLE [Purchasing].[ShipMethod]  WITH CHECK ADD  CONSTRAINT [CK_ShipMethod_ShipRate] CHECK  (([ShipRate]>(0.00)))
GO
ALTER TABLE [Purchasing].[ShipMethod] CHECK CONSTRAINT [CK_ShipMethod_ShipRate]
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Primary key for ShipMethod records.' , @level0type=N'SCHEMA',@level0name=N'Purchasing', @level1type=N'TABLE',@level1name=N'ShipMethod', @level2type=N'COLUMN',@level2name=N'ShipMethodID'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Shipping company name.' , @level0type=N'SCHEMA',@level0name=N'Purchasing', @level1type=N'TABLE',@level1name=N'ShipMethod', @level2type=N'COLUMN',@level2name=N'Name'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Minimum shipping charge.' , @level0type=N'SCHEMA',@level0name=N'Purchasing', @level1type=N'TABLE',@level1name=N'ShipMethod', @level2type=N'COLUMN',@level2name=N'ShipBase'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Default constraint value of 0.0' , @level0type=N'SCHEMA',@level0name=N'Purchasing', @level1type=N'TABLE',@level1name=N'ShipMethod', @level2type=N'CONSTRAINT',@level2name=N'DF_ShipMethod_ShipBase'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Shipping charge per pound.' , @level0type=N'SCHEMA',@level0name=N'Purchasing', @level1type=N'TABLE',@level1name=N'ShipMethod', @level2type=N'COLUMN',@level2name=N'ShipRate'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Default constraint value of 0.0' , @level0type=N'SCHEMA',@level0name=N'Purchasing', @level1type=N'TABLE',@level1name=N'ShipMethod', @level2type=N'CONSTRAINT',@level2name=N'DF_ShipMethod_ShipRate'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'ROWGUIDCOL number uniquely identifying the record. Used to support a merge replication sample.' , @level0type=N'SCHEMA',@level0name=N'Purchasing', @level1type=N'TABLE',@level1name=N'ShipMethod', @level2type=N'COLUMN',@level2name=N'rowguid'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Default constraint value of NEWID()' , @level0type=N'SCHEMA',@level0name=N'Purchasing', @level1type=N'TABLE',@level1name=N'ShipMethod', @level2type=N'CONSTRAINT',@level2name=N'DF_ShipMethod_rowguid'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Date and time the record was last updated.' , @level0type=N'SCHEMA',@level0name=N'Purchasing', @level1type=N'TABLE',@level1name=N'ShipMethod', @level2type=N'COLUMN',@level2name=N'ModifiedDate'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Default constraint value of GETDATE()' , @level0type=N'SCHEMA',@level0name=N'Purchasing', @level1type=N'TABLE',@level1name=N'ShipMethod', @level2type=N'CONSTRAINT',@level2name=N'DF_ShipMethod_ModifiedDate'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Primary key (clustered) constraint' , @level0type=N'SCHEMA',@level0name=N'Purchasing', @level1type=N'TABLE',@level1name=N'ShipMethod', @level2type=N'CONSTRAINT',@level2name=N'PK_ShipMethod_ShipMethodID'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Shipping company lookup table.' , @level0type=N'SCHEMA',@level0name=N'Purchasing', @level1type=N'TABLE',@level1name=N'ShipMethod'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Check constraint [ShipBase] > (0.00)' , @level0type=N'SCHEMA',@level0name=N'Purchasing', @level1type=N'TABLE',@level1name=N'ShipMethod', @level2type=N'CONSTRAINT',@level2name=N'CK_ShipMethod_ShipBase'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Check constraint [ShipRate] > (0.00)' , @level0type=N'SCHEMA',@level0name=N'Purchasing', @level1type=N'TABLE',@level1name=N'ShipMethod', @level2type=N'CONSTRAINT',@level2name=N'CK_ShipMethod_ShipRate'