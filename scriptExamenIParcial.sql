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
Alter PROCEDURE usp_CrearBackup
AS
DECLARE @AwDv_ccastrohz_Dinamico VARCHAR (100)
SET @AwDv_ccastrohz_Dinamico = N'AwDv_ccastrohz ' +  FORMAT (GETDATE(),'yyyyMMdd_hhmmss');
BACKUP DATABASE AdventureWorks2019
TO AwDv_ccastrohz
WITH NOFORMAT, NOINIT, NAME = @AwDv_ccastrohz_Dinamico
GO
 
--EXEC usp_CrearBackup

--database mail

sp_configure 'Database Mail XPs', 1;
GO
RECONFIGURE
GO

-- Creando perfil de database mail 
EXECUTE msdb.dbo.sysmail_add_profile_sp  
    @profile_name = 'Camilo Castro',  
    @description = 'Administrador base de datos' ;  
GO

-- Acceso al perfil  
EXECUTE msdb.dbo.sysmail_add_principalprofile_sp  
    @profile_name = 'Camilo Castro',  
    @principal_name = 'public',  
    @is_default = 1 ;
GO

EXECUTE msdb.dbo.sysmail_add_account_sp  
    @account_name =  'Camilo Castro',  
    @description =   'Configuracion de Correo',  
    @email_address = 'castro_h24@outlook.com',  
    @display_name =  'Administrador',  
    @mailserver_name = 'smtp-mail.outlook.com',
    @port = 587,
    @enable_ssl = 1,
    @username = 'castro_h24@outlook.com',
    @password = '***' ;  
GO

-- Añadiendo cuenta al perfil  
EXECUTE msdb.dbo.sysmail_add_profileaccount_sp  
    @profile_name = 'Camilo Castro',  
    @account_name = 'Camilo Castro',  
    @sequence_number =1 ;  
GO


EXEC msdb.dbo.sp_send_dbmail
     @profile_name = 'Camilo Castro',
     @recipients = 'williamjsg@gmail.com',
     @body = 'Enviando correo de prueba',
     @subject = 'Probando configuracion database mail';
GO

SELECT * FROM msdb.dbo.sysmail_event_log;