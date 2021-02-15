USE [msdb]
GO

/****** Object:  Job [Webcon BPS re-index DBs]    Script Date: 1/28/2020 8:05:25 PM ******/
BEGIN TRANSACTION
DECLARE @ReturnCode INT
SELECT @ReturnCode = 0
/****** Object:  JobCategory [[Uncategorized (Local)]]    Script Date: 1/28/2020 8:05:25 PM ******/
IF NOT EXISTS (SELECT name FROM msdb.dbo.syscategories WHERE name=N'[Uncategorized (Local)]' AND category_class=1)
BEGIN
EXEC @ReturnCode = msdb.dbo.sp_add_category @class=N'JOB', @type=N'LOCAL', @name=N'[Uncategorized (Local)]'
IF (@@ERROR <> 0 OR @ReturnCode <> 0) GOTO QuitWithRollback

END

DECLARE @jobId BINARY(16)
EXEC @ReturnCode =  msdb.dbo.sp_add_job @job_name=N'Webcon BPS re-index DBs', 
		@enabled=1, 
		@notify_level_eventlog=0, 
		@notify_level_email=0, 
		@notify_level_netsend=0, 
		@notify_level_page=0, 
		@delete_level=0, 
		@description=N'No description available.', 
		@category_name=N'[Uncategorized (Local)]', 
		@owner_login_name=N'ECM365\SpSetupUsr', @job_id = @jobId OUTPUT
IF (@@ERROR <> 0 OR @ReturnCode <> 0) GOTO QuitWithRollback
/****** Object:  Step [ECM365Tenant_PTAK_BPS_Attachments]    Script Date: 1/28/2020 8:05:25 PM ******/
EXEC @ReturnCode = msdb.dbo.sp_add_jobstep @job_id=@jobId, @step_name=N'ECM365Tenant_PTAK_BPS_Attachments', 
		@step_id=1, 
		@cmdexec_success_code=0, 
		@on_success_action=3, 
		@on_success_step_id=0, 
		@on_fail_action=2, 
		@on_fail_step_id=0, 
		@retry_attempts=0, 
		@retry_interval=0, 
		@os_run_priority=0, @subsystem=N'TSQL', 
		@command=N'-- reindeksacja wszystkich tabel w bazie
DECLARE @TableName varchar(255)
DECLARE @TableSchema varchar(255)
DECLARE @FullName varchar(1000)
 
DECLARE TableCursor CURSOR FOR
SELECT table_name, table_schema FROM information_schema.tables
WHERE table_type = ''BASE TABLE''
 
OPEN TableCursor
 
FETCH NEXT FROM TableCursor INTO @TableName, @TableSchema
WHILE @@FETCH_STATUS = 0
BEGIN 
set @FullName = @TableSchema + ''.'' + @TableName
PRINT ''Reindexing '' + @FullName
DBCC DBREINDEX(@FullName,'' '',70)
FETCH NEXT FROM TableCursor INTO @TableName, @TableSchema
END
 
CLOSE TableCursor
 
DEALLOCATE TableCursor
GO
 
-- aktualizacja statystyk
declare @table_name varchar(2550)
declare @schema_name varchar(255)
declare @full_name varchar(3000)
 
declare idx_cursor cursor
for select distinct a.name, OBJECT_SCHEMA_NAME(a.id)
from sysobjects a, sysindexes b
where a.type = ''U''
and a.id = b.id
and b.indid > 0
open idx_cursor
 
fetch next from idx_cursor into @table_name, @schema_name 
 
while @@fetch_status = 0
begin
      set @full_name = @schema_name + ''.'' + @table_name
    EXEC (''UPDATE STATISTICS '' + @full_name)
fetch next from idx_cursor into @table_name, @schema_name
end
 
close idx_cursor
deallocate idx_cursor
GO
', 
		@database_name=N'ECM365Tenant_PTAK_BPS_Attachments', 
		@flags=0
IF (@@ERROR <> 0 OR @ReturnCode <> 0) GOTO QuitWithRollback
/****** Object:  Step [ECM365Tenant_PTAK_BPS_Content]    Script Date: 1/28/2020 8:05:25 PM ******/
EXEC @ReturnCode = msdb.dbo.sp_add_jobstep @job_id=@jobId, @step_name=N'ECM365Tenant_PTAK_BPS_Content', 
		@step_id=2, 
		@cmdexec_success_code=0, 
		@on_success_action=3, 
		@on_success_step_id=0, 
		@on_fail_action=2, 
		@on_fail_step_id=0, 
		@retry_attempts=0, 
		@retry_interval=0, 
		@os_run_priority=0, @subsystem=N'TSQL', 
		@command=N'-- reindeksacja wszystkich tabel w bazie
DECLARE @TableName varchar(255)
DECLARE @TableSchema varchar(255)
DECLARE @FullName varchar(1000)
 
DECLARE TableCursor CURSOR FOR
SELECT table_name, table_schema FROM information_schema.tables
WHERE table_type = ''BASE TABLE''
 
OPEN TableCursor
 
FETCH NEXT FROM TableCursor INTO @TableName, @TableSchema
WHILE @@FETCH_STATUS = 0
BEGIN 
set @FullName = @TableSchema + ''.'' + @TableName
PRINT ''Reindexing '' + @FullName
DBCC DBREINDEX(@FullName,'' '',70)
FETCH NEXT FROM TableCursor INTO @TableName, @TableSchema
END
 
CLOSE TableCursor
 
DEALLOCATE TableCursor
GO
 
-- aktualizacja statystyk
declare @table_name varchar(2550)
declare @schema_name varchar(255)
declare @full_name varchar(3000)
 
declare idx_cursor cursor
for select distinct a.name, OBJECT_SCHEMA_NAME(a.id)
from sysobjects a, sysindexes b
where a.type = ''U''
and a.id = b.id
and b.indid > 0
open idx_cursor
 
fetch next from idx_cursor into @table_name, @schema_name 
 
while @@fetch_status = 0
begin
      set @full_name = @schema_name + ''.'' + @table_name
    EXEC (''UPDATE STATISTICS '' + @full_name)
fetch next from idx_cursor into @table_name, @schema_name
end
 
close idx_cursor
deallocate idx_cursor
GO
', 
		@database_name=N'ECM365Tenant_PTAK_BPS_Content', 
		@flags=0
IF (@@ERROR <> 0 OR @ReturnCode <> 0) GOTO QuitWithRollback
/****** Object:  Step [ECM365Tenant_PRODIGO_BPS_Content]    Script Date: 1/28/2020 8:05:25 PM ******/
EXEC @ReturnCode = msdb.dbo.sp_add_jobstep @job_id=@jobId, @step_name=N'ECM365Tenant_PRODIGO_BPS_Content', 
		@step_id=3, 
		@cmdexec_success_code=0, 
		@on_success_action=3, 
		@on_success_step_id=0, 
		@on_fail_action=2, 
		@on_fail_step_id=0, 
		@retry_attempts=0, 
		@retry_interval=0, 
		@os_run_priority=0, @subsystem=N'TSQL', 
		@command=N'-- reindeksacja wszystkich tabel w bazie
DECLARE @TableName varchar(255)
DECLARE @TableSchema varchar(255)
DECLARE @FullName varchar(1000)
 
DECLARE TableCursor CURSOR FOR
SELECT table_name, table_schema FROM information_schema.tables
WHERE table_type = ''BASE TABLE''
 
OPEN TableCursor
 
FETCH NEXT FROM TableCursor INTO @TableName, @TableSchema
WHILE @@FETCH_STATUS = 0
BEGIN 
set @FullName = @TableSchema + ''.'' + @TableName
PRINT ''Reindexing '' + @FullName
DBCC DBREINDEX(@FullName,'' '',70)
FETCH NEXT FROM TableCursor INTO @TableName, @TableSchema
END
 
CLOSE TableCursor
 
DEALLOCATE TableCursor
GO
 
-- aktualizacja statystyk
declare @table_name varchar(2550)
declare @schema_name varchar(255)
declare @full_name varchar(3000)
 
declare idx_cursor cursor
for select distinct a.name, OBJECT_SCHEMA_NAME(a.id)
from sysobjects a, sysindexes b
where a.type = ''U''
and a.id = b.id
and b.indid > 0
open idx_cursor
 
fetch next from idx_cursor into @table_name, @schema_name 
 
while @@fetch_status = 0
begin
      set @full_name = @schema_name + ''.'' + @table_name
    EXEC (''UPDATE STATISTICS '' + @full_name)
fetch next from idx_cursor into @table_name, @schema_name
end
 
close idx_cursor
deallocate idx_cursor
GO
', 
		@database_name=N'ECM365Tenant_PRODIGO_BPS_Content', 
		@flags=0
