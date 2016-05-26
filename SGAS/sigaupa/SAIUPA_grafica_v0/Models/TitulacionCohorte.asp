      <%

      '
      ' This files defines the TitulacionCohorte model
      '
class TitulacionCohorte

      private mMetadata

      '=============================
      'Private properties
        private  m_anos
		private  mCabecera
		private  m_anos_0
        private  m_anos_1
        private  m_anos_2
        private  m_anos_3
		private  m_anos_4
        private  m_anos_5
        private  m_anos_6
		private  m_anos_7
        private  m_anos_8
        private  m_anos_9
		private  m_anos_10
		private  m_anos_11
		private  m_anos_12
		private  m_anos_13

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
      
	  public property get a_anos()
          a_anos = m_anos
      end property

      public property let a_anos(val)
          m_anos = val
      end property
      
	  public property get a_anos_0()
          a_anos_0 = m_anos_0
      end property

      public property let a_anos_0(val)
          m_anos_0 = val
      end property
      
      public property get a_anos_1()
          a_anos_1 = m_anos_1
      end property

      public property let a_anos_1(val)
          m_anos_1 = val
      end property
      
      public property get a_anos_2()
          a_anos_2 = m_anos_2
      end property

      public property let a_anos_2(val)
          m_anos_2 = val
      end property
	  
	  public property get a_anos_3()
          a_anos_3 = m_anos_3
      end property

      public property let a_anos_3(val)
          m_anos_3 = val
      end property
      
      public property get a_anos_4()
          a_anos_4 = m_anos_4
      end property

      public property let a_anos_4(val)
          m_anos_4 = val
      end property
      
      public property get a_anos_5()
          a_anos_5 = m_anos_5
      end property

      public property let a_anos_5(val)
          m_anos_5 = val
      end property
	  
	  public property get a_anos_6()
          a_anos_6 = m_anos_6
      end property

      public property let a_anos_6(val)
          m_anos_6 = val
      end property
      
      public property get a_anos_7()
          a_anos_7 = m_anos_7
      end property

      public property let a_anos_7(val)
          m_anos_7 = val
      end property
      
      public property get a_anos_8()
          a_anos_8 = m_anos_8
      end property

      public property let a_anos_8(val)
          m_anos_8 = val
      end property
      
	  public property get a_anos_9()
          a_anos_9 = m_anos_9
      end property

      public property let a_anos_9(val)
          m_anos_9 = val
      end property
	  
	  public property get a_anos_10()
          a_anos_10 = m_anos_10
      end property

      public property let a_anos_10(val)
          m_anos_10 = val
      end property
	  
	  public property get a_anos_11()
          a_anos_11 = m_anos_11
      end property

      public property let a_anos_11(val)
          m_anos_11 = val
      end property
	  
	  public property get a_anos_12()
          a_anos_12 = m_anos_12
      end property

      public property let a_anos_12(val)
          m_anos_12 = val
      end property
	  
	  public property get a_anos_13()
          a_anos_13 = m_anos_13
      end property

      public property let a_anos_13(val)
          m_anos_13 = val
      end property
	  
      'exteded properties - names from related tables -read/write, but not saved in DB
      
      public property get metadata()
          metadata = mMetadata
      end property


      end class 'TitulacionCohorte


      '======================
