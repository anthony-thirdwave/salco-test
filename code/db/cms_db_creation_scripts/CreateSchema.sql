IF NOT EXISTS (SELECT * FROM sys.database_principals WHERE name = N'3w_customRole' AND type = 'R')
CREATE ROLE [3w_customRole]
GO
IF NOT EXISTS (SELECT * FROM sys.database_principals WHERE name = N'cfmx')
CREATE USER [cfmx] FOR LOGIN [cfmx] WITH DEFAULT_SCHEMA=[cfmx]
GO
IF NOT EXISTS (SELECT * FROM sys.schemas WHERE name = N'cfmx')
EXEC sys.sp_executesql N'CREATE SCHEMA [cfmx] AUTHORIZATION [cfmx]'

GO
IF NOT EXISTS (SELECT * FROM sys.schemas WHERE name = N'3w_customRole')
EXEC sys.sp_executesql N'CREATE SCHEMA [3w_customRole] AUTHORIZATION [3w_customRole]'


/********************************************************
For the following code to execute, the user running this script must be a
member of the sysadmin fixed server role.

Comment out the code and add roles manually if installing user is not a member
of the sysadmin role.
*/

-- add cfmx as a 3w_customRole, db_datawriter and db_datareader rolemember
GO
EXEC sp_addrolemember '3w_customRole', 'cfmx'
GO
EXEC sp_addrolemember 'db_datawriter', 'cfmx'
GO
EXEC sp_addrolemember 'db_datareader', 'cfmx'


-- end sysadmin requirement
--*******************************************************



GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[t_Bulletin]') AND type in (N'U'))
BEGIN
CREATE TABLE [dbo].[t_Bulletin](
	[bulletinID] [int] IDENTITY(1,1) NOT NULL,
	[Message] [varchar](128) NOT NULL,
	[PostDate] [datetime] NOT NULL CONSTRAINT [DF_t_Bulletin_PostDate] DEFAULT CURRENT_TIMESTAMP,
 CONSTRAINT [PK_t_Bulletin] PRIMARY KEY CLUSTERED 
(
	[bulletinID] ASC
)WITH (IGNORE_DUP_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
END
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[t_Category]') AND type in (N'U'))
BEGIN
CREATE TABLE [dbo].[t_Category](
	[CategoryID] [int] IDENTITY(1,1) NOT NULL,
	[CategoryTypeID] [int] NOT NULL,
	[CategoryName] [varchar](128) NOT NULL,
	[CategoryAlias] [varchar](128) NOT NULL,
	[ParentID] [int] NOT NULL,
	[DisplayLevel] [int] NOT NULL,
	[DisplayOrder] [varchar](1000) NULL,
	[CategoryActive] [bit] NOT NULL,
	[ShowInNavigation] [bit] NOT NULL,
	[CategoryIndexed] [bit] NOT NULL,
	[CategoryPriority] [int] NULL,
	[CategoryURL] [varchar](512) NULL,
	[PropertiesID] [int] NULL,
	[WorkflowStatusID] [int] NULL,
	[TemplateID] [int] NULL,
	[CacheDateTime] [datetime] NULL,
	[SourceID] [int] NULL,
 CONSTRAINT [PK_t_Category] PRIMARY KEY CLUSTERED 
(
	[CategoryID] ASC
)WITH (IGNORE_DUP_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
END
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[t_CategoryLocale]') AND type in (N'U'))
BEGIN
CREATE TABLE [dbo].[t_CategoryLocale](
	[CategoryLocaleID] [int] IDENTITY(1,1) NOT NULL,
	[CategoryID] [int] NULL,
	[CategoryLocaleActive] [bit] NULL,
	[CategoryLocaleName] [nvarchar](128) NULL,
	[CategoryLocaleURL] [varchar](128) NULL,
	[LocaleID] [int] NULL,
	[PropertiesID] [int] NULL,
	[DefaultCategoryLocale] [bit] NULL,
 CONSTRAINT [PK_t_CategoryLocale] PRIMARY KEY CLUSTERED 
(
	[CategoryLocaleID] ASC
)WITH (IGNORE_DUP_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
END
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[t_CategoryLocaleMeta]') AND type in (N'U'))
BEGIN
CREATE TABLE [dbo].[t_CategoryLocaleMeta](
	[CategoryID] [int] NOT NULL,
	[LocaleID] [int] NOT NULL,
	[CategoryLocalePriority] [int] NULL,
	[CategoryLocaleDisplayOrder] [varchar](1000) NULL,
 CONSTRAINT [PK_t_CategoryLocalePlacement] PRIMARY KEY CLUSTERED 
(
	[CategoryID] ASC,
	[LocaleID] ASC
)WITH (IGNORE_DUP_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
END
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[t_Content]') AND type in (N'U'))
BEGIN
CREATE TABLE [dbo].[t_Content](
	[ContentID] [int] IDENTITY(1,1) NOT NULL,
	[CategoryID] [int] NULL,
	[ContentName] [varchar](128) NULL,
	[ContentTypeID] [int] NOT NULL,
	[ContentPriority] [int] NULL,
	[ContentActive] [bit] NOT NULL,
	[ContentIndexed] [bit] NOT NULL,
	[SourceID] [int] NULL,
	[EntryID] [int] NULL,
	[PropertiesID] [int] NULL,
	[InheritID] [int] NULL,
	[ContentDate1] [datetime] NULL,
	[ContentDate2] [datetime] NULL,
 CONSTRAINT [PK_t_Content] PRIMARY KEY CLUSTERED 
(
	[ContentID] ASC
)WITH (IGNORE_DUP_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
END
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[t_ContentLocale]') AND type in (N'U'))
BEGIN
CREATE TABLE [dbo].[t_ContentLocale](
	[ContentLocaleID] [int] IDENTITY(1,1) NOT NULL,
	[ContentID] [int] NULL,
	[ContentLocaleActive] [bit] NULL,
	[ContentLocaleName] [nvarchar](1000) NULL,
	[LocaleID] [int] NULL,
	[ContentBody] [ntext] NULL,
	[PropertiesID] [int] NULL,
	[DefaultContentLocale] [bit] NULL,
 CONSTRAINT [PK_t_ContentLocale] PRIMARY KEY CLUSTERED 
(
	[ContentLocaleID] ASC
)WITH (IGNORE_DUP_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
END
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[t_ContentLocaleMeta]') AND type in (N'U'))
BEGIN
CREATE TABLE [dbo].[t_ContentLocaleMeta](
	[ContentID] [int] NOT NULL,
	[LocaleID] [int] NOT NULL,
	[ContentLocalePriority] [int] NULL,
	[ContentPositionID] [int] NULL,
 CONSTRAINT [PK_t_ContentLocaleMeta] PRIMARY KEY CLUSTERED 
(
	[ContentID] ASC,
	[LocaleID] ASC
)WITH (IGNORE_DUP_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
END
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[t_ContentNote]') AND type in (N'U'))
BEGIN
CREATE TABLE [dbo].[t_ContentNote](
	[ContentNoteID] [int] IDENTITY(1,1) NOT NULL,
	[ContentID] [int] NULL,
	[UserID] [int] NULL,
	[ContentNote] [text] NULL,
	[ContentNoteDate] [datetime] NULL,
 CONSTRAINT [PK_t_ContentNote] PRIMARY KEY CLUSTERED 
(
	[ContentNoteID] ASC
)WITH (IGNORE_DUP_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
END
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[t_Country]') AND type in (N'U'))
BEGIN
CREATE TABLE [dbo].[t_Country](
	[CountryID] [int] IDENTITY(1,1) NOT NULL,
	[CountryCode] [char](2) NULL,
	[CountryName] [varchar](64) NULL,
	[Priority] [int] NULL,
 CONSTRAINT [PK_t_Country] PRIMARY KEY CLUSTERED 
(
	[CountryID] ASC
)WITH (IGNORE_DUP_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
END
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[t_Group]') AND type in (N'U'))
BEGIN
CREATE TABLE [dbo].[t_Group](
	[groupId] [int] IDENTITY(1,1) NOT NULL,
	[groupAlias] [nvarchar](100) NOT NULL,
	[groupDescription] [nvarchar](2000) NULL,
	[groupByTable] [nvarchar](100) NULL,
	[groupByColumn] [nvarchar](100) NULL,
	[groupById] [int] NULL,
	[groupDateDisabled] [datetime] NULL,
	[groupIsMaster] [tinyint] NOT NULL DEFAULT (0),
 CONSTRAINT [PK_t_Group] PRIMARY KEY CLUSTERED 
(
	[groupId] ASC
)WITH (IGNORE_DUP_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
END
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[t_GroupedElem]') AND type in (N'U'))
BEGIN
CREATE TABLE [dbo].[t_GroupedElem](
	[id] [int] IDENTITY(1,1) NOT NULL,
	[groupId] [int] NOT NULL,
	[groupedElemTable] [nvarchar](100) NULL,
	[groupedElemColumn] [nvarchar](100) NULL,
	[groupedElemId] [int] NULL,
	[groupedElemDisabledDate] [datetime] NULL,
	[groupedElemDisplayType] [nvarchar](100) NULL,
	[groupedElemType] [nvarchar](100) NULL,
	[groupedElemLabel] [nvarchar](2000) NULL,
	[groupedElemValue] [nvarchar](2000) NULL,
	[groupedElemPublicId] [nvarchar](33) NOT NULL,
	[rank] [int] NOT NULL,
	[horizontalRank] [int] NULL,
 CONSTRAINT [PK_t_GroupedElem] PRIMARY KEY CLUSTERED 
(
	[id] ASC
)WITH (IGNORE_DUP_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
END
GO
ALTER TABLE [dbo].[t_GroupedElem]  WITH CHECK ADD CONSTRAINT [FK_t_GroupedElem_t_Group] FOREIGN KEY([groupId])
REFERENCES [dbo].[t_Group] ([groupId])
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[t_Label]') AND type in (N'U'))
BEGIN
CREATE TABLE [dbo].[t_Label](
	[LabelID] [int] NOT NULL,
	[LabelCode] [varchar](32) NULL,
	[LabelName] [varchar](128) NULL,
	[LabelGroupID] [int] NULL,
	[LabelPriority] [int] NULL,
	[LabelImage] [varchar](255) NULL,
	[LabelParent] [bit] NULL CONSTRAINT [DF_t_Label_LabelParent]  DEFAULT (0),
 CONSTRAINT [PK_t_Label] PRIMARY KEY CLUSTERED 
(
	[LabelID] ASC
)WITH (IGNORE_DUP_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
END
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[t_LabelLanguage]') AND type in (N'U'))
BEGIN
CREATE TABLE [dbo].[t_LabelLanguage](
	[LabelID] [int] NOT NULL,
	[LabelLanguageID] [int] NOT NULL,
	[LabelLanguageName] [nvarchar](128) NULL,
 CONSTRAINT [PK_t_LabelLanguage] PRIMARY KEY CLUSTERED 
(
	[LabelID] ASC,
	[LabelLanguageID] ASC
)WITH (IGNORE_DUP_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
END
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[t_Mime]') AND type in (N'U'))
BEGIN
CREATE TABLE [dbo].[t_Mime](
	[MimeID] [int] IDENTITY(1,1) NOT NULL,
	[MimeMediaTypeID] [int] NULL,
	[MimeSubtype] [varchar](128) NULL,
	[MimeDescription] [varchar](255) NULL,
	[MimeIconPath] [varchar](255) NULL,
 CONSTRAINT [PK_t_Mime] PRIMARY KEY CLUSTERED 
(
	[MimeID] ASC
)WITH (IGNORE_DUP_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
END
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[t_MimeExtensions]') AND type in (N'U'))
BEGIN
CREATE TABLE [dbo].[t_MimeExtensions](
	[MimeExtID] [int] IDENTITY(1,1) NOT NULL,
	[MimeID] [int] NULL,
	[MimeExtension] [varchar](5) NULL,
 CONSTRAINT [PK_t_MimeExtensions] PRIMARY KEY CLUSTERED 
(
	[MimeExtID] ASC
)WITH (IGNORE_DUP_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
END
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[t_Permissions]') AND type in (N'U'))
BEGIN
CREATE TABLE [dbo].[t_Permissions](
	[UserGroupID] [int] NOT NULL,
	[CategoryID] [int] NOT NULL,
	[pRead] [bit] NULL,
	[pCreate] [bit] NULL,
	[pEdit] [bit] NULL,
	[pDelete] [bit] NULL,
	[pSaveLive] [bit] NULL,
	[pManage] [bit] NULL,
 CONSTRAINT [PK_t_Permissions] PRIMARY KEY CLUSTERED 
(
	[UserGroupID] ASC,
	[CategoryID] ASC
)WITH (IGNORE_DUP_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
END
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[t_Properties]') AND type in (N'U'))
BEGIN
CREATE TABLE [dbo].[t_Properties](
	[PropertiesID] [int] IDENTITY(1,1) NOT NULL,
	[PropertiesPacket] [text] NULL,
 CONSTRAINT [PK_t_Properties] PRIMARY KEY CLUSTERED 
(
	[PropertiesID] ASC
)WITH (IGNORE_DUP_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
END
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[t_RewriteType]') AND type in (N'U'))
BEGIN
CREATE TABLE [dbo].[t_RewriteType](
	[RewriteTypeId] [int] IDENTITY(1,1) NOT NULL,
	[Name] [varchar](200) NOT NULL,
	[Alias] [varchar](200) NOT NULL,
	[Description] [varchar](2000) NULL,
	[SourcePrefix] [varchar](200) NULL,
	[SourceSuffix] [varchar](200) NULL,
	[AllowSource] [tinyint] NOT NULL,
	[SourceMustBeUnique] [tinyint] NOT NULL,
	[SourceIsPath] [tinyint] NOT NULL,
	[SourceNotNull] [tinyint] NOT NULL,
	[DestinationPrefix] [varchar](200) NULL,
	[DestinationSuffix] [varchar](200) NULL,
	[AllowDestination] [tinyint] NOT NULL,
	[DestinationMustBeUnique] [tinyint] NOT NULL,
	[DestinationIsPath] [tinyint] NOT NULL,
	[DestinationNotNull] [tinyint] NOT NULL,
	[Flag] [varchar](200) NULL,
	[PublicId] [varchar](33) NOT NULL,
	[Priority] [int] NOT NULL,
 CONSTRAINT [PK_t_RewriteType] PRIMARY KEY CLUSTERED 
(
	[RewriteTypeID] ASC
)WITH (IGNORE_DUP_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
END
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[t_RewriteUrl]') AND type in (N'U'))
BEGIN
CREATE TABLE [dbo].[t_RewriteUrl](
	[RewriteUrlId] [int] IDENTITY(1,1) NOT NULL,
	[SourceUrl] [varchar](500) NULL,
	[DestinationUrl] [varchar](500) NULL,
	[RewriteTypeId] [int] NOT NULL,
	[DateStart] [datetime] NULL,
	[DateEnd] [datetime] NULL,
	[PublicId] [varchar](33) NOT NULL,
	[Priority] [int] NOT NULL,
 CONSTRAINT [PK_t_RewriteUrl] PRIMARY KEY CLUSTERED 
(
	[RewriteUrlID] ASC
)WITH (IGNORE_DUP_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
END
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[t_Security]') AND type in (N'U'))
BEGIN
CREATE TABLE [dbo].[t_Security](
	[SecurityID] [int] IDENTITY(1,1) NOT NULL,
	[CategoryID] [int] NOT NULL,
	[LocaleID] [int] NOT NULL,
	[LoginAlias] [varchar](128) NOT NULL,
	[AuthActivityCode] [varchar](128) NOT NULL,
	[Admin] [bit] NOT NULL CONSTRAINT [DF_t_Security_Admin]  DEFAULT (0),
	[SecurityMessage] [varchar](2000) NULL,
	[MembersOnly] [bit] NULL CONSTRAINT [DF_t_Security_MembersOnly]  DEFAULT (1),
 CONSTRAINT [PK_t_Security] PRIMARY KEY CLUSTERED 
(
	[SecurityID] ASC
)WITH (IGNORE_DUP_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
END
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[t_StateProvince]') AND type in (N'U'))
BEGIN
CREATE TABLE [dbo].[t_StateProvince](
	[StateProvinceID] [int] IDENTITY(1,1) NOT NULL,
	[StateProvinceCode] [varchar](4) NULL,
	[StateProvinceName] [varchar](64) NULL,
	[CountryCode] [char](2) NULL,
	[Priority] [int] NULL,
 CONSTRAINT [PK_t_StateProvince] PRIMARY KEY CLUSTERED 
(
	[StateProvinceID] ASC
)WITH (IGNORE_DUP_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
END
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[t_Tracking]') AND type in (N'U'))
BEGIN
CREATE TABLE [dbo].[t_Tracking](
	[TrackingID] [int] IDENTITY(1,1) NOT NULL,
	[UserID] [varchar](10) NULL,
	[Entity] [varchar](64) NULL,
	[KeyID] [int] NULL,
	[TrackingDateTime] [datetime] NULL,
	[OperationID] [int] NULL,
	[EntityName] [nvarchar](1000) NULL,
 CONSTRAINT [PK_t_Tracking] PRIMARY KEY CLUSTERED 
(
	[TrackingID] ASC
)WITH (IGNORE_DUP_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
END
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[t_User]') AND type in (N'U'))
BEGIN
CREATE TABLE [dbo].[t_User](
	[UserID] [int] IDENTITY(1,1) NOT NULL,
	[LocaleID] [int] NULL,
	[FirstName] [nvarchar](64) NULL,
	[MiddleName] [nvarchar](64) NULL,
	[LastName] [nvarchar](64) NULL,
	[Title] [nvarchar](64) NULL,
	[OrganizationName] [nvarchar](64) NULL,
	[UserLogin] [varchar](16) NULL,
	[UserPassword] [varchar](16) NULL,
	[EmailAddress] [varchar](128) NULL,
	[PhoneNumber] [varchar](24) NULL,
	[DayPhoneNumber] [varchar](24) NULL,
	[FaxNumber] [varchar](24) NULL,
	[MailingList] [bit] NULL,
	[Browser] [varchar](128) NULL,
	[RemoteHost] [varchar](16) NULL,
	[DisableRichControls] [bit] NULL CONSTRAINT [DF_t_User_DisableRichControls]  DEFAULT (0),
	[DateAdded] [datetime] NULL CONSTRAINT [DF_t_User_DateAdded]  DEFAULT (getDate()),
	[DateModified] [datetime] NULL,
	[DashboardModuleIDList] [varchar](128) NULL,
	[OwnerEmailNotifications] [bit] NULL,
 CONSTRAINT [PK_t_User] PRIMARY KEY CLUSTERED 
(
	[UserID] ASC
)WITH (IGNORE_DUP_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
END
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[t_UserGroup]') AND type in (N'U'))
BEGIN
CREATE TABLE [dbo].[t_UserGroup](
	[UserID] [int] NOT NULL,
	[UserGroupID] [int] NOT NULL,
 CONSTRAINT [PK_t_UserGroup] PRIMARY KEY CLUSTERED 
(
	[UserID] ASC,
	[UserGroupID] ASC
)WITH (IGNORE_DUP_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
END
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[t_WorkflowRequest]') AND type in (N'U'))
BEGIN
CREATE TABLE [dbo].[t_WorkflowRequest](
	[WorkflowRequestID] [int] IDENTITY(1,1) NOT NULL,
	[WorkflowRequestTypeID] [int] NULL,
	[WorkflowRequestDateTime] [datetime] NULL,
	[FromUserID] [int] NULL,
	[CategoryID] [int] NULL,
	[LocaleID] [int] NULL,
	[Message] [ntext] NULL,
	[Dismissed] [bit] NULL CONSTRAINT [DF_t_WorkflowRequest_Dismissed]  DEFAULT (0),
 CONSTRAINT [PK_t_WorkflowRequest] PRIMARY KEY CLUSTERED 
(
	[WorkflowRequestId] ASC
)WITH (IGNORE_DUP_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
END
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[t_WorkflowRequestRecipient]') AND type in (N'U'))
BEGIN
CREATE TABLE [dbo].[t_WorkflowRequestRecipient](
	[WorkflowRequestID] [int] NOT NULL,
	[UserID] [int] NOT NULL,
	[UserGroupID] [int] NOT NULL,
 CONSTRAINT [PK_t_WorkflowRequestRecipient] PRIMARY KEY CLUSTERED 
(
	[WorkflowRequestId] ASC,
	[UserID] ASC,
	[UserGroupID] ASC
)WITH (IGNORE_DUP_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
END
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[sp_GetCategoryContentTree]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'CREATE  Procedure [dbo].[sp_GetCategoryContentTree]
@showTabs BIT = 1
As
--@showTabs will indent the title based on the displayLevel number
IF @showTabs = 1
    BEGIN
	SELECT ''Category'' As Type, categoryID as ID, displayLevel, displayOrder, NULL As ContentPriority, categoryAlias As Alias,
	(''http://www.aiga.org/content.cfm?Alias='' + categoryAlias ) As WebLink,
	CASE displayLevel
	WHEN 0 THEN CategoryName
	WHEN NULL THEN CategoryName
	ELSE REPLACE(REPLICATE (char(9), displayLevel) + CategoryName,char(13)+char(10),'' : '')
	END As Title 
	FROM t_Category
	UNION
	SELECT ''Content'' As Type, contentID As ID, displayLevel + 1 As displayLevel, displayOrder, ContentPriority, ContentAlias As Alias,
	(''http://www.aiga.org/content.cfm?contentAlias='' + contentAlias ) As WebLink,
	CASE displayLevel+1
	WHEN 0 THEN ContentTitle
	WHEN NULL THEN ContentTitle
	ELSE REPLACE(REPLICATE (char(9), displayLevel+1) + ContentTitle,char(13)+char(10),'' : '')
	END As Title
	FROM qry_getContentCategory
	ORDER BY displayOrder, contentPriority
    END
ELSE
    BEGIN
	SELECT ''Category'' As Type, categoryID as ID, displayLevel,displayOrder, NULL As ContentPriority, categoryAlias As Alias, ''link'' As WebLink, CategoryName As Title 
	
	FROM t_Category
	UNION
	SELECT ''Content'' As Type, contentID As ID, displayLevel + 1 As displayLevel,displayOrder, ContentPriority, ContentAlias As Alias, ''link'' As WebLink, ContentTitle As Title
	
	FROM qry_getContentCategory
	ORDER BY displayOrder, contentPriority
    END
return
' 
END
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[sp_util_FindColumn]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [dbo].[sp_util_FindColumn]
@strColName VARCHAR(50)
AS
/*
This stored procedure will:
    1. Search through all tables, views and stored procedures to find a column name 
        you pass in.
    
    2. Also searchs views and stored procedures that use: SELECT *
    3. Returns 5 result sets:
	a. Tables containing column
	b. Stored procedures directly referencing column
	c. Stored procedures indirectly referencing column	
	d. Views directly referencing column
	e. Views indirectly referencing column	
*/
SET NOCOUNT ON
DECLARE @strSQL NVARCHAR(4000)
DECLARE @lngTableCount INTEGER
DECLARE @strTabName VARCHAR(50)
DECLARE @lngCounter INTEGER
--Create temp table to hold table names
CREATE TABLE #tTableNames
(numID INTEGER IDENTITY(1,1)
,strName VARCHAR(50)
)
--Create temp table to hold stored proc names
CREATE TABLE #tProcNames
(strName VARCHAR(50)
)
--Create temp table to hold view names
CREATE TABLE #tViewNames
(strName VARCHAR(50)
)
--Tables with column
SET @strSQL = ''SELECT so.name AS ''''Tables Containing Column: '' + @strColName + ''''''
FROM sysobjects so
INNER JOIN syscolumns sc
ON so.id = sc.id
WHERE sc.name = @strColName
ORDER BY so.name''
--Show table names
EXEC dbo.sp_executesql @strSQL,N''@strColName VARCHAR(50)'',@strColName = @strColName
--Insert table names into temp table
INSERT INTO #tTableNames (strName)
EXEC sp_executesql @strSQL,N''@strColName VARCHAR(50)'',@strColName = @strColName
SET @lngTableCount = @@ROWCOUNT
SET @lngCounter = @lngTableCount
--Stored procedures directly referencing column
SET @strSQL = ''SELECT so.name AS ''''Stored Procedures Directly Referencing Column: '' + @strColName + ''''''
FROM dbo.sysobjects so
INNER JOIN dbo.syscomments sc
ON so.id = sc.id
WHERE sc.text LIKE ''''%'' + @strColName + ''%''''
AND so.type = ''''P''''
ORDER BY so.name''
--Show stored procedure names
EXEC dbo.sp_executesql @strSQL,N''@strColName VARCHAR(50)'',@strColName = @strColName
--Stored procedures that may indirectly reference column
WHILE @lngCounter <> 0
BEGIN
      --Reset table name 
      SET @strTabName = (SELECT strName FROM #tTableNames WHERE numID = @lngTableCount)
      --Stored procedures indirectly referencing column
      SET @strSQL = ''SELECT so.name 
      FROM dbo.sysobjects so
      INNER JOIN dbo.syscomments sc
      ON so.id = sc.id
      WHERE ((sc.text LIKE ''''%SELECT *%''''
      OR sc.text LIKE ''''%.*%'''')
      AND sc.text LIKE ''''%'' + @strTabName + ''%''''
      AND sc.text NOT LIKE ''''%SELECT * from #%'''')
      AND so.type = ''''P''''
      ORDER BY so.name''
      --Show stored procedure names
      INSERT INTO #tProcNames
      EXEC dbo.sp_executesql @strSQL
      SET @lngCounter = @lngCounter - 1
END
--Show stored Procedure Names
SET @strSQL = ''SELECT DISTINCT strName AS ''''Stored Procedures That May Indirectly Reference Column: '' 
+ @strColName + ''''''
FROM #tProcNames''
EXEC dbo.sp_executesql @strSQL
--Views directly referencing column
SET @strSQL = ''SELECT so.name AS ''''Views Directly Referencing Column: '' + @strColName + ''''''
FROM dbo.sysobjects so
INNER JOIN dbo.syscomments sc
ON so.id = sc.id
WHERE sc.text LIKE ''''%'' + @strColName + ''%''''
AND so.type = ''''V''''
ORDER BY so.name''
--Show view names
EXEC dbo.sp_executesql @strSQL,N''@strColName VARCHAR(50)'',@strColName = @strColName
--Views that may indirectly reference column
SET @lngCounter = @lngTableCount
WHILE @lngCounter <> 0
BEGIN
      --Reset table name 
      SET @strTabName = (SELECT strName FROM #tTableNames WHERE numID = @lngTableCount)
      --Views indirectly referencing column
      SET @strSQL = ''SELECT so.name 
      FROM dbo.sysobjects so
      INNER JOIN dbo.syscomments sc
      ON so.id = sc.id
      WHERE ((sc.text LIKE ''''%SELECT *%''''
      OR sc.text LIKE ''''%.*%'''')
      AND sc.text LIKE ''''%'' + @strTabName + ''%''''
      AND sc.text NOT LIKE ''''%SELECT * from #%'''')
      AND so.type = ''''V''''
      ORDER BY so.name''
      --Show views names
      INSERT INTO #tViewNames
      EXEC dbo.sp_executesql @strSQL
      SET @lngCounter = @lngCounter - 1
END
--Show views Names
SET @strSQL = ''SELECT DISTINCT strName AS ''''Views That May Indirectly Reference Column: '' 
+ @strColName + ''''''
FROM #tViewNames''
EXEC dbo.sp_executesql @strSQL
DROP TABLE #tTableNames
DROP TABLE #tProcNames
DROP TABLE #tViewNames
' 
END
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[sp_util_getDataStructure]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'CREATE Procedure [dbo].[sp_util_getDataStructure]
AS
Select 
     so.name "TableName", 
     sc.name "FieldName",
     type_name (sc.xusertype) "DataType",
     sc.length "Size",
     "IsNullable" = 
          Case 
             When sc.isnullable = 1 then ''Null'' 
             Else ''Not Null'' 
          End
 From 
     syscolumns sc, 
     sysobjects so 
 Where 
     so.type = ''U'' and 
     sc.id = so.id and 
     so.status >  0 and
     so.name NOT LIKE ''import%'' and
     so.name NOT IN (''CDATA'',''CGLOBAL'')
    
 ORDER BY so.name
---- List all chk and default constraints
 
 Select 
     object_name(parent_obj) "TableName",
     col_name(parent_obj,info) "Fieldname",
     sc.TEXT "Default"
 From
     sysobjects so,
     SysComments sc
 Where
     parent_obj in (select id from sysobjects where type=''U'') and 
     xtype in (''D'',''C'') and
     sc.id = so.ID
' 
END
GO
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[sp_util_send_mail]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [dbo].[sp_util_send_mail]
 
@txtTo varchar(100),
@txtFrom varchar(100),
@txtSubject varchar(100),
@txtBody text,
@txtHTMLBody text
 
-- OUTPUTS:
-- The stored procedure returns a single record recordset, containing 1
--field called Result, which will have only these values:
-- The value is either FAILURE or SUCCESSFUL
-- If successful, it may indicate whether or not there was an error or not
--    "FAILURE - Object could not be created''
--    "Send mail successful"
--    "Send mail successful with Error  (..." - this result would pass what
--     parameters encountered an error..
 
AS
 
DECLARE @object int
DECLARE @resSP int
DECLARE @resSM int
DECLARE @resFN int
DECLARE @resError varchar(8000)
DECLARE @hr int
DECLARE @txtSpoolDir varchar(64)
 
declare @tmpresult int
declare @tmpResultString varchar(5000)
 
EXEC @hr = sp_OACreate ''iMSMail.SendMail'',  @object OUT
 
-- IF THE OBJECT WAS NOT CREATED, THEN STOP THE PROCESS WITH AN ERROR MESSAGE
IF @hr <> 0
BEGIN
 SELECT ''FAILURE - Object could not be created'' as Result
 RETURN
END
 
SET @resFN = 0
SET @resError = ''''
 
--Determine the SPOOL Directory
--************************
SET @txtSpoolDir = ''D:\iMS\Out\'' --FOR Development on AIRWAVES
 
IF @@SERVERNAME = ''ONEDJ''
  SET @txtSpoolDir = ''G:\iMS\Out\'' --FOR Production ON ONEDJ
ELSE IF @@SERVERNAME = ''CRAWLSPACE''
  SET @txtSpoolDir = ''D:\iMS\Out\'' --FOR Production ON CRAWLSPACE
--************************
 
-- SET THE SPOOL DIRECTORY
EXEC @resSP = sp_OASetProperty @object, ''SpoolDir'', @txtSpoolDir
IF (@resSP <> 0)
BEGIN
 SET @resFN = @resSP + @resFN
 SET @resError = @resError + '',Error setting Spool Directory''
END
 
-- SET THE SMTP TO PROPERTY..  This is who the message is really sent too
EXEC @resSP = sp_OASetProperty @object, ''smtpto'', @txtTo
IF (@resSP <> 0)
BEGIN
 SET @resFN = @resSP + @resFN
 SET @resError = @resError + '',Error setting SMTPTO''
END
 
-- SET THE SMTP FROM PROPERTY
EXEC @resSP = sp_OASetProperty @object, ''smtpfrom'', @txtFrom
IF (@resSP <> 0)
BEGIN
 SET @resFN = @resSP + @resFN
 SET @resError = @resError + '',Error setting SMTPFROM''
END
 
EXEC @resSP = sp_OASetProperty @object, ''body'', @txtBody
SET @resFN = @resSP + @resFN
EXEC @resSP = sp_OASetProperty @object, ''html'', @txtHTMLBody
SET @resFN = @resSP + @resFN
 
SET @txtTo = ''SetHeader("To", '' + char(34) + @txtTo + char(34) +  '')''
SET @txtFrom = ''SetHeader("From", '' + char(34) + @txtFrom + char(34) +  '')''
SET @txtSubject = ''SetHeader("Subject", '' + char(34) + @txtSubject + char(34) +  '')''
 
EXEC sp_OAMethod @object, @txtTo
EXEC sp_OAMethod @object, @txtFrom
EXEC sp_OAMethod @object, @txtSubject
 
EXEC @resSM = sp_OAMethod @object, ''SendMail''
 
EXEC @resSP = sp_OAGetProperty @object, ''Result'', @tmpResult OUT
EXEC @resSP = sp_OAGetProperty @object, ''ResultString'', @tmpResultString OUT
EXEC sp_OADestroy @object
 
--RETURN
--print ''sending mail is complete''
 /*
IF (@resSM <> 0)
BEGIN
 SELECT ''send mail process failed'' as Result
 RETURN
END
 
IF (@resSM = 0)
BEGIN
 IF (@resFN = 0)
 BEGIN
  select ''Send mail successful'' as Result
 END
 IF (@resFN <> 0)
 BEGIN
  select ''Send mail successful with Error  ('' + @resError + '')''  as Result
 END
END
*/
' 
END
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[t_Locale]') AND type in (N'U'))
BEGIN
CREATE TABLE [dbo].[t_Locale](
	[LocaleID] [int] IDENTITY(1,1) NOT NULL,
	[LocaleActive] [bit] NULL,
	[LocaleName] [nvarchar](128) NULL,
	[LocaleAlias] [varchar](125) NULL,
	[LocaleCode] [varchar](10) NULL,
	[LanguageID] [int] NULL,
	[GMTOffset] [int] NULL,
	[DSTStartDateTime] [datetime] NULL,
	[DSTEndDateTime] [datetime] NULL,
 CONSTRAINT [PK_t_Locale] PRIMARY KEY CLUSTERED 
(
	[LocaleID] ASC
)WITH (IGNORE_DUP_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
END
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[cfmx].[CDATA]') AND type in (N'U'))
BEGIN
CREATE TABLE [cfmx].[CDATA](
	[cfid] [char](64) NULL,
	[app] [char](64) NULL,
	[data] [text] NULL
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
END
GO

IF NOT EXISTS (SELECT * FROM sys.indexes WHERE object_id = OBJECT_ID(N'[cfmx].[CDATA]') AND name = N'id1')
CREATE UNIQUE NONCLUSTERED INDEX [id1] ON [cfmx].[CDATA] 
(
	[cfid] ASC,
	[app] ASC
)WITH (IGNORE_DUP_KEY = OFF) ON [PRIMARY]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[cfmx].[CGLOBAL]') AND type in (N'U'))
BEGIN
CREATE TABLE [cfmx].[CGLOBAL](
	[cfid] [char](64) NULL,
	[data] [text] NULL,
	[lvisit] [datetime] NULL
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
END
GO

IF NOT EXISTS (SELECT * FROM sys.indexes WHERE object_id = OBJECT_ID(N'[cfmx].[CGLOBAL]') AND name = N'id2')
CREATE NONCLUSTERED INDEX [id2] ON [cfmx].[CGLOBAL] 
(
	[cfid] ASC
)WITH (IGNORE_DUP_KEY = OFF) ON [PRIMARY]
GO

IF NOT EXISTS (SELECT * FROM sys.indexes WHERE object_id = OBJECT_ID(N'[cfmx].[CGLOBAL]') AND name = N'id3')
CREATE NONCLUSTERED INDEX [id3] ON [cfmx].[CGLOBAL] 
(
	[lvisit] ASC
)WITH (IGNORE_DUP_KEY = OFF) ON [PRIMARY]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[t_SupportRequest]') AND type in (N'U'))
BEGIN
CREATE TABLE [dbo].[t_SupportRequest](
	[supportRequestID] [int] IDENTITY(1,1) NOT NULL,
	[requestorName] [varchar](200) NULL,
	[requestorEmail] [varchar](200) NULL,
	[requestorPhone] [varchar](20) NULL,
	[supportIssueType] [varchar](200) NULL,
	[supportIssue] [text] NULL,
	[requestorPlatformID] [int] NULL,
	[requestorBrowser] [varchar](100) NULL,
	[requestorUser] [varchar](50) NULL,
	[supportRequestStatus] [int] NULL,
	[DateRequested] [datetime] NULL CONSTRAINT [DF_t_SupportRequest_DateRequested]  DEFAULT (getdate()),
 CONSTRAINT [PK_t_SupportRequest] PRIMARY KEY CLUSTERED 
(
	[supportRequestID] ASC
)WITH (IGNORE_DUP_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
END
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[fn_IntToBase32]') AND type in (N'FN', N'IF', N'TF', N'FS', N'FT'))
BEGIN
execute dbo.sp_executesql @statement = N'

CREATE   FUNCTION [dbo].[fn_IntToBase32](@i INTEGER)

RETURNS CHAR(3)

AS

BEGIN

/*
Created on 07.07.2006
This function will convert an INT to a BASE 32 three digit string


TESTING:

DECLARE @i INT, @finalNumber char(3)

SET @i = 32770

SELECT @finalNumber = dbo.fn_IntToBase32(@i)

PRINT @finalNumber
*/

DECLARE @base nvarchar(128)

SET @base = ''0123456789abcdefghijklmnopqrstuv''

IF @i >= 32768
  RETURN ''vvv''
ELSE
  BEGIN

	DECLARE @finalNumber nvarchar(16), @x INT, @result INT, @len INT, @remainder INT
	
	SET @finalNumber = ''''
	SET @x = @i
	SET @result = -1
	SET @len = LEN(@base)
	
	WHILE @result <> 0
	  BEGIN
		SET @result = Floor(@x/@len)
		SET @remainder = ( CAST(@x as float) / CAST(@len as float) - @result ) * @len	
	
		set @finalNumber = SUBSTRING(@base,@remainder+1,1) + @finalnumber 
		set @x = @result
	  END
	
	
	SET @finalNumber = RIGHT(''00'' + @finalNumber,3) 	
	
  END

RETURN @finalNumber

END


' 
END




GO
SET ANSI_NULLS OFF 
GO
SET QUOTED_IDENTIFIER ON 
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[sp_CMS_getRecentHistory]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'

CREATE PROCEDURE sp_CMS_getRecentHistory (

@totalRows INT=10 --The total number of rows to display

)

--Created By John WebWilliam Avila on 01.07.2008

--This procedure is called by the 3WCMS and is used to return
----the most recent changes within the CMS.

/*
--TESTING

DECLARE @totalRows INT

SET @totalRows = 20

EXEC sp_CMS_getRecentHistory @totalRows

*/

AS

--===================================================================
--If there is nothing from the query, then return nothing
IF NOT EXISTS (SELECT * FROM qry_GetTracking)
  return
--===================================================================


--Declare a local table used to populate the recent changes
DECLARE @trackingTable TABLE (trackingID INT, trackingDateTime datetime,
firstName nvarchar(64), lastName nvarchar(64),
categoryName varchar(128), categoryAlias varchar(128), keyID INT, operationID INT, entity varchar(1000))

--Local variables used in the loop below
DECLARE @trackingID INT, @categoryAlias varchar(128)

--Loop over the @trackingTable as long as the COUNT is less than the @totalRows
WHILE (SELECT count(*) FROM @trackingTable) < @totalRows
  BEGIN
	--Get the TOP 1 (DESC) of the tracking view, as long as the categoryAlias does
	----not exist in the @trackingTable
	SELECT TOP 1 @trackingID = gt.trackingID, @categoryAlias = c.categoryAlias
	FROM qry_GetTracking gt 
	INNER JOIN t_Category c ON c.CategoryID = gt.KeyID  
	WHERE gt.ENTITY = ''t_Category''
	AND c.categoryAlias NOT IN (SELECT categoryAlias FROM @trackingTable)
	ORDER BY gt.TrackingID DESC

	--Insert the record into the @trackingTable
	INSERT INTO @trackingTable
	SELECT gt.trackingID, gt.trackingDateTime,
	u.FirstName, u.lastName, c.CategoryName, c.CategoryAlias, gt.keyID, gt.operationID, gt.entity
	FROM qry_GetTracking gt 
	INNER JOIN t_Category c ON c.CategoryID = gt.KeyID  
	INNER JOIN t_user u ON u.UserID = gt.UserID 
	WHERE gt.trackingID = @trackingID

  END
--END OF LOOP

--Return the results of the @trackingTable
SELECT 
	trackingID, 
	trackingDateTime,
	firstName, 
	lastName,
	categoryName,
	categoryAlias,
	keyID,
	OperationID,
entity
FROM @trackingTable

return'
END




GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[sp_generateDisplayOrder]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'


CREATE    PROCEDURE [dbo].[sp_generateDisplayOrder] (

@parentCategoryID INT

)

AS

/*
Created on 07.07.2006 by John WebWilliam Avila & Brian Werstein

This procedure will do the following:
   Based on a categoryID (@parentCategoryID), update the displayOrder and displayLevel
   for all children and it''s children.


TESTING:

DECLARE @parentCategoryID INT, @displayOrder nvarchar(128)

SET @parentCategoryID = 2000

SELECT @displayOrder = displayOrder
FROM t_Category
WHERE categoryID = @parentCategoryID

BEGIN TRAN

EXEC sp_generateDisplayOrder @parentCategoryID


SET @displayOrder = @displayOrder+''%''

SELECT *
FROM t_Category
WHERE displayOrder LIKE @displayOrder
ORDER BY displayOrder

ROLLBACK TRAN

*/



DECLARE @displayOrder nvarchar(128), @key INT, @displayLevel INT, @newDisplayOrder nvarchar(128), @categoryID INT
SET @key = 0

DECLARE @someTable TABLE (
categoryID INT,
categoryPriority INT
)

INSERT INTO @someTable (categoryID, categoryPriority)
SELECT categoryID, categoryPriority
FROM t_Category
WHERE parentID = @parentCategoryID
ORDER BY categoryPriority


SELECT @displayOrder = IsNull(displayOrder,'''')
FROM t_Category
WHERE categoryID = @parentCategoryID

IF @displayOrder IS NULL
 SET @displayOrder = ''''


WHILE (SELECT IsNull(Count(categoryID),0) FROM @someTable) > 0
  BEGIN
	SELECT TOP 1 @categoryID = categoryID FROM @someTable

	SET @newDisplayOrder = @displayOrder + dbo.fn_IntToBase32(@key)

	SET @displayLevel = (LEN(@newDisplayOrder)/3) - 1

	UPDATE t_Category
	SET displayOrder = @newDisplayOrder,
	displayLevel = @displayLevel
	WHERE categoryID = @categoryID

	EXEC sp_generateDisplayOrder @categoryID

	SET @key = @key + 1
	
	DELETE FROM @someTable WHERE categoryID = @categoryID
  END

--PRINT ''key: '' + CAST(@key as varchar(16))
--RETURN





' 
END
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[sp_generateDisplayOrderLocaleMeta]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'
CREATE PROCEDURE [dbo].[sp_generateDisplayOrderLocaleMeta] (

@parentCategoryID INT,

@LocaleID INT

)

AS

/*

TESTING:

DECLARE @parentCategoryID INT, @displayOrder nvarchar(128),@LocaleID INT

SET @parentCategoryID = 3255
SET @LocaleID = 2

SELECT @displayOrder = CategoryLocaleDisplayOrder
FROM t_CategoryLocaleMeta
WHERE categoryID = @parentCategoryID
AND LocaleID = @LocaleID

BEGIN TRAN

EXEC sp_generateDisplayOrderLocaleMeta @parentCategoryID, @LocaleID


SET @displayOrder = @displayOrder+''%''

SELECT *
FROM t_CategoryLocaleMeta
WHERE CategoryLocaleDisplayOrder LIKE @displayOrder
AND LocaleID = @LocaleID
ORDER BY CategoryLocaleDisplayOrder

ROLLBACK TRAN

*/



DECLARE @displayOrder nvarchar(128), @key INT, @displayLevel INT, @newDisplayOrder nvarchar(128), @categoryID INT
SET @key = 0

DECLARE @someTable TABLE (
categoryID INT,
categoryLocalePriority INT
)

INSERT INTO @someTable (categoryID, categoryLocalePriority)
SELECT categoryID, categoryLocalePriority
FROM t_CategoryLocaleMeta
WHERE categoryID IN (
	SELECT categoryID FROM t_Category
	WHERE parentID = @parentCategoryID
)
AND LocaleID = @LocaleID
ORDER BY categoryLocalePriority


SELECT @displayOrder = IsNull(CategoryLocaleDisplayOrder,'''')
FROM t_CategoryLocaleMeta
WHERE categoryID = @parentCategoryID
AND LocaleID = @LocaleID

IF @displayOrder IS NULL
 SET @displayOrder = ''''


WHILE (SELECT IsNull(Count(categoryID),0) FROM @someTable) > 0
  BEGIN
	SELECT TOP 1 @categoryID = categoryID FROM @someTable

	SET @newDisplayOrder = @displayOrder + dbo.fn_IntToBase32(@key)

	UPDATE t_CategoryLocaleMeta
	SET CategoryLocaleDisplayOrder = @newDisplayOrder
	WHERE categoryID = @categoryID
	AND LocaleID = @LocaleID

	EXEC sp_generateDisplayOrderLocaleMeta @categoryID, @LocaleID

	SET @key = @key + 1
	
	DELETE FROM @someTable WHERE categoryID = @categoryID
  END

--PRINT ''key: '' + CAST(@key as varchar(16))
--RETURN







' 
END
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.views WHERE object_id = OBJECT_ID(N'[dbo].[qry_GetContent]'))
EXEC dbo.sp_executesql @statement = N'CREATE VIEW [dbo].[qry_GetContent]
AS
SELECT     dbo.t_Content.*, dbo.t_Category.CategoryName AS CategoryName, dbo.t_Category.CategoryAlias AS CategoryAlias, 
                      dbo.t_Category.ParentID AS ParentID, dbo.t_Category.DisplayLevel AS DisplayLevel, dbo.t_Category.DisplayOrder AS DisplayOrder, 
                      dbo.t_Category.CategoryActive AS CategoryActive, dbo.t_Category.PropertiesID AS CategoryPropertiesID, 
                      dbo.t_Content.PropertiesID AS ContentPropertiesID, t_Label_1.LabelName AS ContentTypeName, t_Label_1.LabelImage AS ContentTypeIcon
FROM         dbo.t_Label t_Label_1 RIGHT OUTER JOIN
                      dbo.t_Content ON t_Label_1.LabelID = dbo.t_Content.ContentTypeID LEFT OUTER JOIN
                      dbo.t_Category ON dbo.t_Content.CategoryID = dbo.t_Category.CategoryID
' 
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.views WHERE object_id = OBJECT_ID(N'[dbo].[qry_GetContentInherit]'))
EXEC dbo.sp_executesql @statement = N'CREATE VIEW [dbo].[qry_GetContentInherit]
AS
SELECT     dbo.t_Content.ContentID, dbo.t_Content.InheritID, dbo.t_Content.ContentActive, dbo.t_Category.CategoryID, dbo.t_Category.DisplayOrder, 
                      dbo.t_Category.CategoryActive, dbo.t_Content.ContentPriority, dbo.t_ContentLocaleMeta.LocaleID, dbo.t_ContentLocaleMeta.ContentLocalePriority, 
                      dbo.t_ContentLocaleMeta.ContentPositionID
FROM         dbo.t_Content INNER JOIN
                      dbo.t_Category ON dbo.t_Content.CategoryID = dbo.t_Category.CategoryID INNER JOIN
                      dbo.t_ContentLocaleMeta ON dbo.t_Content.ContentID = dbo.t_ContentLocaleMeta.ContentID
' 
GO


/****** Object:  View [dbo].[qry_GetContentLocale]    Script Date: 08/25/2007 17:12:41 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE VIEW [dbo].[qry_GetContentLocale]
AS
SELECT     dbo.t_Content.ContentID, dbo.t_Content.CategoryID, dbo.t_Content.ContentTypeID, dbo.t_Content.ContentPriority, dbo.t_Content.ContentActive, 
                      dbo.t_Content.ContentIndexed, dbo.t_Content.SourceID, dbo.t_ContentLocale.ContentLocaleID, 
                      dbo.t_ContentLocale.PropertiesID AS ContentLocalePropertiesID, dbo.t_Locale.LocaleID,  
                      dbo.t_Properties.PropertiesPacket AS ContentLocalePropertiesPacket, dbo.t_Content.ContentDate1, dbo.t_Content.ContentDate2, 
                      dbo.t_Content.ContentName, dbo.t_ContentLocale.ContentBody
FROM         dbo.t_Content INNER JOIN
                      dbo.t_ContentLocale ON dbo.t_Content.ContentID = dbo.t_ContentLocale.ContentID INNER JOIN
                      dbo.t_Locale ON dbo.t_ContentLocale.LocaleID = dbo.t_Locale.LocaleID INNER JOIN
                      dbo.t_Properties ON dbo.t_ContentLocale.PropertiesID = dbo.t_Properties.PropertiesID

GO

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.views WHERE object_id = OBJECT_ID(N'[dbo].[qry_GetCategory]'))
EXEC dbo.sp_executesql @statement = N'CREATE VIEW [dbo].[qry_GetCategory]
AS
SELECT     dbo.t_Category.*, dbo.t_Properties.PropertiesPacket AS PropertiesPacket, dbo.t_Label.LabelName AS CategoryTypeName
FROM         dbo.t_Category LEFT OUTER JOIN
                      dbo.t_Label ON dbo.t_Category.CategoryTypeID = dbo.t_Label.LabelID LEFT OUTER JOIN
                      dbo.t_Properties ON dbo.t_Category.PropertiesID = dbo.t_Properties.PropertiesID
' 
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.views WHERE object_id = OBJECT_ID(N'[dbo].[qry_GetCategoryContentPicker]'))
EXEC dbo.sp_executesql @statement = N'CREATE VIEW [dbo].[qry_GetCategoryContentPicker]
AS
SELECT     dbo.t_Category.CategoryID, dbo.t_Category.CategoryTypeID, t_Label_1.LabelName AS CategoryTypeName, dbo.t_Category.CategoryName, 
                      dbo.t_Content.ContentID, dbo.t_Content.ContentName, dbo.t_Content.ContentTypeID, t_Label_2.LabelName AS ContentTypeName, 
                      dbo.t_Category.DisplayOrder, dbo.t_Content.ContentPriority, dbo.t_Category.CategoryActive, dbo.t_Content.ContentActive, dbo.t_Category.DisplayLevel,
                       dbo.t_ContentLocaleMeta.ContentPositionID, t_Label_3.LabelName AS ContentPositionName, dbo.t_ContentLocaleMeta.LocaleID
FROM         dbo.t_Content LEFT OUTER JOIN
                      dbo.t_Label t_Label_3 RIGHT OUTER JOIN
                      dbo.t_ContentLocaleMeta ON t_Label_3.LabelID = dbo.t_ContentLocaleMeta.ContentPositionID ON 
                      dbo.t_Content.ContentID = dbo.t_ContentLocaleMeta.ContentID LEFT OUTER JOIN
                      dbo.t_Label t_Label_2 ON dbo.t_Content.ContentTypeID = t_Label_2.LabelID RIGHT OUTER JOIN
                      dbo.t_Label t_Label_1 RIGHT OUTER JOIN
                      dbo.t_Category ON t_Label_1.LabelID = dbo.t_Category.CategoryTypeID ON dbo.t_Content.CategoryID = dbo.t_Category.CategoryID
' 
GO

GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.views WHERE object_id = OBJECT_ID(N'[dbo].[qry_GetCategoryLocale]'))
EXEC dbo.sp_executesql @statement = N'CREATE VIEW [dbo].[qry_GetCategoryLocale]
AS
SELECT     dbo.t_CategoryLocale.*, dbo.t_Locale.LocaleName AS LocaleName, t_Label_1.LabelName AS LanguageName, t_Label_1.LabelCode AS LanguageCode,
                       dbo.t_Properties.PropertiesPacket AS PropertiesPacket, dbo.t_Category.DisplayOrder AS DisplayORder, dbo.t_Category.CategoryAlias
FROM         dbo.t_Category RIGHT OUTER JOIN
                      dbo.t_CategoryLocale ON dbo.t_Category.CategoryID = dbo.t_CategoryLocale.CategoryID LEFT OUTER JOIN
                      dbo.t_Properties ON dbo.t_CategoryLocale.PropertiesID = dbo.t_Properties.PropertiesID LEFT OUTER JOIN
                      dbo.t_Locale LEFT OUTER JOIN
                      dbo.t_Label t_Label_1 ON dbo.t_Locale.LanguageID = t_Label_1.LabelID ON dbo.t_CategoryLocale.LocaleID = dbo.t_Locale.LocaleID
' 
GO

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.views WHERE object_id = OBJECT_ID(N'[dbo].[qry_GetCategoryLastVersionChange]'))
EXEC dbo.sp_executesql @statement = N'CREATE VIEW [dbo].[qry_GetCategoryLastVersionChange]
AS
SELECT     TOP 100 PERCENT dbo.t_Category.CategoryID, MAX(dbo.t_Tracking.TrackingDateTime) AS MaxTrackingDateTime
FROM         dbo.t_Category INNER JOIN
                      dbo.t_Tracking ON dbo.t_Category.CategoryID = dbo.t_Tracking.KeyID AND dbo.t_Tracking.Entity = ''t_Category'' AND dbo.t_Tracking.OperationID IN (504,
                       505, 500)
GROUP BY dbo.t_Category.CategoryID
' 
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.views WHERE object_id = OBJECT_ID(N'[dbo].[qry_GetCategoryMeta]'))
EXEC dbo.sp_executesql @statement = N'CREATE VIEW [dbo].[qry_GetCategoryMeta]
AS
SELECT	dbo.t_Category.CategoryId, dbo.t_Category.CategoryTypeId, dbo.t_Category.CategoryName, 
		dbo.t_Category.CategoryAlias, dbo.t_Category.ParentID, dbo.t_Category.DisplayLevel, 
		dbo.t_Category.DisplayOrder, dbo.t_Category.CategoryActive, dbo.t_Category.ShowInNavigation, 
		dbo.t_Category.CategoryIndexed,	dbo.t_Category.CategoryPriority, dbo.t_Category.CategoryURL, 
		dbo.t_Category.PropertiesId, dbo.t_Category.WorkflowStatusID, dbo.t_Category.TemplateID, 
		dbo.t_Category.CacheDateTime, dbo.t_Category.SourceID, dbo.t_CategoryLocaleMeta.LocaleID, 
		dbo.t_CategoryLocaleMeta.CategoryLocalePriority,
		dbo.t_CategoryLocaleMeta.CategoryLocaleDisplayOrder
FROM         dbo.t_Category 
INNER JOIN   dbo.t_CategoryLocaleMeta ON dbo.t_Category.CategoryID = dbo.t_CategoryLocaleMeta.CategoryID' 
GO

GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.views WHERE object_id = OBJECT_ID(N'[dbo].[qry_GetCategoryPermission]'))
EXEC dbo.sp_executesql @statement = N'CREATE VIEW [dbo].[qry_GetCategoryPermission]
AS
SELECT     dbo.t_Category.CategoryID AS CategoryID, dbo.t_Category.CategoryName AS CategoryName, dbo.t_Category.CategoryAlias AS CategoryAlias, 
                      dbo.t_Category.CategoryURL AS CategoryURL, dbo.t_Category.DisplayOrder AS DisplayOrder, dbo.t_Category.DisplayLevel AS DisplayLevel, 
                      dbo.t_Category.CategoryActive AS CategoryActive, dbo.t_Permissions.UserGroupID, dbo.t_Permissions.pRead, dbo.t_Permissions.pCreate, 
                      dbo.t_Permissions.pEdit, dbo.t_Permissions.pDelete, dbo.t_Permissions.pSaveLive, dbo.t_Permissions.pManage
FROM         dbo.t_Category LEFT OUTER JOIN
                      dbo.t_Permissions ON dbo.t_Category.CategoryID = dbo.t_Permissions.CategoryID
' 
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.views WHERE object_id = OBJECT_ID(N'[dbo].[qry_GetCategoryProperties]'))
EXEC dbo.sp_executesql @statement = N'CREATE VIEW [dbo].[qry_GetCategoryProperties]
AS
SELECT     dbo.t_Category.CategoryID, dbo.t_Category.DisplayOrder, dbo.t_Properties.PropertiesPacket
FROM         dbo.t_Category INNER JOIN
                      dbo.t_Properties ON dbo.t_Category.PropertiesID = dbo.t_Properties.PropertiesID
' 
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.views WHERE object_id = OBJECT_ID(N'[dbo].[qry_GetWorkflow]'))
EXEC dbo.sp_executesql @statement = N'CREATE VIEW [dbo].[qry_GetWorkflow]
AS
SELECT     dbo.qry_GetCategoryLocaleMeta.CategoryLocaleID, dbo.qry_GetCategoryLocaleMeta.CategoryID, 
                      dbo.qry_GetCategoryLocaleMeta.CategoryLocaleActive, dbo.qry_GetCategoryLocaleMeta.CategoryLocaleName, 
                      dbo.qry_GetCategoryLocaleMeta.CategoryLocaleURL, dbo.qry_GetCategoryLocaleMeta.LocaleID, dbo.qry_GetCategoryLocaleMeta.PropertiesID, 
                      dbo.qry_GetCategoryLocaleMeta.DefaultCategoryLocale, dbo.t_Locale.LocaleName, t_Label_1.LabelName AS LanguageName, 
                      t_Label_1.LabelCode AS LanguageCode, dbo.t_Properties.PropertiesPacket, dbo.t_Category.DisplayOrder, dbo.t_Category.CategoryAlias, 
                      dbo.t_Category.CategoryTypeID, dbo.t_Category.CategoryName, t_Label_2.LabelName AS WorkflowStatusName, dbo.t_Category.ParentID, 
                      t_Category_1.CategoryName AS ParentCategoryName, dbo.qry_GetTrackingCategoryLatest.UserLogin, 
                      dbo.qry_GetTrackingCategoryLatest.OperationName, dbo.qry_GetTrackingCategoryLatest.OperationCode, 
                      dbo.qry_GetTrackingCategoryLatest.TrackingDateTime, dbo.qry_GetTrackingCategoryLatest.OperationID, 
                      dbo.qry_GetCategoryLocaleMeta.CategoryLocalePriority, dbo.qry_GetCategoryLocaleMeta.CategoryLocaleDisplayOrder, 
                      dbo.qry_GetTrackingCategoryLatest.FirstName AS TrackingFirstName, dbo.qry_GetTrackingCategoryLatest.MiddleName AS TrackingMiddleName, 
                      dbo.qry_GetTrackingCategoryLatest.LastName AS TrackingLastName, dbo.qry_GetCategoryLocaleMeta.WorkflowStatusID
FROM         dbo.t_Label AS t_Label_1 INNER JOIN
                      dbo.t_Locale INNER JOIN
                      dbo.t_Category INNER JOIN
                      dbo.qry_GetCategoryLocaleMeta ON dbo.t_Category.CategoryID = dbo.qry_GetCategoryLocaleMeta.CategoryID INNER JOIN
                      dbo.t_Properties ON dbo.qry_GetCategoryLocaleMeta.PropertiesID = dbo.t_Properties.PropertiesID ON 
                      dbo.t_Locale.LocaleID = dbo.qry_GetCategoryLocaleMeta.LocaleID ON t_Label_1.LabelID = dbo.t_Locale.LanguageID INNER JOIN
                      dbo.qry_GetTrackingCategoryLatest ON dbo.t_Category.CategoryID = dbo.qry_GetTrackingCategoryLatest.CategoryID INNER JOIN
                      dbo.t_Label AS t_Label_2 ON dbo.qry_GetCategoryLocaleMeta.WorkflowStatusID = t_Label_2.LabelID LEFT OUTER JOIN
                      dbo.t_Category AS t_Category_1 ON dbo.t_Category.ParentID = t_Category_1.CategoryID
'
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.views WHERE object_id = OBJECT_ID(N'[dbo].[qry_GetWorkflowRequest]'))
EXEC dbo.sp_executesql @statement = N'CREATE VIEW [dbo].[qry_GetWorkflowRequest]
AS
SELECT     dbo.t_WorkflowRequest.WorkflowRequestID, dbo.t_WorkflowRequest.WorkflowRequestTypeID, dbo.t_WorkflowRequest.WorkflowRequestDateTime, 
                      dbo.t_WorkflowRequest.FromUserID, dbo.t_WorkflowRequest.CategoryID, dbo.t_WorkflowRequest.Message, dbo.t_WorkflowRequest.Dismissed, 
                      dbo.t_Category.CategoryName, dbo.t_Category.CategoryAlias, t_User_2.FirstName AS FromFirstName, t_User_2.MiddleName AS FromMiddleName, 
                      t_User_2.LastName AS FromLastName, t_Label_2.LabelName AS WorkflowRequestTypeName, t_User_1.FirstName AS RecipientFirstName, 
                      t_User_1.MiddleName AS RecipientMiddleName, t_User_1.LastName AS RecipientLastName, t_Label_1.LabelName AS RecipientUserGroupName, 
                      dbo.t_WorkflowRequestRecipient.UserID AS RecipientUserID, dbo.t_WorkflowRequestRecipient.UserGroupID AS RecipientUserGroupID, 
                      t_User_2.EmailAddress AS FromEmailAddress, t_User_1.EmailAddress AS RecipientEmailAddress, dbo.t_WorkflowRequest.LocaleID, 
                      dbo.t_CategoryLocale.WorkflowStatusID
FROM         dbo.t_UserGroup LEFT OUTER JOIN
                      dbo.t_Label AS t_Label_1 ON dbo.t_UserGroup.UserGroupID = t_Label_1.LabelID RIGHT OUTER JOIN
                      dbo.t_WorkflowRequestRecipient ON dbo.t_UserGroup.UserGroupID = dbo.t_WorkflowRequestRecipient.UserGroupID LEFT OUTER JOIN
                      dbo.t_User AS t_User_1 ON dbo.t_WorkflowRequestRecipient.UserID = t_User_1.UserID RIGHT OUTER JOIN
                      dbo.t_CategoryLocale RIGHT OUTER JOIN
                      dbo.t_WorkflowRequest ON dbo.t_CategoryLocale.CategoryID = dbo.t_WorkflowRequest.CategoryID AND 
                      dbo.t_CategoryLocale.LocaleID = dbo.t_WorkflowRequest.LocaleID ON 
                      dbo.t_WorkflowRequestRecipient.WorkflowRequestID = dbo.t_WorkflowRequest.WorkflowRequestID LEFT OUTER JOIN
                      dbo.t_Label AS t_Label_2 ON dbo.t_WorkflowRequest.WorkflowRequestTypeID = t_Label_2.LabelID LEFT OUTER JOIN
                      dbo.t_User AS t_User_2 ON dbo.t_WorkflowRequest.FromUserID = t_User_2.UserID LEFT OUTER JOIN
                      dbo.t_Category ON dbo.t_WorkflowRequest.CategoryID = dbo.t_Category.CategoryID
'
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[sp_getPage]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'CREATE Procedure [dbo].[sp_getPage]
@categoryID INT, 
@localeID INT,
@categoryActiveDerived BIT=NULL
AS
--Created by John WebWilliam Avila on 08.12.2004
--Notes:
---localeID: 
----2: United States
----3: Spain
DECLARE @defaultCategoryLocaleID INT, @localeIDexists INT, @sql nvarchar(4000)
--Get the Default LocaleID for this record
SET @defaultCategoryLocaleID = (SELECT localeID FROM t_CategoryLocale
WHERE categoryID = @categoryID
AND defaultCategoryLocale = 1)
--If the current Default LocaleID does not exist, then set the variable to 0
PRINT ''categoryID '' + CAST(@categoryID AS Varchar(16))
IF @defaultCategoryLocaleID IS NULL
  SET @defaultCategoryLocaleID = 0
--Get the localeID
SET @localeIDexists = (SELECT localeID
FROM t_categoryLocale
WHERE categoryID = @categoryID
AND localeID = @localeID) 
--If the current localeID does not exist, then set the variable to 0
IF @localeIDexists IS NULL
  SET @localeIDexists = 0
--23 total fields
--If no record exists in t_categoryLocale, then just get category information
IF @defaultCategoryLocaleID = 0 AND @localeIDexists = 0
  BEGIN
	SET @sql = ''SELECT c.categoryID, c.categoryTypeID, c.categoryName, c.categoryName As categoryNameDerived,
	c.categoryAlias, c.parentID, c.displayLevel,  
	c.displayOrder, c.CategoryLocaledisplayOrder as displayOrderDerived, 
	c.categoryActive, c.ShowInNavigation,
	c.categoryPriority, c.CategoryLocalePriority as categoryPriorityDerived,
	c.categoryURL, c.categoryURL As categoryURLDerived,
	c.propertiesID as categoryPropertiesID, c.workflowStatusID, c.templateID, c.cacheDateTime,
	c.SourceID, NULL As categoryLocaleID, NULL As categoryLocaleActive, 
	NULL As localeID, NULL As categoryLocalePropertiesID, NULL As defaultCategoryLocale,
	NULL As categoryActiveDerived, NULL as CategoryLocalePropertiesPacket, NULL as CategoryPropertiesPacket
	FROM qry_GetCategoryMeta c
					  
	WHERE c.localeID = '' + Cast(@localeID as nvarchar(16)) + '' and c.categoryID = ''+Cast(@categoryID as nvarchar(16))+'' 
	AND ''
	
	--If @categoryActiveDerived IS NOT NULL, then filter by categoryActive
	SET @sql = @sql + CASE @categoryActiveDerived
       	WHEN 0 THEN ''1=1''
       	WHEN 1 THEN ''1 = 0 ''
       	ELSE ''1 = 1 ''
       	END
	
	SET @sql = @sql + ''ORDER BY c.categoryPriority''
	PRINT @sql
	EXEC (@sql)
  END
ELSE --the the combination of t_category, t_categoryLocale and t_Properties information
  BEGIN
	--Create a temporary table with 23 fields
	CREATE TABLE #tempTable2 (
	categoryID INT, 
	categoryTypeID INT, 
	categoryName varchar(128), 
	categoryNameDerived varchar(128),
	categoryAlias varchar(128),
	parentID INT, 
	displayLevel INT,
	displayOrder varchar(128), 
	displayOrderDerived varchar(128),
	categoryActive BIT, 
	ShowInNavigation BIT,
	categoryPriority INT, 
	categoryPriorityDerived INT, 
	categoryURL varchar(512), 
	categoryURLDerived varchar(512),
	categoryPropertiesID INT, 
	workflowStatusID INT, 
	templateID INT, 
	cacheDateTime datetime,
	sourceID INT,
	categoryLocaleID INT, 
	categoryLocaleActive BIT,
	localeID INT, 
	categoryLocalePropertiesID INT, 
	defaultCategoryLocale BIT,
	categoryActiveDerived BIT,
	CategoryLocalePropertiesPacket text,
	CategoryPropertiesPacket text
	)
	INSERT INTO #tempTable2
	SELECT c.categoryID, c.categoryTypeID, c.categoryName, 
	CASE isNull(cl.categoryLocaleName,''0'')
	WHEN '''' THEN c.categoryName
	WHEN ''0'' THEN c.categoryName
	ELSE cl.categoryLocaleName
	END as categoryNameDerived, 
	c.categoryAlias, c.parentID, c.displayLevel,
	c.displayOrder, 
	c.CategoryLocaleDisplayOrder as displayOrderDerived, 
	c.categoryActive, c.ShowInNavigation, 
	c.categoryPriority, 
	c.CategoryLocalePriority as categoryPriorityDerived,
	c.categoryURL,
	CASE isNull(cl.categoryLocaleURL,''0'')
	WHEN ''0'' THEN c.categoryURL
	WHEN '''' THEN c.categoryURL
	ELSE cl.categoryLocaleURL
	END as categoryURLDerived,
	c.propertiesID As categoryPropertiesID, c.workflowStatusID, c.templateID, c.cacheDateTime,
	c.sourceID, cl.categoryLocaleID, cl.categoryLocaleActive, 
	cl.localeID, cl.propertiesID As categoryLocalePropertiesID, cl.defaultCategoryLocale,
	CASE c.categoryActive
	WHEN 0 THEN 0
	WHEN NULL THEN 0
	ELSE cl.categoryLocaleActive
	END as categoryActiveDerived,
	p.PropertiesPacket AS CategoryLocalePropertiesPacket,
	p2.PropertiesPacket AS CategoryPropertiesPacket
	FROM t_Properties p 
	RIGHT OUTER JOIN t_CategoryLocale cl 
	ON p.PropertiesID = cl.PropertiesID 
	RIGHT OUTER JOIN qry_GetCategoryMeta c 
	ON cl.CategoryID = c.CategoryID
	RIGHT OUTER JOIN t_Properties p2
	ON p2.PropertiesID = c.PropertiesID
	WHERE c.categoryID = @categoryID 
	AND cl.localeID = CASE @localeIDexists --if the localeID does not exist, use the defaultLocaleID 
			  WHEN 0 THEN @defaultCategoryLocaleID
			  ELSE @localeID
			  END
	and c.localeid = @localeID
	ORDER BY c.categoryPriority
	
	IF @categoryActiveDerived IS NOT NULL
		SELECT *
		FROM #tempTable2
		WHERE categoryActiveDerived = @categoryActiveDerived
	ELSE
		SELECT *
		FROM #tempTable2
	DROP TABLE #tempTable2	
	
  END
' 
END
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.views WHERE object_id = OBJECT_ID(N'[dbo].[qry_GetContentNote]'))
EXEC dbo.sp_executesql @statement = N'CREATE VIEW [dbo].[qry_GetContentNote]
AS   
SELECT t_Content.*, t_ContentNote.UserID AS UserID, 
    t_ContentNote.ContentNote AS ContentNote, 
    t_ContentNote.ContentNoteDate AS ContentNoteDate, 
    t_ContentNote.ContentNoteID AS ContentNoteID, 
    t_User.UserLogin AS UserLogin
FROM t_Content INNER JOIN 
    t_ContentNote ON 
    t_Content.ContentID = t_ContentNote.ContentID INNER JOIN
    t_User ON t_ContentNote.UserID = t_User.UserID
' 
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.views WHERE object_id = OBJECT_ID(N'[dbo].[qry_GetContentLocale]'))
EXEC dbo.sp_executesql @statement = N'CREATE VIEW [dbo].[qry_GetContentLocale]
AS
SELECT     dbo.t_Content.ContentID, dbo.t_Content.CategoryID, dbo.t_Content.ContentTypeID, dbo.t_Content.ContentPriority, dbo.t_Content.ContentActive, 
                      dbo.t_Content.ContentIndexed, dbo.t_Content.SourceID, dbo.t_ContentLocale.ContentLocaleID, 
                      dbo.t_ContentLocale.PropertiesID AS ContentLocalePropertiesID, dbo.t_Locale.LocaleID,  
                      dbo.t_Properties.PropertiesPacket AS ContentLocalePropertiesPacket, dbo.t_Content.ContentDate1, dbo.t_Content.ContentDate2, 
                      dbo.t_Content.ContentName, dbo.t_ContentLocale.ContentBody
FROM         dbo.t_Content INNER JOIN
                      dbo.t_ContentLocale ON dbo.t_Content.ContentID = dbo.t_ContentLocale.ContentID INNER JOIN
                      dbo.t_Locale ON dbo.t_ContentLocale.LocaleID = dbo.t_Locale.LocaleID INNER JOIN
                      dbo.t_Properties ON dbo.t_ContentLocale.PropertiesID = dbo.t_Properties.PropertiesID
' 
GO

GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.views WHERE object_id = OBJECT_ID(N'[dbo].[qry_GetContentLocaleMeta]'))
EXEC dbo.sp_executesql @statement = N'CREATE VIEW [dbo].[qry_GetContentLocaleMeta]
AS
SELECT     dbo.t_Content.*, dbo.t_ContentLocaleMeta.LocaleID, dbo.t_ContentLocaleMeta.ContentLocalePriority, dbo.t_ContentLocaleMeta.ContentPositionID
FROM         dbo.t_Content INNER JOIN
                      dbo.t_ContentLocaleMeta ON dbo.t_Content.ContentID = dbo.t_ContentLocaleMeta.ContentID
' 
GO

GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[sp_getContent]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'CREATE Procedure [dbo].[sp_getContent]
@contentID INT, 
@localeID INT,
@contentActiveDerived BIT=NULL,
@defaultContentLocale BIT=NULL
AS
--Created by John WebWilliam Avila on 08.12.2004
--Notes:
---localeID: 
----2: United States
----3: Spain
DECLARE @defaultContentLocaleID INT, @localeIDexists INT, @sql nvarchar(4000)
--Get the Default LocaleID for this record
SET @defaultContentLocaleID = (SELECT localeID FROM t_ContentLocale
WHERE contentID = @contentID
AND defaultContentLocale = 1)
--If the current Default LocaleID does not exist, then set the variable to 0
IF @defaultContentLocaleID IS NULL
  SET @defaultContentLocaleID = 0
--Get the localeID
SET @localeIDexists = (SELECT localeID
FROM t_ContentLocale
WHERE contentID = @contentID
AND localeID = @localeID) 
--If the current localeID does not exist, then set the variable to 0
IF @localeIDexists IS NULL
  SET @localeIDexists = 0
--18 columns
--If no record exists in t_ContentLocale, then just get content information
IF @defaultContentLocaleID = 0 AND @localeIDexists = 0
  BEGIN
	SET @sql = ''SELECT c.contentID, c.categoryID, c.contentName, c.contentName As contentNameDerived, '''''''' as ContentLocaleName,
	c.contentTypeID, c.contentPositionID, c.contentPriority, c.contentLocalePriority, c.contentActive, c.ContentDate1, c.ContentDate2,
	0 as contentActiveDerived, c.contentIndexed, 
	c.sourceID, c.propertiesID as contentPropertiesID,
	NULL As contentLocaleID, NULL As contentLocaleActive, 
	NULL As localeID, NULL As contentBody, NULL As contentLocalePropertiesID, 
	NULL As defaultContentLocale
	FROM qry_GetContentLocaleMeta c 
	WHERE c.contentID = ''+Cast(@contentID As nvarchar(16))+'' AND c.LocaleID = ''+Cast(@localeID As nvarchar(16))+ '' AND ''
	SET @sql = @sql + CASE @contentActiveDerived
			  WHEN 0 THEN ''1=1 ''
			  WHEN 1 THEN ''1=0 ''
			  ELSE ''1 = 1 ''
			  END
SET @sql = @sql + CASE @defaultContentLocale
			  WHEN 0 THEN ''AND 1=1 ''
			  WHEN 1 THEN ''AND 1=0 ''
			  ELSE ''AND 1 = 1 ''
			  END
	SET @sql = @sql + ''ORDER BY c.contentPriority''
	EXEC (@sql)
  END
ELSE --the the combination of both t_content and t_ContentLocale information
  BEGIN
	CREATE TABLE #tempTable2 (
	contentID INT, 
	categoryID INT, 
	contentName varchar(1000), 
	contentNameDerived varchar(1000),
	ContentLocaleName varchar(1000),
	contentTypeID INT, 
	contentPositionID INT, 
	contentPriority INT, 
	contentLocalePriority INT, 
	contentActive BIT,
	ContentDate1 datetime,
	ContentDate2 datetime,
	contentActiveDerived BIT, 
	contentIndexed BIT, 
	sourceID INT, 
	contentPropertiesID INT,
	contentLocaleID INT, 
	contentLocaleActive BIT, 
	localeID INT, 
	contentBody ntext, 
	contentLocalePropertiesID INT,
	defaultContentLocale BIT
	)
	INSERT INTO #tempTable2
	SELECT c.contentID, c.categoryID, c.contentName,
	CASE isNull(cl.contentLocaleName,''0'')
	WHEN '''' THEN c.contentName
	WHEN ''0'' THEN c.contentName
	ELSE cl.contentLocaleName
	END as contentNameDerived, cl.ContentLocaleNAme,
	c.contentTypeID, c.contentPositionID, c.contentPriority, c.ContentLocalePriority, c.contentActive,
	c.ContentDate1, c.ContentDate2,
	CASE c.contentActive
	WHEN 0 THEN 0
	WHEN NULL THEN 0
	ELSE cl.contentLocaleActive
	END as contentActiveDerived,
	c.contentIndexed,
	c.sourceID, c.propertiesID as contentPropertiesID, 
	cl.contentLocaleID, cl.contentLocaleActive, 
	cl.localeID, cl.contentBody, cl.propertiesID As contentLocalePropertiesID, 
	cl.defaultContentLocale
	FROM qry_GetcontentLocaleMeta c RIGHT OUTER JOIN t_ContentLocale cl
	ON c.contentID = cl.contentID
	WHERE c.contentID = @contentID and c.LocaleID = @localeID
	AND cl.localeID = CASE @localeIDexists --if the localeID does not exist, use the defaultLocaleID
			  WHEN 0 THEN @defaultContentLocaleID
			  ELSE @localeID
			  END
	ORDER BY c.contentPriority
	IF @contentActiveDerived IS NOT NULL
	  SELECT *
	  FROM #tempTable2
	  WHERE contentActiveDerived = @contentActiveDerived
	ELSE
	  SELECT *
	  FROM #tempTable2
	
	DROP TABLE #tempTable2
  END
' 
END
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.views WHERE object_id = OBJECT_ID(N'[dbo].[qry_GetPermissions]'))
EXEC dbo.sp_executesql @statement = N'CREATE VIEW [dbo].[qry_GetPermissions]
AS
SELECT     dbo.t_Permissions.*, dbo.t_Label.LabelName AS UserGroupName
FROM         dbo.t_Label INNER JOIN
                      dbo.t_Permissions ON dbo.t_Label.LabelID = dbo.t_Permissions.UserGroupID
' 
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO
IF NOT EXISTS (SELECT * FROM sys.views WHERE object_id = OBJECT_ID(N'[dbo].[qry_GetMime]'))
EXEC dbo.sp_executesql @statement = N'CREATE VIEW [dbo].[qry_GetMime]
AS
SELECT     dbo.t_Mime.*, dbo.t_MimeExtensions.MimeExtension AS MimeExtension, dbo.t_Label.LabelName AS MimeMediaType
FROM         dbo.t_Mime INNER JOIN
                      dbo.t_MimeExtensions ON dbo.t_Mime.MimeID = dbo.t_MimeExtensions.MimeID INNER JOIN
                      dbo.t_Label ON dbo.t_Mime.MimeMediaTypeID = dbo.t_Label.LabelID
' 
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.views WHERE object_id = OBJECT_ID(N'[dbo].[qry_GetUser]'))
EXEC dbo.sp_executesql @statement = N'CREATE VIEW [dbo].[qry_GetUser]
AS  
SELECT     dbo.t_User.*, dbo.t_UserGroup.UserGroupID AS UserGroupID, dbo.t_Label.LabelName AS UserGroupName
FROM         dbo.t_UserGroup INNER JOIN
                      dbo.t_User ON dbo.t_UserGroup.UserID = dbo.t_User.UserID INNER JOIN
                      dbo.t_Label ON dbo.t_UserGroup.UserGroupID = dbo.t_Label.LabelID
 
' 
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.views WHERE object_id = OBJECT_ID(N'[dbo].[qry_GetTracking]'))
EXEC dbo.sp_executesql @statement = N'CREATE VIEW [dbo].[qry_GetTracking]
AS
SELECT     dbo.t_Tracking.*, dbo.t_User.UserLogin AS UserLogin, dbo.t_Label.LabelName AS OperationName, dbo.t_Label.LabelCode AS OperationCode
FROM         dbo.t_Tracking LEFT OUTER JOIN
                      dbo.t_User ON dbo.t_Tracking.UserID = dbo.t_User.UserID LEFT OUTER JOIN
                      dbo.t_Label ON dbo.t_Tracking.OperationID = dbo.t_Label.LabelID
' 
GO
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[sp_getContentsNoPosition]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'CREATE Procedure [dbo].[sp_getContentsNoPosition]
@localeID INT,
@categoryID INT,
@contentActiveDerived BIT=NULL
As
--Created by John WebWilliam Avila on 08.12.2004
--Create a temporary table with 18 fields from the sp_Content sp
CREATE TABLE #tempTable (
contentID INT, 
categoryID INT, 
contentName varchar(1000), 
contentNameDerived varchar(1000),
ContentLocaleName varchar(1000),
contentTypeID INT, 
contentPositionID INT, 
contentPriority INT, 
contentLocalePriority int,
contentActive BIT,
ContentDate1 DateTime,
ContentDate2 DateTime,
contentActiveDerived BIT, 
contentIndexed BIT, 
sourceID INT, 
contentPropertiesID INT,
contentLocaleID INT, 
contentLocaleActive BIT, 
localeID INT, 
contentBody ntext, 
contentLocalePropertiesID INT,
defaultContentLocale BIT
)
-- Loop over the content items based on a categoryID
-- =============================================
DECLARE cursorA CURSOR 
KEYSET FOR SELECT contentID FROM t_Content
WHERE categoryID = @categoryID
ORDER BY contentPriority
DECLARE @contentID INT
OPEN cursorA
FETCH NEXT FROM cursorA INTO @contentID
WHILE (@@fetch_status <> -1)
BEGIN
	IF (@@fetch_status <> -2)
	BEGIN
		INSERT INTO #tempTable
		EXEC sp_getContent @contentID, @localeID, @contentActiveDerived, NULL
	END
	FETCH NEXT FROM cursorA INTO @contentID
END
CLOSE cursorA
DEALLOCATE cursorA
-- =============================================
SELECT *
FROM #tempTable
DROP TABLE #tempTable
' 
END
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.views WHERE object_id = OBJECT_ID(N'[dbo].[qry_GetCategoryExtended]'))
EXEC dbo.sp_executesql @statement = N'CREATE VIEW [dbo].[qry_GetCategoryExtended]
AS
SELECT     dbo.qry_GetCategory.*, dbo.qry_GetCategoryLastVersionChange.MaxTrackingDateTime AS Expr1
FROM         dbo.qry_GetCategory INNER JOIN
                      dbo.qry_GetCategoryLastVersionChange ON dbo.qry_GetCategory.CategoryID = dbo.qry_GetCategoryLastVersionChange.CategoryID
' 
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.views WHERE object_id = OBJECT_ID(N'[dbo].[qry_GetCategoryWithCategoryLocale]'))
EXEC dbo.sp_executesql @statement = N'CREATE VIEW [dbo].[qry_GetCategoryWithCategoryLocale]
AS
SELECT     dbo.qry_GetCategory.CategoryID, dbo.qry_GetCategory.CategoryTypeID, dbo.qry_GetCategory.CategoryName, dbo.qry_GetCategory.CategoryAlias, 
                      dbo.qry_GetCategory.ParentID, dbo.qry_GetCategory.DisplayLevel, dbo.qry_GetCategory.DisplayOrder, dbo.qry_GetCategory.CategoryActive, 
                      dbo.qry_GetCategory.CategoryPriority, dbo.qry_GetCategory.CategoryURL, dbo.qry_GetCategory.PropertiesID AS CategoryPropertiesID, 
                      dbo.qry_GetCategory.WorkflowStatusID, dbo.qry_GetCategory.TemplateID, dbo.qry_GetCategory.PropertiesPacket AS CategoryPropertiesPacket, 
                      dbo.qry_GetCategory.CategoryTypeName, dbo.qry_GetCategoryLocale.CategoryLocaleID, dbo.qry_GetCategoryLocale.CategoryLocaleActive, 
                      dbo.qry_GetCategoryLocale.CategoryLocaleName, dbo.qry_GetCategoryLocale.LocaleID, 
                      dbo.qry_GetCategoryLocale.PropertiesID AS CategoryLocalePropertiesID, dbo.qry_GetCategoryLocale.LocaleName, 
                      dbo.qry_GetCategoryLocale.LanguageName, dbo.qry_GetCategoryLocale.LanguageCode, 
                      dbo.qry_GetCategoryLocale.PropertiesPacket AS CategoryLocalePropertiesPacket, dbo.qry_GetCategory.CacheDateTime, 
                      dbo.qry_GetCategory.ShowInNavigation
FROM         dbo.qry_GetCategory LEFT OUTER JOIN
                      dbo.qry_GetCategoryLocale ON dbo.qry_GetCategory.CategoryID = dbo.qry_GetCategoryLocale.CategoryID
' 
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[sp_getContents]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'CREATE Procedure [dbo].[sp_getContents]
@localeID INT,
@categoryID INT,
@contentPositionID INT,
@contentActiveDerived BIT=NULL,
@DefaultContentLocale BIT=NULL
As
--Created by John WebWilliam Avila on 08.12.2004
--Create a temporary table with 18 fields from the sp_Content sp
CREATE TABLE #tempTable (
contentID INT, 
categoryID INT, 
contentName varchar(1000), 
contentNameDerived varchar(1000),
ContentLocaleName varchar(1000),
contentTypeID INT, 
contentPositionID INT, 
contentPriority INT, 
contentLocalePriority INT, 
contentActive BIT,
ContentDate1 DateTime,
ContentDate2 DateTime,
contentActiveDerived BIT, 
contentIndexed BIT, 
sourceID INT, 
contentPropertiesID INT,
contentLocaleID INT, 
contentLocaleActive BIT, 
localeID INT, 
contentBody ntext, 
contentLocalePropertiesID INT,
defaultContentLocale BIT
)
-- Loop over the content items based on a categoryID
-- =============================================
DECLARE cursorA CURSOR 
KEYSET FOR SELECT contentID FROM qry_GetContentLocaleMeta
WHERE categoryID = @categoryID
AND contentPositionID = @contentPositionID
AND LocaleID=@LocaleID
ORDER BY contentLocalePriority
DECLARE @contentID INT
OPEN cursorA
FETCH NEXT FROM cursorA INTO @contentID
WHILE (@@fetch_status <> -1)
BEGIN
	IF (@@fetch_status <> -2)
	BEGIN
		INSERT INTO #tempTable
		EXEC sp_getContent @contentID, @localeID, @contentActiveDerived, @defaultContentLocale
	END
	FETCH NEXT FROM cursorA INTO @contentID
END
CLOSE cursorA
DEALLOCATE cursorA
-- =============================================
SELECT *
FROM #tempTable
DROP TABLE #tempTable
' 
END
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[sp_getPages]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'CREATE Procedure [dbo].[sp_getPages]
@localeID INT,
@displayOrder nvarchar(128)=NULL,
@categoryActiveDerived BIT=NULL,
@ParentID INT,
@DisplayLevelList nvarchar(128)=NULL,
@CategoryIDList nvarchar(1000)=NULL,
@CategoryTypeIDList nvarchar(128)=NULL,
@NotCategoryTypeIDList nvarchar(129)=NULL,
@ShowInNavigation BIT=NULL
As
--Created by John WebWilliam Avila on 08.12.2004
--Create a temporary table with 23 fields from the sp_Page sp
CREATE TABLE #tempTable (
categoryID INT, 
categoryTypeID INT, 
categoryName varchar(128), 
categoryNameDerived varchar(128),
categoryAlias varchar(128),
parentID INT, 
displayLevel INT,
displayOrder varchar(128), 
displayOrderDerived varchar(128), 
categoryActive BIT, 
ShowInNavigation BIT,
categoryPriority INT, 
categoryPriorityDerived INT, 
categoryURL varchar(512), 
categoryURLDerived varchar(512),
categoryPropertiesID INT, 
workflowStatusID INT, 
templateID INT, 
cacheDateTime datetime,
sourceID INT,
categoryLocaleID INT, 
categoryLocaleActive BIT,
localeID INT, 
categoryLocalePropertiesID INT, 
defaultCategoryLocale BIT,
categoryActiveDerived BIT,
CategoryLocalePropertiesPacket text,
CategoryPropertiesPacket text
)
--Declare a string variable to hold the begining of the Loop TSQL
DECLARE @sqlString nvarchar(1000)
-- Loop
-- =============================================
SET @sqlString = ''DECLARE cursorA CURSOR KEYSET FOR SELECT categoryID FROM qry_GetCategoryMeta WHERE ''
SET @sqlString = @sqlString + '' LocaleID = ''+ cast(@LocaleID as nvarchar(128)) + '' AND ''
--If the displayOrder is not null, then where like wildcard
IF @displayOrder IS NOT NULL
  SET @sqlString = @sqlString + '' CategoryLocaledisplayOrder LIKE ''''''+@displayOrder+''%'''' AND ''
IF @ParentID IS NOT NULL
  SET @sqlString = @sqlString + '' ParentID = ''+ cast(@ParentID as nvarchar(128)) + '' AND ''
IF @DisplayLevelList IS NOT NULL
  SET @sqlString = @sqlString + '' DisplayLevel in (''+ @DisplayLevelList + '') AND ''
  
IF @CategoryIDList IS NOT NULL
  SET @sqlString = @sqlString + '' CategoryID in (''+ @CategoryIDList + '') AND ''
  
IF @CategoryTypeIDList IS NOT NULL
  SET @sqlString = @sqlString + '' CategoryTypeID in (''+ @CategoryTypeIDList + '') AND ''
  
IF @NotCategoryTypeIDList IS NOT NULL
  SET @sqlString = @sqlString + '' CategoryTypeID NOT in (''+ @NotCategoryTypeIDList + '') AND ''
IF @ShowInNavigation IS NOT NULL
  SET @sqlString = @sqlString + '' ShowInNavigation = ''+ cast(@ShowInNavigation as nvarchar(1)) +'' AND ''
  
SET @sqlString = @sqlString + '' 1=1 ORDER BY CategoryLocaleDisplayOrder''
EXEC (@sqlString)
--PRINT @sqlString
--RETURN
DECLARE @catID INT
OPEN cursorA
FETCH NEXT FROM cursorA INTO @catID
WHILE (@@fetch_status <> -1)
BEGIN
	IF (@@fetch_status <> -2)
	BEGIN
		INSERT INTO #tempTable
		EXEC sp_getPage @catID, @localeID, @categoryActiveDerived
	END
	FETCH NEXT FROM cursorA INTO @catID
END
CLOSE cursorA
DEALLOCATE cursorA
-- =============================================
SELECT *
FROM #tempTable
ORDER BY displayOrderDerived
DROP TABLE #tempTable
' 
END