IF (@@ERROR <> 0 OR @ReturnCode <> 0) GOTO QuitWithRollback
/****** Object:  Step [ECM365Tenant_PRODIGO_BPS_Attachments]    Script Date: 1/28/2020 8:05:25 PM ******/
EXEC @ReturnCode = msdb.dbo.sp_add_jobstep @job_id=@jobId, @step_name=N'ECM365Tenant_PRODIGO_BPS_Attachments', 
		@step_id=4, 
		@cmdexec_success_code=0, 
		@on_success_action=3, 
		@on_success_step_id=0, 
		@on_fail_action=2, 
		@on_fail_step_id=0, 
		@retry_attempts=0, 
		@retry_interval=0, 
		@os_run_priority=0, @subsystem=N'TSQL', 
		@command=N'-- reindeksacja wszystkich tabel w bazie
DECLARE @TableName varchar(255)
DECLARE @TableSchema varchar(255)
DECLARE @FullName varchar(1000)
 
DECLARE TableCursor CURSOR FOR
SELECT table_name, table_schema FROM information_schema.tables
WHERE table_type = ''BASE TABLE''
 
OPEN TableCursor
 
FETCH NEXT FROM TableCursor INTO @TableName, @TableSchema
WHILE @@FETCH_STATUS = 0
BEGIN 
set @FullName = @TableSchema + ''.'' + @TableName
PRINT ''Reindexing '' + @FullName
DBCC DBREINDEX(@FullName,'' '',70)
FETCH NEXT FROM TableCursor INTO @TableName, @TableSchema
END
 
CLOSE TableCursor
 
DEALLOCATE TableCursor
GO
 
-- aktualizacja statystyk
declare @table_name varchar(2550)
declare @schema_name varchar(255)
declare @full_name varchar(3000)
 
declare idx_cursor cursor
for select distinct a.name, OBJECT_SCHEMA_NAME(a.id)
from sysobjects a, sysindexes b
where a.type = ''U''
and a.id = b.id
and b.indid > 0
open idx_cursor
 
fetch next from idx_cursor into @table_name, @schema_name 
 
while @@fetch_status = 0
begin
      set @full_name = @schema_name + ''.'' + @table_name
    EXEC (''UPDATE STATISTICS '' + @full_name)
fetch next from idx_cursor into @table_name, @schema_name
end
 
close idx_cursor
deallocate idx_cursor
GO
', 
		@database_name=N'ECM365Tenant_PRODIGO_BPS_Attachments', 
		@flags=0
IF (@@ERROR <> 0 OR @ReturnCode <> 0) GOTO QuitWithRollback
/****** Object:  Step [ECM365Tenant_DAMROB_BPS_Attachments]    Script Date: 1/28/2020 8:05:25 PM ******/
EXEC @ReturnCode = msdb.dbo.sp_add_jobstep @job_id=@jobId, @step_name=N'ECM365Tenant_DAMROB_BPS_Attachments', 
		@step_id=5, 
		@cmdexec_success_code=0, 
		@on_success_action=3, 
		@on_success_step_id=0, 
		@on_fail_action=2, 
		@on_fail_step_id=0, 
		@retry_attempts=0, 
		@retry_interval=0, 
		@os_run_priority=0, @subsystem=N'TSQL', 
		@command=N'-- reindeksacja wszystkich tabel w bazie
DECLARE @TableName varchar(255)
DECLARE @TableSchema varchar(255)
DECLARE @FullName varchar(1000)
 
DECLARE TableCursor CURSOR FOR
SELECT table_name, table_schema FROM information_schema.tables
WHERE table_type = ''BASE TABLE''
 
OPEN TableCursor
 
FETCH NEXT FROM TableCursor INTO @TableName, @TableSchema
WHILE @@FETCH_STATUS = 0
BEGIN 
set @FullName = @TableSchema + ''.'' + @TableName
PRINT ''Reindexing '' + @FullName
DBCC DBREINDEX(@FullName,'' '',70)
FETCH NEXT FROM TableCursor INTO @TableName, @TableSchema
END
 
CLOSE TableCursor
 
DEALLOCATE TableCursor
GO
 
-- aktualizacja statystyk
declare @table_name varchar(2550)
declare @schema_name varchar(255)
declare @full_name varchar(3000)
 
declare idx_cursor cursor
for select distinct a.name, OBJECT_SCHEMA_NAME(a.id)
from sysobjects a, sysindexes b
where a.type = ''U''
and a.id = b.id
and b.indid > 0
open idx_cursor
 
fetch next from idx_cursor into @table_name, @schema_name 
 
while @@fetch_status = 0
begin
      set @full_name = @schema_name + ''.'' + @table_name
    EXEC (''UPDATE STATISTICS '' + @full_name)
fetch next from idx_cursor into @table_name, @schema_name
end
 
close idx_cursor
deallocate idx_cursor
GO
', 
		@database_name=N'ECM365Tenant_DAMROB_BPS_Attachments', 
		@flags=0
IF (@@ERROR <> 0 OR @ReturnCode <> 0) GOTO QuitWithRollback
/****** Object:  Step [ECM365Tenant_DAMROB_BPS_Content]    Script Date: 1/28/2020 8:05:25 PM ******/
EXEC @ReturnCode = msdb.dbo.sp_add_jobstep @job_id=@jobId, @step_name=N'ECM365Tenant_DAMROB_BPS_Content', 
		@step_id=6, 
		@cmdexec_success_code=0, 
		@on_success_action=3, 
		@on_success_step_id=0, 
		@on_fail_action=2, 
		@on_fail_step_id=0, 
		@retry_attempts=0, 
		@retry_interval=0, 
		@os_run_priority=0, @subsystem=N'TSQL', 
		@command=N'-- reindeksacja wszystkich tabel w bazie
DECLARE @TableName varchar(255)
DECLARE @TableSchema varchar(255)
DECLARE @FullName varchar(1000)
 
DECLARE TableCursor CURSOR FOR
SELECT table_name, table_schema FROM information_schema.tables
WHERE table_type = ''BASE TABLE''
 
OPEN TableCursor
 
FETCH NEXT FROM TableCursor INTO @TableName, @TableSchema
WHILE @@FETCH_STATUS = 0
BEGIN 
set @FullName = @TableSchema + ''.'' + @TableName
PRINT ''Reindexing '' + @FullName
DBCC DBREINDEX(@FullName,'' '',70)
FETCH NEXT FROM TableCursor INTO @TableName, @TableSchema
END
 
CLOSE TableCursor
 
DEALLOCATE TableCursor
GO
 
-- aktualizacja statystyk
declare @table_name varchar(2550)
declare @schema_name varchar(255)
declare @full_name varchar(3000)
 
declare idx_cursor cursor
for select distinct a.name, OBJECT_SCHEMA_NAME(a.id)
from sysobjects a, sysindexes b
where a.type = ''U''
and a.id = b.id
and b.indid > 0
open idx_cursor
 
fetch next from idx_cursor into @table_name, @schema_name 
 
while @@fetch_status = 0
begin
      set @full_name = @schema_name + ''.'' + @table_name
    EXEC (''UPDATE STATISTICS '' + @full_name)
fetch next from idx_cursor into @table_name, @schema_name
end
 
close idx_cursor
deallocate idx_cursor
GO
', 
		@database_name=N'ECM365Tenant_DAMROB_BPS_Content', 
		@flags=0
IF (@@ERROR <> 0 OR @ReturnCode <> 0) GOTO QuitWithRollback
/****** Object:  Step [ECM365Tenant_AFT_BPS_Attachments]    Script Date: 1/28/2020 8:05:25 PM ******/
EXEC @ReturnCode = msdb.dbo.sp_add_jobstep @job_id=@jobId, @step_name=N'ECM365Tenant_AFT_BPS_Attachments', 
		@step_id=7, 
		@cmdexec_success_code=0, 
		@on_success_action=3, 
		@on_success_step_id=0, 
		@on_fail_action=2, 
		@on_fail_step_id=0, 
		@retry_attempts=0, 
		@retry_interval=0, 
		@os_run_priority=0, @subsystem=N'TSQL', 
		@command=N'-- reindeksacja wszystkich tabel w bazie
DECLARE @TableName varchar(255)
DECLARE @TableSchema varchar(255)
DECLARE @FullName varchar(1000)
 
DECLARE TableCursor CURSOR FOR
SELECT table_name, table_schema FROM information_schema.tables
WHERE table_type = ''BASE TABLE'' 
 
OPEN TableCursor
 
FETCH NEXT FROM TableCursor INTO @TableName, @TableSchema
WHILE @@FETCH_STATUS = 0
BEGIN 
set @FullName = @TableSchema + ''.'' + @TableName
PRINT ''Reindexing '' + @FullName
DBCC DBREINDEX(@FullName,'' '',70)
FETCH NEXT FROM TableCursor INTO @TableName, @TableSchema
END
 
CLOSE TableCursor
 
DEALLOCATE TableCursor
GO
 
-- aktualizacja statystyk
declare @table_name varchar(2550)
declare @schema_name varchar(255)
declare @full_name varchar(3000)
 
