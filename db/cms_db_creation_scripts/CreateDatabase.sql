USE [master]
GO
/****** Object:  Database [cmsdemo_cms_dev]    Script Date: 08/25/2007 17:32:50 ******/
CREATE DATABASE [cmsdemo_cms_dev] ON  PRIMARY 
(	NAME = N'cmsdemo_cms_dev', 
	FILENAME = N'd:\data\cmsdemo_cms_dev\cmsdemo_cms_dev.mdf' , 
	SIZE = 3072KB , MAXSIZE = UNLIMITED, FILEGROWTH = 1024KB )
 LOG ON 
(	NAME = N'cmsdemo_cms_dev_log', 
	FILENAME = N'd:\data\cmsdemo_cms_dev\cmsdemo_cms_dev_log.ldf' , 
	SIZE = 1024KB , MAXSIZE = 2048GB , FILEGROWTH = 10%)
	COLLATE SQL_Latin1_General_CP1_CI_AS
GO
EXEC dbo.sp_dbcmptlevel @dbname=N'cmsdemo_cms_dev', @new_cmptlevel=90
GO
IF (1 = FULLTEXTSERVICEPROPERTY('IsFullTextInstalled'))
begin
EXEC [cmsdemo_cms_dev].[dbo].[sp_fulltext_database] @action = 'disable'
end
GO
ALTER DATABASE [cmsdemo_cms_dev] SET ANSI_NULL_DEFAULT OFF 
GO
ALTER DATABASE [cmsdemo_cms_dev] SET ANSI_NULLS OFF 
GO
ALTER DATABASE [cmsdemo_cms_dev] SET ANSI_PADDING OFF 
GO
ALTER DATABASE [cmsdemo_cms_dev] SET ANSI_WARNINGS OFF 
GO
ALTER DATABASE [cmsdemo_cms_dev] SET ARITHABORT OFF 
GO
ALTER DATABASE [cmsdemo_cms_dev] SET AUTO_CLOSE OFF 
GO
ALTER DATABASE [cmsdemo_cms_dev] SET AUTO_CREATE_STATISTICS ON 
GO
ALTER DATABASE [cmsdemo_cms_dev] SET AUTO_SHRINK OFF 
GO
ALTER DATABASE [cmsdemo_cms_dev] SET AUTO_UPDATE_STATISTICS ON 
GO
ALTER DATABASE [cmsdemo_cms_dev] SET CURSOR_CLOSE_ON_COMMIT OFF 
GO
ALTER DATABASE [cmsdemo_cms_dev] SET CURSOR_DEFAULT  GLOBAL 
GO
ALTER DATABASE [cmsdemo_cms_dev] SET CONCAT_NULL_YIELDS_NULL OFF 
GO
ALTER DATABASE [cmsdemo_cms_dev] SET NUMERIC_ROUNDABORT OFF 
GO
ALTER DATABASE [cmsdemo_cms_dev] SET QUOTED_IDENTIFIER OFF 
GO
ALTER DATABASE [cmsdemo_cms_dev] SET RECURSIVE_TRIGGERS OFF 
GO
ALTER DATABASE [cmsdemo_cms_dev] SET  ENABLE_BROKER 
GO
ALTER DATABASE [cmsdemo_cms_dev] SET AUTO_UPDATE_STATISTICS_ASYNC OFF 
GO
ALTER DATABASE [cmsdemo_cms_dev] SET DATE_CORRELATION_OPTIMIZATION OFF 
GO
ALTER DATABASE [cmsdemo_cms_dev] SET ALLOW_SNAPSHOT_ISOLATION OFF 
GO
ALTER DATABASE [cmsdemo_cms_dev] SET PARAMETERIZATION SIMPLE 
GO
ALTER DATABASE [cmsdemo_cms_dev] SET  READ_WRITE 
GO
ALTER DATABASE [cmsdemo_cms_dev] SET RECOVERY FULL 
GO
ALTER DATABASE [cmsdemo_cms_dev] SET  MULTI_USER 
GO
ALTER DATABASE [cmsdemo_cms_dev] SET PAGE_VERIFY CHECKSUM  
