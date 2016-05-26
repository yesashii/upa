<!-- #include file = "../biblioteca/_conexion.asp" -->
<!-- #include file = "../biblioteca/_negocio.asp" -->

<%
'response.End()
Response.AddHeader "Content-Disposition", "attachment;filename=reporte_becas_excel.xls"
Response.ContentType = "application/vnd.ms-excel"
'------------------------------------------------------------------------------------
set pagina = new CPagina
'------------------------------------------------------------------------------------
set conexion = new CConexion
conexion.Inicializar "upacifico"

set negocio = new CNegocio
negocio.Inicializa conexion
'------------------------------------------------------------------------------------
Periodo = negocio.ObtenerPeriodoAcademico("POSTULACION")
'------------------------------------------------------------------------------------
 v_tdet_ccod = request.querystring("busqueda[0][tdet_ccod]")
 v_carr_ccod = Request.QueryString("busqueda[0][carr_ccod]")


set f_lista_incritos = new CFormulario
f_lista_incritos.Carga_Parametros "inscritos_cursos.xml", "f_listado_alumnos"
f_lista_incritos.Inicializar conexion


'response.Write("Largo:"&len(Request.QueryString))
if len(Request.QueryString) > 1 then
	if esVacio(v_tdet_ccod) and  esVacio(v_carr_ccod)then
		sql_filtro = ""
	else
		if v_tdet_ccod<>"" then
			sql_filtro = " and cast(g.stde_ccod as varchar)='"&v_tdet_ccod&"'  "
		end if
		if v_carr_ccod<>"" then
			sql_filtro = sql_filtro+" and cast(k.carr_ccod as varchar)='"&v_carr_ccod&"' "
		end if

	end if


				
sql_becas =" select distinct cast(sdes_mmatricula as integer) as d_matricula,cast(sdes_mcolegiatura as integer) as d_colegiatura, "& vbCrLf &_
			" cast(g.sdes_nporc_matricula as numeric) as porcentaje_matricula,cast(g.sdes_nporc_colegiatura as numeric) as porcentaje_colegiatura, "& vbCrLf &_
			" i.ingr_nfolio_referencia as comprobante,i.mcaj_ncorr as caja, "& vbCrLf &_
			" (select tdet_tdesc from tipos_detalle where tdet_ccod=g.stde_ccod) as beneficio, "& vbCrLf &_
			" protic.trunc(convert(datetime,protic.trunc(c.cont_fcontrato),103)) as fecha_asignacion, "& vbCrLf &_
			" protic.obtener_rut(a.pers_ncorr) as rut_alumno,protic.obtener_nombre_completo(a.pers_ncorr,'n') as nombre_alumno, "& vbCrLf &_
			" protic.obtener_nombre_carrera(d.ofer_ncorr,'CJ') as carrera, "& vbCrLf &_
			" isnull(protic.obtener_direccion_letra(b.pers_ncorr,1,'CNPB'),protic.obtener_direccion_letra(b.pers_ncorr,2,'CNPB')) direccion_alumno "& vbCrLf &_
			" from alumnos a  "& vbCrLf &_
			" join postulantes b "& vbCrLf &_
			" 	on a.pers_ncorr=b.pers_ncorr "& vbCrLf &_
			" 	and a.post_ncorr=b.post_ncorr "& vbCrLf &_
			" join contratos c "& vbCrLf &_
			" 	on a.matr_ncorr=c.matr_ncorr "& vbCrLf &_
			" join ofertas_academicas d "& vbCrLf &_
			" 	on b.ofer_ncorr=d.ofer_ncorr "& vbCrLf &_
			" join especialidades k "& vbCrLf &_
			" 	on d.espe_ccod=k.espe_ccod  "& vbCrLf &_    
			" join sdescuentos g "& vbCrLf &_
			" 	on a.post_ncorr=g.post_ncorr "& vbCrLf &_
			" 	and d.ofer_ncorr=g.ofer_ncorr "& vbCrLf &_
			"  join compromisos f "& vbCrLf &_
			" 	on c.cont_ncorr=f.comp_ndocto "& vbCrLf &_
			" 	and f.tcom_ccod in (1,2) "& vbCrLf &_
			"  join abonos h "& vbCrLf &_
			" 	on f.comp_ndocto=h.comp_ndocto "& vbCrLf &_
			" 	and h.tcom_ccod in (1,2) "& vbCrLf &_
			"  join ingresos i "& vbCrLf &_
			" 	on h.ingr_ncorr=i.ingr_ncorr "& vbCrLf &_
			" 	and i.ting_ccod=7 "& vbCrLf &_
			" 	--and i.ingr_nfolio_referencia=105944 "& vbCrLf &_
			" join personas j "& vbCrLf &_
			" 	on a.pers_ncorr=j.pers_ncorr      "& vbCrLf &_
			" where b.peri_ccod in ("&Periodo&") "& vbCrLf &_
			" and c.peri_ccod in ("&Periodo&") "& vbCrLf &_
			" and c.econ_ccod not in (2,3) "& vbCrLf &_
			" and g.esde_ccod in (1) " &sql_filtro& " "& vbCrLf &_
			" --and convert(datetime,cont_fcontrato,103) between  convert(datetime,'01/09/2006',103) and convert(datetime,'01/10/2007',103) "& vbCrLf &_
			" order by fecha_asignacion,beneficio " 
				