declare idx_cursor cursor
for select distinct a.name, OBJECT_SCHEMA_NAME(a.id)
from sysobjects a, sysindexes b
where a.type = ''U''
and a.id = b.id
and b.indid > 0
open idx_cursor
 
fetch next from idx_cursor into @table_name, @schema_name 
 
while @@fetch_status = 0
begin
      set @full_name = @schema_name + ''.'' + @table_name
    EXEC (''UPDATE STATISTICS '' + @full_name)
fetch next from idx_cursor into @table_name, @schema_name
end
 
close idx_cursor
deallocate idx_cursor
GO
', 
		@database_name=N'ECM365Tenant_AFT_BPS_Attachments', 
		@flags=0
IF (@@ERROR <> 0 OR @ReturnCode <> 0) GOTO QuitWithRollback
/****** Object:  Step [ECM365Tenant_AFT_BPS_Content]    Script Date: 1/28/2020 8:05:25 PM ******/
EXEC @ReturnCode = msdb.dbo.sp_add_jobstep @job_id=@jobId, @step_name=N'ECM365Tenant_AFT_BPS_Content', 
		@step_id=8, 
		@cmdexec_success_code=0, 
		@on_success_action=3, 
		@on_success_step_id=0, 
		@on_fail_action=2, 
		@on_fail_step_id=0, 
		@retry_attempts=0, 
		@retry_interval=0, 
		@os_run_priority=0, @subsystem=N'TSQL', 
		@database_name=N'ECM365Tenant_AFT_BPS_Content', 
		@flags=0
IF (@@ERROR <> 0 OR @ReturnCode <> 0) GOTO QuitWithRollback
/****** Object:  Step [ECM365Tenant_ALLIES_BPS_Attachments]    Script Date: 1/28/2020 8:05:26 PM ******/
EXEC @ReturnCode = msdb.dbo.sp_add_jobstep @job_id=@jobId, @step_name=N'ECM365Tenant_ALLIES_BPS_Attachments', 
		@step_id=9, 
		@cmdexec_success_code=0, 
		@on_success_action=3, 
		@on_success_step_id=0, 
		@on_fail_action=2, 
		@on_fail_step_id=0, 
		@retry_attempts=0, 
		@retry_interval=0, 
		@os_run_priority=0, @subsystem=N'TSQL', 
		@command=N'-- reindeksacja wszystkich tabel w bazie
DECLARE @TableName varchar(255)
DECLARE @TableSchema varchar(255)
DECLARE @FullName varchar(1000)
 
DECLARE TableCursor CURSOR FOR
SELECT table_name, table_schema FROM information_schema.tables
WHERE table_type = ''BASE TABLE'' 
 
OPEN TableCursor
 
FETCH NEXT FROM TableCursor INTO @TableName, @TableSchema
WHILE @@FETCH_STATUS = 0
BEGIN 
set @FullName = @TableSchema + ''.'' + @TableName
PRINT ''Reindexing '' + @FullName
DBCC DBREINDEX(@FullName,'' '',70)
FETCH NEXT FROM TableCursor INTO @TableName, @TableSchema
END
 
CLOSE TableCursor
 
DEALLOCATE TableCursor
GO
 
-- aktualizacja statystyk
declare @table_name varchar(2550)
declare @schema_name varchar(255)
declare @full_name varchar(3000)
 
declare idx_cursor cursor
for select distinct a.name, OBJECT_SCHEMA_NAME(a.id)
from sysobjects a, sysindexes b
where a.type = ''U''
and a.id = b.id
and b.indid > 0
open idx_cursor
 
fetch next from idx_cursor into @table_name, @schema_name 
 
while @@fetch_status = 0
begin
      set @full_name = @schema_name + ''.'' + @table_name
    EXEC (''UPDATE STATISTICS '' + @full_name)
fetch next from idx_cursor into @table_name, @schema_name
end
 
close idx_cursor
deallocate idx_cursor
GO
', 
		@database_name=N'ECM365Tenant_ALLIES_BPS_Attachments', 
		@flags=0
IF (@@ERROR <> 0 OR @ReturnCode <> 0) GOTO QuitWithRollback
/****** Object:  Step [ECM365Tenant_ALLIES_BPS_Content]    Script Date: 1/28/2020 8:05:26 PM ******/
EXEC @ReturnCode = msdb.dbo.sp_add_jobstep @job_id=@jobId, @step_name=N'ECM365Tenant_ALLIES_BPS_Content', 
		@step_id=10, 
		@cmdexec_success_code=0, 
		@on_success_action=3, 
		@on_success_step_id=0, 
		@on_fail_action=2, 
		@on_fail_step_id=0, 
		@retry_attempts=0, 
		@retry_interval=0, 
		@os_run_priority=0, @subsystem=N'TSQL', 
		@command=N'-- reindeksacja wszystkich tabel w bazie
DECLARE @TableName varchar(255)
DECLARE @TableSchema varchar(255)
DECLARE @FullName varchar(1000)
 
DECLARE TableCursor CURSOR FOR
SELECT table_name, table_schema FROM information_schema.tables
WHERE table_type = ''BASE TABLE'' 
 
OPEN TableCursor
 
FETCH NEXT FROM TableCursor INTO @TableName, @TableSchema
WHILE @@FETCH_STATUS = 0
BEGIN 
set @FullName = @TableSchema + ''.'' + @TableName
PRINT ''Reindexing '' + @FullName
DBCC DBREINDEX(@FullName,'' '',70)
FETCH NEXT FROM TableCursor INTO @TableName, @TableSchema
END
 
CLOSE TableCursor
 
DEALLOCATE TableCursor
GO
 
-- aktualizacja statystyk
declare @table_name varchar(2550)
declare @schema_name varchar(255)
declare @full_name varchar(3000)
 
declare idx_cursor cursor
for select distinct a.name, OBJECT_SCHEMA_NAME(a.id)
from sysobjects a, sysindexes b
where a.type = ''U''
and a.id = b.id
and b.indid > 0
open idx_cursor
 
fetch next from idx_cursor into @table_name, @schema_name 
 
while @@fetch_status = 0
begin
      set @full_name = @schema_name + ''.'' + @table_name
    EXEC (''UPDATE STATISTICS '' + @full_name)
fetch next from idx_cursor into @table_name, @schema_name
end
 
close idx_cursor
deallocate idx_cursor
GO
', 
		@database_name=N'ECM365Tenant_ALLIES_BPS_Content', 
		@flags=0
IF (@@ERROR <> 0 OR @ReturnCode <> 0) GOTO QuitWithRollback
/****** Object:  Step [ECM365Tenant_DIECEZJALOWICZ_BPS_Attachments]    Script Date: 1/28/2020 8:05:26 PM ******/
EXEC @ReturnCode = msdb.dbo.sp_add_jobstep @job_id=@jobId, @step_name=N'ECM365Tenant_DIECEZJALOWICZ_BPS_Attachments', 
		@step_id=11, 
		@cmdexec_success_code=0, 
		@on_success_action=3, 
		@on_success_step_id=0, 
		@on_fail_action=2, 
		@on_fail_step_id=0, 
		@retry_attempts=0, 
		@retry_interval=0, 
		@os_run_priority=0, @subsystem=N'TSQL', 
		@command=N'-- reindeksacja wszystkich tabel w bazie
DECLARE @TableName varchar(255)
DECLARE @TableSchema varchar(255)
DECLARE @FullName varchar(1000)
 
DECLARE TableCursor CURSOR FOR
SELECT table_name, table_schema FROM information_schema.tables
WHERE table_type = ''BASE TABLE'' 
 
OPEN TableCursor
 
FETCH NEXT FROM TableCursor INTO @TableName, @TableSchema
WHILE @@FETCH_STATUS = 0
BEGIN 
set @FullName = @TableSchema + ''.'' + @TableName
PRINT ''Reindexing '' + @FullName
DBCC DBREINDEX(@FullName,'' '',70)
FETCH NEXT FROM TableCursor INTO @TableName, @TableSchema
END
 
CLOSE TableCursor
 
DEALLOCATE TableCursor
GO
 
-- aktualizacja statystyk
declare @table_name varchar(2550)
declare @schema_name varchar(255)
declare @full_name varchar(3000)
 
declare idx_cursor cursor
for select distinct a.name, OBJECT_SCHEMA_NAME(a.id)
from sysobjects a, sysindexes b
where a.type = ''U''
and a.id = b.id
and b.indid > 0
open idx_cursor
 
fetch next from idx_cursor into @table_name, @schema_name 
 
while @@fetch_status = 0
begin
      set @full_name = @schema_name + ''.'' + @table_name
    EXEC (''UPDATE STATISTICS '' + @full_name)
fetch next from idx_cursor into @table_name, @schema_name
end
 
close idx_cursor
deallocate idx_cursor
GO
', 
		@database_name=N'ECM365Tenant_DIECEZJALOWICZ_BPS_Attachments', 
		@flags=0
