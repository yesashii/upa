<!-- #include file = "../biblioteca/_conexion.asp" -->
<!-- #include file = "../biblioteca/_negocio.asp" -->
<%
'----------------------------------------------*********captura de get
fecha_calendario = request.QueryString("fecha")
pcot_ncorr_p = request.QueryString("pcot_ncorr")
seot_ncorr = request.QueryString("seot_ncorr")
dgso_ncorr = request.QueryString("dgso_ncorr")
tipoTiempo = request.QueryString("tipo")
'----------------------------------------------*********captura de get
'*************************************************'
'* SE CREA EL SECTOR DE INGRESO DE CALIFICACIONES *'
'*****************************************************************'
set pagina = new CPagina
pagina.Titulo = "Calendario académico"
'*****************************************************************'
'* SE CREA EL SECTOR DE INGRESO DE CALIFICACIONES *'
'**************************************************'
set botonera =  new CFormulario
botonera.carga_parametros "calendario_academico_otec.xml", "botonera_2"
'---------------------------------------------------------------------------------------------------
set conexion = new CConexion
conexion.Inicializar "upacifico"
set negocio = new CNegocio
negocio.Inicializa conexion
set errores = new cErrores
'---------------------------------------------------------------------------------------------------
'** FUNCIÓN HORAS TRANSCURRIDAS **'
'*****************************************************'
function horasTransP(valor, anio)
if valor <> "" then
	consulta_2 = "" & vbCrLf & _
	"select isnull(sum(total_horas), '0') as suma                			" & vbCrLf & _
	"from   datos_generales_secciones_otec as a                  			" & vbCrLf & _
	"       inner join secciones_otec as b                       			" & vbCrLf & _
	"               on a.dgso_ncorr = b.dgso_ncorr               			" & vbCrLf & _
	"       inner join programacion_calendario_otec as c         			" & vbCrLf & _
	"               on b.seot_ncorr = c.seot_ncorr               			" & vbCrLf & _
	"       inner join programacion_calendario_detalle_otec as d 			" & vbCrLf & _
	"               on c.pcot_ncorr = d.pcot_ncorr               			" & vbCrLf & _
	"                  and d.estado_programacion != '0'          			" & vbCrLf & _
	"				   and d.fecha_calendario <= '"&fecha_calendario&"'		" & vbCrLf & _
	"				   and datepart(year,d.fecha_calendario) = '"&anio&"'	" & vbCrLf & _	
	"where  a.dgso_ncorr = '"&valor&"' 					 	     			" 
	valor_aux = conexion.consultauno(consulta_2)	
	horasTransP = valor_aux	
else
	horasTransP = "0"
end if	
end function
'*****************************************************'
'** FUNCIÓN HORAS TRANSCURRIDAS **'
'---------------------------------****************************
consulta_pcot_ncorr = "" & vbCrLf & _
"select a.pcot_ncorr                                                 " & vbCrLf & _
"from   programacion_calendario_otec as a                            " & vbCrLf & _
"       inner join programacion_calendario_detalle_otec              " & vbCrLf & _
"                  as b                                              " & vbCrLf & _
"               on a.pcot_ncorr = b.pcot_ncorr                       " & vbCrLf & _
"                  and a.seot_ncorr = '"& seot_ncorr &"'             " & vbCrLf & _  
"                  and b.fecha_calendario = '"&fecha_calendario&"'   " 
pcot_ncorr = conexion.ConsultaUno(consulta_pcot_ncorr)
'response.Write("pcot_ncorr =" & pcot_ncorr)

'---------------------------------****************************

