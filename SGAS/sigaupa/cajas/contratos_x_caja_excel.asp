<!-- #include file = "../biblioteca/_conexion.asp" -->
<!-- #include file = "../biblioteca/_negocio.asp" -->

<%
Response.AddHeader "Content-Disposition", "attachment;filename=contratos_caja.xls"
Response.ContentType = "application/vnd.ms-excel"
 
 '---------------------------------------------------------------------------------------------------
set pagina = new CPagina
pagina.Titulo = "Contratos por caja"

'---------------------------------------------------------------------------------------------------
set conexion = new CConexion
conexion.Inicializar "upacifico"
set negocio = new CNegocio
negocio.Inicializa conexion

inicio = request.querystring("inicio")
v_sede_ccod  = request.querystring("busqueda[0][sede_ccod]")
v_pers_ncorr = request.querystring("busqueda[0][pers_ncorr]")


fecha_01 = conexion.ConsultaUno("Select protic.trunc(getdate())")

 set f_busqueda = new CFormulario
 f_busqueda.Carga_Parametros "numeros_boletas_cajeros.xml", "busqueda"
 f_busqueda.Inicializar conexion
 f_busqueda.Consultar "select ''"
 f_busqueda.Siguiente
 
 f_busqueda.AgregaCampoCons "sede_ccod", v_sede_ccod
 f_busqueda.AgregaCampoCons "pers_ncorr", v_pers_ncorr



v_peri_ccod = negocio.ObtenerPeriodoAcademico("POSTULACION")

set lista = new CFormulario
lista.carga_parametros "consulta.xml", "consulta"


if v_sede_ccod <> "" then
	filtro =" and  f.sede_ccod="&v_sede_ccod
end if


if v_pers_ncorr <> "" then
	filtro =filtro&" and  k.pers_ncorr="&v_pers_ncorr
end if

if inicio <> "" then
	filtro =filtro&" and  protic.trunc(convert(datetime,j.mcaj_finicio,103))=convert(datetime,'"&inicio&"',103) "
end if

consulta = " Select protic.trunc(j.mcaj_finicio) as fecha_apertura, isnull(a.mcaj_ncorr,0) as mcaj_ncorr,d.econ_ccod,d.cont_ncorr as n_contrato,g.sede_tdesc as sede, "& vbCrLf &_
			" protic.obtener_nombre_carrera(f.ofer_ncorr,'CE') as carrera,h.jorn_tdesc as jornada,i.econ_tdesc as estado_contrato, "& vbCrLf &_
			" protic.obtener_nombre_completo(e.pers_ncorr,'n') as nombre_alumno, protic.trunc(d.cont_fcontrato) as fecha_contrato, "& vbCrLf &_
			" protic.obtener_rut(e.pers_ncorr) as rut_alumno,protic.obtener_nombre_completo(k.pers_ncorr,'n') as nombre_cajero "& vbCrLf &_
			" From  "& vbCrLf &_
			" ingresos a  "& vbCrLf &_
			" join abonos b  "& vbCrLf &_
			"     on a.ingr_ncorr=b.ingr_ncorr "& vbCrLf &_
			" join compromisos c "& vbCrLf &_
			"     on b.comp_ndocto=c.comp_ndocto "& vbCrLf &_
			"     and b.tcom_ccod=c.tcom_ccod "& vbCrLf &_
			"     and b.inst_ccod=c.inst_ccod "& vbCrLf &_
			" join contratos d "& vbCrLf &_
			"     on c.comp_ndocto=d.cont_ncorr "& vbCrLf &_
			" join postulantes e "& vbCrLf &_
			"     on d.post_ncorr=e.post_ncorr "& vbCrLf &_
			" join ofertas_academicas f "& vbCrLf &_
			"     on e.ofer_ncorr=f.ofer_ncorr    "& vbCrLf &_
			" join sedes g "& vbCrLf &_
			"     on f.sede_ccod=g.sede_ccod    "& vbCrLf &_     
			" join jornadas h "& vbCrLf &_
			"     on f.jorn_ccod=h.jorn_ccod   "& vbCrLf &_
			" join estados_contrato i "& vbCrLf &_
			"     on d.econ_ccod=i.econ_ccod   "& vbCrLf &_
			" left outer join movimientos_cajas j "& vbCrLf &_
			"    on a.mcaj_ncorr=j.mcaj_ncorr "& vbCrLf &_
			" left outer join cajeros k "& vbCrLf &_
			"    on j.caje_ccod=k.caje_ccod "& vbCrLf &_     
			" where a.ting_ccod=7 "& vbCrLf &_
			" and cast(d.peri_ccod as varchar)='"&v_peri_ccod&"' "& vbCrLf &_
			" and d.econ_ccod not in (2) "& vbCrLf &_
			" " &filtro&" "& vbCrLf &_
			" group by j.mcaj_finicio,e.pers_ncorr,k.pers_ncorr,d.cont_fcontrato,i.econ_tdesc,a.mcaj_ncorr,d.econ_ccod,d.cont_ncorr,g.sede_tdesc,h.jorn_tdesc,protic.obtener_nombre_carrera(f.ofer_ncorr,'C'),protic.obtener_nombre_completo(e.pers_ncorr,'n')"


