<!-- #include file = "../biblioteca/_conexion.asp" -->
<!-- #include file = "../biblioteca/_negocio.asp" -->

<%

peri_ccod=request.QueryString("a[0][peri_ccod]")
q_sede_ccod=request.QueryString("a[0][q_sede_ccod]")
fecha_consulta_r=request.QueryString("a[0][fecha_consulta_r]")
rut=request.QueryString("a[0][rut]")
dv=request.QueryString("a[0][dv]")
'response.Write(peri_ccod&"<br>"&sede_ccod&"<br>"&fecha)
'response.Write("<BR>"&fecha_consulta_r)
'---------------------------------------------------------------------------------------------------

set errores= new CErrores

set conexion = new CConexion
conexion.Inicializar "upacifico"

set negocio = new CNegocio
negocio.Inicializa conexion

'---------------------------------------------------------------------------------------------------
set pagina = new cPagina
set botonera = new CFormulario
botonera.carga_parametros "modifica_hora.xml", "botonera"
'---------------------------------------------------------------------------------------------------
set f_botonera = new CFormulario
f_botonera.Carga_Parametros "modifica_hora.xml", "botonera"

'---------------------------------------------------------------------------------------------------
usu=negocio.ObtenerUsuario()
'---------------------------------------------------------------------------------------------------

set f_hdatos_a = new CFormulario
f_hdatos_a.Carga_Parametros "modifica_hora.xml", "toma_hora"
f_hdatos_a.Inicializar conexion
'if sede_ccod<>"" then 
sql_hora="select ''" 
'sql_hora="select a.pers_ncorr,pers_tnombre+' '+pers_tape_paterno+' '+pers_tape_materno as nombre"& vbcrlf & _
'"from personas a"& vbcrlf & _
'"left outer join datos_alumnos_sicologas d"& vbcrlf & _
'"on a.PERS_NCORR=d.pers_ncorr"& vbcrlf & _
'"join horas_tomadas e"& vbcrlf & _
'"on a.PERS_NCORR=e.pers_ncorr"& vbcrlf & _
'"join estado_horas f"& vbcrlf & _
'"on e.esho_ccod=f.esho_ccod"& vbcrlf & _
'"where e.hoto_ncorr="&hoto_ncorr&""

'else
'sql_hora="select ''"
'end if

'response.Write("<br>"&sql_hora)
f_hdatos_a.Consultar sql_hora
f_hdatos_a.siguiente

f_hdatos_a.AgregaCampoCons "peri_ccod", peri_ccod
f_hdatos_a.AgregaCampoCons "fecha_consulta_r", fecha_consulta_r
f_hdatos_a.AgregaCampoCons "rut", rut
f_hdatos_a.AgregaCampoCons "dv", dv



 if not esVacio(fecha_consulta_r) then
 	 dia_semana = conexion.consultaUno("select datepart(weekday,convert(datetime,'"&fecha_consulta_r&"',103))") 
