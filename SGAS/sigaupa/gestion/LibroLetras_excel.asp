<!-- #include file = "../biblioteca/_conexion.asp" -->
<!-- #include file = "../biblioteca/_negocio.asp" -->

<%
Response.AddHeader "Content-Disposition", "attachment;filename=LibroLetras.xls"
Response.ContentType = "application/vnd.ms-excel"


mes=request.QueryString("busqueda[0][mes]")
ano=request.QueryString("busqueda[0][ano]")
set pagina = new CPagina
pagina.Titulo = "Listado Letras Mensuales"
'-------------------------------------------------------------------------------
set conexion = new CConexion
conexion.Inicializar "upacifico"

set negocio = new CNegocio
negocio.Inicializa conexion
'------------------------------------------------------------------------------

Periodo = negocio.ObtenerPeriodoAcademico("POSTULACION")
'obtiene la sede
Sede = negocio.ObtenerSede()

sede_tdesc = conexion.consultaUno("select sede_tdesc from sedes where cast(sede_ccod as varchar)='"&Sede&"'")

filtro  ="(select distinct datepart(year,co.comp_fdocto) ano, datepart(year,co.comp_fdocto) ano2 "& vbCrLf &_
		 " from compromisos co, "& vbCrLf &_
		 " abonos ab "& vbCrLf &_
		 " where co.comp_ndocto=ab.comp_ndocto "& vbCrLf &_
		 " and cast(ab.peri_ccod as varchar)='"&Periodo&"' "& vbCrLf &_
		 " ) a"
'-------------------------------------------------------------------------------
set botonera = new CFormulario
botonera.Carga_Parametros "LibroLetras_excel.xml", "botonera"
'-------------------------------------------------------------------------------

 set f_busqueda = new CFormulario
 f_busqueda.Carga_Parametros "LibroLetras_excel.xml", "busqueda_documentos"
 f_busqueda.Inicializar conexion
 f_busqueda.Consultar "select ''"
 f_busqueda.Siguiente
've que cuando refresque quede con el mismo campo
 f_busqueda.Agregacampocons "mes",mes 
 f_busqueda.Agregacampocons "ano",ano
'manda el filtro al xml  
 f_busqueda.Agregacampoparam "ano","destino",filtro 
'-------------------------------------------------------------------------------

set f_libroletras = new CFormulario
f_libroletras.Carga_Parametros "LibroLetras_excel.xml", "f_libroletras"
f_libroletras.Inicializar conexion

 
'  consulta ="select pp.pers_nrut||'-'||pp.pers_xdv pers_nrut, "& vbCrLf &_
'			"pp.pers_nrut pers_nrut2, "& vbCrLf &_
'			"OBTENER_NOMBRE_COMPLETO(Pp.PERS_NCORR,'NPM') NOMBRE, "& vbCrLf &_
'			"ti.ting_ccod," & vbCrLf &_
'			"ti.ting_tdesc," & vbCrLf &_
'			"d.ding_ndocto, "& vbCrLf &_
'			"d.ding_mdetalle, "& vbCrLf &_
'			"d.ding_mdocto," & vbCrLf &_
'			"d.ding_fdocto||'.' ding_fdocto,"& vbCrLf &_
'			"pp.pers_ncorr,"& vbCrLf &_
'			"co.comp_fdocto,"& vbCrLf &_
'			"rtrim(co.comp_fdocto, ' ') fechaletra"& vbCrLf &_
'			"from detalle_ingresos d, "& vbCrLf &_
'			"personas pp,"& vbCrLf &_
'			"ingresos i,"& vbCrLf &_
'			"abonos ab,"& vbCrLf &_
'			"tipos_ingresos ti,"& vbCrLf &_
'			"compromisos co"& vbCrLf &_
'			"where d.ingr_ncorr=i.ingr_ncorr"& vbCrLf &_
'			"and d.PERS_NCORR_CODEUDOR=pp.pers_ncorr"& vbCrLf &_
'			"and i.eing_ccod=4"& vbCrLf &_
'			"and i.ingr_ncorr=ab.ingr_ncorr"& vbCrLf &_
'			"and ab.peri_ccod='"&Periodo&"'"& vbCrLf &_
'			"and d.ting_ccod=ti.ting_ccod"& vbCrLf &_
'			"and ab.comp_ndocto=co.comp_ndocto"& vbCrLf &_
'			"and ab.tcom_ccod=co.tcom_ccod"& vbCrLf &_
'			"and co.sede_ccod='"&Sede&"'"& vbCrLf &_
'			"and co.audi_tusuario not in ('ACTIVA_CONTRATO','ANULA_CONTRATO','COMPROMISOSTALCA','COMPROMISOSTCO','CREAMNAUL','CREAMANUAL','GENERA_CONTRATO','LETRASPEDAGOGIA','REPACTACIONESTCO','ROOT','protic')"& vbCrLf &_
'			"and d.TING_CCOD=4"& vbCrLf
			