set formulario = new cformulario
formulario.carga_parametros "calendario_academico_otec.xml", "form_agrega_relator"
formulario.inicializar conexion
'*************************************'
'* carga de parametros en formulario *'
'************************************************************************'
consulta_1 = "Select '"&seot_ncorr&"' as seot_ncorr, cast('"&fecha_calendario&"' as varchar) as fecha_calendario"
'************************************************************************'
'* carga de parametros en formulario *'
'*************************************'
formulario.Consultar consulta_1
contador = 0
formulario.siguiente
'***************************************'
'* CONSULTA QUE LLENA EL COMBO RELATOR *'
'************************************************************************'
consulta = "" & vbCrLf & _
"select b.pers_ncorr as pers_ncorr,                                   " & vbCrLf & _                  
"       b.pers_tape_paterno + '  '                                    " & vbCrLf & _                  
"       + b.pers_tape_materno + ', ' + b.pers_tnombre as nombre       " & vbCrLf & _                  
"from   relatores_programa as a                                       " & vbCrLf & _                  
"       inner join personas as b                                      " & vbCrLf & _                  
"               on a.pers_ncorr = b.pers_ncorr                        " & vbCrLf & _                  
"where  cast(a.dgso_ncorr as varchar) = '"&dgso_ncorr&"'  			  " 
'response.write("<pre>"&consulta&"</pre>")
'response.End()
formulario.agregacampoparam "pers_ncorr","destino","("&consulta &")a"
'************************************************************************'
'* CONSULTA QUE LLENA EL COMBO RELATOR *'
'***************************************'
'***************************'
'* DESTUNO DE LAS PESTAÑAS *'
'************************************************************************'
url_leng_1 = "asigna_relator_c_academico_otec.asp?fecha="& fecha_calendario &"&pcot_ncorr="& pcot_ncorr &"&seot_ncorr="& seot_ncorr &"&dgso_ncorr="& dgso_ncorr 
url_leng_2 = "elimina_dia_c_academico_otec.asp?fecha="& fecha_calendario &"&pcot_ncorr="& pcot_ncorr &"&seot_ncorr="& seot_ncorr &"&dgso_ncorr="& dgso_ncorr 
'************************************************************************'
'* DESTUNO DE LAS PESTAÑAS *'
'***************************'
'***************************************************'
'* FUNCION QUE TRAE EL NOMBRE DEL RELATOR ASIGNADO *'
'************************************************************************'
function existeRelator()
varRetorno = "No existe relator."
consulta_nombre = "" & vbCrLf & _
"select b.pers_tape_paterno + '  '                                " & vbCrLf & _
"       + b.pers_tape_materno + ', ' + b.pers_tnombre as nombre   " & vbCrLf & _
"from   programacion_calendario_detalle_otec as a                 " & vbCrLf & _
"       inner join personas as b                                  " & vbCrLf & _
"       on a.pers_ncorr = b.pers_ncorr 	                          " & vbCrLf & _
"where 	protic.trunc(a.fecha_calendario) = '"&fecha_calendario&"' " & vbCrLf & _
"		and a.pcot_ncorr = '"&pcot_ncorr&"'	                      " 
consulta_codigo = "" & vbCrLf & _
"select isnull(pers_ncorr,'0') as pers_ncorr					" & vbCrLf & _  
"from   programacion_calendario_detalle_otec   	                " & vbCrLf & _          
"where 	protic.trunc(fecha_calendario) = '"&fecha_calendario&"' " & vbCrLf & _
"		and pcot_ncorr = '"&pcot_ncorr&"'	                    " 
nombre = conexion.consultauno(consulta_nombre)
codigo = conexion.consultauno(consulta_codigo)
'response.write("C="&codigo)
'response.write("<pre>"&consulta_codigo&"</pre>")
if codigo = "0" or codigo = "" then
	varRetorno = "No existe relator."
else
	varRetorno = nombre 
end if
existeRelator = varRetorno
end function
'************************************************************************'
'* FUNCION QUE TRAE EL NOMBRE DEL RELATOR ASIGNADO *'
'***************************************************'
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

<script type = "text/javascript" language="JavaScript">
function guardar(formulario)
{
	var valor = formulario.elements["com[0][pers_ncorr]"].value;
	if(valor != "")
	{
		formulario.submit();
	}else
	alert ("No hay un relator para guardar");
	formulario.elements["com[0][pers_ncorr]"].focus();
	formulario.elements["com[0][pers_ncorr]"].select();	  
    return false;
}	
function volver(){
	CerrarActualizar();
}
function validaCambios(){
	alert("..");
	return false;
}

