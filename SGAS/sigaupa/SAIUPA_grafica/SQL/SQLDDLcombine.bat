

    @echo Create database test_mvc                   >> "createDbScript.sql"
    @echo GO                                         >> "createDbScript.sql"

    @echo Use test_mvc                               >> "createDbScript.sql"
    @echo GO                                         >> "createDbScript.sql"

    @echo -- create the user and login               >> "createDbScript.sql"
    @echo CREATE LOGIN xx                            >> "createDbScript.sql"
    @echo WITH PASSWORD = 'xxxxxx';                  >> "createDbScript.sql"
    @echo USE test_mvc;                              >> "createDbScript.sql"
    @echo CREATE USER xx FOR LOGIN xx;               >> "createDbScript.sql"

    @echo -- add user to the role                    >> "createDbScript.sql"
    @echo EXEC sp_addrolemember  'db_owner','xx';    >> "createDbScript.sql"

    md DDL
    md TEST
    
      type "Organization_DDL.sql" >> "createDbScript.sql"
      type "Organization_TestData.sql" >> "TestDataScript.sql"

      move "Organization_DDL.sql"  "DDL/Organization_DDL.sql"
      move "Organization_TestData.sql"  "TEST/Organization_DDL.sql"
    
      type "Publication_DDL.sql" >> "createDbScript.sql"
      type "Publication_TestData.sql" >> "TestDataScript.sql"

      move "Publication_DDL.sql"  "DDL/Publication_DDL.sql"
      move "Publication_TestData.sql"  "TEST/Publication_DDL.sql"
    
      type "User_DDL.sql" >> "createDbScript.sql"
      type "User_TestData.sql" >> "TestDataScript.sql"

      move "User_DDL.sql"  "DDL/User_DDL.sql"
      move "User_TestData.sql"  "TEST/User_DDL.sql"
    
      type "PublicationPost_DDL.sql" >> "createDbScript.sql"
      type "PublicationPost_TestData.sql" >> "TestDataScript.sql"

      move "PublicationPost_DDL.sql"  "DDL/PublicationPost_DDL.sql"
      move "PublicationPost_TestData.sql"  "TEST/PublicationPost_DDL.sql"
    
      type "Email_DDL.sql" >> "createDbScript.sql"
      type "Email_TestData.sql" >> "TestDataScript.sql"

      move "Email_DDL.sql"  "DDL/Email_DDL.sql"
      move "Email_TestData.sql"  "TEST/Email_DDL.sql"
    
      type "Attachment_DDL.sql" >> "createDbScript.sql"
      type "Attachment_TestData.sql" >> "TestDataScript.sql"

      move "Attachment_DDL.sql"  "DDL/Attachment_DDL.sql"
      move "Attachment_TestData.sql"  "TEST/Attachment_DDL.sql"
    
      type "Category_DDL.sql" >> "createDbScript.sql"
      type "Category_TestData.sql" >> "TestDataScript.sql"

      move "Category_DDL.sql"  "DDL/Category_DDL.sql"
      move "Category_TestData.sql"  "TEST/Category_DDL.sql"
    
      type "PostType_DDL.sql" >> "createDbScript.sql"
      type "PostType_TestData.sql" >> "TestDataScript.sql"

      move "PostType_DDL.sql"  "DDL/PostType_DDL.sql"
      move "PostType_TestData.sql"  "TEST/PostType_DDL.sql"
    
      type "Priority_DDL.sql" >> "createDbScript.sql"
      type "Priority_TestData.sql" >> "TestDataScript.sql"

      move "Priority_DDL.sql"  "DDL/Priority_DDL.sql"
      move "Priority_TestData.sql"  "TEST/Priority_DDL.sql"
    
      type "Status_DDL.sql" >> "createDbScript.sql"
      type "Status_TestData.sql" >> "TestDataScript.sql"

      move "Status_DDL.sql"  "DDL/Status_DDL.sql"
      move "Status_TestData.sql"  "TEST/Status_DDL.sql"
    
      type "Project_DDL.sql" >> "createDbScript.sql"
      type "Project_TestData.sql" >> "TestDataScript.sql"

      move "Project_DDL.sql"  "DDL/Project_DDL.sql"
      move "Project_TestData.sql"  "TEST/Project_DDL.sql"
    