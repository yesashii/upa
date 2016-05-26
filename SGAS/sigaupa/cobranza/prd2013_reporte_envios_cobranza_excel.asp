<!-- #include file = "../biblioteca/_conexion.asp" -->
<!-- #include file = "../biblioteca/_negocio.asp" -->

<%
Response.AddHeader "Content-Disposition", "attachment;filename=detalle_envios_cobranza.xls"
Response.ContentType = "application/vnd.ms-excel"

'------------------------------------------------------------------------------------
set pagina = new CPagina
'-----------------------------------------------------------------------
set conexion = new CConexion
conexion.Inicializar "upacifico"

set negocio = new CNegocio
negocio.Inicializa conexion
'------------------------------------------------------------------------------------
sede = request.querystring("busqueda[0][sede_ccod]")
 empresa = request.querystring("busqueda[0][inen_ccod]")
 folio = request.querystring("busqueda[0][envi_ncorr]")
 inicio = request.querystring("busqueda[0][envi_fenvio]")
 termino = request.querystring("busqueda[0][envio_termino]") 
 tipo_docto = request.querystring("busqueda[0][ting_ccod]") 
 nro_docto = request.querystring("busqueda[0][ding_ndocto]") 
 estado_docto = request.querystring("busqueda[0][edin_ccod]") 
 rut_alumno = request.querystring("busqueda[0][pers_nrut]")
 rut_alumno_digito = request.querystring("busqueda[0][pers_xdv]")
 rut_apoderado = request.querystring("busqueda[0][code_nrut]")
 rut_apoderado_digito = request.querystring("busqueda[0][code_xdv]")
  nro_cuenta_corriente= request.querystring("busqueda[0][ding_tcuenta_corriente]")
 
Periodo = negocio.ObtenerPeriodoAcademico("POSTULACION")


'
'----------------------------------------------------

set formulario = new CFormulario
formulario.Carga_Parametros "reporte_cobranza.xml", "f_listado"
formulario.Inicializar conexion
formulario.ProcesaForm

'formulario.ListarPost
'response.End()
'

 '------------------------------------------------------------------------------------
set f_detalle_envio = new CFormulario
f_detalle_envio.Carga_Parametros "reporte_cobranza.xml", "f_listado"
f_detalle_envio.Inicializar conexion

