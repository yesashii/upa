
-- VERIFY THE SYNTAX!!! SCRIPT HAS BEEN CREATED AUTOMATICALLY WITH THE BEST GUESS!!! ---    
-- Email --------------

Insert into [Email]
   ([FromAddress]  , [ToAddress]  , [Subject]  , [Body]  , [Incomming] )
Values 
   (  'test data 1'   ,   'test data 1'   ,   'test data 1'   ,   'test data 1'   ,   True )
GO


Insert into [Email]
   ([FromAddress]  , [ToAddress]  , [Subject]  , [Body]  , [Incomming] )
Values 
   (  'test data 2'   ,   'test data 2'   ,   'test data 2'   ,   'test data 2'   ,   False )
GO

Insert into [Email]
   ([FromAddress]  , [ToAddress]  , [Subject]  , [Body]  , [Incomming] )
Values 
   (  'test data 3'   ,   'test data 3'   ,   'test data 3'   ,   'test data 3'   ,   True )
GO
    