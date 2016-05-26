<!-- #include file = "../biblioteca/_conexion.asp" -->
<!-- #include file = "../biblioteca/_negocio.asp" -->

<%

'---------------------------------------------------------------------------------------------------
set pagina = new CPagina
pagina.Titulo = "POSTULACIÓN A CARRERAS SEGÚN FORMAS DE ACCESO"
'---------------------------------------------------------------------------------------------------

set conexion = new CConexion
conexion.Inicializar "upacifico"

set negocio = new CNegocio
negocio.Inicializa conexion

periodo=negocio.obtenerPeriodoAcademico("Postulacion")

set f_botonera = new CFormulario
f_botonera.Carga_Parametros "reportes_x_dias.xml", "botonera"

set lista = new CFormulario
lista.carga_parametros "tabla_vacia.xml", "tabla"

consulta = " select b.peri_ccod,opcion, " & vbCrLf &_
 		   "  (select count(*) " & vbCrLf &_
           "             from ip_postulaciones tt (nolock), postulantes t2 (nolock) " & vbCrLf &_
           "             where tt.post_ncorr=t2.post_ncorr " & vbCrLf &_
           "             and t2.post_bnuevo='S' and t2.peri_ccod=b.peri_ccod " & vbCrLf &_
           "             and tt.OPCION = a.OPCION  " & vbCrLf &_
           "             and (tt.IP_GENERAL like '10.%' or tt.IP_GENERAL like '172.%' or tt.IP_GENERAL like '192.168.%'  or tt.IP_GENERAL = '200.27.186.129' or tt.IP_GENERAL = '200.27.186.130'  or tt.IP_GENERAL = '200.27.186.131'   or tt.IP_GENERAL = '200.27.186.132'  or tt.IP_GENERAL = '200.27.186.133'  or tt.IP_GENERAL = '200.27.186.134')) as internas, " & vbCrLf &_
           "  (select count(*) " & vbCrLf &_
           "             from ip_postulaciones tt (nolock), postulantes t2 (nolock) " & vbCrLf &_
           "             where tt.post_ncorr=t2.post_ncorr " & vbCrLf &_
           "             and t2.post_bnuevo='S' and t2.peri_ccod=b.peri_ccod " & vbCrLf &_
           "             and tt.OPCION = a.OPCION  " & vbCrLf &_
           "             and (tt.IP_GENERAL not like '10.%' and  tt.IP_GENERAL not like '172.%' and tt.IP_GENERAL not like '192.168.%' and tt.IP_GENERAL <> '200.27.186.129' and tt.IP_GENERAL <> '200.27.186.130'  and tt.IP_GENERAL <> '200.27.186.131'   and tt.IP_GENERAL <> '200.27.186.132' and tt.IP_GENERAL <> '200.27.186.133'  and tt.IP_GENERAL <> '200.27.186.134')) as externas, " & vbCrLf &_
		   " count(*) as total  " & vbCrLf &_
		   " from ip_postulaciones a (nolock), postulantes b (nolock) " & vbCrLf &_
		   " where a.post_ncorr=b.post_ncorr " & vbCrLf &_
		   " and b.post_bnuevo='S' and cast(peri_ccod as varchar) = '"&periodo&"' " & vbCrLf &_
		   " and exists (select 1 from ofertas_academicas tt (nolock), aranceles t2 (nolock) where tt.aran_ncorr=t2.aran_ncorr and tt.ofer_ncorr=a.ofer_ncorr and isnull(t2.aran_mcolegiatura,0) > 1 ) " & vbCrLf &_
		   " group by b.peri_ccod,opcion " & vbCrLf &_
		   " order by opcion asc " 
'response.Write("<pre>"&consulta&"</pre>")
'response.End()		   
lista.inicializar conexion 
lista.consultar consulta 
'response.End()
externos_general = 0
internos_general = 0
while lista.siguiente
	externos_general = externos_general + cint(lista.obtenerValor("externas"))
	internos_general = internos_general + cint(lista.obtenerValor("internas"))
wend
lista.primero


set lista2 = new CFormulario
lista2.carga_parametros "tabla_vacia.xml", "tabla"

