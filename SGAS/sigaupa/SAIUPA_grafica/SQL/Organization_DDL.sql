
-- Organization --------------
CREATE TABLE [Organization]
(
  [id] [int] IDENTITY(1,1) NOT NULL, 
  [OrganizationName]    nvarchar(200)   NULL  , 
  [Description]    nvarchar(MAX)   NULL  , 
  [Active]    bit  NULL  , 
  [isExternal]    bit  NULL 
, CONSTRAINT [PK_Organization] PRIMARY KEY CLUSTERED ([id] ASC)WITH (PAD_INDEX  = OFF, IGNORE_DUP_KEY = OFF) ON [PRIMARY]) ON [PRIMARY]
GO
    