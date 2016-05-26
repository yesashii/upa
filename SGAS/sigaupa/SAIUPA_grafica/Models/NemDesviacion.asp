
      <%

      '
      ' This files defines the NemDesviacion model
      '
class NemDesviacion

      private mMetadata

      '=============================
      'Private properties
        private  mCabecera
        private  m2005
        private  m2006
        private  m2007
		private  m2008
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
      
      public property get a2005()
          a2005 = m2005
      end property

      public property let a2005(val)
          m2005 = val
      end property
      
      public property get a2006()
          a2006 = m2006
      end property

      public property let a2006(val)
          m2006 = val
      end property
      
      public property get a2007()
          a2007 = m2007
      end property

      public property let a2007(val)
          m2007 = val
      end property
	  
	  public property get a2008()
          a2008 = m2008
      end property

      public property let a2008(val)
          m2008 = val
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


      end class 'NemDesviacion


      '======================
class NemDesviacionHelper

      Dim selectSQL
	  Dim selectSQLFacultad
	  Dim selectSQLJornada
	  Dim selectSQLCarrera
	  Dim sqlTotalSede
	  Dim sqlTotalFacultad
	  Dim sqlTotalJornada
	  Dim sqlTotalCarrera
	  Dim filtroCarrera

      private sub Class_Initialize()
	  
	  if session("_pers_ncorr_") = "0" then
		  	filtroCarrera = ""
	  else
		    filtroCarrera = " and carr_tdesc collate Modern_Spanish_CI_AS in (select distinct CARR_NOMB_CARRERA from sga_carreras_usuario tt, ani_carreras t2 where tt.carr_ccod =t2.sga_carr_ccod collate Modern_Spanish_CI_AS and cast(pers_ncorr as varchar) = '"&session("_pers_ncorr_")&"') "
	  end if
	  
          selectSQL = " select [tr].Cabecera,[tr].a2005,[tr].a2006,[tr].a2007,[tr].a2008,[tr].a2009,[tr].a2010,[tr].a2011,[tr].a2012,[tr].a2013  " + _
					  "	From  " + _
					  "	(      " + _
					  "		select sede_tdesc as Cabecera, " + _
					  "			   isnull(cast([2005] as numeric(3,2)),0) as a2005,isnull(cast([2006] as numeric(3,2)),0) as a2006,isnull(cast([2007] as numeric(3,2)),0) as a2007, " + _
					  "			   isnull(cast([2008] as numeric(3,2)),0) as a2008,isnull(cast([2009] as numeric(3,2)),0) as a2009,isnull(cast([2010] as numeric(3,2)),0) as a2010, " + _
					  "			   isnull(cast([2011] as numeric(3,2)),0) as a2011,isnull(cast([2012] as numeric(3,2)),0) as a2012,isnull(cast([2013] as numeric(3,2)),0) as a2013   " + _
					  "		from    " + _
					  "		 (    " + _
					  "			select anos_ccod,sede_tdesc,ASG_NEM from [ASG_NEM_NUEVOS_SEDE] where ASG_NEM > 0   " + _
					  "		 )p    " + _
					  "		 PIVOT    " + _
					  "		 (    " + _
					  "		  STDEVP(ASG_NEM) " + _
					  "		  FOR anos_ccod in ([2005],[2006],[2007],[2008],[2009],[2010],[2011],[2012],[2013])  " + _
					  "		 ) AS pvt    " + _
					  "	) tr " + _
					  " "
					  
  	   sqlTotalSede = " select 'TOTALES' as Cabecera,[tr].a2005,[tr].a2006,[tr].a2007,[tr].a2008,[tr].a2009,[tr].a2010,[tr].a2011,[tr].a2012,[tr].a2013  " + _
					  "	From  " + _
					  "	(      " + _
					  "		select " + _
					  "			   isnull(cast([2005] as numeric(3,2)),0) as a2005,isnull(cast([2006] as numeric(3,2)),0) as a2006,isnull(cast([2007] as numeric(3,2)),0) as a2007, " + _
					  "			   isnull(cast([2008] as numeric(3,2)),0) as a2008,isnull(cast([2009] as numeric(3,2)),0) as a2009,isnull(cast([2010] as numeric(3,2)),0) as a2010, " + _
					  "			   isnull(cast([2011] as numeric(3,2)),0) as a2011,isnull(cast([2012] as numeric(3,2)),0) as a2012,isnull(cast([2013] as numeric(3,2)),0) as a2013   " + _
					  "		from    " + _
					  "		 (    " + _
					  "			select anos_ccod,ASG_NEM from [ASG_NEM_NUEVOS_SEDE] where ASG_NEM > 0   " + _
					  "		 )p    " + _
					  "		 PIVOT    " + _
					  "		 (    " + _
					  "		  STDEVP(ASG_NEM) " + _
					  "		  FOR anos_ccod in ([2005],[2006],[2007],[2008],[2009],[2010],[2011],[2012],[2013])  " + _
					  "		 ) AS pvt    " + _
					  "	) tr " + _
					  " " 			  
		  
		  selectSQLFacultad = " select [tr].Cabecera,[tr].a2005,[tr].a2006,[tr].a2007,[tr].a2008,[tr].a2009,[tr].a2010,[tr].a2011,[tr].a2012,[tr].a2013 " + _
							  "	From  "    + _
							  "	(     "    + _
							  "		select facu_tdesc as Cabecera, " + _
							  "			   isnull(cast([2005] as numeric(3,2)),0) as a2005,isnull(cast([2006] as numeric(3,2)),0) as a2006,isnull(cast([2007] as numeric(3,2)),0) as a2007, " + _
							  "			   isnull(cast([2008] as numeric(3,2)),0) as a2008,isnull(cast([2009] as numeric(3,2)),0) as a2009,isnull(cast([2010] as numeric(3,2)),0) as a2010, " + _
							  "			   isnull(cast([2011] as numeric(3,2)),0) as a2011,isnull(cast([2012] as numeric(3,2)),0) as a2012,isnull(cast([2013] as numeric(3,2)),0) as a2013   " + _
							  "		from "    + _
							  "		( "    + _
							  "			select anos_ccod,facu_tdesc,ASG_NEM from  [ASG_NEM_NUEVOS_FACULTAD] where ASG_NEM > 0 "    + _
							  "		)p "    + _
							  "		PIVOT "    + _
							  "		 ( "    + _
							  "		  STDEVP(ASG_NEM) "    + _
							  "		  FOR anos_ccod in ([2005],[2006],[2007],[2008],[2009],[2010],[2011],[2012],[2013]) "    + _
							  "		 ) AS pvt   " + _
							  "	) tr " + _
							  " "
							  
		   sqlTotalFacultad = " select 'TOTALES' as Cabecera,[tr].a2005,[tr].a2006,[tr].a2007,[tr].a2008,[tr].a2009,[tr].a2010,[tr].a2011,[tr].a2012,[tr].a2013 " + _
							  "	From  "    + _
							  "	(     "    + _
							  "		select " + _
							  "			   isnull(cast([2005] as numeric(3,2)),0) as a2005,isnull(cast([2006] as numeric(3,2)),0) as a2006,isnull(cast([2007] as numeric(3,2)),0) as a2007, " + _
							  "			   isnull(cast([2008] as numeric(3,2)),0) as a2008,isnull(cast([2009] as numeric(3,2)),0) as a2009,isnull(cast([2010] as numeric(3,2)),0) as a2010, " + _
							  "			   isnull(cast([2011] as numeric(3,2)),0) as a2011,isnull(cast([2012] as numeric(3,2)),0) as a2012,isnull(cast([2013] as numeric(3,2)),0) as a2013   " + _
							  "		from "    + _
							  "		( "    + _
							  "			select anos_ccod,ASG_NEM from  [ASG_NEM_NUEVOS_FACULTAD] where ASG_NEM > 0 "    + _
							  "		)p "    + _
							  "		PIVOT "    + _
							  "		 ( "    + _
							  "		  STDEVP(ASG_NEM) "    + _
							  "		  FOR anos_ccod in ([2005],[2006],[2007],[2008],[2009],[2010],[2011],[2012],[2013]) "    + _
							  "		 ) AS pvt   " + _
							  "	) tr " + _
							  " "					  
		
		   selectSQLJornada = " select [tr].Cabecera,[tr].a2005,[tr].a2006,[tr].a2007,[tr].a2008,[tr].a2009,[tr].a2010,[tr].a2011,[tr].a2012,[tr].a2013 " + _
							  "	From  "    + _
							  "	(     "    + _
							  "		select jorn_tdesc as Cabecera, " + _
							  "			   isnull(cast([2005] as numeric(3,2)),0) as a2005,isnull(cast([2006] as numeric(3,2)),0) as a2006,isnull(cast([2007] as numeric(3,2)),0) as a2007, " + _
							  "			   isnull(cast([2008] as numeric(3,2)),0) as a2008,isnull(cast([2009] as numeric(3,2)),0) as a2009,isnull(cast([2010] as numeric(3,2)),0) as a2010, " + _
							  "			   isnull(cast([2011] as numeric(3,2)),0) as a2011,isnull(cast([2012] as numeric(3,2)),0) as a2012,isnull(cast([2013] as numeric(3,2)),0) as a2013   " + _
							  "		from "    + _
							  "		( "    + _
							  "			select anos_ccod,jorn_tdesc,ASG_NEM from  [ASG_NEM_NUEVOS_JORNADA] where ASG_NEM > 0 "    + _
							  "		 )p "    + _
							  "		 PIVOT "    + _
							  "		 ( "    + _
							  "		  STDEVP(ASG_NEM) "    + _
							  "		  FOR anos_ccod in ([2005],[2006],[2007],[2008],[2009],[2010],[2011],[2012],[2013]) "    + _
							  "		 ) AS pvt   " + _
							  "	) tr " + _
							  " "
							  
		   sqlTotalJornada  = " select 'TOTALES' as Cabecera,[tr].a2005,[tr].a2006,[tr].a2007,[tr].a2008,[tr].a2009,[tr].a2010,[tr].a2011,[tr].a2012,[tr].a2013 " + _
							  "	From  "    + _
							  "	(     "    + _
							  "		select " + _
							  "			   isnull(cast([2005] as numeric(3,2)),0) as a2005,isnull(cast([2006] as numeric(3,2)),0) as a2006,isnull(cast([2007] as numeric(3,2)),0) as a2007, " + _
							  "			   isnull(cast([2008] as numeric(3,2)),0) as a2008,isnull(cast([2009] as numeric(3,2)),0) as a2009,isnull(cast([2010] as numeric(3,2)),0) as a2010, " + _
							  "			   isnull(cast([2011] as numeric(3,2)),0) as a2011,isnull(cast([2012] as numeric(3,2)),0) as a2012,isnull(cast([2013] as numeric(3,2)),0) as a2013   " + _
							  "		from "    + _
							  "		( "    + _
							  "			select anos_ccod,ASG_NEM from  [ASG_NEM_NUEVOS_JORNADA] where ASG_NEM > 0 "    + _
							  "		 )p "    + _
							  "		 PIVOT "    + _
							  "		 ( "    + _
							  "		  STDEVP(ASG_NEM) "    + _
							  "		  FOR anos_ccod in ([2005],[2006],[2007],[2008],[2009],[2010],[2011],[2012],[2013]) "    + _
							  "		 ) AS pvt   " + _
							  "	) tr " + _
							  " "					  
							  
		   selectSQLCarrera = " select [tr].Cabecera,[tr].a2005,[tr].a2006,[tr].a2007,[tr].a2008,[tr].a2009,[tr].a2010,[tr].a2011,[tr].a2012,[tr].a2013 " + _
							  "	From  "    + _
							  "	(     "    + _
							  "		select carr_tdesc as Cabecera, " + _
							  "			   isnull(cast([2005] as numeric(3,2)),0) as a2005,isnull(cast([2006] as numeric(3,2)),0) as a2006,isnull(cast([2007] as numeric(3,2)),0) as a2007, " + _
							  "			   isnull(cast([2008] as numeric(3,2)),0) as a2008,isnull(cast([2009] as numeric(3,2)),0) as a2009,isnull(cast([2010] as numeric(3,2)),0) as a2010, " + _
							  "			   isnull(cast([2011] as numeric(3,2)),0) as a2011,isnull(cast([2012] as numeric(3,2)),0) as a2012,isnull(cast([2013] as numeric(3,2)),0) as a2013   " + _
							  "	from "    + _
							  "	( "    + _
							  "		select anos_ccod,replace(replace(replace(replace(replace(replace(carr_tdesc,'Ñ','N'),'Á','A'),'É','E'),'Í','I'),'Ó','O'),'Ú','U') as carr_tdesc, "&_
							  "     ASG_NEM from [ASG_NEM_NUEVOS_CARRERA] where ASG_NEM > 0 " + filtroCarrera     + _
							  "	)p "    + _
							  "	 PIVOT "    + _
							  "	 ( "    + _
							  "	     STDEVP(ASG_NEM) "    + _
							  "	     FOR anos_ccod in ([2005],[2006],[2007],[2008],[2009],[2010],[2011],[2012],[2013]) "    + _
							  "	 ) AS pvt   " + _
							  "	) tr " + _
							  " "
							  
			sqlTotalCarrera = " select 'TOTALES' as Cabecera,[tr].a2005,[tr].a2006,[tr].a2007,[tr].a2008,[tr].a2009,[tr].a2010,[tr].a2011,[tr].a2012,[tr].a2013 " + _
							  "	From  "    + _
							  "	(     "    + _
							  "		select " + _
							  "			   isnull(cast([2005] as numeric(3,2)),0) as a2005,isnull(cast([2006] as numeric(3,2)),0) as a2006,isnull(cast([2007] as numeric(3,2)),0) as a2007, " + _
							  "			   isnull(cast([2008] as numeric(3,2)),0) as a2008,isnull(cast([2009] as numeric(3,2)),0) as a2009,isnull(cast([2010] as numeric(3,2)),0) as a2010, " + _
							  "			   isnull(cast([2011] as numeric(3,2)),0) as a2011,isnull(cast([2012] as numeric(3,2)),0) as a2012,isnull(cast([2013] as numeric(3,2)),0) as a2013   " + _
							  "	from "    + _
							  "	( "    + _
							  "		select anos_ccod,ASG_NEM from [ASG_NEM_NUEVOS_CARRERA] where ASG_NEM > 0 " + filtroCarrera     + _
							  "	)p "    + _
							  "	 PIVOT "    + _
							  "	 ( "    + _
							  "	     STDEVP(ASG_NEM) "    + _
							  "	     FOR anos_ccod in ([2005],[2006],[2007],[2008],[2009],[2010],[2011],[2012],[2013]) "    + _
							  "	 ) AS pvt   " + _
							  "	) tr " + _
							  " "				  

      end sub

      private sub Class_Terminate()
      end sub

      '=============================
      'public Functions

      ' Select all NemDesviacion into a Dictionary
      ' return a Dictionary of NemDesviacion objects - if successful, Nothing otherwise
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
                    results.Add obj.Cabecera, obj
                    records.movenext
               wend
               set SelectAll = results
               records.Close
          End If
          set records = nothing
      end function
	  
	  public function SelectTotalSede()
          Dim records
          set objCommand=Server.CreateObject("ADODB.command")
          objCommand.ActiveConnection=DbOpenConnection()
          objCommand.NamedParameters = False
          objCommand.CommandText = sqlTotalSede
          objCommand.CommandType = adCmdText
          set records = objCommand.Execute
          if records.eof then
               Set SelectTotalSede = Nothing
          else
               Dim results, obj, record
               Set results = Server.CreateObject("Scripting.Dictionary")
               while not records.eof
                    set obj = PopulateObjectFromRecord(records)
                    results.Add obj.Cabecera, obj
                    records.movenext
               wend
               set SelectTotalSede = results
               records.Close
          End If
          set records = nothing
      end function
	  
	  public function SelectAllFacultad()
          Dim records
          set objCommand=Server.CreateObject("ADODB.command")
          objCommand.ActiveConnection=DbOpenConnection()
          objCommand.NamedParameters = False
          objCommand.CommandText = selectSQLFacultad
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
               set SelectAllFacultad = results
               records.Close
          End If
          set records = nothing
      end function
	  
	  public function SelectTotalFacultad()
          Dim records
          set objCommand=Server.CreateObject("ADODB.command")
          objCommand.ActiveConnection=DbOpenConnection()
          objCommand.NamedParameters = False
          objCommand.CommandText = sqlTotalFacultad
          objCommand.CommandType = adCmdText
          set records = objCommand.Execute
          if records.eof then
               Set SelectTotalFacultad = Nothing
          else
               Dim results, obj, record
               Set results = Server.CreateObject("Scripting.Dictionary")
               while not records.eof
                    set obj = PopulateObjectFromRecord(records)
                    results.Add obj.Cabecera, obj
                    records.movenext
               wend
               set SelectTotalFacultad = results
               records.Close
          End If
          set records = nothing
      end function
	  
	  public function SelectAllJornada()
          Dim records
          set objCommand=Server.CreateObject("ADODB.command")
          objCommand.ActiveConnection=DbOpenConnection()
          objCommand.NamedParameters = False
          objCommand.CommandText = selectSQLJornada
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
               set SelectAllJornada = results
               records.Close
          End If
          set records = nothing
      end function
	  
	  public function SelectTotalJornada()
          Dim records
          set objCommand=Server.CreateObject("ADODB.command")
          objCommand.ActiveConnection=DbOpenConnection()
          objCommand.NamedParameters = False
          objCommand.CommandText = sqlTotalJornada
          objCommand.CommandType = adCmdText
          set records = objCommand.Execute
          if records.eof then
               Set SelectTotalJornada = Nothing
          else
               Dim results, obj, record
               Set results = Server.CreateObject("Scripting.Dictionary")
               while not records.eof
                    set obj = PopulateObjectFromRecord(records)
                    results.Add obj.Cabecera, obj
                    records.movenext
               wend
               set SelectTotalJornada = results
               records.Close
          End If
          set records = nothing
      end function
	  
	  public function SelectAllCarrera()
          Dim records
          set objCommand=Server.CreateObject("ADODB.command")
          objCommand.ActiveConnection=DbOpenConnection()
          objCommand.NamedParameters = False
          objCommand.CommandText = selectSQLCarrera
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
               set SelectAllCarrera = results
               records.Close
          End If
          set records = nothing
      end function
	  
	  public function SelectTotalCarrera()
          Dim records
          set objCommand=Server.CreateObject("ADODB.command")
          objCommand.ActiveConnection=DbOpenConnection()
          objCommand.NamedParameters = False
          objCommand.CommandText = sqlTotalCarrera
          objCommand.CommandType = adCmdText
          set records = objCommand.Execute
          if records.eof then
               Set SelectTotalCarrera = Nothing
          else
               Dim results, obj, record
               Set results = Server.CreateObject("Scripting.Dictionary")
               while not records.eof
                    set obj = PopulateObjectFromRecord(records)
                    results.Add obj.Cabecera, obj
                    records.movenext
               wend
               set SelectTotalCarrera = results
               records.Close
          End If
          set records = nothing
      end function

      ' Select all NemDesviacion into a Dictionary
      ' return a Dictionary of NemDesviacion objects - if successful, Nothing otherwise
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
            set obj = new NemDesviacion
              obj.Cabecera = record("Cabecera")
              obj.a2005 = record("a2005")
              obj.a2006 = record("a2006")
              obj.a2007 = record("a2007")
			  obj.a2008 = record("a2008")
              obj.a2009 = record("a2009")
              obj.a2010 = record("a2010")
			  obj.a2011 = record("a2011")
              obj.a2012 = record("a2012")
              obj.a2013 = record("a2013")
             
              set PopulateObjectFromRecord = obj
      end if
    end function

end class 'NemDesviacionHelper
%>
    