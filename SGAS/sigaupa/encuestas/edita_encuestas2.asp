<!-- #include file = "../biblioteca/_conexion.asp" -->
<!-- #include file = "../biblioteca/_negocio.asp" -->

<%
encu_ncorr = request.querystring("encu_ncorr")

set pagina = new CPagina

if encu_ncorr <> "" then
   pagina.Titulo = "Editar Encuesta" 
else
   pagina.Titulo = "Nueva Encuesta" 
end if
'---------------------------------------------------------------------------------------------------
'----------------------------------------------------------	
set conectar = new cconexion
conectar.inicializar "upacifico"

set negocio = new CNegocio
negocio.Inicializa conectar
'-------------------------------------------------------------------------------
'------------------------------------------------------------------------------
set botonera = new CFormulario
botonera.Carga_Parametros "m_encuestas2.xml", "botonera"
'-------------------------------------------------------------------------------
set f_nueva = new cformulario
f_nueva.carga_parametros "m_encuestas2.xml", "f_nueva"
f_nueva.inicializar conectar
 if encu_ncorr <> "" then
   sql ="select convert(varchar,a.encu_factivacion,103) as encu_factivacion,convert(varchar,a.encu_fexpiracion,103) as encu_fexpiracion, a.encu_ncorr, a.encu_ccod, a.encu_tnombre, a.encu_ttitulo,a.encu_tinstruccion,a.tien_ncorr from encuestas a where cast(encu_ncorr as varchar)= '" & encu_ncorr & "'"
 else
   sql = "select '' as encu_ccod"
 end if
'response.Write(sql)
'response.end()
f_nueva.consultar sql
f_nueva.Siguiente

activacion = f_nueva.obtenerValor ("encu_factivacion")
mes_activacion = mid(activacion,1,2)
dia_activacion = mid(activacion,4,2)
ano_activacion = mid(activacion,7,10)
f_nueva.AgregaCampoCons "mes_activacion", mes_activacion
f_nueva.AgregaCampoCons "dia_activacion", dia_activacion
f_nueva.AgregaCampoCons "ano_activacion", ano_activacion

expiracion = f_nueva.obtenerValor ("encu_fexpiracion")
mes_expiracion = mid(expiracion,1,2)
dia_expiracion = mid(activacion,4,2)
ano_expiracion = mid(activacion,7,10)
f_nueva.AgregaCampoCons "mes_expiracion", mes_expiracion
f_nueva.AgregaCampoCons "dia_expiracion", dia_expiracion
f_nueva.AgregaCampoCons "ano_expiracion", ano_expiracion



%>
<html>
<head>
<title><%=Pagina.titulo%></title>
<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1">
<link href="../estilos/estilos.css" rel="stylesheet" type="text/css">
<link href="../estilos/tabla.css" rel="stylesheet" type="text/css">

<script language="JavaScript" src="../biblioteca/tabla.js"></script>
<script language="JavaScript" src="../biblioteca/funciones.js"></script>
<script language="JavaScript" src="../biblioteca/validadores.js"></script>
<script language="JavaScript" src="../biblioteca/PopCalendar.js"></script>

<script language="JavaScript">
function Salir()
{ 
  window.close();
}

function Enviar()
{
  //document.edicion.elements["nueva[0][noti_link]"].value = document.edicion.elements["link"].value;
   
}

function validar()
{
  if (document.edicion.elements["codigo"].value != "")
   {
      if (document.edicion.elements["nombre"].value != "")
       {
	      if (document.edicion.elements["titulo"].value != "")
     	   {
             if (document.edicion.elements["instrucciones"].value != "")
                 {
	            	if (Validar_fecha())
				      {
					  codigo= document.edicion.elements["codigo"].value;
					  tipo= document.edicion.elements["nueva[0][tien_ncorr]"].value;
					  nombre=document.edicion.elements["nombre"].value
					  titulo = document.edicion.elements["titulo"].value;
					  instrucciones = document.edicion.elements["instrucciones"].value;
					  dia_activacion = document.edicion.elements["dia_activacion"].value;
					  mes_activacion = document.edicion.elements["mes_activacion"].value;
					  ano_activacion = document.edicion.elements["ano_activacion"].value;
					  dia_expiracion = document.edicion.elements["dia_expiracion"].value;
					  mes_expiracion = document.edicion.elements["mes_expiracion"].value;
					  ano_expiracion = document.edicion.elements["ano_expiracion"].value;
		     	      encu_ncorr = '<%=encu_ncorr%>';
					
					  url = "proc_Editar_encuesta2.asp?titulo=" + titulo +"&codigo=" + codigo + "&tipo=" + tipo + "&nombre=" + nombre +"&instrucciones=" + instrucciones + "&dia_activacion=" + dia_activacion + "&mes_activacion=" + mes_activacion + "&ano_activacion=" + ano_activacion + "&dia_expiracion=" + dia_expiracion + "&mes_expiracion=" + mes_expiracion + "&ano_expiracion=" + ano_expiracion + "&encu_ncorr=" + encu_ncorr ;
					  document.edicion.method = "POST";
 				      document.edicion.action = url;
				      document.edicion.submit();

					  }
				       else
				       {
					    alert("Ingrese una Fecha válida.");}
			  } 
	          else
              { alert("Ingrese Las instrucciones de la encuesta");  document.edicion.elements["instrucciones"].focus();}
   		}
   		else
  	   { alert("Ingrese el titulo de la encuesta"); document.edicion.elements["titulo"].focus();}
	 }
   	else
    { alert("Ingrese el Nombre de la encuesta"); document.edicion.elements["nombre"].focus();}
  }
  else
  { alert("Ingrese el código de la encuesta"); document.edicion.elements["codigo"].focus();}
}