IF (@@ERROR <> 0 OR @ReturnCode <> 0) GOTO QuitWithRollback
/****** Object:  Step [ECM365Tenant_DIECEZJALOWICZ_BPS_Content]    Script Date: 1/28/2020 8:05:26 PM ******/
EXEC @ReturnCode = msdb.dbo.sp_add_jobstep @job_id=@jobId, @step_name=N'ECM365Tenant_DIECEZJALOWICZ_BPS_Content', 
		@step_id=12, 
		@cmdexec_success_code=0, 
		@on_success_action=3, 
		@on_success_step_id=0, 
		@on_fail_action=2, 
		@on_fail_step_id=0, 
		@retry_attempts=0, 
		@retry_interval=0, 
		@os_run_priority=0, @subsystem=N'TSQL', 
		@command=N'-- reindeksacja wszystkich tabel w bazie
DECLARE @TableName varchar(255)
DECLARE @TableSchema varchar(255)
DECLARE @FullName varchar(1000)
 
DECLARE TableCursor CURSOR FOR
SELECT table_name, table_schema FROM information_schema.tables
WHERE table_type = ''BASE TABLE'' 
 
OPEN TableCursor
 
FETCH NEXT FROM TableCursor INTO @TableName, @TableSchema
WHILE @@FETCH_STATUS = 0
BEGIN 
set @FullName = @TableSchema + ''.'' + @TableName
PRINT ''Reindexing '' + @FullName
DBCC DBREINDEX(@FullName,'' '',70)
FETCH NEXT FROM TableCursor INTO @TableName, @TableSchema
END
 
CLOSE TableCursor
 
DEALLOCATE TableCursor
GO
 
-- aktualizacja statystyk
declare @table_name varchar(2550)
declare @schema_name varchar(255)
declare @full_name varchar(3000)
 
declare idx_cursor cursor
for select distinct a.name, OBJECT_SCHEMA_NAME(a.id)
from sysobjects a, sysindexes b
where a.type = ''U''
and a.id = b.id
and b.indid > 0
open idx_cursor
 
fetch next from idx_cursor into @table_name, @schema_name 
 
while @@fetch_status = 0
begin
      set @full_name = @schema_name + ''.'' + @table_name
    EXEC (''UPDATE STATISTICS '' + @full_name)
fetch next from idx_cursor into @table_name, @schema_name
end
 
close idx_cursor
deallocate idx_cursor
GO
', 
		@database_name=N'ECM365Tenant_DIECEZJALOWICZ_BPS_Content', 
		@flags=0
IF (@@ERROR <> 0 OR @ReturnCode <> 0) GOTO QuitWithRollback
/****** Object:  Step [ECM365Tenant_ELDORADCA_BPS_Attachments]    Script Date: 1/28/2020 8:05:26 PM ******/
EXEC @ReturnCode = msdb.dbo.sp_add_jobstep @job_id=@jobId, @step_name=N'ECM365Tenant_ELDORADCA_BPS_Attachments', 
		@step_id=13, 
		@cmdexec_success_code=0, 
		@on_success_action=3, 
		@on_success_step_id=0, 
		@on_fail_action=2, 
		@on_fail_step_id=0, 
		@retry_attempts=0, 
		@retry_interval=0, 
		@os_run_priority=0, @subsystem=N'TSQL', 
		@command=N'-- reindeksacja wszystkich tabel w bazie
DECLARE @TableName varchar(255)
DECLARE @TableSchema varchar(255)
DECLARE @FullName varchar(1000)
 
DECLARE TableCursor CURSOR FOR
SELECT table_name, table_schema FROM information_schema.tables
WHERE table_type = ''BASE TABLE'' 
 
OPEN TableCursor
 
FETCH NEXT FROM TableCursor INTO @TableName, @TableSchema
WHILE @@FETCH_STATUS = 0
BEGIN 
set @FullName = @TableSchema + ''.'' + @TableName
PRINT ''Reindexing '' + @FullName
DBCC DBREINDEX(@FullName,'' '',70)
FETCH NEXT FROM TableCursor INTO @TableName, @TableSchema
END
 
CLOSE TableCursor
 
DEALLOCATE TableCursor
GO
 
-- aktualizacja statystyk
declare @table_name varchar(2550)
declare @schema_name varchar(255)
declare @full_name varchar(3000)
 
declare idx_cursor cursor
for select distinct a.name, OBJECT_SCHEMA_NAME(a.id)
from sysobjects a, sysindexes b
where a.type = ''U''
and a.id = b.id
and b.indid > 0
open idx_cursor
 
fetch next from idx_cursor into @table_name, @schema_name 
 
while @@fetch_status = 0
begin
      set @full_name = @schema_name + ''.'' + @table_name
    EXEC (''UPDATE STATISTICS '' + @full_name)
fetch next from idx_cursor into @table_name, @schema_name
end
 
close idx_cursor
deallocate idx_cursor
GO
', 
		@database_name=N'ECM365Tenant_ELDORADCA_BPS_Attachments', 
		@flags=0
IF (@@ERROR <> 0 OR @ReturnCode <> 0) GOTO QuitWithRollback
/****** Object:  Step [ECM365Tenats_ELDORADCA_BPS_Content]    Script Date: 1/28/2020 8:05:26 PM ******/
EXEC @ReturnCode = msdb.dbo.sp_add_jobstep @job_id=@jobId, @step_name=N'ECM365Tenats_ELDORADCA_BPS_Content', 
		@step_id=14, 
		@cmdexec_success_code=0, 
		@on_success_action=3, 
		@on_success_step_id=0, 
		@on_fail_action=2, 
		@on_fail_step_id=0, 
		@retry_attempts=0, 
		@retry_interval=0, 
		@os_run_priority=0, @subsystem=N'TSQL', 
		@command=N'-- reindeksacja wszystkich tabel w bazie
DECLARE @TableName varchar(255)
DECLARE @TableSchema varchar(255)
DECLARE @FullName varchar(1000)
 
DECLARE TableCursor CURSOR FOR
SELECT table_name, table_schema FROM information_schema.tables
WHERE table_type = ''BASE TABLE'' 
 
OPEN TableCursor
 
FETCH NEXT FROM TableCursor INTO @TableName, @TableSchema
WHILE @@FETCH_STATUS = 0
BEGIN 
set @FullName = @TableSchema + ''.'' + @TableName
PRINT ''Reindexing '' + @FullName
DBCC DBREINDEX(@FullName,'' '',70)
FETCH NEXT FROM TableCursor INTO @TableName, @TableSchema
END
 
CLOSE TableCursor
 
DEALLOCATE TableCursor
GO
 
-- aktualizacja statystyk
declare @table_name varchar(2550)
declare @schema_name varchar(255)
declare @full_name varchar(3000)
 
declare idx_cursor cursor
for select distinct a.name, OBJECT_SCHEMA_NAME(a.id)
from sysobjects a, sysindexes b
where a.type = ''U''
and a.id = b.id
and b.indid > 0
open idx_cursor
 
fetch next from idx_cursor into @table_name, @schema_name 
 
while @@fetch_status = 0
begin
      set @full_name = @schema_name + ''.'' + @table_name
    EXEC (''UPDATE STATISTICS '' + @full_name)
fetch next from idx_cursor into @table_name, @schema_name
end
 
close idx_cursor
deallocate idx_cursor
GO
', 
		@database_name=N'ECM365Tenant_ELDORADCA_BPS_Content', 
		@flags=0
IF (@@ERROR <> 0 OR @ReturnCode <> 0) GOTO QuitWithRollback
/****** Object:  Step [ECM365Tenant_Konsal_BPS_Attachments]    Script Date: 1/28/2020 8:05:26 PM ******/
EXEC @ReturnCode = msdb.dbo.sp_add_jobstep @job_id=@jobId, @step_name=N'ECM365Tenant_Konsal_BPS_Attachments', 
		@step_id=15, 
		@cmdexec_success_code=0, 
		@on_success_action=3, 
		@on_success_step_id=0, 
		@on_fail_action=2, 
		@on_fail_step_id=0, 
		@retry_attempts=0, 
		@retry_interval=0, 
		@os_run_priority=0, @subsystem=N'TSQL', 
		@command=N'-- reindeksacja wszystkich tabel w bazie
DECLARE @TableName varchar(255)
DECLARE @TableSchema varchar(255)
DECLARE @FullName varchar(1000)
 
DECLARE TableCursor CURSOR FOR
SELECT table_name, table_schema FROM information_schema.tables
WHERE table_type = ''BASE TABLE'' 
 
OPEN TableCursor
 
FETCH NEXT FROM TableCursor INTO @TableName, @TableSchema
WHILE @@FETCH_STATUS = 0
BEGIN 
set @FullName = @TableSchema + ''.'' + @TableName
PRINT ''Reindexing '' + @FullName
DBCC DBREINDEX(@FullName,'' '',70)
FETCH NEXT FROM TableCursor INTO @TableName, @TableSchema
END
 
CLOSE TableCursor
 
DEALLOCATE TableCursor
GO
 
