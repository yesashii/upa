
      <%

      '
      ' This files defines the ExcelDetalleProfesores model
      '
class ExcelDetalleProfesores

      private mMetadata

      '=============================
      'Private properties
      private  mAnio
      private  mRut	
      private  mApPaterno	
      private  mApMaterno
      private  mNombre
      private  mSexo
      private  mFechaNacimiento	 
      private  mNacionalidad	
      private  mAnoInst	
      private  mPUnidad
      private  mPRegion
      private  mSUnidad
      private  mSRegion
      private  mNivelAcad
      private  mTitulo
      private  mInstTitulo	
      private  mPaisTitulo	
      private  mFechaTitulo
      private  mAcadHorasCind	
      private  mAcadHorasCfij	
      private  mAcadHorasChon	
      private  mAcadHorasTotal	
      private  mFuncHorasCind	
      private  mFuncHorasCfij	
      private  mFuncHorasChon	
      private  mFuncHorasTotal	
      private  mTotalHoras	
      private  mCargo 

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
      
	  public property get Rut()
          Rut = mRut
      end property
      public property let Rut(val)
          mRut = val
      end property
	  	
	  public property get ApPaterno()
          ApPaterno = mApPaterno
      end property
      public property let ApPaterno(val)
          mApPaterno = val
      end property
	  	
      
	  public property get ApMaterno()
          ApMaterno = mApMaterno
      end property
      public property let ApMaterno(val)
          mApMaterno = val
      end property
	  
      public property get Nombre()
          Nombre = mNombre
      end property
      public property let Nombre(val)
          mNombre = val
      end property
	  
      
	  public property get Sexo()
          Sexo = mSexo
      end property
      public property let Sexo(val)
          mSexo = val
      end property
	  
      	 
	  public property get FechaNacimiento()
          FechaNacimiento = mFechaNacimiento
      end property
      public property let FechaNacimiento(val)
          mFechaNacimiento = val
      end property
	  
      	
	  public property get Nacionalidad()
          Nacionalidad = mNacionalidad
      end property
      public property let Nacionalidad(val)
          mNacionalidad = val
      end property
	  
      	
	  public property get AnoInst()
          AnoInst = mAnoInst
      end property
      public property let AnoInst(val)
          mAnoInst = val
      end property
	  
      
	  public property get PUnidad()
          PUnidad = mPUnidad
      end property
      public property let PUnidad(val)
          mPUnidad = val
      end property
	  
      
	  public property get PRegion()
          PRegion = mPRegion
      end property
      public property let PRegion(val)
          mPRegion = val
      end property
	  
      
	  public property get SUnidad()
          SUnidad = mSUnidad
      end property
      public property let SUnidad(val)
          mSUnidad = val
      end property
	  
      
	  public property get SRegion()
          SRegion = mSRegion
      end property
      public property let SRegion(val)
          mSRegion = val
      end property
	  
      
	  public property get NivelAcad()
          NivelAcad = mNivelAcad
      end property
      public property let NivelAcad(val)
          mNivelAcad = val
      end property
	  
      
	  public property get Titulo()
          Titulo = mTitulo
      end property
      public property let Titulo(val)
          mTitulo = val
      end property
	  
      	
	  public property get InstTitulo()
          InstTitulo = mInstTitulo
      end property
      public property let InstTitulo(val)
          mInstTitulo = val
      end property
	  
      	
	  public property get PaisTitulo()
          PaisTitulo = mPaisTitulo
      end property
      public property let PaisTitulo(val)
          mPaisTitulo = val
      end property
	  
      
	  public property get FechaTitulo()
          FechaTitulo = mFechaTitulo
      end property
      public property let FechaTitulo(val)
          mFechaTitulo = val
      end property
	  
      	
	  public property get AcadHorasCind()
          AcadHorasCind = mAcadHorasCind
      end property

      public property let AcadHorasCind(val)
          mAcadHorasCind = val
      end property
	  
      	
	  public property get AcadHorasCfij()
          AcadHorasCfij = mAcadHorasCfij
      end property
      public property let AcadHorasCfij(val)
          mAcadHorasCfij = val
      end property
	  
      
	  public property get AcadHorasChon()
          AcadHorasChon = mAcadHorasChon
      end property
      public property let AcadHorasChon(val)
          mAcadHorasChon = val
      end property
	  	
      	
	  public property get AcadHorasTotal()
          AcadHorasTotal = mAcadHorasTotal
      end property
      public property let AcadHorasTotal(val)
          mAcadHorasTotal = val
      end property
	  
      	
	  public property get FuncHorasCind()
          FuncHorasCind = mFuncHorasCind
      end property
      public property let FuncHorasCind(val)
          mFuncHorasCind = val
      end property
	  
      	
	  public property get FuncHorasCfij()
          FuncHorasCfij = mFuncHorasCfij
      end property
      public property let FuncHorasCfij(val)
          mFuncHorasCfij = val
      end property
	  
      
	  public property get FuncHorasChon()
          FuncHorasChon = mFuncHorasChon
      end property
      public property let FuncHorasChon(val)
          mFuncHorasChon = val
      end property
	  	
      	
	  public property get FuncHorasTotal()
          FuncHorasTotal = mFuncHorasTotal
      end property
      public property let FuncHorasTotal(val)
          mFuncHorasTotal = val
      end property
	  
      	
	  public property get TotalHoras()
          TotalHoras = mTotalHoras
      end property
      public property let TotalHoras(val)
          mTotalHoras = val
      end property
	  
       
	  public property get Cargo()
          Cargo = mCargo
      end property
      public property let Cargo(val)
          mCargo = val
      end property
	  
      
      'exteded properties - names from related tables -read/write, but not saved in DB
      
      public property get metadata()
          metadata = mMetadata
      end property


      end class 'Postulante


      '======================
