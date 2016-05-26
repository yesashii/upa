<!-- #include file = "../biblioteca/_conexion.asp" -->
<!-- #include file = "../biblioteca/_negocio.asp" -->

<%
set pagina = new CPagina
pagina.Titulo = "Editar Acta Convalidación"

'---------------------------------------------------------------------------------------------------
set conexion = new CConexion
conexion.Inicializar "upacifico"

set negocio = new CNegocio
negocio.Inicializa conexion

'---------------------------------------------------------------------------------------------------
'--  RECEPCION DE VARIABLES GET
q_matr_ncorr = Request.QueryString("matr_ncorr")
q_asig_ccod = Request.QueryString("asig_ccod")
q_acon_ncorr = Request.QueryString("acon_ncorr")
'------------------------------------------------------------------------------------------------------------------
set f_consulta = new CFormulario
f_consulta.Carga_Parametros "acta_convalidacion.xml", "consulta"

'-------------------------------------------------------------------------------------------------------------------
consulta = "SELECT a.eres_ccod " & vbCrLf &_
           "FROM resoluciones a, actas_convalidacion b " & vbCrLf &_
		   "WHERE a.reso_ncorr = b.reso_ncorr AND " &_
		   "      cast(b.acon_ncorr as varchar)= '" & q_acon_ncorr &"'"
		   
v_eres_ccod = conexion.ConsultaUno(consulta)

if CInt(v_eres_ccod) = 2 then
	resolucion_abierta = true
else
	resolucion_abierta = false
end if


'-------------------------------------------------------------------------------------------------------------------
set f_datos_alumno = new CFormulario
f_datos_alumno.Carga_Parametros "acta_convalidacion_editar.xml", "datos_alumno"
f_datos_alumno.Inicializar conexion

consulta = "SELECT a.pers_nrut, " & vbCrLf &_
           "       a.pers_xdv, " & vbCrLf &_
		   "       a.pers_tape_paterno, " & vbCrLf &_
		   "       a.pers_tape_materno, " & vbCrLf &_
		   "       a.pers_tnombre, " & vbCrLf &_
		   "       a.pers_tape_paterno + ' ' + a.pers_tape_materno + ' ' + a.pers_tnombre AS nombre_alumno, " & vbCrLf &_
		   "       e.carr_tdesc, " & vbCrLf &_
		   "       d.espe_tdesc, " & vbCrLf &_
		   "       c.plan_ncorrelativo, " & vbCrLf &_
		   "       c.plan_tdesc, " & vbCrLf &_
		   "       c.plan_ccod " & vbCrLf &_
		   "FROM personas a, alumnos b, planes_estudio c, especialidades d, carreras e " & vbCrLf &_
		   "WHERE a.pers_ncorr = b.pers_ncorr AND " & vbCrLf &_
		   "      b.plan_ccod = c.plan_ccod AND " & vbCrLf &_
		   "      c.espe_ccod = d.espe_ccod AND " & vbCrLf &_
		   "      d.carr_ccod = e.carr_ccod AND " & vbCrLf &_
		   "      cast(b.matr_ncorr as varchar)= '" & q_matr_ncorr & "'"
		   
f_datos_alumno.Consultar consulta
f_datos_alumno.Siguiente

v_plan_ccod = f_datos_alumno.ObtenerValor("plan_ccod")


'-------------------------------------------------------------------------------------------------------------------
set f_convalidaciones = new CFormulario
f_convalidaciones.Carga_Parametros "acta_convalidacion_editar.xml", "convalidaciones"
f_convalidaciones.Inicializar conexion

consulta = "SELECT replace(cast(a.conv_nnota as decimal(3,1)),',','.') as conv_nnota, a.*, cast(b.asig_ccod as varchar)+ ' ' + b.asig_tdesc AS desc_asignatura, a.conv_tdocente as profesor " & vbCrLf &_
           "FROM convalidaciones a, asignaturas b " & vbCrLf &_
		   "WHERE a.asig_ccod = b.asig_ccod AND " & vbCrLf &_
		   "      cast(a.matr_ncorr as varchar)= '" & q_matr_ncorr & "' AND " &_
		   "      cast(a.asig_ccod as varchar)= '" & q_asig_ccod & "' AND " &_
		   "      cast(a.acon_ncorr as varchar)= '" & q_acon_ncorr& "'"
		   
		   
