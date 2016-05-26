<!-- #include file = "../biblioteca/_conexion.asp" -->
<!-- #include file = "../biblioteca/_negocio.asp" -->

<%
hora_ccod = request("hora_ccod")

set pagina = new CPagina
pagina.Titulo = "Mantenedor De Horarios Sedes "
set botonera =  new CFormulario
botonera.carga_parametros "mantenedor_horarios_sedes.xml", "btn_editar_horarios"

'---------------------------------------------------------------------------------------------------
set conectar = new CConexion
conectar.Inicializar "upacifico"

set negocio = new CNegocio
negocio.Inicializa conectar

sede_ccod = negocio.obtenersede

set f_horarios	 		=	new cformulario
f_horarios.carga_parametros 		"mantenedor_horarios_sedes.xml", "agregar_horario"
f_horarios.inicializar		conectar

Sql_horarios =  " select a.hora_ccod,b.hora_tdesc, " &vbCrlf & _
				" cast(DATEPART(hour,a.hora_hinicio)as varchar)+':'+cast(DATEPART(minute,a.hora_hinicio) as varchar) as hora_hinicio, " &vbCrlf & _
				" cast(DATEPART(hour,a.hora_htermino)as varchar)+':'+cast(DATEPART(minute,a.hora_htermino) as varchar)as hora_htermino " &vbCrlf & _
				" from  " &vbCrlf & _
				" horarios_sedes a, horarios b " &vbCrlf & _
				" where a.hora_ccod = b.hora_ccod " &vbCrlf & _
				" and cast(a.hora_ccod as varchar) = '"&hora_ccod&"'" &vbCrlf & _
				" and cast(a.sede_ccod as varchar) = '"&sede_ccod&"'"

'response.Write("<pre>"&Sql_horarios&"</pre>")
'response.End()
f_horarios.consultar 		Sql_horarios 
f_horarios.siguientef
if hora_ccod="" or isnull(hora_ccod) or isempty(hora_ccod) then
	f_horarios.agregaCampoParam "hora_ccod","destino", "(select hora_ccod,hora_tdesc  " & _
													   " from horarios  " &_
													   " where hora_ccod not in (select b.hora_ccod " & _
													   " 						 from horarios a,horarios_sedes b " & _
													   "						 where a.hora_ccod = b.hora_ccod " & _
													   "                         and cast(b.sede_ccod as varchar)='"&sede_ccod&"')) a "
'response.Write("entre")
'response.End()
else
	f_horarios.agregaCampoParam "hora_ccod","destino", "(select hora_ccod,hora_tdesc  " & _
													   " from horarios  " &_
													   " where hora_ccod not in (select b.hora_ccod " & _
													   " 						 from horarios a,horarios_sedes b " & _
													   "						 where a.hora_ccod = b.hora_ccod " & _
													   "                         and cast(b.sede_ccod as varchar)='"&sede_ccod&"' " & _
													   "                         and cast(b.hora_ccod as varchar) <>'"&hora_ccod&"')) a "
end if
													   
'---------------------------------------------------------------------------------------------------
'response.Write("Hora " &hora_ccod)

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

<script language="JavaScript">

function InicioPagina(formulario){
hora ='<%=hora_ccod%>'
hora_tdesc="<%=conectar.consultauno("select hora_tdesc from horarios where cast(hora_ccod as varchar) ='"&hora_ccod&"'")%>";

	if (hora!=""){

		formulario.elements["ag_s[0][hora_ccod]"].length = 0;
		op = document.createElement("OPTION");
		op.value = hora;
		op.text = hora_tdesc;
		formulario.elements["ag_s[0][hora_ccod]"].add(op)
	}	
}
function cerrar() {
	window.opener.location.reload();
	window.close();
}
function agrega_horario(formulario){
	formulario.action = 'proc_horario.asp';
  	if(preValidaFormulario(formulario)){	
		if (verhora(formulario)){
			formulario.submit();
		}
		else {
		alert("Debe Ingresar Un Formato De Hora Correcto\nO La Hora De Inicio Debe Ser Menor Que La Hora De Termino")
		}
	}
 }
 function verhora(formulario){
 cadena_horainicio  = formulario.elements["ag_s[0][hora_hinicio]"].value.split(":");
 cadena_horatermino = formulario.elements["ag_s[0][hora_htermino]"].value.split(":");
 hora_inicio = cadena_horainicio[0];
 minutos_inicio = cadena_horainicio[1];
 hora_termino = cadena_horatermino[0];
 minutos_termino = cadena_horatermino[1];
/* alert(hora_inicio)
 alert(minutos_inicio)
 alert(hora_termino)
 alert(minutos_termino)*/
  if(isDigit(hora_inicio) && isDigit(minutos_inicio) && isDigit(hora_termino) && isDigit(minutos_termino)){
  	  if (hora_inicio<= 24 && hora_termino<=24 && minutos_inicio<=59 && minutos_termino<59) {
  		 if(hora_termino>hora_inicio){
			return true;		
		}
		if(hora_termino<hora_inicio){
			return false;		
		}
		if(hora_termino==hora_inicio){	  
			if(minutos_termino>minutos_inicio){
				return true;
			} 
			else{
				return false;
			}
		}
    }
	else{
		return false;
	}
 }
 else{
 	return false;
 }

 }
