﻿USE SSISDesignPatterns
GO

-- Note, for this demo the column FormattedComma field is used for Type 1, 
-- the column FormattedZero will be used for Type 2


-- Reset source, if needed
DECLARE @MaxRows    BIGINT = 10000
EXEC DDL.CreateSourceTable 'Source', '03_SCD_Type_2', @MaxRows

-- If needed, reset target table
DECLARE @IncludeType2 BIT = 1
EXEC DDL.CreateTargetTable 'Target', '03_SCD_Type_2', @IncludeType2


-- Show data prior to first run, will be empty table.
SELECT [03_SCD_Type_2SK]
      ,[BigNumber]
      ,[FormattedComma]
      ,[FormattedZero]
      ,[SourceCIUD]
      ,[TargetCIUD]
      ,[IsRowDeleted]
      ,[EffectiveDate]
      ,[ExpirationDate]
      ,[IsCurrentRecord]
  FROM [Target].[03_SCD_Type_2]
 ORDER BY [BigNumber]

 -- Run the package to do the initial load. 

 -- Show the table with rows in it.
SELECT [03_SCD_Type_2SK]
      ,[BigNumber]
      ,[FormattedComma]
      ,[FormattedZero]
      ,[SourceCIUD]
      ,[TargetCIUD]
      ,[IsRowDeleted]
      ,[EffectiveDate]
      ,[ExpirationDate]
      ,[IsCurrentRecord]
  FROM [Target].[03_SCD_Type_2]
 ORDER BY [BigNumber]

-- Show number of rows by update type
SELECT 'Source' AS SourceTarget, [SourceCIUD] AS CIUD, FORMAT(COUNT([SourceCIUD]), '#,##0') AS CIUDCount
  FROM [Target].[03_SCD_Type_2]
 GROUP BY [SourceCIUD]
UNION
SELECT 'Target' AS SourceTarget, [TargetCIUD] AS CIUD, FORMAT(COUNT([TargetCIUD]), '#,##0') AS CIUDCount
  FROM [Target].[03_SCD_Type_2]
 GROUP BY [TargetCIUD]
 ORDER BY [SourceTarget], [CIUD]


-- Update rows in the source
-- Note, FormattedComma field is used for T1, FormattedZero for T2
-- Declare variables we'll need for the CUD
DECLARE @MaxInsertRowsT1  BIGINT = 12000
DECLARE @UpdateFromT1     BIGINT = 500
DECLARE @UpdateThruT1     BIGINT = 999
DECLARE @IncludeType2ChangeT1 BIT = 0
DECLARE @DeleteFrom       BIGINT = -1
DECLARE @DeleteThru       BIGINT = -1

EXECUTE [CUD].[03_SCD_Type_2_T1] @MaxInsertRowsT1, @UpdateFromT1, @UpdateThruT1, @DeleteFrom, @DeleteThru, @IncludeType2ChangeT1
GO

DECLARE @MaxInsertRowsT2  BIGINT = 15000
DECLARE @UpdateFromT2     BIGINT = 5000
DECLARE @UpdateThruT2     BIGINT = 5999
DECLARE @IncludeType2ChangeT2 BIT = 1
DECLARE @DeleteFrom       BIGINT = -1
DECLARE @DeleteThru       BIGINT = -1

EXECUTE [CUD].[03_SCD_Type_2_T2] @MaxInsertRowsT2, @UpdateFromT2, @UpdateThruT2, @DeleteFrom, @DeleteThru, @IncludeType2ChangeT2
GO


-- Rerun the package

-- Show data post update

-- Again, show number of rows by update type
SELECT 'Source' AS SourceTarget, [SourceCIUD] AS CIUD, FORMAT(COUNT([SourceCIUD]), '#,##0') AS CIUDCount
  FROM [Target].[03_SCD_Type_2]
 GROUP BY [SourceCIUD]
UNION
SELECT 'Target' AS SourceTarget, [TargetCIUD] AS CIUD, FORMAT(COUNT([TargetCIUD]), '#,##0') AS CIUDCount
  FROM [Target].[03_SCD_Type_2]
 GROUP BY [TargetCIUD]
 ORDER BY [SourceTarget], [CIUD]


-- New records 
SELECT [03_SCD_Type_2SK]
      ,[BigNumber]
      ,[FormattedComma]
      ,[FormattedZero]
      ,[SourceCIUD]
      ,[TargetCIUD]
      ,[IsRowDeleted]
      ,[EffectiveDate]
      ,[ExpirationDate]
      ,[IsCurrentRecord]
  FROM [Target].[03_SCD_Type_2]
  WHERE [BigNumber] > (SELECT MAX(BigNumber) -50 FROM [Target].[03_SCD_Type_2] WHERE TargetCIUD = 'Created' )
  ORDER BY [BigNumber]

-- Type 1 updates
SELECT [03_SCD_Type_2SK]
      ,[BigNumber]
      ,[FormattedComma]
      ,[FormattedZero]
      ,[SourceCIUD]
      ,[TargetCIUD]
      ,[IsRowDeleted]
      ,[EffectiveDate]
      ,[ExpirationDate]
      ,[IsCurrentRecord]
  FROM [Target].[03_SCD_Type_2]
 WHERE [BigNumber] > (SELECT MIN(BigNumber) -3 FROM [Target].[03_SCD_Type_2] WHERE TargetCIUD = 'Update' )
   AND [BigNumber] < (SELECT MAX(BigNumber) +3 FROM [Target].[03_SCD_Type_2] WHERE TargetCIUD = 'Update' )
 ORDER BY [BigNumber]

-- Type 2 updates
SELECT [03_SCD_Type_2SK]
      ,[BigNumber]
      ,[FormattedComma]
      ,[FormattedZero]
      ,[SourceCIUD]
      ,[TargetCIUD]
      ,[IsRowDeleted]
      ,[EffectiveDate]
      ,[ExpirationDate]
      ,[IsCurrentRecord]
  FROM [Target].[03_SCD_Type_2]
 WHERE [BigNumber] >  (SELECT MIN(BigNumber) -3 FROM [Target].[03_SCD_Type_2] WHERE TargetCIUD = 'Expire' )
   AND [BigNumber] < (SELECT MAX(BigNumber) +3 FROM [Target].[03_SCD_Type_2] WHERE TargetCIUD = 'Expire' ) 
 ORDER BY [BigNumber]

 
