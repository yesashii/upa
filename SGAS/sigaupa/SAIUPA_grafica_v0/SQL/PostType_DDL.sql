
-- PostType --------------
CREATE TABLE [PostType]
(
  [id] [int] IDENTITY(1,1) NOT NULL, 
  [PostTypeName]    nvarchar(200)   NULL  , 
  [SortOrder]    int   NULL 
, CONSTRAINT [PK_PostType] PRIMARY KEY CLUSTERED ([id] ASC)WITH (PAD_INDEX  = OFF, IGNORE_DUP_KEY = OFF) ON [PRIMARY]) ON [PRIMARY]
GO
    