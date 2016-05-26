<!-- #include file = "../biblioteca/_conexion.asp" -->
<!-- #include file = "../biblioteca/_negocio.asp" -->

<%
set pagina = new CPagina
pagina.Titulo = "Título de la página"
'---------------------------------------------------------------------------------------------------
set conexion = new CConexion
conexion.Inicializar "upacifico"

set negocio = new CNegocio
negocio.Inicializa conexion

'---------------------------------------------------------------------------------------------------
'------------------------------------------------------------------------------------------------------------------
'--  RECEPCION DE VARIABLES GET
q_pers_nrut = Request.QueryString("reso_acon[0][pers_nrut]")
q_pers_xdv = Request.QueryString("reso_acon[0][pers_xdv]")

q_reso_ncorr = Request.QueryString("reso_acon[0][reso_ncorr]")
q_reso_nresolucion = Request.QueryString("reso_acon[0][reso_nresolucion]")
q_tres_ccod = Request.QueryString("reso_acon[0][tres_ccod]")
q_reso_fresolucion = Request.QueryString("reso_acon[0][reso_fresolucion]")
q_acon_tinstitucion = Request.QueryString("reso_acon[0][acon_tinstitucion]")
q_acon_tcarrera = Request.QueryString("reso_acon[0][acon_tcarrera]")
q_acon_ncorr = Request.QueryString("reso_acon[0][acon_ncorr]")
q_acon_nacta = Request.QueryString("reso_acon[0][acon_nacta]")
q_acon_facta = Request.QueryString("reso_acon[0][acon_facta]")

'------------------------------------------------------------------------------------------------------------------
set f_consulta = new CFormulario
f_consulta.Carga_Parametros "acta_convalidacion.xml", "consulta"


'-------------------------------------------------------------------------------------------------------------------
consulta = "SELECT eres_ccod FROM resoluciones WHERE cast(reso_ncorr as varchar)= '" & q_reso_ncorr &"'"
f_consulta.Inicializar conexion
f_consulta.Consultar consulta

if f_consulta.NroFilas > 0 then
	resolucion_existe = true
	
	f_consulta.Siguiente
	
	v_eres_ccod = f_consulta.ObtenerValor("eres_ccod")
	
	if CInt(v_eres_ccod) = 2 then
		resolucion_abierta = true
	else
		resolucion_abierta = false
	end if
else
	resolucion_existe = false
end if


'-------------------------------------------------------------------------
actividad = session("_actividad")
'response.Write("a "&actividad)
if (actividad = "7")  then
	peri_ccod = negocio.obtenerPeriodoAcademico("TOMACARGA")
else
	peri_ccod = negocio.obtenerPeriodoAcademico("CLASES18")
end if

peri_tdesc = conexion.consultaUno("Select peri_tdesc from periodos_Academicos where cast(peri_ccod as varchar)='"&peri_ccod&"'")
'---------------------------------------------------------------------------------------



set fc_datos_alumno = new CFormulario
fc_datos_alumno.Carga_Parametros "acta_convalidacion.xml", "consulta"
fc_datos_alumno.Inicializar conexion