' 
	 'response.Write(dia_semana)
 end if
 
 fecha_trabajo = Array("","","","","","","","")
 
 if not esVacio(fecha_consulta_r) then
 	 if dia_semana = "1" then
		  fecha_trabajo(1) = conexion.consultaUno("select convert(datetime,'"&fecha_consulta_r&"',103)")
		  fecha_trabajo(2) = conexion.consultaUno("select convert(datetime,'"&fecha_consulta_r&"',103)+1")
		  fecha_trabajo(3) = conexion.consultaUno("select convert(datetime,'"&fecha_consulta_r&"',103)+2")
		  fecha_trabajo(4) = conexion.consultaUno("select convert(datetime,'"&fecha_consulta_r&"',103)+3")
		  fecha_trabajo(5) = conexion.consultaUno("select convert(datetime,'"&fecha_consulta_r&"',103)+4")
		  fecha_trabajo(6) = conexion.consultaUno("select convert(datetime,'"&fecha_consulta_r&"',103)+5")
		  fecha_trabajo(7) = conexion.consultaUno("select convert(datetime,'"&fecha_consulta_r&"',103)+6")
	 elseif dia_semana = "2" then
		  fecha_trabajo(1) = conexion.consultaUno("select convert(datetime,'"&fecha_consulta_r&"',103)-1")
		  fecha_trabajo(2) = conexion.consultaUno("select convert(datetime,'"&fecha_consulta_r&"',103)")
		  fecha_trabajo(3) = conexion.consultaUno("select convert(datetime,'"&fecha_consulta_r&"',103)+1")
		  fecha_trabajo(4) = conexion.consultaUno("select convert(datetime,'"&fecha_consulta_r&"',103)+2")
		  fecha_trabajo(5) = conexion.consultaUno("select convert(datetime,'"&fecha_consulta_r&"',103)+3")
		  fecha_trabajo(6) = conexion.consultaUno("select convert(datetime,'"&fecha_consulta_r&"',103)+4")
		  fecha_trabajo(7) = conexion.consultaUno("select convert(datetime,'"&fecha_consulta_r&"',103)+5")
	 elseif dia_semana = "3" then
		  fecha_trabajo(1) = conexion.consultaUno("select convert(datetime,'"&fecha_consulta_r&"',103)-2")
		  fecha_trabajo(2) = conexion.consultaUno("select convert(datetime,'"&fecha_consulta_r&"',103)-1")
		  fecha_trabajo(3) = conexion.consultaUno("select convert(datetime,'"&fecha_consulta_r&"',103)")
		  fecha_trabajo(4) = conexion.consultaUno("select convert(datetime,'"&fecha_consulta_r&"',103)+1")
		  fecha_trabajo(5) = conexion.consultaUno("select convert(datetime,'"&fecha_consulta_r&"',103)+2")
		  fecha_trabajo(6) = conexion.consultaUno("select convert(datetime,'"&fecha_consulta_r&"',103)+3")
		  fecha_trabajo(7) = conexion.consultaUno("select convert(datetime,'"&fecha_consulta_r&"',103)+4") 
     elseif dia_semana = "4" then
		  fecha_trabajo(1) = conexion.consultaUno("select convert(datetime,'"&fecha_consulta_r&"',103)-3")
		  fecha_trabajo(2) = conexion.consultaUno("select convert(datetime,'"&fecha_consulta_r&"',103)-2")
		  fecha_trabajo(3) = conexion.consultaUno("select convert(datetime,'"&fecha_consulta_r&"',103)-1")
		  fecha_trabajo(4) = conexion.consultaUno("select convert(datetime,'"&fecha_consulta_r&"',103)")
		  fecha_trabajo(5) = conexion.consultaUno("select convert(datetime,'"&fecha_consulta_r&"',103)+1")
		  fecha_trabajo(6) = conexion.consultaUno("select convert(datetime,'"&fecha_consulta_r&"',103)+2")
		  fecha_trabajo(7) = conexion.consultaUno("select convert(datetime,'"&fecha_consulta_r&"',103)+3") 
	 elseif dia_semana = "5" then
		  fecha_trabajo(1) = conexion.consultaUno("select convert(datetime,'"&fecha_consulta_r&"',103)-4")
		  fecha_trabajo(2) = conexion.consultaUno("select convert(datetime,'"&fecha_consulta_r&"',103)-3")
		  fecha_trabajo(3) = conexion.consultaUno("select convert(datetime,'"&fecha_consulta_r&"',103)-2")
		  fecha_trabajo(4) = conexion.consultaUno("select convert(datetime,'"&fecha_consulta_r&"',103)-1")
		  fecha_trabajo(5) = conexion.consultaUno("select convert(datetime,'"&fecha_consulta_r&"',103)")
		  fecha_trabajo(6) = conexion.consultaUno("select convert(datetime,'"&fecha_consulta_r&"',103)+1")
		  fecha_trabajo(7) = conexion.consultaUno("select convert(datetime,'"&fecha_consulta_r&"',103)+2") 
	 elseif dia_semana = "6" then
		  fecha_trabajo(1) = conexion.consultaUno("select convert(datetime,'"&fecha_consulta_r&"',103)-5")
		  fecha_trabajo(2) = conexion.consultaUno("select convert(datetime,'"&fecha_consulta_r&"',103)-4")
		  fecha_trabajo(3) = conexion.consultaUno("select convert(datetime,'"&fecha_consulta_r&"',103)-3")
		  fecha_trabajo(4) = conexion.consultaUno("select convert(datetime,'"&fecha_consulta_r&"',103)-2")
		  fecha_trabajo(5) = conexion.consultaUno("select convert(datetime,'"&fecha_consulta_r&"',103)-1")
		  fecha_trabajo(6) = conexion.consultaUno("select convert(datetime,'"&fecha_consulta_r&"',103)")
		  fecha_trabajo(7) = conexion.consultaUno("select convert(datetime,'"&fecha_consulta_r&"',103)+1") 
	 elseif dia_semana = "7" then
		  fecha_trabajo(1) = conexion.consultaUno("select convert(datetime,'"&fecha_consulta_r&"',103)-6")
		  fecha_trabajo(2) = conexion.consultaUno("select convert(datetime,'"&fecha_consulta_r&"',103)-5")
		  fecha_trabajo(3) = conexion.consultaUno("select convert(datetime,'"&fecha_consulta_r&"',103)-4")
		  fecha_trabajo(4) = conexion.consultaUno("select convert(datetime,'"&fecha_consulta_r&"',103)-3")
		  fecha_trabajo(5) = conexion.consultaUno("select convert(datetime,'"&fecha_consulta_r&"',103)-2")
		  fecha_trabajo(6) = conexion.consultaUno("select convert(datetime,'"&fecha_consulta_r&"',103)-1")
		  fecha_trabajo(7) = conexion.consultaUno("select convert(datetime,'"&fecha_consulta_r&"',103)") 	  
     end if
 end if
 
 
 if fecha_consulta_r<>"" then
	s_es_lunes = "select case when protic.trunc('"&fecha_trabajo(1)&"')=protic.trunc(getdate())and datepart(weekday,convert(datetime,'"&fecha_trabajo(1)&"',103))=datepart(weekday,convert(datetime,getdate(),103))then 1  else 0 end"
	s_es_martes = "select case when protic.trunc('"&fecha_trabajo(2)&"')=protic.trunc(getdate())and datepart(weekday,convert(datetime,'"&fecha_trabajo(2)&"',103))=datepart(weekday,convert(datetime,getdate(),103))then 1  else 0 end"
	s_es_miercoles = "select case when protic.trunc('"&fecha_trabajo(3)&"')=protic.trunc(getdate())and datepart(weekday,convert(datetime,'"&fecha_trabajo(3)&"',103))=datepart(weekday,convert(datetime,getdate(),103))then 1  else 0 end"
	s_es_jueves = "select case when protic.trunc('"&fecha_trabajo(4)&"')=protic.trunc(getdate())and datepart(weekday,convert(datetime,'"&fecha_trabajo(4)&"',103))=datepart(weekday,convert(datetime,getdate(),103))then 1  else 0 end"
	s_es_viernes = "select case when protic.trunc('"&fecha_trabajo(5)&"')=protic.trunc(getdate())and datepart(weekday,convert(datetime,'"&fecha_trabajo(5)&"',103))=datepart(weekday,convert(datetime,getdate(),103))then 1  else 0 end"
	 'response.Write("<br>s_es_hoy= "&s_es_hoy)
	es_lunes =conexion.consultaUno(s_es_lunes)
	es_martes =conexion.consultaUno(s_es_martes)
	es_miercoles =conexion.consultaUno(s_es_miercoles)
	es_jueves =conexion.consultaUno(s_es_jueves)
	es_viernes =conexion.consultaUno(s_es_viernes)
	 'response.Write("<br>es hoy= "&es_hoy)
 end if


 if not esVacio(q_sede_ccod) then
