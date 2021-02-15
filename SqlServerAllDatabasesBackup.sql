DECLARE @name VARCHAR(50) -- database name
DECLARE @path VARCHAR(256) -- path for backup files
DECLARE @fileName VARCHAR(256) -- filename for backup
DECLARE @fileDate VARCHAR(20) -- used for file name 
 
-- please change the set @path = 'change to your backup location'. for example,
-- SET @path = 'C:\backup\'
-- or SET @path = 'O:\sqlbackup\' if you using remote drives
-- note that remotedrive setup is extra step you have to perform in sql server in order to backup your dbs to remote drive
-- you have to chnage you sql server accont to a network account and add that user to have full access to the network drive you are backing up to
 
SET @path = 'F:\SQLBackups\'  
 
SELECT @fileDate = CONVERT(VARCHAR(20),GETDATE(),112) 
 
DECLARE db_cursor CURSOR FOR
SELECT name
FROM master.dbo.sysdatabases
WHERE name NOT IN ('master','model','msdb','tempdb')  
 
OPEN db_cursor
FETCH NEXT FROM db_cursor INTO @name   
 
WHILE @@FETCH_STATUS = 0
BEGIN
       SET @fileName = @path + @fileDate + '_' + @name + '.BAK'
       BACKUP DATABASE @name TO DISK = @fileName  
 
       FETCH NEXT FROM db_cursor INTO @name
END  
 
CLOSE db_cursor
DEALLOCATE db_cursor