
      <%

      '
      ' This files defines the DocentePromRenta model
      '
class DocentePromRenta

      private mMetadata

      '=============================
      'Private properties
        private  mCabecera
        private  m2009
        private  m2010
		private  m2011
        private  m2012
        private  m2013

      private sub Class_Initialize()
          mMetadata = Array("Cabecera", "2011")
      end sub

      private sub Class_Terminate()
      end sub

      '=============================
      'public properties

      public property get Cabecera()
          Cabecera = mCabecera
      end property

      public property let Cabecera(val)
          mCabecera = val
      end property
      
      public property get a2009()
          a2009 = m2009
      end property

      public property let a2009(val)
          m2009 = val
      end property
      
      public property get a2010()
          a2010 = m2010
      end property

      public property let a2010(val)
          m2010 = val
      end property
	  
	  public property get a2011()
          a2011 = m2011
      end property

      public property let a2011(val)
          m2011 = val
      end property
      
      public property get a2012()
          a2012 = m2012
      end property

      public property let a2012(val)
          m2012 = val
      end property
      
      public property get a2013()
          a2013 = m2013
      end property

      public property let a2013(val)
          m2013 = val
      end property
      
      'exteded properties - names from related tables -read/write, but not saved in DB
      
      public property get metadata()
          metadata = mMetadata
      end property


      end class 'DocentePromRenta


      '======================
