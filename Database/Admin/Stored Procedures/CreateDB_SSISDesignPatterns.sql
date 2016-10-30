/*
 Pre-Deployment Script Template							
--------------------------------------------------------------------------------------
 This file contains SQL statements that will be executed before the build script.	
 Use SQLCMD syntax to include a file in the pre-deployment script.			
 Example:      :r .\myfile.sql								
 Use SQLCMD syntax to reference a variable in the pre-deployment script.		
 Example:      :setvar TableName MyTable							
               SELECT * FROM [$(TableName)]					
--------------------------------------------------------------------------------------
*/
USE [master];
GO
DROP DATABASE IF EXISTS SSISDesignPatterns;
CREATE DATABASE SSISDesignPatterns
ON PRIMARY
( NAME = SSISDPDat,
    FILENAME = 'C:\MSSQL13.MSSQLSERVER\MSSQL\User\ssisdp.mdf',
    SIZE = 10MB,
    MAXSIZE = 50MB,
    FILEGROWTH = 10% )
LOG ON
( NAME = SSISDPLog,
    FILENAME = 'C:\MSSQL13.MSSQLSERVER\MSSQL\Log\ssisdp.ldf',
    SIZE = 5MB,
    MAXSIZE = 25MB,
    FILEGROWTH = 5MB ) ;
GO