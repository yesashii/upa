 <!-- #include file = "../biblioteca/_conexion.asp" -->
<!-- #include file = "../biblioteca/_negocio.asp" -->

<%
nombre = request.querystring("nombre_asig")
codigo = request.QueryString("codigo_asig")
plan = request.querystring("plan")
carr = request.QueryString("carr")
espe = request.querystring("espe")

'response.Write("PLAN: " & plan & "<BR><BR>")

if nombre <> "" or codigo <> "" then 
	pasa = false
else 
	pasa = true
end if

set pagina = new CPagina
pagina.Titulo = "Agregar Asignatura"
set botonera =  new CFormulario
botonera.carga_parametros "adm_mallas_curriculares.xml", "btn_agregar_asig"
'---------------------------------------------------------------------------------------------------
set conectar = new CConexion
conectar.Inicializar "desauas"

set negocio = new CNegocio
negocio.Inicializa conectar

'---------------------------------------------------------------------------------------------------
set formulario = new cformulario
formulario.carga_parametros "adm_mallas_curriculares.xml", "form_agrega_asig"
formulario.inicializar conectar


if codigo ="" and nombre="" then
codigo="    "
end if
consulta = "SELECT distinct a.ASIG_CCOD, a.ASIG_TDESC " & _
		   " FROM asignaturas a " & _
           " WHERE " & _
		   "  (a.asig_ccod = '" & codigo & "' or '" & codigo & "' is null )" & _
		   " and ( a.asig_tdesc like '" & nombre & "%' or '" & nombre & "%' is null )" & _
		   " order by asig_tdesc" 

texto = "Para buscar asignaturas ingrese un criterio de búsqueda y presione el botón buscar"
formulario.consultar consulta



'-----------------------------------------------------------------------
'-----------------------------------------------------------------------
set f_consulta = new CFormulario
f_consulta.Carga_Parametros "adm_mallas_curriculares.xml", "f_agregar_asignatura"
f_consulta.inicializar conectar
sql = "select '" & plan & "'as plan, '3.0' as mall_nota_presentacion, '60' as mall_porcentaje_presentacion, '2' as mall_nevaluacion_minima, '50' as mall_porcentaje_asistencia from dual"
f_consulta.consultar sql
f_consulta.siguiente
'-----------------------------------------------------------------------


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
function salir(){
	self.opener.opener.location.reload();
	window.close();
}

function agrega_asig(formulario)
{
 if ( formulario.v_nivel.value!="" )
  {
	if (preValidaFormulario(formulario))
	{
	   //formulario.action="agregar_asig_malla.asp?mall_ccod=<%=mall_ccod%>";
	   //formulario.method="POST";
	   //formulario.submit();
	   //alert("TODO OK");
	}
  }
else
  {alert('Ingrese el Nivel, a la Asignatura Seleccionada');
   formulario.v_nivel.focus();}
}


</script>

