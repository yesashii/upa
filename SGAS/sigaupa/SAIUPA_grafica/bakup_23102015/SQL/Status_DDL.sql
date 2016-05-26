
-- Status --------------
CREATE TABLE [Status]
(
  [id] [int] IDENTITY(1,1) NOT NULL, 
  [StatusName]    nvarchar(200)   NULL  , 
  [SortOrder]    int   NULL  , 
  [CSSClass]    nvarchar(200)   NULL  , 
  [isDefault]    bit  NULL 
, CONSTRAINT [PK_Status] PRIMARY KEY CLUSTERED ([id] ASC)WITH (PAD_INDEX  = OFF, IGNORE_DUP_KEY = OFF) ON [PRIMARY]) ON [PRIMARY]
GO
    