-- aktualizacja statystyk
declare @table_name varchar(2550)
declare @schema_name varchar(255)
declare @full_name varchar(3000)
 
declare idx_cursor cursor
for select distinct a.name, OBJECT_SCHEMA_NAME(a.id)
from sysobjects a, sysindexes b
where a.type = ''U''
and a.id = b.id
and b.indid > 0
open idx_cursor
 
fetch next from idx_cursor into @table_name, @schema_name 
 
while @@fetch_status = 0
begin
      set @full_name = @schema_name + ''.'' + @table_name
    EXEC (''UPDATE STATISTICS '' + @full_name)
fetch next from idx_cursor into @table_name, @schema_name
end
 
close idx_cursor
deallocate idx_cursor
GO
', 
		@database_name=N'ECM365Tenant_KONSAL_BPS_Attachments', 
		@flags=0
IF (@@ERROR <> 0 OR @ReturnCode <> 0) GOTO QuitWithRollback
/****** Object:  Step [ECM365Tenant_KONSAL_BPS_Content]    Script Date: 1/28/2020 8:05:26 PM ******/
EXEC @ReturnCode = msdb.dbo.sp_add_jobstep @job_id=@jobId, @step_name=N'ECM365Tenant_KONSAL_BPS_Content', 
		@step_id=16, 
		@cmdexec_success_code=0, 
		@on_success_action=3, 
		@on_success_step_id=0, 
		@on_fail_action=2, 
		@on_fail_step_id=0, 
		@retry_attempts=0, 
		@retry_interval=0, 
		@os_run_priority=0, @subsystem=N'TSQL', 
		@command=N'-- reindeksacja wszystkich tabel w bazie
DECLARE @TableName varchar(255)
DECLARE @TableSchema varchar(255)
DECLARE @FullName varchar(1000)
 
DECLARE TableCursor CURSOR FOR
SELECT table_name, table_schema FROM information_schema.tables
WHERE table_type = ''BASE TABLE'' 
 
OPEN TableCursor
 
FETCH NEXT FROM TableCursor INTO @TableName, @TableSchema
WHILE @@FETCH_STATUS = 0
BEGIN 
set @FullName = @TableSchema + ''.'' + @TableName
PRINT ''Reindexing '' + @FullName
DBCC DBREINDEX(@FullName,'' '',70)
FETCH NEXT FROM TableCursor INTO @TableName, @TableSchema
END
 
CLOSE TableCursor
 
DEALLOCATE TableCursor
GO
 
-- aktualizacja statystyk
declare @table_name varchar(2550)
declare @schema_name varchar(255)
declare @full_name varchar(3000)
 
declare idx_cursor cursor
for select distinct a.name, OBJECT_SCHEMA_NAME(a.id)
from sysobjects a, sysindexes b
where a.type = ''U''
and a.id = b.id
and b.indid > 0
open idx_cursor
 
fetch next from idx_cursor into @table_name, @schema_name 
 
while @@fetch_status = 0
begin
      set @full_name = @schema_name + ''.'' + @table_name
    EXEC (''UPDATE STATISTICS '' + @full_name)
fetch next from idx_cursor into @table_name, @schema_name
end
 
close idx_cursor
deallocate idx_cursor
GO
', 
		@database_name=N'ECM365Tenant_KONSAL_BPS_Content', 
		@flags=0
IF (@@ERROR <> 0 OR @ReturnCode <> 0) GOTO QuitWithRollback
/****** Object:  Step [ECM365Tenant_LAFARGE_BPS_Attachments]    Script Date: 1/28/2020 8:05:26 PM ******/
EXEC @ReturnCode = msdb.dbo.sp_add_jobstep @job_id=@jobId, @step_name=N'ECM365Tenant_LAFARGE_BPS_Attachments', 
		@step_id=17, 
		@cmdexec_success_code=0, 
		@on_success_action=3, 
		@on_success_step_id=0, 
		@on_fail_action=2, 
		@on_fail_step_id=0, 
		@retry_attempts=0, 
		@retry_interval=0, 
		@os_run_priority=0, @subsystem=N'TSQL', 
		@command=N'-- reindeksacja wszystkich tabel w bazie
DECLARE @TableName varchar(255)
DECLARE @TableSchema varchar(255)
DECLARE @FullName varchar(1000)
 
DECLARE TableCursor CURSOR FOR
SELECT table_name, table_schema FROM information_schema.tables
WHERE table_type = ''BASE TABLE'' 
 
OPEN TableCursor
 
FETCH NEXT FROM TableCursor INTO @TableName, @TableSchema
WHILE @@FETCH_STATUS = 0
BEGIN 
set @FullName = @TableSchema + ''.'' + @TableName
PRINT ''Reindexing '' + @FullName
DBCC DBREINDEX(@FullName,'' '',70)
FETCH NEXT FROM TableCursor INTO @TableName, @TableSchema
END
 
CLOSE TableCursor
 
DEALLOCATE TableCursor
GO
 
-- aktualizacja statystyk
declare @table_name varchar(2550)
declare @schema_name varchar(255)
declare @full_name varchar(3000)
 
declare idx_cursor cursor
for select distinct a.name, OBJECT_SCHEMA_NAME(a.id)
from sysobjects a, sysindexes b
where a.type = ''U''
and a.id = b.id
and b.indid > 0
open idx_cursor
 
fetch next from idx_cursor into @table_name, @schema_name 
 
while @@fetch_status = 0
begin
      set @full_name = @schema_name + ''.'' + @table_name
    EXEC (''UPDATE STATISTICS '' + @full_name)
fetch next from idx_cursor into @table_name, @schema_name
end
 
close idx_cursor
deallocate idx_cursor
GO
', 
		@database_name=N'ECM365Tenant_LAFARGE_BPS_Attachments', 
		@flags=0
IF (@@ERROR <> 0 OR @ReturnCode <> 0) GOTO QuitWithRollback
/****** Object:  Step [ECM365Tenant_LAFARGE_BPS_Content]    Script Date: 1/28/2020 8:05:26 PM ******/
EXEC @ReturnCode = msdb.dbo.sp_add_jobstep @job_id=@jobId, @step_name=N'ECM365Tenant_LAFARGE_BPS_Content', 
		@step_id=18, 
		@cmdexec_success_code=0, 
		@on_success_action=3, 
		@on_success_step_id=0, 
		@on_fail_action=2, 
		@on_fail_step_id=0, 
		@retry_attempts=0, 
		@retry_interval=0, 
		@os_run_priority=0, @subsystem=N'TSQL', 
		@command=N'-- reindeksacja wszystkich tabel w bazie
DECLARE @TableName varchar(255)
DECLARE @TableSchema varchar(255)
DECLARE @FullName varchar(1000)
 
DECLARE TableCursor CURSOR FOR
SELECT table_name, table_schema FROM information_schema.tables
WHERE table_type = ''BASE TABLE'' 
 
OPEN TableCursor
 
FETCH NEXT FROM TableCursor INTO @TableName, @TableSchema
WHILE @@FETCH_STATUS = 0
BEGIN 
set @FullName = @TableSchema + ''.'' + @TableName
PRINT ''Reindexing '' + @FullName
DBCC DBREINDEX(@FullName,'' '',70)
FETCH NEXT FROM TableCursor INTO @TableName, @TableSchema
END
 
CLOSE TableCursor
 
DEALLOCATE TableCursor
GO
 
-- aktualizacja statystyk
declare @table_name varchar(2550)
declare @schema_name varchar(255)
declare @full_name varchar(3000)
 
declare idx_cursor cursor
for select distinct a.name, OBJECT_SCHEMA_NAME(a.id)
from sysobjects a, sysindexes b
where a.type = ''U''
and a.id = b.id
and b.indid > 0
open idx_cursor
 
fetch next from idx_cursor into @table_name, @schema_name 
 
while @@fetch_status = 0
begin
      set @full_name = @schema_name + ''.'' + @table_name
    EXEC (''UPDATE STATISTICS '' + @full_name)
fetch next from idx_cursor into @table_name, @schema_name
end
 
close idx_cursor
deallocate idx_cursor
GO
', 
		@database_name=N'ECM365Tenant_LAFARGE_BPS_Content', 
		@flags=0
IF (@@ERROR <> 0 OR @ReturnCode <> 0) GOTO QuitWithRollback
/****** Object:  Step [ECM365Tenant_MKPARTNER_BPS_Attachments]    Script Date: 1/28/2020 8:05:26 PM ******/
EXEC @ReturnCode = msdb.dbo.sp_add_jobstep @job_id=@jobId, @step_name=N'ECM365Tenant_MKPARTNER_BPS_Attachments', 
		@step_id=19, 
		@cmdexec_success_code=0, 
		@on_success_action=3, 
		@on_success_step_id=0, 
		@on_fail_action=2, 
		@on_fail_step_id=0, 
		@retry_attempts=0, 
		@retry_interval=0, 
		@os_run_priority=0, @subsystem=N'TSQL', 
		@command=N'-- reindeksacja wszystkich tabel w bazie
