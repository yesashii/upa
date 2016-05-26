
-- Attachment --------------
CREATE TABLE [Attachment]
(
  [id] [int] IDENTITY(1,1) NOT NULL, 
  [ItemPost]    int   NULL  , 
  [AttachmentName]    nvarchar(200)   NULL  , 
  [AttachmentContent]    nvarchar(200)   NULL 
, CONSTRAINT [PK_Attachment] PRIMARY KEY CLUSTERED ([id] ASC)WITH (PAD_INDEX  = OFF, IGNORE_DUP_KEY = OFF) ON [PRIMARY]) ON [PRIMARY]
GO
    