class TitulacionCohorteHelper

      Dim selectSQL
	  Dim selectSQLFacultad
	  Dim selectSQLJornada
	  Dim selectSQLCarrera
	  Dim sqlTotalSede
	  Dim sqlTotalFacultad
	  Dim sqlTotalJornada
	  Dim sqlTotalCarrera

      private sub Class_Initialize()
          selectSQL = " select [tr].a_anos, [tr].Cabecera,[tr].a_anos_0,[tr].a_anos_1,[tr].a_anos_2,[tr].a_anos_3,[tr].a_anos_4,[tr].a_anos_5,[tr].a_anos_6,[tr].a_anos_6,[tr].a_anos_7,  " + _
		              "                     [tr].a_anos_8,[tr].a_anos_9,[tr].a_anos_10,[tr].a_anos_11,[tr].a_anos_12,[tr].a_anos_13  " + _
					  "	From  " + _
					  "	(      " + _
					  "		select anos_ccod as a_anos, sede_tdesc as Cabecera, total_cohorte as a_anos_0, " + _
					  "			desc_anos_1 as a_anos_1,desc_anos_2 as a_anos_2,desc_anos_3 as a_anos_3,desc_anos_4 as a_anos_4,desc_anos_5 as a_anos_5,desc_anos_6 as a_anos_6, " + _
					  "			desc_anos_7 as a_anos_7,desc_anos_8 as a_anos_8,desc_anos_9 as a_anos_9,desc_anos_10 as a_anos_10,desc_anos_11 as a_anos_11,desc_anos_12 as a_anos_12, " + _
					  "			desc_anos_13 as a_anos_13 " + _
					  "		from ANI_TITULADO_COHORTE_SEDE    " + _
					  "	) tr " + _
					  " "
		  
 	   sqlTotalSede = " select [tr].a_anos, 'Totales' as Cabecera,[tr].a_anos_0,[tr].a_anos_1,[tr].a_anos_2,[tr].a_anos_3,[tr].a_anos_4,[tr].a_anos_5,[tr].a_anos_6,[tr].a_anos_6,[tr].a_anos_7,  " + _
		              "                     [tr].a_anos_8,[tr].a_anos_9,[tr].a_anos_10,[tr].a_anos_11,[tr].a_anos_12,[tr].a_anos_13  " + _
					  "	From  " + _
					  "	(      " + _
					  "		select anos_ccod as a_anos, sum(total_cohorte) as a_anos_0, " + _
					  "			sum(desc_anos_1) as a_anos_1,sum(desc_anos_2) as a_anos_2,sum(desc_anos_3) as a_anos_3,sum(desc_anos_4) as a_anos_4,sum(desc_anos_5) as a_anos_5,  " + _
					  "         sum(desc_anos_6) as a_anos_6, sum(desc_anos_7) as a_anos_7,sum(desc_anos_8) as a_anos_8,sum(desc_anos_9) as a_anos_9,sum(desc_anos_10) as a_anos_10,  " + _
					  "			sum(desc_anos_11) as a_anos_11,sum(desc_anos_12) as a_anos_12, sum(desc_anos_13) as a_anos_13 " + _
					  "		from ANI_TITULADO_COHORTE_SEDE    " + _
					  "		group by  anos_ccod " + _
					  "	) tr " + _
					  " "
		  
		  selectSQLFacultad = " select [tr].a_anos, [tr].Cabecera,[tr].a_anos_0,[tr].a_anos_1,[tr].a_anos_2,[tr].a_anos_3,[tr].a_anos_4,[tr].a_anos_5,[tr].a_anos_6,[tr].a_anos_6,[tr].a_anos_7,  " + _
							  "                     [tr].a_anos_8,[tr].a_anos_9,[tr].a_anos_10,[tr].a_anos_11,[tr].a_anos_12,[tr].a_anos_13  " + _
							  "	From  " + _
							  "	(      " + _
							  "		select anos_ccod as a_anos, replace(replace(replace(replace(replace(replace(facu_tdesc,'Ñ','N'),'Á','A'),'É','E'),'Í','I'),'Ó','O'),'Ú','U') as Cabecera, " + _ 	
							  "         total_cohorte as a_anos_0, " + _
							  "			desc_anos_1 as a_anos_1,desc_anos_2 as a_anos_2,desc_anos_3 as a_anos_3,desc_anos_4 as a_anos_4,desc_anos_5 as a_anos_5,desc_anos_6 as a_anos_6, " + _
							  "			desc_anos_7 as a_anos_7,desc_anos_8 as a_anos_8,desc_anos_9 as a_anos_9,desc_anos_10 as a_anos_10,desc_anos_11 as a_anos_11,desc_anos_12 as a_anos_12, " + _
							  "			desc_anos_13 as a_anos_13 " + _
							  "		from ANI_TITULADO_COHORTE_FACULTAD    " + _
							  "	) tr " + _
							  " "
							  
		   sqlTotalFacultad = " select [tr].a_anos, 'Totales' as Cabecera, " + _
		                      "        [tr].a_anos_0, [tr].a_anos_1,[tr].a_anos_2,[tr].a_anos_3,[tr].a_anos_4,[tr].a_anos_5,[tr].a_anos_6,[tr].a_anos_6,[tr].a_anos_7,  " + _
							  "        [tr].a_anos_8,[tr].a_anos_9,[tr].a_anos_10,[tr].a_anos_11,[tr].a_anos_12,[tr].a_anos_13  " + _
							  "	From  " + _
							  "	(      " + _
							  "		select anos_ccod as a_anos, sum(total_cohorte) as a_anos_0, " + _
							  "			sum(desc_anos_1) as a_anos_1,sum(desc_anos_2) as a_anos_2,sum(desc_anos_3) as a_anos_3,sum(desc_anos_4) as a_anos_4,sum(desc_anos_5) as a_anos_5,  " + _
							  "         sum(desc_anos_6) as a_anos_6, sum(desc_anos_7) as a_anos_7,sum(desc_anos_8) as a_anos_8,sum(desc_anos_9) as a_anos_9,sum(desc_anos_10) as a_anos_10,  " + _
							  "			sum(desc_anos_11) as a_anos_11,sum(desc_anos_12) as a_anos_12, sum(desc_anos_13) as a_anos_13 " + _
							  "		from ANI_TITULADO_COHORTE_FACULTAD    " + _
							  "		group by  anos_ccod " + _
							  "	) tr " + _
							  " "					  
		
		   selectSQLJornada = " select [tr].a_anos, [tr].Cabecera,[tr].a_anos_0,[tr].a_anos_1,[tr].a_anos_2,[tr].a_anos_3,[tr].a_anos_4,[tr].a_anos_5,[tr].a_anos_6,[tr].a_anos_6,[tr].a_anos_7,  " + _
							  "                     [tr].a_anos_8,[tr].a_anos_9,[tr].a_anos_10,[tr].a_anos_11,[tr].a_anos_12,[tr].a_anos_13  " + _
							  "	From  " + _
							  "	(      " + _
							  "		select anos_ccod as a_anos, jorn_tdesc as Cabecera, total_cohorte as a_anos_0, " + _
							  "			desc_anos_1 as a_anos_1,desc_anos_2 as a_anos_2,desc_anos_3 as a_anos_3,desc_anos_4 as a_anos_4,desc_anos_5 as a_anos_5,desc_anos_6 as a_anos_6, " + _
							  "			desc_anos_7 as a_anos_7,desc_anos_8 as a_anos_8,desc_anos_9 as a_anos_9,desc_anos_10 as a_anos_10,desc_anos_11 as a_anos_11,desc_anos_12 as a_anos_12, " + _
							  "			desc_anos_13 as a_anos_13 " + _
							  "		from ANI_TITULADO_COHORTE_JORNADA    " + _
							  "	) tr " + _
							  " "
							  
		   sqlTotalJornada  = " select [tr].a_anos, 'Totales' as Cabecera, " + _
		                      "        [tr].a_anos_0, [tr].a_anos_1,[tr].a_anos_2,[tr].a_anos_3,[tr].a_anos_4,[tr].a_anos_5,[tr].a_anos_6,[tr].a_anos_6,[tr].a_anos_7,  " + _
							  "        [tr].a_anos_8,[tr].a_anos_9,[tr].a_anos_10,[tr].a_anos_11,[tr].a_anos_12,[tr].a_anos_13  " + _
							  "	From  " + _
							  "	(      " + _
							  "		select anos_ccod as a_anos, sum(total_cohorte) as a_anos_0, " + _
							  "			sum(desc_anos_1) as a_anos_1,sum(desc_anos_2) as a_anos_2,sum(desc_anos_3) as a_anos_3,sum(desc_anos_4) as a_anos_4,sum(desc_anos_5) as a_anos_5,  " + _
							  "         sum(desc_anos_6) as a_anos_6, sum(desc_anos_7) as a_anos_7,sum(desc_anos_8) as a_anos_8,sum(desc_anos_9) as a_anos_9,sum(desc_anos_10) as a_anos_10,  " + _
							  "			sum(desc_anos_11) as a_anos_11,sum(desc_anos_12) as a_anos_12, sum(desc_anos_13) as a_anos_13 " + _
							  "		from ANI_TITULADO_COHORTE_JORNADA    " + _
							  "		group by  anos_ccod " + _
							  "	) tr " + _
							  " " 
		 					  
		   selectSQLCarrera = " select [tr].a_anos, [tr].Cabecera,[tr].a_anos_0,[tr].a_anos_1,[tr].a_anos_2,[tr].a_anos_3,[tr].a_anos_4,[tr].a_anos_5,[tr].a_anos_6,[tr].a_anos_6,[tr].a_anos_7,  " + _
							  "                     [tr].a_anos_8,[tr].a_anos_9,[tr].a_anos_10,[tr].a_anos_11,[tr].a_anos_12,[tr].a_anos_13  " + _
							  "	From  " + _
							  "	(      " + _
							  "		select anos_ccod as a_anos, replace(replace(replace(replace(replace(replace(carr_tdesc,'Ñ','N'),'Á','A'),'É','E'),'Í','I'),'Ó','O'),'Ú','U') as Cabecera, " + _ 
							  "     sum(total_cohorte) as a_anos_0, " + _
							  "		sum(desc_anos_1) as a_anos_1,sum(desc_anos_2) as a_anos_2,sum(desc_anos_3) as a_anos_3,sum(desc_anos_4) as a_anos_4,sum(desc_anos_5) as a_anos_5, " + _
							  "     sum(desc_anos_6) as a_anos_6,sum(desc_anos_7) as a_anos_7,sum(desc_anos_8) as a_anos_8,sum(desc_anos_9) as a_anos_9,sum(desc_anos_10) as a_anos_10, " + _
							  "     sum(desc_anos_11) as a_anos_11,sum(desc_anos_12) as a_anos_12, sum(desc_anos_13) as a_anos_13 " + _
							  "		from ANI_TITULADO_COHORTE_CARRERA  " + _
							  "		group by anos_ccod, replace(replace(replace(replace(replace(replace(carr_tdesc,'Ñ','N'),'Á','A'),'É','E'),'Í','I'),'Ó','O'),'Ú','U')  " + _
							  "	) tr " + _
							  " "
							  
		  sqlTotalCarrera   = " select [tr].a_anos, 'Totales' as Cabecera, " + _
		                      "        [tr].a_anos_0, [tr].a_anos_1,[tr].a_anos_2,[tr].a_anos_3,[tr].a_anos_4,[tr].a_anos_5,[tr].a_anos_6,[tr].a_anos_6,[tr].a_anos_7,  " + _
							  "        [tr].a_anos_8,[tr].a_anos_9,[tr].a_anos_10,[tr].a_anos_11,[tr].a_anos_12,[tr].a_anos_13  " + _
							  "	From  " + _
							  "	(      " + _
							  "		select anos_ccod as a_anos, sum(total_cohorte) as a_anos_0, " + _
							  "			sum(desc_anos_1) as a_anos_1,sum(desc_anos_2) as a_anos_2,sum(desc_anos_3) as a_anos_3,sum(desc_anos_4) as a_anos_4,sum(desc_anos_5) as a_anos_5,  " + _
							  "         sum(desc_anos_6) as a_anos_6, sum(desc_anos_7) as a_anos_7,sum(desc_anos_8) as a_anos_8,sum(desc_anos_9) as a_anos_9,sum(desc_anos_10) as a_anos_10,  " + _
							  "			sum(desc_anos_11) as a_anos_11,sum(desc_anos_12) as a_anos_12, sum(desc_anos_13) as a_anos_13 " + _
							  "		from ANI_TITULADO_COHORTE_CARRERA    " + _
							  "		group by  anos_ccod " + _
							  "	) tr " + _
							  " "					  

      end sub

      private sub Class_Terminate()
      end sub

      '=============================
      'public Functions

      ' Select all TitulacionCohorte into a Dictionary
      ' return a Dictionary of TitulacionCohorte objects - if successful, Nothing otherwise
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
                    results.Add obj.Cabecera+"-"+cstr(obj.a_anos), obj
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
                    results.Add obj.Cabecera+"-"+cstr(obj.a_anos), obj
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
                    results.Add obj.Cabecera+"-"+cstr(obj.a_anos), obj
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
                    results.Add obj.Cabecera+"-"+cstr(obj.a_anos), obj
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
                    results.Add obj.Cabecera+"-"+cstr(obj.a_anos), obj
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
                    results.Add obj.Cabecera+"-"+cstr(obj.a_anos), obj
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
                    results.Add obj.Cabecera+"-"+cstr(obj.a_anos), obj
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
                    results.Add obj.Cabecera+"-"+cstr(obj.a_anos), obj
                    records.movenext
               wend
               set SelectTotalCarrera = results
               records.Close
          End If
          set records = nothing
      end function

      ' Select all TitulacionCohorte into a Dictionary
      ' return a Dictionary of TitulacionCohorte objects - if successful, Nothing otherwise
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
            set obj = new TitulacionCohorte
              obj.a_anos    = record("a_anos")
			  obj.Cabecera  = record("Cabecera")
              obj.a_anos_0  = record("a_anos_0")
              obj.a_anos_1  = record("a_anos_1")
              obj.a_anos_2  = record("a_anos_2")
			  obj.a_anos_3  = record("a_anos_3")
              obj.a_anos_4  = record("a_anos_4")
              obj.a_anos_5  = record("a_anos_5")
			  obj.a_anos_6  = record("a_anos_6")
              obj.a_anos_7  = record("a_anos_7")
              obj.a_anos_8  = record("a_anos_8")
			  obj.a_anos_9  = record("a_anos_9")
			  obj.a_anos_10 = record("a_anos_10")
			  obj.a_anos_11 = record("a_anos_11")
			  obj.a_anos_12 = record("a_anos_12")
			  obj.a_anos_13 = record("a_anos_13")
             
              set PopulateObjectFromRecord = obj
      end if
    end function

end class 'TitulacionCohorteHelper
%>
    