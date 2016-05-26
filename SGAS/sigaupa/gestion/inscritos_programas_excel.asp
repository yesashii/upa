<!-- #include file = "../biblioteca/_conexion.asp" -->
<!-- #include file = "../biblioteca/_negocio.asp" -->

<%
'response.End()
Response.AddHeader "Content-Disposition", "attachment;filename=inscritos_programas_excel.xls"
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
Usuario = negocio.ObtenerUsuario()
'------------------------------------------------------------------------------------
 v_tdet_ccod = request.querystring("busqueda[0][tdet_ccod]")


set f_lista_incritos = new CFormulario
f_lista_incritos.Carga_Parametros "inscritos_programas.xml", "f_listado_alumnos"
f_lista_incritos.Inicializar conexion


if len(Request.QueryString) > 1 then
	if esVacio(v_tdet_ccod) then
		'sql_filtro = " and c.tdet_ccod in (1379,1380,1381,1382) "
		sql_filtro = ""
	else
		sql_filtro = " and cast(c.tdet_ccod as varchar)='"&v_tdet_ccod&"' "
		'f_lista_incritos.agregaCampoCons "tdet_ccod", v_tdet_ccod
	end if


sql_cursos = " Select sum(f.abon_mabono)as monto_pago,g.ingr_nfolio_referencia as comprobante,protic.trunc(max(g.ingr_fpago)) as fecha_inscrito, "& vbCrLf &_
				" d.tdet_tdesc, protic.obtener_nombre(b.pers_ncorr,'n') nombre_persona,lower(e.pers_temail) as email, "& vbCrLf &_
				" protic.obtener_rut(b.pers_ncorr) as rut, isnull(e.pers_tfono,'s/n') as telefono ,"& vbCrLf &_
				" protic.obtener_direccion_letra(b.pers_ncorr,1,'CNPB') as direccion,i.ciud_tdesc as comuna,i.ciud_tcomuna as  ciudad "& vbCrLf &_
				"    From compromisos a "& vbCrLf &_
				"    join detalle_compromisos b  " & vbCrLf &_  
				"		on a.tcom_ccod = b.tcom_ccod  "& vbCrLf &_      
				"		and a.inst_ccod = b.inst_ccod  "& vbCrLf &_      
				"		and a.comp_ndocto = b.comp_ndocto "& vbCrLf &_
				"        and a.ecom_ccod = '1' "& vbCrLf &_
				"     join detalles c "& vbCrLf &_
				"        on c.tcom_ccod = b.tcom_ccod  "& vbCrLf &_ 
				"		and c.inst_ccod = b.inst_ccod  "& vbCrLf &_  
				"		and c.comp_ndocto = b.comp_ndocto "& vbCrLf &_
				"     join tipos_detalle d "& vbCrLf &_
				"        on c.tdet_ccod=d.tdet_ccod "& vbCrLf &_
				"     join personas e "& vbCrLf &_
				"        on b.pers_ncorr=e.pers_ncorr "& vbCrLf &_
				"     left outer join DIRECCIONES H "& vbCrLf &_
				"        on b.pers_ncorr=H.pers_ncorr "& vbCrLf &_
				" 		 and h.tdir_ccod=1 "& vbCrLf &_
				"     left outer join CIUDADES I "& vbCrLf &_
				"        on h.ciud_ccod=i.ciud_ccod "& vbCrLf &_
				"     join abonos f "& vbCrLf &_
				"        on b.tcom_ccod = f.tcom_ccod  " & vbCrLf &_
				"		 and b.inst_ccod = f.inst_ccod  " & vbCrLf &_ 
				"		 and b.comp_ndocto = f.comp_ndocto "& vbCrLf &_
				"        and b.dcom_ncompromiso = f.dcom_ncompromiso "& vbCrLf &_
				"     join ingresos g "& vbCrLf &_
				"        on f.ingr_ncorr=g.ingr_ncorr "& vbCrLf &_
				"    	 and g.eing_ccod not in (3,6) " & vbCrLf &_
				"        and ting_ccod in (16,34) "& vbCrLf &_
				" Where a.tcom_ccod in (16) " &sql_filtro& " "& vbCrLf &_
				" Group by g.ingr_nfolio_referencia,b.pers_ncorr,c.tdet_ccod,d.tdet_tdesc,e.pers_tfono,i.ciud_tdesc,i.ciud_tcomuna,a.comp_ndocto,e.pers_temail "& vbCrLf &_
				" order by c.tdet_ccod,rut "
else
	sql_cursos="select '' where 1=2"			
end if

'response.Write("<pre>"&sql_cursos&"</pre>")
f_lista_incritos.Consultar sql_cursos
%>
<html>
<head>
<title> Listado Inscritos Cursos </title>
<meta http-equiv="Content-Type" content="text/html;">
</head>
<body >
<table width="75%" border="1">
  <tr> 
    <td width="11%"><div align="center"><strong>N&ordm; Comprobante</strong></div></td>
	   <td width="11%"><div align="center"><strong>Monto Pago</strong></div></td>
    <td width="11%"><div align="center"><strong>Fecha. Inscripcion</strong></div></td>
    <td width="14%"><div align="center"><strong>Nombre Curso</strong></div></td>
    <td width="8%"><div align="center"><strong>Nombre Alumno</strong></div></td>
    <td width="11%"><div align="center"><strong>Rut Alumno</strong></div></td>
    <td width="11%"><div align="center"><strong>Telefono</strong></div></td>
	<td width="11%"><div align="center"><strong>Direccion</strong></div></td>
	<td width="11%"><div align="center"><strong>Comuna</strong></div></td>
	<td width="11%"><div align="center"><strong>Ciudad</strong></div></td>
    <td width="11%"><div align="center"><strong>Email</strong></div></td>
  </tr>
  <%  while f_lista_incritos.Siguiente %>
  <tr> 
	<td><div align="left"><%=f_lista_incritos.ObtenerValor("comprobante")%></div></td>
    <td><div align="left"><%=f_lista_incritos.ObtenerValor("monto_pago")%></div></td>
    <td><div align="left"><%=f_lista_incritos.ObtenerValor("fecha_inscrito")%></div></td>
    <td><div align="left"><%=f_lista_incritos.ObtenerValor("tdet_tdesc")%></div></td>
    <td><div align="left"><%=f_lista_incritos.ObtenerValor("nombre_persona")%></div></td>
    <td><div align="left"><%=f_lista_incritos.ObtenerValor("rut")%></div></td>
    <td><div align="left"><%=f_lista_incritos.ObtenerValor("telefono")%></div></td>
	<td><div align="left"><%=f_lista_incritos.ObtenerValor("direccion")%></div></td>
	<td><div align="left"><%=f_lista_incritos.ObtenerValor("comuna")%></div></td>
	<td><div align="left"><%=f_lista_incritos.ObtenerValor("ciudad")%></div></td>
    <td><div align="left"><%=f_lista_incritos.ObtenerValor("email")%></div></td>
  </tr>
  <%  wend %>
</table>
<p>&nbsp; 
</p> 
<div align="center"></div>
</body>
</html>