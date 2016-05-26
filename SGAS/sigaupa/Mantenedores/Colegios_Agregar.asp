<!-- #include file = "../biblioteca/_conexion.asp" -->
<!-- #include file = "../biblioteca/_negocio.asp" -->

<%
set pagina = new CPagina

cole_ccod = request.querystring("cole_ccod")


if cole_ccod <> "" then
   pagina.Titulo = "Modificar Colegio"
else
   pagina.Titulo = "Agregar Colegio"
end if

'---------------------------------------------------------------------------------------------------
set conexion = new CConexion
conexion.Inicializar "upacifico"

set negocio = new CNegocio
negocio.Inicializa conexion

ciud_ccod = conexion.consultaUno("Select ciud_ccod from colegios where cast(cole_ccod as varchar)='"&cole_ccod&"'")
regi_ccod = conexion.consultaUno("Select regi_ccod from colegios a, ciudades b where cast(cole_ccod as varchar)='"&cole_ccod&"' and a.ciud_ccod=b.ciud_ccod ")
ciud_tcomuna = conexion.consultaUno("Select ciud_tcomuna from colegios a, ciudades b where cast(cole_ccod as varchar)='"&cole_ccod&"' and a.ciud_ccod=b.ciud_ccod ")
'----------------------------------------------------------------
set botonera = new CFormulario
botonera.Carga_Parametros "Mantenedor_colegios.xml", "botonera"
'----------------------------------------------------------------
Ciudad = conexion.consultauno("SELECT ciud_tcomuna FROM ciudades WHERE cast(ciud_ccod as varchar)= '" & ciud_ccod & "'")
region = conexion.consultauno("SELECT regi_tdesc FROM regiones WHERE cast(regi_ccod as varchar) = '" & regi_ccod & "'")

'----------------------------------------------------------------
set f_nueva = new CFormulario
f_nueva.Carga_Parametros "mantenedor_colegios.xml", "f_nuevo"
f_nueva.Inicializar conexion

cole_tdesc = conexion.consultaUno("Select cole_tdesc from colegios where cast(cole_ccod as varchar)='"&cole_ccod&"'")
tcol_ccod = conexion.consultaUno("Select tcol_ccod from colegios where cast(cole_ccod as varchar)='"&cole_ccod&"'")
cole_tdirector = conexion.consultaUno("Select cole_tdirector from colegios where cast(cole_ccod as varchar)='"&cole_ccod&"'")
cole_tdireccion = conexion.consultaUno("Select cole_tdireccion from colegios where cast(cole_ccod as varchar)='"&cole_ccod&"'")
cole_tfono = conexion.consultaUno("Select cole_tfono from colegios where cast(cole_ccod as varchar)='"&cole_ccod&"'")
cole_tcelular = conexion.consultaUno("Select cole_tcelular from colegios where cast(cole_ccod as varchar)='"&cole_ccod&"'")
cole_temail = conexion.consultaUno("Select cole_temail from colegios where cast(cole_ccod as varchar)='"&cole_ccod&"'")
cole_tlocalidad = conexion.consultaUno("Select cole_tlocalidad from colegios where cast(cole_ccod as varchar)='"&cole_ccod&"'")
cole_trbd = conexion.consultaUno("Select cole_trbd from colegios where cast(cole_ccod as varchar)='"&cole_ccod&"'")
cole_tarea = conexion.consultaUno("Select isnull(cole_tarea,1) from colegios where cast(cole_ccod as varchar)='"&cole_ccod&"'")

consulta= " Select '"&regi_ccod&"' as regi_ccod, '"&ciud_tcomuna&"' as ciud_tcomuna, '"&ciud_ccod&"' as ciud_ccod,"&_
		  " '"&cole_ccod&"' as cole_ccod, '"&cole_tdesc&"' as cole_tdesc, '"&tcol_ccod&"' as tcol_ccod,"&_
		  " '"&cole_tlocalidad&"' as cole_tlocalidad, '"&cole_tdireccion&"' as cole_tdireccion, '"&cole_tfono&"' as cole_tfono,"&_
		  " '"&cole_trbd&"' as cole_trbd, '"&cole_tarea&"' as cole_tarea, '"&cole_temail&"' as cole_temail"
