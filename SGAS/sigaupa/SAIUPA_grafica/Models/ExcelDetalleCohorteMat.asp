
      <%

      '
      ' This files defines the ExcelDetalleCohorteMat model
      '
class ExcelDetalleCohorteMat

      private mMetadata

      '=============================
      'Private properties
      private  mAnio
      private  mCodigoUnico	
      private  mCodigoUnicoProceso	
      private  mCodigoRC	
      private  mSedeTdesc	
      private  mCarrTdesc	
      private  mFacuTdesc	
      private  mJornTdesc
      private  mCarrDuracion	
      private  mRUT	
      private  mApePaterno	
      private  mApeMaterno
      private  mNombres	
      private  mAnio1
      private  mDetalleAnio1
      private  mAnio2	
      private  mDetalleAnio2	
      private  mAnio3	
      private  mDetalleAnio3	
      private  mAnio4	
      private  mDetalleAnio4	
      private  mAnio5	
      private  mDetalleAnio5	
      private  mAnio6	
      private  mDetalleAnio6	
      private  mAnio7	
      private  mDetalleAnio7	
      private  mAnio8	
      private  mDetalleAnio8	
      private  mAnio9	
      private  mDetalleAnio9	
      private  mAnio10	
      private  mDetalleAnio10	
      private  mAnio11	
      private  mDetalleAnio11	
      private  mAnio12	
      private  mDetalleAnio12	
      private  mAnio13	
      private  mDetalleAnio13

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
	  
      	
	  public property get SedeTdesc()
          SedeTdesc = mSedeTdesc
      end property
      public property let SedeTdesc(val)
          mSedeTdesc = val
      end property
	  
      	
	  public property get CarrTdesc()
          CarrTdesc = mCarrTdesc
      end property
      public property let CarrTdesc(val)
          mCarrTdesc = val
      end property
	  
      	
	  public property get FacuTdesc()
          FacuTdesc = mFacuTdesc
      end property
      public property let FacuTdesc(val)
          mFacuTdesc = val
      end property
	  
      
	  public property get JornTdesc()
          JornTdesc = mJornTdesc
      end property
      public property let JornTdesc(val)
          mJornTdesc = val
      end property
	  
      	
	  public property get CarrDuracion()
          CarrDuracion = mCarrDuracion
      end property
      public property let CarrDuracion(val)
          mCarrDuracion = val
      end property
	  
      	
	  public property get RUT()
          RUT = mRUT
      end property
      public property let RUT(val)
          mRUT = val
      end property
	  
      	
	  public property get ApePaterno()
          ApePaterno = mApePaterno
      end property
      public property let ApePaterno(val)
          mApePaterno = val
      end property
	  
      
	  public property get ApeMaterno()
          ApeMaterno = mApeMaterno
      end property
      public property let ApeMaterno(val)
          mApeMaterno = val
      end property
	  
      	
	  public property get Nombres()
          Nombres = mNombres
      end property
      public property let Nombres(val)
          mNombres = val
      end property
	  
      
	  public property get Anio1()
          Anio1 = mAnio1
      end property
      public property let Anio1(val)
          mAnio1 = val
      end property
	  
      
	  public property get DetalleAnio1()
          DetalleAnio1 = mDetalleAnio1
      end property
      public property let DetalleAnio1(val)
          mDetalleAnio1 = val
      end property
	  
      	
	  public property get Anio2()
          Anio2 = mAnio2
      end property
      public property let Anio2(val)
          mAnio2 = val
      end property
	  
      	
	  public property get DetalleAnio2()
          DetalleAnio2 = mDetalleAnio2
      end property
      public property let DetalleAnio2(val)
          mDetalleAnio2 = val
      end property
	  
      	
	  public property get Anio3()
          Anio3 = mAnio3
      end property
      public property let Anio3(val)
          mAnio3 = val
      end property
	  
      	
	  public property get DetalleAnio3()
          DetalleAnio3 = mDetalleAnio3
      end property
      public property let DetalleAnio3(val)
          mDetalleAnio3 = val
      end property
	  
      	
	  public property get Anio4()
          Anio4 = mAnio4
      end property
      public property let Anio4(val)
          mAnio4 = val
      end property
	  
      	
	  public property get DetalleAnio4()
          DetalleAnio4 = mDetalleAnio4
      end property
      public property let DetalleAnio4(val)
          mDetalleAnio4 = val
      end property
	  
      	
	  public property get Anio5()
          Anio5 = mAnio5
      end property
      public property let Anio5(val)
          mAnio5 = val
      end property
	  
      	
	  public property get DetalleAnio5()
          DetalleAnio5 = mDetalleAnio5
      end property
      public property let DetalleAnio5(val)
          mDetalleAnio5 = val
      end property
	  
      	
	  public property get Anio6()
          Anio6 = mAnio6
      end property
      public property let Anio6(val)
          mAnio6 = val
      end property
	  
      	
	  public property get DetalleAnio6()
          DetalleAnio6 = mDetalleAnio6
      end property
      public property let DetalleAnio6(val)
          mDetalleAnio6 = val
      end property
	  
      	
	  public property get Anio7()
          Anio7 = mAnio7
      end property
      public property let Anio7(val)
          mAnio7 = val
      end property
	  
      	
	  public property get DetalleAnio7()
          DetalleAnio7 = mDetalleAnio7
      end property
      public property let DetalleAnio7(val)
          mDetalleAnio7 = val
      end property
	  
      	
	  public property get Anio8()
          Anio8 = mAnio8
      end property
      public property let Anio8(val)
          mAnio8 = val
      end property
	  
      	
	  public property get DetalleAnio8()
          DetalleAnio8 = mDetalleAnio8
      end property
      public property let DetalleAnio8(val)
          mDetalleAnio8 = val
      end property
	  
      	
	  public property get Anio9()
          Anio9 = mAnio9
      end property
      public property let Anio9(val)
          mAnio9 = val
      end property
	  
      	
	  public property get DetalleAnio9()
          DetalleAnio9 = mDetalleAnio9
      end property
      public property let DetalleAnio9(val)
          mDetalleAnio9 = val
      end property
	  
      	
	  public property get Anio10()
          Anio10 = mAnio10
      end property
      public property let Anio10(val)
          mAnio10 = val
      end property
	  
      	
	  public property get DetalleAnio10()
          DetalleAnio10 = mDetalleAnio10
      end property
      public property let DetalleAnio10(val)
          mDetalleAnio10 = val
      end property
	  
      	
	  public property get Anio11()
          Anio11 = mAnio11
      end property
      public property let Anio11(val)
          mAnio11 = val
      end property
	  
      	
	  public property get DetalleAnio11()
          DetalleAnio11 = mDetalleAnio11
      end property
      public property let DetalleAnio11(val)
          mDetalleAnio11 = val
      end property
	  
      	
	  public property get Anio12()
          Anio12 = mAnio12
      end property
      public property let Anio12(val)
          mAnio12 = val
      end property
	  
      	
	  public property get DetalleAnio12()
          DetalleAnio12 = mDetalleAnio12
      end property
      public property let DetalleAnio12(val)
          mDetalleAnio12 = val
      end property
	  
      	
	  public property get Anio13()
          Anio13 = mAnio13
      end property
      public property let Anio13(val)
          mAnio13 = val
      end property
	  
      
	  public property get DetalleAnio13()
          DetalleAnio13 = mDetalleAnio13
      end property
      public property let DetalleAnio13(val)
          mDetalleAnio13 = val
      end property
	  
	  
      'exteded properties - names from related tables -read/write, but not saved in DB
      
      public property get metadata()
          metadata = mMetadata
      end property


      end class 'Postulante


      '======================