function Validar_fecha()
{
	var dia_act, mes_act, ano_act,dia_exp,mes_exp,ano_exp;
	dia_act = document.edicion.elements["dia_activacion"].value;
    mes_act = document.edicion.elements["mes_activacion"].value;
    ano_act = document.edicion.elements["ano_activacion"].value;
	dia_exp = document.edicion.elements["dia_expiracion"].value;
    mes_exp = document.edicion.elements["mes_expiracion"].value;
    ano_exp = document.edicion.elements["ano_expiracion"].value;
  
    if ((dia_act != "") || (mes_act != "") || (ano_act != "")||(dia_exp != "") || (mes_exp != "") || (ano_exp != ""))
       return (isFecha(dia_act + "/" + mes_act + "/" + ano_act) && isFecha(dia_exp + "/" + mes_exp + "/" + ano_exp) );   
    else
      return false;
}

function obtener_fecha(objeto)
{
  var arreglo = new Array();
  var fecha = document.edicion.fecha_oculta.value;
  arreglo = fecha.split("/"); 
  //alert("Fecha "+ arreglo[0]+"/"+arreglo[1]+"/"+arreglo[2]);
 if(objeto == "1") 
    {
      document.edicion.elements["dia_activacion"].value = arreglo[0];
	  document.edicion.elements["mes_activacion"].value= arreglo[1];
	  document.edicion.elements["ano_activacion"].value = arreglo[2]; 
    }
  else
    {
      document.edicion.elements["dia_expiracion"].value = arreglo[0];
	  document.edicion.elements["mes_expiracion"].value= arreglo[1];
	  document.edicion.elements["ano_expiracion"].value = arreglo[2]; 
    }
}

</script>

</head>
<body bgcolor="#EBEBEB" leftmargin="0" topmargin="0" marginwidth="0" marginheight="0">
<script language="JavaScript">
	//Para que ejecute debe de estar entre <body> y </body>
	PopCalendar = getCalendarInstance()
	PopCalendar.startAt = 0	// 0 - sunday ; 1 - monday
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
	PopCalendar.defaultFormat = "mm-dd-yyyy" //Default Format dd-mm-yyyy
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

<html>
<head>
<title><%=pagina.Titulo%></title>
<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1">
<link href="../estilos/estilos.css" rel="stylesheet" type="text/css">
<link href="../estilos/tabla.css" rel="stylesheet" type="text/css">

