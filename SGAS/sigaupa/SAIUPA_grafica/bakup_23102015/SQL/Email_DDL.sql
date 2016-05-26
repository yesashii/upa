
-- Email --------------
CREATE TABLE [Email]
(
  [id] [int] IDENTITY(1,1) NOT NULL, 
  [FromAddress]    nvarchar(200)   NULL  , 
  [ToAddress]    nvarchar(200)   NULL  , 
  [Subject]    nvarchar(200)   NULL  , 
  [Body]    nvarchar(MAX)   NULL  , 
  [Incomming]    bit  NULL 
, CONSTRAINT [PK_Email] PRIMARY KEY CLUSTERED ([id] ASC)WITH (PAD_INDEX  = OFF, IGNORE_DUP_KEY = OFF) ON [PRIMARY]) ON [PRIMARY]
GO
    