consulta = "select a.edin_ccod, a.ting_ccod ,i.ting_tdesc, a.ding_ndocto as c_ding_ndocto,ee.envi_ncorr,  "& vbCrLf &_
" protic.trunc(b.ingr_fpago) as fecha_envio,a.ding_tcuenta_corriente, a.ding_ndocto, a.ding_mdetalle, "& vbCrLf &_
" protic.trunc(a.ding_fdocto) as ding_fdocto,h.edin_tdesc,b.ingr_ncorr,a.ding_mdocto,  "& vbCrLf &_
" protic.obtener_rut(b.pers_ncorr) as rut_alumno, protic.obtener_rut(a.pers_ncorr_codeudor) as rut_apoderado  "& vbCrLf &_
"	 from envios ee,  "& vbCrLf &_
"	 detalle_envios de,  "& vbCrLf &_
"	 detalle_ingresos a,   "& vbCrLf &_
"	 estados_detalle_ingresos a1,   "& vbCrLf &_
"	 ingresos b,   "& vbCrLf &_
"	 estados_detalle_ingresos h,   "& vbCrLf &_
"	 tipos_ingresos i,    "& vbCrLf &_
"		  personas j,  "& vbCrLf &_
"		  personas k,   "& vbCrLf &_
"		  abonos l,   "& vbCrLf &_
"		  detalle_compromisos m,   "& vbCrLf &_
"		  postulantes n,  "& vbCrLf &_
"		  ofertas_academicas o ,instituciones_envio hh,familias_estados_detalle_ingr fe  "& vbCrLf &_
"	 where   "& vbCrLf &_
"	   ee.envi_ncorr = de.envi_ncorr "& vbCrLf &_
"	   and de.ting_ccod = a.ting_ccod  "& vbCrLf &_
"	   and de.ding_ndocto = a.ding_ndocto   "& vbCrLf &_
"	 and de.ingr_ncorr = a.ingr_ncorr   "& vbCrLf &_
"	   and a.ingr_ncorr = b.ingr_ncorr     "& vbCrLf &_
"      and a.edin_ccod = a1.edin_ccod   "& vbCrLf &_
"		and a1.fedi_ccod = fe.fedi_ccod  "& vbCrLf &_
"      and a.ding_ncorrelativo = 1    "& vbCrLf &_
"	   and a.edin_ccod = h.edin_ccod    "& vbCrLf &_
"	   and a.ting_ccod = i.ting_ccod   "& vbCrLf &_
"	   and b.pers_ncorr = j.pers_ncorr   "& vbCrLf &_
"	   and a.pers_ncorr_codeudor  *= k.pers_ncorr   "& vbCrLf &_
"	   and b.ingr_ncorr = l.ingr_ncorr   "& vbCrLf &_
"	   and l.tcom_ccod = m.tcom_ccod   "& vbCrLf &_
"	   and l.inst_ccod = m.inst_ccod   "& vbCrLf &_
"	   and l.comp_ndocto = m.comp_ndocto  "& vbCrLf &_
"	   and l.dcom_ncompromiso = m.dcom_ncompromiso   "& vbCrLf &_
"	   and b.pers_ncorr = n.pers_ncorr   "& vbCrLf &_
"	   and n.peri_ccod  = isnull(m.peri_ccod,n.peri_ccod)   "& vbCrLf &_
"	   and n.ofer_ncorr = o.ofer_ncorr  "& vbCrLf &_
"	   and ee.inen_ccod = hh.inen_ccod    "& vbCrLf &_
"	   and hh.TINE_CCOD in (3,4) "& vbCrLf 




					if rut_alumno <> "" then
					   consulta = consulta & "	   and cast(j.pers_nrut as varchar)= '" & rut_alumno & "' "& vbCrLf
					end if
					
					if sede <> "" then
					   consulta = consulta & "	  and cast(o.sede_ccod as varchar)='" & sede & "' "& vbCrLf
					end if
					
					
					if rut_apoderado <> "" then
					   consulta = consulta & "	   and cast(k.pers_nrut as varchar)= '" & rut_apoderado & "' "& vbCrLf
					end if
					
					if nro_docto <> "" then					
					  consulta = consulta & "	   and cast(a.ding_ndocto as varchar)= '" & nro_docto & "' "& vbCrLf
					end if
					
					if nro_cuenta_corriente <> "" then					
					  consulta = consulta &" and isnull(a.ding_tcuenta_corriente , ' ') = isnull(isnull('" & nro_cuenta_corriente & "',a.ding_tcuenta_corriente), ' ') "& vbCrLf
					 end if 
					 
					 
					 if tipo_docto <> "" then					
					  consulta = consulta &"		and cast(de.ting_ccod as varchar)= '" & tipo_docto & "'"& vbCrLf
					 end if 
					 
					 if estado_docto <> "" then
					  consulta = consulta & "and cast(fe.fedi_ccod as varchar) = '" & estado_docto & "' "& vbCrLf
					end if

f_detalle_envio.Consultar consulta

%>
<html>
<head>
<title> Detalle Envio a Notaria</title>
<meta http-equiv="Content-Type" content="text/html;">
</head>
<body >
<table width="114%" border="1">
  <tr> 
    <td width="10%"><div align="center"><strong>N&ordm; Documento</strong></div></td>
    <td width="12%" align="center"><strong>Tipo</strong></td>
    <td width="15%" align="center"><strong>N&ordm; Cuenta Corriente</strong></td>
    <td width="15%"><div align="center"><strong>Estado</strong></div></td>
    <td width="10%"><div align="center"><strong>Fecha Emisi&oacute;n</strong></div></td>
    <td width="10%"><div align="center"><strong>Fecha Vencimiento</strong></div></td>
    <td width="13%"><div align="center"><strong>Rut Alumno</strong></div></td>
    <td width="13%"><div align="center"><strong>Rut Apoderado</strong></div></td>
    <td width="18%"><div align="center"><strong>Monto Letra</strong></div></td>
  </tr>
  <%  while f_detalle_envio.Siguiente %>
  <tr> 
    <td><div align="center"><%=f_detalle_envio.ObtenerValor("ding_ndocto")%></div></td>
    <td align="center"><%=f_detalle_envio.ObtenerValor("ting_tdesc")%></td>
    <td align="center"><%=f_detalle_envio.ObtenerValor("ding_tcuenta_corriente")%></td>
    <td><div align="center"><%=f_detalle_envio.ObtenerValor("edin_tdesc")%></div></td>
    <td><div align="center"><%=f_detalle_envio.ObtenerValor("fecha_envio")%></div></td>
    <td><div align="center"><%=f_detalle_envio.ObtenerValor("ding_fdocto")%></div></td>
    <td><div align="center"><%=f_detalle_envio.ObtenerValor("rut_alumno")%></div></td>
    <td><div align="center"><%=f_detalle_envio.ObtenerValor("rut_apoderado")%></div></td>
    <td align="center"> <%=f_detalle_envio.ObtenerValor("ding_mdocto")%></td>
  </tr>
  <%  wend %>
</table>

</body>
</html>