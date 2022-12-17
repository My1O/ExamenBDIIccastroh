--Examen BDII - primer parcial
-- Dispositivo de almacenamiento
USE AdventureWorks2019
go
--Crear dispositivo de almacenamiento
--1. Crear dispositivo de backUp para Adventureworks2019 : AwDv_ccastroh
EXEC sp_addumpdevice 'disk', 'AwDv_ccastrohz',
'C:\Ing.Sis\BD II\ExamenBDII\DATA\AwDv_ccastroh.bak';
GO

--creat primer backup
BACKUP DATABASE AdventureWorks2019
TO AwDv_ccastrohz
WITH FORMAT, INIT, NAME = N'AdventureWorks_full_backup';
GO

SELECT *
FROM sys.backup_devices
GO

-- BackUp Dinamico -yyyyMMdd.
CREATE PROCEDURE usp_CrearBackup
AS
DECLARE @AwDv_ccastrohz_Dinamico VARCHAR (100)
SET @AwDv_ccastrohz_Dinamico = N'AwDv_ccastroh ' +  FORMAT (GETDATE(),'yyyyMMdd_hhmmss');
BACKUP DATABASE AdventureWorks2019
TO AwDv_ccastrohz
WITH NOFORMAT, NOINIT, NAME = @AwDv_ccastrohz_Dinamico
GO