f_nueva.consultar consulta

consulta =  " select a.regi_tdesc,a.regi_ccod,b.ciud_ccod,b.ciud_tcomuna, b.ciud_tdesc " & vbCrLf & _
			" from regiones a, ciudades b " & vbCrLf & _
			" where a.regi_ccod=b.regi_ccod " & vbCrLf & _
			" order by a.regi_ccod,ciud_tcomuna,ciud_tdesc " 

'response.Write("<pre>"&consulta&"</pre>")	
f_nueva.inicializaListaDependiente "lBusqueda", consulta
 
'if cole_ccod = "" then
'   consulta = "select '" & ciud_ccod & "' as ciud_ccod , '' as ciud_tdesc, '' as tcol_ccod"
'   f_nueva.Consultar consulta
 '  fecha_sistema = conexion.consultauno("select convert(varchar,getdate(),103)")
   'response.write(fecha_sistema)
'   f_nueva.AgregaCampoCons "plan_fcreacion", fecha_sistema
'else
'   consulta ="select cole_ccod,ciud_ccod,cole_tdesc,tcol_ccod" & vbCrlf & _
'				"from colegios" & vbCrlf & _
'				"where cast(cole_ccod as varchar) ='" & cole_ccod & "'"
'   f_nueva.Consultar consulta
'end if
f_nueva.Siguiente
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
<% f_nueva.generaJS %>
</head>
<body bgcolor="#D8D8DE" leftmargin="0" topmargin="0" marginwidth="0" marginheight="0" onLoad="MM_preloadImages('../imagenes/botones/buscar_f2.gif','../images/bot_deshabilitar_f2.gif','../images/agregar2_f2_p.gif','im&amp;#225;genes/marco1_r3_c2_f2.gif');MM_preloadImages('im&amp;#225;genes/marco1_r3_c4_f2.gif');MM_preloadImages('im&amp;#225;genes/marco1_r3_c6_f2.gif');MM_preloadImages('im&amp;#225;genes/marco1_r3_c8_f2.gif');MM_preloadImages('../imagenes/botones/cargar_f2.gif','../imagenes/botones/continuar_f2.gif')" onBlur="revisaVentana();">
<table width="550" height="100%" border="0" align="center" cellpadding="0" cellspacing="0">
  
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
                <td><%pagina.DibujarLenguetas Array("Agregar Especialidad"), 1 %></td>
              </tr>
              <tr> 
                <td height="2" background="../imagenes/top_r3_c2.gif"></td>
              </tr>
              <tr> 
                <td><div align="center"><br>
                    <%pagina.DibujarTituloPagina%>
                    <br>
					</div>
				   
                  <form name="edicion">
                    <table width="98%"  border="0" align="center" cellpadding="0" cellspacing="0">
                      <tr> 
                        <td>
                          <table width="100%" border="0">
						    <%if cole_ccod <> "" then %>
							<tr> 
                              <td><strong>Cód.Interno</strong></td>
                              <td><div align="center">:</div></td>
                              <td colspan="3"><font color="#990000" size="3"><strong><%=cole_ccod%></strong></font>(Entregar a Informática)</td>
                            </tr>
							<%end if%>
							 <tr> 
                                <td width="27%"><font color="#CC3300">*</font> Regi&oacute;n</td>
								<td width="2%"> <div align="center">:</div> </td>
								<td><% f_nueva.dibujaCampoLista "lBusqueda", "regi_ccod"%></td>
                              </tr>
							  <tr> 
                                <td width="27%"><font color="#CC3300">*</font> Ciudad</td>
								<td width="2%"> <div align="center">:</div> </td>
								<td><% f_nueva.dibujaCampoLista "lBusqueda", "ciud_tcomuna"%></td>
                              </tr>
							  <tr> 
                                <td width="27%"><font color="#CC3300">*</font> Comuna</td>
								<td width="2%"> <div align="center">:</div> </td>
								<td><% f_nueva.dibujaCampoLista "lBusqueda", "ciud_ccod"%></td>
                              </tr>
							  <tr> 
                                <td width="27%"><font color="#CC3300">*</font> Localidad</td>
								<td width="2%"> <div align="center">:</div> </td>
								<td><% f_nueva.DibujaCampo "cole_tlocalidad"%></td>
                              </tr>
                            <tr> 
                              <td><font color="#CC3300">*</font> Establecimiento</td>
                              <td><div align="center">:</div></td>
                              <td colspan="3"> <% f_nueva.DibujaCampo "cole_tdesc"%></td>
                            </tr>
							<tr> 
                              <td><font color="#CC3300">*</font> RBD</td>
                              <td><div align="center">:</div></td>
                              <td colspan="3"> <% f_nueva.DibujaCampo "cole_trbd"%></td>
                            </tr>
							<tr> 
                              <td><font color="#CC3300">*</font> Dependencia</td>
                              <td><div align="center">:</div></td>
                              <td colspan="3"> <% f_nueva.DibujaCampo "tcol_ccod"%></td>
                            </tr>
							<tr> 
                              <td><font color="#CC3300">*</font> Área</td>
                              <td><div align="center">:</div></td>
                              <td colspan="3"> <% f_nueva.DibujaCampo "cole_tarea"%></td>
                            </tr>
							  <tr> 
                                <td width="27%"> <div align="left">Direcci&oacute;n Local</div></td>
								<td width="2%"> <div align="center">:</div> </td>
								<td><% f_nueva.dibujaCampo "cole_tdireccion"%></td>
                              </tr>
							  <tr> 
                                <td width="27%"> <div align="left">Tel&eacute;fono</div></td>
								<td width="2%"> <div align="center">:</div> </td>
								<td><% f_nueva.dibujaCampo "cole_tfono"%></td>
                              </tr>
							  <tr> 
                                <td width="27%"> <div align="left">E-mail</div></td>
								<td width="2%"> <div align="center">:</div> </td>
								<td><% f_nueva.dibujaCampo "cole_temail"%></td>
                              </tr>
							  <tr> 
	                              <td colspan="3"><input type="hidden" name="colegios[0][actualizado]" value="SI"><div align="right"><font color="#CC3300">*</font>Campos Obligatorios</div></td>
                              </tr>
                          </table>
                          </td>
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
                <td width="19%" height="20"><div align="center"> 
                    <table width="90%"  border="0" cellspacing="0" cellpadding="0">
                      <tr> 
                        <td width="33%"><div align="center">
                            <%
							  if cole_ccod <> "" then
							     botonera.agregaBotonParam "guardar_nueva", "url", "Proc_colegios_Agregar.asp?ciud_ccod=" & ciud_ccod & "&cole_ccod=" & cole_ccod & "&tcol_ccod=" & tcol_ccod & "&cole_tdesc=" & cole_tdesc
							  else
  							     botonera.agregaBotonParam "guardar_nueva", "url", "Proc_colegios_Agregar.asp?ciud_ccod=" & ciud_ccod & "&tcol_ccod=" & tcol_ccod & "&cole_tdesc=" & cole_tdesc
							  end if
							  botonera.dibujaBoton "guardar_nueva" %>
                          </div></td>
                        <td width="33%"><div align="center">
                            <%botonera.dibujaBoton "cancelar" %>
                          </div></td>
						<td width="34%"><div align="center">
                            <%    if ciud_ccod <> "" and cole_ccod <> ""  then
									botonera.agregaBotonParam "excel2","url","personas_colegios.asp?ciud_ccod="&ciud_ccod&"&cole_ccod="&cole_ccod
									botonera.DibujaBoton "excel2"
								  end if
							 %>
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