class ExcelDetalleProfesoresHelper

      Dim selectSQL

      private sub Class_Initialize()
          selectSQL =   " select PROF_PERIODO as Anio,	 " + _
						"	CAST(CAST(prof_RUT AS NUMERIC(10,0)) AS VARCHAR) +'-'+ isnull(prof_DV,'') as Rut,	 " + _
						"	PROF_AP_PATERNO as ApPaterno,	 " + _
						"	PROF_AP_MATERNO	as ApMaterno, " + _
						"	PROF_NOMBRE	as Nombre, " + _
						"	PROF_SEXO	as Sexo, " + _
						"	PROF_FECHA_NACIMIENTO as FechaNacimiento, " + _
						"	PROF_NACIONALIDAD as Nacionalidad,	 " + _
						"	PROF_ANO_INST as AnoInst,	 " + _
						"	PROF_P_UNIDAD	as PUnidad, " + _
						"	PROF_P_REGION	as PRegion, " + _
						"	PROF_S_UNIDAD	as SUnidad, " + _
						"	PROF_S_REGION	as SRegion, " + _
						"	PROF_NIVEL_ACAD	as NivelAcad, " + _
						"	PROF_TITULO	as Titulo, " + _
						"	PROF_INST_TITULO as InstTitulo, " + _
						"	PROF_PAIS_TITULO as PaisTitulo,	 " + _
						"	PROF_FECHA_TITULO	as FechaTitulo, " + _
						"	PROF_ACAD_HORAS_CIND as AcadHorasCind,	 " + _
						"	PROF_ACAD_HORAS_CFIJ as AcadHorasCfij,	 " + _
						"	PROF_ACAD_HORAS_CHON as AcadHorasChon,	 " + _
						"	PROF_ACAD_HORAS_TOTAL as AcadHorasTotal,	 " + _
						"	PROF_FUNC_HORAS_CIND as FuncHorasCind,	 " + _
						"	PROF_FUNC_HORAS_CFIJ as FuncHorasCfij,	 " + _
						"	PROF_FUNC_HORAS_CHON as FuncHorasChon,	 " + _
						"	PROF_FUNC_HORAS_TOTAL as FuncHorasTotal,	 " + _
						"	PROF_TOTAL_HORAS  as TotalHoras, " + _	
						"	PROF_CARGO	  as Cargo  " + _
						"	from SAIUPA..ani_profesores  a " + _
						" "
	  end sub

      private sub Class_Terminate()
      end sub

      '=============================
      'public Functions

      ' Select all Postulante into a Dictionary
      ' return a Dictionary of ExcelDetalleProfesores objects - if successful, Nothing otherwise
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
                    results.Add cstr(obj.Anio) + obj.Rut, obj
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
          objCommand.CommandText = selectSQL + " where a.prof_periodo like '%" + value + "%' "       
          objCommand.CommandType = adCmdText
          set records = objCommand.Execute
          if records.eof then
               Set Search = Nothing
          else
               Dim results, obj, record
               Set results = Server.CreateObject("Scripting.Dictionary")
               while not records.eof
                    set obj = PopulateObjectFromRecord(records)
                    results.Add cstr(obj.Anio)+ obj.Rut, obj
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
            set obj = new ExcelDetalleProfesores
           
		      obj.Anio		 		= record("Anio")
		      obj.Rut		 		= record("Rut")	
		      obj.ApPaterno		 	= record("ApPaterno")	
		      obj.ApMaterno		 	= record("ApMaterno")
		      obj.Nombre		 	= record("Nombre")
		      obj.Sexo		 		= record("Sexo")
		      obj.FechaNacimiento	= record("FechaNacimiento")	 
		      obj.Nacionalidad		= record("Nacionalidad")	
		      obj.AnoInst		 	= record("AnoInst")	
		      obj.PUnidad		 	= record("PUnidad")
		      obj.PRegion		 	= record("PRegion")
		      obj.SUnidad		 	= record("SUnidad")
		      obj.SRegion		 	= record("SRegion")
		      obj.NivelAcad		 	= record("NivelAcad")
		      obj.Titulo		 	= record("Titulo")
		      obj.InstTitulo		= record("InstTitulo")	
		      obj.PaisTitulo		= record("PaisTitulo")	
		      obj.FechaTitulo		= record("FechaTitulo")
		      obj.AcadHorasCind		= record("AcadHorasCind")
		      obj.AcadHorasCfij		= record("AcadHorasCfij")	
		      obj.AcadHorasChon		= record("AcadHorasChon")
		      obj.AcadHorasTotal	= record("AcadHorasTotal")	
		      obj.FuncHorasCind		= record("FuncHorasCind")	
		      obj.FuncHorasCfij		= record("FuncHorasCfij")	
		      obj.FuncHorasChon		= record("FuncHorasChon")	
		      obj.FuncHorasTotal	= record("FuncHorasTotal")	
		      obj.TotalHoras		= record("TotalHoras")	
		      obj.Cargo		 		= record("Cargo") 

              set PopulateObjectFromRecord = obj
      end if
    end function

end class 'PostulanteHelper
%>
    