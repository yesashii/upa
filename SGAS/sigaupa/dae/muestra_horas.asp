<!-- #include file = "../biblioteca/_conexion.asp" -->
<!-- #include file = "../biblioteca/_negocio.asp" -->

<%

peri_ccod=request.QueryString("peri_ccod")
sede_ccod=request.QueryString("sede_ccod")
fecha_consulta=request.QueryString("fecha_consulta")
indice=request.QueryString("indice")
if indice="" then

indice=-99
end if
'response.Write(peri_ccod&"<br>"&sede_ccod&"<br>"&fecha)
'---------------------------------------------------------------------------------------------------

set errores= new CErrores

set conexion = new CConexion
conexion.Inicializar "upacifico"

set negocio = new CNegocio
negocio.Inicializa conexion

'---------------------------------------------------------------------------------------------------
set pagina = new cPagina
set botonera = new CFormulario
botonera.carga_parametros "crea_modulos_sicologos.xml", "botonera"
'---------------------------------------------------------------------------------------------------
set f_botonera = new CFormulario
f_botonera.Carga_Parametros "crea_modulos_sicologos.xml", "botonera"

'---------------------------------------------------------------------------------------------------

'---------------------------------------------------------------------------------------------------
set f_cheques = new CFormulario
f_cheques.Carga_Parametros "crea_modulos_sicologos.xml", "cheques"
f_cheques.Inicializar conexion


sql_descuentos= "select ''"

f_cheques.Consultar sql_descuentos
f_cheques.Siguiente
 usu=negocio.obtenerUsuario
 f_cheques.agregaCampoCons "peri_ccod",peri_ccod
 f_cheques.agregaCampoCons "sede_ccod",sede_ccod
 f_cheques.agregaCampoCons "fecha_consulta",fecha_consulta
 
 
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
'response.Write(sql_descuentos)
 if not esVacio(fecha_consulta) then
 	 dia_semana = conexion.consultaUno("select datepart(weekday,convert(datetime,'"&fecha_consulta&"',103))") 
' 
	 'response.Write(dia_semana)
 end if
 fecha_trabajo = Array("","","","","","","","")