lista.inicializar conexion 


'response.Write("<pre>"&consulta&"</pre>")		

if not Esvacio(Request.QueryString) then
	lista.Consultar consulta
	 
	if lista.nroFilas > 0 then
		cantidad_encontrados=conexion.consultaUno("Select Count(*) from ("&consulta&")a")
	else
		cantidad_encontrados=0
	end if
	
else
	 lista.Consultar "select '' where 1=2"
	 lista.AgregaParam "mensajeError", "Ingrese criterio de busqueda"
end if
%>
<html>
<head>
<title>Listado de alumnos contratados por día</title>
<meta http-equiv="Content-Type" content="text/html;">
</head>
<body >
<table width="100%" border="0">
 <tr> 
    <td colspan="4"><div align="center"><font size="+2" face="Arial, Helvetica, sans-serif"><%=tituloPag%></font></div>
	  <div align="right"></div></td>
    
  </tr>
  <tr> 
    <td colspan="4">&nbsp;</td>
  </tr>
  <tr> 
    <td width="15%" height="22"><strong>Contratos del día </strong></td>
    <td width="85%" colspan="3"><strong>:</strong> <%=inicio %> </td>
  </tr>
  <tr>
    <td><strong>Fecha actual</strong></td>
    <td colspan="3"> <strong>:</strong> <%=fecha_01%></td>
 </tr>
 
</table>

<p>&nbsp;</p><table width="100%" border="1">
  <tr> 
    <td width="2%" bgcolor="#FFFFCC" ><div align="center"><strong>N°</strong></div></td>
    <td width="8%" bgcolor="#FFFFCC"><div align="center"><strong>N° Contrato</strong></div></td>
	<td width="5%" bgcolor="#FFFFCC"><div align="center"><strong>Fecha contrato </strong></div></td>
    <td width="8%" bgcolor="#FFFFCC"><div align="center"><strong>Estado</strong></div></td>
    <td width="20%" bgcolor="#FFFFCC"><div align="center"><strong>Rut</strong></div></td>
	<td width="5%" bgcolor="#FFFFCC"><div align="center"><strong>Nombre</strong></div></td>
	<td width="5%" bgcolor="#FFFFCC"><div align="center"><strong>Sede</strong></div></td>
	<td width="5%" bgcolor="#FFFFCC"><div align="center"><strong>Jornada</strong></div></td>
	<td width="20%" bgcolor="#FFFFCC"><div align="center"><strong>Carrera</strong></div></td>
	<td width="5%" bgcolor="#FFFFCC"><div align="center"><strong>N&deg; Caja</strong></div></td>
	<td width="5%" bgcolor="#FFFFCC"><div align="center"><strong>Nombre cajero</strong></div></td>
	<td width="5%" bgcolor="#FFFFCC"><div align="center"><strong>Fecha apertura</strong></div></td>
  </tr>
  <% fila = 1 
     while lista.Siguiente %>
  <tr> 
    <td><div align="left"><%=fila%></div></td>
	<td><div align="center"><%=lista.ObtenerValor("n_contrato")%></div></td>
	<td><div align="center"><%=lista.ObtenerValor("fecha_contrato")%></div></td>
	<td><div align="center"><%=lista.ObtenerValor("estado_contrato")%></div></td>
	<td><div align="left"><%=lista.ObtenerValor("rut_alumno")%></div></td>
    <td><div align="left"><%=lista.ObtenerValor("nombre_alumno")%></div></td>
	<td><div align="left"><%=lista.ObtenerValor("sede")%></div></td>
	<td><div align="left"><%=lista.ObtenerValor("jornada")%></div></td>
	<td><div align="left"><%=lista.ObtenerValor("carrera")%></div></td>
	<td><div align="left"><%=lista.ObtenerValor("mcaj_ncorr")%></div></td>
	<td><div align="left"><%=lista.ObtenerValor("nombre_cajero")%></div></td>
	<td><div align="left"><%=lista.ObtenerValor("fecha_apertura")%></div></td>
  </tr>
  <% fila = fila + 1  
  wend %>
</table>
<p>&nbsp; 
</p> 
<div align="center"></div>
</body>
</html>