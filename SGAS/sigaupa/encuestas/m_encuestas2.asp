<!-- #include file = "../biblioteca/_conexion.asp" -->
<!-- #include file = "../biblioteca/_negocio.asp" -->

<%
set pagina = new CPagina
pagina.Titulo = "Mantenedor De Encuestas " 

'------------------------------------------------------------------------------
set botonera = new CFormulario
botonera.Carga_Parametros "m_encuestas2.xml", "botonera"
'-------------------------------------------------------------------------------
encu_ccod=request.QueryString("m[0][encu_ccod]")
dia_creacion=request.QueryString("m[0][dia_creacion]")
mes_creacion=request.QueryString("m[0][mes_creacion]")
ano_creacion=request.QueryString("m[0][ano_creacion]")
fecha_creacion = dia_creacion & "/" & mes_creacion & "/" & ano_creacion
dia_activacion=request.QueryString("m[0][dia_activacion]")
mes_activacion=request.QueryString("m[0][mes_activacion]")
ano_activacion=request.QueryString("m[0][ano_activacion]")
fecha_activacion = dia_activacion & "/" & mes_activacion & "/" & ano_activacion
dia_expiracion=request.QueryString("m[0][dia_expiracion]")
mes_expiracion=request.QueryString("m[0][mes_expiracion]")
ano_expiracion=request.QueryString("m[0][ano_expiracion]")
fecha_expiracion = dia_expiracion & "/" & mes_expiracion & "/" & ano_expiracion

set conectar = new cconexion
conectar.inicializar "upacifico"

set negocio = new CNegocio
negocio.Inicializa conectar
set errores 	= new cErrores

set f_busqueda = new cformulario
f_busqueda.carga_parametros "m_encuestas2.xml", "f_filtros"

f_busqueda.inicializar conectar
f_busqueda.consultar "select  '' as encu_ncorr"
f_busqueda.Siguiente

 f_busqueda.AgregaCampoCons "encu_ccod", encu_ccod
 f_busqueda.AgregaCampoCons "dia_creacion", dia_creacion
 f_busqueda.AgregaCampoCons "mes_creacion", mes_creacion
 f_busqueda.AgregaCampoCons "ano_creacion", ano_creacion
 f_busqueda.AgregaCampoCons "dia_activacion", dia_activacion
 f_busqueda.AgregaCampoCons "mes_activacion", mes_activacion
 f_busqueda.AgregaCampoCons "ano_activacion", ano_activacion
 f_busqueda.AgregaCampoCons "dia_expiracion", dia_expiracion
 f_busqueda.AgregaCampoCons "mes_expiracion", mes_expiracion
 f_busqueda.AgregaCampoCons "ano_expiracion", ano_expiracion

'Query_encuestas = "select encu_ncorr,'<a href=""javascript:editar('|| encu_ncorr || ')"">'|| encu_ccod || '</a>'  as codigo, encu_tnombre as nombre,"& vbcrlf &_ 
'"to_char(encu_fcreacion,'dd/mm/yyyy') as f_creacion,to_char(encu_factivacion,'dd/mm/yyyy') as f_activacion,"& vbcrlf &_ 
'"to_char(encu_fexpiracion,'dd/mm/yyyy') as f_expiracion,'<a href=""javascript:direccionar('|| encu_ncorr || ')"">'|| 'Personalizar' || '</a>' as personalizado from encuestas where 1=1 "

Query_encuestas = "select encu_ncorr,'<a href=""javascript:editar('+ cast(encu_ncorr as varchar) + ')"">'+ cast(encu_ccod as varchar) + '</a>'  as codigo, encu_tnombre as nombre,"& vbcrlf &_ 
"convert(varchar,encu_fcreacion,103) as f_creacion,convert(varchar,encu_factivacion,103) as f_activacion,"& vbcrlf &_ 
"convert(varchar,encu_fexpiracion,103) as f_expiracion,'<a href=""javascript:direccionar('+ cast(encu_ncorr as varchar) + ')"">'+ 'Personalizar' + '</a>' as personalizado from encuestas where 1=1 "


if encu_ccod<>"" then
Query_encuestas=Query_encuestas & " AND cast(encu_ccod as varchar)='"&encu_ccod&"'"
end if

if dia_creacion<>"" and mes_creacion<>"" and ano_creacion<>"" then
Query_encuestas=Query_encuestas & " AND convert(varchar,encu_fcreacion,103) = convert(datetime,'" & fecha_creacion &  "',103) "
end if

