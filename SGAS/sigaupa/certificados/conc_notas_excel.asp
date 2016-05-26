<!-- #include file = "../biblioteca/_conexion.asp" -->
<!-- #include file = "../biblioteca/_negocio.asp" -->

<%
Response.AddHeader "Content-Disposition", "attachment;filename=conc_notas_excel.xls"
Response.ContentType = "application/vnd.ms-excel"

q_pers_nrut = Request.QueryString("pers_nrut")
q_pers_xdv = Request.QueryString("pers_xdv")
q_peri_ccod = Request.QueryString("peri_ccod")
q_solo_aprobadas = Request.QueryString("solo_aprobadas")
carrera=Request.QueryString("carrera")

'---------------------------------------------------------------------------------------------------
set conexion = new CConexion
conexion.Inicializar "upacifico"

set negocio = new CNegocio
negocio.Inicializa conexion


'---------------------------------------------------------------------------------------------------
set f_encabezado = new CFormulario
f_encabezado.Carga_Parametros "conc_notas.xml", "encabezado"
f_encabezado.Inicializar conexion

consulta = "select protic.obtener_rut(a.pers_ncorr) as rut, protic.obtener_nombre_completo(a.pers_ncorr,'n') as nombre, b.plan_ccod, " & vbCrLf &_
           "       protic.obtener_nombre_carrera(b.ofer_ncorr, 'C') as carrera, protic.ano_ingreso_plan(b.pers_ncorr, b.plan_ccod) as ano_ingreso_plan, cast(d.espe_nduracion as varchar) + ' Semestres' as duas_tdesc " & vbCrLf &_
		   "from personas a, alumnos b, ofertas_academicas c, especialidades d" & vbCrLf &_
		   "where a.pers_ncorr = b.pers_ncorr   " & vbCrLf &_
		   "  and b.ofer_ncorr = c.ofer_ncorr " & vbCrLf &_
		   "  and c.espe_ccod = d.espe_ccod " & vbCrLf &_
		   "  and b.emat_ccod <> 9 " 
		   if not esVacio(carrera) then
		   		consulta = consulta & "  and cast(d.carr_ccod as varchar)='"&carrera&"'"
		   else
		   		consulta = consulta & "  and b.ofer_ncorr = protic.ultima_oferta_matriculado(a.pers_ncorr) "
		   end if
		   
		   consulta = consulta & "  and cast(a.pers_nrut as varchar)= '" & q_pers_nrut & "' "

f_encabezado.Consultar consulta
f_encabezado.Siguiente
v_plan_ccod = f_encabezado.ObtenerValor("plan_ccod")

f_encabezado.AgregaParam "columnas", "1"

'---------------------------------------------------------------------------------------------------
set f_notas = new CFormulario
f_notas.Carga_Parametros "conc_notas.xml", "notas"
f_notas.Inicializar conexion

sql_notas = conexion.ConsultaUno("select protic.obtener_sql_notas('" & q_pers_nrut & "') ")

consulta = "select a.asig_ccod, b.asig_tdesc, a.carg_nnota_final, c.peri_ccod, c.anos_ccod, c.plec_ccod, isnull(a.sitf_ccod,'') as sitf_ccod, a.sitf_baprueba, a.cod_tipo, " & vbCrLf &_
           "       rtrim(ltrim(cast(a.carg_nnota_final as decimal(2,1)))) as nota_final,b.asig_nhoras as horas " & vbCrLf &_
		   "from ( " & vbCrLf &_
		   sql_notas & vbCrLf &_
		   "	) a, asignaturas b, periodos_academicos c " 
		   if not esVacio(carrera) then
		   		consulta = consulta & ", planes_estudio d, especialidades e"
		   end if
		   consulta =consulta & " where a.asig_ccod = b.asig_ccod " & vbCrLf &_
		   "  and a.peri_ccod = c.peri_ccod "
		   if not esVacio(q_solo_aprobadas) and q_solo_aprobadas<> "N" then
		    	consulta=consulta & "  and isnull(cast(a.sitf_baprueba as varchar),'N') = case '" & q_solo_aprobadas & "' when 'S' then 'S' else 'N' end"
		   end if
		   if not esVacio(q_peri_ccod) then
		   		consulta=consulta & "  and cast(a.peri_ccod as varchar) = '" & q_peri_ccod & "'" 
		   end if 
		   consulta=consulta & " -- and cast(a.plan_ccod as varchar)= '" & v_plan_ccod & "' " & vbCrLf &_
		   " and sitf_ccod <> '' "
		    if not esVacio(carrera) then
		   		consulta = consulta & " and a.plan_ccod=d.plan_ccod and d.espe_ccod=e.espe_ccod and cast(e.carr_ccod as varchar)='"&carrera&"'"
		   end if 
		   consulta=consulta &" order by a.peri_ccod asc, b.asig_tdesc asc"
 
f_notas.Consultar consulta


'------------------------------------------------------------------------------------------------ 
set f_param_impresion = new CFormulario
f_param_impresion.Carga_Parametros "conc_notas.xml", "param_impresion"
f_param_impresion.Inicializar conexion
f_param_impresion.Consultar "select ''"   
   
 
%>


<html>

<body>
<%f_encabezado.DibujaRegistro%>
<br>
<table width="98%"  border="1">
  <tr>
    <td><div align="center"><strong>C&oacute;digo</strong></div></td>
    <td><div align="center"><strong>Asignatura</strong></div></td>
    <td><div align="center"><strong>Nota</strong></div></td>
    <td><div align="center"><strong>Situaci&oacute;n Final</strong></div></td>
    <td><div align="center"><strong>A&ntilde;o</strong></div></td>
    <td><div align="center"><strong>Semestre</strong></div></td>
	<td><div align="center"><strong>Horas</strong></div></td>
  </tr>
  <%while f_notas.Siguiente%>
  <tr>
    <td><%=f_notas.ObtenerValor("asig_ccod")%></td>
    <td><%=f_notas.ObtenerValor("asig_tdesc")%></td>
    <td><%=f_notas.ObtenerValor("carg_nnota_final")%></td>
    <td><%=f_notas.ObtenerValor("sitf_ccod")%></td>
    <td><%=f_notas.ObtenerValor("anos_ccod")%></td>
    <td><%=f_notas.ObtenerValor("plec_ccod")%></td>
	<td><%=f_notas.ObtenerValor("horas")%></td>
  </tr>
  <%wend%>
</table>
</body>
</html>