<body bgcolor="#D8D8DE" leftmargin="0" topmargin="0" marginwidth="0" marginheight="0" onLoad="MM_preloadImages('../imagenes/botones/buscar_f2.gif','../images/bot_deshabilitar_f2.gif','../images/agregar2_f2_p.gif','im&amp;#225;genes/marco1_r3_c2_f2.gif');MM_preloadImages('im&amp;#225;genes/marco1_r3_c4_f2.gif');MM_preloadImages('im&amp;#225;genes/marco1_r3_c6_f2.gif');MM_preloadImages('im&amp;#225;genes/marco1_r3_c8_f2.gif');MM_preloadImages('../imagenes/botones/cargar_f2.gif','../imagenes/botones/continuar_f2.gif')" onBlur="revisaVentana();">
<table width="600" height="100%" border="0" align="center" cellpadding="0" cellspacing="0">
  
  <tr> 
    <td valign="top" bgcolor="#EAEAEA"> <br> <br> <table width="90%"  border="0" align="center" cellpadding="0" cellspacing="0" bgcolor="#D8D8DE">
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
                <td align="center"><br>
              <%pagina.DibujarTituloPagina%>
              <br>
              <br></td>
              </tr>
            </table>
			<form action="JAVASCRIPT:Enviar();" method="post" enctype="multipart/form-data" name="edicion" id="edicion">
                <table width="100%" border="0">
				<tr> 
                    <td width="26%"><div align="right">C&oacute;digo<strong><font color="#FF0000"> 
                        </font></strong></div></td>
                    <td width="4%"><div align="center">:</div></td>
                    <td width="70%"><input name="codigo" type="text" value='<%=f_nueva.obtenerValor("encu_ccod")%>' size="15" maxlength="10"> 
                    </td>
                  </tr>
				  <tr> 
                    <td width="26%"><div align="right">Tipo<strong><font color="#FF0000"> 
                        </font></strong></div></td>
                    <td width="4%"><div align="center">:</div></td>
                    <td width="70%"><% f_nueva.DibujaCampo ("tien_ncorr")%> 
                    </td>
                  </tr>
                  <tr> 
                    <td width="26%"><div align="right">Nombre<strong><font color="#FF0000"> 
                        </font></strong></div></td>
                    <td width="4%"><div align="center">:</div></td>
                    <td width="70%"><input name="nombre" type="text" value='<%=f_nueva.obtenerValor("encu_tnombre")%>' size="70" maxlength="50"> 
                    </td>
                  </tr>
				  <tr> 
                    <td colspan="3"><div align="center"> </div></td>
                  </tr>
                  <tr> 
                    <td><div align="right">T&iacute;tulo</div></td>
                    <td><div align="center">:</div></td>
                    <td><textarea name="titulo" cols="50" rows="2" id="resumen"><%=f_nueva.obtenerValor("encu_ttitulo")%></textarea> 
                    </td>
                  </tr>
				   <tr> 
                    <td><div align="right">Instrucciones</div></td>
                    <td><div align="center">:</div></td>
                    <td><textarea name="instrucciones" cols="70" rows="4" id="resumen"><%=f_nueva.obtenerValor("encu_tinstruccion")%></textarea> 
                    </td>
                  </tr>
                 
                  <tr> 
                    <td colspan="3"><div align="center"> </div></td>
                  </tr>
                  
                  <tr> 
                    <td><div align="right">Fecha de Activaci&oacute;n </div></td>
                    <td><div align="center">:</div></td>
                    <td> <input name="dia_activacion" type="text" id="dia_activacion" size="2" maxlength="2" value='<%=f_nueva.obtenerValor("dia_activacion")%>'>
					  / 
                      <input name="mes_activacion" type="text" id="mes_activacion" size="2" maxlength="2" value='<%=f_nueva.obtenerValor("mes_activacion")%>'>
                      / 
                      <input name="ano_activacion" type="text" id="ano_activacion" size="4" maxlength="4" value='<%=f_nueva.obtenerValor("ano_activacion")%>'> 
                      <a style='cursor:hand;' onClick='PopCalendar.show(document.edicion.fecha_oculta, "dd/mm/yyyy", null, null, "obtener_fecha(1)", "11");'> 
                      <img src="../imagenes/calendario/Calendario2.gif" border="0" style="Padding-Top:10px" align="absmiddle"> 
                      <input type="hidden" name="fecha_oculta">
                      </a>(DD/MM/YYYY) </td>
                  </tr>
				  <tr> 
                    <td><div align="right">Fecha de Expiraci&oacute;n </div></td>
                    <td><div align="center">:</div></td>
                    <td> <input name="dia_expiracion" type="text" id="dia_expiracion" size="2" maxlength="2" value='<%=f_nueva.obtenerValor("dia_expiracion")%>'>
					  / 
                      <input name="mes_expiracion" type="text" id="mes_expiracion" size="2" maxlength="2" value='<%=f_nueva.obtenerValor("mes_expiracion")%>'>
                      / 
                      <input name="ano_expiracion" type="text" id="ano_expiracion" size="4" maxlength="4" value='<%=f_nueva.obtenerValor("ano_expiracion")%>'> 
                      <a style='cursor:hand;' onClick='PopCalendar.show(document.edicion.fecha_oculta, "dd/mm/yyyy", null, null, "obtener_fecha(2)", "11");'> 
                      <img src="../imagenes/calendario/Calendario2.gif" border="0" style="Padding-Top:10px" align="absmiddle"> 
                     </a>(DD/MM/YYYY) </td>
                  </tr>
                </table>
                </form>
			</td>
          <td width="7" background="../imagenes/der.gif">&nbsp;</td>
        </tr>
        <tr> 
          <td width="9" height="28"><img src="../imagenes/abajo_r1_c1.gif" width="9" height="28"></td>
          <td height="28"><table width="100%" height="28"  border="0" cellpadding="0" cellspacing="0">
              <tr> 
                <td width="19%" height="20"><div align="center"> 
                    <table width="90%"  border="0" cellspacing="0" cellpadding="0">
                      <tr> 
                        <td width="47%"><div align="center">
                            <%botonera.DibujaBoton "grabar"%>
                          </div></td>
                        <td width="53%"><div align="center">
                            <%botonera.DibujaBoton "cerrar_actualizar"%>
                          </div></td>
                      </tr>
                    </table>
                  </div></td>
                <td width="81%" rowspan="2" background="../imagenes/abajo_r1_c4.gif"><img src="../imagenes/abajo_r1_c3.gif" width="12" height="28"></td>
              </tr>
              <tr> 
                <td height="8" background="../imagenes/abajo_r2_c2.gif"></td>
              </tr>
            </table></td>
          <td width="7" height="28"><img src="../imagenes/abajo_r1_c5.gif" width="7" height="28"></td>
        </tr>
      </table>
      <br> </td>
  </tr>
</table>
</body>
</html>
