
      <%

      '
      ' This files defines the Login model
      '
class Login

      private mMetadata

      '=============================
      'Private properties
        private  mId
        private  mUsuario
        private  mClave

      private sub Class_Initialize()
          mMetadata = Array("1", "1")
      end sub

      private sub Class_Terminate()
      end sub

      '=============================
      'public properties

      public property get Id()
          Id = mId
      end property

      public property let Id(val)
          mId = val
      end property
      
      public property get Usuario()
          Usuario = mUsuario
      end property

      public property let Usuario(val)
          mUsuario = val
      end property
      
      public property get Clave()
          Clave = mClave
      end property

      public property let Clave(val)
          mClave = val
      end property
      
      'exteded properties - names from related tables -read/write, but not saved in DB
      
      public property get metadata()
          metadata = mMetadata
      end property


      end class 'Login


      '======================
class LoginHelper

      Dim selectSQL

      private sub Class_Initialize()
          selectSQL = " select [tr].id,[tr].usuario,[tr].clave" + _
					  "	From "     + _
					  "	(     "    + _
					  "		select pers_ncorr as id, asg_tlogin as usuario, asg_tclave as clave from [ASG_USERS]   " + _
					  "  ) tr " + _
					  " "
	  end sub

      private sub Class_Terminate()
      end sub

      '=============================
      'public Functions

      ' Select all Login into a Dictionary
      ' return a Dictionary of Login objects - if successful, Nothing otherwise
      public function SelectAll()
          Dim records
          set objCommand=Server.CreateObject("ADODB.command")
          objCommand.ActiveConnection=DbOpenConnection()
          objCommand.NamedParameters = False
          objCommand.CommandText = selectSQL
          objCommand.CommandType = adCmdText
          set records = objCommand.Execute
          if records.eof then
               Set SelectAll = Nothing
          else
               Dim results, obj, record
               Set results = Server.CreateObject("Scripting.Dictionary")
               while not records.eof
                    set obj = PopulateObjectFromRecord(records)
                    results.Add obj.id, obj
                    records.movenext
               wend
               set SelectAll = results
               records.Close
          End If
          set records = nothing
      end function
	  
      ' Select all Login into a Dictionary
      ' return a Dictionary of Login objects - if successful, Nothing otherwise
      public function Search(usuario,pass)
          Dim records
          set objCommand=Server.CreateObject("ADODB.command")
          objCommand.ActiveConnection=DbOpenConnection()
          objCommand.NamedParameters = False
          objCommand.CommandText = selectSQL + _
          " where (1=1) and [tr].usuario='" + usuario + "' and CONVERT(varchar,DecryptByPassphrase('presunciosa', [tr].clave, 1, CONVERT(varbinary, 7))) = '"+uCase(pass)+"'"       
          objCommand.CommandType = adCmdText
          set records = objCommand.Execute
          if records.eof then
               Set Search = Nothing
          else
               Dim results, obj, record
               Set results = Server.CreateObject("Scripting.Dictionary")
               while not records.eof
                    set obj = PopulateObjectFromRecord(records)
                    results.Add obj.id, obj
                    records.movenext
               wend
               set Search = results
               records.Close
          End If
          set records = nothing
      end function

      public function BuscaUsuario(usuario, pass)
		Dim record
		set record = DbExecute(StringFormat(selectSQL + " WHERE [tr].usuario = '{0}' and [tr].clave = dbo.fn_EncryptPassword('{1}')", array(usuario,pass)))
		Set BuscaUsuario = PopulateObjectFromRecord(record)
		record.Close
		set record = nothing
		DbCloseConnection
	  end function
    
      private function PopulateObjectFromRecord(record)
        if record.eof then
            Set PopulateObjectFromRecord = Nothing
        else
            Dim obj
            set obj = new Login
            obj.Id = record("Id")
            obj.Usuario = record("usuario")
            obj.Clave = record("clave")
           
            set PopulateObjectFromRecord = obj
      end if
    end function

end class 'LoginHelper
%>
    