side_ncorr=conexion.ConsultaUno("select side_ncorr from sicologos_sede a, sicologos b where a.sico_ncorr=b.sico_ncorr and b.pers_ncorr=protic.obtener_pers_ncorr("&usu&") and sede_ccod="&q_sede_ccod&"")
diferencia=conexion.ConsultaUno("select top 1 DATEDIFF ( mi, convert(datetime,'"&fecha_consulta_r&" '+rtrim(ltrim(hora_ini)),103) , convert(datetime,'"&fecha_consulta_r&" '+rtrim(ltrim(hora_fin)),103) )as diferencia from bloques_sicologos a where side_ncorr="&side_ncorr&"")
pers_ncorr=conexion.ConsultaUno("select protic.obtener_pers_ncorr("&rut&")")
end  if
 
 set f_horas = new CFormulario
f_horas.Carga_Parametros "tabla_vacia.xml", "tabla" 
f_horas.Inicializar conexion
if q_sede_ccod<>"" then  

	sql_hora="select hora_ini+' - '+hora_fin as hora ,"& vbcrlf & _
					"case when  protic.verificar_hora_sicologo(a.blsi_ncorr,protic.obtener_pers_ncorr("&rut&"),'"&fecha_trabajo(1)&"',1)='N' and (select case count(*) when 0 then 'N' else 'S' end from bloqueo_hora_dia fff where fff.blsi_ncorr=a.blsi_ncorr and fecha_hora='"&fecha_trabajo(1)&" ')='N' and protic.ES_BLOQUE_ACTIVO_SICOLOGO(a.blsi_ncorr,1)='S' and (select  case when convert(datetime,getdate(),103)< convert(datetime,'"&fecha_trabajo(1)&" '+rtrim(ltrim(hora_fin)),103) then  'S' else 'N' end)='S' then '<input type="&CHR(034)&"button"&CHR(034)&" value="&CHR(034)&"Tomar Hora"&CHR(034)&" onclick="&CHR(034)&"selec(1,''"&fecha_trabajo(1)&"'','+cast(blsi_ncorr as varchar)+',"&CHR(039)&""&CHR(039)&"'+hora_ini+' a '+hora_fin+'"&CHR(039)&""&CHR(039)&");"&CHR(034)&"/>'" & vbcrlf & _
					 "else '_' end as eslunes,"& vbcrlf & _
					
					"case when protic.verificar_hora_sicologo(a.blsi_ncorr,protic.obtener_pers_ncorr("&rut&"),'"&fecha_trabajo(2)&"',2)='N'  and (select case count(*) when 0 then 'N' else 'S' end from bloqueo_hora_dia fff where fff.blsi_ncorr=a.blsi_ncorr and fecha_hora='"&fecha_trabajo(2)&" ')='N' and protic.ES_BLOQUE_ACTIVO_SICOLOGO(a.blsi_ncorr,2)='S' and (select  case when convert(datetime,getdate(),103)< convert(datetime,'"&fecha_trabajo(2)&" '+rtrim(ltrim(hora_fin)),103) then  'S' else 'N' end)='S' then '<input type="&CHR(034)&"button"&CHR(034)&" value="&CHR(034)&"Tomar Hora"&CHR(034)&" onclick="&CHR(034)&"selec(2,''"&fecha_trabajo(2)&"'','+cast(blsi_ncorr as varchar)+',"&CHR(039)&""&CHR(039)&"'+hora_ini+' a '+hora_fin+'"&CHR(039)&""&CHR(039)&");"&CHR(034)&"/>'"& vbcrlf & _
					 "else  '_' end as esmartes,"& vbcrlf & _
					
					"case when  protic.verificar_hora_sicologo(a.blsi_ncorr,protic.obtener_pers_ncorr("&rut&"),'"&fecha_trabajo(3)&"',3)='N' and (select case count(*) when 0 then 'N' else 'S' end from bloqueo_hora_dia fff where fff.blsi_ncorr=a.blsi_ncorr and fecha_hora='"&fecha_trabajo(3)&" ')='N' and protic.ES_BLOQUE_ACTIVO_SICOLOGO(a.blsi_ncorr,3)='S' and (select  case when convert(datetime,getdate(),103)< convert(datetime,'"&fecha_trabajo(3)&" '+rtrim(ltrim(hora_fin)),103) then  'S' else 'N' end)='S' then '<input type="&CHR(034)&"button"&CHR(034)&" value="&CHR(034)&"Tomar Hora"&CHR(034)&" onclick="&CHR(034)&"selec(3,''"&fecha_trabajo(3)&"'','+cast(blsi_ncorr as varchar)+',"&CHR(039)&""&CHR(039)&"'+hora_ini+' a '+hora_fin+'"&CHR(039)&""&CHR(039)&");"&CHR(034)&"/>'"& vbcrlf & _ 
					"else  '_' end as esmiercoles,"& vbcrlf & _
					
					"case when  protic.verificar_hora_sicologo(a.blsi_ncorr,protic.obtener_pers_ncorr("&rut&"),'"&fecha_trabajo(4)&"',4)='N' and (select case count(*) when 0 then 'N' else 'S' end from bloqueo_hora_dia fff where fff.blsi_ncorr=a.blsi_ncorr and fecha_hora='"&fecha_trabajo(4)&" ')='N' and protic.ES_BLOQUE_ACTIVO_SICOLOGO(a.blsi_ncorr,4)='S' and (select  case when convert(datetime,getdate(),103)< convert(datetime,'"&fecha_trabajo(4)&" '+rtrim(ltrim(hora_fin)),103) then  'S' else 'N' end)='S' then '<input type="&CHR(034)&"button"&CHR(034)&" value="&CHR(034)&"Tomar Hora"&CHR(034)&" onclick="&CHR(034)&"selec(4,''"&fecha_trabajo(4)&"'','+cast(blsi_ncorr as varchar)+',"&CHR(039)&""&CHR(039)&"'+hora_ini+' a '+hora_fin+'"&CHR(039)&""&CHR(039)&");"&CHR(034)&"/>'"& vbcrlf & _
					" else  '_' end as esjueves,"& vbcrlf & _
					 
					"case when protic.verificar_hora_sicologo(a.blsi_ncorr,protic.obtener_pers_ncorr("&rut&"),'"&fecha_trabajo(5)&"',5)='N' and (select case count(*) when 0 then 'N' else 'S' end from bloqueo_hora_dia fff where fff.blsi_ncorr=a.blsi_ncorr and fecha_hora='"&fecha_trabajo(5)&" ')='N' and  protic.ES_BLOQUE_ACTIVO_SICOLOGO(a.blsi_ncorr,5)='S' and (select  case when convert(datetime,getdate(),103)< convert(datetime,'"&fecha_trabajo(5)&" '+rtrim(ltrim(hora_fin)),103) then  'S' else 'N' end)='S' then '<input type="&CHR(034)&"button"&CHR(034)&" value="&CHR(034)&"Tomar Hora"&CHR(034)&" onclick="&CHR(034)&"selec(5,''"&fecha_trabajo(5)&"'','+cast(blsi_ncorr as varchar)+',"&CHR(039)&""&CHR(039)&"'+hora_ini+' a '+hora_fin+'"&CHR(039)&""&CHR(039)&");"&CHR(034)&"/>'"& vbcrlf & _
				    " else  '_' end as esviernes"& vbcrlf & _
					"from bloques_sicologos a" & vbcrlf & _
					"where side_ncorr="&side_ncorr&""& vbcrlf & _
					"and peri_ccod="&peri_ccod&""
					
