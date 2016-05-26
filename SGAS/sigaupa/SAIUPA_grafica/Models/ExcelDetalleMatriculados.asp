
      <%

      '
      ' This files defines the ExcelDetalleMatriculados model
      '
class ExcelDetalleMatriculados

      private mMetadata

      '=============================
      'Private properties
      private  mAnio
	  
	  private  mCodigoUnico
	  private  mCodigoUnicoProceso
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
	  private  mPaisEstudiosPrevios
	  private  mExtranjero
	  private  mNumPasaporte
	  private  mNacionalidad
	  private  mTipoEstudiante
	  private  mTipoResidencia
	  private  mPerfilNotaEm
	  private  mNRbdAnioEgreso
	  private  mNRbd
	  private  mNRbdNem
	  private  mNRbdCodDependencia
	  private  mNRbdRegion
	  private  mNRbdCodEstablecimiento
	  private  mNRbdTipoEstablecimiento
	  private  mNRbdClasEstablecimiento
	  private  mRPsu
	  private  mRPsuAnioEgreso
	  private  mRPsuRbd
	  private  mRPsuCodDependencia
	  private  mRPsuRegion
	  private  mRPsuNem
	  private  mRPsuTramo50
	  private  mRPsuTramo502
	  private  mRPsuTramo100
	  private  mRPsuTramo600700720
	  private  mRPsuTramo475por50
	  private  mBBeca
	  
      private  mSede
      private  mCarrera
      private  mJornada
      private  mRut
      private  mNombre
	  private  mPaterno
      private  mMaterno
      private  mSexo
	  private  mFechaNac

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
	  
	  public property get CodigoUnicoProceso()          
	  			CodigoUnicoProceso = mCodigoUnicoProceso      
	  end property
      public property let CodigoUnicoProceso(val)
	  		    mCodigoUnicoProceso = val      
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
	  
	  public property get PaisEstudiosPrevios()
	            PaisEstudiosPrevios = mPaisEstudiosPrevios      
	  end property
      public property let PaisEstudiosPrevios(val)
	            mPaisEstudiosPrevios = val      
	  end property
	  
	  public property get Extranjero()
	            Extranjero = mExtranjero      
	  end property
      public property let Extranjero(val)
	            mExtranjero = val      
	  end property
	  
	  public property get NumPasaporte()
	            NumPasaporte = mNumPasaporte      
	  end property
      public property let NumPasaporte(val)
	            mNumPasaporte = val      
	  end property
	  
	  public property get Nacionalidad()
	            Nacionalidad = mNacionalidad      
	  end property
      public property let Nacionalidad(val)
	            mNacionalidad = val      
	  end property
	  
	  public property get TipoEstudiante()
	            TipoEstudiante = mTipoEstudiante      
	  end property
      public property let TipoEstudiante(val)
	            mTipoEstudiante = val      
	  end property
	  
	  public property get TipoResidencia()
	            TipoResidencia = mTipoResidencia      
	  end property
      public property let TipoResidencia(val)
	            mTipoResidencia = val      
	  end property
	  
	  public property get PerfilNotaEm()
	            PerfilNotaEm = mPerfilNotaEm      
	  end property
      public property let PerfilNotaEm(val)
	            mPerfilNotaEm = val      
	  end property
	  
	  public property get NRbdAnioEgreso()
	            NRbdAnioEgreso = mNRbdAnioEgreso      
	  end property
      public property let NRbdAnioEgreso(val)
	            mNRbdAnioEgreso = val      
	  end property
	  
	  public property get NRbd()
	            NRbd = mNRbd      
	  end property
      public property let NRbd(val)
	            mNRbd = val      
	  end property
	  
	  public property get NRbdNem()
	            NRbdNem = mNRbdNem      
	  end property
      public property let NRbdNem(val)
	            mNRbdNem = val      
	  end property
	  
	  public property get NRbdCodDependencia()
	            NRbdCodDependencia = mNRbdCodDependencia      
	  end property
      public property let NRbdCodDependencia(val)
	            mNRbdCodDependencia = val      
	  end property
	  
	  public property get NRbdRegion()
	            NRbdRegion = mNRbdRegion      
	  end property
      public property let NRbdRegion(val)
	            mNRbdRegion = val      
	  end property

	  public property get NRbdCodEstablecimiento()
	            NRbdCodEstablecimiento = mNRbdCodEstablecimiento      
	  end property
      public property let NRbdCodEstablecimiento(val)
	            mNRbdCodEstablecimiento = val      
	  end property
	  
	  public property get NRbdTipoEstablecimiento()
	            NRbdTipoEstablecimiento = mNRbdTipoEstablecimiento      
	  end property
      public property let NRbdTipoEstablecimiento(val)
	            mNRbdTipoEstablecimiento = val      
	  end property
	  
	  public property get NRbdClasEstablecimiento()
	            NRbdClasEstablecimiento = mNRbdClasEstablecimiento      
	  end property
      public property let NRbdClasEstablecimiento(val)
	            mNRbdClasEstablecimiento = val      
	  end property
	  
	  public property get RPsu()
	            RPsu = mRPsu      
	  end property
      public property let RPsu(val)
	            mRPsu = val      
	  end property
	  
	  public property get RPsuAnioEgreso()
	            RPsuAnioEgreso = mRPsuAnioEgreso      
	  end property
      public property let RPsuAnioEgreso(val)
	            mRPsuAnioEgreso = val      
	  end property
	  
	  public property get RPsuRbd()
	            RPsuRbd = mRPsuRbd      
	  end property
      public property let RPsuRbd(val)
	            mRPsuRbd = val      
	  end property
	  
	  public property get RPsuCodDependencia()
	            RPsuCodDependencia = mRPsuCodDependencia      
	  end property
      public property let RPsuCodDependencia(val)
	            mRPsuCodDependencia = val      
	  end property
	  
	  public property get RPsuRegion()
	            RPsuRegion = mRPsuRegion      
	  end property
      public property let RPsuRegion(val)
	            mRPsuRegion = val      
	  end property
	  
	  public property get RPsuNem()
	            RPsuNem = mRPsuNem      
	  end property
      public property let RPsuNem(val)
	            mRPsuNem = val      
	  end property
	  
	  public property get RPsuTramo50()
	            RPsuTramo50 = mRPsuTramo50      
	  end property
      public property let RPsuTramo50(val)
	            mRPsuTramo50 = val      
	  end property
	  
	  public property get RPsuTramo502()
	            RPsuTramo502 = mRPsuTramo502      
	  end property
      public property let RPsuTramo502(val)
	            mRPsuTramo502 = val      
	  end property
	  
	  public property get RPsuTramo100()
	            RPsuTramo100 = mRPsuTramo100      
	  end property
      public property let RPsuTramo100(val)
	            mRPsuTramo100 = val      
	  end property
	  
	  public property get RPsuTramo600700720()
	            RPsuTramo600700720 = mRPsuTramo600700720      
	  end property
      public property let RPsuTramo600700720(val)
	            mRPsuTramo600700720 = val      
	  end property
	  
	  public property get RPsuTramo475por50()
	            RPsuTramo475por50 = mRPsuTramo475por50      
	  end property
      public property let RPsuTramo475por50(val)
	            mRPsuTramo475por50 = val      
	  end property
	  
	  public property get BBeca()
	            BBeca = mBBeca      
	  end property
      public property let BBeca(val)
	            mBBeca = val      
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
      
      'exteded properties - names from related tables -read/write, but not saved in DB
      
      public property get metadata()
          metadata = mMetadata
      end property


      end class 'Postulante


      '======================
