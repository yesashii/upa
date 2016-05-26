
      <script type="text/javascript">
          //two variables Controller and Action have to be initialized in the View HTML code
          var Controller ='MatriculaCredito';
          var Action = 'List';
      </script>
      <%
	  chequeo_2005="checked='checked'"
	  chequeo_2006="checked='checked'"
	  chequeo_2007="checked='checked'"
	  chequeo_2008="checked='checked'"
	  chequeo_2009="checked='checked'"
	  chequeo_2010="checked='checked'"
	  chequeo_2011="checked='checked'"
	  chequeo_2012="checked='checked'"
	  chequeo_2013="checked='checked'"
	  complemento_url = ""
	  url_detalle = "&q="
	  maximo_anio = 2005
	  inicial = request.form("inicial")
	  if inicial = "" then
	  	inicial= 1
	  end if
	  if request.form("c2005")="" then
	  	chequeo_2005=""
	  else
	    complemento_url = complemento_url&"&e2005=1"
		maximo_anio = 2005
	  end if
	  if request.form("c2006")="" then
	  	chequeo_2006=""
	  else
	    complemento_url = complemento_url&"&e2006=1"
		maximo_anio = 2006
	  end if
	  if request.form("c2007")="" then
	  	chequeo_2007=""
	  else
	    complemento_url = complemento_url&"&e2007=1"
		maximo_anio = 2007
	  end if
	  if request.form("c2008")="" then
	  	chequeo_2008=""
	  else
	    complemento_url = complemento_url&"&e2008=1"
		maximo_anio = 2008
	  end if
	  if request.form("c2009")="" then
	  	chequeo_2009=""
	  else
	    complemento_url = complemento_url&"&e2009=1"
		maximo_anio = 2009
	  end if
	  if request.form("c2010")="" and inicial <> 1 then
	  	chequeo_2010=""
	  else
	    complemento_url = complemento_url&"&e2010=1"
		maximo_anio = 2010
	  end if
	  if request.form("c2011")="" and inicial <> 1 then
	  	chequeo_2011=""
	  else
	    complemento_url = complemento_url&"&e2011=1"
		maximo_anio = 2011
	  end if
	  if request.form("c2012")="" and inicial <> 1 then
	  	chequeo_2012=""
	  else
	    complemento_url = complemento_url&"&e2012=1"
		maximo_anio = 2012
	  end if
	  if request.form("c2013")="" and inicial <> 1 then
	  	chequeo_2013=""
	  else
	    complemento_url = complemento_url&"&e2013=1"
		maximo_anio = 2013
	  end if
	  url_detalle = url_detalle & "" & maximo_anio
	  %>
      <script type="text/javascript" src="//www.google.com/jsapi"></script>
	  <script type="text/javascript">
          google.load('visualization', '1.1', {packages: ['controls']});
      </script>
      <script type="text/javascript">
      function drawVisualization() {
        // Prepare the data
        var data = google.visualization.arrayToDataTable([
          ['Periodo','Sede','Matriculados con Crédito']
		       <%Dim obj0,obj01,obj02, valor_periodo,cabe
			      cadena = ""
				  sede_seleccionada = ""
                  For each obj0 in Model.Items
				    cabe = Html.Encode(obj0.cabecera)
					IF sede_seleccionada = "" THEN 
						sede_seleccionada = cabe
					END IF
					if instr(cadena, cabe) = 0 then 
					   cadena = cadena + cabe
						if chequeo_2005 <> "" then
							response.Write(",['2005','"+cabe+"',")
							valor_periodo = 0
							For each obj01 in Model.Items
							  if Html.Encode(obj01.cabecera) = cabe then
								valor_periodo = Html.Encode(obj01.a2005)
							  end if
							next
    						response.Write(valor_periodo+"]")
						end if 
						if chequeo_2006 <> "" then
							response.Write(",['2006','"+cabe+"',")
							valor_periodo = 0
							For each obj01 in Model.Items
							  if Html.Encode(obj01.cabecera) = cabe then
								valor_periodo = Html.Encode(obj01.a2006)
							  end if
							next
							response.Write(valor_periodo+"]")
						end if
						if chequeo_2007 <> "" then
							response.Write(",['2007','"+cabe+"',")
							valor_periodo = 0
							For each obj01 in Model.Items
							  if Html.Encode(obj01.cabecera) = cabe then
								valor_periodo = Html.Encode(obj01.a2007)
							  end if
							next
							response.Write(valor_periodo+"]")
						end if
						if chequeo_2008 <> "" then
							response.Write(",['2008','"+cabe+"',")
							valor_periodo = 0
							For each obj01 in Model.Items
							  if Html.Encode(obj01.cabecera) = cabe then
								valor_periodo = Html.Encode(obj01.a2008)
							  end if
							next
							response.Write(valor_periodo+"]")
						end if
						if chequeo_2009 <> "" then
							response.Write(",['2009','"+cabe+"',")
							valor_periodo = 0
							For each obj01 in Model.Items
							  if Html.Encode(obj01.cabecera) = cabe then
								valor_periodo = Html.Encode(obj01.a2009)
							  end if
							next
							response.Write(valor_periodo+"]")
						end if
						if chequeo_2010 <> "" then
							response.Write(",['2010','"+cabe+"',")
							valor_periodo = 0
							For each obj01 in Model.Items
							  if Html.Encode(obj01.cabecera) = cabe then
								valor_periodo = Html.Encode(obj01.a2010)
							  end if
							next
							response.Write(valor_periodo+"]")
						end if
						if chequeo_2011 <> "" then
							response.Write(",['2011','"+cabe+"',")
							valor_periodo = 0
							For each obj01 in Model.Items
							  if Html.Encode(obj01.cabecera) = cabe  then
								valor_periodo = Html.Encode(obj01.a2011)
							  end if
							next
							response.Write(valor_periodo+"]")
						end if
						if chequeo_2012 <> "" then
							response.Write(",['2012','"+cabe+"',")
							valor_periodo = 0
							For each obj01 in Model.Items
							  if Html.Encode(obj01.cabecera) = cabe then
								valor_periodo = Html.Encode(obj01.a2012)
							  end if
							next
							response.Write(valor_periodo+"]")
						end if
						if chequeo_2013 <> "" then
							response.Write(",['2013','"+cabe+"',")
							valor_periodo = 0
							For each obj01 in Model.Items
							  if Html.Encode(obj01.cabecera) = cabe then
								valor_periodo = Html.Encode(obj01.a2013)
							  end if
							next
							response.Write(valor_periodo+"]")
						end if
					end if
				   next%>
        ]);
      
	  //Para Facultad
	  var data_Facultad = google.visualization.arrayToDataTable([
          ['Periodo','Facultad','Matriculados con Crédito']
		       <%Dim obj_f
			      cadena = ""
				  facu_seleccionada = ""
                  For each obj_f in ModelFacultad.Items
				    cabe = Html.Encode(obj_f.cabecera)
					IF facu_seleccionada = "" THEN 
						facu_seleccionada = cabe
					END IF
					if instr(cadena, cabe) = 0 then 
					   cadena = cadena + cabe
						if chequeo_2005 <> "" then
							response.Write(",['2005','"+cabe+"',")
							valor_periodo = 0
							For each obj01 in ModelFacultad.Items
							  if Html.Encode(obj01.cabecera) = cabe then
								valor_periodo = Html.Encode(obj01.a2005)
							  end if
							next
							response.Write(valor_periodo+"]")
						end if 
						if chequeo_2006 <> "" then
							response.Write(",['2006','"+cabe+"',")
							valor_periodo = 0
							For each obj01 in ModelFacultad.Items
							  if Html.Encode(obj01.cabecera) = cabe then
								valor_periodo = Html.Encode(obj01.a2006)
							  end if
							next
							response.Write(valor_periodo+"]")
						end if
						if chequeo_2007 <> "" then
							response.Write(",['2007','"+cabe+"',")
							valor_periodo = 0
							For each obj01 in ModelFacultad.Items
							  if Html.Encode(obj01.cabecera) = cabe then
								valor_periodo = Html.Encode(obj01.a2007)
							  end if
							next
							response.Write(valor_periodo+"]")
						end if
						if chequeo_2008 <> "" then
							response.Write(",['2008','"+cabe+"',")
							valor_periodo = 0
							For each obj01 in ModelFacultad.Items
							  if Html.Encode(obj01.cabecera) = cabe then
								valor_periodo = Html.Encode(obj01.a2008)
							  end if
							next
							response.Write(valor_periodo+"]")
						end if
						if chequeo_2009 <> "" then
							response.Write(",['2009','"+cabe+"',")
							valor_periodo = 0
							For each obj01 in ModelFacultad.Items
							  if Html.Encode(obj01.cabecera) = cabe then
								valor_periodo = Html.Encode(obj01.a2009)
							  end if
							next
							response.Write(valor_periodo+"]")
						end if
						if chequeo_2010 <> "" then
							response.Write(",['2010','"+cabe+"',")
							valor_periodo = 0
							For each obj01 in ModelFacultad.Items
							  if Html.Encode(obj01.cabecera) = cabe then
								valor_periodo = Html.Encode(obj01.a2010)
							  end if
							next
							response.Write(valor_periodo+"]")
						end if
						if chequeo_2011 <> "" then
							response.Write(",['2011','"+cabe+"',")
							valor_periodo = 0
							For each obj01 in ModelFacultad.Items
							  if Html.Encode(obj01.cabecera) = cabe  then
								valor_periodo = Html.Encode(obj01.a2011)
							  end if
							next
							response.Write(valor_periodo+"]")
						end if
						if chequeo_2012 <> "" then
							response.Write(",['2012','"+cabe+"',")
							valor_periodo = 0
							For each obj01 in ModelFacultad.Items
							  if Html.Encode(obj01.cabecera) = cabe  then
								valor_periodo = Html.Encode(obj01.a2012)
							  end if
							next
							response.Write(valor_periodo+"]")
						end if
						if chequeo_2013 <> "" then
							response.Write(",['2013','"+cabe+"',")
							valor_periodo = 0
							For each obj01 in ModelFacultad.Items
							  if Html.Encode(obj01.cabecera) = cabe  then
								valor_periodo = Html.Encode(obj01.a2013)
							  end if
							next
							response.Write(valor_periodo+"]")
						end if
					end if
				   next%>
        ]);
	  
	  //Para Jornada
	  var data_Jornada = google.visualization.arrayToDataTable([
          ['Periodo','Jornada','Matriculados con Crédito']
		       <%Dim obj_j
			      cadena = ""
				  jorn_seleccionada = ""
                  For each obj_j in ModelJornada.Items
				    cabe = Html.Encode(obj_j.cabecera)
					IF jorn_seleccionada = "" THEN 
					jorn_seleccionada = cabe
					END IF
					if instr(cadena, cabe) = 0 then 
					   cadena = cadena + cabe
						if chequeo_2005 <> "" then
							response.Write(",['2005','"+cabe+"',")
							valor_periodo = 0
							For each obj01 in ModelJornada.Items
							  if Html.Encode(obj01.cabecera) = cabe then
								valor_periodo = Html.Encode(obj01.a2005)
							  end if
							next
							response.Write(valor_periodo+"]")
						end if 
						if chequeo_2006 <> "" then
							response.Write(",['2006','"+cabe+"',")
							valor_periodo = 0
							For each obj01 in ModelJornada.Items
							  if Html.Encode(obj01.cabecera) = cabe then
								valor_periodo = Html.Encode(obj01.a2006)
							  end if
							next
							response.Write(valor_periodo+"]")
						end if
						if chequeo_2007 <> "" then
							response.Write(",['2007','"+cabe+"',")
							valor_periodo = 0
							For each obj01 in ModelJornada.Items
							  if Html.Encode(obj01.cabecera) = cabe then
								valor_periodo = Html.Encode(obj01.a2007)
							  end if
							next
							response.Write(valor_periodo+"]")
						end if
						if chequeo_2008 <> "" then
							response.Write(",['2008','"+cabe+"',")
							valor_periodo = 0
							For each obj01 in ModelJornada.Items
							  if Html.Encode(obj01.cabecera) = cabe then
								valor_periodo = Html.Encode(obj01.a2008)
							  end if
							next
							response.Write(valor_periodo+"]")
						end if
						if chequeo_2009 <> "" then
							response.Write(",['2009','"+cabe+"',")
							valor_periodo = 0
							For each obj01 in ModelJornada.Items
							  if Html.Encode(obj01.cabecera) = cabe  then
								valor_periodo = Html.Encode(obj01.a2009)
							  end if
							next
							response.Write(valor_periodo+"]")
						end if
						if chequeo_2010 <> "" then
							response.Write(",['2010','"+cabe+"',")
							valor_periodo = 0
							For each obj01 in ModelJornada.Items
							  if Html.Encode(obj01.cabecera) = cabe  then
								valor_periodo = Html.Encode(obj01.a2010)
							  end if
							next
							response.Write(valor_periodo+"]")
						end if
						if chequeo_2011 <> "" then
							response.Write(",['2011','"+cabe+"',")
							valor_periodo = 0
							For each obj01 in ModelJornada.Items
							  if Html.Encode(obj01.cabecera) = cabe then
								valor_periodo = Html.Encode(obj01.a2011)
							  end if
							next
							response.Write(valor_periodo+"]")
						end if
						if chequeo_2012 <> "" then
							response.Write(",['2012','"+cabe+"',")
							valor_periodo = 0
							For each obj01 in ModelJornada.Items
							  if Html.Encode(obj01.cabecera) = cabe  then
								valor_periodo = Html.Encode(obj01.a2012)
							  end if
							next
							response.Write(valor_periodo+"]")
						end if
						if chequeo_2013 <> "" then
							response.Write(",['2013','"+cabe+"',")
							valor_periodo = 0
							For each obj01 in ModelJornada.Items
							  if Html.Encode(obj01.cabecera) = cabe then
								valor_periodo = Html.Encode(obj01.a2013)
							  end if
							next
							response.Write(valor_periodo+"]")
						end if
					end if
				   next%>
        ]);
	  
	  //Para Carrera
	  var data_Carrera = google.visualization.arrayToDataTable([
          ['Periodo','Carrera','Matriculados con Crédito']
		       <%Dim obj_c
			      cadena = ""
				  carr_seleccionada = ""
                  For each obj_c in ModelCarrera.Items
				    cabe = Html.Encode(obj_c.cabecera)
					IF carr_seleccionada = "" THEN 
					carr_seleccionada = cabe
					END IF
					if instr(cadena, cabe) = 0 then 
					   cadena = cadena + cabe
						if chequeo_2005 <> "" then
							response.Write(",['2005','"+cabe+"',")
							For each obj01 in ModelCarrera.Items
							  if Html.Encode(obj01.cabecera) = cabe then
								valor_periodo = Html.Encode(obj01.a2005)
							  end if
							next
							if isNumeric(valor_periodo) then
								response.Write(valor_periodo+"]")
							else
								response.Write("0]")
							end if
						end if 
						if chequeo_2006 <> "" then
							response.Write(",['2006','"+cabe+"',")
							For each obj01 in ModelCarrera.Items
							  if Html.Encode(obj01.cabecera) = cabe  then
								valor_periodo = Html.Encode(obj01.a2006)
							  end if
							next
							if isNumeric(valor_periodo) then
								response.Write(valor_periodo+"]")
							else
								response.Write("0]")
							end if
						end if
						if chequeo_2007 <> "" then
							response.Write(",['2007','"+cabe+"',")
							For each obj01 in ModelCarrera.Items
							  if Html.Encode(obj01.cabecera) = cabe then
								valor_periodo = Html.Encode(obj01.a2007)
							  end if
							next
							if isNumeric(valor_periodo) then
								response.Write(valor_periodo+"]")
							else
								response.Write("0]")
							end if
						end if
						if chequeo_2008 <> "" then
							response.Write(",['2008','"+cabe+"',")
							For each obj01 in ModelCarrera.Items
							  if Html.Encode(obj01.cabecera) = cabe then
								valor_periodo = Html.Encode(obj01.a2008)
							  end if
							next
							if isNumeric(valor_periodo) then
								response.Write(valor_periodo+"]")
							else
								response.Write("0]")
							end if
						end if
						if chequeo_2009 <> "" then
							response.Write(",['2009','"+cabe+"',")
							For each obj01 in ModelCarrera.Items
							  if Html.Encode(obj01.cabecera) = cabe then
								valor_periodo = Html.Encode(obj01.a2009)
							  end if
							next
							if isNumeric(valor_periodo) then
								response.Write(valor_periodo+"]")
							else
								response.Write("0]")
							end if
						end if
						if chequeo_2010 <> "" then
							response.Write(",['2010','"+cabe+"',")
							For each obj01 in ModelCarrera.Items
							  if Html.Encode(obj01.cabecera) = cabe  then
								valor_periodo = Html.Encode(obj01.a2010)
							  end if
							next
							if isNumeric(valor_periodo) then
								response.Write(valor_periodo+"]")
							else
								response.Write("0]")
							end if
						end if
						if chequeo_2011 <> "" then
							response.Write(",['2011','"+cabe+"',")
							For each obj01 in ModelCarrera.Items
							  if Html.Encode(obj01.cabecera) = cabe  then
								valor_periodo = Html.Encode(obj01.a2011)
							  end if
							next
							if isNumeric(valor_periodo) then
								response.Write(valor_periodo+"]")
							else
								response.Write("0]")
							end if
						end if
						if chequeo_2012 <> "" then
							response.Write(",['2012','"+cabe+"',")
							For each obj01 in ModelCarrera.Items
							  if Html.Encode(obj01.cabecera) = cabe  then
								valor_periodo = Html.Encode(obj01.a2012)
							  end if
							next
							if isNumeric(valor_periodo) then
								response.Write(valor_periodo+"]")
							else
								response.Write("0]")
							end if
						end if
						if chequeo_2013 <> "" then
							response.Write(",['2013','"+cabe+"',")
							For each obj01 in ModelCarrera.Items
							  if Html.Encode(obj01.cabecera) = cabe  then
								valor_periodo = Html.Encode(obj01.a2013)
							  end if
							next
							if isNumeric(valor_periodo) then
								response.Write(valor_periodo+"]")
							else
								response.Write("0]")
							end if
						end if
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
      
        // Define a bar chart to show 'Population' data
        var ColumnChartSede = new google.visualization.ChartWrapper({
          'chartType': 'ColumnChart',
          'containerId': 'chart1',
          'options': {
            'width': 300,
            'height': 230,
			//'isStacked': true,
			'colors':['#6fa9ce'],
            'chartArea': {top: 0, right: 0, bottom: 0}
          },
          // Configure the barchart to use columns 2 (City) and 3 (Population)
          'view': {'columns': [0,2]}
        });
		
		var ColumnChartFacultad = new google.visualization.ChartWrapper({
          'chartType': 'BarChart',
          'containerId': 'chartF',
          'options': {
            'width': 300,
            'height': 230,
			//'isStacked': true,
			'colors':['#fa7874'],
            'chartArea': {top: 0, right: 0, bottom: 0}
          },
          // Configure the barchart to use columns 2 (City) and 3 (Population)
          'view': {'columns': [0,2]}
        });
		
		var AreaChartJornada = new google.visualization.ChartWrapper({
          'chartType': 'AreaChart',
          'containerId': 'chartJ',
          'options': {
            'width': 300,
            'height': 230,
			//'isStacked': true,
			'colors':['#90c7a0'],
            'chartArea': {top: 0, right: 0, bottom: 0}
          },
          'view': {'columns': [0,2]}
        });

         var ColumnChartCarrera = new google.visualization.ChartWrapper({
          'chartType': 'ColumnChart',
          'containerId': 'chartC',
          'options': {
            'width': 300,
            'height': 250,
			'colors':['#eda64d'],
            'chartArea': {top: 0, right: 0, bottom: 0}
          },
          // Configure the barchart to use columns 2 (City) and 3 (Population)
          'view': {'columns': [0,2]}
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
		    
      }
      google.setOnLoadCallback(drawVisualization);
    </script>
     <!-- <div class='GridViewScrollContainer'>-->
     <div id="cuadro0">
     <br />
     <h1>Total alumnos matriculados 1er año con crédito</h1>
     <p><i>"Cantidad de alumnos matriculados al primer año de la carrera durante este período, que cuentan con algún crédito financiero."</i></p>
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
                        <td colspan="9"><H3 class="shad">Seleccione años a consultar</H3></td>
                    </tr>
                    <tr>
                        <td width="11%" align="center"><input type="checkbox" name="c2005" value="2005" <%=chequeo_2005%> onchange="document.formu_anos.submit();" ></td>
                        <td width="11%" align="center"><input type="checkbox" name="c2006" value="2006" <%=chequeo_2006%> onchange="document.formu_anos.submit();" ></td>
                        <td width="11%" align="center"><input type="checkbox" name="c2007" value="2007" <%=chequeo_2007%> onchange="document.formu_anos.submit();" ></td>
                        <td width="11%" align="center"><input type="checkbox" name="c2008" value="2008" <%=chequeo_2008%> onchange="document.formu_anos.submit();" ></td>
                        <td width="11%" align="center"><input type="checkbox" name="c2009" value="2009" <%=chequeo_2009%> onchange="document.formu_anos.submit();" ></td>
                        <td width="11%" align="center"><input type="checkbox" name="c2010" value="2010" <%=chequeo_2010%> onchange="document.formu_anos.submit();" ></td>
                        <td width="11%" align="center"><input type="checkbox" name="c2011" value="2011" <%=chequeo_2011%> onchange="document.formu_anos.submit();" ></td>
                        <td width="11%" align="center"><input type="checkbox" name="c2012" value="2012" <%=chequeo_2012%> onchange="document.formu_anos.submit();" ></td>
                        <td width="12%" align="center"><input type="checkbox" name="c2013" value="2013" <%=chequeo_2013%> onchange="document.formu_anos.submit();" ></td>
                    </tr>
                    <tr>
                        <td width="11%" align="center"><font color="#999999">2005</font></td>
                        <td width="11%" align="center"><font color="#999999">2006</font></td>
                        <td width="11%" align="center"><font color="#999999">2007</font></td>
                        <td width="11%" align="center"><font color="#999999">2008</font></td>
                        <td width="11%" align="center"><font color="#999999">2009</font></td>
                        <td width="11%" align="center"><font color="#999999">2010</font></td>
                        <td width="11%" align="center"><font color="#999999">2011</font></td>
                        <td width="11%" align="center"><font color="#999999">2012</font></td>
                        <td width="12%" align="center"><font color="#999999">2013</font></td>
                    </tr>
                    <tr>
                    	<td colspan="9" align="right">
				            <%=Html.ActionLink("<div class='btn' align='right'>Obtener Excel</div>","MatriculaCredito","List_excel", "partial=excel"&complemento_url)%>
                            <%if session("_pers_ncorr_") = "0" then 
							   response.Write(Html.ActionLink("<div class='btn' align='right'>Detalle "&maximo_anio&"</div>","ExcelDetalleMatriculados","List_excel", "partial=excel"&url_detalle))
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
     <input name="imagefield" type="image" src="Content/minimizar.jpg" onclick="minimizar('capa2')"/>
     <input name="imagefield" type="image" src="Content/encuadre.jpg" onclick="maximizar('capa2')"/>
     <input name="imagefield" type="image" src="Content/cerrar.jpg" style="margin-right:3px;" onclick="minimizar('capa2');minimizar('titulo2')"/>
     </div>
     <div id="capa2">
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
                                	<table bgcolor="#FFFFFF" class="tabla">
                                        <tr>
                                          <td>&nbsp;</td>
                                          <td>&nbsp;</td>

                                          <%if chequeo_2005 <> "" then%>
                                          <td width="18" height="18" bgcolor="#7dcaa7">&nbsp;</td>
                                          <td><font size="2"><strong>2005</strong></font></td>
                                          <%end if%>
                                          <%if chequeo_2006 <> "" then%>
                                          <td width="18" height="18" bgcolor="#f79820">&nbsp;</td>
                                          <td><font size="2"><strong>2006</strong></font></td>
                                          <%end if%>
                                          <%if chequeo_2007 <> "" then%>
                                          <td width="18" height="18" bgcolor="#23885b">&nbsp;</td>
                                          <td><font size="2"><strong>2007</strong></font></td>
                                          <%end if%>
                                          <%if chequeo_2008 <> "" then%>
                                          <td width="18" height="18" bgcolor="#7fa3d6">&nbsp;</td>
                                          <td><font size="2"><strong>2008</strong></font></td>
                                          <%end if%>
                                          <%if chequeo_2009 <> "" then%>
                                          <td width="18" height="18" bgcolor="#e77368">&nbsp;</td>
                                          <td><font size="2"><strong>2009</strong></font></td>
                                          <%end if%>
                                          <%if chequeo_2010 <> "" then%>
                                          <td width="18" height="18" bgcolor="#35cbe8">&nbsp;</td>
                                          <td><font size="2"><strong>2010</strong></font></td>
                                          <%end if%>
                                          <%if chequeo_2011 <> "" then%>
                                          <td width="18" height="18" bgcolor="#5cb200">&nbsp;</td>
                                          <td><font size="2"><strong>2011</strong></font></td>
                                          <%end if%>
                                          <%if chequeo_2012 <> "" then%>
                                          <td width="18" height="18" bgcolor="#0e8ccb">&nbsp;</td>
                                          <td><font size="2"><strong>2012</strong></font></td>
                                          <%end if%>
                                          <%if chequeo_2013 <> "" then%>
                                          <td width="18" height="18" bgcolor="#e85900">&nbsp;</td>
                                          <td><font size="2"><strong>2013</strong></font></td>
                                          <%end if%>
                                        </tr>
                                
                                        <%
                                        Dim obj_tot_sede
                                        For each obj_tot_sede in ModelTotalSede.Items
                                        %>
                                        <tr>
                                          <td colspan="2"><div align="left"><font size="2"><strong><%=Html.Encode(obj_tot_sede.cabecera) %></strong></font></div></td>
                                          <%if chequeo_2005 <> "" then%>
                                          <td colspan="2" bgcolor="#7dcaa7"><font color="#FFFFFF" size="2"><strong><%=Html.Encode(obj_tot_sede.a2005) %></strong></font></td>
                                          <%end if%>
                                          <%if chequeo_2006 <> "" then%>
                                          <td colspan="2" bgcolor="#f79820"><font color="#FFFFFF" size="2"><strong><%=Html.Encode(obj_tot_sede.a2006) %></strong></font></td>
                                          <%end if%>
                                          <%if chequeo_2007 <> "" then%>
                                          <td colspan="2" bgcolor="#23885b"><font color="#FFFFFF" size="2"><strong><%=Html.Encode(obj_tot_sede.a2007) %></strong></font></td>
                                          <%end if%>
                                          <%if chequeo_2008 <> "" then%>
                                          <td colspan="2" bgcolor="#7fa3d6"><font color="#FFFFFF" size="2"><strong><%=Html.Encode(obj_tot_sede.a2008) %></strong></font></td>
                                          <%end if%>
                                          <%if chequeo_2009 <> "" then%>
                                          <td colspan="2" bgcolor="#e77368"><font color="#FFFFFF" size="2"><strong><%=Html.Encode(obj_tot_sede.a2009) %></strong></font></td>
                                          <%end if%>
                                          <%if chequeo_2010 <> "" then%>
                                          <td colspan="2" bgcolor="#35cbe8"><font color="#FFFFFF" size="2"><strong><%=Html.Encode(obj_tot_sede.a2010) %></strong></font></td>
                                          <%end if%>
                                          <%if chequeo_2011 <> "" then%>
                                          <td colspan="2" bgcolor="#5cb200"><font color="#FFFFFF" size="2"><strong><%=Html.Encode(obj_tot_sede.a2011) %></strong></font></td>
                                          <%end if%>
                                          <%if chequeo_2012 <> "" then%>
                                          <td colspan="2" bgcolor="#0e8ccb"><font color="#FFFFFF" size="2"><strong><%=Html.Encode(obj_tot_sede.a2012) %></strong></font></td>
                                          <%end if%>
                                          <%if chequeo_2013 <> "" then%>
                                          <td colspan="2" bgcolor="#e85900"><font color="#FFFFFF" size="2"><strong><%=Html.Encode(obj_tot_sede.a2013) %></strong></font></td>
                                          <%end if%>
                                        </tr>
                                          <% 
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
                                	<table bgcolor="#FFFFFF" class="tabla">
                                         <tr>
                                          <td>&nbsp;</td>
                                          <td>&nbsp;</td>
                                          <%if chequeo_2005 <> "" then%>
                                          <td width="18" height="18" bgcolor="#7dcaa7">&nbsp;</td>
                                          <td><font size="2"><strong>2005</strong></font></td>
                                          <%end if%>
                                          <%if chequeo_2006 <> "" then%>
                                          <td width="18" height="18" bgcolor="#f79820">&nbsp;</td>
                                          <td><font size="2"><strong>2006</strong></font></td>
                                          <%end if%>
                                          <%if chequeo_2007 <> "" then%>
                                          <td width="18" height="18" bgcolor="#23885b">&nbsp;</td>
                                          <td><font size="2"><strong>2007</strong></font></td>
                                          <%end if%>
                                          <%if chequeo_2008 <> "" then%>
                                          <td width="18" height="18" bgcolor="#7fa3d6">&nbsp;</td>
                                          <td><font size="2"><strong>2008</strong></font></td>
                                          <%end if%>
                                          <%if chequeo_2009 <> "" then%>
                                          <td width="18" height="18" bgcolor="#e77368">&nbsp;</td>
                                          <td><font size="2"><strong>2009</strong></font></td>
                                          <%end if%>
                                          <%if chequeo_2010 <> "" then%>
                                          <td width="18" height="18" bgcolor="#35cbe8">&nbsp;</td>
                                          <td><font size="2"><strong>2010</strong></font></td>
                                          <%end if%>
                                          <%if chequeo_2011 <> "" then%>
                                          <td width="18" height="18" bgcolor="#5cb200">&nbsp;</td>
                                          <td><font size="2"><strong>2011</strong></font></td>
                                          <%end if%>
                                          <%if chequeo_2012 <> "" then%>
                                          <td width="18" height="18" bgcolor="#0e8ccb">&nbsp;</td>
                                          <td><font size="2"><strong>2012</strong></font></td>
                                          <%end if%>
                                          <%if chequeo_2013 <> "" then%>
                                          <td width="18" height="18" bgcolor="#e85900">&nbsp;</td>
                                          <td><font size="2"><strong>2013</strong></font></td>
                                          <%end if%>
                                        </tr>
                                
                                        <%
                                        Dim obj_tot_facu
                                        For each obj_tot_facu in ModelTotalFacultad.Items
                                        %>
                                
                                        <tr>
                                          <td colspan="2"><div align="left"><font size="2"><strong><%=Html.Encode(obj_tot_facu.cabecera) %></strong></font></div></td>
                                          <%if chequeo_2005 <> "" then%>
                                          <td colspan="2" bgcolor="#7dcaa7"><font color="#FFFFFF" size="2"><strong><%=Html.Encode(obj_tot_facu.a2005) %></strong></font></td>
                                          <%end if%>
                                          <%if chequeo_2006 <> "" then%>
                                          <td colspan="2" bgcolor="#f79820"><font color="#FFFFFF" size="2"><strong><%=Html.Encode(obj_tot_facu.a2006) %></strong></font></td>
                                          <%end if%>
                                          <%if chequeo_2007 <> "" then%>
                                          <td colspan="2" bgcolor="#23885b"><font color="#FFFFFF" size="2"><strong><%=Html.Encode(obj_tot_facu.a2007) %></strong></font></td>
                                          <%end if%>
                                          <%if chequeo_2008 <> "" then%>
                                          <td colspan="2" bgcolor="#7fa3d6"><font color="#FFFFFF" size="2"><strong><%=Html.Encode(obj_tot_facu.a2008) %></strong></font></td>
                                          <%end if%>
                                          <%if chequeo_2009 <> "" then%>
                                          <td colspan="2" bgcolor="#e77368"><font color="#FFFFFF" size="2"><strong><%=Html.Encode(obj_tot_facu.a2009) %></strong></font></td>
                                          <%end if%>
                                          <%if chequeo_2010 <> "" then%>
                                          <td colspan="2" bgcolor="#35cbe8"><font color="#FFFFFF" size="2"><strong><%=Html.Encode(obj_tot_facu.a2010) %></strong></font></td>
                                          <%end if%>
                                          <%if chequeo_2011 <> "" then%>
                                          <td colspan="2" bgcolor="#5cb200"><font color="#FFFFFF" size="2"><strong><%=Html.Encode(obj_tot_facu.a2011) %></strong></font></td>
                                          <%end if%>
                                          <%if chequeo_2012 <> "" then%>
                                          <td colspan="2" bgcolor="#0e8ccb"><font color="#FFFFFF" size="2"><strong><%=Html.Encode(obj_tot_facu.a2012) %></strong></font></td>
                                          <%end if%>
                                          <%if chequeo_2013 <> "" then%>
                                          <td colspan="2" bgcolor="#e85900"><font color="#FFFFFF" size="2"><strong><%=Html.Encode(obj_tot_facu.a2013) %></strong></font></td>
                                          <%end if%>
                                        </tr>
                                          <% 
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
                                <table bgcolor="#FFFFFF" class="tabla">
                                     <tr>
                                      <td>&nbsp;</td>
                                      <td>&nbsp;</td>
                                      <%if chequeo_2005 <> "" then%>
                                      <td width="18" height="18" bgcolor="#7dcaa7">&nbsp;</td>
                                      <td><font size="2"><strong>2005</strong></font></td>
                                      <%end if%>
                                      <%if chequeo_2006 <> "" then%>
                                      <td width="18" height="18" bgcolor="#f79820">&nbsp;</td>
                                      <td><font size="2"><strong>2006</strong></font></td>
                                      <%end if%>
                                      <%if chequeo_2007 <> "" then%>
                                      <td width="18" height="18" bgcolor="#23885b">&nbsp;</td>
                                      <td><font size="2"><strong>2007</strong></font></td>
                                      <%end if%>
                                      <%if chequeo_2008 <> "" then%>
                                      <td width="18" height="18" bgcolor="#7fa3d6">&nbsp;</td>
                                      <td><font size="2"><strong>2008</strong></font></td>
                                      <%end if%>
                                      <%if chequeo_2009 <> "" then%>
                                      <td width="18" height="18" bgcolor="#e77368">&nbsp;</td>
                                      <td><font size="2"><strong>2009</strong></font></td>
                                      <%end if%>
                                      <%if chequeo_2010 <> "" then%>
                                      <td width="18" height="18" bgcolor="#35cbe8">&nbsp;</td>
                                      <td><font size="2"><strong>2010</strong></font></td>
                                      <%end if%>
                                      <%if chequeo_2011 <> "" then%>
                                      <td width="18" height="18" bgcolor="#5cb200">&nbsp;</td>
                                      <td><font size="2"><strong>2011</strong></font></td>
                                      <%end if%>
                                      <%if chequeo_2012 <> "" then%>
                                      <td width="18" height="18" bgcolor="#0e8ccb">&nbsp;</td>
                                      <td><font size="2"><strong>2012</strong></font></td>
                                      <%end if%>
                                      <%if chequeo_2013 <> "" then%>
                                      <td width="18" height="18" bgcolor="#e85900">&nbsp;</td>
                                      <td><font size="2"><strong>2013</strong></font></td>
                                      <%end if%>
                                    </tr>
                            
                                    <%
                                    Dim obj_tot_jorn
                                    For each obj_tot_jorn in ModelTotalJornada.Items
                                    %>
                            
                                    <tr>
                                      <td colspan="2"><div align="left"><font size="2"><strong><%=Html.Encode(obj_tot_jorn.cabecera) %></strong></font></div></td>
                                      <%if chequeo_2005 <> "" then%>
                                      <td colspan="2" bgcolor="#7dcaa7"><font color="#FFFFFF" size="2"><strong><%=Html.Encode(obj_tot_jorn.a2005) %></strong></font></td>
                                      <%end if%>
                                      <%if chequeo_2006 <> "" then%>
                                      <td colspan="2" bgcolor="#f79820"><font color="#FFFFFF" size="2"><strong><%=Html.Encode(obj_tot_jorn.a2006) %></strong></font></td>
                                      <%end if%>
                                      <%if chequeo_2007 <> "" then%>
                                      <td colspan="2" bgcolor="#23885b"><font color="#FFFFFF" size="2"><strong><%=Html.Encode(obj_tot_jorn.a2007) %></strong></font></td>
                                      <%end if%>
                                      <%if chequeo_2008 <> "" then%>
                                      <td colspan="2" bgcolor="#7fa3d6"><font color="#FFFFFF" size="2"><strong><%=Html.Encode(obj_tot_jorn.a2008) %></strong></font></td>
                                      <%end if%>
                                      <%if chequeo_2009 <> "" then%>
                                      <td colspan="2" bgcolor="#e77368"><font color="#FFFFFF" size="2"><strong><%=Html.Encode(obj_tot_jorn.a2009) %></strong></font></td>
                                      <%end if%>
                                      <%if chequeo_2010 <> "" then%>
                                      <td colspan="2" bgcolor="#35cbe8"><font color="#FFFFFF" size="2"><strong><%=Html.Encode(obj_tot_jorn.a2010) %></strong></font></td>
                                      <%end if%>
                                      <%if chequeo_2011 <> "" then%>
                                      <td colspan="2" bgcolor="#5cb200"><font color="#FFFFFF" size="2"><strong><%=Html.Encode(obj_tot_jorn.a2011) %></strong></font></td>
                                      <%end if%>
                                      <%if chequeo_2012 <> "" then%>
                                      <td colspan="2" bgcolor="#0e8ccb"><font color="#FFFFFF" size="2"><strong><%=Html.Encode(obj_tot_jorn.a2012) %></strong></font></td>
                                      <%end if%>
                                      <%if chequeo_2013 <> "" then%>
                                      <td colspan="2" bgcolor="#e85900"><font color="#FFFFFF" size="2"><strong><%=Html.Encode(obj_tot_jorn.a2013) %></strong></font></td>
                                      <%end if%>
                                    </tr>
                                      <% 
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
                      <td colspan="2" align="left" style='font-size: 0.8em;'>
                       <div id="controlC" align="left"></div>
                      </td>
                   </tr>
                   <tr><td colspan="2">&nbsp;</td></tr>
                   <tr valign="top">
                       <td  width="65%" align="center" style='font-size: 0.6em;'>
                          <table width="100%">
                            <tr><td width="100%" align="center"><div id="tableC" class="tabla"></div></td></tr>
                            <tr><td width="100%" align="center">&nbsp;</td></tr>
                            <tr>
                                <td width="100%" align="center">
                                <table bgcolor="#FFFFFF" class="tabla">
                                     <tr>
                                      <td>&nbsp;</td>
                                      <td>&nbsp;</td>
                                      <%if chequeo_2005 <> "" then%>
                                      <td width="18" height="18" bgcolor="#7dcaa7">&nbsp;</td>
                                      <td><font size="2"><strong>2005</strong></font></td>
                                      <%end if%>
                                      <%if chequeo_2006 <> "" then%>
                                      <td width="18" height="18" bgcolor="#f79820">&nbsp;</td>
                                      <td><font size="2"><strong>2006</strong></font></td>
                                      <%end if%>
                                      <%if chequeo_2007 <> "" then%>
                                      <td width="18" height="18" bgcolor="#23885b">&nbsp;</td>
                                      <td><font size="2"><strong>2007</strong></font></td>
                                      <%end if%>
                                      <%if chequeo_2008 <> "" then%>
                                      <td width="18" height="18" bgcolor="#7fa3d6">&nbsp;</td>
                                      <td><font size="2"><strong>2008</strong></font></td>
                                      <%end if%>
                                      <%if chequeo_2009 <> "" then%>
                                      <td width="18" height="18" bgcolor="#e77368">&nbsp;</td>
                                      <td><font size="2"><strong>2009</strong></font></td>
                                      <%end if%>
                                      <%if chequeo_2010 <> "" then%>
                                      <td width="18" height="18" bgcolor="#35cbe8">&nbsp;</td>
                                      <td><font size="2"><strong>2010</strong></font></td>
                                      <%end if%>
                                      <%if chequeo_2011 <> "" then%>
                                      <td width="18" height="18" bgcolor="#5cb200">&nbsp;</td>
                                      <td><font size="2"><strong>2011</strong></font></td>
                                      <%end if%>
                                      <%if chequeo_2012 <> "" then%>
                                      <td width="18" height="18" bgcolor="#0e8ccb">&nbsp;</td>
                                      <td><font size="2"><strong>2012</strong></font></td>
                                      <%end if%>
                                      <%if chequeo_2013 <> "" then%>
                                      <td width="18" height="18" bgcolor="#e85900">&nbsp;</td>
                                      <td><font size="2"><strong>2013</strong></font></td>
                                      <%end if%>
                                    </tr>
                            
                                    <%
                                    Dim obj_tot_carr
                                    For each obj_tot_carr in ModelTotalCarrera.Items
                                    %>
                            
                                    <tr>
                                      <td colspan="2"><div align="left"><font size="2"><strong><%=Html.Encode(obj_tot_carr.cabecera) %></strong></font></div></td>
                                      <%if chequeo_2005 <> "" then%>
                                      <td colspan="2" bgcolor="#7dcaa7"><font color="#FFFFFF" size="2"><strong><%=Html.Encode(obj_tot_carr.a2005) %></strong></font></td>
                                      <%end if%>
                                      <%if chequeo_2006 <> "" then%>
                                      <td colspan="2" bgcolor="#f79820"><font color="#FFFFFF" size="2"><strong><%=Html.Encode(obj_tot_carr.a2006) %></strong></font></td>
                                      <%end if%>
                                      <%if chequeo_2007 <> "" then%>
                                      <td colspan="2" bgcolor="#23885b"><font color="#FFFFFF" size="2"><strong><%=Html.Encode(obj_tot_carr.a2007) %></strong></font></td>
                                      <%end if%>
                                      <%if chequeo_2008 <> "" then%>
                                      <td colspan="2" bgcolor="#7fa3d6"><font color="#FFFFFF" size="2"><strong><%=Html.Encode(obj_tot_carr.a2008) %></strong></font></td>
                                      <%end if%>
                                      <%if chequeo_2009 <> "" then%>
                                      <td colspan="2" bgcolor="#e77368"><font color="#FFFFFF" size="2"><strong><%=Html.Encode(obj_tot_carr.a2009) %></strong></font></td>
                                      <%end if%>
                                      <%if chequeo_2010 <> "" then%>
                                      <td colspan="2" bgcolor="#35cbe8"><font color="#FFFFFF" size="2"><strong><%=Html.Encode(obj_tot_carr.a2010) %></strong></font></td>
                                      <%end if%>
                                      <%if chequeo_2011 <> "" then%>
                                      <td colspan="2" bgcolor="#5cb200"><font color="#FFFFFF" size="2"><strong><%=Html.Encode(obj_tot_carr.a2011) %></strong></font></td>
                                      <%end if%>
                                      <%if chequeo_2012 <> "" then%>
                                      <td colspan="2" bgcolor="#0e8ccb"><font color="#FFFFFF" size="2"><strong><%=Html.Encode(obj_tot_carr.a2012) %></strong></font></td>
                                      <%end if%>
                                      <%if chequeo_2013 <> "" then%>
                                      <td colspan="2" bgcolor="#e85900"><font color="#FFFFFF" size="2"><strong><%=Html.Encode(obj_tot_carr.a2013) %></strong></font></td>
                                      <%end if%>
                                    </tr>
                                    <% 
                                    Next
                                    %>
                                 </table>
                                </td>
                            </tr> 
                          </table>
                       </td>
                       <td  width="35%" align="center" style='font-size: 0.6em;'>
                            <div id="chartC"></div>
                       </td>
                   </tr>
                 </table>
         </div>
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