else
	sql_hora="select ''"
end if

'response.Write("<br>"&sql_hora)
'response.End()
f_horas.Consultar sql_hora

'end if 
 set f_sedes_sicologos = new CFormulario
f_sedes_sicologos.Carga_Parametros "crea_modulos_sicologos.xml", "sede_sicologos"
f_sedes_sicologos.Inicializar conexion


sql_descuentos= "select c.sede_ccod,sede_tdesc "& vbcrlf & _
 "from sicologos a,"& vbcrlf & _
 "sicologos_sede b,"& vbcrlf & _
 "sedes c"& vbcrlf & _
"where a.sico_ncorr=b.sico_ncorr"& vbcrlf & _
"and b.sede_ccod=c.SEDE_CCOD"& vbcrlf & _
"and a.pers_ncorr=protic.obtener_pers_ncorr("&usu&") order by c.sede_ccod"

f_sedes_sicologos.Consultar sql_descuentos
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
<script language="JavaScript" src="../biblioteca/PopCalendar.js"></script>
<script language="JavaScript">
function marca_sede()
{


	q_sede_ccod='<%=q_sede_ccod%>'
	
	if (q_sede_ccod!='') 
	{
		
		document.edicion.elements['a[0][q_sede_ccod]'].value=q_sede_ccod;
	
	}
}
function selec(dias_ccod,fecha_hora,blsi_ncorr,hora_bloque)
{

if(confirm("¿Quiere Tomar esta hora?")) {


peri_ccod=<%=peri_ccod%>
q_sede_ccod=<%=q_sede_ccod%>
fecha_consulta_r='<%=fecha_consulta_r%>'
rut=<%=rut%>
dv='<%=dv%>'
pers_ncorr=<%=pers_ncorr%>

pagina='tomar_hora_proc.asp?pers_ncorr='+pers_ncorr+'&dias_ccod='+dias_ccod+'&fecha_hora='+fecha_hora+'&blsi_ncorr='+blsi_ncorr+'&hora_bloque='+hora_bloque+'&peri_ccod='+peri_ccod+'&q_sede_ccod='+q_sede_ccod+'&fecha_consulta_r='+fecha_consulta_r+'&rut='+rut+'&dv='+dv+''
location.href=pagina
} 

}