'Toma la fecha del dia en que esta parado y genera las fechas de la semana completa, ejemplo:
' si la fecha es 30/10/2012 el dia es martes entonces:
'		  fecha_trabajo(1) = conexion.consultaUno("select convert(datetime,'"&fecha_consulta&"',103)-1")**** LUNES
'		  fecha_trabajo(2) = conexion.consultaUno("select convert(datetime,'"&fecha_consulta&"',103)") **** Dia seleccionado (MARTES)
'		  fecha_trabajo(3) = conexion.consultaUno("select convert(datetime,'"&fecha_consulta&"',103)+1")**** MIERCOLES
'		  fecha_trabajo(4) = conexion.consultaUno("select convert(datetime,'"&fecha_consulta&"',103)+2")**** JUEVES
'		  fecha_trabajo(5) = conexion.consultaUno("select convert(datetime,'"&fecha_consulta&"',103)+3")**** VIERNES
'		  fecha_trabajo(6) = conexion.consultaUno("select convert(datetime,'"&fecha_consulta&"',103)+4")**** SABADO
'		  fecha_trabajo(7) = conexion.consultaUno("select convert(datetime,'"&fecha_consulta&"',103)+5")**** DOMINGO


 if not esVacio(fecha_consulta) then
 	 if dia_semana = "1" then
		  fecha_trabajo(1) = conexion.consultaUno("select convert(datetime,'"&fecha_consulta&"',103)")
		  fecha_trabajo(2) = conexion.consultaUno("select convert(datetime,'"&fecha_consulta&"',103)+1")
		  fecha_trabajo(3) = conexion.consultaUno("select convert(datetime,'"&fecha_consulta&"',103)+2")
		  fecha_trabajo(4) = conexion.consultaUno("select convert(datetime,'"&fecha_consulta&"',103)+3")
		  fecha_trabajo(5) = conexion.consultaUno("select convert(datetime,'"&fecha_consulta&"',103)+4")
		  fecha_trabajo(6) = conexion.consultaUno("select convert(datetime,'"&fecha_consulta&"',103)+5")
		  fecha_trabajo(7) = conexion.consultaUno("select convert(datetime,'"&fecha_consulta&"',103)+6")
	 elseif dia_semana = "2" then
		  fecha_trabajo(1) = conexion.consultaUno("select convert(datetime,'"&fecha_consulta&"',103)-1")
		  fecha_trabajo(2) = conexion.consultaUno("select convert(datetime,'"&fecha_consulta&"',103)")
		  fecha_trabajo(3) = conexion.consultaUno("select convert(datetime,'"&fecha_consulta&"',103)+1")
		  fecha_trabajo(4) = conexion.consultaUno("select convert(datetime,'"&fecha_consulta&"',103)+2")
		  fecha_trabajo(5) = conexion.consultaUno("select convert(datetime,'"&fecha_consulta&"',103)+3")
		  fecha_trabajo(6) = conexion.consultaUno("select convert(datetime,'"&fecha_consulta&"',103)+4")
		  fecha_trabajo(7) = conexion.consultaUno("select convert(datetime,'"&fecha_consulta&"',103)+5")
	 elseif dia_semana = "3" then
		  fecha_trabajo(1) = conexion.consultaUno("select convert(datetime,'"&fecha_consulta&"',103)-2")
		  fecha_trabajo(2) = conexion.consultaUno("select convert(datetime,'"&fecha_consulta&"',103)-1")
		  fecha_trabajo(3) = conexion.consultaUno("select convert(datetime,'"&fecha_consulta&"',103)")
		  fecha_trabajo(4) = conexion.consultaUno("select convert(datetime,'"&fecha_consulta&"',103)+1")
		  fecha_trabajo(5) = conexion.consultaUno("select convert(datetime,'"&fecha_consulta&"',103)+2")
		  fecha_trabajo(6) = conexion.consultaUno("select convert(datetime,'"&fecha_consulta&"',103)+3")
		  fecha_trabajo(7) = conexion.consultaUno("select convert(datetime,'"&fecha_consulta&"',103)+4") 
     elseif dia_semana = "4" then
		  fecha_trabajo(1) = conexion.consultaUno("select convert(datetime,'"&fecha_consulta&"',103)-3")
		  fecha_trabajo(2) = conexion.consultaUno("select convert(datetime,'"&fecha_consulta&"',103)-2")
		  fecha_trabajo(3) = conexion.consultaUno("select convert(datetime,'"&fecha_consulta&"',103)-1")
		  fecha_trabajo(4) = conexion.consultaUno("select convert(datetime,'"&fecha_consulta&"',103)")
		  fecha_trabajo(5) = conexion.consultaUno("select convert(datetime,'"&fecha_consulta&"',103)+1")
		  fecha_trabajo(6) = conexion.consultaUno("select convert(datetime,'"&fecha_consulta&"',103)+2")
		  fecha_trabajo(7) = conexion.consultaUno("select convert(datetime,'"&fecha_consulta&"',103)+3") 
	 elseif dia_semana = "5" then
		  fecha_trabajo(1) = conexion.consultaUno("select convert(datetime,'"&fecha_consulta&"',103)-4")
		  fecha_trabajo(2) = conexion.consultaUno("select convert(datetime,'"&fecha_consulta&"',103)-3")
		  fecha_trabajo(3) = conexion.consultaUno("select convert(datetime,'"&fecha_consulta&"',103)-2")
		  fecha_trabajo(4) = conexion.consultaUno("select convert(datetime,'"&fecha_consulta&"',103)-1")
		  fecha_trabajo(5) = conexion.consultaUno("select convert(datetime,'"&fecha_consulta&"',103)")
		  fecha_trabajo(6) = conexion.consultaUno("select convert(datetime,'"&fecha_consulta&"',103)+1")
		  fecha_trabajo(7) = conexion.consultaUno("select convert(datetime,'"&fecha_consulta&"',103)+2") 
	 elseif dia_semana = "6" then
		  fecha_trabajo(1) = conexion.consultaUno("select convert(datetime,'"&fecha_consulta&"',103)-5")
		  fecha_trabajo(2) = conexion.consultaUno("select convert(datetime,'"&fecha_consulta&"',103)-4")
		  fecha_trabajo(3) = conexion.consultaUno("select convert(datetime,'"&fecha_consulta&"',103)-3")
		  fecha_trabajo(4) = conexion.consultaUno("select convert(datetime,'"&fecha_consulta&"',103)-2")
		  fecha_trabajo(5) = conexion.consultaUno("select convert(datetime,'"&fecha_consulta&"',103)-1")
		  fecha_trabajo(6) = conexion.consultaUno("select convert(datetime,'"&fecha_consulta&"',103)")
		  fecha_trabajo(7) = conexion.consultaUno("select convert(datetime,'"&fecha_consulta&"',103)+1") 
	 elseif dia_semana = "7" then
		  fecha_trabajo(1) = conexion.consultaUno("select convert(datetime,'"&fecha_consulta&"',103)-6")
		  fecha_trabajo(2) = conexion.consultaUno("select convert(datetime,'"&fecha_consulta&"',103)-5")
		  fecha_trabajo(3) = conexion.consultaUno("select convert(datetime,'"&fecha_consulta&"',103)-4")
		  fecha_trabajo(4) = conexion.consultaUno("select convert(datetime,'"&fecha_consulta&"',103)-3")
		  fecha_trabajo(5) = conexion.consultaUno("select convert(datetime,'"&fecha_consulta&"',103)-2")
		  fecha_trabajo(6) = conexion.consultaUno("select convert(datetime,'"&fecha_consulta&"',103)-1")
		  fecha_trabajo(7) = conexion.consultaUno("select convert(datetime,'"&fecha_consulta&"',103)") 	  
     end if
 end if
 
 
 if fecha_consulta<>"" then
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
 
