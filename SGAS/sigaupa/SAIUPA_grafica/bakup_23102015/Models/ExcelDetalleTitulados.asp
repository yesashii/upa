
      <%

      '
      ' This files defines the ExcelDetalleTitulados model
      '
class ExcelDetalleTitulados

      private mMetadata

      '=============================
      'Private properties
      private  mAnio
	  
	  private  mCodigoUnico
	  private  mCodigoRC
	  private  mEdad
	  private  mEdadEntero
	  private  mRangoEdad
	  private  mCodEstadoCivil
	  private  mFechaMatrimonio
	  private  mFechaDefuncion
	  private  mAnoIngPriAno
	  private  mSemIngPriAno
	  private  mAnoIngCarrera
	  private  mSemIngCarrera
	  private  mExtranjero
	  private  mNacionalidad
	  private  mSede
      private  mCarrera
      private  mJornada
      private  mRut
      private  mNombre
	  private  mPaterno
      private  mMaterno
      private  mSexo
	  private  mFechaNac
	  private  mNombTituloObtenido
	  private  mNombGradoObtenido
	  private  mFechaObtencionTitulo

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
      
	  public property get CodigoUnico()
	            CodigoUnico = mCodigoUnico
      end property
      public property let CodigoUnico(val)
	            mCodigoUnico = val      
	  end property
	  
	  public property get CodigoRC()
	            CodigoRC = mCodigoRC      
	  end property
      public property let CodigoRC(val)
	            mCodigoRC = val      
	  end property
	  
	  public property get Edad()
	            Edad = mEdad      
	  end property
      public property let Edad(val)
	            mEdad = val      
	  end property
	  
	  public property get EdadEntero()
	            EdadEntero = mEdadEntero      
	  end property
      public property let EdadEntero(val)
	            mEdadEntero = val      
	  end property
	  
	  public property get RangoEdad()
	            RangoEdad = mRangoEdad      
	  end property
      public property let RangoEdad(val)
	            mRangoEdad = val      
	  end property
	  
	  public property get CodEstadoCivil()
	            CodEstadoCivil = mCodEstadoCivil      
	  end property
      public property let CodEstadoCivil(val)
	            mCodEstadoCivil = val      
	  end property
	  
	  public property get FechaMatrimonio()
	            FechaMatrimonio = mFechaMatrimonio      
	  end property
      public property let FechaMatrimonio(val)
	            mFechaMatrimonio = val      
	  end property
	  
	  public property get FechaDefuncion()
	            FechaDefuncion = mFechaDefuncion      
	  end property
      public property let FechaDefuncion(val)
	            mFechaDefuncion = val      
	  end property
	  
	  public property get AnoIngPriAno()
	            AnoIngPriAno = mAnoIngPriAno      
	  end property
      public property let AnoIngPriAno(val)
	            mAnoIngPriAno = val      
	  end property
	  
	  public property get SemIngPriAno()
	            SemIngPriAno = mSemIngPriAno      
	  end property
      public property let SemIngPriAno(val)
	            mSemIngPriAno = val      
	  end property
	  
	  public property get AnoIngCarrera()
	            AnoIngCarrera = mAnoIngCarrera      
	  end property
      public property let AnoIngCarrera(val)
	            mAnoIngCarrera = val      
	  end property
	  
	  public property get SemIngCarrera()
	            SemIngCarrera = mSemIngCarrera      
	  end property
      public property let SemIngCarrera(val)
	            mSemIngCarrera = val      
	  end property
	  
	  public property get Extranjero()
	            Extranjero = mExtranjero      
	  end property
      public property let Extranjero(val)
	            mExtranjero = val      
	  end property
	  
	  public property get Nacionalidad()
	            Nacionalidad = mNacionalidad      
	  end property
      public property let Nacionalidad(val)
	            mNacionalidad = val      
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
	  
	  
	   public property get NombTituloObtenido()
          NombTituloObtenido = mNombTituloObtenido
      end property

      public property let NombTituloObtenido(val)
          mNombTituloObtenido = val
      end property
	  
	  
	   public property get NombGradoObtenido()
          NombGradoObtenido = mNombGradoObtenido
      end property

      public property let NombGradoObtenido(val)
          mNombGradoObtenido = val
      end property
	  
	   public property get FechaObtencionTitulo()
          FechaObtencionTitulo = mFechaObtencionTitulo
      end property

      public property let FechaObtencionTitulo(val)
          mFechaObtencionTitulo = val
      end property
	  
      
      'exteded properties - names from related tables -read/write, but not saved in DB
      
      public property get metadata()
          metadata = mMetadata
      end property


      end class 'Postulante


      '======================