</script>
<%
	set calendario = new FCalendario
	calendario.IniciaFuncion
	calendario.MuestraFecha "a[0][fecha_consulta_r]","1","edicion","fecha_consulta_oculta"
	calendario.FinFuncion
%>
</head>
<body bgcolor="#CC6600" leftmargin="0" topmargin="0" marginwidth="0" marginheight="0" onLoad="MM_preloadImages('../imagenes/botones/buscar_f2.gif','../images/bot_deshabilitar_f2.gif','../images/agregar2_f2_p.gif','im&amp;#225;genes/marco1_r3_c2_f2.gif');MM_preloadImages('im&amp;#225;genes/marco1_r3_c4_f2.gif');MM_preloadImages('im&amp;#225;genes/marco1_r3_c6_f2.gif');MM_preloadImages('im&amp;#225;genes/marco1_r3_c8_f2.gif');MM_preloadImages('../imagenes/botones/cargar_f2.gif','../imagenes/botones/continuar_f2.gif');marca_sede();">
<%calendario.ImprimeVariables%>

<table width="750" height="250" border="0" align="center" cellpadding="0" cellspacing="0">
  <tr>
    <td height="62" valign="top"><img src="../imagenes/vineta2_r1_c1.gif" width="750" height="62" border="0"></td>
  </tr>
  <%pagina.DibujarEncabezado()%>  
  <tr>
    <td valign="top" bgcolor="#EAEAEA">
	<br>
	
	<br>
	<form name="edicion">
	<table width="90%"  border="0" align="center" cellpadding="0" cellspacing="0" bgcolor="#D8D8DE">
      <tr>
        <td width="9" height="8"><img name="top_r1_c1" src="../imagenes/top_r1_c1.gif" width="9" height="8" border="0" alt=""></td>
        <td height="8" background="../imagenes/top_r1_c2.gif"></td>
        <td width="7" height="8"><img name="top_r1_c3" src="../imagenes/top_r1_c3.gif" width="7" height="8" border="0" alt=""></td>
      </tr>
      <tr>
        <td width="9" background="../imagenes/izq.gif">&nbsp;</td>
        <td><table width="100%"  border="0" cellspacing="0" cellpadding="0">
         
          <tr>
            <td height="2" background="../imagenes/top_r3_c2.gif"></td>
          </tr>
		  
          <tr>
            <td>
                <table width="98%"  border="0" align="center" cellpadding="0" cellspacing="0">
                  <tr>
                    <td width="50%">
						  <table width="100%"  border="0" align="center">
								 <tr>						
								 	<td width="11%"><strong>Rut Alumno:</strong></td>
							       <td width="89%" colspan="3" align="left"><%f_hdatos_a.DibujaCampo("rut")%>-<%f_hdatos_a.DibujaCampo("dv")%> <%pagina.DibujarBuscaPersonas "a[0][rut]", "a[0][dv]"%></td>
									
						         </tr>
								 <tr>
								 	<td colspan="2" width="100%">
									  <table width="100%">
											 <tr>
												<td width="6%">
													<strong>Sede:</strong></td>
												<td width="28%">
													 <select name="a[0][q_sede_ccod]"  id='NU-N' >
													<option value=''>Seleccione</option>
													<%while f_sedes_sicologos.Siguiente%>
													<option value='<%=f_sedes_sicologos.Obtenervalor("sede_ccod")%>' ><%=f_sedes_sicologos.Obtenervalor("sede_tdesc")%></option>
													<%wend%>
													</select>
											   </td>
												<td width="19%"><strong>Periodo Ac&aacute;demico :</strong></td>
											   <td width="47%"><%f_hdatos_a.DibujaCampo("peri_ccod")%></td>
											 </tr>
									   </table>
								 	</td>
								 </tr>
						  </table>
						   <table width="100%" align="center">
								   <tr>
									  <td width="33%" align="up"><span class="Estilo2"></span><strong> Selecionar Semana </strong><br>
									    <%f_hdatos_a.dibujaCampo "fecha_consulta_r"%>
									    <%calendario.DibujaImagen "fecha_consulta_oculta","1","edicion" %>
									    <a style='cursor:hand;' onClick='PopCalendar.show(document.edicion.fecha_consulta_oculta, "dd/mm/yyyy", null, null, "obtener_fecha(1)", "11");'></a></td>
									   <td width="33%" align="up">&nbsp;</td>
										<td width="34%" align="up">&nbsp;</td>
								   </tr>
						  </table>
				   </td>
                  </tr>
				  
                </table>
                <br>
				
           </td>
		</tr>
        </table></td>
        <td width="7" background="../imagenes/der.gif">&nbsp;</td>
      </tr>
      <tr>
        <td width="9" height="28"><img src="../imagenes/abajo_r1_c1.gif" width="9" height="28"></td>
        <td height="28"><table width="100%" height="28"  border="0" cellpadding="0" cellspacing="0">
          <tr>
            <td width="31%" height="20"><div align="center">
              <table width="90%"  border="0" cellspacing="0" cellpadding="0">
                <tr>
                  <td align="center"><%f_botonera.DibujaBoton("buscar")%></td>
                </tr>
              </table>
            </div></td>
            <td width="69%" rowspan="2" background="../imagenes/abajo_r1_c4.gif"><img src="../imagenes/abajo_r1_c3.gif" width="12" height="28"></td>
            </tr>
          <tr>
            <td height="8" background="../imagenes/abajo_r2_c2.gif"></td>
          </tr>
        </table>
		
		</td>
        <td width="7" height="28"><img src="../imagenes/abajo_r1_c5.gif" width="7" height="28"></td>
      </tr>
    </table>
	</form>
	<br>
	<br>
	<table width="90%"  border="0" align="center" cellpadding="0" cellspacing="0" bgcolor="#D8D8DE">
      <tr>
        <td width="9" height="8"><img name="top_r1_c1" src="../imagenes/top_r1_c1.gif" width="9" height="8" border="0" alt=""></td>
        <td height="8" background="../imagenes/top_r1_c2.gif"></td>
        <td width="7" height="8"><img name="top_r1_c3" src="../imagenes/top_r1_c3.gif" width="7" height="8" border="0" alt=""></td>
      </tr>
      <tr>
        <td width="9" background="../imagenes/izq.gif">&nbsp;</td>
        <td><table width="100%"  border="0" cellspacing="0" cellpadding="0">
          <tr>
            <td><%pagina.DibujarLenguetas Array("Resultados de la búsqueda"), 1 %></td>
          </tr>
          <tr>
            <td height="2" background="../imagenes/top_r3_c2.gif"></td>
          </tr>
          <tr>
            <td>
			
			<%if fecha_consulta_r<>"" then%>
              <%pagina.DibujarTituloPagina%><br>
                    <table width="100%" border="0">
					  <tr> 
                        <td colspan="3">
						        <table width="98%" cellpadding="0" cellspacing="0" bgcolor="#FFFFFF" border="2" bordercolor="#0099CC">
								<tr> 
									<td colspan="8" align="center"><font color="#990000">Presione sobre el bot&oacute;n para tomar la hora </font></td>
								</tr>
								<tr>
									<td align="center"><font size="3" color="#0099CC">HORA</font></td>
									<%if es_lunes = "1" then %>
										<td align="center" bgcolor="#d7f5fd"><font size="3" color="#0099CC">LUNES</font><br><font color="#990000"><%=fecha_trabajo(1)%></font></td>
									<%else%>
										<td align="center"><font size="3" color="#0099CC">LUNES</font><br><font color="#990000"><%=fecha_trabajo(1)%></font></td>
									<%end if%>	
									<%if es_martes = "1" then %>
										<td align="center" bgcolor="#d7f5fd"><font size="3" color="#0099CC">MARTES</font><br><font color="#990000"><%=fecha_trabajo(2)%></font></td>
									<%else%>
										<td align="center"><font size="3" color="#0099CC">MARTES</font><br><font color="#990000"><%=fecha_trabajo(2)%></font></td>
									<%end if%>
									<%if es_miercoles = "1" then %>
										<td align="center" bgcolor="#d7f5fd"><font size="3" color="#0099CC">MIERCOLES</font><br><font color="#990000"><%=fecha_trabajo(3)%></font></td>
									<%else%>
										<td align="center"><font size="3" color="#0099CC">MIERCOLES</font><br><font color="#990000"><%=fecha_trabajo(3)%></font></td>
									<%end if%>
									<%if es_jueves = "1" then %>
										<td align="center" bgcolor="#d7f5fd"><font size="3" color="#0099CC">JUEVES</font><br><font color="#990000"><%=fecha_trabajo(4)%></font></td>
									<%else%>
										<td align="center"><font size="3" color="#0099CC">JUEVES</font><br><font color="#990000"><%=fecha_trabajo(4)%></font></td>
									<%end if%>
									<%if es_viernes = "1" then %>
										<td align="center" bgcolor="#d7f5fd"><font size="3" color="#0099CC">VIERNES</font><br><font color="#990000"><%=fecha_trabajo(5)%></font></td>
									<%else%>
										<td align="center"><font size="3" color="#0099CC">VIERNES</font><br><font color="#990000"><%=fecha_trabajo(5)%></font></td>
									<%end if%>
									
								</tr>
									<%while f_horas.siguiente%>
								    <tr>
									    <td align="center" height="25"><%=f_horas.ObtenerValor("hora")%></td>
										<%if es_lunes = "1" then %> 
										<td align="center" bgcolor="#d7f5fd" valign="bottom" height="25"><%=f_horas.ObtenerValor("eslunes")%></td>
										<%else%>
										<td align="center" valign="bottom"><%=f_horas.ObtenerValor("eslunes")%></td>
										<%end if%>
										<%if es_martes = "1" then %>
										<td align="center" bgcolor="#d7f5fd" valign="bottom"><%=f_horas.ObtenerValor("esmartes")%></td>
										<%else%>
										<td align="center" valign="bottom"><%=f_horas.ObtenerValor("esmartes")%></td>
										<%end if%>
										<%if es_miercoles = "1" then %>
										<td align="center" bgcolor="#d7f5fd" valign="bottom"><%=f_horas.ObtenerValor("esmiercoles")%></td>
										<%else%>
										<td align="center" valign="bottom"><%=f_horas.ObtenerValor("esmiercoles")%></td>
										<%end if%>
										<%if es_jueves = "1" then %>
										<td align="center" bgcolor="#d7f5fd" valign="bottom"><%=f_horas.ObtenerValor("esjueves")%></td>
										<%else%>
										<td align="center" valign="bottom"><%=f_horas.ObtenerValor("esjueves")%></td>
										<%end if%>
										<%if es_viernes = "1" then %>
										<td align="center" bgcolor="#d7f5fd" valign="bottom"><%=f_horas.ObtenerValor("esviernes")%></td>
										<%else%>
										<td align="center" valign="bottom"><%=f_horas.ObtenerValor("esviernes")%></td>
										<%end if%>
										
												
							    	<%wend%>
									</tr>
								
						        </table>
						</td>
                      </tr>
                    </table>
                  </div>
					
			  <%end if%>
              </td></tr>
        </table></td>
        <td width="7" background="../imagenes/der.gif">&nbsp;</td>
      </tr>
      <tr>
        <td width="9" height="12" valign="top"><img src="../imagenes/abajo_r1_c1.gif" width="9" height="12"></td>
        <td height="28"><table width="100%" height="28"  border="0" cellpadding="0" cellspacing="0">
							  <tr>
								<td width="82%" rowspan="3" background="../imagenes/abajo_r1_c4.gif">&nbsp;</td>
							  </tr>
							  
						</table>
		</td>
        <td width="7" height="28"><img src="../imagenes/abajo_r1_c5.gif" width="7" height="28"></td>
      </tr>
    </table>
	
	</td>
  </tr>  
</table> </form>
</body>
</html>