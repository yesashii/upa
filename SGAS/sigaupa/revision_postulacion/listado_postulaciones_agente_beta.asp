<!-- #include file = "../biblioteca/_conexion.asp" -->
<!-- #include file = "../biblioteca/_negocio.asp" -->

<%
set pagina = new CPagina
pagina.Titulo = "Listado de Postulantes asociados al Agente"
'---------------------------------------------------------------------------------------------------
set conexion = new CConexion
conexion.Inicializar "upacifico"

set negocio = new CNegocio
negocio.Inicializa conexion


'--------------------------------------------------------------------------
periodo = negocio.obtenerPeriodoAcademico("Postulacion")
pers_ncorr_agente = conexion.consultaUno("select pers_ncorr from personas where cast(pers_nrut as varchar)='"&negocio.obtenerUsuario&"'")
rut_agente = conexion.consultaUno("select cast(pers_nrut as varchar)+ '-'+ pers_xdv from personas where cast(pers_nrut as varchar)='"&negocio.obtenerUsuario&"'")
nombre_agente = conexion.consultaUno("select protic.initcap(Pers_tnombre + ' ' + pers_tape_paterno + ' ' +pers_tape_materno) from personas where cast(pers_nrut as varchar)='"&negocio.obtenerUsuario&"'")
'--------------------------------------------------------------------------
set botonera = new CFormulario
botonera.Carga_Parametros "listado_postulaciones_agente.xml", "botonera"
'--------------------------------------------------------------------------
set formulario = new CFormulario
formulario.Carga_Parametros "listado_postulaciones_agente.xml", "f_listado"
formulario.Inicializar conexion

consulta = " select distinct c.pers_ncorr,cast(c.pers_nrut as varchar)+'-'+c.pers_xdv as rut, "& vbcrlf & _
		   " c.pers_tnombre + ' ' +c.pers_tape_paterno + ' ' + c.pers_tape_materno as alumno,fecha_ingreso, protic.trunc(fecha_ingreso) as ingresado, "& vbcrlf & _
		   " (select count(*) from postulantes_por_agente bb where bb.post_ncorr=b.post_ncorr) as total_agentes,   "& vbcrlf & _
		   " (select count(*) from detalle_postulantes bb where bb.post_ncorr=b.post_ncorr) as total_carreras, "& vbcrlf & _
		   " (select case count(*) when 0 then 'No' else 'Sí' end from observaciones_postulacion bb where bb.post_ncorr=b.post_ncorr) as gestionado, "& vbcrlf & _
		   " (select max(audi_fmodificacion) from observaciones_postulacion bb where bb.post_ncorr=b.post_ncorr) as ultima_modificacion "& vbcrlf & _
		   " from postulantes_por_agente a, postulantes b, personas_postulante c "& vbcrlf & _
		   " where a.post_ncorr=b.post_ncorr and b.pers_ncorr=c.perS_ncorr "& vbcrlf & _
		   " and cast(a.pers_ncorr as varchar)='"&pers_ncorr_agente&"' "& vbcrlf & _
		   " and not exists (select 1 from alumnos cc where cc.post_ncorr=b.post_ncorr) "
		  
'response.Write("<pre>"&consulta&"</pre>")
cantidad_encontrados = conexion.consultaUno("select count(*) from ("&consulta&")a")	   
formulario.Consultar consulta & " order by fecha_ingreso desc"
	   
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

function Validar()
{
	formulario = document.buscador;
	
	rut_alumno = formulario.elements["busqueda[0][pers_nrut]"].value + "-" + formulario.elements["busqueda[0][pers_xdv]"].value;	
	if (formulario.elements["busqueda[0][pers_nrut]"].value  != '')
  	  if (!valida_rut(rut_alumno)) {
		alert('Ingrese un RUT válido.');
		formulario.elements["busqueda[0][pers_xdv]"].focus();
		formulario.elements["busqueda[0][pers_xdv]"].select();
		return false;
	  }
	
	
	return true;
}


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
                      <div align="left"><font color="#FFFFFF" size="1" face="Verdana, Arial, Helvetica, sans-serif">Listado 
                          Postulantes del Agente</font></div></td>
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
                  
                <td bgcolor="#D8D8DE">
				  <table width="98%" border="0">
					<tr> 
                       <td width="100%"><div align="center"><%pagina.DibujarTituloPagina%>
                        </div></td>
					</tr>
					<tr> 
                       <td width="100%" align="left"></td>
					</tr>
					<tr> 
                       <td width="100%"><%pagina.DibujarSubTitulo("Postulantes asignados")%></td>
					</tr>
					<tr> 
                       <td width="100%"><div align="left"><strong>Rut Agente :</strong><%=rut_agente%></div></td>
					</tr>
					<tr> 
                       <td width="100%"><div align="left"><strong>Nombre Agente :</strong><%=nombre_agente%></div></td>
					</tr>
					<tr> 
                       <td width="100%"><div align="left"><strong>Total encontrado :</strong><%=cantidad_encontrados%> postulante(s)</div></td>
					</tr>
					<tr> 
                       <td width="100%">
                        <div align="right">P&aacute;ginas: &nbsp; 
                          <%formulario.AccesoPagina%>
                        </div></td>
					</tr>
					<tr> 
                       <td width="100%" align="center"><form name="edicion"> 
														<div align="center">
														  <% formulario.DibujaTabla %>
														</div>
													  </form>
													  <br>
				        </td>
					</tr>
                  </table> 
                  </td>
                  <td width="7" align="right" background="../imagenes/der.gif">&nbsp;</td>
                </tr>
            </table>
              <table width="100%" border="0" cellspacing="0" cellpadding="0">
                <tr>
                  <td width="9" rowspan="2"><img src="../imagenes/abajo_r1_c1.gif" width="9" height="28"></td>
                  <td width="101" nowrap bgcolor="#D8D8DE"><table width="100%" border="0" cellpadding="0" cellspacing="0">
                    <tr> 
                      <td width="94%">
                        <%  botonera.dibujaboton "salir"%>
                      </td>
					   <td><div align="center">  
				        <%botonera.agregabotonparam "excel", "url", "listado_postulaciones_agente_excel.asp"
					      botonera.dibujaboton "excel"%>
				  </div></td>
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