consulta = "select cast(pp.pers_nrut as varchar)  + '-' + pp.pers_xdv pers_nrut,pp.pers_nrut pers_nrut2,"& vbCrLf &_
			"        protic.OBTENER_NOMBRE_COMPLETO(Pp.PERS_NCORR,'n') NOMBRE,"& vbCrLf &_
			"        ti.ting_ccod,ti.ting_tdesc,d.ding_ndocto,d.ding_mdetalle,"& vbCrLf &_
			"        d.ding_mdocto,d.ding_fdocto,pp.pers_ncorr,co.comp_fdocto,convert(varchar,co.comp_fdocto,103) fechaletra"& vbCrLf &_
			"    from detalle_ingresos d,ingresos i,personas pp,abonos ab,tipos_ingresos ti,compromisos co"& vbCrLf &_
			"    where d.ingr_ncorr = i.ingr_ncorr"& vbCrLf &_
			"        and d.PERS_NCORR_CODEUDOR=pp.pers_ncorr"& vbCrLf &_
			"        and i.ingr_ncorr=ab.ingr_ncorr"& vbCrLf &_
			"        and d.ting_ccod=ti.ting_ccod"& vbCrLf &_
			"        and ab.comp_ndocto=co.comp_ndocto"& vbCrLf &_
			"        and ab.tcom_ccod=co.tcom_ccod"& vbCrLf &_
			"        and i.eing_ccod=4"& vbCrLf &_
			"        and ab.peri_ccod='"&Periodo&"'"& vbCrLf &_
			"        and co.sede_ccod='"&Sede&"'"& vbCrLf &_
			"        and d.TING_CCOD=4"& vbCrLf &_
			"        and co.audi_tusuario not in ('ACTIVAR CONTRATO')"						
	'response.Write("<pre>"&consulta&"</pre>")								
	'response.End()
			'--------- busca por año y por mes si año y mes tienen valores
			if mes<>"" and ano<>"" then 
			   mes_tdesc=conexion.consultaUno("select protic.entrega_mes('"&mes&"')") 			   
			   ano_tdesc=""&ano&""
			   consulta=consulta & " and cast(datePart(month,co.comp_fdocto) as numeric)="&cint(mes)& " and cast(datePart(year,co.comp_fdocto) as numeric)="&cint(ano)&""
			end if
			
			'-------------------------------------------------------------
			'si mes tiene valor pero año no
			if mes<>"" and ano="" then 			   
			      mes_tdesc=conexion.consultaUno("select protic.entrega_mes('"&mes&"')") 
				  ano_tdesc="TODOS"
			     consulta=consulta &  " and cast(datePart(month,co.comp_fdocto) as numeric)="&cint(mes)& ""
			end if
			
			'---------------------------------------------------
			' si mes no tiene valor pero año si
			
			if mes="" and ano<>"" then 			   			   
			   mes_tdesc="TODOS"
			   ano_tdesc=""&ano&""
			     consulta=consulta &  " and cast(datePart(year,co.comp_fdocto) as numeric)="&cint(ano)& ""
			end if
			
			if mes="" and ano="" then 			   			   
			   mes_tdesc="TODOS"
			   ano_tdesc="TODOS"
			end if
						
			consulta=consulta & "order by co.COMP_FDOCTO asc,pp.pers_nrut desc,d.DING_FDOCTO asc"					
'response.Write(consulta)
'response.Flush()
f_libroletras.consultar consulta

%>


<html>
<head>
<title><%=pagina.Titulo%></title>
<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1">


<style type="text/css">
<!--
.Estilo3 {
	font-size: large;
	font-weight: bold;
}
-->
</style>
</head>
<body>
<p><span class="Estilo3">LIBRO LETRAS DE LA SEDE <%=negocio.ObtenerNombreSede%></span></p>
<p>FECHA : <%=negocio.ObtenerFechaActual%></p>
<p>MES : <font face="Verdana, Arial, Helvetica, sans-serif" size="1">
  <%pagina.DibujarSubtitulo  mes_tdesc%>
</font></p>
<p>A&Ntilde;O : <font face="Verdana, Arial, Helvetica, sans-serif" size="1">
<%pagina.DibujarSubtitulo  ano_tdesc%>
</font><br>
</p>
<table border="1">
  <tr>
    <td><div align="center"><strong>FECHA EMISION </strong></div></td>
    <td><div align="center"><strong>NUMERO LETRA </strong></div></td>
    <td><div align="center"><strong>NOMBRE ACEPTANTE </strong></div></td>
    <td><div align="center"><strong>RUT ACEPTANTE </strong></div></td>
    <td><div align="center"><strong>TIPO MONEDA </strong></div></td>
    <td><div align="center"><strong>VALOR LETRA </strong></div></td>
    <td><div align="center"><strong>VALOR LETRA ($)</strong></div></td>
    <td><div align="center"><strong>VENCIMIENTO LETRA </strong></div></td>
    <td><div align="center"><strong>TASA IMPUESTO </strong></div></td>
    <td><div align="center"><strong>MONTO IMPUESTO </strong></div></td>
  </tr>
  <%while f_libroletras.Siguiente%>
  <tr>
    <td><%=f_libroletras.ObtenerValor("fechaletra")%></td>
    <td><%=f_libroletras.ObtenerValor("ding_ndocto")%></td>
    <td><%=f_libroletras.ObtenerValor("Nombre")%></td>
    <td><%=f_libroletras.ObtenerValor("pers_nrut")%></td>
    <td><%=f_libroletras.ObtenerValor(" ")%></td>
    <td><%=f_libroletras.ObtenerValor(" ")%></td>
    <td><%=f_libroletras.ObtenerValor("ding_mdocto")%></td>
    <td><%=f_libroletras.ObtenerValor("ding_fdocto")%></td>
    <td><%=f_libroletras.ObtenerValor(" ")%></td>
    <td><%=f_libroletras.ObtenerValor(" ")%></td>    
  </tr>
  <%wend%>
</table>
</body>
</html>