if Request.QueryString <> "" then

consulta_modulo="select case count(*) when 0 then 'No' else 'Si' end  from bloques_sicologos a,"& vbcrlf & _
"sicologos_sede b,"& vbcrlf & _
"sicologos c"& vbcrlf & _
"where a.side_ncorr=b.side_ncorr"& vbcrlf & _
"and b.sico_ncorr=c.sico_ncorr"& vbcrlf & _
"and c.pers_ncorr=protic.obtener_pers_ncorr("&usu&")"& vbcrlf & _
"and b.sede_ccod="&sede_ccod&""& vbcrlf & _
"and a.peri_ccod="&peri_ccod&""
'response.Write(consulta_modulo)
tiene_bloque_creado=conexion.ConsultaUno(consulta_modulo)

side_ncorr=conexion.ConsultaUno("select side_ncorr from sicologos_sede a, sicologos b where a.sico_ncorr=b.sico_ncorr and b.pers_ncorr=protic.obtener_pers_ncorr("&usu&") and sede_ccod="&sede_ccod&"")
'response.Write(side_ncorr)
 set f_horas = new CFormulario
f_horas.Carga_Parametros "crea_modulos_sicologos.xml", "hora"
f_horas.Inicializar conexion
if sede_ccod<>"" and tiene_bloque_creado="Si" then  
sql_hora= "select hora_ini+'-'+hora_fin as hora,"& vbcrlf & _
"isnull((select case when count(*)>0 then '<a style="&CHR(034)&"cursor:pointer"&CHR(034)&" onClick="&CHR(034) &"CambiarHora('+cast(hoto_ncorr as varchar)+');"&CHR(034) &" title="&CHR(034) &"'+pers_tnombre+' '+pers_tape_paterno+'"&CHR(034) &">'+cast(pers_nrut as varchar)+'-'+pers_xdv+'</a>' else '&nbsp;' end from horas_tomadas aa, personas bb where aa.pers_ncorr=bb.PERS_NCORR and aa.blsi_ncorr=a.blsi_ncorr and convert(datetime,hoto_fecha,103)=convert(datetime,'"&fecha_trabajo(1)&"',103) and esho_ccod in (1,2,3) group by hoto_ncorr,pers_tnombre,pers_tape_paterno,pers_nrut,pers_xdv),'<a>&nbsp;</a>')as lunes ,"& vbcrlf & _
"isnull((select case when count(*)>0 then '<a style="&CHR(034)&"cursor:pointer"&CHR(034)&" onClick="&CHR(034) &"CambiarHora('+cast(hoto_ncorr as varchar)+');"&CHR(034) &" title="&CHR(034) &"'+pers_tnombre+' '+pers_tape_paterno+'"&CHR(034) &">'+cast(pers_nrut as varchar)+'-'+pers_xdv+'</a>' else '&nbsp;' end from horas_tomadas aa, personas bb where aa.pers_ncorr=bb.PERS_NCORR and aa.blsi_ncorr=a.blsi_ncorr and convert(datetime,hoto_fecha,103)=convert(datetime,'"&fecha_trabajo(2)&"',103) and esho_ccod in (1,2,3) group by hoto_ncorr,pers_tnombre,pers_tape_paterno,pers_nrut,pers_xdv),'<a>&nbsp;</a>')as martes ,"& vbcrlf & _
"isnull((select case when count(*)>0 then '<a style="&CHR(034)&"cursor:pointer"&CHR(034)&" onClick="&CHR(034) &"CambiarHora('+cast(hoto_ncorr as varchar)+');"&CHR(034) &" title="&CHR(034) &"'+pers_tnombre+' '+pers_tape_paterno+'"&CHR(034) &">'+cast(pers_nrut as varchar)+'-'+pers_xdv+'</a>' else '&nbsp;' end from horas_tomadas aa, personas bb where aa.pers_ncorr=bb.PERS_NCORR and aa.blsi_ncorr=a.blsi_ncorr and convert(datetime,hoto_fecha,103)=convert(datetime,'"&fecha_trabajo(3)&"',103) and esho_ccod in (1,2,3) group by hoto_ncorr,pers_tnombre,pers_tape_paterno,pers_nrut,pers_xdv),'<a>&nbsp;</a>')as miercoles ,"& vbcrlf & _
"isnull((select case when count(*)>0 then '<a style="&CHR(034)&"cursor:pointer"&CHR(034)&" onClick="&CHR(034) &"CambiarHora('+cast(hoto_ncorr as varchar)+');"&CHR(034) &" title="&CHR(034) &"'+pers_tnombre+' '+pers_tape_paterno+'"&CHR(034) &">'+cast(pers_nrut as varchar)+'-'+pers_xdv+'</a>' else '&nbsp;' end from horas_tomadas aa, personas bb where aa.pers_ncorr=bb.PERS_NCORR and aa.blsi_ncorr=a.blsi_ncorr and convert(datetime,hoto_fecha,103)=convert(datetime,'"&fecha_trabajo(4)&"',103) and esho_ccod in (1,2,3) group by hoto_ncorr,pers_tnombre,pers_tape_paterno,pers_nrut,pers_xdv),'<a>&nbsp;</a>')as jueves ,"& vbcrlf & _
"isnull((select case when count(*)>0 then '<a style="&CHR(034)&"cursor:pointer"&CHR(034)&" onClick="&CHR(034) &"CambiarHora('+cast(hoto_ncorr as varchar)+');"&CHR(034) &" title="&CHR(034) &"'+pers_tnombre+' '+pers_tape_paterno+'"&CHR(034) &">'+cast(pers_nrut as varchar)+'-'+pers_xdv+'</a>' else '&nbsp;' end from horas_tomadas aa, personas bb where aa.pers_ncorr=bb.PERS_NCORR and aa.blsi_ncorr=a.blsi_ncorr and convert(datetime,hoto_fecha,103)=convert(datetime,'"&fecha_trabajo(5)&"',103) and esho_ccod in (1,2,3) group by hoto_ncorr,pers_tnombre,pers_tape_paterno,pers_nrut,pers_xdv),'<a>&nbsp;</a>')as viernes "& vbcrlf & _
"from bloques_sicologos a,"& vbcrlf & _
"sicologos_sede b,"& vbcrlf & _
"sicologos c"& vbcrlf & _
"where a.side_ncorr=b.side_ncorr"& vbcrlf & _
"and b.sico_ncorr=c.sico_ncorr"& vbcrlf & _
"and b.sede_ccod="&sede_ccod&""& vbcrlf & _
"and a.peri_ccod="&peri_ccod&""& vbcrlf & _
"and c.pers_ncorr=protic.obtener_pers_ncorr("&usu&")"
else
sql_hora="select ''"
end if

