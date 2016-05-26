<!-- #include file = "../biblioteca/_conexion.asp" -->
<!-- #include file = "../biblioteca/revisa_session_alumno.asp" -->
<!-- #include file = "../biblioteca/_negocio.asp" -->

<%
matr_ncorr		= 	session("matr_ncorr")

'---------------------------------------------------------------------------------------------------
set pagina = new CPagina
pagina.Titulo = "TOMA DE ASIGNATURAS ONLINE"

'---------------------------------------------------------------------------------------------------
set conexion = new CConexion
conexion.Inicializar "upacifico"

set negocio = new CNegocio
negocio.Inicializa conexion


peri_ccod = conexion.consultaUno("Select peri_ccod from alumnos a, ofertas_academicas b where cast(a.matr_ncorr as varchar)='"&matr_ncorr&"' and a.ofer_ncorr = b.ofer_ncorr")
sede_ccod = conexion.consultaUno("Select sede_ccod from alumnos a, ofertas_academicas b where cast(a.matr_ncorr as varchar)='"&matr_ncorr&"' and a.ofer_ncorr = b.ofer_ncorr")

peri_tdesc = conexion.consultaUno("Select protic.initcap(peri_tdesc) from periodos_academicos where cast(peri_ccod as varchar)='"&peri_ccod&"'")
pers_ncorr= session("pers_ncorr_alumno")

pagina.Titulo = "TOMA DE ASIGNATURAS ONLINE <br>" & peri_tdesc
'---------------------------------------------------------------------------------------------------
set f_botonera = new CFormulario
f_botonera.Carga_Parametros "documentacion_matricula.xml", "botonera"

fecha_01=conexion.consultaUno("select protic.trunc(getDate()) as fecha")
'---------------------------------------------------------------------------------------------------

set f_alumno = new CFormulario
f_alumno.Carga_Parametros "inicio_toma_carga_alfa.xml", "carga_tomada"
f_alumno.Inicializar conexion

consulta = " select c.asig_ccod as cod_asignatura, c.asig_tdesc as asignatura,b.secc_tdesc as seccion, " & vbCrLf &_
		   " protic.horario_con_sala(b.secc_ccod) as horario, case acse_ncorr when 3 then 'Carga sin Pre-requisitos' else case a.carg_afecta_promedio when 'N' then 'Optativo' else 'Carga Regular' end end as tipo, "& vbCrLf &_
		   " isnull((select isnull(cred_valor,0) from asignaturas aa,creditos_Asignatura bb "& vbCrLf &_
           "  where aa.cred_ccod = bb.cred_ccod and aa.asig_ccod=c.asig_ccod),0) as creditos"& vbCrLf &_
		   " from cargas_Academicas a, secciones b, asignaturas c " & vbCrLf &_
		   " where cast(matr_ncorr as varchar)='"&matr_ncorr&"' " & vbCrLf &_
		   " and a.secc_ccod=b.secc_ccod " & vbCrLf &_
		   " and not exists (Select 1 from equivalencias eq where eq.matr_ncorr=a.matr_ncorr and eq.secc_ccod=a.secc_ccod) " & vbCrLf &_
		   " and b.asig_ccod=c.asig_ccod " & vbCrLf &_
		   " union all " & vbCrLf &_
		   " select c.asig_ccod as cod_asignatura, c.asig_tdesc as asignatura,b.secc_tdesc as seccion, " & vbCrLf &_
		   " protic.horario_con_sala(b.secc_ccod) as horario,case isnull(acse_ncorr,0) when 0 then 'Equivalencia' else 'Carga Extraordinaria' end as tipo, " & vbCrLf &_
		   " isnull((select isnull(cred_valor,0) from asignaturas aa,creditos_Asignatura bb "& vbCrLf &_
           "  where aa.cred_ccod = bb.cred_ccod and aa.asig_ccod=c.asig_ccod),0) as creditos"& vbCrLf &_
		   " from equivalencias a, secciones b, asignaturas c,cargas_academicas ca " & vbCrLf &_
		   " where cast(a.matr_ncorr as varchar)='"&matr_ncorr&"' " & vbCrLf &_
		   " and a.secc_ccod=b.secc_ccod  and a.matr_ncorr=ca.matr_ncorr and a.secc_ccod = ca.secc_ccod" & vbCrLf &_
		   " and b.asig_ccod=c.asig_ccod "