f_convalidaciones.Consultar consulta
f_convalidaciones.Siguiente

'------------Se debe buscar el tipo de resolución para ver si se muestra al docente y el campo de reprobado o nop
q_tres_ccod = conexion.consultaUno("select tres_ccod from actas_convalidacion a, resoluciones b where cast(acon_ncorr as varchar)='"&q_acon_ncorr&"' and a.reso_ncorr = b.reso_ncorr")

'----------------------------------------------------------------------------------------------------------------------

'-----------------------------------------------------------------------
set botonera = new CFormulario
botonera.Carga_Parametros "acta_convalidacion_editar.xml", "botonera"
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
<!--
resizeTo(730, 430);


function Salir()
{
	window.close();
}


function ValidaFormEdicion(formulario)
{
	nota = parseFloat(formulario.elements["convalidaciones[0][conv_nnota]"].value);
	
	if ( (nota < 1) || (nota > 7) ) {
		alert('Ingrese una nota válida.');
		formulario.elements["convalidaciones[0][conv_nnota]"].focus();
		formulario.elements["convalidaciones[0][conv_nnota]"].select();
		return false;
    }
	else if ((nota >= 1 ) && ( nota < 4 ) && (document.edicion.elements["reprobada"].checked == false))
	{
		alert("ERROR \nAl parecer esta asignatura esta reprobada,\nhaga el favor de tickear en el cuadro correspondiente");
		document.edicion.elements["reprobada"].focus();
		return false;
	}
	
	return true;
}


function Aceptar(formulario)
{
	if (preValidaFormulario(formulario)) {
	
		if (ValidaFormEdicion(formulario)) {			
			formulario.method = "post";
			formulario.action = "acta_convalidacion_editar_aceptar.asp"
			formulario.submit();
		}
	}
}


function MM_preloadImages() { //v3.0
  var d=document; if(d.images){ if(!d.MM_p) d.MM_p=new Array();
    var i,j=d.MM_p.length,a=MM_preloadImages.arguments; for(i=0; i<a.length; i++)
    if (a[i].indexOf("#")!=0){ d.MM_p[j]=new Image; d.MM_p[j++].src=a[i];}}
}
//-->
</script>


