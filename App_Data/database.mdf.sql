/****** Object:  Table [dbo].[categories]    Script Date: 11/07/2013 23:52:18 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[categories]') AND type in (N'U'))
DROP TABLE [dbo].[categories]
GO
/****** Object:  Table [dbo].[products]    Script Date: 11/07/2013 23:52:18 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[products]') AND type in (N'U'))
DROP TABLE [dbo].[products]
GO
/****** Object:  Default [DF_categories_parent_id]    Script Date: 11/07/2013 23:52:18 ******/
IF  EXISTS (SELECT * FROM sys.default_constraints WHERE object_id = OBJECT_ID(N'[dbo].[DF_categories_parent_id]') AND parent_object_id = OBJECT_ID(N'[dbo].[categories]'))
Begin
IF  EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[DF_categories_parent_id]') AND type = 'D')
BEGIN
ALTER TABLE [dbo].[categories] DROP CONSTRAINT [DF_categories_parent_id]
END


End
GO
/****** Object:  Default [DF_products_featured]    Script Date: 11/07/2013 23:52:18 ******/
IF  EXISTS (SELECT * FROM sys.default_constraints WHERE object_id = OBJECT_ID(N'[dbo].[DF_products_featured]') AND parent_object_id = OBJECT_ID(N'[dbo].[products]'))
Begin
IF  EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[DF_products_featured]') AND type = 'D')
BEGIN
ALTER TABLE [dbo].[products] DROP CONSTRAINT [DF_products_featured]
END


End
GO
/****** Object:  Default [DF_products_on_sale]    Script Date: 11/07/2013 23:52:18 ******/
IF  EXISTS (SELECT * FROM sys.default_constraints WHERE object_id = OBJECT_ID(N'[dbo].[DF_products_on_sale]') AND parent_object_id = OBJECT_ID(N'[dbo].[products]'))
Begin
IF  EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[DF_products_on_sale]') AND type = 'D')
BEGIN
ALTER TABLE [dbo].[products] DROP CONSTRAINT [DF_products_on_sale]
END


End
GO
/****** Object:  Table [dbo].[products]    Script Date: 11/07/2013 23:52:18 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[products]') AND type in (N'U'))
BEGIN
CREATE TABLE [dbo].[products](
	[product_id] [int] IDENTITY(1,1) NOT NULL,
	[category_id] [int] NOT NULL,
	[product_code] [char](10) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[product_name] [char](50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[price] [numeric](6, 2) NULL,
	[featured] [char](1) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[on_sale] [char](1) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL
)
END
GO
SET IDENTITY_INSERT [dbo].[products] ON
INSERT [dbo].[products] ([product_id], [category_id], [product_code], [product_name], [price], [featured], [on_sale]) VALUES (1, 4, N'PROD1     ', N'Product 1                                         ', CAST(19.99 AS Numeric(6, 2)), N'0', N'0')
INSERT [dbo].[products] ([product_id], [category_id], [product_code], [product_name], [price], [featured], [on_sale]) VALUES (2, 4, N'PROD2     ', N'Product 2                                         ', CAST(29.99 AS Numeric(6, 2)), N'0', N'0')
SET IDENTITY_INSERT [dbo].[products] OFF
/****** Object:  Table [dbo].[categories]    Script Date: 11/07/2013 23:52:18 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[categories]') AND type in (N'U'))
BEGIN
CREATE TABLE [dbo].[categories](
	[category_id] [int] IDENTITY(1,1) NOT NULL,
	[category_code] [char](10) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[category_name] [char](30) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[category_description] [nchar](10) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[parent_id] [nchar](10) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL
)
END
GO
SET IDENTITY_INSERT [dbo].[categories] ON
INSERT [dbo].[categories] ([category_id], [category_code], [category_name], [category_description], [parent_id]) VALUES (1, N'cat1      ', N'Category 1                    ', NULL, N'0         ')
INSERT [dbo].[categories] ([category_id], [category_code], [category_name], [category_description], [parent_id]) VALUES (2, N'cat2      ', N'Category 2                    ', NULL, N'0         ')
INSERT [dbo].[categories] ([category_id], [category_code], [category_name], [category_description], [parent_id]) VALUES (3, N'cat3      ', N'Category 3                    ', NULL, N'0         ')
INSERT [dbo].[categories] ([category_id], [category_code], [category_name], [category_description], [parent_id]) VALUES (4, N'subcat1   ', N'Sub Category 1                ', NULL, N'1         ')
INSERT [dbo].[categories] ([category_id], [category_code], [category_name], [category_description], [parent_id]) VALUES (5, N'subcat2   ', N'Sub Category 2                ', NULL, N'1         ')
SET IDENTITY_INSERT [dbo].[categories] OFF
/****** Object:  Default [DF_categories_parent_id]    Script Date: 11/07/2013 23:52:18 ******/
IF Not EXISTS (SELECT * FROM sys.default_constraints WHERE object_id = OBJECT_ID(N'[dbo].[DF_categories_parent_id]') AND parent_object_id = OBJECT_ID(N'[dbo].[categories]'))
Begin
IF NOT EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[DF_categories_parent_id]') AND type = 'D')
BEGIN
ALTER TABLE [dbo].[categories] ADD  CONSTRAINT [DF_categories_parent_id]  DEFAULT ((0)) FOR [parent_id]
END


End
GO
/****** Object:  Default [DF_products_featured]    Script Date: 11/07/2013 23:52:18 ******/
IF Not EXISTS (SELECT * FROM sys.default_constraints WHERE object_id = OBJECT_ID(N'[dbo].[DF_products_featured]') AND parent_object_id = OBJECT_ID(N'[dbo].[products]'))
Begin
IF NOT EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[DF_products_featured]') AND type = 'D')
BEGIN
ALTER TABLE [dbo].[products] ADD  CONSTRAINT [DF_products_featured]  DEFAULT ((0)) FOR [featured]
END


End
GO
/****** Object:  Default [DF_products_on_sale]    Script Date: 11/07/2013 23:52:18 ******/
IF Not EXISTS (SELECT * FROM sys.default_constraints WHERE object_id = OBJECT_ID(N'[dbo].[DF_products_on_sale]') AND parent_object_id = OBJECT_ID(N'[dbo].[products]'))
Begin
IF NOT EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[DF_products_on_sale]') AND type = 'D')
BEGIN
ALTER TABLE [dbo].[products] ADD  CONSTRAINT [DF_products_on_sale]  DEFAULT ((0)) FOR [on_sale]
END


End
GO