consulta = " select d.sede_ccod,d.sede_tdesc,b.peri_ccod, " & vbCrLf &_
		   "			  (select count(*)  " & vbCrLf &_
		   "			   from ip_postulaciones tt (nolock), postulantes t2 (nolock), ofertas_academicas t3 " & vbCrLf &_
		   "			   where tt.post_ncorr=t2.post_ncorr and tt.ofer_ncorr=t3.ofer_ncorr and t3.sede_ccod=d.sede_ccod " & vbCrLf &_
		   "			   and t2.post_bnuevo='S' and t2.peri_ccod=b.peri_ccod " & vbCrLf &_
		   "			   and (tt.IP_GENERAL like '10.%' or tt.IP_GENERAL like '172.%' or tt.IP_GENERAL like '192.168.%' or tt.IP_GENERAL = '200.27.186.129' or tt.IP_GENERAL = '200.27.186.130'  or tt.IP_GENERAL = '200.27.186.131'   or tt.IP_GENERAL = '200.27.186.132'  or tt.IP_GENERAL = '200.27.186.133'  or tt.IP_GENERAL = '200.27.186.134')) as internas,  " & vbCrLf &_
		   "			  (select count(*)  " & vbCrLf &_
		   "			   from ip_postulaciones tt (nolock), postulantes t2 (nolock), ofertas_academicas t3 " & vbCrLf &_
		   "			   where tt.post_ncorr=t2.post_ncorr and tt.ofer_ncorr=t3.ofer_ncorr and t3.sede_ccod=d.sede_ccod " & vbCrLf &_
		   "			   and t2.post_bnuevo='S' and t2.peri_ccod=b.peri_ccod " & vbCrLf &_
		   "			   and (tt.IP_GENERAL not like '10.%' and  tt.IP_GENERAL not like '172.%' and tt.IP_GENERAL not like '192.168.%' and tt.IP_GENERAL <> '200.27.186.129' and tt.IP_GENERAL <> '200.27.186.130'  and tt.IP_GENERAL <> '200.27.186.131'   and  tt.IP_GENERAL <> '200.27.186.132'  and tt.IP_GENERAL <> '200.27.186.133' and tt.IP_GENERAL <> '200.27.186.134')) as externas, " & vbCrLf &_
		   " count(*) as total  " & vbCrLf &_
		   " from ip_postulaciones a (nolock), postulantes b (nolock), ofertas_academicas c, sedes d " & vbCrLf &_
		   " where a.post_ncorr=b.post_ncorr and a.ofer_ncorr=c.ofer_ncorr and c.sede_ccod=d.sede_ccod " & vbCrLf &_
		   " and b.post_bnuevo='S' and cast(b.peri_ccod as varchar) = '"&periodo&"' " & vbCrLf &_
		   " and exists (select 1 from ofertas_academicas tt (nolock), aranceles t2 (nolock) where tt.aran_ncorr=t2.aran_ncorr and tt.ofer_ncorr=a.ofer_ncorr and isnull(t2.aran_mcolegiatura,0) > 1 ) " & vbCrLf &_
		   " group by d.sede_ccod,d.sede_tdesc,b.peri_ccod " & vbCrLf &_
		   " order by d.sede_tdesc asc " 
		   
lista2.inicializar conexion 
lista2.consultar consulta 


set lista3 = new CFormulario
lista3.carga_parametros "tabla_vacia.xml", "tabla"