else
	sql_becas="select '' where 1=2"						
end if

'response.Write("<pre>"&sql_becas&"</pre>")
f_lista_incritos.Consultar sql_becas


%>
<html>
<head>
<title> Listado Becas y Beneficios  </title>
<meta http-equiv="Content-Type" content="text/html;">
</head>
<body >
<table width="75%" border="1">
  <tr> 
	    <td width="11%"><div align="center"><strong>Carrera</strong></div></td>
    <td width="11%"><div align="center"><strong>Fecha Asignacion </strong></div></td>
    <td width="14%"><div align="center"><strong>Item Beneficio </strong></div></td>
    <td width="8%"><div align="center"><strong>Nombre Alumno</strong></div></td>
    <td width="11%"><div align="center"><strong>Rut Alumno</strong></div></td>
	<td width="11%"><div align="center"><strong>Direccion</strong></div></td>
	<td width="11%"><div align="center"><strong>Monto matricula</strong></div></td>
	<td width="11%"><div align="center"><strong>Monto arancel</strong></div></td>
	<td width="11%"><div align="center"><strong>Caja</strong></div></td>
	<td width="11%"><div align="center"><strong>Comprobante</strong></div></td>
	
  </tr>
  <%  while f_lista_incritos.Siguiente %>
  <tr> 
    <td><div align="left"><%=f_lista_incritos.ObtenerValor("carrera")%></div></td>
    <td><div align="left"><%=f_lista_incritos.ObtenerValor("fecha_asignacion")%></div></td>
    <td><div align="left"><%=f_lista_incritos.ObtenerValor("beneficio")%></div></td>
    <td><div align="left"><%=f_lista_incritos.ObtenerValor("nombre_alumno")%></div></td>
    <td><div align="left"><%=f_lista_incritos.ObtenerValor("rut_alumno")%></div></td>
	<td><div align="left"><%=f_lista_incritos.ObtenerValor("direccion_alumno")%></div></td>
	<td><div align="left"><%=f_lista_incritos.ObtenerValor("d_matricula")%></div></td>
    <td><div align="left"><%=f_lista_incritos.ObtenerValor("d_colegiatura")%></div></td>
	<td><div align="left"><%=f_lista_incritos.ObtenerValor("caja")%></div></td>
	<td><div align="left"><%=f_lista_incritos.ObtenerValor("comprobante")%></div></td>

	
  </tr>
  <%  wend %>
</table>
<p>&nbsp; 
</p> 
<div align="center"></div>
</body>
</html>