consulta = "SELECT a.pers_nrut, " & vbCrLf &_
           "       a.pers_xdv, " & vbCrLf &_
		   "       a.pers_tape_paterno, " & vbCrLf &_
		   "       a.pers_tape_materno, " & vbCrLf &_
		   "       a.pers_tnombre, " & vbCrLf &_
		   "       a.pers_tape_paterno + ' ' + a.pers_tape_materno + ' ' + a.pers_tnombre AS nombre_alumno, " & vbCrLf &_
		   "       f.carr_tdesc, " & vbCrLf &_
		   "       e.espe_tdesc, " & vbCrLf &_
		   "       d.plan_ncorrelativo, " & vbCrLf &_
		   "       d.plan_tdesc, " & vbCrLf &_
		   "       d.plan_ccod, " & vbCrLf &_
		   "       b.matr_ncorr, "  & vbCrLf &_
		   "       a.pers_ncorr "  & vbCrLf &_
		   "FROM personas a, alumnos b, ofertas_academicas c, planes_estudio d, especialidades e, carreras f " & vbCrLf &_
		   "WHERE a.pers_ncorr = b.pers_ncorr AND " & vbCrLf &_
		   "      b.ofer_ncorr = c.ofer_ncorr AND " & vbCrLf &_
		   "      b.plan_ccod = d.plan_ccod AND " & vbCrLf &_
		   "      d.espe_ccod = e.espe_ccod AND " & vbCrLf &_
		   "      e.carr_ccod = f.carr_ccod AND "  & vbCrLf &_
		   "      b.emat_ccod = 1 AND " & vbCrLf &_
		   "      cast(a.pers_nrut as varchar)= '" & q_pers_nrut & "' AND " & vbCrLf &_
		   "      cast(a.pers_xdv as varchar)= '" & q_pers_xdv & "' AND " & vbCrLf &_
		   "      cast(c.peri_ccod as varchar)= '" & peri_ccod & "'"
		   
	
fc_datos_alumno.Consultar consulta

v_plan_ccod = 0

if fc_datos_alumno.NroFilas > 0 then
	alumno_matriculado = true
	
	fc_datos_alumno.Siguiente
	v_plan_ccod = fc_datos_alumno.ObtenerValor("plan_ccod")
	v_matr_ncorr = fc_datos_alumno.ObtenerValor("matr_ncorr")
	v_pers_ncorr = fc_datos_alumno.ObtenerValor("pers_ncorr")
	
	
	set f_convalidaciones = new CFormulario
	f_convalidaciones.Carga_Parametros "acta_convalidacion_agregar.xml", "convalidaciones"
	f_convalidaciones.Inicializar conexion
	
		   
	c_destino = "(SELECT a.nive_ccod, b.asig_ccod, b.asig_tdesc, b.asig_nhoras, cast(b.asig_ccod as varchar)+ ' ' +b.asig_tdesc AS desc_asignatura " & vbCrLf &_
	            "FROM malla_curricular a, asignaturas b " & vbCrLf &_
				"WHERE a.asig_ccod = b.asig_ccod AND " & vbCrLf &_
				"      cast(a.plan_ccod as varchar)= '" & v_plan_ccod & "' AND " & vbCrLf &_
				"      a.asig_ccod NOT IN (SELECT asig_ccod " & vbCrLf &_
				"                          FROM convalidaciones " & vbCrLf &_
				"                          WHERE cast(matr_ncorr as varchar)= '" & v_matr_ncorr & "' AND " & vbCrLf &_
				"                                cast(acon_ncorr as varchar)= '" & q_acon_ncorr & "') " & vbCrLf &_
				")t"
				
	f_convalidaciones.AgregaCampoParam "asig_ccod", "destino",  c_destino	
	
	if q_tres_ccod = "7" then
		v_sitf_ccod = "AC"
	else
		v_sitf_ccod = "C"
	end if
	
	consulta = "SELECT " & v_matr_ncorr & " AS matr_ncorr, " & vbCrLf &_
	           "       " & q_acon_ncorr & " AS acon_ncorr, " & vbCrLf &_
	           "       '" & v_sitf_ccod & "' AS sitf_ccod " & vbCrLf 
	           			   

	f_convalidaciones.Consultar consulta
	f_convalidaciones.Siguiente	
		
	'---------------------------------------------------------------------------------------------------------------
	set f_resoluciones = new CFormulario
	f_resoluciones.Carga_Parametros "acta_convalidacion_agregar.xml", "resoluciones"
	f_resoluciones.Inicializar conexion
	
	consulta = "SELECT " & q_reso_ncorr & " AS reso_ncorr, " & vbCrLf &_
	           "       '" & q_reso_nresolucion & "' AS reso_nresolucion, " & vbCrLf &_
			   "       " & q_tres_ccod & " AS tres_ccod, " & vbCrLf &_
			   "       '" & q_reso_fresolucion & "' AS reso_fresolucion, " & vbCrLf &_
			   "       '" & negocio.ObtenerUsuario & "' AS reso_ejecutante, " & vbCrLf &_
			   "       2 AS eres_ccod " & vbCrLf 
			
			
	f_resoluciones.Consultar consulta
	f_resoluciones.Siguiente	
	
	'---------------------------------------------------------------------------------------------------------------
	set f_actas_convalidacion = new CFormulario
	f_actas_convalidacion.Carga_Parametros "acta_convalidacion_agregar.xml", "actas_convalidacion"
	f_actas_convalidacion.Inicializar conexion
	
	consulta = "SELECT " & q_acon_ncorr & " AS acon_ncorr, " & vbCrLf &_
	           "       " & peri_ccod & " AS peri_ccod, " & vbCrLf &_
			   "       '" & q_acon_nacta & "' AS acon_nacta, " & vbCrLf &_
			   "       '" & q_acon_facta & "' AS acon_facta, " & vbCrLf &_
			   "       " & q_reso_ncorr & " AS reso_ncorr, " & vbCrLf &_
			   "       '" & q_acon_tinstitucion & "' AS acon_tinstitucion, " & vbCrLf &_
			   "       '" & q_acon_tcarrera & "' AS acon_tcarrera " & vbCrLf
			
			   
	f_actas_convalidacion.Consultar consulta
	f_actas_convalidacion.Siguiente
	
	
	'-----------------------------------------------------------------------------------------------------------------
	set f_resoluciones_personas = new CFormulario
	f_resoluciones_personas.Carga_Parametros "acta_convalidacion_agregar.xml", "resoluciones_personas"
	f_resoluciones_personas.Inicializar conexion
	
	consulta = "SELECT " & q_reso_ncorr & " AS reso_ncorr, " & vbCrLf &_
	           "       " & v_pers_ncorr & " AS pers_ncorr " & vbCrLf 
			  
			   
	f_resoluciones_personas.Consultar consulta
	f_resoluciones_personas.Siguiente
	