'response.Write("<br>"&sql_hora)
f_horas.Consultar sql_hora

end if 

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


function carga()
{
var indice =<%=indice%> 

	if (indice!="-99")
	{
		document.edicion.elements["a[0][sede_ccod]"].selectedIndex=indice;
	}
}
function buscar()
{
//alert("entro")
formulario=document.edicion;
	if (preValidaFormulario(formulario)) 
	{		
		//alert("se va")
		var indice =document.edicion.elements["a[0][sede_ccod]"].selectedIndex; 
		var sede_ccod =document.edicion.elements["a[0][sede_ccod]"].value; 
		var peri_ccod=document.edicion.elements["a[0][peri_ccod]"].value;
		var fecha=document.edicion.elements["a[0][fecha_consulta]"].value;
		
		p_url="muestra_horas.asp?peri_ccod="+peri_ccod+"&fecha_consulta="+fecha+"&indice="+indice+"&sede_ccod="+sede_ccod+"";
		
		location.href=p_url			
			
	}
}

function CambiarHora(hoto)
{

var sede_ccod =document.edicion.elements["a[0][sede_ccod]"].value; 
var peri_ccod=document.edicion.elements["a[0][peri_ccod]"].value;
var fecha=document.edicion.elements["a[0][fecha_consulta]"].value;
var indice=<%=indice%>		
		p_url="modificar_hora.asp?peri_ccod="+peri_ccod+"&fecha_consulta="+fecha+"&indice="+indice+"&sede_ccod="+sede_ccod+"&hoto_ncorr="+hoto+"";
		
		location.href=p_url	

}