</head>
<body bgcolor="#D8D8DE" leftmargin="0" topmargin="0" marginwidth="0" marginheight="0" onLoad="MM_preloadImages('../imagenes/botones/buscar_f2.gif','../images/bot_deshabilitar_f2.gif','../images/agregar2_f2_p.gif','../__base/im&#225;genes/marco1_r3_c2_f2.gif');MM_preloadImages('../__base/im&#225;genes/marco1_r3_c4_f2.gif');MM_preloadImages('../__base/im&#225;genes/marco1_r3_c6_f2.gif');MM_preloadImages('../__base/im&#225;genes/marco1_r3_c8_f2.gif');MM_preloadImages('../imagenes/botones/cargar_f2.gif','../imagenes/botones/continuar_f2.gif')" onBlur="revisaVentana();">
<table width="100%" height="100%" border="0" align="center" cellpadding="0" cellspacing="0">
  <tr>
    <td valign="top" bgcolor="#EAEAEA">	<br><table width="90%"  border="0" align="center" cellpadding="0" cellspacing="0" bgcolor="#D8D8DE">
      <tr>
        <td width="9" height="8"><img name="top_r1_c1" src="../imagenes/top_r1_c1.gif" width="9" height="8" border="0" alt=""></td>
        <td height="8" background="../imagenes/top_r1_c2.gif"></td>
        <td width="7" height="8"><img name="top_r1_c3" src="../imagenes/top_r1_c3.gif" width="7" height="8" border="0" alt=""></td>
      </tr>
      <tr>
        <td width="9" background="../imagenes/izq.gif"></td>
        <td><table width="100%"  border="0" cellspacing="0" cellpadding="0">
          <tr>
            <td><%pagina.DibujarLenguetas Array("Buscador"), 1 %></td>
          </tr>
          <tr>
            <td height="2" background="../imagenes/top_r3_c2.gif"></td>
          </tr>
          <tr>
            <td><form name="buscador">
                    <table width="100%" border="0" cellspacing="0" cellpadding="0">
                              <tr> 
                                <td width="43%" height="29" nowrap> 
                                  <div align="center">
                            <p>&nbsp;</p>
                            <p><font face="Verdana, Arial, Helvetica, sans-serif" size="1"> 
                              <input type="text" name="codigo_asig" size="20" maxlength="20" onKeyDown="return bloquearTeclas(event.keyCode,this)" onKeyUp="this.value=this.value.toUpperCase()" ID="TO-S" value=<%=codigo%>>
                              <input type="hidden" name="asig_ccod" >
                              <input type="hidden" name="espe"  value="<%=espe%>">
                              <input type="hidden" name="carr"  value="<%=carr%>">
                              <input type="hidden" name="plan"  value="<%=plan%>">
                              <br>
                              Código Asignatura </font></p>
                          </div></td>
                                <td width="34%"> <div align="center">
                            <p>&nbsp;</p>
                            <p><font face="Verdana, Arial, Helvetica, sans-serif" size="1"> 
                              <input type="text" name="nombre_asig" size="20" maxlength="20" onKeyDown="return bloquearTeclas(event.keyCode,this)" onKeyUp="this.value=this.value.toUpperCase()" ID="TO-s" value=<%=nombre%>>
                              <br>
                              Nombre Asignatura</font></p>
                          </div></td>
                                <td width="21%"> <div align="left">
                            <p>&nbsp;</p>
                            <p><font face="Verdana, Arial, Helvetica, sans-serif" size="1">
                              <%botonera.dibujaboton "buscar"%>
                              <br>
                              </font></p>
                          </div></td>
                                <td width="1%"> <div align="center"><font face="Verdana, Arial, Helvetica, sans-serif" size="1"> 
                                    <br>
                                    </font></div></td>
                                <td width="1%"> <div align="center"><font face="Verdana, Arial, Helvetica, sans-serif" size="1"> 
                                    </font></div></td>
                              </tr>
                            </table>
              </form></td>
          </tr>
        </table></td>
        <td width="7" background="../imagenes/der.gif"></td>
      </tr>
      <tr>
        <td width="9" height="13"><img src="../imagenes/base1.gif" width="9" height="13"></td>
        <td height="13" background="../imagenes/base2.gif"></td>
        <td width="7" height="13"><img src="../imagenes/base3.gif" width="7" height="13"></td>
      </tr>
    </table>  <br>
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
            <td><%pagina.DibujarLenguetas Array("Resultado De La Búsqueda"), 1 %></td>
          </tr>
          <tr>
            <td height="2" background="../imagenes/top_r3_c2.gif"></td>
          </tr>
          <tr>
            <td><div align="center"><br>
                    
                    <%pagina.DibujarTituloPagina %><BR>
                    <%pagina.DibujarSubtitulo "Lista  Asignaturas "%>
                  </div>
                  <form name="editar">
                    <table width="90%" align="center" cellpadding="0" cellspacing="0">
                      <tr> 
                        <td height="13" colspan="8"> <div align="center"><strong></strong></div></td>
                      </tr>
                      <tr> 
                        <td height="21" align="right"> <div align="left">Nivel 
                          </div></td>
                        <td align="right"> <div align="center">:</div></td>
                        <td align="right"> <div align="left"> 
                            <%f_consulta.DibujaCampo ("nivel")%>
                            <%f_consulta.DibujaCampo ("plan")%>
                            <!--<input name="v_nivel" type="text" id="v_nivel2" size="1" maxlength="2">
                            <input type="hidden" name="plan2"  value="<%=plan%>">-->
                          </div></td>
                        <td align="right"> <div align="left"> </div></td>
                        <td align="right"><div align="left"></div></td>
                        <td align="right"><div align="left"></div></td>
                      </tr>
                      <tr>
                        <td height="21" align="right"><div align="left">Nota Presentaci&oacute;n</div></td>
                        <td align="right"><div align="center">:</div></td>
                        <td align="right"><div align="left"> 
                            <%f_consulta.DibujaCampo ("mall_nota_presentacion")%>
                          </div></td>
                        <td align="right"><div align="left">% Presentaci&oacute;n</div></td>
                        <td align="right"><div align="left">:</div></td>
                        <td align="right"><div align="left"> 
                            <%f_consulta.DibujaCampo ("mall_porcentaje_presentacion")%>
                          </div></td>
                      </tr>
                      <tr> 
                        <td width="115" height="21" align="right"><div align="left">N&ordm; 
                            Evaluaciones Min.</div></td>
                        <td width="23" align="right"><div align="center">:</div></td>
                        <td width="103" align="right"><div align="left"> 
                            <%f_consulta.DibujaCampo ("mall_nevaluacion_minima")%>
                          </div></td>
                        <td width="109" align="right"><div align="left">% Asistencia</div></td>
                        <td width="17" align="right"><div align="left">:</div></td>
                        <td width="193" align="right"><div align="left"> 
                            <%f_consulta.DibujaCampo ("mall_porcentaje_asistencia")%>
                          </div></td>
                      </tr>
                      <tr> 
                        <td colspan="8" align="right"> <strong>P&aacute;ginas&nbsp;:&nbsp;</strong>&nbsp; 
                          <%formulario.accesoPagina%> </td>
                      </tr>
                      <tr> 
                        <td colspan="8" align="right">&nbsp;</td>
                      </tr>
                      <tr> 
                        <td colspan="8" align="right"> <div align="center"> 
                            <%formulario.dibujaTabla()%>
                          </div></td>
                      </tr>
                      <tr> 
                        <td colspan="8" align="left" valign="top"> <div align="center"> 
                          </div></td>
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
            <td width="24%" height="20"><div align="center">
              <table width="90%"  border="0" cellspacing="0" cellpadding="0">
                <tr>
                  <td width="25%"><div align="center"><font face="Verdana, Arial, Helvetica, sans-serif" size="1">
                    <%
					if formulario.nrofilas > 0 then
					  botonera.agregaBotonParam "AGREGAR", "deshabilitado", "FALSE"
					else
 					  botonera.agregaBotonParam "AGREGAR", "deshabilitado", "TRUE"
					end if
					botonera.agregaBotonParam "AGREGAR", "url", "agregar_asig_malla.asp"
					botonera.dibujaboton "AGREGAR"
					%>
                  </font>
                  </div></td>
                  <td width="60%"><div align="center"><font face="Verdana, Arial, Helvetica, sans-serif" size="1">
                    <%botonera.dibujaboton "SALIR"%>
                  </font> </div></td>
                  <td width="15%"><div align="center"></div></td>
                </tr>
              </table>
            </div></td>
            <td width="76%" rowspan="2" background="../imagenes/abajo_r1_c4.gif"><img src="../imagenes/abajo_r1_c3.gif" width="12" height="28"></td>
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
