<!-- #include file = "../biblioteca/_conexion.asp" -->
<!-- #include file = "../biblioteca/_negocio.asp" -->

<%
set pagina = new CPagina

asig_ccod = request.querystring("asig_ccod")
mall_ccod = request.querystring("mall_ccod")
pers_ncorr = request.querystring("pers_ncorr")


'response.Write(mall_ccod)

'---------------------------------------------------------------------------------------------------
set conexion = new CConexion
conexion.Inicializar "upacifico"

set negocio = new CNegocio
negocio.Inicializa conexion

'----------------------------------------------------------------
set botonera = new CFormulario
botonera.Carga_Parametros "cambiar_notas.xml", "botonera"
'----------------------------------------------------------------

asig_tdesc = conexion.consultauno("SELECT ltrim(rtrim(b.asig_ccod)) + ' ' + asig_tdesc FROM malla_curricular a, asignaturas b WHERE cast(a.mall_ccod as varchar)= '" & mall_ccod & "' and a.asig_ccod = b.asig_ccod")


pagina.Titulo = "Agregar Calificación"

rut = conexion.consultauno("SELECT cast(b.pers_nrut as varchar)+ '-' +b.pers_xdv  FROM  personas b WHERE cast(pers_ncorr as varchar)= '" & pers_ncorr & "'")
nombre = conexion.consultauno("SELECT b.pers_tnombre + ' ' + b.pers_tape_paterno + ' ' + b.pers_tape_materno  FROM personas b WHERE cast(pers_ncorr as varchar)= '" & pers_ncorr & "'")
plan_tdesc = conexion.consultauno("SELECT plan_tdesc FROM malla_curricular a, planes_estudio b WHERE cast(a.mall_ccod as varchar)='"&mall_ccod&"' and a.plan_ccod = b.plan_ccod ")
espe_tdesc = conexion.consultauno("SELECT espe_tdesc FROM malla_curricular a, planes_estudio b,especialidades c WHERE cast(a.mall_ccod as varchar)='"&mall_ccod&"' and a.plan_ccod = b.plan_ccod and b.espe_ccod = c.espe_ccod")
carr_tdesc = conexion.consultauno("SELECT carr_tdesc FROM malla_curricular a, planes_estudio b,especialidades c,carreras d WHERE cast(a.mall_ccod as varchar)='"&mall_ccod&"' and a.plan_ccod = b.plan_ccod and b.espe_ccod=c.espe_ccod and c.carr_ccod=d.carr_ccod")

set f_datos		=		new cformulario
f_datos.inicializar 		conexion
f_datos.carga_parametros	"cambiar_notas.xml","f_campos"
f_datos.consultar "select '' "

consulta_periodos = "(select c.peri_ccod, c.peri_tdesc from alumnos a, ofertas_academicas b, periodos_Academicos c where cast(a.pers_ncorr as varchar)='"&pers_ncorr&"' and a.ofer_ncorr=b.ofer_ncorr and b.peri_ccod=c.peri_ccod and c.anos_ccod < 2006 and emat_ccod in (1,2,4,8,10,13))aa"

f_datos.agregaCampoParam "peri_ccod","destino",consulta_periodos
f_datos.siguiente



'--------------------------------usuario----------------------------------------------------
usuario_temp = negocio.obtenerUsuario

c_bloqueado = "select case count(*) when 0 then 'N' else 'S' end from personas a, sis_roles_usuarios b where cast(a.pers_nrut as varchar)='"&usuario_temp&"' and a.pers_ncorr=b.pers_ncorr and b.srol_ncorr=95"
bloqueado = conexion.consultaUno(c_bloqueado)
'response.Write(bloqueado)
c_es_practica = "select case count(*) when 0 then 'N' else 'S' end  from asignaturas where asig_ccod ='"&asig_ccod&"' and asig_tdesc like '%ca profe%'"
es_practica = conexion.consultaUno(c_es_practica)


c_es_titulado = "select case count(*) when 0 then 'N' else 'S' end  from alumnos where cast(pers_ncorr as varchar) = '"&pers_ncorr&"' and emat_ccod=8"
es_titulado = conexion.consultaUno(c_es_titulado)

if bloqueado="N" then
		habilitar = "S"
		mensaje_nuevo=""