</script>
<%
	set calendario = new FCalendario
	calendario.IniciaFuncion
	calendario.MuestraFecha "a[0][fecha_consulta]","1","edicion","fecha_consulta_oculta"
	calendario.FinFuncion
%>
<% 'f_cheques.generaJS %>
</head>
<body bgcolor="#CC6600" leftmargin="0" topmargin="0" marginwidth="0" marginheight="0" onLoad="MM_preloadImages('../imagenes/botones/buscar_f2.gif','../images/bot_deshabilitar_f2.gif','../images/agregar2_f2_p.gif','im&amp;#225;genes/marco1_r3_c2_f2.gif');MM_preloadImages('im&amp;#225;genes/marco1_r3_c4_f2.gif');MM_preloadImages('im&amp;#225;genes/marco1_r3_c6_f2.gif');MM_preloadImages('im&amp;#225;genes/marco1_r3_c8_f2.gif');MM_preloadImages('../imagenes/botones/cargar_f2.gif','../imagenes/botones/continuar_f2.gif'),carga();" onBlur="revisaVentana();">
<%calendario.ImprimeVariables%>
<form name="edicion">
<table width="750" height="300" border="0" align="center" cellpadding="0" cellspacing="0">
  <tr>
    <td height="62" valign="top"><img src="../imagenes/vineta2_r1_c1.gif" width="750" height="62" border="0"></td>
  </tr>
  <%pagina.DibujarEncabezado()%>  
  <tr>
    <td valign="top" bgcolor="#EAEAEA">
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
            <td height="2" background="../imagenes/top_r3_c2.gif"></td>
          </tr>
		  <tr>
		  <td><div align="center">
                    <br>
                    <table width="100%" border="0">
                    
                    </table>
			    </tr>
          <tr>
            <td>
				
              
                <table width="98%"  border="0" align="center" cellpadding="0" cellspacing="0">
                  <tr>
                    <td width="50%">
						  <table width="75%"  border="0" align="center">
								 <tr>				
								   <td width="20%"><span class="Estilo2"></span><strong>Periodo Académico</strong><br><%f_cheques.DibujaCampo("peri_ccod")%></td>
												
								   <td width="20%"><span class="Estilo2"></span><strong>Sede</strong><br>  
									   <select name="a[0][sede_ccod]"  id='NU-N' >
										<option value=''>Seleccione una Sede</option>
										<%while f_sedes_sicologos.Siguiente%>
										<option value='<%=f_sedes_sicologos.Obtenervalor("sede_ccod")%>' ><%=f_sedes_sicologos.Obtenervalor("sede_tdesc")%></option>
										<%wend%>
									 </select>
								   </td>
						    </tr>
						  </table>
						   <table width="75%" align="center">
								   <tr>
									  <td width="33%" align="up"><span class="Estilo2"></span><strong> Selecionar Semana </strong><br>
									    <% f_cheques.dibujaCampo "fecha_consulta"%>
										<a style='cursor:hand;' onClick='PopCalendar.show(document.edicion.fecha_consulta_oculta, "dd/mm/yyyy", null, null, "obtener_fecha(1)", "11");'></a> 
                                		<%calendario.DibujaImagen "fecha_consulta_oculta","1","edicion" %>
									 </td>
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
				
                  <td>
				  	<div align="center"><table id="bt_busca7055" width="92" border="0" cellspacing="0" cellpadding="0" class="click" onMouseOver="_OverBoton(this);" onMouseOut="_OutBoton(this);" onClick="buscar()">
				  <tr> 
					<td width="7" height="16" rowspan="3"><img src="../imagenes/botones/boton1.gif" width="5" height="16" id="bt_busca7055c11"></td> 
					<td width="88" height="2"><img src="../imagenes/botones/boton2.gif" width="88" height="2" id="bt_busca7055c12"></td> 
					<td width="10" height="16" rowspan="3"><img src="../imagenes/botones/boton4.gif" width="5" height="16" id="bt_busca7055c13"></td>
				  </tr>
				  <tr> 
					<td height="12" bgcolor="#EEEEF0" id="bt_busca7055c21" nowrap> 
					  <div align="center"><font id="bt_busca7055f21" color="#333333" size="1" face="Verdana, Arial, Helvetica, sans-serif">Buscar</font></div></td>
				  </tr>
				  <tr> 
					<td width="88" height="2"><img src="../imagenes/botones/boton3.gif" width="88" height="2" id="bt_busca7055c31"></td>
				  </tr>
				</table></div>
				  
				  </td>
				  
							 
                  <td><div align="center"><%f_botonera.DibujaBoton("salir")%></div></td>
				  
				  
				 
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
			
			<%if Request.QueryString <> "" then%>
				<%if tiene_bloque_creado="Si" then%>
			<div align="center"><br>
              <%pagina.DibujarTituloPagina%><br>
                    <table width="100%" border="0">
                      <tr> 
                        <td colspan="3">&nbsp;</td>
                      </tr>
					  
					  <tr> 
                        <td colspan="3">&nbsp;</td>
                      </tr>
					  <tr> 
                        <td colspan="3">
						        <table width="98%" cellpadding="0" cellspacing="0" bgcolor="#FFFFFF" border="2" bordercolor="#0099CC">
								<tr> 
									<td colspan="8" align="center"><font color="#990000">Presione sobre el Rut del alumno para tener datos del alumno o para anular la hora </font></td>
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
									    <td align="center"><font color="#000000"><%=f_horas.ObtenerValor("hora")%></font></td>
										<%if es_lunes = "1" then %> 
										<td align="center" bgcolor="#d7f5fd"><font color="#0099CC"><%=f_horas.ObtenerValor("lunes")%></font></td>
										<%else%>
										<td align="center"><font color="#000000"><%=f_horas.ObtenerValor("lunes")%></font></td>
										<%end if%>
										<%if es_martes = "1" then %>
										<td align="center" bgcolor="#d7f5fd"><font color="#0099CC"><%=f_horas.ObtenerValor("martes")%></font></td>
										<%else%>
										<td align="center"><font color="#000000"><%=f_horas.ObtenerValor("martes")%></font></td>
										<%end if%>
										<%if es_miercoles = "1" then %>
										<td align="center" bgcolor="#d7f5fd"><font color="#0099CC"><%=f_horas.ObtenerValor("miercoles")%></font></td>
										<%else%>
										<td align="center"><font color="#000000"><%=f_horas.ObtenerValor("miercoles")%></font></td>
										<%end if%>
										<%if es_jueves = "1" then %>
										<td align="center" bgcolor="#d7f5fd"><font color="#0099CC"><%=f_horas.ObtenerValor("jueves")%></font></td>
										<%else%>
										<td align="center"><font color="#000000"><%=f_horas.ObtenerValor("jueves")%></font></td>
										<%end if%>
										<%if es_viernes = "1" then %>
										<td align="center" bgcolor="#d7f5fd"><font color="#0099CC"><%=f_horas.ObtenerValor("viernes")%></font></td>
										<%else%>
										<td align="center"><font color="#000000"><%=f_horas.ObtenerValor("viernes")%></font></td>
										<%end if%>
										
												
							    	<%wend%>
									</tr>
								
						        </table>
						</td>
                      </tr>
					  <tr>
					  	<td width="26%"><%f_botonera.AgregaBotonParam "modifica_horario", "url", "bloques_sicologos_anula.asp?peri_ccod="&peri_ccod&"&side_ncorr="&side_ncorr&"&devuelta=1"
											f_botonera.DibujaBoton("modifica_horario")
											%>
						</td> 
                        <td width="74%" colspan="2" align="left"><font color="#990000">Presione sobre el Rut del alumno para ver los datos del alumno o para anular la hora .</font></td>
                      </tr>
					 
                    </table>
                  </div>
					  <%else%>
					  
					  <div>
						<table border="1" align="center" bgcolor="#FF0000">
							<tr>
								<td>
									<font size="2" color="#FFFFFF">USTED NO HA CREADO BLOQUES HORARIOS PARA LA SEDE Y SEMESTRE SELECIONADO</font>								</td>
							</tr>
						</table>
					  </div>
					  <%end if%>
			  <%end if%>
              </td></tr>
        </table></td>
        <td width="7" background="../imagenes/der.gif">&nbsp;</td>
      </tr>
    <tr>
        <td width="9" height="28"><img src="../imagenes/abajo_r1_c1.gif" width="9" height="28"></td>
        <td height="28"><table width="100%" height="28"  border="0" cellpadding="0" cellspacing="0">
          <tr>
            <td width="13%" height="20"><div align="center">
              <table width="90%"  border="0" cellspacing="0" cellpadding="0">
                <tr>
                  <td><div align="center">
                    
					<%f_botonera.AgregaBotonParam "excel", "url", "muestra_horas_excel.asp?sede_ccod="&sede_ccod&"&indice="&indice&"&fecha_consulta="&fecha_consulta&"&peri_ccod="&peri_ccod
				   f_botonera.DibujaBoton"excel"  %></div></td>
				   <td><div align="center">
                    
					<%f_botonera.AgregaBotonParam "excel", "url", "muestra_inasistentes_excel.asp?sede_ccod="&sede_ccod&"&indice="&indice&"&fecha_consulta="&fecha_consulta&"&peri_ccod="&peri_ccod
				   f_botonera.AgregaBotonParam "excel","texto","Inasistentes"
				   f_botonera.DibujaBoton"excel"  %></div></td>
                  </tr>
              </table>
            </div></td>
            <td width="87%" rowspan="2" background="../imagenes/abajo_r1_c4.gif"><img src="../imagenes/abajo_r1_c3.gif" width="12" height="28"></td>
            </tr>
          <tr>
            <td height="8" background="../imagenes/abajo_r2_c2.gif"></td>
          </tr>
        </table></td>
        <td width="7" height="28"><img src="../imagenes/abajo_r1_c5.gif" width="7" height="28"></td>
      </tr>
    </table>
	<br>
	<br>
	
	<br>
	<br>
	</td>
  </tr>  
</table> </form>
</body>
</html>