class ExcelDetalleMatriculadosHelper

      Dim selectSQL

      private sub Class_Initialize()
          selectSQL =   " select distinct a.mat_cat_periodo as Anio, a.MAT_CODIGO_UNICO as CodigoUnico, "&_
						" a.MAT_CODIGO_UNICO_PROCESO as CodigoUnicoProceso, a.MAT_CODIGO_RC as CodigoRC, "&_
						" tt.CARR_NOMB_SEDE as Sede, tt.CARR_NOMB_CARRERA as Carrera, tt.CARR_JORNADA as Jornada, "&_
						" a.MAT_RUT,A.MAT_DV,CAST(CAST(a.MAT_RUT AS NUMERIC(10,0)) AS VARCHAR) +'-'+ a.MAT_DV as Rut, "&_
						" a.MAT_NOMBRES as Nombre, a.MAT_APE_PATERNO as Paterno, a.MAT_APE_MATERNO as Materno, a.MAT_SEXO as Sexo, a.MAT_FECHA_NACIMIENTO as FechaNac, "&_
						" a.MAT_EDAD as Edad, a.MAT_EDAD_entero as EdadEntero, a.MAT_RANGO_EDAD as RangoEdad, a.MAT_COD_ESTADO_CIVIL as CodEstadoCivil, "&_
						" a.MAT_FECHA_MATRIMONIO as FechaMatrimonio, a.MAT_FECHA_DEFUNCION as FechaDefuncion, a.MAT_ANO_ING_PRI_ANO  as AnoIngPriAno, "&_
						" a.MAT_SEM_ING_PRI_ANO as SemIngPriAno, a.MAT_ANO_ING_CARRERA as AnoIngCarrera, a.MAT_SEM_ING_CARRERA as SemIngCarrera, a.MAT_PAIS_ESTUDIOS_PREVIOS as PaisEstudiosPrevios, "&_
						" a.MAT_EXTRANJERO as Extranjero, a.MAT_NUM_PASAPORTE as NumPasaporte, a.MAT_NACIONALIDAD as Nacionalidad, a.MAT_TIPO_ESTUDIANTE as TipoEstudiante, "&_
						" a.MAT_TIPO_RESIDENCIA as TipoResidencia, a.MAT_PERFIL_NOTA_EM as PerfilNotaEm, a.MAT_N_RBD_ANIO_EGRESO as NRbdAnioEgreso, a.MAT_N_RBD as NRbd, "&_
						" a.MAT_N_RBD_NEM as NRbdNem, a.MAT_N_RBD_COD_DEPENDENCIA as NRbdCodDependencia, a.MAT_N_RBD_REGION as NRbdRegion, "&_
						" a.MAT_N_RBD_COD_ESTABLECIMIENTO as NRbdCodEstablecimiento, a.MAT_N_RBD_TIPO_ESTABLECIMIENTO as NRbdTipoEstablecimiento, "&_
						" a.MAT_N_RBD_CLAS_ESTABLECIMIENTO as NRbdClasEstablecimiento, a.MAT_R_PSU as RPsu, a.MAT_R_PSU_ANIO_EGRESO as RPsuAnioEgreso, "&_
						" a.MAT_R_PSU_RBD as RPsuRbd, a.MAT_R_PSU_COD_DEPENDENCIA as RPsuCodDependencia, a.MAT_R_PSU_REGION as RPsuRegion, a.MAT_R_PSU_NEM as RPsuNem, "&_
						" a.mat_r_psu_tramo_50 as RPsuTramo50, a.MAT_R_PSU_TRAMO_50_2 as RPsuTramo502, a.MAT_R_PSU_TRAMO_100 as RPsuTramo100, "&_
						" a.MAT_R_PSU_TRAMO_600_700_720 as RPsuTramo600700720, a.MAT_R_PSU_TRAMO_475_POR_50 as RPsuTramo475por50, a.MAT_B_BECA as BBeca "&_
						" from SAIUPA..ani_matriculados a, SAIUPA..ani_carreras tt "&_
						" where tt.carr_codigo_unico_proceso=a.mat_codigo_unico_proceso and carr_nivel_global = 'PREGRADO'  "    + _
						" and isnull(CAST(CAST(a.MAT_RUT AS NUMERIC(10,0)) AS VARCHAR) +'-'+ a.MAT_DV,'') <> '' " + _
					    " "
	  end sub

      private sub Class_Terminate()
      end sub

      '=============================
      'public Functions

      ' Select all Postulante into a Dictionary
      ' return a Dictionary of ExcelDetalleMatriculados objects - if successful, Nothing otherwise
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
                    results.Add cstr(obj.Anio)+ obj.Sede + obj.Carrera + obj.Jornada + obj.Rut + cstr(obj.AnoIngPriAno), obj
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
          objCommand.CommandText = selectSQL + " and a.mat_cat_periodo like '%" + value + "%' "       
          objCommand.CommandType = adCmdText
          set records = objCommand.Execute
          if records.eof then
               Set Search = Nothing
          else
               Dim results, obj, record
               Set results = Server.CreateObject("Scripting.Dictionary")
               while not records.eof
                    set obj = PopulateObjectFromRecord(records)
                    results.Add cstr(obj.Anio)+ obj.Sede + obj.Carrera + obj.Jornada + obj.Rut + cstr(obj.AnoIngPriAno), obj
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
            set obj = new ExcelDetalleMatriculados
           
		      obj.Anio		 			= record("Anio")
			  obj.CodigoUnico			= record("CodigoUnico")
	          obj.CodigoUnicoProceso	= record("CodigoUnicoProceso")
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
			  obj.PaisEstudiosPrevios	= record("PaisEstudiosPrevios")
			  obj.Extranjero		 	= record("Extranjero")
			  obj.NumPasaporte		 	= record("NumPasaporte")
			  obj.Nacionalidad		 	= record("Nacionalidad")
			  obj.TipoEstudiante		= record("TipoEstudiante")
			  obj.TipoResidencia		= record("TipoResidencia")
			  obj.PerfilNotaEm		 	= record("PerfilNotaEm")
			  obj.NRbdAnioEgreso		= record("NRbdAnioEgreso")
			  obj.NRbd		 			= record("NRbd")
			  obj.NRbdNem		 		= record("NRbdNem")
			  obj.NRbdCodDependencia	= record("NRbdCodDependencia")
			  obj.NRbdRegion		 	= record("NRbdRegion")
			  obj.NRbdCodEstablecimiento  = record("NRbdCodEstablecimiento")
			  obj.NRbdTipoEstablecimiento = record("NRbdTipoEstablecimiento")
			  obj.NRbdClasEstablecimiento = record("NRbdClasEstablecimiento")
			  obj.RPsu		 			= record("RPsu")
			  obj.RPsuAnioEgreso		= record("RPsuAnioEgreso")
			  obj.RPsuRbd		 		= record("RPsuRbd")
			  obj.RPsuCodDependencia	= record("RPsuCodDependencia")
			  obj.RPsuRegion		 	= record("RPsuRegion")
			  obj.RPsuNem		 		= record("RPsuNem")
			  obj.RPsuTramo50		 	= record("RPsuTramo50")
			  obj.RPsuTramo502		 	= record("RPsuTramo502")
			  obj.RPsuTramo100		 	= record("RPsuTramo100")
			  obj.RPsuTramo600700720	= record("RPsuTramo600700720")
			  obj.RPsuTramo475por50		= record("RPsuTramo475por50")
			  obj.BBeca		 			= record("BBeca")
			  obj.Sede 		 			= record("Sede")
			  obj.Carrera    			= record("Carrera")
			  obj.Jornada    			= record("Jornada")
			  obj.Rut        			= record("Rut")
			  obj.Nombre     			= record("Nombre")
			  obj.Paterno    			= record("Paterno")
			  obj.Materno    			= record("Materno")
			  obj.Sexo       			= record("Sexo")
			  obj.FechaNac   			= record("FechaNac")

              set PopulateObjectFromRecord = obj
      end if
    end function

end class 'PostulanteHelper
%>
    