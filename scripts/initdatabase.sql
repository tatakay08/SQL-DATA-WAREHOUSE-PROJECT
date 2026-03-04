/*
=======================================================================
Create Database and Schemas
=======================================================================

Script Purpose
  This script creates a  new database named datawarehouse after checking if it already exists.
  If the database exists, it is dropped and recreated. Additionally, the script sets up three schemas (layers) within the database using the medallion method within the database: 'bronze', 'silver', 'gold'.

WARNING:
  Running this script will drop the entire datawarehouse database if it exists.
  All data in the database will be permanently deleted. Proceed with caution and ensure that you have proper backups before running the script.
*/
USE master;
GO

IF EXISTS (SELECT 1 FROM sys.databases WHERE name = 'Roducate_DataWarehouse')
BEGIN
    ALTER DATABASE Roducate_DataWarehouse SET SINGLE_USER WITH ROLLBACK IMMEDIATE;
    DROP DATABASE Roducate_DataWarehouse;
END;
GO

-- Create the 'Roducate_DataWarehouse' database
CREATE DATABASE Roducate_DataWarehouse;
GO

USE Roducate_DataWarehouse;
GO

-- Create Schemas
CREATE SCHEMA Bronze;
GO

CREATE SCHEMA Silver;
GO

CREATE SCHEMA Gold;
GO