if dia_activacion<>"" and mes_activacion<>"" and ano_activacion<>"" then
Query_encuestas=Query_encuestas & " AND convert(varchar,encu_factivacion,103) = convert(datetime,'" & fecha_activacion &  "',103) "
end if

if dia_expiracion<>"" and mes_expiracion<>"" and ano_expiracion<>"" then
Query_encuestas=Query_encuestas &  " AND convert(varchar,encu_fexpiracion,103) = convert(datetime,'" & fecha_expiracion &  "',103) "
end if


set f_encuestas = new cformulario
f_encuestas.carga_parametros "m_encuestas2.xml", "f_tabla"
f_encuestas.inicializar conectar 
f_encuestas.consultar Query_encuestas

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

function buscar_encuestas(formulario){
	formulario.method="get";
	formulario.action="m_encuestas2.asp";
	formulario.submit();
}
function editar(valor){
    
	irA("edita_encuestas2.asp?encu_ncorr="+ valor , "1", 600, 390)
	//document.f_encuestas.method="get";
	//document.f_encuestas.action="edita_encuestas.asp";
	//document.f_encuestas.submit();
}
function direccionar(valor){
	//formulario.method="get";
	//formulario.action="m_criterios.asp?encu_ncorr="+valor;
	//formulario.submit();
	location.href ="m_criterios2.asp?encu_ncorr="+valor;
}

function buscar(formulario){
	formulario.method = "GET";
	formulario.action = "m_encuestas2.asp";
	formulario.submit();
}

function limpiar()
{
   location.href ="m_encuestas2.asp";
}

function obtener_fecha(objeto)
{
  var arreglo = new Array();
  var fecha = document.buscador.fecha_oculta.value;
  arreglo = fecha.split("/"); 
  if (objeto == "1") 
	{
	  document.buscador.elements["m[0][dia_creacion]"].value = arreglo[0];
	  document.buscador.elements["m[0][mes_creacion]"].value= arreglo[1];
	  document.buscador.elements["m[0][ano_creacion]"].value = arreglo[2];  
    }
  else if (objeto=="2")
    {
      document.buscador.elements["m[0][dia_activacion]"].value = arreglo[0];
	  document.buscador.elements["m[0][mes_activacion]"].value= arreglo[1];
	  document.buscador.elements["m[0][ano_activacion]"].value = arreglo[2]; 
    }
  else if (objeto=="3")
    {
      document.buscador.elements["m[0][dia_expiracion]"].value = arreglo[0];
	  document.buscador.elements["m[0][mes_expiracion]"].value= arreglo[1];
	  document.buscador.elements["m[0][ano_expiracion]"].value = arreglo[2]; 
    }
}
</script>

</head>
<body bgcolor="#EBEBEB" leftmargin="0" topmargin="0" marginwidth="0" marginheight="0">
<script language="JavaScript">
	//Para que ejecute debe de estar entre <body> y </body>
	PopCalendar = getCalendarInstance()
	PopCalendar.startAt = 1	// 0 - sunday ; 1 - monday
	PopCalendar.showWeekNumber = 0 // 0 - don't show; 1 - show
	PopCalendar.showToday = 1 // 0 - don't show; 1 - show
	PopCalendar.showWeekend = 1 // 0 - don't show; 1 - show
	PopCalendar.showHolidays = 1 // 0 - don't show; 1 - show
	PopCalendar.showSpecialDay = 1 // 0 - don't show, 1 - show
	PopCalendar.selectWeekend = 0 // 0 - don't Select; 1 - Select
	PopCalendar.selectHoliday = 0 // 0 - don't Select; 1 - Select
	PopCalendar.addCarnival = 1 // 0 - don't Add; 1- Add to Holiday (Tuesday of Carnival)
	PopCalendar.addGoodFriday = 1 // 0 - don't Add; 1- Add to Holiday
	PopCalendar.language = 0 // 0 - Spanish; 1 - English
	PopCalendar.defaultFormat = "dd-mm-yyyy" //Default Format dd-mm-yyyy
	PopCalendar.fixedX = -1 // x position (-1 if to appear below control)
	PopCalendar.fixedY = -1 // y position (-1 if to appear below control)
	PopCalendar.fade = .5 // 0 - don't fade; .1 to 1 - fade (Only IE) 
	PopCalendar.shadow = 1 // 0  - don't shadow, 1 - shadow
	PopCalendar.move = 1 // 0  - don't move, 1 - move (Only IE)
	PopCalendar.saveMovePos = 1  // 0  - don't save, 1 - save
	PopCalendar.centuryLimit = 40 // 1940 - 2039
	//PopCalendar.forcedToday("31-12-1999", "dd-mm-yyyy")  // Force Today Date;
	PopCalendar.initCalendar()