</script>

<style type="text/css">
<!--
.Estilo1 {color: #FF0000}
-->
</style>
</head>
<body bgcolor="#D8D8DE" leftmargin="0" topmargin="0" marginwidth="0" marginheight="0" onLoad="InicioPagina(document.editar);MM_preloadImages('../imagenes/botones/buscar_f2.gif','../images/bot_deshabilitar_f2.gif','../images/agregar2_f2_p.gif','../__base/im&#225;genes/marco1_r3_c2_f2.gif');MM_preloadImages('../__base/im&#225;genes/marco1_r3_c4_f2.gif');MM_preloadImages('../__base/im&#225;genes/marco1_r3_c6_f2.gif');MM_preloadImages('../__base/im&#225;genes/marco1_r3_c8_f2.gif');MM_preloadImages('../imagenes/botones/cargar_f2.gif','../imagenes/botones/continuar_f2.gif')" onBlur="revisaVentana();">
<table width="100%" height="100%" border="0" align="center" cellpadding="0" cellspacing="0">
  <tr>
    <td valign="top" bgcolor="#EAEAEA">	<br>
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
            <td><%pagina.DibujarLenguetas Array("Mantenedor De Horarios"), 1 %></td>
          </tr>
          <tr>
            <td height="2" background="../imagenes/top_r3_c2.gif"></td>
          </tr>
          <tr>
            <td><br><%pagina.DibujarSubtitulo "Datos Horario"%>
(<span class="Estilo1">*</span>) 
                            Campos Obligatorios.
<form name="editar" method="post">
<table width="95%" align="center" cellpadding="0" cellspacing="0">
                        <tr> 
                          <td colspan="6"></td>
                        </tr>
                        <tr> 
                          <td colspan="6" align="center">&nbsp;</td>
                        </tr>
                        <tr> 
                          <td colspan="6" align="center">&nbsp;</td>
                        </tr>
                        <tr align="center"> 
                          <td width="23%" align="left" valign="top" nowrap>(<span class="Estilo1">*</span>)<strong> 
                            Bloque Horario </strong></td>
                          <td width="24%" align="left" valign="top" nowrap> : 
                            <%f_horarios.dibujacampo("hora_ccod")%> </td>
                          <td width="53%" align="left" valign="top" nowrap>&nbsp; </td>
                        </tr>
                        <tr align="center"> 
                          <td align="left" valign="top" nowrap> (<span class="Estilo1">*</span>)<strong> 
                            Hora Inicio </strong> </td>
                          <td align="left" valign="top" nowrap>: 
                            <%f_horarios.dibujacampo("hora_hinicio")%> 
                            (HH:MM) </td>
                          <td valign="top" nowrap>&nbsp; </td>
                        </tr>
                        <tr align="center"> 
                          <td align="left" valign="top" nowrap>(<span class="Estilo1">*</span>)<strong> Hora Termino </strong></td>
                          <td align="left" valign="top" nowrap>: 
                            <%f_horarios.dibujacampo("hora_htermino")%>
                            (HH:MM)</td>
                          <td valign="top" nowrap>&nbsp;</td>
                        </tr>
                        <tr align="center"> 
                          <td align="left" valign="top" nowrap>&nbsp;</td>
                          <td align="left" valign="top" nowrap>&nbsp; </td>
                          <td valign="top" nowrap>&nbsp;</td>
                        </tr>
                        <tr align="center"> 
                          <td align="left" valign="top" nowrap>&nbsp;</td>
                          <td align="left" valign="top" nowrap>&nbsp; </td>
                          <td valign="top" nowrap>&nbsp;</td>
                        </tr>
                        <tr align="center"> 
                          <td align="left" valign="top" nowrap>&nbsp;</td>
                          <td align="left" valign="top" nowrap>&nbsp; </td>
                          <td valign="top" nowrap><input type="hidden" name="sala" value="<%=sala_ccod%>"></td>
                        </tr>
                        <tr> 
                          <td colspan="6" align="center" valign="top"> </td>
                        </tr>
                        <tr> 
                          <td colspan="6" align="center" valign="top"></td>
                        </tr>
                    </table>
                </form></td></tr>
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
                  <td><div align="center"><font face="Verdana, Arial, Helvetica, sans-serif" size="1"><%botonera.dibujaboton "agregar"%>
                  </font>
                  </div></td>
                  <td><div align="center"><font face="Verdana, Arial, Helvetica, sans-serif" size="1"><%botonera.dibujaboton "salir"%>
                  </font> </div></td>
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
	<br>
	<br>
	</td>
  </tr>  
</table>
</body>
</html>
