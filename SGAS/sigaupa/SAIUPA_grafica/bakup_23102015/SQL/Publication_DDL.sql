
-- Publication --------------
CREATE TABLE [Publication]
(
  [id] [int] IDENTITY(1,1) NOT NULL, 
  [PublicationName]    nvarchar(200)   NULL  , 
  [ProjectID]    int   NULL  , 
  [PriorityID]    int   NULL  , 
  [StatusID]    int   NULL  , 
  [Description]    nvarchar(MAX)   NULL  , 
  [OrganizationID]    int   NULL  , 
  [CategoryID]    int   NULL 
, CONSTRAINT [PK_Publication] PRIMARY KEY CLUSTERED ([id] ASC)WITH (PAD_INDEX  = OFF, IGNORE_DUP_KEY = OFF) ON [PRIMARY]) ON [PRIMARY]
GO
    