</script>

</head>
<body bgcolor="#CC6600" leftmargin="0" topmargin="0" marginwidth="0" marginheight="0" onLoad="MM_preloadImages('../imagenes/botones/buscar_f2.gif','../images/bot_deshabilitar_f2.gif','../images/agregar2_f2_p.gif','im&amp;#225;genes/marco1_r3_c2_f2.gif');MM_preloadImages('im&amp;#225;genes/marco1_r3_c4_f2.gif');MM_preloadImages('im&amp;#225;genes/marco1_r3_c6_f2.gif');MM_preloadImages('im&amp;#225;genes/marco1_r3_c8_f2.gif');MM_preloadImages('../imagenes/botones/cargar_f2.gif','../imagenes/botones/continuar_f2.gif')">
<table width="750" border="0" align="center" cellpadding="0" cellspacing="0">
  <tr>
    <td><img src="../imagenes/vineta2_r1_c1.gif" width="750" height="72" border="0"></td>
  </tr>
  <%pagina.DibujarEncabezado()%>  
  <tr>
    <td valign="top" bgcolor="#EAEAEA">
	<br>
	<table width="90%" border="0" align="center" cellpadding="0" cellspacing="0">
      <tr>
        <td><table width="90%" border="0" align="center" cellpadding="0" cellspacing="0">
              <tr> 
                <td><table border="0" cellpadding="0" cellspacing="0" width="100%">
                    <!-- fwtable fwsrc="marco contenidos.png" fwbase="top.gif" fwstyle="Dreamweaver" fwdocid = "742308039" fwnested="0" -->
                    <tr> 
                      <td><img src="../imagenes/spacer.gif" width="9" height="1" border="0" alt=""></td>
                      <td><img src="../imagenes/spacer.gif" width="559" height="1" border="0" alt=""></td>
                      <td><img src="../imagenes/spacer.gif" width="7" height="1" border="0" alt=""></td>
                    </tr>
                    <tr> 
                      <td><img name="top_r1_c1" src="../imagenes/top_r1_c1.gif" width="9" height="8" border="0" alt=""></td>
                      <td height="8"><img name="top_r1_c2" src="../imagenes/top_r1_c2.gif" width="670" height="8" border="0" alt=""></td>
                      <td><img name="top_r1_c3" src="../imagenes/top_r1_c3.gif" width="7" height="8" border="0" alt=""></td>
                    </tr>
                    <tr> 
                      <td><img name="top_r2_c1" src="../imagenes/top_r2_c1.gif" width="9" height="17" border="0" alt=""></td>
                      <td><table width="100%" border="0" cellspacing="0" cellpadding="0">
                          <tr> 
                            <td width="15" background="../imagenes/fondo1.gif"><img src="../imagenes/izq_1.gif" width="5" height="17"></td>
                            <td width="210" valign="bottom" background="../imagenes/fondo1.gif"> 
                              <div align="left"><font color="#FFFFFF" size="1" face="Verdana, Arial, Helvetica, sans-serif">Buscador 
                                </font></div></td>
                            <td width="6"><img src="../imagenes/derech1.gif" width="6" height="17"></td>
                            <td width="423" bgcolor="#D8D8DE"><font color="#D8D8DE" size="1">.</font></td>
                          </tr>
                        </table></td>
                      <td><img name="top_r2_c3" src="../imagenes/top_r2_c3.gif" width="7" height="17" border="0" alt=""></td>
                    </tr>
                    <tr> 
                      <td><img name="top_r3_c1" src="../imagenes/top_r3_c1.gif" width="9" height="2" border="0" alt=""></td>
                      <td><img name="top_r3_c2" src="../imagenes/top_r3_c2.gif" width="670" height="2" border="0" alt=""></td>
                      <td><img name="top_r3_c3" src="../imagenes/top_r3_c3.gif" width="7" height="2" border="0" alt=""></td>
                    </tr>
                  </table>
                  <table width="100%" border="0" cellspacing="0" cellpadding="0">
                    <tr> 
                      <td width="9" height="62" align="left" background="../imagenes/izq.gif">&nbsp;</td>
                      <td bgcolor="#D8D8DE"><form name="buscador">
                    <table width="100%" border="0">
                      <tr> 
                        <td width="21%"><div align="right"><strong>C&oacute;digo 
                            Encuesta </strong></div></td>
                        <td width="5%"><center><strong>:</strong></center></td>
                        <td width="47%"><% f_busqueda.DibujaCampo ("encu_ccod")%></td>
                      </tr>
					  <tr> 
                        <td width="21%"><div align="right"><strong>Fecha de Creación</strong></div></td>
                        <td width="5%"><center><strong>:</strong></center></td>
                        <td width="47%">
						<% f_busqueda.DibujaCampo ("dia_creacion")%>
                        / 
                        <% f_busqueda.DibujaCampo ("mes_creacion")%>
                        / 
                        <% f_busqueda.DibujaCampo ("ano_creacion")%>
                        <a style='cursor:hand;' onClick='PopCalendar.show(document.buscador.fecha_oculta, "dd/mm/yyyy", null, null, "obtener_fecha(1)", "11");'> 
                        <img src="../imagenes/calendario/Calendario2.gif" border="0" style="Padding-Top:10px" align="absmiddle"> 
                        </a>(DD/MM/YYYY) 
                        <input type="hidden" name="fecha_oculta">
						</td>
                      </tr>
					  <tr> 
                        <td width="21%"><div align="right"><strong>Fecha de Activacion</strong></div></td>
                        <td width="5%"><center><strong>:</strong></center></td>
                        <td width="47%">
							<% f_busqueda.DibujaCampo ("dia_activacion")%>
                        	/ 
                        	<% f_busqueda.DibujaCampo ("mes_activacion")%>
                        	/ 
                        	<% f_busqueda.DibujaCampo ("ano_activacion")%>
                        	<a style='cursor:hand;' onClick='PopCalendar.show(document.buscador.fecha_oculta, "dd/mm/yyyy", null, null, "obtener_fecha(2)", "11");'> 
                        	<img src="../imagenes/calendario/Calendario2.gif" border="0" style="Padding-Top:10px" align="absmiddle"> 
                        	</a>(DD/MM/YYYY) 
                        </td>
						</tr>
						<tr> 
                        <td width="21%"><div align="right"><strong>Fecha de Expiración</strong></div></td>
                        <td width="5%"><center><strong>:</strong></center></td>
                        <td width="47%">
							<% f_busqueda.DibujaCampo ("dia_expiracion")%>
                       		 / 
                        	<% f_busqueda.DibujaCampo ("mes_expiracion")%>
                        	/ 
                       		 <% f_busqueda.DibujaCampo ("ano_expiracion")%>
                        	<a style='cursor:hand;' onClick='PopCalendar.show(document.buscador.fecha_oculta, "dd/mm/yyyy", null, null, "obtener_fecha(3)", "11");'> 
                        	<img src="../imagenes/calendario/Calendario2.gif" border="0" style="Padding-Top:10px" align="absmiddle"> 
                        	</a>(DD/MM/YYYY) 
                        </td>
						<td width="1%"><div align="right"><% botonera.dibujaBoton "buscar"%></div></td>
						<td width="26%"><div align="left"><% botonera.dibujaBoton "limpiar"%></div></td>
                      </tr>
                      
                    </table>
                    </form></td>
                      <td width="7" align="right" background="../imagenes/der.gif">&nbsp;</td>
                    </tr>
                    <tr> 
                      <td align="left" valign="top"><img src="../imagenes/base1.gif" width="9" height="13"></td>
                      <td valign="top" bgcolor="#D8D8DE"><img src="../imagenes/base2.gif" width="670" height="13"></td>
                      <td align="right" valign="top"><img src="../imagenes/base3.gif" width="7" height="13"></td>
                    </tr>
                  </table></td>
              </tr>
            </table></td>
      </tr>
    </table>	
	<br>		
	<table width="90%" border="0" align="center" cellpadding="0" cellspacing="0">
        <tr>
          <td><table border="0" cellpadding="0" cellspacing="0" width="100%">
              <!-- fwtable fwsrc="marco contenidos.png" fwbase="top.gif" fwstyle="Dreamweaver" fwdocid = "742308039" fwnested="0" -->
              <tr>
                <td><img src="../imagenes/spacer.gif" width="9" height="1" border="0" alt=""></td>
                <td><img src="../imagenes/spacer.gif" width="559" height="1" border="0" alt=""></td>
                <td><img src="../imagenes/spacer.gif" width="7" height="1" border="0" alt=""></td>
              </tr>
              <tr>
                <td><img name="top_r1_c1" src="../imagenes/top_r1_c1.gif" width="9" height="8" border="0" alt=""></td>
                <td><img src="../imagenes/top_r1_c2.gif" alt="" name="top_r1_c2" width="670" height="8" border="0"></td>
                <td><img name="top_r1_c3" src="../imagenes/top_r1_c3.gif" width="7" height="8" border="0" alt=""></td>
              </tr>
              <tr>
                <td><img name="top_r2_c1" src="../imagenes/top_r2_c1.gif" width="9" height="17" border="0" alt=""></td>
                <td><table width="100%" border="0" cellspacing="0" cellpadding="0">
                    <tr>
                      <td width="13" background="../imagenes/fondo1.gif"><img src="../imagenes/izq_1.gif" width="5" height="17"></td>
                      <td width="209" valign="middle" background="../imagenes/fondo1.gif">
                      <div align="left"><font color="#FFFFFF" size="1" face="Verdana, Arial, Helvetica, sans-serif">Encuestas Encontradas</font></div></td>
                      <td width="448" bgcolor="#D8D8DE"><img src="../imagenes/derech1.gif" width="6" height="17"></td>
                    </tr>
                </table></td>
                <td><img name="top_r2_c3" src="../imagenes/top_r2_c3.gif" width="7" height="17" border="0" alt=""></td>
              </tr>
              <tr>
                <td><img name="top_r3_c1" src="../imagenes/top_r3_c1.gif" width="9" height="2" border="0" alt=""></td>
                <td><img name="top_r3_c2" src="../imagenes/top_r3_c2.gif" width="670" height="2" border="0" alt=""></td>
                <td><img name="top_r3_c3" src="../imagenes/top_r3_c3.gif" width="7" height="2" border="0" alt=""></td>
              </tr>
            </table>
              <table width="100%" border="0" cellspacing="0" cellpadding="0" aling="center">
                <tr>
                  <td width="9" align="left" background="../imagenes/izq.gif">&nbsp;</td>
                  
                <td bgcolor="#D8D8DE"> <div align="center">&nbsp; 
                    <BR>
					<%pagina.DibujarTituloPagina%>
                  </div>
                  <table width="98%" border="0">
                    <tr> 
                       <td><div align="right">P&aacute;gina<%f_encuestas.accesopagina%></div></td>
                    </tr>
                  </table> 
                  <form name="f_encuestas">
                           <div align="center"><%f_encuestas.dibujatabla()%></div>
                  </form>
				  <br>				  </td>
                  <td width="7" align="right" background="../imagenes/der.gif">&nbsp;</td>
                </tr>
            </table>
              <table width="100%" border="0" cellspacing="0" cellpadding="0">
                <tr>
                  <td width="9" rowspan="2"><img src="../imagenes/abajo_r1_c1.gif" width="9" height="28"></td>
                  <td width="101" nowrap bgcolor="#D8D8DE"><table width="100%" border="0" cellpadding="0" cellspacing="0">
                    <tr> 
                      <td width="28%"><% botonera.dibujaBoton "agregar" %></td>
                      <td width="30%"><% botonera.dibujaBoton "eliminar" %> </td>
                      <td width="42%"><% botonera.dibujaBoton "SALIR" %></td>
                    </tr>
                  </table></td>
                  <td width="309" rowspan="2" background="../imagenes/abajo_r1_c4.gif"><img src="../imagenes/abajo_r1_c3.gif" width="12" height="28"></td>
                  <td width="267" rowspan="2" align="right" background="../imagenes/abajo_r1_c4.gif"><img src="../imagenes/abajo_r1_c5.gif" width="7" height="28"></td>
                </tr>
                <tr>
                  <td valign="bottom" bgcolor="#D8D8DE"><img src="../imagenes/abajo_r2_c2.gif" width="100%" height="8"></td>
                </tr>
            </table>
			<BR>
		  </td>
        </tr>
      </table>	
   </td>
  </tr>  
</table>
</body>
</html>