f_alumno.Consultar consulta


'--------------------------------------------------------------------------------------------------
set fc_datos = new CFormulario
fc_datos.Carga_Parametros "consulta.xml", "consulta"
fc_datos.Inicializar conexion
		   
consulta = "select protic.FORMAT_RUT(cast(a.pers_nrut as varchar)) as rut," & vbCrLf &_
			"         a.pers_tnombre + ' ' + a.pers_tape_paterno + ' ' + a.pers_tape_materno as nombre_completo " & vbCrLf &_
			"from personas_postulante a " & vbCrLf &_
			"where cast(a.pers_ncorr as varchar) = '" & pers_ncorr & "'"
		   
fc_datos.Consultar consulta
fc_datos.Siguiente

max_periodo_matricula = conexion.consultaUno("select max(peri_ccod) from alumnos a, ofertas_academicas b where a.ofer_ncorr=b.ofer_ncorr and a.emat_ccod=1 and cast(a.pers_ncorr as varchar)='"&pers_ncorr&"'")

if not esVacio(max_periodo_matricula) and max_periodo_matricula <> "" then
	cod_carrera = conexion.consultaUno("select carr_ccod from alumnos a, ofertas_academicas b,especialidades c where a.ofer_ncorr=b.ofer_ncorr and a.emat_ccod=1 and cast(a.matr_ncorr as varchar)='"&matr_ncorr&"' and b.espe_ccod = c.espe_ccod")
	carrera = conexion.consultaUno("select protic.initCap(carr_tdesc) from carreras where carr_ccod ='"&cod_carrera&"'")	
	ano_ingreso = conexion.consultaUno("select protic.ANO_INGRESO_CARRERA("&pers_ncorr&",'"&cod_carrera&"')")
	sede_ccod = conexion.consultaUno("select sede_ccod from alumnos a, ofertas_academicas b where a.ofer_ncorr=b.ofer_ncorr and a.emat_ccod=1 and cast(a.matr_ncorr as varchar)='"&matr_ncorr&"'")
	sede = conexion.consultaUno("select protic.initCap(sede_tdesc) from sedes where sede_ccod ='"&sede_ccod&"'")	
	jornada = conexion.consultaUno("select case b.jorn_ccod when 1 then 'Diurna' else 'Vespertina' end from alumnos a, ofertas_academicas b where a.ofer_ncorr=b.ofer_ncorr and a.emat_ccod=1 and cast(a.matr_ncorr as varchar)='"&matr_ncorr&"'")
end if

%>


<html>
<head>
<title><%=pagina.Titulo%></title>
<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1">
<link href="../estilos/estilos_inicial.css" rel="stylesheet" type="text/css">
<link href="../estilos/tabla.css" rel="stylesheet" type="text/css">
<style>
@media print{ .noprint {visibility:hidden; }}
</style>

<script language="JavaScript" src="../biblioteca/tabla.js"></script>
<script language="JavaScript" src="../biblioteca/funciones.js"></script>
<script language="JavaScript" src="../biblioteca/validadores.js"></script>

<script language="JavaScript">
function imprimir() {
  //alert("Enviando a imprimir....");
  window.print()
}

function salir(){
window.close();
}
function InicioPagina(formulario)
{

}
</script>

