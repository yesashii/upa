<!-- #include file = "../biblioteca/_conexion.asp" -->
<!-- #include file = "../biblioteca/_negocio.asp" -->

<%
nombre= request.querystring("nombre_asig")
codigo= request.QueryString("codigo_asig")
plan= request.querystring("plan")
carr= request.QueryString("carr")
espe= request.querystring("espe")

if nombre <> "" or codigo <> "" then 
	pasa = false
else 
	pasa = true
end if

set pagina = new CPagina
pagina.Titulo = "Agregar Asignatura "
set botonera =  new CFormulario
botonera.carga_parametros "adm_mallas_curriculares.xml", "btn_agregar_asig"

'---------------------------------------------------------------------------------------------------
set conectar = new CConexion
conectar.Inicializar "upacifico"

set negocio = new CNegocio
negocio.Inicializa conectar

'---------------------------------------------------------------------------------------------------
set formulario = new cformulario
formulario.carga_parametros "adm_mallas_curriculares.xml", "form_agrega_asig"
formulario.inicializar conectar


if codigo ="" and nombre="" then
codigo="NADA"
end if
consulta = "SELECT distinct a.ASIG_CCOD, a.ASIG_TDESC " & _
		   " FROM asignaturas a " & _
           " WHERE " & _
		   "  (a.asig_ccod like '%" & codigo & "%' or '" & codigo & "' is null )" & _
		   " and ( a.asig_tdesc like '%" & nombre & "%' or '" & nombre & "%' is null )" & _
		   " order by asig_tdesc" 

texto = "Para buscar asignaturas ingrese un criterio de búsqueda y presione el botón buscar"
formulario.consultar consulta


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
function enviar(formulario){
	formulario.action = 'agregar_asig.asp';
  	if(preValidaFormulario(formulario)){	
	formulario.submit();
	}
 }
function agrega_asig(formulario){
if ( formulario.v_nivel.value!="" ) {
	formulario.action="agregar_asig_malla.asp";
	formulario.submit();
   }
else
  {alert('Ingrese Nivel Respectivo a cada Asignaturas.');
   formulario.v_nivel.focus();}
}


</script>

</head>
<body bgcolor="#CC6600" leftmargin="0" topmargin="0" marginwidth="0" marginheight="0" onLoad="MM_preloadImages('../imagenes/botones/buscar_f2.gif','../images/bot_deshabilitar_f2.gif','../images/agregar2_f2_p.gif','im&amp;#225;genes/marco1_r3_c2_f2.gif');MM_preloadImages('im&amp;#225;genes/marco1_r3_c4_f2.gif');MM_preloadImages('im&amp;#225;genes/marco1_r3_c6_f2.gif');MM_preloadImages('im&amp;#225;genes/marco1_r3_c8_f2.gif');MM_preloadImages('../imagenes/botones/cargar_f2.gif','../imagenes/botones/continuar_f2.gif')" onBlur="revisaVentana();">
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
            <td><form name="buscador" method="get">
              <table width="100%" border="0" cellspacing="0" cellpadding="0">
                              <tr> 
                                <td width="43%" height="29" nowrap> 
                                  <div align="center"><font face="Verdana, Arial, Helvetica, sans-serif" size="1"> <br>
                                    <input type="text" name="codigo_asig" size="20" maxlength="20" onKeyDown="return bloquearTeclas(event.keyCode,this)" onKeyUp="this.value=this.value.toUpperCase()" ID="TO-S" >
                                    <input type="hidden" name="asig_ccod" >
									<input type="hidden" name="espe"  value="<%=espe%>">
									<input type="hidden" name="carr"  value="<%=carr%>">
									<input type="hidden" name="plan"  value="<%=plan%>">
                                    <br>
                                    Código Asignatura </font></div></td>
                                <td width="34%"> <div align="center"><font face="Verdana, Arial, Helvetica, sans-serif" size="1"> 
                                    <input type="text" name="nombre_asig" size="20" maxlength="20" onKeyDown="return bloquearTeclas(event.keyCode,this)" onKeyUp="this.value=this.value.toUpperCase()" ID="TO-s" >
                                    <br>
                                    Nombre Asignatura</font></div></td>
                                <td width="21%"> <div align="left"><font face="Verdana, Arial, Helvetica, sans-serif" size="1"> 
                                    <%botonera.dibujaboton "buscar"%>
                                    <br>
                                </font></div></td>
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
            <td><br><%pagina.DibujarSubtitulo "Lista  Asignaturas "%>
              <form name="editar" method="post">
                <%if pasa  then 
				       response.Write(texto)
					  else%>
                <table>
                  <tr>
                    <td nowrap>Resultado de la b&uacute;squeda </td>
                  </tr>
                </table>
                <%if nombre <>""  then%>
                <table>
                  <tr>
                    <td>Nombre Asignatura</td>
                    <td><strong>
                      <%response.write(nombre)%>
                    </strong></td>
                  </tr>
                </table>
                <%end if %>
                <%if codigo <>""  then%>
                <table>
                  <tr>
                    <td>C&oacute;digo Asignatura</td>
                    <td><strong>
                      <%response.write(codigo)%>
                    </strong></td>
                  </tr>
                </table>
                
                    <% end if %>
                    <%end if %>
                    
                <table width="90%" align="center" cellpadding="0" cellspacing="0">
                  <tr>
                    <td height="13">
                      <div align="center"><strong><font face="Verdana, Arial, Helvetica, sans-serif">LISTADO</font></strong></div></td>
                  </tr>
                  <tr>
                    <td height="21" align="right">
                      <div align="left"> NIVEL
                          <input name="v_nivel" type="text" id="v_nivel" size="1" maxlength="2">
                          <input type="hidden" name="plan"  value="<%=plan%>">
                    </div></td>
                  </tr>
                  <tr>
                    <td align="right"> <strong>P&aacute;ginas&nbsp;:&nbsp;</strong>&nbsp;
                        <%formulario.accesoPagina%>
                    </td>
                  </tr>
                  <tr>
                    <td align="right">&nbsp;</td>
                  </tr>
                  <tr>
                    <td align="left" valign="top">
                      <div align="center">
                        <%formulario.dibujaTabla()%>
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
            <td width="38%" height="20"><div align="center">
              <table width="90%"  border="0" cellspacing="0" cellpadding="0">
                <tr>
                  <td><div align="center"><font face="Verdana, Arial, Helvetica, sans-serif" size="1">
                    <%botonera.dibujaboton "AGREGAR"%>
                  </font>
                  </div></td>
                  <td><div align="center"><font face="Verdana, Arial, Helvetica, sans-serif" size="1">
                    <%botonera.dibujaboton "SALIR"%>
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