else
	alumno_matriculado = false
end if


'-----------------------------------------------------------------------
set botonera = new CFormulario
botonera.Carga_Parametros "acta_convalidacion_agregar.xml", "botonera"
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
	
	return true;
}


function Aceptar(formulario)
{
	if (preValidaFormulario(formulario)) {
	
		if (ValidaFormEdicion(formulario)) {
			formulario.method = "post";
			formulario.action = "acta_convalidacion_agregar_aceptar.asp"
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
<table width="750" height="100%" border="0" align="center" cellpadding="0" cellspacing="0">
  
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
            <td><%pagina.DibujarLenguetas Array("Actas de convalidación "&peri_tdesc), 1 %></td>
          </tr>
          <tr>
            <td height="2" background="../imagenes/top_r3_c2.gif"></td>
          </tr>
          <tr>
            <td><div align="center"><BR>
                    <%
					  if alumno_matriculado then
					  %>
                    <BR>
			<table width="95%" align="center" cellpadding="0" cellspacing="0">
                        <tr> 
                          <td width="13%"><div align="left">Alumno</div></td>
                          <td width="2%"><div align="center">:</div></td>
                          <td width="85%"><b> 
                            <% fc_datos_alumno.DibujaCampo("nombre_alumno") %>
                            </b> </td>
                        </tr>
                        <tr> 
                          <td>Carrera</td>
                          <td><div align="center">:</div></td>
                          <td><b> 
                            <% fc_datos_alumno.DibujaCampo("carr_tdesc") %>
                            </b></td>
                        </tr>
                        <tr> 
                          <td>Especialidad</td>
                          <td><div align="center">:</div></td>
                          <td><b> 
                            <% fc_datos_alumno.DibujaCampo("espe_tdesc") %>
                            </b></td>
                        </tr>
                        <tr>
                          <td>Plan</td>
                          <td><div align="center">:</div></td>
                          <td><b>
                            <% fc_datos_alumno.DibujaCampo("plan_ncorrelativo") %>
                            </b></td>
                        </tr>
                        <tr> 
                          <td><div align="left"></div></td>
                          <td><div align="center"></div></td>
                          <td><b> </b> </td>
                        </tr>
                      </table>
			
			        <%
					  end if
					  %>
                    <br><BR>
              <%'pagina.DibujarTituloPagina%><br>
                    <%
				  if alumno_matriculado then
				  %>
                  </div>
              <form name="edicion">
                <table width="98%"  border="0" align="center" cellpadding="0" cellspacing="0">
                  <tr>
                    <td><%'pagina.DibujarSubtitulo "Sub-título 1"%>
                          <%
					  if (not resolucion_existe) or (resolucion_existe and resolucion_abierta) then
					  %>
                          <table width="95%" border="1" align="center" cellpadding="0" cellspacing="0">
                            <tr> 
                              <td align="left"> <br> 
                                <%
							f_resoluciones.DibujaCampo("reso_ncorr")
							f_resoluciones.DibujaCampo("reso_nresolucion")
							f_resoluciones.DibujaCampo("tres_ccod")
							f_resoluciones.DibujaCampo("reso_fresolucion")
							f_resoluciones.DibujaCampo("reso_ejecutante")
							f_resoluciones.DibujaCampo("eres_ccod")
							
							f_resoluciones_personas.DibujaCampo("reso_ncorr")
							f_resoluciones_personas.DibujaCampo("pers_ncorr")							
							
							f_actas_convalidacion.DibujaCampo("acon_ncorr")
							f_actas_convalidacion.DibujaCampo("peri_ccod")
							f_actas_convalidacion.DibujaCampo("acon_nacta")
							f_actas_convalidacion.DibujaCampo("acon_facta")
							f_actas_convalidacion.DibujaCampo("reso_ncorr")
							f_actas_convalidacion.DibujaCampo("acon_tinstitucion")
							f_actas_convalidacion.DibujaCampo("acon_tcarrera")							
							
							f_convalidaciones.DibujaCampo("matr_ncorr")
							f_convalidaciones.DibujaCampo("sitf_ccod")
							f_convalidaciones.DibujaCampo("acon_ncorr")
							%>
                                <table width="97%" align="center" cellpadding="0" cellspacing="0">
                                  <tr> 
                                    <td width="26%"><div align="right"><strong>Asignatura 
                                        a convalidar</strong></div></td>
                                    <td width="3%"><div align="center"><strong>:</strong></div></td>
                                    <td width="71%"> 
                                      <%f_convalidaciones.DibujaCampo("asig_ccod")%>
                                    </td>
                                  </tr>
                                  <tr> 
                                    <td><div align="right"><strong>Nota</strong></div></td>
                                    <td><div align="center"><strong>:</strong></div></td>
                                    <td> 
                                      <%f_convalidaciones.DibujaCampo("conv_nnota")%>
                                    </td>
                                  </tr>
                                </table>
                                <br> <br> </td>
                            </tr>
                          </table> 
                          <div align="center"><br>
                            <%
					  else
					  		Response.Write("<center><b>Esta resolución ya está cerrada.</b></center><BR><BR><BR>")
					  end if
					  %>
                          </div></td>
                  </tr>
                </table>
                          <br>
            </form><%
					else
						Response.Write("<center><b>El alumno no registra matrícula en el periodo actual.</b></center><BR><BR><BR>")
					end if
					%></td></tr>
        </table></td>
        <td width="7" background="../imagenes/der.gif">&nbsp;</td>
      </tr>
      <tr>
        <td width="9" height="28"><img src="../imagenes/abajo_r1_c1.gif" width="9" height="28"></td>
        <td height="28"><table width="100%" height="28"  border="0" cellpadding="0" cellspacing="0">
          <tr>
            <td width="16%" height="20"><div align="center">
              <table width="90%"  border="0" cellspacing="0" cellpadding="0">
                <tr>
                  <td><div align="center">
				  <% if ((not resolucion_existe) or (resolucion_existe and resolucion_abierta)) and (alumno_matriculado) then 
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
            <td width="84%" rowspan="2" background="../imagenes/abajo_r1_c4.gif"><img src="../imagenes/abajo_r1_c3.gif" width="12" height="28"></td>
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