else
    if es_practica="S" and es_titulado="S" then
		habilitar ="S"
		mensaje_nuevo=""
	else
	    habilitar ="N"
		mensaje_nuevo="USTED NO TIENE PERMISOS PARA INGRESAR NOTAS."
	end if
end if 
'-------------------------------------------------------------------------------------------



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



</head>
<body bgcolor="#D8D8DE" leftmargin="0" topmargin="0" marginwidth="0" marginheight="0" onLoad="MM_preloadImages('../imagenes/botones/buscar_f2.gif','../images/bot_deshabilitar_f2.gif','../images/agregar2_f2_p.gif','im&amp;#225;genes/marco1_r3_c2_f2.gif');MM_preloadImages('im&amp;#225;genes/marco1_r3_c4_f2.gif');MM_preloadImages('im&amp;#225;genes/marco1_r3_c6_f2.gif');MM_preloadImages('im&amp;#225;genes/marco1_r3_c8_f2.gif');MM_preloadImages('../imagenes/botones/cargar_f2.gif','../imagenes/botones/continuar_f2.gif')" onBlur="revisaVentana();">
<table width="500" height="100%" border="0" align="center" cellpadding="0" cellspacing="0">
  
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
                <td><%pagina.DibujarLenguetas Array("Cálificar asignatura"), 1 %></td>
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
					      <input type="hidden" name="p[0][pers_ncorr]" value="<%=pers_ncorr%>">
						  <input type="hidden" name="p[0][asig_ccod]" value="<%=asig_ccod%>">
						  <input type="hidden" name="p[0][mall_ccod]" value="<%=mall_ccod%>">
                        <td>
						    <table width="100%" border="0">
                            <tr> 
                              <td width="21%"><strong>RUT</strong></td>
                              <td width="5%"><strong>:</strong></td>
                              <td colspan="3"><%=rut%></td>
                            </tr>
							<tr> 
                              <td width="21%"><strong>Nombre</strong></td>
                              <td width="5%"><strong>:</strong></td>
                              <td colspan="3"><%=nombre%></td>
                            </tr>
							<tr><td colspan="5"><hr></td></tr>
							<tr> 
                              <td width="21%"><strong>Carrera</strong></td>
                              <td width="5%"><strong>:</strong></td>
                              <td colspan="3"><%=carr_tdesc%></td>
                            </tr>
							<tr> 
                              <td width="21%"><strong>Especialidad</strong></td>
                              <td width="5%"><strong>:</strong></td>
                              <td colspan="3"><%=espe_tdesc%></td>
                            </tr>
							<tr> 
                              <td width="21%"><strong>Plan</strong></td>
                              <td width="5%"><strong>:</strong></td>
                              <td colspan="3"><%=plan_tdesc%></td>
                            </tr>
							<tr> 
                              <td width="21%"><strong>Asignatura</strong></td>
                              <td width="5%"><strong>:</strong></td>
                              <td colspan="3"><strong><%=asig_tdesc%></strong></td>
                            </tr>
                            <tr><td colspan="5"><hr></td></tr>
							<%if mensaje_nuevo = "" then%>
							<tr> 
                              <td width="21%"><strong>Periodo</strong></td>
                              <td width="5%"><strong>:</strong></td>
                              <td colspan="3"><strong><%f_datos.DibujaCampo("peri_ccod")%></strong></td>
                            </tr>
							<tr> 
                              <td width="21%"><strong>Concepto</strong></td>
                              <td width="5%"><strong>:</strong></td>
                              <td colspan="3"><strong><%f_datos.DibujaCampo("sitf_ccod")%></strong></td>
                            </tr>
							<tr> 
                              <td width="21%"><strong>Nota</strong></td>
                              <td width="5%"><strong>:</strong></td>
                              <td colspan="3"><strong><%f_datos.DibujaCampo("carg_nnota_final")%></strong> (Ej: 6.5)</td>
                            </tr>
							<%else%>
							<tr>
							  <td colspan="5" bgcolor="#990000" align="center"><font color="#FFFFFF"><strong><%=mensaje_nuevo%></strong></font></td>
							</tr>
							<%end if%>
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
                        <td width="47%"><div align="center">
                            <%if mensaje_nuevo = "" then
							     botonera.dibujaBoton "guardar_nota" 
							  end if
							%>
                          </div></td>
                        <td width="53%"><div align="center">
                            <%botonera.dibujaBoton "cerrar" %>
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
