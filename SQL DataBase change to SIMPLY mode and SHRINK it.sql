USE [master]
GO
ALTER DATABASE [DataBase] SET RECOVERY SIMPLE WITH NO_WAIT
GO
USE [DataBase]
GO
DBCC SHRINKDATABASE(N'DataBase' )
GO