consulta =  " select e.carr_ccod,e.carr_tdesc,b.peri_ccod,  " & vbCrLf &_
			"			  (select count(*)  " & vbCrLf &_
			"			   from ip_postulaciones tt (nolock), postulantes t2 (nolock), ofertas_academicas t3, especialidades t4  " & vbCrLf &_
			"			   where tt.post_ncorr=t2.post_ncorr and tt.ofer_ncorr=t3.ofer_ncorr   " & vbCrLf &_
			"			   and t3.espe_ccod=t4.espe_ccod and t4.carr_ccod=e.carr_ccod  " & vbCrLf &_
			"			   and t2.post_bnuevo='S' and t2.peri_ccod=b.peri_ccod  " & vbCrLf &_
			"			   and (tt.IP_GENERAL like '10.%' or tt.IP_GENERAL like '172.%' or tt.IP_GENERAL like '192.168.%' or tt.IP_GENERAL = '200.27.186.129' or tt.IP_GENERAL = '200.27.186.130'  or tt.IP_GENERAL = '200.27.186.131'   or tt.IP_GENERAL = '200.27.186.132'  or tt.IP_GENERAL = '200.27.186.133'  or tt.IP_GENERAL = '200.27.186.134')) as internas,   " & vbCrLf &_
			"			  (select count(*)   " & vbCrLf &_
			"			   from ip_postulaciones tt (nolock), postulantes t2 (nolock), ofertas_academicas t3, especialidades t4  " & vbCrLf &_
			"			   where tt.post_ncorr=t2.post_ncorr and tt.ofer_ncorr=t3.ofer_ncorr   " & vbCrLf &_
			"			   and t3.espe_ccod=t4.espe_ccod and t4.carr_ccod=e.carr_ccod  " & vbCrLf &_
			"			   and t2.post_bnuevo='S' and t2.peri_ccod=b.peri_ccod  " & vbCrLf &_
			"			   and (tt.IP_GENERAL not like '10.%' and  tt.IP_GENERAL not like '172.%' and tt.IP_GENERAL not like '192.168.%' and tt.IP_GENERAL <> '200.27.186.129' and tt.IP_GENERAL <> '200.27.186.130'  and tt.IP_GENERAL <> '200.27.186.131'  and tt.IP_GENERAL <> '200.27.186.132'  and tt.IP_GENERAL <> '200.27.186.133'  and tt.IP_GENERAL <> '200.27.186.134')) as externas,  " & vbCrLf &_
			" count(*) as total   " & vbCrLf &_
			" from ip_postulaciones a (nolock), postulantes b (nolock), ofertas_academicas c, especialidades d, carreras e  " & vbCrLf &_
			" where a.post_ncorr=b.post_ncorr and a.ofer_ncorr=c.ofer_ncorr and c.espe_ccod=d.espe_ccod   " & vbCrLf &_
			" and d.carr_ccod=e.carr_ccod and b.post_bnuevo='S' and cast(b.peri_ccod as varchar) = '"&periodo&"'  " & vbCrLf &_
		    " and exists (select 1 from ofertas_academicas tt (nolock), aranceles t2 (nolock) where tt.aran_ncorr=t2.aran_ncorr and tt.ofer_ncorr=a.ofer_ncorr and isnull(t2.aran_mcolegiatura,0) > 1 ) " & vbCrLf &_
 			" group by e.carr_ccod,e.carr_tdesc,b.peri_ccod  " & vbCrLf &_
			" order by e.carr_tdesc asc "
		   
lista3.inicializar conexion 
lista3.consultar consulta 

set lista4 = new CFormulario
lista4.carga_parametros "tabla_vacia.xml", "tabla"

consulta =  " select f.REGI_CCOD,f.NOMBRE_REAL as region,f.CIUDAD_MAPA, count(distinct c.pers_ncorr) as total  " & vbCrLf &_    
			" from detalle_postulantes a (nolock),postulantes b (nolock), " & vbCrLf &_
			"      personas_postulante c (nolock),direcciones_publica d (nolock), " & vbCrLf &_
			"      ciudades e, regiones f " & vbCrLf &_
			" where a.post_ncorr=b.post_ncorr and b.pers_ncorr=c.pers_ncorr " & vbCrLf &_
			" and c.pers_ncorr=d.pers_ncorr and d.tdir_ccod=1 and d.ciud_ccod=e.ciud_ccod  " & vbCrLf &_
			" and e.regi_ccod = f.regi_ccod  " & vbCrLf &_
			" and b.post_bnuevo='S' and cast(b.peri_ccod as varchar) = '"&periodo&"' " & vbCrLf &_
 		    " and exists (select 1 from ofertas_academicas tt (nolock), aranceles t2 (nolock) where tt.aran_ncorr=t2.aran_ncorr and tt.ofer_ncorr=a.ofer_ncorr and isnull(t2.aran_mcolegiatura,0) > 1 ) " & vbCrLf &_
			" group by f.REGI_CCOD,f.NOMBRE_REAL,f.CIUDAD_MAPA " & vbCrLf &_
			" order by f.REGI_CCOD asc  " 
		   