</script>
</head>
<body bgcolor="#CC6600" leftmargin="0" topmargin="0" marginwidth="0" marginheight="0" onLoad="MM_preloadImages('../imagenes/botones/buscar_f2.gif','../images/bot_deshabilitar_f2.gif','../images/agregar2_f2_p.gif','im&amp;#225;genes/marco1_r3_c2_f2.gif');MM_preloadImages('im&amp;#225;genes/marco1_r3_c4_f2.gif');MM_preloadImages('im&amp;#225;genes/marco1_r3_c6_f2.gif');MM_preloadImages('im&amp;#225;genes/marco1_r3_c8_f2.gif');MM_preloadImages('../imagenes/botones/cargar_f2.gif','../imagenes/botones/continuar_f2.gif')" onBlur="revisaVentana();">
<table width="380" border="0" align="center" cellpadding="0" cellspacing="0">
<tr><td>&nbsp;</td>
</tr>
  <tr>
    <td valign="top" bgcolor="#EAEAEA">
	<table width="98%"  border="0" align="center" cellpadding="0" cellspacing="0" bgcolor="#D8D8DE">
      <tr>
        <td width="9" height="8"><img name="top_r1_c1" src="../imagenes/top_r1_c1.gif" width="9" height="8" border="0" alt=""></td>
        <td height="8" background="../imagenes/top_r1_c2.gif"></td>
        <td width="7" height="8"><img name="top_r1_c3" src="../imagenes/top_r1_c3.gif" width="7" height="8" border="0" alt=""></td>
      </tr>
      <tr>
        <td width="9" background="../imagenes/izq.gif">&nbsp;</td>
        <td><table width="100%"  border="0" cellspacing="0" cellpadding="0">
          <tr>
		  <% if tipoTiempo = "pasado" then %>		  
				<td><% pagina.DibujarLenguetas Array(Array("Asignar a un relator al: "& fecha_calendario, url_leng_1)), 1 %></td>
			<% else %>	
				<td><% pagina.DibujarLenguetas Array(Array("Asignar a un relator", url_leng_1), Array("Eliminaci&oacute;n del d&iacute;a: "& fecha_calendario , url_leng_2)), 1 %></td>
			<% end if %>	
          </tr>	
          <tr>
            <td height="2" background="../imagenes/top_r3_c2.gif"></td>
          </tr>
<tr>
	<td width="100%" colspan="3"><br /></td>   
</tr>
<tr>
<td width="100%" colspan="3"><strong> <%response.write("El programa lleva "& horasTransP(dgso_ncorr,split(fecha_calendario,"/")(2)) &" horas (inclusive) hasta la fecha.")%></strong> </td>   
</tr>
<tr>
	<td width="100%" colspan="3"><hr /></td>   
</tr>
          <tr>
            <td>
              <form name="edicion" action="proc_asigna_relator_c_academico_otec.asp" method="post">  
                  <table width="100%" border="0">
				  <tr>
                    <td width="111">&nbsp;</td>                    
                  </tr>
                  <tr>
                    <td width="111">Relator asignado</td>
                    <td align="center" width="8">:</td>
                    <td width="215"><% Response.Write(existeRelator) %></td>
                  </tr>
                  <tr>
                    <td>Nuevo relator</td>
                    <td align="center" >:</td>
                    <td><% formulario.dibujaCampo "pers_ncorr" %>  </td> 					
                  </tr>
				  <tr>
					<td><% formulario.dibujaCampo "seot_ncorr" %>  </td>
					<td><% formulario.dibujaCampo "fecha_calendario"%></td>						
				  </tr>
				  <tr>
                    <td width="111">&nbsp;</td>                    
                  </tr>
                </table>                     
            </form></td>
         </tr>
        </table></td>
        <td width="7" background="../imagenes/der.gif">&nbsp;</td>
      </tr>
      <tr>
        <td width="9" height="28"><img src="../imagenes/abajo_r1_c1.gif" width="9" height="28"></td>
        <td height="28"><table width="100%" height="28"  border="0" cellpadding="0" cellspacing="0">
          <tr>
            <td width="38%" height="20"><div align="center">
              <table width="90%"  border="0" cellspacing="0" cellpadding="0">
                <tr>
                  <td><div align="center"><%botonera.dibujaboton "guardar_2" %></div></td>
                  <td><div align="center"><%botonera.dibujaboton "volver_2" %></div></td>
                  <td><div align="center"></div></td>
                </tr>
              </table>
            </div></td>
            <td width="62%" rowspan="2" background="../imagenes/abajo_r1_c4.gif"><img src="../imagenes/abajo_r1_c3.gif" width="12" height="28"></td>
            </tr>
          <tr>
            <td height="8" background="../imagenes/abajo_r2_c2.gif"></td>
          </tr>
        </table></td>
        <td width="7" height="28"><img src="../imagenes/abajo_r1_c5.gif" width="7" height="28"></td>
      </tr>
    </table>
	</td>
  </tr>  
</table>
</body>
</html>