DECLARE @TableName varchar(255)
DECLARE @TableSchema varchar(255)
DECLARE @FullName varchar(1000)
 
DECLARE TableCursor CURSOR FOR
SELECT table_name, table_schema FROM information_schema.tables
WHERE table_type = ''BASE TABLE'' 
 
OPEN TableCursor
 
FETCH NEXT FROM TableCursor INTO @TableName, @TableSchema
WHILE @@FETCH_STATUS = 0
BEGIN 
set @FullName = @TableSchema + ''.'' + @TableName
PRINT ''Reindexing '' + @FullName
DBCC DBREINDEX(@FullName,'' '',70)
FETCH NEXT FROM TableCursor INTO @TableName, @TableSchema
END
 
CLOSE TableCursor
 
DEALLOCATE TableCursor
GO
 
-- aktualizacja statystyk
declare @table_name varchar(2550)
declare @schema_name varchar(255)
declare @full_name varchar(3000)
 
declare idx_cursor cursor
for select distinct a.name, OBJECT_SCHEMA_NAME(a.id)
from sysobjects a, sysindexes b
where a.type = ''U''
and a.id = b.id
and b.indid > 0
open idx_cursor
 
fetch next from idx_cursor into @table_name, @schema_name 
 
while @@fetch_status = 0
begin
      set @full_name = @schema_name + ''.'' + @table_name
    EXEC (''UPDATE STATISTICS '' + @full_name)
fetch next from idx_cursor into @table_name, @schema_name
end
 
close idx_cursor
deallocate idx_cursor
GO
', 
		@database_name=N'ECM365Tenant_MKPARTNER_BPS_Attachments', 
		@flags=0
IF (@@ERROR <> 0 OR @ReturnCode <> 0) GOTO QuitWithRollback
/****** Object:  Step [ECM365Tenant_MKPARTNER_BPS_Content]    Script Date: 1/28/2020 8:05:26 PM ******/
EXEC @ReturnCode = msdb.dbo.sp_add_jobstep @job_id=@jobId, @step_name=N'ECM365Tenant_MKPARTNER_BPS_Content', 
		@step_id=20, 
		@cmdexec_success_code=0, 
		@on_success_action=3, 
		@on_success_step_id=0, 
		@on_fail_action=2, 
		@on_fail_step_id=0, 
		@retry_attempts=0, 
		@retry_interval=0, 
		@os_run_priority=0, @subsystem=N'TSQL', 
		@command=N'-- reindeksacja wszystkich tabel w bazie
DECLARE @TableName varchar(255)
DECLARE @TableSchema varchar(255)
DECLARE @FullName varchar(1000)
 
DECLARE TableCursor CURSOR FOR
SELECT table_name, table_schema FROM information_schema.tables
WHERE table_type = ''BASE TABLE'' 
 
OPEN TableCursor
 
FETCH NEXT FROM TableCursor INTO @TableName, @TableSchema
WHILE @@FETCH_STATUS = 0
BEGIN 
set @FullName = @TableSchema + ''.'' + @TableName
PRINT ''Reindexing '' + @FullName
DBCC DBREINDEX(@FullName,'' '',70)
FETCH NEXT FROM TableCursor INTO @TableName, @TableSchema
END
 
CLOSE TableCursor
 
DEALLOCATE TableCursor
GO
 
-- aktualizacja statystyk
declare @table_name varchar(2550)
declare @schema_name varchar(255)
declare @full_name varchar(3000)
 
declare idx_cursor cursor
for select distinct a.name, OBJECT_SCHEMA_NAME(a.id)
from sysobjects a, sysindexes b
where a.type = ''U''
and a.id = b.id
and b.indid > 0
open idx_cursor
 
fetch next from idx_cursor into @table_name, @schema_name 
 
while @@fetch_status = 0
begin
      set @full_name = @schema_name + ''.'' + @table_name
    EXEC (''UPDATE STATISTICS '' + @full_name)
fetch next from idx_cursor into @table_name, @schema_name
end
 
close idx_cursor
deallocate idx_cursor
GO
', 
		@database_name=N'ECM365Tenant_MKPARTNER_BPS_Content', 
		@flags=0
IF (@@ERROR <> 0 OR @ReturnCode <> 0) GOTO QuitWithRollback
/****** Object:  Step [ECM365Tenant_AFT_BPS_Attachments_rebulid_catalog]    Script Date: 1/28/2020 8:05:26 PM ******/
EXEC @ReturnCode = msdb.dbo.sp_add_jobstep @job_id=@jobId, @step_name=N'ECM365Tenant_AFT_BPS_Attachments_rebulid_catalog', 
		@step_id=21, 
		@cmdexec_success_code=0, 
		@on_success_action=3, 
		@on_success_step_id=0, 
		@on_fail_action=2, 
		@on_fail_step_id=0, 
		@retry_attempts=0, 
		@retry_interval=0, 
		@os_run_priority=0, @subsystem=N'TSQL', 
		@command=N'ALTER FULLTEXT CATALOG WFAttachmentFiles
REBUILD WITH ACCENT_SENSITIVITY = OFF', 
		@database_name=N'ECM365Tenant_AFT_BPS_Attachments', 
		@flags=0
IF (@@ERROR <> 0 OR @ReturnCode <> 0) GOTO QuitWithRollback
/****** Object:  Step [ECM365Tenant_AFT_BPS_Content_rebulid_catalog]    Script Date: 1/28/2020 8:05:26 PM ******/
EXEC @ReturnCode = msdb.dbo.sp_add_jobstep @job_id=@jobId, @step_name=N'ECM365Tenant_AFT_BPS_Content_rebulid_catalog', 
		@step_id=22, 
		@cmdexec_success_code=0, 
		@on_success_action=3, 
		@on_success_step_id=0, 
		@on_fail_action=2, 
		@on_fail_step_id=0, 
		@retry_attempts=0, 
		@retry_interval=0, 
		@os_run_priority=0, @subsystem=N'TSQL', 
		@command=N'ALTER FULLTEXT CATALOG WorkFlow_FullText_Catalog
REBUILD WITH ACCENT_SENSITIVITY = OFF', 
		@database_name=N'ECM365Tenant_AFT_BPS_Content', 
		@flags=0
IF (@@ERROR <> 0 OR @ReturnCode <> 0) GOTO QuitWithRollback
/****** Object:  Step [ECM365Tenant_ALLIES_BPS_Attachments_rebulid_catalog]    Script Date: 1/28/2020 8:05:26 PM ******/
EXEC @ReturnCode = msdb.dbo.sp_add_jobstep @job_id=@jobId, @step_name=N'ECM365Tenant_ALLIES_BPS_Attachments_rebulid_catalog', 
		@step_id=23, 
		@cmdexec_success_code=0, 
		@on_success_action=3, 
		@on_success_step_id=0, 
		@on_fail_action=2, 
		@on_fail_step_id=0, 
		@retry_attempts=0, 
		@retry_interval=0, 
		@os_run_priority=0, @subsystem=N'TSQL', 
		@command=N'ALTER FULLTEXT CATALOG WFAttachmentFiles
REBUILD WITH ACCENT_SENSITIVITY = OFF', 
		@database_name=N'ECM365Tenant_ALLIES_BPS_Attachments', 
		@flags=0
IF (@@ERROR <> 0 OR @ReturnCode <> 0) GOTO QuitWithRollback
/****** Object:  Step [ECM365Tenant_ALLIES_BPS_Content_rebulid_catalog]    Script Date: 1/28/2020 8:05:26 PM ******/
EXEC @ReturnCode = msdb.dbo.sp_add_jobstep @job_id=@jobId, @step_name=N'ECM365Tenant_ALLIES_BPS_Content_rebulid_catalog', 
		@step_id=24, 
		@cmdexec_success_code=0, 
		@on_success_action=3, 
		@on_success_step_id=0, 
		@on_fail_action=2, 
		@on_fail_step_id=0, 
		@retry_attempts=0, 
		@retry_interval=0, 
		@os_run_priority=0, @subsystem=N'TSQL', 
		@command=N'ALTER FULLTEXT CATALOG WorkFlow_FullText_Catalog
REBUILD WITH ACCENT_SENSITIVITY = OFF', 
		@database_name=N'ECM365Tenant_ALLIES_BPS_Content', 
		@flags=0
IF (@@ERROR <> 0 OR @ReturnCode <> 0) GOTO QuitWithRollback
/****** Object:  Step [ECM365Tenant_DAMROB_BPS_Attachments_rebulid_catalog]    Script Date: 1/28/2020 8:05:26 PM ******/
EXEC @ReturnCode = msdb.dbo.sp_add_jobstep @job_id=@jobId, @step_name=N'ECM365Tenant_DAMROB_BPS_Attachments_rebulid_catalog', 
		@step_id=25, 
		@cmdexec_success_code=0, 
		@on_success_action=3, 
		@on_success_step_id=0, 
		@on_fail_action=2, 
		@on_fail_step_id=0, 
		@retry_attempts=0, 
		@retry_interval=0, 
		@os_run_priority=0, @subsystem=N'TSQL', 
		@command=N'ALTER FULLTEXT CATALOG WFAttachmentFiles