class ExcelDetalleCohorteMatHelper

      Dim selectSQL

      private sub Class_Initialize()
          selectSQL = " select ANIO as Anio,CODIGOUNICO	as CodigoUnico,CODIGOUNICOPROCESO	as CodigoUnicoProceso,CODIGORC as CodigoRC,SEDE_TDESC	as SedeTdesc,  "    + _
					  "	CARR_TDESC	as CarrTdesc,FACU_TDESC	as FacuTdesc,JORN_TDESC	as JornTdesc,CARR_DURACION as CarrDuracion,  "    + _
					  "	CAST(CAST(MAT_RUT AS NUMERIC(10,0)) AS VARCHAR) +'-'+ isnull(MAT_DV,'')	as Rut,APEPATERNO	as ApePaterno,APEMATERNO	as ApeMaterno,NOMBRES	as Nombres,  "    + _
					  "	ANIO_1	as Anio1,DETALLE_ANIO_1	as DetalleAnio1,ANIO_2	as Anio2,DETALLE_ANIO_2	as DetalleAnio2,ANIO_3	as Anio3,DETALLE_ANIO_3	as DetalleAnio3,  "    + _
					  "	ANIO_4	as Anio4,DETALLE_ANIO_4	as DetalleAnio4,ANIO_5	as Anio5,DETALLE_ANIO_5	as DetalleAnio5,ANIO_6	as Anio6,DETALLE_ANIO_6	as DetalleAnio6,  "    + _
					  "	ANIO_7	as Anio7,DETALLE_ANIO_7 as DetalleAnio7,ANIO_8	as Anio8,DETALLE_ANIO_8	as DetalleAnio8,ANIO_9	as Anio9,DETALLE_ANIO_9	as DetalleAnio9,  "    + _
					  "	ANIO_10	as Anio10,DETALLE_ANIO_10 as DetalleAnio10,ANIO_11 as Anio11,DETALLE_ANIO_11 as DetalleAnio11,ANIO_12 as Anio12,DETALLE_ANIO_12	as DetalleAnio12,  "    + _
					  "	ANIO_13	as Anio13,DETALLE_ANIO_13 as DetalleAnio13  "    + _
					  "	from saiupa..ANI_MATR_COHORTE_DETALLE a  "    + _
					  " "
	  end sub

      private sub Class_Terminate()
      end sub

      '=============================
      'public Functions

      ' Select all Postulante into a Dictionary
      ' return a Dictionary of ExcelDetalleCohorteMat objects - if successful, Nothing otherwise
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
                    results.Add cstr(obj.Anio)+ obj.Rut + obj.CodigoUnicoProceso, obj
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
          " where a.Anio in (" + value + ") "       
          objCommand.CommandType = adCmdText
          set records = objCommand.Execute
          if records.eof then
               Set Search = Nothing
          else
               Dim results, obj, record
               Set results = Server.CreateObject("Scripting.Dictionary")
               while not records.eof
                    set obj = PopulateObjectFromRecord(records)
                    results.Add cstr(obj.Anio) + obj.Rut + obj.CodigoUnicoProceso, obj
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
            set obj = new ExcelDetalleCohorteMat
           
		      obj.Anio		          = record("Anio")
		      obj.CodigoUnico		  = record("CodigoUnico")	
		      obj.CodigoUnicoProceso  = record("CodigoUnicoProceso")	
		      obj.CodigoRC		      = record("CodigoRC")	
		      obj.SedeTdesc		      = record("SedeTdesc")	
		      obj.CarrTdesc		      = record("CarrTdesc")	
		      obj.FacuTdesc		      = record("FacuTdesc")	
		      obj.JornTdesc		      = record("JornTdesc")
		      obj.CarrDuracion		  = record("CarrDuracion")	
		      obj.RUT		          = record("RUT")	
		      obj.ApePaterno		  = record("ApePaterno")	
		      obj.ApeMaterno		  = record("ApeMaterno")
		      obj.Nombres		      = record("Nombres")	
		      obj.Anio1		          = record("Anio1")
		      obj.DetalleAnio1		  = record("DetalleAnio1")
		      obj.Anio2			      = record("Anio2")
		      obj.DetalleAnio2		  = record("DetalleAnio2")	
		      obj.Anio3		          = record("Anio3")	
		      obj.DetalleAnio3		  = record("DetalleAnio3")	
		      obj.Anio4		          = record("Anio4")	
		      obj.DetalleAnio4		  = record("DetalleAnio4")	
		      obj.Anio5		          = record("Anio5")	
		      obj.DetalleAnio5		  = record("DetalleAnio5")	
		      obj.Anio6		          = record("Anio6")	
		      obj.DetalleAnio6		  = record("DetalleAnio6")	
		      obj.Anio7		          = record("Anio7")	
		      obj.DetalleAnio7		  = record("DetalleAnio7")	
		      obj.Anio8		          = record("Anio8")	
		      obj.DetalleAnio8		  = record("DetalleAnio8")	
		      obj.Anio9		          = record("Anio9")	
		      obj.DetalleAnio9		  = record("DetalleAnio9")	
		      obj.Anio10		      = record("Anio10")	
		      obj.DetalleAnio10		  = record("DetalleAnio10")	
		      obj.Anio11		      = record("Anio11")	
		      obj.DetalleAnio11		  = record("DetalleAnio11")	
		      obj.Anio12		      = record("Anio12")	
		      obj.DetalleAnio12		  = record("DetalleAnio12")	
		      obj.Anio13		      = record("Anio13")	
		      obj.DetalleAnio13		  = record("DetalleAnio13")
             
              set PopulateObjectFromRecord = obj
      end if
    end function

end class 'PostulanteHelper
%>
    