class DocentePromRentaHelper

      Dim selectSQL
	  Dim sqlTotal
	  Dim selectSQLHoras
	  Dim sqlTotalHoras

      private sub Class_Initialize()
	  
	  if session("_pers_ncorr_") = "" then
		  	filtroCarrera = ""
		  else
		    filtroCarrera = " where exists (select 1 from asg_docentes_carreras tt " + _
                            "               where tt.anos_ccod=a.anos_ccod and tt.prof_rut=a.prof_rut " + _
                            "               and tt.carr_ccod in (select carr_ccod from SGA_CARRERAS_USUARIO where cast(pers_ncorr as varchar)='"&session("_pers_ncorr_")&"')) "
		  end if
		  
          selectSQL = " select [tr].Cabecera,[tr].a2009,[tr].a2010,[tr].a2011,[tr].a2012,[tr].a2013 "     + _
					  " From "     + _
					  "	(     "     + _
					  "		select 'Promedio Renta en UF'  as Cabecera,isnull([2009],0) as a2009,isnull([2010],0) as a2010,isnull([2011],0) as a2011,isnull([2012],0) as a2012,isnull([2013],0) as a2013  "     + _
					  "		from   "     + _
					  "		 (   "     + _
					  "			select anos_ccod,prom_renta_uf from [ASG_PROMEDIO_RENTA_DOCENTE]  a  "+ filtroCarrera   + _
					  "		 )p   "     + _
					  "		 PIVOT   "     + _
					  "		 (   "     + _
					  "		  AVG(prom_renta_uf)  "     + _
					  "		  FOR anos_ccod in ([2009],[2010],[2011],[2012],[2013]) "     + _
					  "		 ) AS pvt   "     + _
					  "	) tr " + _
					  " "
		  
	      sqlTotal =  " select 'TOTALES' as Cabecera,[tr].a2009,[tr].a2010,[tr].a2011,[tr].a2012,[tr].a2013 "     + _
					  " From "     + _
					  "	(     "     + _
					  "		select [2009] as a2009,[2010] as a2010,[2011] as a2011,[2012] as a2012,[2013] as a2013  "     + _
					  "		from   "     + _
					  "		 (   "     + _
					  "			select anos_ccod,prom_renta_uf from [ASG_PROMEDIO_RENTA_DOCENTE]  a  "+ filtroCarrera  + _
					  "		 )p   "     + _
					  "		 PIVOT   "     + _
					  "		 (   "     + _
					  "		  AVG(prom_renta_uf)  "     + _
					  "		  FOR anos_ccod in ([2009],[2010],[2011],[2012],[2013]) "     + _
					  "		 ) AS pvt   "     + _
					  "	) tr " + _
					  " "
		   
     selectSQLHoras = " select [tr].Cabecera,[tr].a2009,[tr].a2010,[tr].a2011,[tr].a2012,[tr].a2013 "     + _
					  " From "     + _
					  "	(     "     + _
					  "		select 'Valor Hora x UF' as Cabecera,isnull([2009],0) as a2009,isnull([2010],0) as a2010,isnull([2011],0) as a2011,isnull([2012],0) as a2012,isnull([2013],0) as a2013  "     + _
					  "		from   "     + _
					  "		 (   "     + _
					  "			select anos_ccod,isnull(PROM_HORAS,0) as prom_horas_uf from [ASG_HORAS_RENTA_DOCENTE]  a  "+ filtroCarrera   + _
					  "		 )p   "     + _
					  "		 PIVOT   "     + _
					  "		 (   "     + _
					  "		  AVG(prom_horas_uf)  "     + _
					  "		  FOR anos_ccod in ([2009],[2010],[2011],[2012],[2013]) "     + _
					  "		 ) AS pvt   "     + _
					  "	) tr " + _
					  " "
		  
     sqlTotalHoras =  " select 'TOTALES' as Cabecera,[tr].a2009,[tr].a2010,[tr].a2011,[tr].a2012,[tr].a2013 "     + _
					  " From "     + _
					  "	(     "     + _
					  "		select [2009] as a2009,[2010] as a2010,[2011] as a2011,[2012] as a2012,[2013] as a2013  "     + _
					  "		from   "     + _
					  "		 (   "     + _
					  "			select anos_ccod,isnull(PROM_HORAS,0) as prom_horas_uf from [ASG_HORAS_RENTA_DOCENTE]  a  "+ filtroCarrera   + _
					  "		 )p   "     + _
					  "		 PIVOT   "     + _
					  "		 (   "     + _
					  "		  AVG(prom_horas_uf)  "     + _
					  "		  FOR anos_ccod in ([2009],[2010],[2011],[2012],[2013]) "     + _
					  "		 ) AS pvt   "     + _
					  "	) tr " + _
					  " "			  
	  end sub

      private sub Class_Terminate()
      end sub

      '=============================
      'public Functions

      ' Select all DocentePromRenta into a Dictionary
      ' return a Dictionary of DocentePromRenta objects - if successful, Nothing otherwise
      public function SelectAll()
          Dim records
          set objCommand=Server.CreateObject("ADODB.command")
          objCommand.ActiveConnection=DbOpenConnection()
          objCommand.NamedParameters = False
          objCommand.CommandText = selectSQL + " order by cabecera asc"
          objCommand.CommandType = adCmdText
          set records = objCommand.Execute
          if records.eof then
               Set SelectAll = Nothing
          else
               Dim results, obj, record
               Set results = Server.CreateObject("Scripting.Dictionary")
               while not records.eof
                    set obj = PopulateObjectFromRecord(records)
                    results.Add obj.Cabecera, obj
                    records.movenext
               wend
               set SelectAll = results
               records.Close
          End If
          set records = nothing
      end function
	  
	  public function SelectTotal()
          Dim records
          set objCommand=Server.CreateObject("ADODB.command")
          objCommand.ActiveConnection=DbOpenConnection()
          objCommand.NamedParameters = False
          objCommand.CommandText = sqlTotal
          objCommand.CommandType = adCmdText
          set records = objCommand.Execute
          if records.eof then
               Set SelectTotal = Nothing
          else
               Dim results, obj, record
               Set results = Server.CreateObject("Scripting.Dictionary")
               while not records.eof
                    set obj = PopulateObjectFromRecord(records)
                    results.Add obj.Cabecera, obj
                    records.movenext
               wend
               set SelectTotal = results
               records.Close
          End If
          set records = nothing
      end function
	  
	  public function SelectAllHoras()
          Dim records
          set objCommand=Server.CreateObject("ADODB.command")
          objCommand.ActiveConnection=DbOpenConnection()
          objCommand.NamedParameters = False
          objCommand.CommandText = selectSQLHoras
          objCommand.CommandType = adCmdText
          set records = objCommand.Execute
          if records.eof then
               Set SelectAllHoras = Nothing
          else
               Dim results, obj, record
               Set results = Server.CreateObject("Scripting.Dictionary")
               while not records.eof
                    set obj = PopulateObjectFromRecord(records)
                    results.Add obj.Cabecera, obj
                    records.movenext
               wend
               set SelectAllHoras = results
               records.Close
          End If
          set records = nothing
      end function
	  
	  public function SelectTotalHoras()
          Dim records
          set objCommand=Server.CreateObject("ADODB.command")
          objCommand.ActiveConnection=DbOpenConnection()
          objCommand.NamedParameters = False
          objCommand.CommandText = sqlTotalHoras
          objCommand.CommandType = adCmdText
          set records = objCommand.Execute
          if records.eof then
               Set SelectTotalHoras = Nothing
          else
               Dim results, obj, record
               Set results = Server.CreateObject("Scripting.Dictionary")
               while not records.eof
                    set obj = PopulateObjectFromRecord(records)
                    results.Add obj.Cabecera, obj
                    records.movenext
               wend
               set SelectTotalHoras = results
               records.Close
          End If
          set records = nothing
      end function
	  
      ' return a Dictionary of DocentePromRenta objects - if successful, Nothing otherwise
      public function Search(value)
          Dim records
          set objCommand=Server.CreateObject("ADODB.command")
          objCommand.ActiveConnection=DbOpenConnection()
          objCommand.NamedParameters = False
          objCommand.CommandText = selectSQL + _
          " where (1=2) "  + " or ([tr].Cabecera like '%" + value + "%') "       
          objCommand.CommandType = adCmdText
          set records = objCommand.Execute
          if records.eof then
               Set Search = Nothing
          else
               Dim results, obj, record
               Set results = Server.CreateObject("Scripting.Dictionary")
               while not records.eof
                    set obj = PopulateObjectFromRecord(records)
                    results.Add obj.Cabecera, obj
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
            set obj = new DocentePromRenta
              obj.Cabecera = record("Cabecera")
              obj.a2009 = record("a2009")
              obj.a2010 = record("a2010")
			  obj.a2011 = record("a2011")
              obj.a2012 = record("a2012")
              obj.a2013 = record("a2013")
            set PopulateObjectFromRecord = obj
      end if
    end function

end class 'DocentePromRentaHelper
%>
    