/****** Object:  ForeignKey [FK_orders_orders]    Script Date: 11/27/2013 12:12:22 ******/
IF  EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_orders_orders]') AND parent_object_id = OBJECT_ID(N'[dbo].[orders]'))
ALTER TABLE [dbo].[orders] DROP CONSTRAINT [FK_orders_orders]
GO
/****** Object:  Table [dbo].[categories]    Script Date: 11/27/2013 12:12:22 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[categories]') AND type in (N'U'))
DROP TABLE [dbo].[categories]
GO
/****** Object:  Table [dbo].[orders]    Script Date: 11/27/2013 12:12:22 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[orders]') AND type in (N'U'))
DROP TABLE [dbo].[orders]
GO
/****** Object:  Table [dbo].[products]    Script Date: 11/27/2013 12:12:22 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[products]') AND type in (N'U'))
DROP TABLE [dbo].[products]
GO
/****** Object:  Table [dbo].[shopping_cart_items]    Script Date: 11/27/2013 12:12:22 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[shopping_cart_items]') AND type in (N'U'))
DROP TABLE [dbo].[shopping_cart_items]
GO
/****** Object:  Table [dbo].[shopping_carts]    Script Date: 11/27/2013 12:12:22 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[shopping_carts]') AND type in (N'U'))
DROP TABLE [dbo].[shopping_carts]
GO
/****** Object:  Default [DF_categories_parent_id]    Script Date: 11/27/2013 12:12:22 ******/
IF  EXISTS (SELECT * FROM sys.default_constraints WHERE object_id = OBJECT_ID(N'[dbo].[DF_categories_parent_id]') AND parent_object_id = OBJECT_ID(N'[dbo].[categories]'))
Begin
IF  EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[DF_categories_parent_id]') AND type = 'D')
BEGIN
ALTER TABLE [dbo].[categories] DROP CONSTRAINT [DF_categories_parent_id]
END


End
GO
/****** Object:  Default [DF_products_featured]    Script Date: 11/27/2013 12:12:22 ******/
IF  EXISTS (SELECT * FROM sys.default_constraints WHERE object_id = OBJECT_ID(N'[dbo].[DF_products_featured]') AND parent_object_id = OBJECT_ID(N'[dbo].[products]'))
Begin
IF  EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[DF_products_featured]') AND type = 'D')
BEGIN
ALTER TABLE [dbo].[products] DROP CONSTRAINT [DF_products_featured]
END


End
GO
/****** Object:  Default [DF_products_on_sale]    Script Date: 11/27/2013 12:12:22 ******/
IF  EXISTS (SELECT * FROM sys.default_constraints WHERE object_id = OBJECT_ID(N'[dbo].[DF_products_on_sale]') AND parent_object_id = OBJECT_ID(N'[dbo].[products]'))
Begin
IF  EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[DF_products_on_sale]') AND type = 'D')
BEGIN
ALTER TABLE [dbo].[products] DROP CONSTRAINT [DF_products_on_sale]
END


