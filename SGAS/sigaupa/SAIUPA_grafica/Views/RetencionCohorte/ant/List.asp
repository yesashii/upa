
      <script type="text/javascript">
          //two variables Controller and Action have to be initialized in the View HTML code
          var Controller ='RetencionCohorte';
          var Action = 'List';
      </script>
      <%
	  anio_consulta=""
	  complemento_url = ""
	  url_detalle = "&q="
	  v_anio_actual	= Year(now())
	  maximo_anio = "2000"
	  inicial = request.form("inicial")
	  if inicial = "" then
	  	inicial= 1
	  end if
	  if request.form("anio_consulta") = "" then
	  	complemento_url = complemento_url&"&anio_consulta=2000"
		maximo_anio = "2000"
	  else
	    complemento_url = complemento_url&"&anio_consulta="&request.form("anio_consulta")
		maximo_anio = request.form("anio_consulta")
	  end if
	  url_detalle = url_detalle & "" & maximo_anio
	  
	  chequeo_2000="checked='checked'"
	  chequeo_2001="checked='checked'"
	  chequeo_2002="checked='checked'"
	  chequeo_2003="checked='checked'"
	  chequeo_2004="checked='checked'"
	  chequeo_2005="checked='checked'"
	  chequeo_2006="checked='checked'"
	  chequeo_2007="checked='checked'"
	  chequeo_2008="checked='checked'"
	  chequeo_2009="checked='checked'"
	  chequeo_2010="checked='checked'"
	  chequeo_2011="checked='checked'"
	  chequeo_2012="checked='checked'"
	  chequeo_2013="checked='checked'"
	  if maximo_anio <> "2000" then   chequeo_2000=""  end if
	  if maximo_anio <> "2001" then   chequeo_2001=""  end if
	  if maximo_anio <> "2002" then   chequeo_2002=""  end if
	  if maximo_anio <> "2003" then   chequeo_2003=""  end if
	  if maximo_anio <> "2004" then   chequeo_2004=""  end if
	  if maximo_anio <> "2005" then   chequeo_2005=""  end if
	  if maximo_anio <> "2006" then   chequeo_2006=""  end if
	  if maximo_anio <> "2007" then   chequeo_2007=""  end if
	  if maximo_anio <> "2008" then   chequeo_2008=""  end if
	  if maximo_anio <> "2009" then   chequeo_2009=""  end if
	  if maximo_anio <> "2010" then   chequeo_2010=""  end if
	  if maximo_anio <> "2011" then   chequeo_2011=""  end if
	  if maximo_anio <> "2012" then   chequeo_2012=""  end if
	  if maximo_anio <> "2013" then   chequeo_2013=""  end if
	  
	  
	  
	  'response.Write(maximo_anio)
	  %>
      <script type="text/javascript" src="//www.google.com/jsapi"></script>
	  <script type="text/javascript">
          google.load('visualization', '1.1', {packages: ['controls']});
      </script>
      <script type="text/javascript">
      function drawVisualization() {
        // Prepare the data
        var data = google.visualization.arrayToDataTable([
          ['Cohorte','Sede','Matr. Cohorte'
		   <%if maximo_anio + 1 <=  v_anio_actual then  response.Write(",'Año N°2'")  end if%>
		   <%if maximo_anio + 2 <=  v_anio_actual then  response.Write(",'Año N°3'")  end if%>
		   <%if maximo_anio + 3 <=  v_anio_actual then  response.Write(",'Año N°4'")  end if%>
		   <%if maximo_anio + 4 <=  v_anio_actual then  response.Write(",'Año N°5'")  end if%>
		   <%if maximo_anio + 5 <=  v_anio_actual then  response.Write(",'Año N°6'")  end if%>
		   <%if maximo_anio + 6 <=  v_anio_actual then  response.Write(",'Año N°7'")  end if%>
		   <%if maximo_anio + 7 <=  v_anio_actual then  response.Write(",'Año N°8'")  end if%>
		   <%if maximo_anio + 8 <=  v_anio_actual then  response.Write(",'Año N°9'")  end if%>
		   <%if maximo_anio + 9 <=  v_anio_actual then  response.Write(",'Año N°10'")  end if%>
		   <%if maximo_anio + 10 <=  v_anio_actual then  response.Write(",'Año N°11'")  end if%>
		   <%if maximo_anio + 11 <=  v_anio_actual then  response.Write(",'Año N°12'")  end if%>
		   <%if maximo_anio + 12 <=  v_anio_actual then  response.Write(",'Año N°13'")  end if%>
		   <%if maximo_anio + 13 <=  v_anio_actual then  response.Write(",'Año N°14'")  end if%>
		 ]
		   <%Dim obj0,obj01,obj02, valor_periodo,cabe
			      cadena = ""
				  sede_seleccionada = ""
                  For each obj0 in Model.Items
				    cabe = Html.Encode(obj0.cabecera)
					anio_registro = Html.Encode(obj0.a_anos)
					if anio_registro = maximo_anio then
						'IF sede_seleccionada = "" THEN 
						'	sede_seleccionada = cabe
						'END IF
                        response.Write(",['"+anio_registro+"','"+cabe+"',"+replace(Html.Encode(obj0.a_anos_0),",","."))
						if anio_registro + 1 <=  v_anio_actual then
							valor_periodo = replace(Html.Encode(obj0.a_anos_1),",",".")
							response.Write(","+valor_periodo)
						end if 
						if anio_registro + 2 <=  v_anio_actual then
							valor_periodo = replace(Html.Encode(obj0.a_anos_2),",",".")
							response.Write(","+valor_periodo)
						end if 
						if anio_registro + 3 <=  v_anio_actual then
							valor_periodo = replace(Html.Encode(obj0.a_anos_3),",",".")
							response.Write(","+valor_periodo)
						end if 
						if anio_registro + 4 <=  v_anio_actual then
							valor_periodo = replace(Html.Encode(obj0.a_anos_4),",",".")
							response.Write(","+valor_periodo)
						end if 
						if anio_registro + 5 <=  v_anio_actual then
							valor_periodo = replace(Html.Encode(obj0.a_anos_5),",",".")
							response.Write(","+valor_periodo)
						end if 
						if anio_registro + 6 <=  v_anio_actual then
							valor_periodo = replace(Html.Encode(obj0.a_anos_6),",",".")
							response.Write(","+valor_periodo)
						end if 
						if anio_registro + 7 <=  v_anio_actual then
							valor_periodo = replace(Html.Encode(obj0.a_anos_7),",",".")
							response.Write(","+valor_periodo)
						end if 
						if anio_registro + 8 <=  v_anio_actual then
							valor_periodo = replace(Html.Encode(obj0.a_anos_8),",",".")
							response.Write(","+valor_periodo)
						end if 
						if anio_registro + 9 <=  v_anio_actual then
							valor_periodo = replace(Html.Encode(obj0.a_anos_9),",",".")
							response.Write(","+valor_periodo)
						end if 
						if anio_registro + 10 <=  v_anio_actual then
							valor_periodo = replace(Html.Encode(obj0.a_anos_10),",",".")
							response.Write(","+valor_periodo)
						end if 
						if anio_registro + 11 <=  v_anio_actual then
							valor_periodo = replace(Html.Encode(obj0.a_anos_11),",",".")
							response.Write(","+valor_periodo)
						end if 
						if anio_registro + 12 <=  v_anio_actual then
							valor_periodo = replace(Html.Encode(obj0.a_anos_12),",",".")
							response.Write(","+valor_periodo)
						end if 
						if anio_registro + 13 <=  v_anio_actual then
							valor_periodo = replace(Html.Encode(obj0.a_anos_13),",",".")
							response.Write(","+valor_periodo)
						end if 
						response.Write("]")
					end if
				   next%>
        ]);
      
	  //Para Facultad
	  var data_Facultad = google.visualization.arrayToDataTable([
          ['Cohorte','Facultad','Matr. Cohorte'
		   <%if maximo_anio + 1 <=  v_anio_actual then  response.Write(",'Año N°2'")  end if%>
		   <%if maximo_anio + 2 <=  v_anio_actual then  response.Write(",'Año N°3'")  end if%>
		   <%if maximo_anio + 3 <=  v_anio_actual then  response.Write(",'Año N°4'")  end if%>
		   <%if maximo_anio + 4 <=  v_anio_actual then  response.Write(",'Año N°5'")  end if%>
		   <%if maximo_anio + 5 <=  v_anio_actual then  response.Write(",'Año N°6'")  end if%>
		   <%if maximo_anio + 6 <=  v_anio_actual then  response.Write(",'Año N°7'")  end if%>
		   <%if maximo_anio + 7 <=  v_anio_actual then  response.Write(",'Año N°8'")  end if%>
		   <%if maximo_anio + 8 <=  v_anio_actual then  response.Write(",'Año N°9'")  end if%>
		   <%if maximo_anio + 9 <=  v_anio_actual then  response.Write(",'Año N°10'")  end if%>
		   <%if maximo_anio + 10 <=  v_anio_actual then  response.Write(",'Año N°11'")  end if%>
		   <%if maximo_anio + 11 <=  v_anio_actual then  response.Write(",'Año N°12'")  end if%>
		   <%if maximo_anio + 12 <=  v_anio_actual then  response.Write(",'Año N°13'")  end if%>
		   <%if maximo_anio + 13 <=  v_anio_actual then  response.Write(",'Año N°14'")  end if%>
		 ]
		   <%     cadena = ""
				  facu_seleccionada = ""
                  For each obj_f in ModelFacultad.Items
				    cabe = Html.Encode(obj_f.cabecera)
					anio_registro = Html.Encode(obj_f.a_anos)
					if anio_registro = maximo_anio then
						'IF facu_seleccionada = "" THEN 
						'	facu_seleccionada = cabe
						'END IF
                        response.Write(",['"+anio_registro+"','"+cabe+"',"+replace(Html.Encode(obj_f.a_anos_0),",","."))
						if anio_registro + 1 <=  v_anio_actual then
							valor_periodo = replace(Html.Encode(obj_f.a_anos_1),",",".")
							response.Write(","+valor_periodo)
						end if 
						if anio_registro + 2 <=  v_anio_actual then
							valor_periodo = replace(Html.Encode(obj_f.a_anos_2),",",".")
							response.Write(","+valor_periodo)
						end if 
						if anio_registro + 3 <=  v_anio_actual then
							valor_periodo = replace(Html.Encode(obj_f.a_anos_3),",",".")
							response.Write(","+valor_periodo)
						end if 
						if anio_registro + 4 <=  v_anio_actual then
							valor_periodo = replace(Html.Encode(obj_f.a_anos_4),",",".")
							response.Write(","+valor_periodo)
						end if 
						if anio_registro + 5 <=  v_anio_actual then
							valor_periodo = replace(Html.Encode(obj_f.a_anos_5),",",".")
							response.Write(","+valor_periodo)
						end if 
						if anio_registro + 6 <=  v_anio_actual then
							valor_periodo = replace(Html.Encode(obj_f.a_anos_6),",",".")
							response.Write(","+valor_periodo)
						end if 
						if anio_registro + 7 <=  v_anio_actual then
							valor_periodo = replace(Html.Encode(obj_f.a_anos_7),",",".")
							response.Write(","+valor_periodo)
						end if 
						if anio_registro + 8 <=  v_anio_actual then
							valor_periodo = replace(Html.Encode(obj_f.a_anos_8),",",".")
							response.Write(","+valor_periodo)
						end if 
						if anio_registro + 9 <=  v_anio_actual then
							valor_periodo = replace(Html.Encode(obj_f.a_anos_9),",",".")
							response.Write(","+valor_periodo)
						end if 
						if anio_registro + 10 <=  v_anio_actual then
							valor_periodo = replace(Html.Encode(obj_f.a_anos_10),",",".")
							response.Write(","+valor_periodo)
						end if 
						if anio_registro + 11 <=  v_anio_actual then
							valor_periodo = replace(Html.Encode(obj_f.a_anos_11),",",".")
							response.Write(","+valor_periodo)
						end if 
						if anio_registro + 12 <=  v_anio_actual then
							valor_periodo = replace(Html.Encode(obj_f.a_anos_12),",",".")
							response.Write(","+valor_periodo)
						end if 
						if anio_registro + 13 <=  v_anio_actual then
							valor_periodo = replace(Html.Encode(obj_f.a_anos_13),",",".")
							response.Write(","+valor_periodo)
						end if 
						response.Write("]")
					end if
				   next%>
        ]);
	  
	  //Para Jornada
	  var data_Jornada = google.visualization.arrayToDataTable([
          ['Cohorte','Jornada','Matr. Cohorte'
		   <%if maximo_anio + 1 <=  v_anio_actual then  response.Write(",'Año N°2'")  end if%>
		   <%if maximo_anio + 2 <=  v_anio_actual then  response.Write(",'Año N°3'")  end if%>
		   <%if maximo_anio + 3 <=  v_anio_actual then  response.Write(",'Año N°4'")  end if%>
		   <%if maximo_anio + 4 <=  v_anio_actual then  response.Write(",'Año N°5'")  end if%>
		   <%if maximo_anio + 5 <=  v_anio_actual then  response.Write(",'Año N°6'")  end if%>
		   <%if maximo_anio + 6 <=  v_anio_actual then  response.Write(",'Año N°7'")  end if%>
		   <%if maximo_anio + 7 <=  v_anio_actual then  response.Write(",'Año N°8'")  end if%>
		   <%if maximo_anio + 8 <=  v_anio_actual then  response.Write(",'Año N°9'")  end if%>
		   <%if maximo_anio + 9 <=  v_anio_actual then  response.Write(",'Año N°10'")  end if%>
		   <%if maximo_anio + 10 <=  v_anio_actual then  response.Write(",'Año N°11'")  end if%>
		   <%if maximo_anio + 11 <=  v_anio_actual then  response.Write(",'Año N°12'")  end if%>
		   <%if maximo_anio + 12 <=  v_anio_actual then  response.Write(",'Año N°13'")  end if%>
		   <%if maximo_anio + 13 <=  v_anio_actual then  response.Write(",'Año N°14'")  end if%>
		 ]
		   <%     cadena = ""
				  jorn_seleccionada = ""
                  For each obj_j in ModelJornada.Items
				    cabe = Html.Encode(obj_j.cabecera)
					anio_registro = Html.Encode(obj_j.a_anos)
					if anio_registro = maximo_anio then
						'IF jorn_seleccionada = "" THEN 
						'	jorn_seleccionada = cabe
						'END IF
                        response.Write(",['"+anio_registro+"','"+cabe+"',"+replace(Html.Encode(obj_j.a_anos_0),",","."))
						if anio_registro + 1 <=  v_anio_actual then
							valor_periodo = replace(Html.Encode(obj_j.a_anos_1),",",".")
							response.Write(","+valor_periodo)
						end if 
						if anio_registro + 2 <=  v_anio_actual then
							valor_periodo = replace(Html.Encode(obj_j.a_anos_2),",",".")
							response.Write(","+valor_periodo)
						end if 
						if anio_registro + 3 <=  v_anio_actual then
							valor_periodo = replace(Html.Encode(obj_j.a_anos_3),",",".")
							response.Write(","+valor_periodo)
						end if 
						if anio_registro + 4 <=  v_anio_actual then
							valor_periodo = replace(Html.Encode(obj_j.a_anos_4),",",".")
							response.Write(","+valor_periodo)
						end if 
						if anio_registro + 5 <=  v_anio_actual then
							valor_periodo = replace(Html.Encode(obj_j.a_anos_5),",",".")
							response.Write(","+valor_periodo)
						end if 
						if anio_registro + 6 <=  v_anio_actual then
							valor_periodo = replace(Html.Encode(obj_j.a_anos_6),",",".")
							response.Write(","+valor_periodo)
						end if 
						if anio_registro + 7 <=  v_anio_actual then
							valor_periodo = replace(Html.Encode(obj_j.a_anos_7),",",".")
							response.Write(","+valor_periodo)
						end if 
						if anio_registro + 8 <=  v_anio_actual then
							valor_periodo = replace(Html.Encode(obj_j.a_anos_8),",",".")
							response.Write(","+valor_periodo)
						end if 
						if anio_registro + 9 <=  v_anio_actual then
							valor_periodo = replace(Html.Encode(obj_j.a_anos_9),",",".")
							response.Write(","+valor_periodo)
						end if 
						if anio_registro + 10 <=  v_anio_actual then
							valor_periodo = replace(Html.Encode(obj_j.a_anos_10),",",".")
							response.Write(","+valor_periodo)
						end if 
						if anio_registro + 11 <=  v_anio_actual then
							valor_periodo = replace(Html.Encode(obj_j.a_anos_11),",",".")
							response.Write(","+valor_periodo)
						end if 
						if anio_registro + 12 <=  v_anio_actual then
							valor_periodo = replace(Html.Encode(obj_j.a_anos_12),",",".")
							response.Write(","+valor_periodo)
						end if 
						if anio_registro + 13 <=  v_anio_actual then
							valor_periodo = replace(Html.Encode(obj_j.a_anos_13),",",".")
							response.Write(","+valor_periodo)
						end if 
						response.Write("]")
					end if
				   next%>
        ]);
	  
	  //Para Carrera
	  var data_Carrera = google.visualization.arrayToDataTable([
          ['Cohorte','Carrera','Matr. Cohorte'
		   <%if maximo_anio + 1 <=  v_anio_actual then  response.Write(",'Año N°2'")  end if%>
		   <%if maximo_anio + 2 <=  v_anio_actual then  response.Write(",'Año N°3'")  end if%>
		   <%if maximo_anio + 3 <=  v_anio_actual then  response.Write(",'Año N°4'")  end if%>
		   <%if maximo_anio + 4 <=  v_anio_actual then  response.Write(",'Año N°5'")  end if%>
		   <%if maximo_anio + 5 <=  v_anio_actual then  response.Write(",'Año N°6'")  end if%>
		   <%if maximo_anio + 6 <=  v_anio_actual then  response.Write(",'Año N°7'")  end if%>
		   <%if maximo_anio + 7 <=  v_anio_actual then  response.Write(",'Año N°8'")  end if%>
		   <%if maximo_anio + 8 <=  v_anio_actual then  response.Write(",'Año N°9'")  end if%>
		   <%if maximo_anio + 9 <=  v_anio_actual then  response.Write(",'Año N°10'")  end if%>
		   <%if maximo_anio + 10 <=  v_anio_actual then  response.Write(",'Año N°11'")  end if%>
		   <%if maximo_anio + 11 <=  v_anio_actual then  response.Write(",'Año N°12'")  end if%>
		   <%if maximo_anio + 12 <=  v_anio_actual then  response.Write(",'Año N°13'")  end if%>
		   <%if maximo_anio + 13 <=  v_anio_actual then  response.Write(",'Año N°14'")  end if%>
		 ]
		   <%     cadena = ""
				  carr_seleccionada = ""
                  For each obj_c in ModelCarrera.Items
				    cabe = Html.Encode(obj_c.cabecera)
					anio_registro = Html.Encode(obj_c.a_anos)
					if anio_registro = maximo_anio then
						IF carr_seleccionada = "" THEN 
							carr_seleccionada = cabe
						END IF
                        response.Write(",['"+anio_registro+"','"+cabe+"',"+replace(Html.Encode(obj_c.a_anos_0),",","."))
						if anio_registro + 1 <=  v_anio_actual then
							valor_periodo = replace(Html.Encode(obj_c.a_anos_1),",",".")
							response.Write(","+valor_periodo)
						end if 
						if anio_registro + 2 <=  v_anio_actual then
							valor_periodo = replace(Html.Encode(obj_c.a_anos_2),",",".")
							response.Write(","+valor_periodo)
						end if 
						if anio_registro + 3 <=  v_anio_actual then
							valor_periodo = replace(Html.Encode(obj_c.a_anos_3),",",".")
							response.Write(","+valor_periodo)
						end if 
						if anio_registro + 4 <=  v_anio_actual then
							valor_periodo = replace(Html.Encode(obj_c.a_anos_4),",",".")
							response.Write(","+valor_periodo)
						end if 
						if anio_registro + 5 <=  v_anio_actual then
							valor_periodo = replace(Html.Encode(obj_c.a_anos_5),",",".")
							response.Write(","+valor_periodo)
						end if 
						if anio_registro + 6 <=  v_anio_actual then
							valor_periodo = replace(Html.Encode(obj_c.a_anos_6),",",".")
							response.Write(","+valor_periodo)
						end if 
						if anio_registro + 7 <=  v_anio_actual then
							valor_periodo = replace(Html.Encode(obj_c.a_anos_7),",",".")
							response.Write(","+valor_periodo)
						end if 
						if anio_registro + 8 <=  v_anio_actual then
							valor_periodo = replace(Html.Encode(obj_c.a_anos_8),",",".")
							response.Write(","+valor_periodo)
						end if 
						if anio_registro + 9 <=  v_anio_actual then
							valor_periodo = replace(Html.Encode(obj_c.a_anos_9),",",".")
							response.Write(","+valor_periodo)
						end if 
						if anio_registro + 10 <=  v_anio_actual then
							valor_periodo = replace(Html.Encode(obj_c.a_anos_10),",",".")
							response.Write(","+valor_periodo)
						end if 
						if anio_registro + 11 <=  v_anio_actual then
							valor_periodo = replace(Html.Encode(obj_c.a_anos_11),",",".")
							response.Write(","+valor_periodo)
						end if 
						if anio_registro + 12 <=  v_anio_actual then
							valor_periodo = replace(Html.Encode(obj_c.a_anos_12),",",".")
							response.Write(","+valor_periodo)
						end if 
						if anio_registro + 13 <=  v_anio_actual then
							valor_periodo = replace(Html.Encode(obj_c.a_anos_13),",",".")
							response.Write(","+valor_periodo)
						end if 
						response.Write("]")
					end if
				   next%>
        ]);
		
		//Para Carrera Detalle
	  var data_CarreraDetalle = google.visualization.arrayToDataTable([
          ['Cohorte','Carrera','Detalle','Matr. Cohorte'
		   <%if maximo_anio + 1 <=  v_anio_actual then  response.Write(",'Año N°2'")  end if%>
		   <%if maximo_anio + 2 <=  v_anio_actual then  response.Write(",'Año N°3'")  end if%>
		   <%if maximo_anio + 3 <=  v_anio_actual then  response.Write(",'Año N°4'")  end if%>
		   <%if maximo_anio + 4 <=  v_anio_actual then  response.Write(",'Año N°5'")  end if%>
		   <%if maximo_anio + 5 <=  v_anio_actual then  response.Write(",'Año N°6'")  end if%>
		   <%if maximo_anio + 6 <=  v_anio_actual then  response.Write(",'Año N°7'")  end if%>
		   <%if maximo_anio + 7 <=  v_anio_actual then  response.Write(",'Año N°8'")  end if%>
		   <%if maximo_anio + 8 <=  v_anio_actual then  response.Write(",'Año N°9'")  end if%>
		   <%if maximo_anio + 9 <=  v_anio_actual then  response.Write(",'Año N°10'")  end if%>
		   <%if maximo_anio + 10 <=  v_anio_actual then  response.Write(",'Año N°11'")  end if%>
		   <%if maximo_anio + 11 <=  v_anio_actual then  response.Write(",'Año N°12'")  end if%>
		   <%if maximo_anio + 12 <=  v_anio_actual then  response.Write(",'Año N°13'")  end if%>
		   <%if maximo_anio + 13 <=  v_anio_actual then  response.Write(",'Año N°14'")  end if%>
		 ]
		   <%     cadena = ""
                  For each obj_cd in ModelCarreraDetalle.Items
				    cabe = Html.Encode(obj_cd.cabecera)
					deta = Html.Encode(obj_cd.detalle)
					anio_registro = Html.Encode(obj_cd.a_anos)
					if anio_registro = maximo_anio then
                        response.Write(",['"+anio_registro+"','"+cabe+"','"+deta+"',"+Html.Encode(obj_cd.a_anos_0))
						if anio_registro + 1 <=  v_anio_actual then
							valor_periodo = replace(Html.Encode(obj_cd.a_anos_1),",",".")
							IF LEN(valor_periodo) = 0 THEN
								valor_periodo = "0"
							END IF
							response.Write(","+valor_periodo)
						end if 
						if anio_registro + 2 <=  v_anio_actual then
							valor_periodo = replace(Html.Encode(obj_cd.a_anos_2),",",".")
							IF LEN(valor_periodo) = 0 THEN
								valor_periodo = "0"
							END IF
							response.Write(","+valor_periodo)
						end if 
						if anio_registro + 3 <=  v_anio_actual then
							valor_periodo = replace(Html.Encode(obj_cd.a_anos_3),",",".")
							IF LEN(valor_periodo) = 0 THEN
								valor_periodo = "0"
							END IF
							response.Write(","+valor_periodo)
						end if 
						if anio_registro + 4 <=  v_anio_actual then
							valor_periodo = replace(Html.Encode(obj_cd.a_anos_4),",",".")
							IF LEN(valor_periodo) = 0 THEN
								valor_periodo = "0"
							END IF
							response.Write(","+valor_periodo)
						end if 
						if anio_registro + 5 <=  v_anio_actual then
							valor_periodo = replace(Html.Encode(obj_cd.a_anos_5),",",".")
							IF LEN(valor_periodo) = 0 THEN
								valor_periodo = "0"
							END IF
							response.Write(","+valor_periodo)
						end if 
						if anio_registro + 6 <=  v_anio_actual then
							valor_periodo = replace(Html.Encode(obj_cd.a_anos_6),",",".")
							IF LEN(valor_periodo) = 0 THEN
								valor_periodo = "0"
							END IF
							response.Write(","+valor_periodo)
						end if 
						if anio_registro + 7 <=  v_anio_actual then
							valor_periodo = replace(Html.Encode(obj_cd.a_anos_7),",",".")
							IF LEN(valor_periodo) = 0 THEN
								valor_periodo = "0"
							END IF
							response.Write(","+valor_periodo)
						end if 
						if anio_registro + 8 <=  v_anio_actual then
							valor_periodo = replace(Html.Encode(obj_cd.a_anos_8),",",".")
							IF LEN(valor_periodo) = 0 THEN
								valor_periodo = "0"
							END IF
							response.Write(","+valor_periodo)
						end if 
						if anio_registro + 9 <=  v_anio_actual then
							valor_periodo = replace(Html.Encode(obj_cd.a_anos_9),",",".")
							IF LEN(valor_periodo) = 0 THEN
								valor_periodo = "0"
							END IF
							response.Write(","+valor_periodo)
						end if 
						if anio_registro + 10 <=  v_anio_actual then
							valor_periodo = replace(Html.Encode(obj_cd.a_anos_10),",",".")
							response.Write(","+valor_periodo)
						end if 
						if anio_registro + 11 <=  v_anio_actual then
							valor_periodo = replace(Html.Encode(obj_cd.a_anos_11),",",".")
							IF LEN(valor_periodo) = 0 THEN
								valor_periodo = "0"
							END IF
							response.Write(","+valor_periodo)
						end if 
						if anio_registro + 12 <=  v_anio_actual then
							valor_periodo = replace(Html.Encode(obj_cd.a_anos_12),",",".")
							IF LEN(valor_periodo) = 0 THEN
								valor_periodo = "0"
							END IF
							response.Write(","+valor_periodo)
						end if 
						if anio_registro + 13 <=  v_anio_actual then
							valor_periodo = replace(Html.Encode(obj_cd.a_anos_13),",",".")
							IF LEN(valor_periodo) = 0 THEN
								valor_periodo = "0"
							END IF
							response.Write(","+valor_periodo)
						end if 
						response.Write("]")
					end if
				   next%>
        ]);
	  
       var periodoPicker = new google.visualization.ControlWrapper({
          'controlType': 'CategoryFilter',
          'containerId': 'control2',
          'options': {
            'filterColumnLabel': 'Sede',
			'ui': {
              'labelStacking': 'horizontal',
              'allowTyping': false,
              'allowMultiple': false
            }
          },
		// Define an initial state, i.e. a set of metrics to be initially selected.
		  'state': {'selectedValues': ['<%=sede_seleccionada%>']}
        });
		
		var periodoPickerFacultad = new google.visualization.ControlWrapper({
          'controlType': 'CategoryFilter',
          'containerId': 'controlF',
          'options': {
            'filterColumnLabel': 'Facultad',
			'ui': {
              'labelStacking': 'horizontal',
              'allowTyping': false,
              'allowMultiple': false
            }
          },
		// Define an initial state, i.e. a set of metrics to be initially selected.
		  'state': {'selectedValues': ['<%=facu_seleccionada%>']}
        });
		
		var periodoPickerJornada = new google.visualization.ControlWrapper({
          'controlType': 'CategoryFilter',
          'containerId': 'controlJ',
          'options': {
            'filterColumnLabel': 'Jornada',
			'ui': {
              'labelStacking': 'horizontal',
              'allowTyping': false,
              'allowMultiple': false
            }
          },
		// Define an initial state, i.e. a set of metrics to be initially selected.
		  'state': {'selectedValues': ['<%=jorn_seleccionada%>']}
        });
		
		var carreraPickerCarrera = new google.visualization.ControlWrapper({
          'controlType': 'CategoryFilter',
          'containerId': 'controlC',
          'options': {
            'filterColumnLabel': 'Carrera',
			'ui': {
              'labelStacking': 'horizontal',
              'allowTyping': false,
              'allowMultiple': false
            }
          },
		// Define an initial state, i.e. a set of metrics to be initially selected.
		  'state': {'selectedValues': ['<%=carr_seleccionada%>']}
        });
		
		var carreraPickerCarreraD = new google.visualization.ControlWrapper({
          'controlType': 'CategoryFilter',
          'containerId': 'controlCD',
          'options': {
            'filterColumnLabel': 'Carrera',
			'ui': {
              'labelStacking': 'horizontal',
              'allowTyping': false,
              'allowMultiple': false
            }
          },
		// Define an initial state, i.e. a set of metrics to be initially selected.
		  'state': {'selectedValues': ['<%=carr_seleccionada%>']}
        });
      
        // Define a bar chart to show 'Population' data
        var ColumnChartSede = new google.visualization.ChartWrapper({
          'chartType': 'BarChart',
          'containerId': 'chart1',
          'options': {
            'width': 300,
            'height': 290,
			'legend': 'none',
			//'isStacked': true,
			'colors':['#6fa9ce','#ffe799','#fa7874','#90c7a0','#eda64d','#1998cc','#f1f25a','#79ce5b','#859da9','#6163f1','#54ee97','#4640f8','#ff4040'],
            'chartArea': {top: 0, right: 0, bottom: 0}
          },
          // Configure the barchart to use columns 2 (City) and 3 (Population)
          'view': {'columns': [1,2
		            <%if maximo_anio + 1 <=  v_anio_actual then  response.Write(",3")  end if%>
				    <%if maximo_anio + 2 <=  v_anio_actual then  response.Write(",4")  end if%>
				    <%if maximo_anio + 3 <=  v_anio_actual then  response.Write(",5")  end if%>
				    <%if maximo_anio + 4 <=  v_anio_actual then  response.Write(",6")  end if%>
				    <%if maximo_anio + 5 <=  v_anio_actual then  response.Write(",7")  end if%>
				    <%if maximo_anio + 6 <=  v_anio_actual then  response.Write(",8")  end if%>
				    <%if maximo_anio + 7 <=  v_anio_actual then  response.Write(",9")  end if%>
				    <%if maximo_anio + 8 <=  v_anio_actual then  response.Write(",10")  end if%>
				    <%if maximo_anio + 9 <=  v_anio_actual then  response.Write(",11")  end if%>
				    <%if maximo_anio + 10 <=  v_anio_actual then  response.Write(",12")  end if%>
				    <%if maximo_anio + 11 <=  v_anio_actual then  response.Write(",13")  end if%>
				    <%if maximo_anio + 12 <=  v_anio_actual then  response.Write(",14")  end if%>
				    <%if maximo_anio + 13 <=  v_anio_actual then  response.Write(",15")  end if%>
		          ]}
        });
		
		var ColumnChartFacultad = new google.visualization.ChartWrapper({
          'chartType': 'BarChart',
          'containerId': 'chartF',
          'options': {
            'width': 300,
            'height': 290,
			'legend': 'none',
			//'isStacked': true,
			'colors':['#6fa9ce','#ffe799','#fa7874','#90c7a0','#eda64d','#1998cc','#f1f25a','#79ce5b','#859da9','#6163f1','#54ee97','#4640f8','#ff4040'],
            'chartArea': {top: 0, right: 0, bottom: 0}
          },
          // Configure the barchart to use columns 2 (City) and 3 (Population)
          'view': {'columns': [1,2
		   			<%if maximo_anio + 1 <=  v_anio_actual then  response.Write(",3")  end if%>
				    <%if maximo_anio + 2 <=  v_anio_actual then  response.Write(",4")  end if%>
				    <%if maximo_anio + 3 <=  v_anio_actual then  response.Write(",5")  end if%>
				    <%if maximo_anio + 4 <=  v_anio_actual then  response.Write(",6")  end if%>
				    <%if maximo_anio + 5 <=  v_anio_actual then  response.Write(",7")  end if%>
				    <%if maximo_anio + 6 <=  v_anio_actual then  response.Write(",8")  end if%>
				    <%if maximo_anio + 7 <=  v_anio_actual then  response.Write(",9")  end if%>
				    <%if maximo_anio + 8 <=  v_anio_actual then  response.Write(",10")  end if%>
				    <%if maximo_anio + 9 <=  v_anio_actual then  response.Write(",11")  end if%>
				    <%if maximo_anio + 10 <=  v_anio_actual then  response.Write(",12")  end if%>
				    <%if maximo_anio + 11 <=  v_anio_actual then  response.Write(",13")  end if%>
				    <%if maximo_anio + 12 <=  v_anio_actual then  response.Write(",14")  end if%>
				    <%if maximo_anio + 13 <=  v_anio_actual then  response.Write(",15")  end if%> 
		         ]}
		});
		
		var AreaChartJornada = new google.visualization.ChartWrapper({
          'chartType': 'BarChart',
          'containerId': 'chartJ',
          'options': {
            'width': 300,
            'height': 290,
			'legend': 'none',
			//'isStacked': true,
			'colors':['#6fa9ce','#ffe799','#fa7874','#90c7a0','#eda64d','#1998cc','#f1f25a','#79ce5b','#859da9','#6163f1','#54ee97','#4640f8','#ff4040'],
            'chartArea': {top: 0, right: 0, bottom: 0}
          },
          'view': {'columns': [1,2
		  			<%if maximo_anio + 1 <=  v_anio_actual then  response.Write(",3")  end if%>
				    <%if maximo_anio + 2 <=  v_anio_actual then  response.Write(",4")  end if%>
				    <%if maximo_anio + 3 <=  v_anio_actual then  response.Write(",5")  end if%>
				    <%if maximo_anio + 4 <=  v_anio_actual then  response.Write(",6")  end if%>
				    <%if maximo_anio + 5 <=  v_anio_actual then  response.Write(",7")  end if%>
				    <%if maximo_anio + 6 <=  v_anio_actual then  response.Write(",8")  end if%>
				    <%if maximo_anio + 7 <=  v_anio_actual then  response.Write(",9")  end if%>
				    <%if maximo_anio + 8 <=  v_anio_actual then  response.Write(",10")  end if%>
				    <%if maximo_anio + 9 <=  v_anio_actual then  response.Write(",11")  end if%>
				    <%if maximo_anio + 10 <=  v_anio_actual then  response.Write(",12")  end if%>
				    <%if maximo_anio + 11 <=  v_anio_actual then  response.Write(",13")  end if%>
				    <%if maximo_anio + 12 <=  v_anio_actual then  response.Write(",14")  end if%>
				    <%if maximo_anio + 13 <=  v_anio_actual then  response.Write(",15")  end if%>
				]}	
        });

         var ColumnChartCarrera = new google.visualization.ChartWrapper({
          'chartType': 'ColumnChart',
          'containerId': 'chartC',
          'options': {
            'width': 280,
            'height': 280,
			'legend': 'none',
			'colors':['#6fa9ce','#ffe799','#fa7874','#90c7a0','#eda64d','#1998cc','#f1f25a','#79ce5b','#859da9','#6163f1','#54ee97','#4640f8','#ff4040'],
            'chartArea': {top: 0, right: 0, bottom: 0}
          },
          // Configure the barchart to use columns 2 (City) and 3 (Population)
          'view': {'columns': [0,2
		            <%if maximo_anio + 1 <=  v_anio_actual then  response.Write(",3")  end if%>
				    <%if maximo_anio + 2 <=  v_anio_actual then  response.Write(",4")  end if%>
				    <%if maximo_anio + 3 <=  v_anio_actual then  response.Write(",5")  end if%>
				    <%if maximo_anio + 4 <=  v_anio_actual then  response.Write(",6")  end if%>
				    <%if maximo_anio + 5 <=  v_anio_actual then  response.Write(",7")  end if%>
				    <%if maximo_anio + 6 <=  v_anio_actual then  response.Write(",8")  end if%>
				    <%if maximo_anio + 7 <=  v_anio_actual then  response.Write(",9")  end if%>
				    <%if maximo_anio + 8 <=  v_anio_actual then  response.Write(",10")  end if%>
				    <%if maximo_anio + 9 <=  v_anio_actual then  response.Write(",11")  end if%>
				    <%if maximo_anio + 10 <=  v_anio_actual then  response.Write(",12")  end if%>
				    <%if maximo_anio + 11 <=  v_anio_actual then  response.Write(",13")  end if%>
				    <%if maximo_anio + 12 <=  v_anio_actual then  response.Write(",14")  end if%>
				    <%if maximo_anio + 13 <=  v_anio_actual then  response.Write(",15")  end if%>
		  ]}
        });
	   
	    // Define a table
        var table_sede = new google.visualization.ChartWrapper({
          'chartType': 'Table',
          'containerId': 'tableS',
          'options': {
              'width': '95%',
			  'page' : 'enable',
			  'pageSize' : '3'
          }
        });
		var table_facu = new google.visualization.ChartWrapper({
          'chartType': 'Table',
          'containerId': 'tableF',
          'options': {
			  'width': '95%',
			  'page' : 'enable',
			  'pageSize' : '3'
          }
        });
		var table_jorn = new google.visualization.ChartWrapper({
          'chartType': 'Table',
          'containerId': 'tableJ',
          'options': {
              'width': '95%',
			  'page' : 'enable',
			  'pageSize' : '3'
          }
        });
		
		var table_carr = new google.visualization.ChartWrapper({
          'chartType': 'Table',
          'containerId': 'tableC',
          'options': {
               'width': '95%',
			   'page' : 'enable',
			   'pageSize' : '8'
          }
        });
		
		var table_carr_det = new google.visualization.ChartWrapper({
          'chartType': 'Table',
          'containerId': 'tableCD',
          'options': {
               'width': '95%',
			   'page' : 'enable',
			   'pageSize' : '2'
          },
		  'view': {'columns': [0,2,3
		            <%if maximo_anio + 1 <=  v_anio_actual then  response.Write(",4")  end if%>
				    <%if maximo_anio + 2 <=  v_anio_actual then  response.Write(",5")  end if%>
				    <%if maximo_anio + 3 <=  v_anio_actual then  response.Write(",6")  end if%>
				    <%if maximo_anio + 4 <=  v_anio_actual then  response.Write(",7")  end if%>
				    <%if maximo_anio + 5 <=  v_anio_actual then  response.Write(",8")  end if%>
				    <%if maximo_anio + 6 <=  v_anio_actual then  response.Write(",9")  end if%>
				    <%if maximo_anio + 7 <=  v_anio_actual then  response.Write(",10")  end if%>
				    <%if maximo_anio + 8 <=  v_anio_actual then  response.Write(",11")  end if%>
				    <%if maximo_anio + 9 <=  v_anio_actual then  response.Write(",12")  end if%>
				    <%if maximo_anio + 10 <=  v_anio_actual then  response.Write(",13")  end if%>
				    <%if maximo_anio + 11 <=  v_anio_actual then  response.Write(",14")  end if%>
				    <%if maximo_anio + 12 <=  v_anio_actual then  response.Write(",15")  end if%>
					<%if maximo_anio + 13 <=  v_anio_actual then  response.Write(",16")  end if%>
		  ]}
        });
		
	      
        // Create the dashboard.
        new google.visualization.Dashboard(document.getElementById('dashboard')).
		  bind(periodoPicker, [ColumnChartSede,table_sede]).		  
          draw(data);
		  
		//new google.visualization.Dashboard(document.getElementById('dashboardFacultad')).
		//  bind(periodoPickerFacultad, [ColumnChartFacultad,table_facu]).		  
        //  draw(data_Facultad);  
		  
		new google.visualization.Dashboard(document.getElementById('dashboardJornada')).
		  bind(periodoPickerJornada, [AreaChartJornada,table_jorn]).		  
          draw(data_Jornada);
		  
		new google.visualization.Dashboard(document.getElementById('dashboardCarrera')).
		  bind(carreraPickerCarrera, [ColumnChartCarrera,table_carr]).		  
          draw(data_Carrera);
		
		new google.visualization.Dashboard(document.getElementById('dashboardCarreraDetalle')).
		  bind(carreraPickerCarreraD, [table_carr_det]).		  
          draw(data_CarreraDetalle);
		    
      }
      google.setOnLoadCallback(drawVisualization);
    </script>
     <!-- <div class='GridViewScrollContainer'>-->
     <div id="cuadro0">
     <br />
     <h1>Tasa de Retención de la Cohorte</h1>
     <p><i>"Cantidad porcentual alumnos matriculados a primer año de la carrera para la cohorte ingresada".</i></p> 
     <div id="titulo1" class="titulo">
     Filtros
     <input name="imagefield" type="image" src="Content/minimizar.jpg" onclick="minimizar('capa1')"/>
     <input name="imagefield" type="image" src="Content/encuadre.jpg" onclick="maximizar('capa1')"/>
     <input name="imagefield" type="image" src="Content/cerrar.jpg" style="margin-right:3px;" onclick="minimizar('capa1');minimizar('titulo1')"/>
     </div>
     <div id="capa1">
               <form name="formu_anos" target="_self" method="post">
               <input type="hidden" name="inicial" value="0" />
               <table width="90%" align="center">
                    <tr valign="top">
                        <td colspan="13"><H3 class="shad">Seleccione año a consultar</H3></td>
                    </tr>
                    <tr>
                        <td align="center"><input type="radio" name="anio_consulta" value="2000" <%=chequeo_2000%> onchange="document.formu_anos.submit();" ></td>
                        <td align="center"><input type="radio" name="anio_consulta" value="2001" <%=chequeo_2001%> onchange="document.formu_anos.submit();" ></td>
                        <td align="center"><input type="radio" name="anio_consulta" value="2002" <%=chequeo_2002%> onchange="document.formu_anos.submit();" ></td>
                        <td align="center"><input type="radio" name="anio_consulta" value="2003" <%=chequeo_2003%> onchange="document.formu_anos.submit();" ></td>
                        <td align="center"><input type="radio" name="anio_consulta" value="2004" <%=chequeo_2004%> onchange="document.formu_anos.submit();" ></td>
                        <td align="center"><input type="radio" name="anio_consulta" value="2005" <%=chequeo_2005%> onchange="document.formu_anos.submit();" ></td>
                        <td align="center"><input type="radio" name="anio_consulta" value="2006" <%=chequeo_2006%> onchange="document.formu_anos.submit();" ></td>
                        <td align="center"><input type="radio" name="anio_consulta" value="2007" <%=chequeo_2007%> onchange="document.formu_anos.submit();" ></td>
                        <td align="center"><input type="radio" name="anio_consulta" value="2008" <%=chequeo_2008%> onchange="document.formu_anos.submit();" ></td>
                        <td align="center"><input type="radio" name="anio_consulta" value="2009" <%=chequeo_2009%> onchange="document.formu_anos.submit();" ></td>
                        <td align="center"><input type="radio" name="anio_consulta" value="2010" <%=chequeo_2010%> onchange="document.formu_anos.submit();" ></td>
                        <td align="center"><input type="radio" name="anio_consulta" value="2011" <%=chequeo_2011%> onchange="document.formu_anos.submit();" ></td>
                        <td align="center"><input type="radio" name="anio_consulta" value="2012" <%=chequeo_2012%> onchange="document.formu_anos.submit();" ></td>
						<td align="center"><input type="radio" name="anio_consulta" value="2013" <%=chequeo_2013%> onchange="document.formu_anos.submit();" ></td>
                    </tr>
                    <tr>
                        <td align="center"><font color="#999999">2000</font></td>
                        <td align="center"><font color="#999999">2001</font></td>
                        <td align="center"><font color="#999999">2002</font></td>
                        <td align="center"><font color="#999999">2003</font></td>
                        <td align="center"><font color="#999999">2004</font></td>
                        <td align="center"><font color="#999999">2005</font></td>
                        <td align="center"><font color="#999999">2006</font></td>
                        <td align="center"><font color="#999999">2007</font></td>
                        <td align="center"><font color="#999999">2008</font></td>
                        <td align="center"><font color="#999999">2009</font></td>
                        <td align="center"><font color="#999999">2010</font></td>
                        <td align="center"><font color="#999999">2011</font></td>
                        <td align="center"><font color="#999999">2012</font></td>
						<td align="center"><font color="#999999">2013</font></td>
                    </tr>
                    <tr>
                    	<td colspan="13" align="right">
				            <%=Html.ActionLink("<div class='btn' align='right'>Obtener Excel</div>","RetencionCohorte","List_excel", "partial=excel"&complemento_url)%>
                            <%if session("_pers_ncorr_") = "0" then 
							   response.Write(Html.ActionLink("<div class='btn' align='right'>Detalle "&maximo_anio&"</div>","ExcelDetalleCohorteMat","List_excel", "partial=excel"&url_detalle))
							  end if
							%>
                        </td>	
                    </tr>
                    
               </table>
               </form>
     </div>
     <br />
     <div id="titulo2" class="titulo">
     Indicadores por Sede<!--, Facultad--> y Jornada
     <input name="imagefield" type="image" src="Content/minimizar.jpg" onclick="minimizar('capa2_dh')"/>
     <input name="imagefield" type="image" src="Content/encuadre.jpg" onclick="maximizar('capa2_dh')"/>
     <input name="imagefield" type="image" src="Content/cerrar.jpg" style="margin-right:3px;" onclick="minimizar('capa2_dh');minimizar('titulo2')"/>
     </div>
     <div id="capa2_dh">
         <div id="banner">  				
            <div class="oneByOne_item">     
                <div id="dashboard">
                  <table width="980">
                   <tr style='vertical-align: top'>
                      <td colspan="2" align="left" style='font-size: 0.8em;'>
                       <div id="control2" align="left"></div>
                      </td>
                   </tr>
                   <tr><td colspan="2">&nbsp;</td></tr>
                   <tr valign="top">
                       <td  width="65%" align="center" style='font-size: 0.6em;'>
                          <table width="100%">
                            <tr><td width="100%" align="center"><div id="tableS"  class="tabla"></div></td></tr>
                            <tr><td width="100%" align="center">&nbsp;</td></tr>
                            <tr>
                                <td width="100%" align="center">
                                	<table width="800" bgcolor="#FFFFFF" class="tabla">
                                        <tr>
                                          <td>&nbsp;</td>
                                          <td>&nbsp;</td>
                                          <td bgcolor="#6fa9ce">Cohorte</td>
                                          <%if maximo_anio + 1 <=  v_anio_actual then%>
                                          <td bgcolor="#ffe799">&nbsp;</td>
                                          <td><font size="2"><strong><%=maximo_anio + 1%></strong></font></td>
                                          <%end if%>
                                          <%if maximo_anio + 2 <=  v_anio_actual then%>
                                          <td bgcolor="#fa7874">&nbsp;</td>
                                          <td><font size="2"><strong><%=maximo_anio + 2%></strong></font></td>
                                          <%end if%>
                                          <%if maximo_anio + 3 <=  v_anio_actual then%>
                                          <td  bgcolor="#90c7a0">&nbsp;</td>
                                          <td><font size="2"><strong><%=maximo_anio + 3%></strong></font></td>
                                          <%end if%>
                                          <%if maximo_anio + 4 <=  v_anio_actual then%>
                                          <td bgcolor="#eda64d">&nbsp;</td>
                                          <td><font size="2"><strong><%=maximo_anio + 4%></strong></font></td>
                                          <%end if%>
                                          <%if maximo_anio + 5 <=  v_anio_actual then%>
                                          <td bgcolor="#1998cc">&nbsp;</td>
                                          <td><font size="2"><strong><%=maximo_anio + 5%></strong></font></td>
                                          <%end if%>
                                          <%if maximo_anio + 6 <=  v_anio_actual then%>
                                          <td bgcolor="#f1f25a">&nbsp;</td>
                                          <td><font size="2"><strong><%=maximo_anio + 6%></strong></font></td>
                                          <%end if%>
                                          <%if maximo_anio + 7 <=  v_anio_actual then%>
                                          <td bgcolor="#79ce5b">&nbsp;</td>
                                          <td><font size="2"><strong><%=maximo_anio + 7%></strong></font></td>
                                          <%end if%>
                                          <%if maximo_anio + 8 <=  v_anio_actual then%>
                                          <td bgcolor="#859da9">&nbsp;</td>
                                          <td><font size="2"><strong><%=maximo_anio + 8%></strong></font></td>
                                          <%end if%>
                                          <%if maximo_anio + 9 <=  v_anio_actual then%>
                                          <td bgcolor="#6163f1">&nbsp;</td>
                                          <td><font size="2"><strong><%=maximo_anio + 9%></strong></font></td>
                                          <%end if%>
                                          <%if maximo_anio + 10 <=  v_anio_actual then%>
                                          <td bgcolor="#54ee97">&nbsp;</td>
                                          <td><font size="2"><strong><%=maximo_anio + 10%></strong></font></td>
                                          <%end if%>
                                          <%if maximo_anio + 11 <=  v_anio_actual then%>
                                          <td bgcolor="#4640f8">&nbsp;</td>
                                          <td><font size="2"><strong><%=maximo_anio + 11%></strong></font></td>
                                          <%end if%>
                                          <%if maximo_anio + 12 <=  v_anio_actual then%>
                                          <td bgcolor="#ff4040">&nbsp;</td>
                                          <td><font size="2"><strong><%=maximo_anio + 12%></strong></font></td>
                                          <%end if%>
                                          <%if maximo_anio + 13 <=  v_anio_actual then%>
                                          <td bgcolor="#7fa3d6">&nbsp;</td>
                                          <td><font size="2"><strong><%=maximo_anio + 13%></strong></font></td>
                                          <%end if%>
                                        </tr>
                                
                                        <%
                                        Dim obj_tot_sede
                                        For each obj_tot_sede in ModelTotalSede.Items
										
										if maximo_anio = Html.Encode(obj_tot_sede.a_anos) then
                                        %>
                                        <tr>
                                          <td colspan="2"><div align="left"><font size="2"><strong><%=Html.Encode(obj_tot_sede.cabecera) %></strong></font></div></td>
                                          <td bgcolor="#6fa9ce"><div align="center"><font size="2"><strong><%=Html.Encode(obj_tot_sede.a_anos_0) %></strong></font></div></td>
                                          <%if maximo_anio + 1 <=  v_anio_actual then%>
                                          <td colspan="2" bgcolor="#ffe799"><font  size="2"><strong><%=Html.Encode(obj_tot_sede.a_anos_1) %></strong></font></td>
                                          <%end if%>
                                          <%if maximo_anio + 2 <=  v_anio_actual then%>
                                          <td colspan="2" bgcolor="#fa7874"><font  size="2"><strong><%=Html.Encode(obj_tot_sede.a_anos_2) %></strong></font></td>
                                          <%end if%>
                                          <%if maximo_anio + 3 <=  v_anio_actual then%>
                                          <td colspan="2" bgcolor="#90c7a0"><font  size="2"><strong><%=Html.Encode(obj_tot_sede.a_anos_3) %></strong></font></td>
                                          <%end if%>
                                          <%if maximo_anio + 4 <=  v_anio_actual then%>
                                          <td colspan="2" bgcolor="#eda64d"><font  size="2"><strong><%=Html.Encode(obj_tot_sede.a_anos_4) %></strong></font></td>
                                          <%end if%>
                                          <%if maximo_anio + 5 <=  v_anio_actual then%>
                                          <td colspan="2" bgcolor="#1998cc"><font  size="2"><strong><%=Html.Encode(obj_tot_sede.a_anos_5) %></strong></font></td>
                                          <%end if%>
                                          <%if maximo_anio + 6 <=  v_anio_actual then%>
                                          <td colspan="2" bgcolor="#f1f25a"><font  size="2"><strong><%=Html.Encode(obj_tot_sede.a_anos_6) %></strong></font></td>
                                          <%end if%>
                                          <%if maximo_anio + 7 <=  v_anio_actual then%>
                                          <td colspan="2" bgcolor="#79ce5b"><font  size="2"><strong><%=Html.Encode(obj_tot_sede.a_anos_7) %></strong></font></td>
                                          <%end if%>
                                          <%if maximo_anio + 8 <=  v_anio_actual then%>
                                          <td colspan="2" bgcolor="#859da9"><font  size="2"><strong><%=Html.Encode(obj_tot_sede.a_anos_8) %></strong></font></td>
                                          <%end if%>
                                          <%if maximo_anio + 9 <=  v_anio_actual then%>
                                          <td colspan="2" bgcolor="#6163f1"><font  size="2"><strong><%=Html.Encode(obj_tot_sede.a_anos_9) %></strong></font></td>
                                          <%end if%>
                                          <%if maximo_anio + 10 <=  v_anio_actual then%>
                                          <td colspan="2" bgcolor="#54ee97"><font  size="2"><strong><%=Html.Encode(obj_tot_sede.a_anos_10) %></strong></font></td>
                                          <%end if%>
                                          <%if maximo_anio + 11 <=  v_anio_actual then%>
                                          <td colspan="2" bgcolor="#4640f8"><font  size="2"><strong><%=Html.Encode(obj_tot_sede.a_anos_11) %></strong></font></td>
                                          <%end if%>
                                          <%if maximo_anio + 12 <=  v_anio_actual then%>
                                          <td colspan="2" bgcolor="#ff4040"><font  size="2"><strong><%=Html.Encode(obj_tot_sede.a_anos_12) %></strong></font></td>
                                          <%end if%>
                                          <%if maximo_anio + 13 <=  v_anio_actual then%>
                                          <td colspan="2" bgcolor="#7fa3d6"><font  size="2"><strong><%=Html.Encode(obj_tot_sede.a_anos_13) %></strong></font></td>
                                          <%end if%>
                                        </tr>
                                          <% 
										end if
                                        Next
                                          %>
                                   </table>
                                </td>
                            </tr> 
                          </table>     
                       </td>
                       <td  width="35%" align="center" style='font-size: 0.6em;'>
                            <div id="chart1"></div>
                       </td>
                   </tr>
                 </table>
               </div>   
            </div>
			<!--
            <div class="oneByOne_item">     
             <div id="dashboardFacultad">
                  <table width="980">
                   <tr style='vertical-align: top'>
                      <td colspan="2" align="left" style='font-size: 0.8em;'>
                       <div id="controlF" align="left"></div>
                      </td>
                   </tr>
                   <tr><td colspan="2">&nbsp;</td></tr>
                   <tr valign="top">
                       <td  width="65%" align="center" style='font-size: 0.6em;'>
                          <table width="100%">
                            <tr><td width="100%" align="center"><div id="tableF"  class="tabla"></div></td></tr>
                            <tr><td width="100%" align="center">&nbsp;</td></tr>
                            <tr>
                                <td width="100%" align="center">
                                	<table width="90%" bgcolor="#FFFFFF" class="tabla">
                                         <tr>
                                          <td>&nbsp;</td>
                                          <td>&nbsp;</td>
                                          <td bgcolor="#6fa9ce">Cohorte</td>
                                          <%if maximo_anio + 1 <=  v_anio_actual then%>
                                          <td width="18" height="18" bgcolor="#ffe799">&nbsp;</td>
                                          <td><font size="2"><strong><%=maximo_anio + 1%></strong></font></td>
                                          <%end if%>
                                          <%if maximo_anio + 2 <=  v_anio_actual then%>
                                          <td width="18" height="18" bgcolor="#fa7874">&nbsp;</td>
                                          <td><font size="2"><strong><%=maximo_anio + 2%></strong></font></td>
                                          <%end if%>
                                          <%if maximo_anio + 3 <=  v_anio_actual then%>
                                          <td width="18" height="18" bgcolor="#90c7a0">&nbsp;</td>
                                          <td><font size="2"><strong><%=maximo_anio + 3%></strong></font></td>
                                          <%end if%>
                                          <%if maximo_anio + 4 <=  v_anio_actual then%>
                                          <td width="18" height="18" bgcolor="#eda64d">&nbsp;</td>
                                          <td><font size="2"><strong><%=maximo_anio + 4%></strong></font></td>
                                          <%end if%>
                                          <%if maximo_anio + 5 <=  v_anio_actual then%>
                                          <td width="18" height="18" bgcolor="#1998cc">&nbsp;</td>
                                          <td><font size="2"><strong><%=maximo_anio + 5%></strong></font></td>
                                          <%end if%>
                                          <%if maximo_anio + 6 <=  v_anio_actual then%>
                                          <td width="18" height="18" bgcolor="#f1f25a">&nbsp;</td>
                                          <td><font size="2"><strong><%=maximo_anio + 6%></strong></font></td>
                                          <%end if%>
                                          <%if maximo_anio + 7 <=  v_anio_actual then%>
                                          <td width="18" height="18" bgcolor="#79ce5b">&nbsp;</td>
                                          <td><font size="2"><strong><%=maximo_anio + 7%></strong></font></td>
                                          <%end if%>
                                          <%if maximo_anio + 8 <=  v_anio_actual then%>
                                          <td width="18" height="18" bgcolor="#859da9">&nbsp;</td>
                                          <td><font size="2"><strong><%=maximo_anio + 8%></strong></font></td>
                                          <%end if%>
                                          <%if maximo_anio + 9 <=  v_anio_actual then%>
                                          <td width="18" height="18" bgcolor="#6163f1">&nbsp;</td>
                                          <td><font size="2"><strong><%=maximo_anio + 9%></strong></font></td>
                                          <%end if%>
                                          <%if maximo_anio + 10 <=  v_anio_actual then%>
                                          <td width="18" height="18" bgcolor="#54ee97">&nbsp;</td>
                                          <td><font size="2"><strong><%=maximo_anio + 10%></strong></font></td>
                                          <%end if%>
                                          <%if maximo_anio + 11 <=  v_anio_actual then%>
                                          <td width="18" height="18" bgcolor="#4640f8">&nbsp;</td>
                                          <td><font size="2"><strong><%=maximo_anio + 11%></strong></font></td>
                                          <%end if%>
                                          <%if maximo_anio + 12 <=  v_anio_actual then%>
                                          <td width="18" height="18" bgcolor="#ff4040">&nbsp;</td>
                                          <td><font size="2"><strong><%=maximo_anio + 12%></strong></font></td>
                                          <%end if%>
                                          <%if maximo_anio + 13 <=  v_anio_actual then%>
                                          <td width="18" height="18" bgcolor="#7fa3d6">&nbsp;</td>
                                          <td><font size="2"><strong><%=maximo_anio + 13%></strong></font></td>
                                          <%end if%>
                                        </tr>
                                
                                        <%
                                        Dim obj_tot_facu
                                        For each obj_tot_facu in ModelTotalFacultad.Items
										if maximo_anio = Html.Encode(obj_tot_facu.a_anos) then 
                                        %>
                                
                                        <tr>
                                          <td colspan="2"><div align="left"><font size="2"><strong><%=Html.Encode(obj_tot_facu.cabecera) %></strong></font></div></td>
                                          <td bgcolor="#6fa9ce"><div align="center"><font size="2"><strong><%=Html.Encode(obj_tot_facu.a_anos_0) %></strong></font></div></td>
                                          <%if maximo_anio + 1 <=  v_anio_actual then%>
                                          <td colspan="2" bgcolor="#ffe799"><font size="2"><strong><%=Html.Encode(obj_tot_facu.a_anos_1) %></strong></font></td>
                                          <%end if%>
                                          <%if maximo_anio + 2 <=  v_anio_actual then%>
                                          <td colspan="2" bgcolor="#fa7874"><font  size="2"><strong><%=Html.Encode(obj_tot_facu.a_anos_2) %></strong></font></td>
                                          <%end if%>
                                          <%if maximo_anio + 3 <=  v_anio_actual then%>
                                          <td colspan="2" bgcolor="#90c7a0"><font  size="2"><strong><%=Html.Encode(obj_tot_facu.a_anos_3) %></strong></font></td>
                                          <%end if%>
                                          <%if maximo_anio + 4 <=  v_anio_actual then%>
                                          <td colspan="2" bgcolor="#eda64d"><font  size="2"><strong><%=Html.Encode(obj_tot_facu.a_anos_4) %></strong></font></td>
                                          <%end if%>
                                          <%if maximo_anio + 5 <=  v_anio_actual then%>
                                          <td colspan="2" bgcolor="#1998cc"><font  size="2"><strong><%=Html.Encode(obj_tot_facu.a_anos_5) %></strong></font></td>
                                          <%end if%>
                                          <%if maximo_anio + 6 <=  v_anio_actual then%>
                                          <td colspan="2" bgcolor="#f1f25a"><font  size="2"><strong><%=Html.Encode(obj_tot_facu.a_anos_6) %></strong></font></td>
                                          <%end if%>
                                          <%if maximo_anio + 7 <=  v_anio_actual then%>
                                          <td colspan="2" bgcolor="#79ce5b"><font  size="2"><strong><%=Html.Encode(obj_tot_facu.a_anos_7) %></strong></font></td>
                                          <%end if%>
                                          <%if maximo_anio + 8 <=  v_anio_actual then%>
                                          <td colspan="2" bgcolor="#859da9"><font  size="2"><strong><%=Html.Encode(obj_tot_facu.a_anos_8) %></strong></font></td>
                                          <%end if%>
                                          <%if maximo_anio + 9 <=  v_anio_actual then%>
                                          <td colspan="2" bgcolor="#6163f1"><font  size="2"><strong><%=Html.Encode(obj_tot_facu.a_anos_9) %></strong></font></td>
                                          <%end if%>
                                          <%if maximo_anio + 10 <=  v_anio_actual then%>
                                          <td colspan="2" bgcolor="#54ee97"><font  size="2"><strong><%=Html.Encode(obj_tot_facu.a_anos_10) %></strong></font></td>
                                          <%end if%>
                                          <%if maximo_anio + 11 <=  v_anio_actual then%>
                                          <td colspan="2" bgcolor="#4640f8"><font  size="2"><strong><%=Html.Encode(obj_tot_facu.a_anos_11) %></strong></font></td>
                                          <%end if%>
                                          <%if maximo_anio + 12 <=  v_anio_actual then%>
                                          <td colspan="2" bgcolor="#ff4040"><font  size="2"><strong><%=Html.Encode(obj_tot_facu.a_anos_12) %></strong></font></td>
                                          <%end if%>
                                          <%if maximo_anio + 13 <=  v_anio_actual then%>
                                          <td colspan="2" bgcolor="#7fa3d6"><font  size="2"><strong><%=Html.Encode(obj_tot_facu.a_anos_13) %></strong></font></td>
                                          <%end if%>
                                        </tr>
                                          <% 
										end if
                                        Next
                                     %>
                                     </table>
                                </td>
                            </tr> 
                          </table>
                       </td>
                       <td  width="35%" align="center" style='font-size: 0.6em;'>
                            <div id="chartF"></div>
                       </td>
                   </tr>
                 </table>
                </div>  
            </div>
            -->
			<div class="oneByOne_item">                      
               <div id="dashboardJornada">
                  <table width="980">
                   <tr style='vertical-align: top'>
                      <td colspan="2" align="left" style='font-size: 0.8em;'>
                       <div id="controlJ" align="left"></div>
                      </td>
                   </tr>
                   <tr><td colspan="2">&nbsp;</td></tr>
                   <tr valign="top">
                       <td  width="65%" align="center" style='font-size: 0.6em;'>
                           <table width="100%">
                            <tr><td width="100%" align="center"><div id="tableJ"  class="tabla"></div></td></tr>
                            <tr><td width="100%" align="center">&nbsp;</td></tr>
                            <tr>
                                <td width="100%" align="center">
                                <table width="90%" bgcolor="#FFFFFF" class="tabla">
                                     <tr>
                                      <td>&nbsp;</td>
                                      <td>&nbsp;</td>
                                      <td bgcolor="#6fa9ce">Cohorte</td>
                                          <%if maximo_anio + 1 <=  v_anio_actual then%>
                                          <td width="18" height="18" bgcolor="#ffe799">&nbsp;</td>
                                          <td><font size="2"><strong><%=maximo_anio + 1%></strong></font></td>
                                          <%end if%>
                                          <%if maximo_anio + 2 <=  v_anio_actual then%>
                                          <td width="18" height="18" bgcolor="#fa7874">&nbsp;</td>
                                          <td><font size="2"><strong><%=maximo_anio + 2%></strong></font></td>
                                          <%end if%>
                                          <%if maximo_anio + 3 <=  v_anio_actual then%>
                                          <td width="18" height="18" bgcolor="#90c7a0">&nbsp;</td>
                                          <td><font size="2"><strong><%=maximo_anio + 3%></strong></font></td>
                                          <%end if%>
                                          <%if maximo_anio + 4 <=  v_anio_actual then%>
                                          <td width="18" height="18" bgcolor="#eda64d">&nbsp;</td>
                                          <td><font size="2"><strong><%=maximo_anio + 4%></strong></font></td>
                                          <%end if%>
                                          <%if maximo_anio + 5 <=  v_anio_actual then%>
                                          <td width="18" height="18" bgcolor="#1998cc">&nbsp;</td>
                                          <td><font size="2"><strong><%=maximo_anio + 5%></strong></font></td>
                                          <%end if%>
                                          <%if maximo_anio + 6 <=  v_anio_actual then%>
                                          <td width="18" height="18" bgcolor="#f1f25a">&nbsp;</td>
                                          <td><font size="2"><strong><%=maximo_anio + 6%></strong></font></td>
                                          <%end if%>
                                          <%if maximo_anio + 7 <=  v_anio_actual then%>
                                          <td width="18" height="18" bgcolor="#79ce5b">&nbsp;</td>
                                          <td><font size="2"><strong><%=maximo_anio + 7%></strong></font></td>
                                          <%end if%>
                                          <%if maximo_anio + 8 <=  v_anio_actual then%>
                                          <td width="18" height="18" bgcolor="#859da9">&nbsp;</td>
                                          <td><font size="2"><strong><%=maximo_anio + 8%></strong></font></td>
                                          <%end if%>
                                          <%if maximo_anio + 9 <=  v_anio_actual then%>
                                          <td width="18" height="18" bgcolor="#6163f1">&nbsp;</td>
                                          <td><font size="2"><strong><%=maximo_anio + 9%></strong></font></td>
                                          <%end if%>
                                          <%if maximo_anio + 10 <=  v_anio_actual then%>
                                          <td width="18" height="18" bgcolor="#54ee97">&nbsp;</td>
                                          <td><font size="2"><strong><%=maximo_anio + 10%></strong></font></td>
                                          <%end if%>
                                          <%if maximo_anio + 11 <=  v_anio_actual then%>
                                          <td width="18" height="18" bgcolor="#4640f8">&nbsp;</td>
                                          <td><font size="2"><strong><%=maximo_anio + 11%></strong></font></td>
                                          <%end if%>
                                          <%if maximo_anio + 12 <=  v_anio_actual then%>
                                          <td width="18" height="18" bgcolor="#ff4040">&nbsp;</td>
                                          <td><font size="2"><strong><%=maximo_anio + 12%></strong></font></td>
                                          <%end if%>
                                          <%if maximo_anio + 13 <=  v_anio_actual then%>
                                          <td width="18" height="18" bgcolor="#7fa3d6">&nbsp;</td>
                                          <td><font size="2"><strong><%=maximo_anio + 13%></strong></font></td>
                                          <%end if%>
                                    </tr>
                            
                                    <%
                                    Dim obj_tot_jorn
                                    For each obj_tot_jorn in ModelTotalJornada.Items
									if maximo_anio = Html.Encode(obj_tot_jorn.a_anos) then 
                                    %>
                            
                                    <tr>
                                      <td colspan="2"><div align="left"><font size="2"><strong><%=Html.Encode(obj_tot_jorn.cabecera) %></strong></font></div></td>
                                      <td bgcolor="#6fa9ce"><div align="center"><font size="2"><strong><%=Html.Encode(obj_tot_jorn.a_anos_0) %></strong></font></div></td>
                                          <%if maximo_anio + 1 <=  v_anio_actual then%>
                                      <td colspan="2" bgcolor="#ffe799"><font size="2"><strong><%=Html.Encode(obj_tot_jorn.a_anos_1) %></strong></font></td>
                                          <%end if%>
                                          <%if maximo_anio + 2 <=  v_anio_actual then%>
                                      <td colspan="2" bgcolor="#fa7874"><font size="2"><strong><%=Html.Encode(obj_tot_jorn.a_anos_2) %></strong></font></td>
                                          <%end if%>
                                          <%if maximo_anio + 3 <=  v_anio_actual then%>
                                      <td colspan="2" bgcolor="#90c7a0"><font size="2"><strong><%=Html.Encode(obj_tot_jorn.a_anos_3) %></strong></font></td>
                                          <%end if%>
                                          <%if maximo_anio + 4 <=  v_anio_actual then%>
                                      <td colspan="2" bgcolor="#eda64d"><font size="2"><strong><%=Html.Encode(obj_tot_jorn.a_anos_4) %></strong></font></td>
                                          <%end if%>
                                          <%if maximo_anio + 5 <=  v_anio_actual then%>
                                      <td colspan="2" bgcolor="#1998cc"><font size="2"><strong><%=Html.Encode(obj_tot_jorn.a_anos_5) %></strong></font></td>
                                          <%end if%>
                                          <%if maximo_anio + 6 <=  v_anio_actual then%>
                                      <td colspan="2" bgcolor="#f1f25a"><font size="2"><strong><%=Html.Encode(obj_tot_jorn.a_anos_6) %></strong></font></td>
                                          <%end if%>
                                          <%if maximo_anio + 7 <=  v_anio_actual then%>
                                      <td colspan="2" bgcolor="#79ce5b"><font size="2"><strong><%=Html.Encode(obj_tot_jorn.a_anos_7) %></strong></font></td>
                                          <%end if%>
                                          <%if maximo_anio + 8 <=  v_anio_actual then%>
                                      <td colspan="2" bgcolor="#859da9"><font size="2"><strong><%=Html.Encode(obj_tot_jorn.a_anos_8) %></strong></font></td>
                                          <%end if%>
                                          <%if maximo_anio + 9 <=  v_anio_actual then%>
                                      <td colspan="2" bgcolor="#6163f1"><font size="2"><strong><%=Html.Encode(obj_tot_jorn.a_anos_9) %></strong></font></td>
                                          <%end if%>
                                          <%if maximo_anio + 10 <=  v_anio_actual then%>
                                      <td colspan="2" bgcolor="#54ee97"><font size="2"><strong><%=Html.Encode(obj_tot_jorn.a_anos_10) %></strong></font></td>
                                          <%end if%>
                                          <%if maximo_anio + 11 <=  v_anio_actual then%>
                                      <td colspan="2" bgcolor="#4640f8"><font size="2"><strong><%=Html.Encode(obj_tot_jorn.a_anos_11) %></strong></font></td>
                                          <%end if%>
                                          <%if maximo_anio + 12 <=  v_anio_actual then%>
                                      <td colspan="2" bgcolor="#ff4040"><font size="2"><strong><%=Html.Encode(obj_tot_jorn.a_anos_12) %></strong></font></td>
                                          <%end if%>
                                          <%if maximo_anio + 13 <=  v_anio_actual then%>
                                      <td colspan="2" bgcolor="#7fa3d6"><font size="2"><strong><%=Html.Encode(obj_tot_jorn.a_anos_13) %></strong></font></td>
                                          <%end if%>
                                    </tr>
                                      <% 
									end if
                                    Next
                                 %>
                                 </table>
                                </td>
                            </tr> 
                          </table>
                       </td>
                       <td  width="35%" align="center" style='font-size: 0.6em;'>
                            <div id="chartJ"></div>
                       </td>
                   </tr>
                 </table>
               </div> 												
            </div>
           
         </div>
     </div>
     <br />
     <div id="titulo3" class="titulo">
     Indicadores por Carreras
     <input name="imagefield" type="image" src="Content/minimizar.jpg" onclick="minimizar('capa3_dh')"/>
     <input name="imagefield" type="image" src="Content/encuadre.jpg" onclick="maximizar('capa3_dh')"/>
     <input name="imagefield" type="image" src="Content/cerrar.jpg" style="margin-right:3px;" onclick="minimizar('capa3_dh');minimizar('titulo3')"/>
     </div>
     <div id="capa3_dh">
         <div id="dashboardCarrera">
                  <table width="980">
                   <tr style='vertical-align: top'>
                      <td colspan="2" align="left" style='font-size: 0.6em;'>
                       <div id="controlC" align="left"></div>
                      </td>
                   </tr>
                   <tr><td colspan="2">&nbsp;</td></tr>
                   <tr valign="top">
                       <td  width="65%" align="center">
                          <table width="100%">
                            <tr><td width="100%" align="center"><div id="tableC" class="tabla"></div></td></tr>
                            <tr><td width="100%" align="center">&nbsp;</td></tr>
                            <tr><td width="100%" align="center">&nbsp;</td></tr>
                            <div id="dashboardCarreraDetalle">
                                <tr style='vertical-align: top'>
                                  <td colspan="2" align="left"  style='font-size: 0.6em;'>
                                  <div id="controlCD" align="left"></div>
                                  </td>
                                </tr>
                                <tr><td width="100%" align="center"><div id="tableCD" class="tabla"></div></td></tr>
                            </div>
                          </table>
                       </td>
                       <td  width="35%" align="center" style='font-size: 0.6em;'>
                            <div id="chartC"></div>
                       </td>
                   </tr>
                 </table>
         </div>
         
                  <table width="980">
                   
                   <tr><td colspan="2">&nbsp;</td></tr>
                   <tr valign="top">
                       <td  colspan="2" align="center" style='font-size: 0.6em;'>
                           <table width="90%" bgcolor="#FFFFFF" class="tabla">
                                     <tr>
                                      <td>&nbsp;</td>
                                      <td>&nbsp;</td>
                                      <td bgcolor="#6fa9ce">Cohorte</td>
                                          <%if maximo_anio + 1 <=  v_anio_actual then%>
                                          <td width="18" height="18" bgcolor="#ffe799">&nbsp;</td>
                                          <td><font size="2"><strong><%=maximo_anio + 1%></strong></font></td>
                                          <%end if%>
                                          <%if maximo_anio + 2 <=  v_anio_actual then%>
                                          <td width="18" height="18" bgcolor="#fa7874">&nbsp;</td>
                                          <td><font size="2"><strong><%=maximo_anio + 2%></strong></font></td>
                                          <%end if%>
                                          <%if maximo_anio + 3 <=  v_anio_actual then%>
                                          <td width="18" height="18" bgcolor="#90c7a0">&nbsp;</td>
                                          <td><font size="2"><strong><%=maximo_anio + 3%></strong></font></td>
                                          <%end if%>
                                          <%if maximo_anio + 4 <=  v_anio_actual then%>
                                          <td width="18" height="18" bgcolor="#eda64d">&nbsp;</td>
                                          <td><font size="2"><strong><%=maximo_anio + 4%></strong></font></td>
                                          <%end if%>
                                          <%if maximo_anio + 5 <=  v_anio_actual then%>
                                          <td width="18" height="18" bgcolor="#1998cc">&nbsp;</td>
                                          <td><font size="2"><strong><%=maximo_anio + 5%></strong></font></td>
                                          <%end if%>
                                          <%if maximo_anio + 6 <=  v_anio_actual then%>
                                          <td width="18" height="18" bgcolor="#f1f25a">&nbsp;</td>
                                          <td><font size="2"><strong><%=maximo_anio + 6%></strong></font></td>
                                          <%end if%>
                                          <%if maximo_anio + 7 <=  v_anio_actual then%>
                                          <td width="18" height="18" bgcolor="#79ce5b">&nbsp;</td>
                                          <td><font size="2"><strong><%=maximo_anio + 7%></strong></font></td>
                                          <%end if%>
                                          <%if maximo_anio + 8 <=  v_anio_actual then%>
                                          <td width="18" height="18" bgcolor="#859da9">&nbsp;</td>
                                          <td><font size="2"><strong><%=maximo_anio + 8%></strong></font></td>
                                          <%end if%>
                                          <%if maximo_anio + 9 <=  v_anio_actual then%>
                                          <td width="18" height="18" bgcolor="#6163f1">&nbsp;</td>
                                          <td><font size="2"><strong><%=maximo_anio + 9%></strong></font></td>
                                          <%end if%>
                                          <%if maximo_anio + 10 <=  v_anio_actual then%>
                                          <td width="18" height="18" bgcolor="#54ee97">&nbsp;</td>
                                          <td><font size="2"><strong><%=maximo_anio + 10%></strong></font></td>
                                          <%end if%>
                                          <%if maximo_anio + 11 <=  v_anio_actual then%>
                                          <td width="18" height="18" bgcolor="#4640f8">&nbsp;</td>
                                          <td><font size="2"><strong><%=maximo_anio + 11%></strong></font></td>
                                          <%end if%>
                                          <%if maximo_anio + 12 <=  v_anio_actual then%>
                                          <td width="18" height="18" bgcolor="#ff4040">&nbsp;</td>
                                          <td><font size="2"><strong><%=maximo_anio + 12%></strong></font></td>
                                          <%end if%>
                                          <%if maximo_anio + 13 <=  v_anio_actual then%>
                                          <td width="18" height="18" bgcolor="#7fa3d6">&nbsp;</td>
                                          <td><font size="2"><strong><%=maximo_anio + 13%></strong></font></td>
                                          <%end if%>
                                    </tr>
                            
                                    <%
                                    Dim obj_tot_carr
                                    For each obj_tot_carr in ModelTotalCarrera.Items
									if maximo_anio = Html.Encode(obj_tot_carr.a_anos) then 
                                    %>
                            
                                    <tr>
                                      <td colspan="2"><div align="left"><font size="2"><strong><%=Html.Encode(obj_tot_carr.cabecera) %></strong></font></div></td>
                                      <td bgcolor="#6fa9ce"><div align="center"><font size="2"><strong><%=Html.Encode(obj_tot_carr.a_anos_0) %></strong></font></div></td>
                                          <%if maximo_anio + 1 <=  v_anio_actual then%>
                                      <td colspan="2" bgcolor="#ffe799"><font size="2"><strong><%=Html.Encode(obj_tot_carr.a_anos_1) %></strong></font></td>
                                          <%end if%>
                                          <%if maximo_anio + 2 <=  v_anio_actual then%>
                                      <td colspan="2" bgcolor="#fa7874"><font size="2"><strong><%=Html.Encode(obj_tot_carr.a_anos_2) %></strong></font></td>
                                          <%end if%>
                                          <%if maximo_anio + 3 <=  v_anio_actual then%>
                                      <td colspan="2" bgcolor="#90c7a0"><font size="2"><strong><%=Html.Encode(obj_tot_carr.a_anos_3) %></strong></font></td>
                                          <%end if%>
                                          <%if maximo_anio + 4 <=  v_anio_actual then%>
                                      <td colspan="2" bgcolor="#eda64d"><font size="2"><strong><%=Html.Encode(obj_tot_carr.a_anos_4) %></strong></font></td>
                                          <%end if%>
                                          <%if maximo_anio + 5 <=  v_anio_actual then%>
                                      <td colspan="2" bgcolor="#1998cc"><font size="2"><strong><%=Html.Encode(obj_tot_carr.a_anos_5) %></strong></font></td>
                                          <%end if%>
                                          <%if maximo_anio + 6 <=  v_anio_actual then%>
                                      <td colspan="2" bgcolor="#f1f25a"><font size="2"><strong><%=Html.Encode(obj_tot_carr.a_anos_6) %></strong></font></td>
                                          <%end if%>
                                          <%if maximo_anio + 7 <=  v_anio_actual then%>
                                      <td colspan="2" bgcolor="#79ce5b"><font size="2"><strong><%=Html.Encode(obj_tot_carr.a_anos_7) %></strong></font></td>
                                          <%end if%>
                                          <%if maximo_anio + 8 <=  v_anio_actual then%>
                                      <td colspan="2" bgcolor="#859da9"><font size="2"><strong><%=Html.Encode(obj_tot_carr.a_anos_8) %></strong></font></td>
                                          <%end if%>
                                          <%if maximo_anio + 9 <=  v_anio_actual then%>
                                      <td colspan="2" bgcolor="#6163f1"><font size="2"><strong><%=Html.Encode(obj_tot_carr.a_anos_9) %></strong></font></td>
                                          <%end if%>
                                          <%if maximo_anio + 10 <=  v_anio_actual then%>
                                      <td colspan="2" bgcolor="#54ee97"><font size="2"><strong><%=Html.Encode(obj_tot_carr.a_anos_10) %></strong></font></td>
                                          <%end if%>
                                          <%if maximo_anio + 11 <=  v_anio_actual then%>
                                      <td colspan="2" bgcolor="#4640f8"><font size="2"><strong><%=Html.Encode(obj_tot_carr.a_anos_11) %></strong></font></td>
                                          <%end if%>
                                          <%if maximo_anio + 12 <=  v_anio_actual then%>
                                      <td colspan="2" bgcolor="#ff4040"><font size="2"><strong><%=Html.Encode(obj_tot_carr.a_anos_12) %></strong></font></td>
                                          <%end if%>
                                          <%if maximo_anio + 13 <=  v_anio_actual then%>
                                      <td colspan="2" bgcolor="#7fa3d6"><font size="2"><strong><%=Html.Encode(obj_tot_carr.a_anos_13) %></strong></font></td>
                                          <%end if%>
                                    </tr>
                                    <% 
									end if
                                    Next
                                    %>
                           </table>
                             
                   </tr>
                 </table>
       
       </div>
     <br />
    <table width="100%" height="30">
    	<tr>
           <td width="100%">&nbsp;</td>
        </tr>
    </table> 
    </div> 
    <br />
    <br />
    <br />
           <!--</div>-->

    