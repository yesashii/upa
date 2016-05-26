RESTORE DATABASE protic2
 FROM DISK = 'C:\Archivos de programa\Microsoft SQL Server\MSSQL\BACKUP\FS24Sigaupa.BAK'
 WITH NORECOVERY,
      MOVE 'protic_data' TO 'C:\Archivos de programa\Microsoft SQL Server\MSSQL\Data\protic2.mdf', 
      MOVE 'protic_log' TO 'C:\Archivos de programa\Microsoft SQL Server\MSSQL\Data\protic2_log.ldf'