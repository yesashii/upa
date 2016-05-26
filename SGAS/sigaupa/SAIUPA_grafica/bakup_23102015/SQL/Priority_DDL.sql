
-- Priority --------------
CREATE TABLE [Priority]
(
  [id] [int] IDENTITY(1,1) NOT NULL, 
  [PriorityName]    nvarchar(200)   NULL  , 
  [SortOrder]    int   NULL  , 
  [SCCClass]    nvarchar(200)   NULL  , 
  [BGColor]    nvarchar(200)   NULL 
, CONSTRAINT [PK_Priority] PRIMARY KEY CLUSTERED ([id] ASC)WITH (PAD_INDEX  = OFF, IGNORE_DUP_KEY = OFF) ON [PRIMARY]) ON [PRIMARY]
GO
    