class ExcelDetalleTituladosHelper

      Dim selectSQL

      private sub Class_Initialize()
          selectSQL =   " select distinct a.tit_cat_periodo as Anio, a.tit_CODIGO_UNICO as CodigoUnico,   " + _ 
						" a.tit_CODIGO_RC as CodigoRC,   " + _ 
						" tt.CARRTIT_NOMB_SEDE as Sede, tt.CARRTIT_NOMB_CARRERA as Carrera, tt.CARRTIT_JORNADA as Jornada,   " + _ 
						" a.tit_RUT,A.tit_DV,CAST(a.tit_RUT AS VARCHAR) +'-'+ isnull(a.tit_DV,'') as Rut,   " + _ 
						" a.tit_NOMBRES as Nombre, a.tit_APE_PATERNO as Paterno, a.tit_APE_MATERNO as Materno, a.tit_SEXO as Sexo, a.tit_FECHA_NACIMIENTO as FechaNac,   " + _ 
						" a.tit_EDAD as Edad, a.tit_EDAD_entero as EdadEntero, a.tit_RANGO_EDAD as RangoEdad, a.tit_COD_ESTADO_CIVIL as CodEstadoCivil,   " + _ 
						" a.tit_FECHA_MATRIMONIO as FechaMatrimonio, a.tit_FECHA_DEFUNCION as FechaDefuncion, a.tit_ANO_ING_PRI_ANO  as AnoIngPriAno,   " + _ 
						" a.tit_SEM_ING_PRI_AÑO as SemIngPriAno, a.tit_ANO_ING_CARR as AnoIngCarrera, a.tit_SEM_ING_CARR as SemIngCarrera,  " + _ 
						" a.tit_EXTRANJERO as Extranjero, a.tit_NACIONALIDAD as Nacionalidad,a.TIT_NOMB_TITULO_OBTENIDO as NombTituloObtenido,  " + _ 
						" a.TIT_NOMB_GRADO_OBTENIDO as NombGradoObtenido, a.TIT_FECHA_OBTENCION_TITULO as FechaObtencionTitulo   " + _ 
						" from SAIUPA..ani_titulados a, SAIUPA..ANI_CARRERAS_TITULADOS tt   " + _ 	
						" where tt.CARRTIT_CODIGO_UNICO=a.TIT_CODIGO_UNICO  " + _ 
						" and tt.CARRTIT_NIVEL_GLOBAL = 'PREGRADO' and A.TIT_CAT_PERIODO = tt.CARRTIT_CAT_PERIODO	  " + _ 														
						" and isnull(CAST(a.TIT_RUT AS VARCHAR) +'-'+ isnull(a.TIT_DV,''),'') <> '' " + _
					    " "
	  end sub

      private sub Class_Terminate()
      end sub

      '=============================
      'public Functions

      ' Select all Postulante into a Dictionary
      ' return a Dictionary of ExcelDetalleTitulados objects - if successful, Nothing otherwise
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
                    results.Add obj.Anio + obj.codigoUnico + obj.Rut + cstr(obj.FechaObtencionTitulo), obj
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
          objCommand.CommandText = selectSQL + " and a.tit_cat_periodo like '%" + value + "%' "       
          objCommand.CommandType = adCmdText
          set records = objCommand.Execute
          if records.eof then
               Set Search = Nothing
          else
               Dim results, obj, record
               Set results = Server.CreateObject("Scripting.Dictionary")
               while not records.eof
                    set obj = PopulateObjectFromRecord(records)
					'response.Write(obj.Anio + " " + obj.codigoUnico + " " + obj.Rut + " " + cstr(obj.FechaObtencionTitulo))
                    results.Add obj.Anio + obj.codigoUnico + obj.Rut + cstr(obj.FechaObtencionTitulo), obj
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
            set obj = new ExcelDetalleTitulados
           
		      obj.Anio		 			= record("Anio")
			  obj.CodigoUnico			= record("CodigoUnico")
			  obj.CodigoRC		 		= record("CodigoRC")
			  obj.Edad		 			= record("Edad")
			  obj.EdadEntero		 	= record("EdadEntero")
			  obj.RangoEdad		 		= record("RangoEdad")
			  obj.CodEstadoCivil		= record("CodEstadoCivil")
			  obj.FechaMatrimonio		= record("FechaMatrimonio")
			  obj.FechaDefuncion		= record("FechaDefuncion")
			  obj.AnoIngPriAno		 	= record("AnoIngPriAno")
			  obj.SemIngPriAno		 	= record("SemIngPriAno")
			  obj.AnoIngCarrera		 	= record("AnoIngCarrera")
			  obj.SemIngCarrera		 	= record("SemIngCarrera")
			  obj.Extranjero		 	= record("Extranjero")
			  obj.Nacionalidad		 	= record("Nacionalidad")
			  obj.Sede 		 			= record("Sede")
			  obj.Carrera    			= record("Carrera")
			  obj.Jornada    			= record("Jornada")
			  obj.Rut        			= record("Rut")
			  obj.Nombre     			= record("Nombre")
			  obj.Paterno    			= record("Paterno")
			  obj.Materno    			= record("Materno")
			  obj.Sexo       			= record("Sexo")
			  obj.FechaNac   			= record("FechaNac")
			  obj.NombTituloObtenido    = record("NombTituloObtenido")
			  obj.NombGradoObtenido     = record("NombGradoObtenido")
			  obj.FechaObtencionTitulo  = record("FechaObtencionTitulo")

              set PopulateObjectFromRecord = obj
      end if
    end function

end class 'PostulanteHelper
%>
    