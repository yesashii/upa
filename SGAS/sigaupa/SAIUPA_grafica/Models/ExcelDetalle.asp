
      <%

      '
      ' This files defines the ExcelDetalle model
      '
class ExcelDetalle

      private mMetadata

      '=============================
      'Private properties
      private  mAnio
      private  mSede
      private  mCarrera
      private  mJornada
      private  mFacultad
      private  mRut
      private  mNombre
	  private  mPaterno
      private  mMaterno
      private  mSexo
	  private  mFechaNac
	  private  mPais
	  private  mRegion

      private sub Class_Initialize()
          mMetadata = Array("2005", "Las Condes")
      end sub

      private sub Class_Terminate()
      end sub

      '=============================
      'public properties

      public property get Anio()
          Anio = mAnio
      end property

      public property let Anio(val)
          mAnio = val
      end property
      
      public property get Sede()
          Sede = mSede
      end property

      public property let Sede(val)
          mSede = val
      end property
      
      public property get Carrera()
          Carrera = mCarrera
      end property

      public property let Carrera(val)
          mCarrera = val
      end property
      
      public property get Jornada()
          Jornada = mJornada
      end property

      public property let Jornada(val)
          mJornada = val
      end property
	  
	  public property get Facultad()
          Facultad = mFacultad
      end property

      public property let Facultad(val)
          mFacultad = val
      end property
      
      public property get Rut()
          Rut = mRut
      end property

      public property let Rut(val)
          mRut = val
      end property
      
      public property get Nombre()
          Nombre = mNombre
      end property

      public property let Nombre(val)
          mNombre = val
      end property
	  
	  public property get Paterno()
          Paterno = mPaterno
      end property

      public property let Paterno(val)
          mPaterno = val
      end property
      
      public property get Materno()
          Materno = mMaterno
      end property

      public property let Materno(val)
          mMaterno = val
      end property
      
      public property get Sexo()
          Sexo = mSexo
      end property

      public property let Sexo(val)
          mSexo = val
      end property
	  
	  public property get FechaNac()
          FechaNac = mFechaNac
      end property

      public property let FechaNac(val)
          mFechaNac = val
      end property
      
	  public property get Pais()
          Pais = mPais
      end property

      public property let Pais(val)
          mPais = val
      end property
	  
	  public property get Region()
          Region = mRegion
      end property

      public property let Region(val)
          mRegion = val
      end property
      'exteded properties - names from related tables -read/write, but not saved in DB
      
      public property get metadata()
          metadata = mMetadata
      end property


      end class 'Postulante


      '======================
class ExcelDetalleHelper

      Dim selectSQL

      private sub Class_Initialize()
          selectSQL = " select ANOS_CCOD as Anio, SEDE_TDESC as Sede, CARR_TDESC as Carrera, JORN_TDESC as Jornada, FACU_TDESC as Facultad, "    + _
					  "            RUT as Rut, PERS_TNOMBRE as Nombre, PERS_TAPE_PATERNO as Paterno, PERS_TAPE_MATERNO as Materno, SEXO as Sexo, "    + _
					  " 		   PERS_FNACIMIENTO as FechaNac, PAIS_TDESC as Pais, REGI_TDESC as Region " + _
					  "		from [SGA_POSTULANTES_DETALLE] tr  "    + _
					  " "
	  end sub

      private sub Class_Terminate()
      end sub

      '=============================
      'public Functions

      ' Select all Postulante into a Dictionary
      ' return a Dictionary of ExcelDetalle objects - if successful, Nothing otherwise
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
                    results.Add cstr(obj.Anio)+ obj.Sede + obj.Carrera + obj.Jornada + obj.Rut, obj
                    records.movenext
               wend
               set SelectAll = results
               records.Close
          End If
          set records = nothing
      end function
	  
	  ' Select all Postulante into a Dictionary
      ' return a Dictionary of Postulante objects - if successful, Nothing otherwise
      public function Search(value)
          Dim records
          set objCommand=Server.CreateObject("ADODB.command")
          objCommand.ActiveConnection=DbOpenConnection()
          objCommand.NamedParameters = False
          objCommand.CommandText = selectSQL + _
          " where (1=1) "  + " and ([tr].ANOS_CCOD in (" + value + ")) "       
          objCommand.CommandType = adCmdText
          set records = objCommand.Execute
          if records.eof then
               Set Search = Nothing
          else
               Dim results, obj, record
               Set results = Server.CreateObject("Scripting.Dictionary")
               while not records.eof
                    set obj = PopulateObjectFromRecord(records)
                    results.Add cstr(obj.Anio)+ obj.Sede + obj.Carrera + obj.Jornada + obj.Rut, obj
                    records.movenext
               wend
               set Search = results
               records.Close
          End If
          set records = nothing
      end function


      private function PopulateObjectFromRecord(record)
        if record.eof then
            Set PopulateObjectFromRecord = Nothing
        else
            Dim obj
            set obj = new ExcelDetalle
           
		      obj.Anio		 = record("Anio")
			  obj.Sede 		 = record("Sede")
			  obj.Carrera    = record("Carrera")
			  obj.Jornada    = record("Jornada")
			  obj.Facultad   = record("Facultad")
			  obj.Rut        = record("Rut")
			  obj.Nombre     = record("Nombre")
			  obj.Paterno    = record("Paterno")
			  obj.Materno    = record("Materno")
			  obj.Sexo       = record("Sexo")
			  obj.FechaNac   = record("FechaNac")
			  obj.Pais       = record("Pais")
			  obj.Region     = record("Region")
             
              set PopulateObjectFromRecord = obj
      end if
    end function

end class 'PostulanteHelper
%>
    