lista4.inicializar conexion 
lista4.consultar consulta 
cadena = ""
while lista4.siguiente
	cadena = replace(cadena,",*",",")
	ciudad = lista4.obtenerValor("CIUDAD_MAPA")
	total  = lista4.obtenerValor("total")
	cadena = cadena & "['"&ciudad&"',"&total&"],*"
wend
cadena = replace(cadena,",*"," ")
lista4.primero
								   
								   

set lista5 = new CFormulario
lista5.carga_parametros "tabla_vacia.xml", "tabla"

consulta =  " select d.pais_ccod,d.pais_tdesc as pais, count(distinct c.pers_ncorr) as total " & vbCrLf &_     
			" from detalle_postulantes a (nolock),postulantes b (nolock),  " & vbCrLf &_
			"      personas_postulante c (nolock),paises d " & vbCrLf &_
			" where a.post_ncorr=b.post_ncorr and b.pers_ncorr=c.pers_ncorr  " & vbCrLf &_
			" and case isnull(c.pais_ccod,0) when 0 then 1 else c.pais_ccod end = d.pais_ccod  " & vbCrLf &_
			" and b.post_bnuevo='S' and cast(b.peri_ccod as varchar) = '"&periodo&"' " & vbCrLf &_
 		    " and exists (select 1 from ofertas_academicas tt (nolock), aranceles t2 (nolock) where tt.aran_ncorr=t2.aran_ncorr and tt.ofer_ncorr=a.ofer_ncorr and isnull(t2.aran_mcolegiatura,0) > 1 ) " & vbCrLf &_
			" group by d.pais_ccod,d.pais_tdesc " & vbCrLf &_
			" order by d.pais_tdesc asc  " 
 
		   
lista5.inicializar conexion 
lista5.consultar consulta 

cadena2 = ""
while lista5.siguiente
	 cadena2 = replace(cadena2,",*",",")
     pais = lista5.obtenerValor("pais")
	 total  = lista5.obtenerValor("total")
	 cadena2 = cadena2 & "['"&pais&"',"&total&"],*"
wend
cadena2 = replace(cadena2,",*"," ")
lista5.primero

%>


<html>
<head>
<title><%=pagina.Titulo%></title>
<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1">
<link href="../estilos/estilos.css" rel="stylesheet" type="text/css">
<link href="../estilos/tabla.css" rel="stylesheet" type="text/css">

<script language="JavaScript" src="../biblioteca/tabla.js"></script>
<script language="JavaScript" src="../biblioteca/funciones.js"></script>
<script language="JavaScript" src="../biblioteca/validadores.js"></script>

<script type="text/javascript" src="http://www.google.com/jsapi"></script>
<script type="text/javascript" src="js/jquery-1.4.4.min.js"></script>
<script type="text/javascript" src="js/jquery.gvChart-1.0.1.min.js"></script>