</head>
<body bgcolor="#D8D8DE" leftmargin="0" topmargin="0" marginwidth="0" marginheight="0" onLoad="MM_preloadImages('../imagenes/botones/buscar_f2.gif','../images/bot_deshabilitar_f2.gif','../images/agregar2_f2_p.gif','im&amp;#225;genes/marco1_r3_c2_f2.gif');MM_preloadImages('im&amp;#225;genes/marco1_r3_c4_f2.gif');MM_preloadImages('im&amp;#225;genes/marco1_r3_c6_f2.gif');MM_preloadImages('im&amp;#225;genes/marco1_r3_c8_f2.gif');MM_preloadImages('../imagenes/botones/cargar_f2.gif','../imagenes/botones/continuar_f2.gif')" onBlur="revisaVentana();">
<table width="695" height="107%" border="0" align="center" cellpadding="0" cellspacing="0">
  <tr>
    <td width="751" height="293" valign="top" bgcolor="#EAEAEA"> <br>
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
            <td><div align="center"><br>
              <%pagina.DibujarTituloPagina%><br><BR><BR>
			  <table width="95%" align="center" cellpadding="0" cellspacing="0">
                        <tr> 
                          <td width="13%"><div align="left">Alumno</div></td>
                          <td width="2%"><div align="center">:</div></td>
                          <td width="85%"><b> 
                            <% f_datos_alumno.DibujaCampo("nombre_alumno") %>
                            </b> </td>
                        </tr>
                        <tr> 
                          <td>Carrera</td>
                          <td><div align="center">:</div></td>
                          <td><b> 
                            <% f_datos_alumno.DibujaCampo("carr_tdesc") %>
                            </b></td>
                        </tr>
                        <tr> 
                          <td>Especialidad</td>
                          <td><div align="center">:</div></td>
                          <td><b> 
                            <% f_datos_alumno.DibujaCampo("espe_tdesc") %>
                            </b></td>
                        </tr>
                        <tr>
                          <td>Plan</td>
                          <td><div align="center">:</div></td>
                          <td><b>
                            <% f_datos_alumno.DibujaCampo("plan_tdesc") %>
                            </b></td>
                        </tr>
                        <tr> 
                          <td><div align="left"></div></td>
                          <td><div align="center"></div></td>
                          <td><b> </b> </td>
                        </tr>
                      </table>
                </div>
              <form name="edicion">
                <table width="98%"  border="0" align="center" cellpadding="0" cellspacing="0">
                  <tr>
                    <td><%pagina.DibujarSubtitulo "Edición"%>
                      <br>
					  <table width="95%" border="1" align="center" cellpadding="0" cellspacing="0">
                            <tr> 
                          <td align="left">                             
                            <br>
							<%
							if resolucion_abierta then
							%>
                            <table width="97%" align="center" cellpadding="0" cellspacing="0">
							<%
							f_convalidaciones.DibujaCampo("matr_ncorr")
							f_convalidaciones.DibujaCampo("asig_ccod")
							f_convalidaciones.DibujaCampo("acon_ncorr")
							%>
                              <tr> 
                                <td width="26%"><div align="right"><strong>Asignatura 
                                    a convalidar</strong></div></td>
                                <td width="3%"><div align="center"><strong>:</strong></div></td>
                                <td width="71%"> <%f_convalidaciones.DibujaCampo("desc_asignatura")%> </td>
                              </tr>
                              <tr> 
                                <td><div align="right"><strong>Nota</strong></div></td>
                                <td><div align="center"><strong>:</strong></div></td>
                                <td> <%f_convalidaciones.DibujaCampo("conv_nnota")%> (Ej: 6.5)</td>
                              </tr>
							   <%if q_tres_ccod = "3" or q_tres_ccod= "6" then%>
								  <tr> 
                                    <td><div align="right"><strong>Docente</strong></div></td>
                                    <td><div align="center"><strong>:</strong></div></td>
                                    <td><input type="text" name="profesor" size="30" maxlength="30" value="<%=f_convalidaciones.ObtenerValor("profesor")%>"></td>
                                  </tr>
								  <tr> 
                                    <td><div align="right"><strong>¿Evaluación Reprobada?</strong></div></td>
                                    <td><div align="center"><strong>:</strong></div></td>
                                    <td> <%if f_convalidaciones.ObtenerValor("conv_nnota") <= "4.0" then%>
									     <input type="checkbox" name="reprobada" checked>
										 <%else%>
										 <input type="checkbox" name="reprobada">
										 <%end if%>
								    </td>
                                  </tr>
								<%end if%>
                            </table>
							<%
							else
								Response.Write("<center><b>Esta resolución se encuentra cerrada.</b></center>")
							end if
							%>
                            <br>
                            <br>
                          </td>
                        </tr>
                      </table>					  
					  </td>
                  </tr>
                </table>
                          <br>
            </form></td></tr>
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
                  <td><div align="center">
				  <% if resolucion_abierta then
				       botonera.agregaBotonParam "aceptar", "deshabilitado", "false"
				     else
				       botonera.agregaBotonParam "aceptar", "deshabilitado", "true"					 
					 end if
					 
					 botonera.dibujaBoton "aceptar"
				    %>
				  
				  </div></td>
                  <td><div align="center"><%botonera.dibujaBoton "salir"%></div></td>
                  
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
	
	</td>
  </tr>  
</table>
</body>
</html>
