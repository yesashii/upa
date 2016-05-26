
      <script type="text/javascript">
          //two variables Controller and Action have to be initialized in the View HTML code
          var Controller ='DocenteJerarquiaGrado';
          var Action = 'List';
      </script>
           
      <%
	  chequeo_2005=""
	  chequeo_2006=""
	  chequeo_2007=""
	  chequeo_2008=""
	  chequeo_2009="checked='checked'"
	  chequeo_2010="checked='checked'"
	  chequeo_2011="checked='checked'"
	  chequeo_2012="checked='checked'"
	  chequeo_2013="checked='checked'"
	  chequeo_2014="checked='checked'"
	  complemento_url = ""
  	  url_detalle = "&q="
	  maximo_anio = 2009
	  inicial = request.form("inicial")
	  if inicial = "" then
	  	inicial= 1
	  end if
	  if request.form("c2009")="" then
	  	chequeo_2009=""
	  else
	    complemento_url = complemento_url&"&e2009=1"
		maximo_anio = 2009
	  end if
	  if request.form("c2010")=""  then
	  	chequeo_2010=""
	  else
	    complemento_url = complemento_url&"&e2010=1"
		maximo_anio = 2010
	  end if
	  if request.form("c2011")=""  and inicial <> 1 then
	  	chequeo_2011=""
	  else
	    complemento_url = complemento_url&"&e2011=1"
		maximo_anio = 2011
	  end if
	  if request.form("c2012")=""  and inicial <> 1 then
	  	chequeo_2012=""
	  else
	    complemento_url = complemento_url&"&e2012=1"
		maximo_anio = 2012
	  end if
	  if request.form("c2013")=""  and inicial <> 1 then
	  	chequeo_2013=""
	  else
	    complemento_url = complemento_url&"&e2013=1"
		maximo_anio = 2013
	  end if
	  if request.form("c2014")="" and inicial <> 1 then
	  	chequeo_2014=""
	  else
	    complemento_url = complemento_url&"&e2014=1"
		maximo_anio = 2014
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
          ['Periodo','Jerarquia','1. Doctores (PhD)','2. Magister','3. Licenciados o Titulados','4. Técnicos']
		       <%Dim obj0,obj01,obj02, valor_periodo,cabe
			      cadena = ""
				  jera_seleccionada_1 = ""
                  For each obj0 in Model.Items
				    cabe = Html.Encode(obj0.cabecera)
					if jera_seleccionada_1 = "" then
						jera_seleccionada_1 = cabe
					end if
					if instr(cadena, cabe) = 0 then 
					   cadena = cadena + cabe
						if chequeo_2009 <> "" then
							response.Write(",['2009','"+cabe+"',")
							valor_periodo = "0"
							For each obj01 in Model.Items
							  if Html.Encode(obj01.cabecera) = cabe and Html.Encode(obj01.grado)= "1. Doctores (PhD)" then
								valor_periodo = Html.Encode(obj01.a2009)
							  end if
							next
							response.Write(valor_periodo+",")
							valor_periodo = "0"
							For each obj01 in Model.Items
							  if Html.Encode(obj01.cabecera) = cabe and Html.Encode(obj01.grado)= "2. Magister" then
								valor_periodo = Html.Encode(obj01.a2009)
							  end if
							next
							response.Write(valor_periodo+",")
							valor_periodo = "0"
							For each obj01 in Model.Items
							  if Html.Encode(obj01.cabecera) = cabe and Html.Encode(obj01.grado)= "3. Licenciados o Titulados" then
								valor_periodo = Html.Encode(obj01.a2009)
							  end if
							next
							response.Write(valor_periodo+",")
							valor_periodo = "0"
							For each obj01 in Model.Items
							  if Html.Encode(obj01.cabecera) = cabe and Html.Encode(obj01.grado)= "4. Técnicos" then
								valor_periodo = Html.Encode(obj01.a2009)
							  end if
							next
							response.Write(valor_periodo+"]")
						end if
						if chequeo_2010 <> "" then
							response.Write(",['2010','"+cabe+"',")
							valor_periodo = "0"
							For each obj01 in Model.Items
							  if Html.Encode(obj01.cabecera) = cabe and Html.Encode(obj01.grado)= "1. Doctores (PhD)" then
								valor_periodo = Html.Encode(obj01.a2010)
							  end if
							next
  						    response.Write(valor_periodo+",")
							valor_periodo = "0"
							For each obj01 in Model.Items
							  if Html.Encode(obj01.cabecera) = cabe and Html.Encode(obj01.grado)= "2. Magister" then
								valor_periodo = Html.Encode(obj01.a2010)
							  end if
							next
							response.Write(valor_periodo+",")
							valor_periodo = "0"
							For each obj01 in Model.Items
							  if Html.Encode(obj01.cabecera) = cabe and Html.Encode(obj01.grado)= "3. Licenciados o Titulados" then
								valor_periodo = Html.Encode(obj01.a2010)
							  end if
							next
							response.Write(valor_periodo+",")
							valor_periodo = "0"
							For each obj01 in Model.Items
							  if Html.Encode(obj01.cabecera) = cabe and Html.Encode(obj01.grado)= "4. Técnicos" then
								valor_periodo = Html.Encode(obj01.a2010)
							  end if
							next
							response.Write(valor_periodo+"]")
						end if
						if chequeo_2011 <> "" then
							response.Write(",['2011','"+cabe+"',")
							valor_periodo = "0"
							For each obj01 in Model.Items
							  if Html.Encode(obj01.cabecera) = cabe and Html.Encode(obj01.grado)= "1. Doctores (PhD)" then
								valor_periodo = Html.Encode(obj01.a2011)
							  end if
							next
							response.Write(valor_periodo+",")
							valor_periodo = "0"
							For each obj01 in Model.Items
							  if Html.Encode(obj01.cabecera) = cabe and Html.Encode(obj01.grado)= "2. Magister" then
								valor_periodo = Html.Encode(obj01.a2011)
							  end if
							next
							response.Write(valor_periodo+",")
							valor_periodo = "0"
							For each obj01 in Model.Items
							  if Html.Encode(obj01.cabecera) = cabe and Html.Encode(obj01.grado)= "3. Licenciados o Titulados" then
								valor_periodo = Html.Encode(obj01.a2011)
							  end if
							next
							response.Write(valor_periodo+",")
							valor_periodo = "0"
							For each obj01 in Model.Items
							  if Html.Encode(obj01.cabecera) = cabe and Html.Encode(obj01.grado)= "4. Técnicos" then
								valor_periodo = Html.Encode(obj01.a2011)
							  end if
							next
							response.Write(valor_periodo+"]")
						end if
						if chequeo_2012 <> "" then
							response.Write(",['2012','"+cabe+"',")
							valor_periodo = "0"
							For each obj01 in Model.Items
							  if Html.Encode(obj01.cabecera) = cabe and Html.Encode(obj01.grado)= "1. Doctores (PhD)" then
								valor_periodo = Html.Encode(obj01.a2012)
							  end if
							next
							response.Write(valor_periodo+",")
							valor_periodo = "0"
							For each obj01 in Model.Items
							  if Html.Encode(obj01.cabecera) = cabe and Html.Encode(obj01.grado)= "2. Magister" then
								valor_periodo = Html.Encode(obj01.a2012)
							  end if
							next
							response.Write(valor_periodo+",")
							valor_periodo = "0"
							For each obj01 in Model.Items
							  if Html.Encode(obj01.cabecera) = cabe and Html.Encode(obj01.grado)= "3. Licenciados o Titulados" then
								valor_periodo = Html.Encode(obj01.a2012)
							  end if
							next
							response.Write(valor_periodo+",")
							valor_periodo = "0"
							For each obj01 in Model.Items
							  if Html.Encode(obj01.cabecera) = cabe and Html.Encode(obj01.grado)= "4. Técnicos" then
								valor_periodo = Html.Encode(obj01.a2012)
							  end if
							next
							response.Write(valor_periodo+"]")
						end if
						if chequeo_2013 <> "" then
							response.Write(",['2013','"+cabe+"',")
							valor_periodo = "0"
							For each obj01 in Model.Items
							  if Html.Encode(obj01.cabecera) = cabe and Html.Encode(obj01.grado)= "1. Doctores (PhD)" then
								valor_periodo = Html.Encode(obj01.a2013)
							  end if
							next
							response.Write(valor_periodo+",")
							valor_periodo = "0"
							For each obj01 in Model.Items
							  if Html.Encode(obj01.cabecera) = cabe and Html.Encode(obj01.grado)= "2. Magister" then
								valor_periodo = Html.Encode(obj01.a2013)
							  end if
							next
							response.Write(valor_periodo+",")
							valor_periodo = "0"
							For each obj01 in Model.Items
							  if Html.Encode(obj01.cabecera) = cabe and Html.Encode(obj01.grado)= "3. Licenciados o Titulados" then
								valor_periodo = Html.Encode(obj01.a2013)
							  end if
							next
							response.Write(valor_periodo+",")
							valor_periodo = "0"
							For each obj01 in Model.Items
							  if Html.Encode(obj01.cabecera) = cabe and Html.Encode(obj01.grado)= "4. Técnicos" then
								valor_periodo = Html.Encode(obj01.a2013)
							  end if
							next
							response.Write(valor_periodo+"]")
						end if
						if chequeo_2014 <> "" then
							response.Write(",['2014','"+cabe+"',")
							valor_periodo = "0"
							For each obj01 in Model.Items
							  if Html.Encode(obj01.cabecera) = cabe and Html.Encode(obj01.grado)= "1. Doctores (PhD)" then
								valor_periodo = Html.Encode(obj01.a2014)
							  end if
							next
							response.Write(valor_periodo+",")
							valor_periodo = "0"
							For each obj01 in Model.Items
							  if Html.Encode(obj01.cabecera) = cabe and Html.Encode(obj01.grado)= "2. Magister" then
								valor_periodo = Html.Encode(obj01.a2014)
							  end if
							next
							response.Write(valor_periodo+",")
							valor_periodo = "0"
							For each obj01 in Model.Items
							  if Html.Encode(obj01.cabecera) = cabe and Html.Encode(obj01.grado)= "3. Licenciados o Titulados" then
								valor_periodo = Html.Encode(obj01.a2014)
							  end if
							next
							response.Write(valor_periodo+",")
							valor_periodo = "0"
							For each obj01 in Model.Items
							  if Html.Encode(obj01.cabecera) = cabe and Html.Encode(obj01.grado)= "4. Técnicos" then
								valor_periodo = Html.Encode(obj01.a2014)
							  end if
							next
							response.Write(valor_periodo+"]")
						end if
					end if
				   next%>
        ]);
      
	  //Para Horas
	  var data_Horas = google.visualization.arrayToDataTable([
          ['Periodo','Jerarquia','1. Doctores (PhD)','2. Magister','3. Licenciados o Titulados','4. Técnicos']
		       <%Dim obj_f
			      cadena = ""
				  jera_seleccionada_2 = ""
                  For each obj_f in ModelHoras.Items
				    cabe = Html.Encode(obj_f.cabecera)
					if jera_seleccionada_2 = "" then
						jera_seleccionada_2 = cabe
					end if
					if instr(cadena, cabe) = 0 then 
					   cadena = cadena + cabe
						if chequeo_2009 <> "" then
							response.Write(",['2009','"+cabe+"',")
							valor_periodo = "0"
							For each obj01 in ModelHoras.Items
							  if Html.Encode(obj01.cabecera) = cabe and Html.Encode(obj01.grado)= "1. Doctores (PhD)" then
								valor_periodo = Html.Encode(obj01.a2009)
							  end if
							next
							response.Write(valor_periodo+",")
							valor_periodo = "0"
							For each obj01 in ModelHoras.Items
							  if Html.Encode(obj01.cabecera) = cabe and Html.Encode(obj01.grado)= "2. Magister" then
								valor_periodo = Html.Encode(obj01.a2009)
							  end if
							next
							response.Write(valor_periodo+",")
							valor_periodo = "0"
							For each obj01 in ModelHoras.Items
							  if Html.Encode(obj01.cabecera) = cabe and Html.Encode(obj01.grado)= "3. Licenciados o Titulados" then
								valor_periodo = Html.Encode(obj01.a2009)
							  end if
							next
							response.Write(valor_periodo+",")
							valor_periodo = "0"
							For each obj01 in ModelHoras.Items
							  if Html.Encode(obj01.cabecera) = cabe and Html.Encode(obj01.grado)= "4. Técnicos" then
								valor_periodo = Html.Encode(obj01.a2009)
							  end if
							next
							response.Write(valor_periodo+"]")
						end if
						if chequeo_2010 <> "" then
							response.Write(",['2010','"+cabe+"',")
							valor_periodo = "0"
							For each obj01 in ModelHoras.Items
							  if Html.Encode(obj01.cabecera) = cabe and Html.Encode(obj01.grado)= "1. Doctores (PhD)" then
								valor_periodo = Html.Encode(obj01.a2010)
							  end if
							next
							response.Write(valor_periodo+",")
							valor_periodo = "0"
							For each obj01 in ModelHoras.Items
							  if Html.Encode(obj01.cabecera) = cabe and Html.Encode(obj01.grado)= "2. Magister" then
								valor_periodo = Html.Encode(obj01.a2010)
							  end if
							next
							response.Write(valor_periodo+",")
							valor_periodo = "0"
							For each obj01 in ModelHoras.Items
							  if Html.Encode(obj01.cabecera) = cabe and Html.Encode(obj01.grado)= "3. Licenciados o Titulados" then
								valor_periodo = Html.Encode(obj01.a2010)
							  end if
							next
							response.Write(valor_periodo+",")
							valor_periodo = "0"
							For each obj01 in ModelHoras.Items
							  if Html.Encode(obj01.cabecera) = cabe and Html.Encode(obj01.grado)= "4. Técnicos" then
								valor_periodo = Html.Encode(obj01.a2010)
							  end if
							next
							response.Write(valor_periodo+"]")
						end if
						if chequeo_2011 <> "" then
							response.Write(",['2011','"+cabe+"',")
							valor_periodo = "0"
							For each obj01 in ModelHoras.Items
							  if Html.Encode(obj01.cabecera) = cabe and Html.Encode(obj01.grado)= "1. Doctores (PhD)" then
								valor_periodo = Html.Encode(obj01.a2011)
							  end if
							next
							response.Write(valor_periodo+",")
							valor_periodo = "0"
							For each obj01 in ModelHoras.Items
							  if Html.Encode(obj01.cabecera) = cabe and Html.Encode(obj01.grado)= "2. Magister" then
								valor_periodo = Html.Encode(obj01.a2011)
							  end if
							next
							response.Write(valor_periodo+",")
							valor_periodo = "0"
							For each obj01 in ModelHoras.Items
							  if Html.Encode(obj01.cabecera) = cabe and Html.Encode(obj01.grado)= "3. Licenciados o Titulados" then
								valor_periodo = Html.Encode(obj01.a2011)
							  end if
							next
							response.Write(valor_periodo+",")
							valor_periodo = "0"
							For each obj01 in ModelHoras.Items
							  if Html.Encode(obj01.cabecera) = cabe and Html.Encode(obj01.grado)= "4. Técnicos" then
								valor_periodo = Html.Encode(obj01.a2011)
							  end if
							next
							response.Write(valor_periodo+"]")
						end if
						if chequeo_2012 <> "" then
							response.Write(",['2012','"+cabe+"',")
							valor_periodo = "0"
							For each obj01 in ModelHoras.Items
							  if Html.Encode(obj01.cabecera) = cabe and Html.Encode(obj01.grado)= "1. Doctores (PhD)" then
								valor_periodo = Html.Encode(obj01.a2012)
							  end if
							next
							response.Write(valor_periodo+",")
							valor_periodo = "0"
							For each obj01 in ModelHoras.Items
							  if Html.Encode(obj01.cabecera) = cabe and Html.Encode(obj01.grado)= "2. Magister" then
								valor_periodo = Html.Encode(obj01.a2012)
							  end if
							next
							response.Write(valor_periodo+",")
							valor_periodo = "0"
							For each obj01 in ModelHoras.Items
							  if Html.Encode(obj01.cabecera) = cabe and Html.Encode(obj01.grado)= "3. Licenciados o Titulados" then
								valor_periodo = Html.Encode(obj01.a2012)
							  end if
							next
							response.Write(valor_periodo+",")
							valor_periodo = "0"
							For each obj01 in ModelHoras.Items
							  if Html.Encode(obj01.cabecera) = cabe and Html.Encode(obj01.grado)= "4. Técnicos" then
								valor_periodo = Html.Encode(obj01.a2012)
							  end if
							next
							response.Write(valor_periodo+"]")
						end if
						if chequeo_2013 <> "" then
							response.Write(",['2013','"+cabe+"',")
							valor_periodo = "0"
							For each obj01 in ModelHoras.Items
							  if Html.Encode(obj01.cabecera) = cabe and Html.Encode(obj01.grado)= "1. Doctores (PhD)" then
								valor_periodo = Html.Encode(obj01.a2013)
							  end if
							next
							response.Write(valor_periodo+",")
							valor_periodo = "0"
							For each obj01 in ModelHoras.Items
							  if Html.Encode(obj01.cabecera) = cabe and Html.Encode(obj01.grado)= "2. Magister" then
								valor_periodo = Html.Encode(obj01.a2013)
							  end if
							next
							response.Write(valor_periodo+",")
							valor_periodo = "0"
							For each obj01 in ModelHoras.Items
							  if Html.Encode(obj01.cabecera) = cabe and Html.Encode(obj01.grado)= "3. Licenciados o Titulados" then
								valor_periodo = Html.Encode(obj01.a2013)
							  end if
							next
							response.Write(valor_periodo+",")
							valor_periodo = "0"
							For each obj01 in ModelHoras.Items
							  if Html.Encode(obj01.cabecera) = cabe and Html.Encode(obj01.grado)= "4. Técnicos" then
								valor_periodo = Html.Encode(obj01.a2013)
							  end if
							next
							response.Write(valor_periodo+"]")
						end if
						if chequeo_2014 <> "" then
							response.Write(",['2014','"+cabe+"',")
							valor_periodo = "0"
							For each obj01 in ModelHoras.Items
							  if Html.Encode(obj01.cabecera) = cabe and Html.Encode(obj01.grado)= "1. Doctores (PhD)" then
								valor_periodo = Html.Encode(obj01.a2014)
							  end if
							next
							response.Write(valor_periodo+",")
							valor_periodo = "0"
							For each obj01 in ModelHoras.Items
							  if Html.Encode(obj01.cabecera) = cabe and Html.Encode(obj01.grado)= "2. Magister" then
								valor_periodo = Html.Encode(obj01.a2014)
							  end if
							next
							response.Write(valor_periodo+",")
							valor_periodo = "0"
							For each obj01 in ModelHoras.Items
							  if Html.Encode(obj01.cabecera) = cabe and Html.Encode(obj01.grado)= "3. Licenciados o Titulados" then
								valor_periodo = Html.Encode(obj01.a2014)
							  end if
							next
							response.Write(valor_periodo+",")
							valor_periodo = "0"
							For each obj01 in ModelHoras.Items
							  if Html.Encode(obj01.cabecera) = cabe and Html.Encode(obj01.grado)= "4. Técnicos" then
								valor_periodo = Html.Encode(obj01.a2014)
							  end if
							next
							response.Write(valor_periodo+"]")
						end if
					end if
				   next%>
        ]);
	  
	  	  
       var periodoPicker = new google.visualization.ControlWrapper({
          'controlType': 'CategoryFilter',
          'containerId': 'control2',
          'options': {
            'filterColumnLabel': 'Jerarquia',
			'ui': {
              'labelStacking': 'horizontal',
              'allowTyping': false,
              'allowMultiple': false
            }
          },
		// Define an initial state, i.e. a set of metrics to be initially selected.
		  'state': {'selectedValues': ['<%=jera_seleccionada_1%>']}
        });
		
		var periodoPickerHoras = new google.visualization.ControlWrapper({
          'controlType': 'CategoryFilter',
          'containerId': 'controlH',
          'options': {
            'filterColumnLabel': 'Jerarquia',
			'ui': {
              'labelStacking': 'horizontal',
              'allowTyping': false,
              'allowMultiple': false
            }
          },
		// Define an initial state, i.e. a set of metrics to be initially selected.
		  'state': {'selectedValues': ['<%=jera_seleccionada_2%>']}
        });
		
		// Define a bar chart to show 'Population' data
        var ColumnChartTotal = new google.visualization.ChartWrapper({
          'chartType': 'ColumnChart',
          'containerId': 'chart1',
          'options': {
            'width': 320,
            'height': 320,
			//'isStacked': true,
			'colors':['#6fa9ce','#ffe799','#fa7874','#90c7a0','#eda64d','#1998cc','#f1f25a','#79ce5b'],
            'chartArea': {top: 0, right: 0, bottom: 0}
          },
          // Configure the barchart to use columns 2 (City) and 3 (Population)
          'view': {'columns': [0,2,3,4,5]}
        });
		
		var ColumnChartHoras = new google.visualization.ChartWrapper({
          'chartType': 'BarChart',
          'containerId': 'chartH',
          'options': {
            'width': 320,
            'height': 320,
			//'isStacked': true,
			'colors':['#6fa9ce','#ffe799','#fa7874','#90c7a0','#eda64d','#1998cc','#f1f25a','#79ce5b'],
            'chartArea': {top: 0, right: 0, bottom: 0}
          },
          // Configure the barchart to use columns 2 (City) and 3 (Population)
          'view': {'columns': [0,2,3,4,5]}
        });
		
		 // Define a table
        var table_total = new google.visualization.ChartWrapper({
          'chartType': 'Table',
          'containerId': 'tableT',
          'options': {
              'width': '550px',
			  'page' : 'enable',
			  'pageSize' : '4'
          }
        });
		var table_hora = new google.visualization.ChartWrapper({
          'chartType': 'Table',
          'containerId': 'tableH',
          'options': {
			  'width': '550px',
			  'page' : 'enable',
			  'pageSize' : '4'
          }
        });
	     
        // Create the dashboard.
        new google.visualization.Dashboard(document.getElementById('dashboard')).
		  bind(periodoPicker, [ColumnChartTotal,table_total]).		  
          draw(data);
		  
		new google.visualization.Dashboard(document.getElementById('dashboardHoras')).
		  bind(periodoPickerHoras, [ColumnChartHoras , table_hora]).		  
          draw(data_Horas);  
					    
      }
      

      google.setOnLoadCallback(drawVisualization);
    </script>
     <!-- <div class='GridViewScrollContainer'>-->
     <div id="cuadro0">
     <br />
     <h1>N° de docentes por Jerarquia y grado acad&eacute;mico</h1>
     <p><i>"Cantidad de docentes y total de horas cronológicas semanales, distribuidas por jerarquia y grado acad&eacute;mico".</i></p>
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
                        <td colspan="10"><H3 class="shad">Seleccione años a consultar</H3></td>
                    </tr>
                    <tr>
                        <td width="10%" align="center"><input type="checkbox" name="c2005" value="2005" <%=chequeo_2005%> onchange="document.formu_anos.submit();" ></td>
                        <td width="10%" align="center"><input type="checkbox" name="c2006" value="2006" <%=chequeo_2006%> onchange="document.formu_anos.submit();" ></td>
                        <td width="10%" align="center"><input type="checkbox" name="c2007" value="2007" <%=chequeo_2007%> onchange="document.formu_anos.submit();" ></td>
                        <td width="10%" align="center"><input type="checkbox" name="c2008" value="2008" <%=chequeo_2008%> onchange="document.formu_anos.submit();" ></td>
                        <td width="10%" align="center"><input type="checkbox" name="c2009" value="2009" <%=chequeo_2009%> onchange="document.formu_anos.submit();" ></td>
                        <td width="10%" align="center"><input type="checkbox" name="c2010" value="2010" <%=chequeo_2010%> onchange="document.formu_anos.submit();" ></td>
                        <td width="10%" align="center"><input type="checkbox" name="c2011" value="2011" <%=chequeo_2011%> onchange="document.formu_anos.submit();" ></td>
                        <td width="10%" align="center"><input type="checkbox" name="c2012" value="2012" <%=chequeo_2012%> onchange="document.formu_anos.submit();" ></td>
                        <td width="10%" align="center"><input type="checkbox" name="c2013" value="2013" <%=chequeo_2013%> onchange="document.formu_anos.submit();" ></td>
						<td width="10%" align="center"><input type="checkbox" name="c2014" value="2014" <%=chequeo_2014%> onchange="document.formu_anos.submit();" ></td>
                    </tr>
                    <tr>
                        <td width="10%" align="center"><font color="#999999">2005</font></td>
                        <td width="10%" align="center"><font color="#999999">2006</font></td>
                        <td width="10%" align="center"><font color="#999999">2007</font></td>
                        <td width="10%" align="center"><font color="#999999">2008</font></td>
                        <td width="10%" align="center"><font color="#999999">2009</font></td>
                        <td width="10%" align="center"><font color="#999999">2010</font></td>
                        <td width="10%" align="center"><font color="#999999">2011</font></td>
                        <td width="10%" align="center"><font color="#999999">2012</font></td>
                        <td width="10%" align="center"><font color="#999999">2013</font></td>
						<td width="10%" align="center"><font color="#999999">2014</font></td>
                    </tr>
                    <tr>
                    	<td colspan="10" align="right">
				            <%=Html.ActionLink("<div class='btn' align='right'>Obtener Excel</div>","DocenteJerarquiaGrado","List_excel", "partial=excel"&complemento_url)%>
                            <%if session("_pers_ncorr_") = "0" then 
							   response.Write(Html.ActionLink("<div class='btn' align='right'>Detalle "&maximo_anio&"</div>","ExcelDetalleProfesores","List_excel", "partial=excel"&url_detalle))
							  end if
							%>
                        </td>	
                    </tr>
                    
               </table>
               </form>
     </div>
     <br />
     <div id="titulo2" class="titulo">
     N° de docentes
     <input name="imagefield" type="image" src="Content/minimizar.jpg" onclick="minimizar('capa2_dh')"/>
     <input name="imagefield" type="image" src="Content/encuadre.jpg" onclick="maximizar('capa2_dh')"/>
     <input name="imagefield" type="image" src="Content/cerrar.jpg" style="margin-right:3px;" onclick="minimizar('capa2_dh');minimizar('titulo2')"/>
     </div>
     <div id="capa2_dh">
        <div id="dashboard">
                  <table width="980">
                   <tr style='vertical-align: top'>
                      <td colspan="2" align="left" style='font-size: 0.8em;'>
                       <div id="control2" align="left"></div>
                      </td>
                   </tr>
                   <tr valign="top">
                       <td  width="65%" align="center" style='font-size: 0.6em;'>
                          <table width="100%">
                            <tr><td width="100%" align="center"><div id="tableT"  class="tabla"></div></td></tr>
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
									  <%if chequeo_2014 <> "" then%>
                                      <td width="18" height="18" bgcolor="#e85900">&nbsp;</td>
                                      <td><font size="2"><strong>2014</strong></font></td>
                                      <%end if%>
                                    </tr>
                            
                                    <%
                                    Dim obj_tot_carr
                                    For each obj_tot_carr in ModelTotal.Items
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
									  <%if chequeo_2014 <> "" then%>
                                      <td colspan="2" bgcolor="#e85900"><font color="#FFFFFF" size="2"><strong><%=Html.Encode(obj_tot_carr.a2014) %></strong></font></td>
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
     <br />
     <div id="titulo3" class="titulo">
     Total de horas semanales
     <input name="imagefield" type="image" src="Content/minimizar.jpg" onclick="minimizar('capa3_dh')"/>
     <input name="imagefield" type="image" src="Content/encuadre.jpg" onclick="maximizar('capa3_dh')"/>
     <input name="imagefield" type="image" src="Content/cerrar.jpg" style="margin-right:3px;" onclick="minimizar('capa3_dh');minimizar('titulo3')"/>
     </div>
       <div id="capa3_dh">
          <div id="dashboardHoras">
                  <table width="980">
                   <tr style='vertical-align: top'>
                      <td colspan="2" align="left" style='font-size: 0.8em;'>
                       <div id="controlH" align="left"></div>
                      </td>
                   </tr>
                   <tr valign="top">
                       <td  width="65%" align="center" style='font-size: 0.6em;'>
                          <table width="100%">
                            <tr><td width="100%" align="center"><div id="tableH"  class="tabla"></div></td></tr>
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
									  <%if chequeo_2014 <> "" then%>
                                      <td width="18" height="18" bgcolor="#e85900">&nbsp;</td>
                                      <td><font size="2"><strong>2014</strong></font></td>
                                      <%end if%>
                                    </tr>
                            
                                    <%
                                    Dim obj_tot_horas
                                    For each obj_tot_horas in ModelTotalHoras.Items
                                    %>
                            
                                    <tr>
                                      <td colspan="2"><div align="left"><font size="2"><strong><%=Html.Encode(obj_tot_horas.cabecera) %></strong></font></div></td>
                                      <%if chequeo_2005 <> "" then%>
                                      <td colspan="2" bgcolor="#7dcaa7"><font color="#FFFFFF" size="2"><strong><%=Html.Encode(obj_tot_horas.a2005) %></strong></font></td>
                                      <%end if%>
                                      <%if chequeo_2006 <> "" then%>
                                      <td colspan="2" bgcolor="#f79820"><font color="#FFFFFF" size="2"><strong><%=Html.Encode(obj_tot_horas.a2006) %></strong></font></td>
                                      <%end if%>
                                      <%if chequeo_2007 <> "" then%>
                                      <td colspan="2" bgcolor="#23885b"><font color="#FFFFFF" size="2"><strong><%=Html.Encode(obj_tot_horas.a2007) %></strong></font></td>
                                      <%end if%>
                                      <%if chequeo_2008 <> "" then%>
                                      <td colspan="2" bgcolor="#7fa3d6"><font color="#FFFFFF" size="2"><strong><%=Html.Encode(obj_tot_horas.a2008) %></strong></font></td>
                                      <%end if%>
                                      <%if chequeo_2009 <> "" then%>
                                      <td colspan="2" bgcolor="#e77368"><font color="#FFFFFF" size="2"><strong><%=Html.Encode(obj_tot_horas.a2009) %></strong></font></td>
                                      <%end if%>
                                      <%if chequeo_2010 <> "" then%>
                                      <td colspan="2" bgcolor="#35cbe8"><font color="#FFFFFF" size="2"><strong><%=Html.Encode(obj_tot_horas.a2010) %></strong></font></td>
                                      <%end if%>
                                      <%if chequeo_2011 <> "" then%>
                                      <td colspan="2" bgcolor="#5cb200"><font color="#FFFFFF" size="2"><strong><%=Html.Encode(obj_tot_horas.a2011) %></strong></font></td>
                                      <%end if%>
                                      <%if chequeo_2012 <> "" then%>
                                      <td colspan="2" bgcolor="#0e8ccb"><font color="#FFFFFF" size="2"><strong><%=Html.Encode(obj_tot_horas.a2012) %></strong></font></td>
                                      <%end if%>
                                      <%if chequeo_2013 <> "" then%>
                                      <td colspan="2" bgcolor="#e85900"><font color="#FFFFFF" size="2"><strong><%=Html.Encode(obj_tot_horas.a2013) %></strong></font></td>
                                      <%end if%>
									  <%if chequeo_2014 <> "" then%>
                                      <td colspan="2" bgcolor="#e85900"><font color="#FFFFFF" size="2"><strong><%=Html.Encode(obj_tot_horas.a2014) %></strong></font></td>
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
                            <div id="chartH"></div>
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