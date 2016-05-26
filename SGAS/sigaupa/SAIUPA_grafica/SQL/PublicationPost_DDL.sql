
-- PublicationPost --------------
CREATE TABLE [PublicationPost]
(
  [id] [int] IDENTITY(1,1) NOT NULL, 
  [PublicationPostName]    nvarchar(200)   NULL  , 
  [PostText]    nvarchar(MAX)   NULL  , 
  [PublicationID]    int   NULL  , 
  [PostType]    int   NULL  , 
  [Author]    int   NULL 
, CONSTRAINT [PK_PublicationPost] PRIMARY KEY CLUSTERED ([id] ASC)WITH (PAD_INDEX  = OFF, IGNORE_DUP_KEY = OFF) ON [PRIMARY]) ON [PRIMARY]
GO
    