REBUILD WITH ACCENT_SENSITIVITY = OFF', 
		@database_name=N'ECM365Tenant_DAMROB_BPS_Attachments', 
		@flags=0
IF (@@ERROR <> 0 OR @ReturnCode <> 0) GOTO QuitWithRollback
/****** Object:  Step [ECM365Tenant_DAMROB_BPS_Content_rebulid_catalog]    Script Date: 1/28/2020 8:05:26 PM ******/
EXEC @ReturnCode = msdb.dbo.sp_add_jobstep @job_id=@jobId, @step_name=N'ECM365Tenant_DAMROB_BPS_Content_rebulid_catalog', 
		@step_id=26, 
		@cmdexec_success_code=0, 
		@on_success_action=3, 
		@on_success_step_id=0, 
		@on_fail_action=2, 
		@on_fail_step_id=0, 
		@retry_attempts=0, 
		@retry_interval=0, 
		@os_run_priority=0, @subsystem=N'TSQL', 
		@command=N'ALTER FULLTEXT CATALOG WorkFlow_FullText_Catalog
REBUILD WITH ACCENT_SENSITIVITY = OFF', 
		@database_name=N'ECM365Tenant_DAMROB_BPS_Content', 
		@flags=0
IF (@@ERROR <> 0 OR @ReturnCode <> 0) GOTO QuitWithRollback
/****** Object:  Step [ECM365Tenant_DIECEZJALOWICZ_BPS_Attachments_rebulid_catalog]    Script Date: 1/28/2020 8:05:26 PM ******/
EXEC @ReturnCode = msdb.dbo.sp_add_jobstep @job_id=@jobId, @step_name=N'ECM365Tenant_DIECEZJALOWICZ_BPS_Attachments_rebulid_catalog', 
		@step_id=27, 
		@cmdexec_success_code=0, 
		@on_success_action=3, 
		@on_success_step_id=0, 
		@on_fail_action=2, 
		@on_fail_step_id=0, 
		@retry_attempts=0, 
		@retry_interval=0, 
		@os_run_priority=0, @subsystem=N'TSQL', 
		@command=N'ALTER FULLTEXT CATALOG WFAttachmentFiles
REBUILD WITH ACCENT_SENSITIVITY = OFF', 
		@database_name=N'ECM365Tenant_DIECEZJALOWICZ_BPS_Attachments', 
		@flags=0
IF (@@ERROR <> 0 OR @ReturnCode <> 0) GOTO QuitWithRollback
/****** Object:  Step [ECM365Tenant_DIECEZJALOWICZ_BPS_Content_rebulid_catalog]    Script Date: 1/28/2020 8:05:26 PM ******/
EXEC @ReturnCode = msdb.dbo.sp_add_jobstep @job_id=@jobId, @step_name=N'ECM365Tenant_DIECEZJALOWICZ_BPS_Content_rebulid_catalog', 
		@step_id=28, 
		@cmdexec_success_code=0, 
		@on_success_action=3, 
		@on_success_step_id=0, 
		@on_fail_action=2, 
		@on_fail_step_id=0, 
		@retry_attempts=0, 
		@retry_interval=0, 
		@os_run_priority=0, @subsystem=N'TSQL', 
		@command=N'ALTER FULLTEXT CATALOG WorkFlow_FullText_Catalog
REBUILD WITH ACCENT_SENSITIVITY = OFF', 
		@database_name=N'ECM365Tenant_DIECEZJALOWICZ_BPS_Content', 
		@flags=0
IF (@@ERROR <> 0 OR @ReturnCode <> 0) GOTO QuitWithRollback
/****** Object:  Step [ECM365Tenant_ELDORADCA_BPS_Attachments_rebulid_catalog]    Script Date: 1/28/2020 8:05:26 PM ******/
EXEC @ReturnCode = msdb.dbo.sp_add_jobstep @job_id=@jobId, @step_name=N'ECM365Tenant_ELDORADCA_BPS_Attachments_rebulid_catalog', 
		@step_id=29, 
		@cmdexec_success_code=0, 
		@on_success_action=3, 
		@on_success_step_id=0, 
		@on_fail_action=2, 
		@on_fail_step_id=0, 
		@retry_attempts=0, 
		@retry_interval=0, 
		@os_run_priority=0, @subsystem=N'TSQL', 
		@command=N'ALTER FULLTEXT CATALOG WFAttachmentFiles
REBUILD WITH ACCENT_SENSITIVITY = OFF', 
		@database_name=N'ECM365Tenant_ELDORADCA_BPS_Attachments', 
		@flags=0
IF (@@ERROR <> 0 OR @ReturnCode <> 0) GOTO QuitWithRollback
/****** Object:  Step [ECM365Tenant_ELDORADCA_BPS_Content_rebulid_catalog]    Script Date: 1/28/2020 8:05:26 PM ******/
EXEC @ReturnCode = msdb.dbo.sp_add_jobstep @job_id=@jobId, @step_name=N'ECM365Tenant_ELDORADCA_BPS_Content_rebulid_catalog', 
		@step_id=30, 
		@cmdexec_success_code=0, 
		@on_success_action=3, 
		@on_success_step_id=0, 
		@on_fail_action=2, 
		@on_fail_step_id=0, 
		@retry_attempts=0, 
		@retry_interval=0, 
		@os_run_priority=0, @subsystem=N'TSQL', 
		@command=N'ALTER FULLTEXT CATALOG WorkFlow_FullText_Catalog
REBUILD WITH ACCENT_SENSITIVITY = OFF', 
		@database_name=N'ECM365Tenant_ELDORADCA_BPS_Content', 
		@flags=0
IF (@@ERROR <> 0 OR @ReturnCode <> 0) GOTO QuitWithRollback
/****** Object:  Step [ECM365Tenant_KONSAL_BPS_Attachments_rebulid_catalog]    Script Date: 1/28/2020 8:05:26 PM ******/
EXEC @ReturnCode = msdb.dbo.sp_add_jobstep @job_id=@jobId, @step_name=N'ECM365Tenant_KONSAL_BPS_Attachments_rebulid_catalog', 
		@step_id=31, 
		@cmdexec_success_code=0, 
		@on_success_action=3, 
		@on_success_step_id=0, 
		@on_fail_action=2, 
		@on_fail_step_id=0, 
		@retry_attempts=0, 
		@retry_interval=0, 
		@os_run_priority=0, @subsystem=N'TSQL', 
		@command=N'ALTER FULLTEXT CATALOG WFAttachmentFiles
REBUILD WITH ACCENT_SENSITIVITY = OFF', 
		@database_name=N'ECM365Tenant_KONSAL_BPS_Attachments', 
		@flags=0
IF (@@ERROR <> 0 OR @ReturnCode <> 0) GOTO QuitWithRollback
/****** Object:  Step [ECM365Tenant_KONSAL_BPS_Content_rebulid_catalog]    Script Date: 1/28/2020 8:05:26 PM ******/
EXEC @ReturnCode = msdb.dbo.sp_add_jobstep @job_id=@jobId, @step_name=N'ECM365Tenant_KONSAL_BPS_Content_rebulid_catalog', 
		@step_id=32, 
		@cmdexec_success_code=0, 
		@on_success_action=3, 
		@on_success_step_id=0, 
		@on_fail_action=2, 
		@on_fail_step_id=0, 
		@retry_attempts=0, 
		@retry_interval=0, 
		@os_run_priority=0, @subsystem=N'TSQL', 
		@command=N'ALTER FULLTEXT CATALOG WorkFlow_FullText_Catalog
REBUILD WITH ACCENT_SENSITIVITY = OFF', 
		@database_name=N'ECM365Tenant_KONSAL_BPS_Content', 
		@flags=0
IF (@@ERROR <> 0 OR @ReturnCode <> 0) GOTO QuitWithRollback
/****** Object:  Step [ECM365Tenant_LAFARGE_BPS_Attachments_rebulid_catalog]    Script Date: 1/28/2020 8:05:27 PM ******/
EXEC @ReturnCode = msdb.dbo.sp_add_jobstep @job_id=@jobId, @step_name=N'ECM365Tenant_LAFARGE_BPS_Attachments_rebulid_catalog', 
		@step_id=33, 
		@cmdexec_success_code=0, 
		@on_success_action=3, 
		@on_success_step_id=0, 
		@on_fail_action=2, 
		@on_fail_step_id=0, 
		@retry_attempts=0, 
		@retry_interval=0, 
		@os_run_priority=0, @subsystem=N'TSQL', 
		@command=N'ALTER FULLTEXT CATALOG WFAttachmentFiles
REBUILD WITH ACCENT_SENSITIVITY = OFF', 
		@database_name=N'ECM365Tenant_LAFARGE_BPS_Attachments', 
		@flags=0