</head>
<body bgcolor="#ffffff" leftmargin="0" topmargin="0" marginwidth="0" marginheight="0" onLoad="MM_preloadImages('../imagenes/botones/buscar_f2.gif','../images/bot_deshabilitar_f2.gif','../images/agregar2_f2_p.gif','im&amp;#225;genes/marco1_r3_c2_f2.gif');MM_preloadImages('im&amp;#225;genes/marco1_r3_c4_f2.gif');MM_preloadImages('im&amp;#225;genes/marco1_r3_c6_f2.gif');MM_preloadImages('im&amp;#225;genes/marco1_r3_c8_f2.gif');MM_preloadImages('../imagenes/botones/cargar_f2.gif','../imagenes/botones/continuar_f2.gif')" onBlur="revisaVentana();">
<table width="500" height="50%" border="1" align="center" cellpadding="0" cellspacing="0">
  <tr>
    <td valign="top" bgcolor="#ffffff">
	<br>
	
	<table width="98%"  border="0" align="center" cellpadding="0" cellspacing="0" bgcolor="#ffffff">
      <tr>
        <td width="9">&nbsp;</td>
        <td><table width="100%"  border="0" cellspacing="0" cellpadding="0">
          <tr>
            <td><%pagina.DibujarLenguetas Array("Carga Académica Registrada"), 1 %></td>
          </tr>
          <tr>
            <td height="2"></td>
          </tr>
          <tr>
            <td><div align="center"><br>
              <%pagina.DibujarTituloPagina%><br>              
                </div>
				<br>				<br>
				<table width="98%"  border="0" align="center" cellpadding="0" cellspacing="0">
				<tr>
                  <td width="20%"><strong>R.U.T.</strong></td>
                  <td width="1%"><strong>:</strong></td>
                  <td width="79%"><%=fc_datos.ObtenerValor("rut")%></td>
                </tr>
                <tr>
                  <td width="20%"><strong>NOMBRE</strong></td>
                  <td width="1%"><strong>:</strong></td>
                  <td width="79%"><%=fc_datos.ObtenerValor("nombre_completo")%></td>
                </tr>
				<%if not esVacio(max_periodo_matricula) and max_periodo_matricula <> "" then%>
				<tr>
                  <td width="20%"><strong>CARRERA</strong></td>
                  <td width="1%"><strong>:</strong></td>
                  <td width="79%" ><%=carrera%></td>
                </tr>
				<tr>
                  <td width="20%"><strong>AÑO INGRESO</strong></td>
                  <td width="1%"><strong>:</strong></td>
                  <td width="79%"><%=ano_ingreso%></td>
                </tr>
                <tr>
                  <td width="20%"><strong>SEDE</strong></td>
                  <td width="1%"><strong>:</strong></td>
                  <td width="79%"><%=sede%></td>
                </tr>
				<tr>
                  <td width="20%"><strong>JORNADA</strong></td>
                  <td width="1%"><strong>:</strong></td>
                  <td width="79%"><%=jornada%></td>
                </tr>
				<%end if%>
				 <tr>
                  <td width="20%"><strong>Impresi&oacute;n</strong></td>
                  <td width="1%"><strong>:</strong></td>
                  <td width="79%"><%=fecha_01%></td>
                </tr>
              </table>
              <form name="edicion">
                <table width="98%"  border="0" align="center" cellpadding="0" cellspacing="0">
                  <tr>
                    <td colspan="2">
                          <%pagina.DibujarSubtitulo "Carga Académica Registrada"%>                          

                      <br><div align="center"><%f_alumno.DibujaTabla%></div></td>
                  </tr>
				  <tr><td colspan="2">&nbsp;</td></tr>
				  <tr>
                    <td colspan="2" align="center">
					    <table width="80%" border="1" bordercolor="#999999">
							<tr>
								<td width="100%">
									<font face="Courier New, Courier, mono" size="2">
										<strong>Te informamos que esta carga académica está sujeta a eventuales modificaciones.</strong>
									</font>
								</td>
							</tr>
						</table>
					  </td>
                  </tr>
				  <tr>
				      <td colspan="2">
					<br>
					<br>
					<br>
					<br>
                      <table width="98%"  border="0" align="center" cellpadding="0" cellspacing="0">
                        <tr>
                          <td><div align="center"><strong>_______________</strong></div></td>
						  <td><div align="center"><strong>_______________</strong></div></td>
                        </tr>
						 <tr>
                          <td><div align="center">Escuela</div></td>
						  <td><div align="center">Alumno</div></td>
                        </tr>
                      </table>
					  </td>
				  </tr>
				  <tr>
				  	<td>&nbsp; <br><br><br>
				  	</td>
				  </tr>
				  <tr  class="noprint">
                  <td width="8%"><div align="center">
                            <%f_botonera.DibujaBoton("salir2")%>
                          </div></td>
                  <td width="92%"><div align="left"> 
				            <%f_botonera.DibujaBoton ("imprimir")%>
				  </div></td>
                  </tr>
                </table>
                          <br>
            </form></td></tr>
        </table></td>
        <td width="7">&nbsp;</td>
      </tr>
     </table>
	<br>
	<br>
	</td>
  </tr>  
</table>
</body>
</html>