<script language="JavaScript">
gvChartInit();
		jQuery(document).ready(function(){
			
			jQuery('#myTable1_1').gvChart({
				chartType: 'PieChart',
				gvSettings: {
					vAxis: {title: 'INDICE', minValue: 0, titleTextStyle: {fontName: 'Times',fontStyle: 'normal',fontSize: 10}},
					hAxis: {title: 'AÑOS', titleTextStyle: {fontName: 'Times',fontStyle: "NORMAL",fontSize: 10}},
					width: 400,
					height: 160,
					colors: ['#ffd236','#f3625b']
					}
			});
			
			jQuery('#myTable1_2').gvChart({
				chartType: 'BarChart',
				gvSettings: {
					vAxis: {title: 'OPCION', minValue: 0, titleTextStyle: {fontName: 'Times',fontStyle: 'normal',fontSize: 10}},
					hAxis: {title: 'CANTIDAD', titleTextStyle: {fontName: 'Times',fontStyle: "NORMAL",fontSize: 10}},
					width: 400,
					height: 160,
					colors: ['#a2cc7d','#5bbfe5','#0033CC','#9966CC']
					}
			});
			
			jQuery('#myTable1_3').gvChart({
				chartType: 'BarChart',
				gvSettings: {
					vAxis: {title: 'SEDE CAMPUS', minValue: 0, titleTextStyle: {fontName: 'Times',fontStyle: 'normal',fontSize: 10}},
					hAxis: {title: 'CANTIDAD', titleTextStyle: {fontName: 'Times',fontStyle: "NORMAL",fontSize: 10}},
					width: 400,
					height: 160,
					colors: ['#0033CC','#9966CC']
					}
			});
			
			jQuery('#myTable1_4').gvChart({
				chartType: 'BarChart',
				gvSettings: {
					vAxis: {title: 'CARRERAS', minValue: 0, titleTextStyle: {fontName: 'Times',fontStyle: 'normal',fontSize: 10}},
					hAxis: {title: 'CANTIDAD', titleTextStyle: {fontName: 'Times',fontStyle: "NORMAL",fontSize: 14}},
					width: 400,
					height: 1200,
					colors: ['#ffd236','#f3625b']
					}
			});
			
		});


</script>
<script type='text/javascript'>
		      google.load('visualization', '1', {'packages': ['geochart']});      
			  google.setOnLoadCallback(drawMarkersMap);        
			  function drawMarkersMap() 
			  {       var data = google.visualization.arrayToDataTable([ 
			                     ['City',   'Postulantes'],
								 <%=cadena%>]);        
			  var options = {         region: 'CL',         
			                          displayMode: 'markers', 
									  backgroundColor:'#D2ECEE', 
									  colorAxis: {colors: ['FF3300', 'FFCC99']}       };        
			  var chart = new google.visualization.GeoChart(document.getElementById('chart_div'));       
			      chart.draw(data, options);    
		     };    

	        google.load('visualization', '1', {'packages': ['geochart']});
		    google.setOnLoadCallback(drawRegionsMap);
			function drawRegionsMap() 
			  {
			        var data2 = google.visualization.arrayToDataTable([
						           ['Country', 'Postulantes'],           
									   <%=cadena2%>         
			            		]);  
							        
					var options = {backgroundColor:'#D2ECEE', 
								   colorAxis: {colors: ['FFCC99','FF3300' ]}};          
					var chart = new google.visualization.GeoChart(document.getElementById('chart_div2'));         
					chart.draw(data2, options);     
			  };
</script>
			