IF (@@ERROR <> 0 OR @ReturnCode <> 0) GOTO QuitWithRollback
/****** Object:  Step [ECM365Tenant_LAFARGE_BPS_Content_rebulid_catalog]    Script Date: 1/28/2020 8:05:27 PM ******/
EXEC @ReturnCode = msdb.dbo.sp_add_jobstep @job_id=@jobId, @step_name=N'ECM365Tenant_LAFARGE_BPS_Content_rebulid_catalog', 
		@step_id=34, 
		@cmdexec_success_code=0, 
		@on_success_action=3, 
		@on_success_step_id=0, 
		@on_fail_action=2, 
		@on_fail_step_id=0, 
		@retry_attempts=0, 
		@retry_interval=0, 
		@os_run_priority=0, @subsystem=N'TSQL', 
		@command=N'ALTER FULLTEXT CATALOG WorkFlow_FullText_Catalog
REBUILD WITH ACCENT_SENSITIVITY = OFF', 
		@database_name=N'ECM365Tenant_LAFARGE_BPS_Content', 
		@flags=0
IF (@@ERROR <> 0 OR @ReturnCode <> 0) GOTO QuitWithRollback
/****** Object:  Step [ECM365Tenant_MKPARTNER_BPS_Attachments_rebulid_catalog]    Script Date: 1/28/2020 8:05:27 PM ******/
EXEC @ReturnCode = msdb.dbo.sp_add_jobstep @job_id=@jobId, @step_name=N'ECM365Tenant_MKPARTNER_BPS_Attachments_rebulid_catalog', 
		@step_id=35, 
		@cmdexec_success_code=0, 
		@on_success_action=3, 
		@on_success_step_id=0, 
		@on_fail_action=2, 
		@on_fail_step_id=0, 
		@retry_attempts=0, 
		@retry_interval=0, 
		@os_run_priority=0, @subsystem=N'TSQL', 
		@command=N'ALTER FULLTEXT CATALOG WFAttachmentFiles
REBUILD WITH ACCENT_SENSITIVITY = OFF', 
		@database_name=N'ECM365Tenant_MKPARTNER_BPS_Attachments', 
		@flags=0
IF (@@ERROR <> 0 OR @ReturnCode <> 0) GOTO QuitWithRollback
/****** Object:  Step [ECM365Tenant_MKPARTNER_BPS_Content_rebulid_catalog]    Script Date: 1/28/2020 8:05:27 PM ******/
EXEC @ReturnCode = msdb.dbo.sp_add_jobstep @job_id=@jobId, @step_name=N'ECM365Tenant_MKPARTNER_BPS_Content_rebulid_catalog', 
		@step_id=36, 
		@cmdexec_success_code=0, 
		@on_success_action=3, 
		@on_success_step_id=0, 
		@on_fail_action=2, 
		@on_fail_step_id=0, 
		@retry_attempts=0, 
		@retry_interval=0, 
		@os_run_priority=0, @subsystem=N'TSQL', 
		@command=N'ALTER FULLTEXT CATALOG WorkFlow_FullText_Catalog
REBUILD WITH ACCENT_SENSITIVITY = OFF', 
		@database_name=N'ECM365Tenant_MKPARTNER_BPS_Content', 
		@flags=0
IF (@@ERROR <> 0 OR @ReturnCode <> 0) GOTO QuitWithRollback
/****** Object:  Step [ECM365Tenant_PRODIGO_BPS_Attachments_rebulid_catalog]    Script Date: 1/28/2020 8:05:27 PM ******/
EXEC @ReturnCode = msdb.dbo.sp_add_jobstep @job_id=@jobId, @step_name=N'ECM365Tenant_PRODIGO_BPS_Attachments_rebulid_catalog', 
		@step_id=37, 
		@cmdexec_success_code=0, 
		@on_success_action=3, 
		@on_success_step_id=0, 
		@on_fail_action=2, 
		@on_fail_step_id=0, 
		@retry_attempts=0, 
		@retry_interval=0, 
		@os_run_priority=0, @subsystem=N'TSQL', 
		@command=N'ALTER FULLTEXT CATALOG WFAttachmentFiles
REBUILD WITH ACCENT_SENSITIVITY = OFF', 
		@database_name=N'ECM365Tenant_PRODIGO_BPS_Attachments', 
		@flags=0
IF (@@ERROR <> 0 OR @ReturnCode <> 0) GOTO QuitWithRollback
/****** Object:  Step [ECM365Tenant_PRODIGO_BPS_Content_rebulid_catalog]    Script Date: 1/28/2020 8:05:27 PM ******/
EXEC @ReturnCode = msdb.dbo.sp_add_jobstep @job_id=@jobId, @step_name=N'ECM365Tenant_PRODIGO_BPS_Content_rebulid_catalog', 
		@step_id=38, 
		@cmdexec_success_code=0, 
		@on_success_action=3, 
		@on_success_step_id=0, 
		@on_fail_action=2, 
		@on_fail_step_id=0, 
		@retry_attempts=0, 
		@retry_interval=0, 
		@os_run_priority=0, @subsystem=N'TSQL', 
		@command=N'ALTER FULLTEXT CATALOG WorkFlow_FullText_Catalog
REBUILD WITH ACCENT_SENSITIVITY = OFF', 
		@database_name=N'ECM365Tenant_PRODIGO_BPS_Content', 
		@flags=0
IF (@@ERROR <> 0 OR @ReturnCode <> 0) GOTO QuitWithRollback
/****** Object:  Step [ECM365Tenant_PTAK_BPS_Content_rebulid_catalog]    Script Date: 1/28/2020 8:05:27 PM ******/
EXEC @ReturnCode = msdb.dbo.sp_add_jobstep @job_id=@jobId, @step_name=N'ECM365Tenant_PTAK_BPS_Content_rebulid_catalog', 
		@step_id=39, 
		@cmdexec_success_code=0, 
		@on_success_action=3, 
		@on_success_step_id=0, 
		@on_fail_action=2, 
		@on_fail_step_id=0, 
		@retry_attempts=0, 
		@retry_interval=0, 
		@os_run_priority=0, @subsystem=N'TSQL', 
		@command=N'ALTER FULLTEXT CATALOG WFAttaWorkFlow_FullText_CatalogchmentFiles
REBUILD WITH ACCENT_SENSITIVITY = OFF', 
		@database_name=N'ECM365Tenant_PTAK_BPS_Content', 
		@flags=0
IF (@@ERROR <> 0 OR @ReturnCode <> 0) GOTO QuitWithRollback
/****** Object:  Step [ECM365Tenant_PTAK_BPS_Attachments_rebulid_catalog]    Script Date: 1/28/2020 8:05:27 PM ******/
EXEC @ReturnCode = msdb.dbo.sp_add_jobstep @job_id=@jobId, @step_name=N'ECM365Tenant_PTAK_BPS_Attachments_rebulid_catalog', 
		@step_id=40, 
		@cmdexec_success_code=0, 
		@on_success_action=1, 
		@on_success_step_id=0, 
		@on_fail_action=2, 
		@on_fail_step_id=0, 
		@retry_attempts=0, 
		@retry_interval=0, 
		@os_run_priority=0, @subsystem=N'TSQL', 
		@command=N'ALTER FULLTEXT CATALOG WFAttachmentFiles
REBUILD WITH ACCENT_SENSITIVITY = OFF', 
		@database_name=N'ECM365Tenant_PTAK_BPS_Attachments', 
		@flags=0
IF (@@ERROR <> 0 OR @ReturnCode <> 0) GOTO QuitWithRollback
EXEC @ReturnCode = msdb.dbo.sp_update_job @job_id = @jobId, @start_step_id = 1
IF (@@ERROR <> 0 OR @ReturnCode <> 0) GOTO QuitWithRollback
EXEC @ReturnCode = msdb.dbo.sp_add_jobschedule @job_id=@jobId, @name=N'Weekly', 
		@enabled=1, 
		@freq_type=4, 
		@freq_interval=1, 
		@freq_subday_type=1, 
		@freq_subday_interval=0, 
		@freq_relative_interval=0, 
		@freq_recurrence_factor=0, 
		@active_start_date=20190205, 
		@active_end_date=99991231, 
		@active_start_time=40000, 
		@active_end_time=235959, 
		@schedule_uid=N'ec9c5340-93f2-42ce-aaa6-bc7e5bd4f8d4'
IF (@@ERROR <> 0 OR @ReturnCode <> 0) GOTO QuitWithRollback
EXEC @ReturnCode = msdb.dbo.sp_add_jobserver @job_id = @jobId, @server_name = N'(local)'
IF (@@ERROR <> 0 OR @ReturnCode <> 0) GOTO QuitWithRollback
COMMIT TRANSACTION
GOTO EndSave
QuitWithRollback:
    IF (@@TRANCOUNT > 0) ROLLBACK TRANSACTION
EndSave:

GO