End
GO
/****** Object:  Table [dbo].[shopping_carts]    Script Date: 11/27/2013 12:12:22 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[shopping_carts]') AND type in (N'U'))
BEGIN
CREATE TABLE [dbo].[shopping_carts](
	[cart_id] [int] IDENTITY(1,1) NOT NULL,
	[session_id] [nchar](25) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL
)
END
GO
/****** Object:  Table [dbo].[shopping_cart_items]    Script Date: 11/27/2013 12:12:22 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[shopping_cart_items]') AND type in (N'U'))
BEGIN
CREATE TABLE [dbo].[shopping_cart_items](
	[cart_id] [int] NOT NULL,
	[product_id] [int] NOT NULL,
	[qty] [int] NOT NULL
)
END
GO
/****** Object:  Table [dbo].[products]    Script Date: 11/27/2013 12:12:22 ******/
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
INSERT [dbo].[products] ([product_id], [category_id], [product_code], [product_name], [price], [featured], [on_sale]) VALUES (1, 4, N'70D-body  ', N'Canon EOS 70D DSLR Camera (Body Only)             ', CAST(1199.00 AS Numeric(6, 2)), N'0', N'0')
INSERT [dbo].[products] ([product_id], [category_id], [product_code], [product_name], [price], [featured], [on_sale]) VALUES (2, 4, N'T2i-kit   ', N'Canon EOS Rebel T2i EF-S 18-55IS II Kit           ', CAST(699.99 AS Numeric(6, 2)), N'0', N'0')
INSERT [dbo].[products] ([product_id], [category_id], [product_code], [product_name], [price], [featured], [on_sale]) VALUES (14, 4, N'EOS-M     ', N'Canon EOS-M Mirrorless Digital Camera             ', CAST(599.00 AS Numeric(6, 2)), N'0', N'0')
INSERT [dbo].[products] ([product_id], [category_id], [product_code], [product_name], [price], [featured], [on_sale]) VALUES (15, 5, N'3558B002  ', N'Canon EF-S 18-135mm f/3.5-5.6 IS Lens             ', CAST(499.00 AS Numeric(6, 2)), N'0', N'0')
INSERT [dbo].[products] ([product_id], [category_id], [product_code], [product_name], [price], [featured], [on_sale]) VALUES (16, 5, N'2514A002  ', N'NULLCanon EF 50mm f/1.8 II Lens                   ', CAST(125.00 AS Numeric(6, 2)), N'0', N'0')
SET IDENTITY_INSERT [dbo].[products] OFF
/****** Object:  Table [dbo].[orders]    Script Date: 11/27/2013 12:12:22 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[orders]') AND type in (N'U'))
BEGIN
CREATE TABLE [dbo].[orders](
	[order_id] [int] IDENTITY(1,1) NOT NULL,
	[last_name] [nchar](255) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[first_name] [nchar](255) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[address] [nchar](255) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[address_2] [nchar](255) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[city] [nchar](255) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[state] [nchar](2) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[zip] [int] NOT NULL,
	[phone_number] [nchar](255) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[email] [nchar](255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[shopping_cart_id] [int] NOT NULL,
	[auth_code] [nchar](12) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
 CONSTRAINT [PK_orders] PRIMARY KEY CLUSTERED 
(
	[order_id] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON)
)
END
GO
/****** Object:  Table [dbo].[categories]    Script Date: 11/27/2013 12:12:22 ******/
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
INSERT [dbo].[categories] ([category_id], [category_code], [category_name], [category_description], [parent_id]) VALUES (1, N'camera    ', N'Cameras                       ', NULL, N'0         ')
INSERT [dbo].[categories] ([category_id], [category_code], [category_name], [category_description], [parent_id]) VALUES (4, N'body      ', N'Body                          ', NULL, N'1         ')
INSERT [dbo].[categories] ([category_id], [category_code], [category_name], [category_description], [parent_id]) VALUES (5, N'lens      ', N'Lenses                        ', NULL, N'1         ')
SET IDENTITY_INSERT [dbo].[categories] OFF
/****** Object:  Default [DF_categories_parent_id]    Script Date: 11/27/2013 12:12:22 ******/
IF Not EXISTS (SELECT * FROM sys.default_constraints WHERE object_id = OBJECT_ID(N'[dbo].[DF_categories_parent_id]') AND parent_object_id = OBJECT_ID(N'[dbo].[categories]'))
Begin
IF NOT EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[DF_categories_parent_id]') AND type = 'D')
BEGIN
ALTER TABLE [dbo].[categories] ADD  CONSTRAINT [DF_categories_parent_id]  DEFAULT ((0)) FOR [parent_id]
END


End
GO
/****** Object:  Default [DF_products_featured]    Script Date: 11/27/2013 12:12:22 ******/
IF Not EXISTS (SELECT * FROM sys.default_constraints WHERE object_id = OBJECT_ID(N'[dbo].[DF_products_featured]') AND parent_object_id = OBJECT_ID(N'[dbo].[products]'))
Begin
IF NOT EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[DF_products_featured]') AND type = 'D')
BEGIN
ALTER TABLE [dbo].[products] ADD  CONSTRAINT [DF_products_featured]  DEFAULT ((0)) FOR [featured]
END


End
GO
/****** Object:  Default [DF_products_on_sale]    Script Date: 11/27/2013 12:12:22 ******/
IF Not EXISTS (SELECT * FROM sys.default_constraints WHERE object_id = OBJECT_ID(N'[dbo].[DF_products_on_sale]') AND parent_object_id = OBJECT_ID(N'[dbo].[products]'))
Begin
IF NOT EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[DF_products_on_sale]') AND type = 'D')
BEGIN
ALTER TABLE [dbo].[products] ADD  CONSTRAINT [DF_products_on_sale]  DEFAULT ((0)) FOR [on_sale]
END


End
GO
/****** Object:  ForeignKey [FK_orders_orders]    Script Date: 11/27/2013 12:12:22 ******/
IF NOT EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_orders_orders]') AND parent_object_id = OBJECT_ID(N'[dbo].[orders]'))
ALTER TABLE [dbo].[orders]  WITH CHECK ADD  CONSTRAINT [FK_orders_orders] FOREIGN KEY([order_id])
REFERENCES [dbo].[orders] ([order_id])
GO
IF  EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_orders_orders]') AND parent_object_id = OBJECT_ID(N'[dbo].[orders]'))
ALTER TABLE [dbo].[orders] CHECK CONSTRAINT [FK_orders_orders]
GO