</head>
<body bgcolor="#CC6600" leftmargin="0" topmargin="0" marginwidth="0" marginheight="0" onLoad="MM_preloadImages('../imagenes/botones/buscar_f2.gif','../images/bot_deshabilitar_f2.gif','../images/agregar2_f2_p.gif','../jefe_carrera/im&amp;#225;genes/marco1_r3_c2_f2.gif');MM_preloadImages('../jefe_carrera/im&amp;#225;genes/marco1_r3_c4_f2.gif');MM_preloadImages('../jefe_carrera/im&amp;#225;genes/marco1_r3_c6_f2.gif');MM_preloadImages('../jefe_carrera/im&amp;#225;genes/marco1_r3_c8_f2.gif');MM_preloadImages('../imagenes/botones/cargar_f2.gif','../imagenes/botones/continuar_f2.gif')" onBlur="revisaVentana();" >
<table width="750" border="0" align="center" cellpadding="0" cellspacing="0">
  <tr>
    <td height="72" valign="top"><img src="../imagenes/vineta2_r1_c1.gif" width="750" height="72" border="0"></td>
  </tr>
  <%pagina.DibujarEncabezado()%>  
  <tr>
    <td valign="top" bgcolor="#EAEAEA">
	<br>
	<table width="95%"  border="0" align="center" cellpadding="0" cellspacing="0" bgcolor="#D8D8DE">
      <tr>
        <td width="9" height="8"><img name="top_r1_c1" src="../imagenes/top_r1_c1.gif" width="9" height="8" border="0" alt=""></td>
        <td height="8" background="../imagenes/top_r1_c2.gif"></td>
        <td width="7" height="8"><img name="top_r1_c3" src="../imagenes/top_r1_c3.gif" width="7" height="8" border="0" alt=""></td>
      </tr>
      <tr>
        <td width="9" background="../imagenes/izq.gif">&nbsp;</td>
        <td><table width="100%"  border="0" cellspacing="0" cellpadding="0">
          <tr>
            <td><%pagina.DibujarLenguetas Array("Distribución de postulaciones"), 1 %></td>
          </tr>
          <tr>
            <td height="2" background="../imagenes/top_r3_c2.gif"></td>
          </tr>
          <tr>
                <td>
					<br>
					<div align="center"> 
						<%pagina.DibujarTituloPagina%>
					</div>
                </td>
          </tr>
		  <tr><td>&nbsp;</td></tr>
		  <tr><td align="left"><font face="Georgia, Times New Roman, Times, serif" size="2" color="#0066FF">DISTRIBUCIÓN GENERAL DE POSTULACIONES</font></td></tr>
		  <form name="edicion">
		  <tr>
		      <td>
			      <table width="100%" cellpadding="0" cellspacing="0" border="0">
				  	<tr>
						<td width="50%" align="center">
							<table width="98%" cellpadding="2" cellspacing="2" border="1">
							   <tr>
							   		<td width="50%"><strong>DISTRIBUCIÓN GENERAL</strong></td>
									<td width="25%"><strong>Internas</strong></td>
									<td width="25%"><strong>Externas</strong></td>
							   </tr>
							   <tr>
							   		<td width="50%">Postulación Total</td>
									<td width="25%" align="center"><%=internos_general%></td>
									<td width="25%" align="center"><%=externos_general%></td>
							   </tr>
							</table>
						</td>
						<td width="50%" bgcolor="#FFFFFF">
							<table id='myTable1_1' align="center">
								<thead>
									<tr>
										<th></th>
										<th>Internas</th>
										<th>Externas</th>
									</tr>
								</thead>
									<tbody>
									<tr>
										<th></th>
										<td><%=internos_general%></td>
										<td><%=externos_general%></td>
									</tr>
								</tbody>
							</table>
						</td>
					</tr>
					<tr>
						<td colspan="2" height="50">&nbsp;</td>
					</tr>
					<tr><td align="left"><font face="Georgia, Times New Roman, Times, serif" size="2" color="#0066FF">POSTULACIONES DISTRIBUÍDAS POR PÁGINA DE ACCESO</font></td></tr>
					<tr>
						<td width="50%" align="center">
							<table width="98%" cellpadding="2" cellspacing="2" border="1">
							   <tr>
							   		<td width="50%"><strong>MEDIO DE POSTULACIÓN</strong></td>
									<td width="20%"><strong>Internas</strong></td>
									<td width="20%"><strong>Externas</strong></td>
									<td width="10%"><strong>Totales</strong></td>
							   </tr>
							   <% while lista.siguiente %>
							   <tr>
							   		<td width="50%"><%=lista.obtenerValor("opcion")%></td>
									<td width="20%" align="center"><%=lista.obtenerValor("internas")%></td>
									<td width="20%" align="center"><%=lista.obtenerValor("externas")%></td>
									<td width="10%" align="center"><%=lista.obtenerValor("total")%></td>
							   </tr>
							   <% wend
							      lista.primero%>
							</table>
						</td>
						<td width="50%" bgcolor="#FFFFFF">
							<table id='myTable1_2' align="center">
								<thead>
								<tr>
									<th></th>
									<% while lista.siguiente %>
										<th><%=lista.obtenerValor("opcion")%></th>
								    <% wend
									  lista.primero%>
								</tr>
							   </thead>
								<tbody>
								<tr>
									<th>Post.Internas</th>
									<% while lista.siguiente %>
										<td><%=lista.obtenerValor("internas")%></td>
								    <% wend
									  lista.primero%>
								</tr>
								<tr>
									<th>Post.Externas</th>
									<% while lista.siguiente %>
										<td><%=lista.obtenerValor("externas")%></td>
								    <% wend
									  lista.primero%>
								</tr>
							</tbody>
							</table>
						</td>
					</tr>
					<tr>
						<td colspan="2">&nbsp;</td>
					</tr>
					<tr>
						<td colspan="2"><hr></td>
					</tr>
					<tr>
						<td colspan="2">&nbsp;</td>
					</tr>
					<tr><td align="left"><font face="Georgia, Times New Roman, Times, serif" size="2" color="#0066FF">POSTULACIONES DISTRIBUIDAS POR SEDE</font></td></tr>
					<tr>
						<td width="50%" align="center">
							<table width="98%" cellpadding="2" cellspacing="2" border="1">
							   <tr>
							   		<td width="50%"><strong>SEDES Y CAMPUS</strong></td>
									<td width="20%"><strong>Internas</strong></td>
									<td width="20%"><strong>Externas</strong></td>
									<td width="10%"><strong>Totales</strong></td>
							   </tr>
							   <% while lista2.siguiente %>
							   <tr>
							   		<td width="50%"><%=lista2.obtenerValor("sede_tdesc")%></td>
									<td width="20%" align="center"><%=lista2.obtenerValor("internas")%></td>
									<td width="20%" align="center"><%=lista2.obtenerValor("externas")%></td>
									<td width="10%" align="center"><%=lista2.obtenerValor("total")%></td>
							   </tr>
							   <% wend
							      lista2.primero%>
							</table>
						</td>
						<td width="50%" bgcolor="#FFFFFF">
							<table id='myTable1_3' align="center">
								<thead>
								<tr>
									<th></th>
									<% while lista2.siguiente %>
										<th><%=lista2.obtenerValor("sede_tdesc")%></th>
								    <% wend
									  lista2.primero%>
								</tr>
							   </thead>
								<tbody>
								<tr>
									<th>Post.Internas</th>
									<% while lista2.siguiente %>
										<td><%=lista2.obtenerValor("internas")%></td>
								    <% wend
									  lista2.primero%>
								</tr>
								<tr>
									<th>Post.Externas</th>
									<% while lista2.siguiente %>
										<td><%=lista2.obtenerValor("externas")%></td>
								    <% wend
									  lista2.primero%>
								</tr>
							</tbody>
							</table>
						</td>
					</tr>
					<tr>
						<td colspan="2">&nbsp;</td>
					</tr>
					<tr>
						<td colspan="2"><hr></td>
					</tr>
					<tr>
						<td colspan="2">&nbsp;</td>
					</tr>
					<tr><td align="left"><font face="Georgia, Times New Roman, Times, serif" size="2" color="#0066FF">POSTULACIONES DISTRIBUIDAS POR CARRERAS</font></td></tr>
					<tr valign="top">
						<td width="50%" align="center">
							<table width="98%" cellpadding="2" cellspacing="2" border="1">
							   <tr>
							   		<td width="50%"><strong>CARRERAS</strong></td>
									<td width="20%"><strong>Internas</strong></td>
									<td width="20%"><strong>Externas</strong></td>
									<td width="10%"><strong>Totales</strong></td>
							   </tr>
							   <% while lista3.siguiente %>
							   <tr>
							   		<td width="50%"><%=lista3.obtenerValor("carr_ccod")%>:<%=lista3.obtenerValor("carr_tdesc")%></td>
									<td width="20%" align="center"><%=lista3.obtenerValor("internas")%></td>
									<td width="20%" align="center"><%=lista3.obtenerValor("externas")%></td>
									<td width="10%" align="center"><%=lista3.obtenerValor("total")%></td>
							   </tr>
							   <% wend
							      lista3.primero%>
							</table>
						</td>
						<td width="50%" bgcolor="#FFFFFF">
							<table id='myTable1_4' align="center">
								<thead>
								<tr>
									<th></th>
									<% while lista3.siguiente %>
										<th><%=lista3.obtenerValor("carr_tdesc")%></th>
								    <% wend
									  lista3.primero%>
								</tr>
							   </thead>
								<tbody>
								<tr>
									<th>Post.Internas</th>
									<% while lista3.siguiente %>
										<td><%=lista3.obtenerValor("internas")%></td>
								    <% wend
									  lista3.primero%>
								</tr>
								<tr>
									<th>Post.Externas</th>
									<% while lista3.siguiente %>
										<td><%=lista3.obtenerValor("externas")%></td>
								    <% wend
									  lista3.primero%>
								</tr>
							</tbody>
							</table>
						</td>
					</tr>
					<tr>
						<td colspan="2">&nbsp;</td>
					</tr>
					<tr>
						<td colspan="2"><hr></td>
					</tr>
					<tr>
						<td colspan="2">&nbsp;</td>
					</tr>
					<tr><td align="left"><font face="Georgia, Times New Roman, Times, serif" size="2" color="#0066FF">DISTRIBUCIÓN DE POSTULACIONES EN EL TERRITORIO NACIONAL</font></td></tr>
					<tr valign="bottom">
						<td width="50%" align="right">&nbsp;</td>
						<td width="50%" align="right">* La ciudad o comuna indicada, es sólo utilizada para señalar el total de postulantes de la región.</td>
					</tr>
					<tr valign="top">
						<td width="50%" align="center">
							<table width="98%" cellpadding="2" cellspacing="2" border="1">
							   <tr>
							   		<td><strong>Regiones</strong></td>
									<td><strong>Postulaciones</strong></td>
							   </tr>
							   <% while lista4.siguiente %>
							   <tr>
							   		<td><%=lista4.obtenerValor("region")%></td>
									<td align="center"><%=lista4.obtenerValor("total")%></td>
							   </tr>
							   <% wend
							      lista4.primero%>
							</table>
						</td>
						<td width="50%" bgcolor="#FFFFFF">
							<div id="chart_div" style="width: 400px; height: 350px;"></div>
						</td>
					</tr>
					<tr>
						<td colspan="2">&nbsp;</td>
					</tr>
					<tr>
						<td colspan="2"><hr></td>
					</tr>
					<tr>
						<td colspan="2">&nbsp;</td>
					</tr>
					<tr><td align="left"><font face="Georgia, Times New Roman, Times, serif" size="2" color="#0066FF">DISTRIBUCIÓN DE POSTULACIONES EN EL MUNDO</font></td></tr>
					<tr>
						<td colspan="2" align="center">
						  <div id="chart_div2" style="width: 750px; height: 450px;"></div>
						</td>
					</tr>
					<tr>
						<td colspan="2">&nbsp;</td>
					</tr>
				  </table>
			  </td>
		  </tr>
		  </form>
		  
		  <tr><td>&nbsp;</td></tr>
		  <tr><td>&nbsp;</td></tr>
        </table></td>
        <td width="7" background="../imagenes/der.gif">&nbsp;</td>
      </tr>
      <tr>
        <td width="9" height="28"><img src="../imagenes/abajo_r1_c1.gif" width="9" height="28"></td>
        <td height="28"><table width="100%" height="28"  border="0" cellpadding="0" cellspacing="0">
          <tr>
            <td width="16%" height="20"><div align="center">
              <table width="90%"  border="0" cellspacing="0" cellpadding="0">
                <tr>
                  <td><div align="center"><%f_botonera.DibujaBoton("salir")%></div></td>
				  <td><div align="center"><%f_botonera.agregaBotonParam "excel","url","modo_de_acceso_excel.asp"
				                            f_botonera.DibujaBoton("excel")%></div></td>
                  </tr>
              </table>
            </div></td>
            <td width="84%" rowspan="2" background="../imagenes/abajo_r1_c4.gif"><img src="../imagenes/abajo_r1_c3.gif" width="12" height="28"></td>
            </tr>
          <tr>
            <td height="8" background="../imagenes/abajo_r2_c2.gif"></td>
          </tr>
        </table></td>
        <td width="7" height="28"><img src="../imagenes/abajo_r1_c5.gif" width="7" height="28"></td>
      </tr>
    </table>
	<br>
	</td>
  </tr>  
</table>
</body>
</html>
