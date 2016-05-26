<!-- #include file = "../biblioteca/_conexion.asp" -->

<%
set conexion = new CConexion
conexion.Inicializar "upacifico"

pers_ncorr= request.QueryString("pers_ncorr")
carr_ccod = request.QueryString("carr_ccod")
plan_ccod = conexion.consultaUno("select top 1 plan_ccod from alumnos a, ofertas_academicas b, especialidades c where a.ofer_ncorr=b.ofer_ncorr and b.espe_ccod=c.espe_ccod and cast(a.pers_ncorr as varchar)='"&pers_ncorr&"' and c.carr_ccod='"&carr_ccod&"' and a.emat_ccod in (4,8) order by b.peri_ccod desc")
'response.Write(plan_ccod)

set f_asignaturas = new cFormulario
f_asignaturas.carga_parametros	"tabla_vacia.xml" , "tabla"
f_asignaturas.inicializar		conexion

consulta_asignaturas = " select mall_ccod, a.asig_ccod, asig_tdesc,"& vbCrLf &_
					   " (select count(*) from ASIGNATURAS_CERTIFICADO tt where tt.mall_ccod=a.mall_ccod and cast(tt.pers_ncorr as varchar)='"&pers_ncorr&"' and tt.carr_ccod='"&carr_ccod&"' and cast(tt.plan_ccod as varchar)='"&plan_ccod&"' and ACER_ENVIADA='NO') as grabado"& vbCrLf &_
                       " from malla_curricular a, asignaturas b "& vbCrLf &_
					   " where a.asig_ccod=b.asig_ccod and cast(a.plan_ccod as varchar)='"&plan_ccod&"' "& vbCrLf &_
					   " order by asig_tdesc asc "

f_asignaturas.consultar consulta_asignaturas
total_asignaturas = f_asignaturas.nroFilas
%>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Strict//EN"
    "http://www.w3.org/TR/xhtml1/DTD/xhtml1-strict.dtd">
<html xmlns="http://www.w3.org/1999/xhtml" xml:lang="en" lang="en">
<head>
  <meta http-equiv="content-type" content="text/html; charset=iso-8859-1" />
  <meta name="description" content="Your description goes here" />
  <meta name="keywords" content="your,keywords,goes,here" />
  <title>Seleccionar Asignaturas</title>
<script src="Scripts/AC_RunActiveContent.js" type="text/javascript"></script>
<script type="text/javascript">
function grabar_asignaturas()
{
	  var cantidad=document.edicion.length;
	  var contestada=0;
	  var cant_radios=0;
	  for(i=0;i<cantidad;i++)
	  {
		elemento=document.edicion.elements[i];
		if (elemento.type=="checkbox")
			{
			  cant_radios++;
			  if(elemento.checked)
				 {contestada++;}
			}
	  }
	  if (contestada==0)
	  {
		alert("Debe seleccionar las asignaturas requeridas para su solicitud.");
	  }
	  else
	  {
		document.edicion.submit();
	  }
}
</script>
<style>
a {
	color: #000000;
	text-decoration: none;
	font-weight:bold;	
}

a:hover {
	color: #63ABCC;
}
</style>
</head>

<body bgcolor="#FFFFFF">
<table width="480" bgcolor="#FFFFFF" border="0">
    <tr>
      <td width="100%" align="left">
	  		<table width="100%" cellpadding="0" cellspacing="0" border="0">
				<tr valign="bottom">
					<td bgcolor="#FFFFFF" width="8" height="18"><img width="8" height="18" src="img/esq_sup_izq.png"></td>
					<td bgcolor="#FFFFFF" height="18" background="img/superior.png">&nbsp;</td>
					<td bgcolor="#FFFFFF" width="12" height="18"><img width="12" height="18" src="img/esq_sup_der.png"></td>
				</tr>
				<tr>
					<td bgcolor="#FFFFFF" width="8" background="img/izquierda.png">&nbsp;</td>
					<td bgcolor="#FFFFFF">
							<table width="100%" cellpadding="0" cellspacing="0">
														<tr>
															<td width="100%" align="left">
																<font size="3"><strong>Seleccione las asignaturas a solicitar</strong></font>
															</td>
														</tr>
														<form name="edicion" action="cargar_asignaturas_proc.asp" method="post">
														<input type="hidden" name="total_asignaturas" value="<%=total_asignaturas%>">
														<input type="hidden" name="pers_ncorr" value="<%=pers_ncorr%>">
														<input type="hidden" name="carr_ccod" value="<%=carr_ccod%>">
														<input type="hidden" name="plan_ccod" value="<%=plan_ccod%>">
														<tr>
															<td width="100%" align="center"><input type="button" name="grabar" value="Grabar Seleccion" onclick="grabar_asignaturas()"></td>
														</tr>
														<tr>
															<td width="100%" align="center">
																<table width="90%" cellpadding="0" cellspacing="0" border="1" bordercolor="#b90000">
																	<tr>
																		<td width="3%" bgcolor="#e0e0e0" align="center"><font color="#333333"><strong>&nbsp;</strong></font></td>
																		<td width="17%" bgcolor="#e0e0e0" align="center"><font color="#333333"><strong>Código</strong></font></td>
																		<td width="80%" bgcolor="#e0e0e0" align="center"><font color="#333333"><strong>Asignatura</strong></font></td>
																	</tr>
																	<%fila = 0
																	  while f_asignaturas.siguiente
																	  	malla = f_asignaturas.obtenerValor("mall_ccod")
																		codig = f_asignaturas.obtenerValor("asig_ccod")
																		asign = f_asignaturas.obtenerValor("asig_tdesc")
																		grabado = f_asignaturas.obtenerValor("grabado")
																		check=""
																		if grabado <> "0" then
																			check="checked"
																		end if
																		%>
																	 <tr>
																		<td width="3%" align="center"><input type="checkbox" name="malla[<%=fila%>]" value="<%=malla%>" <%=check%>></td>
																		<td width="17%" align="left"><font color="#333333"><%=codig%></font></td>
																		<td width="80%" align="left"><font color="#333333"><%=asign%></font></td>
																	 </tr>	
																	 <%fila=fila+1
																	  wend%>
																</table>
															</td>
														</tr>
														</form>
														<tr>
															<td width="100%" align="left">&nbsp;</td>
														</tr>
													</table>			 
					 </td>
				 	 <td bgcolor="#FFFFFF" width="12" background="img/derecha.png">&nbsp;</td>
				</tr>
				<tr valign="top">
				   <td bgcolor="#FFFFFF" width="8" height="18"><img width="8" height="18" src="img/esq_inf_izq.png"></td>
				   <td bgcolor="#FFFFFF" height="18" background="img/inferior.png">&nbsp;</td>
				   <td bgcolor="#FFFFFF" width="12" height="18"><img width="12" height="18" src="img/esq_inf_der.png"></td>
				</tr>
		 </table>
	  </td>
    </tr>
								
  </table>
</body>
</html>
