<!-- #include file = "../biblioteca/_conexion.asp" -->
<!-- #include file = "../biblioteca/_negocio.asp" -->

<%
Response.AddHeader "Content-Disposition", "attachment;filename=Reporte_Carta_Guia.xls"
Response.ContentType = "application/vnd.ms-excel"


'------------------------------------------------------------------------------------
set pagina = new CPagina
'-----------------------------------------------------------------------
set conexion = new CConexion
conexion.Inicializar "upacifico"

set negocio = new CNegocio
negocio.Inicializa conexion
'------------------------------------------------------------------------------------
Periodo = negocio.ObtenerPeriodoAcademico("POSTULACION")
'------------------------------------------------------------------------------------
'response.Write("En Construccion...")
'response.End()
folio_envio = Request.QueryString("folio_envio")


set f_letras = new CFormulario
f_letras.Carga_Parametros "Reporte_Letras.xml", "f_letras_BHIF"
f_letras.Inicializar conexion

cadena = "select pers_ncorr,max(rut_alumno) as rut_alumno,max(dv_alumno) as dv_alumno,max(rut_apoderado) as rut_apoderado,max(dv_apoderado) as dv_apoderado," & vbCrLf &_
"max(nombre_apoderado) as nombre_apoderado,max (paterno_apoderado) as paterno_apoderado,max (materno_apoderado) as materno_apoderado, "& vbCrLf &_
"max(direccion) as direccion,max(ciud_tdesc) as comuna, max(ciud_tcomuna) as ciudad, max(LOWER(pers_temail)) as email, " & vbCrLf &_
"max(uno) as uno,max(m_uno) as m_uno,max(f_uno) as f_uno, " & vbCrLf &_
"max(dos) as dos,max(m_dos) as m_dos,max(f_dos) as f_dos, " & vbCrLf &_
"max(tres) as tres,max(m_tres) as m_tres,max(f_tres) as f_tres, " & vbCrLf &_
"max(cuatro) as cuatro,max(m_cuatro) as m_cuatro,max(f_cuatro) as f_cuatro, " & vbCrLf &_
"max(cinco) as cinco,max(m_cinco) as m_cinco,max(f_cinco) as f_cinco, " & vbCrLf &_
"max(seis) as seis,max(m_seis) as m_seis,max(f_seis) as f_seis, " & vbCrLf &_
"max(siete) as siete,max(m_siete) as m_siete,max(f_siete) as f_siete, " & vbCrLf &_
"max(ocho) as ocho,max(m_ocho) as m_ocho,max(f_ocho) as f_ocho, " & vbCrLf &_
"max(nueve) as nueve,max(m_nueve) as m_nueve,max(f_nueve) as f_nueve, " & vbCrLf &_
"max(diez) as diez,max(m_diez) as m_diez,max(f_diez) as f_diez, " & vbCrLf &_
"max(oncee) as oncee,max(m_oncee) as m_oncee,max(f_oncee) as f_oncee, " & vbCrLf &_
"max(doce) as doce,max(m_doce) as m_doce,max(f_doce) as f_doce, " & vbCrLf &_
"max(trece) as trece,max(m_trece) as m_trece,max(f_trece) as f_trece, " & vbCrLf &_
"max(catorce) as catorce,max(m_catorce) as m_catorce,max(f_catorce) as f_catorce, " & vbCrLf &_
"max(quince) as quince,max(m_quince) as m_quince,max(f_quince) as f_quince, " & vbCrLf &_
"max(dieciseis) as dieciseis,max(m_dieciseis) as m_dieciseis,max(f_dieciseis) as f_dieciseis, " & vbCrLf &_
"max(diecisiete) as diecisiete,max(m_diecisiete) as m_diecisiete,max(f_diecisiete) as f_diecisiete, " & vbCrLf &_
"max(dieciocho) as dieciocho,max(m_dieciocho) as m_dieciocho,max(f_dieciocho) as f_dieciocho, " & vbCrLf &_
"max(diecinueve) as diecinueve,max(m_diecinueve) as m_diecinueve,max(f_diecinueve) as f_diecinueve, " & vbCrLf &_
"max(veinte) as veinte,max(m_veinte) as m_veinte,max(f_veinte) as f_veinte " & vbCrLf &_
"from ( " & vbCrLf &_
"select  i.pers_ncorr,o.pers_nrut as rut_alumno,o.pers_xdv as dv_alumno,d.pers_nrut as rut_apoderado,d.pers_xdv as dv_apoderado," & vbCrLf &_
" 		 d.pers_tnombre as nombre_apoderado,d.pers_tape_paterno as paterno_apoderado,d.pers_tape_materno as materno_apoderado, "& vbCrLf &_
"        protic.obtener_direccion_letra(d.pers_ncorr, 1,'CNPB') as direccion,f.ciud_tdesc, f.ciud_tcomuna, d.pers_temail, " & vbCrLf &_
"        isnull(protic.numero_compromiso (b.ingr_ncorr, b.ting_ccod, b.ding_ndocto), '0') as numero_compromiso, " & vbCrLf &_
"        case protic.numero_compromiso (b.ingr_ncorr, b.ting_ccod, b.ding_ndocto) when 1 then j.ding_ndocto end uno, " & vbCrLf &_
"        case protic.numero_compromiso (b.ingr_ncorr, b.ting_ccod, b.ding_ndocto) when 2 then j.ding_ndocto end dos, " & vbCrLf &_
"        case protic.numero_compromiso (b.ingr_ncorr, b.ting_ccod, b.ding_ndocto) when 3 then j.ding_ndocto end tres, " & vbCrLf &_
"        case protic.numero_compromiso (b.ingr_ncorr, b.ting_ccod, b.ding_ndocto) when 4 then j.ding_ndocto end cuatro, " & vbCrLf &_
"        case protic.numero_compromiso (b.ingr_ncorr, b.ting_ccod, b.ding_ndocto) when 5 then j.ding_ndocto end cinco, " & vbCrLf &_
"        case protic.numero_compromiso (b.ingr_ncorr, b.ting_ccod, b.ding_ndocto) when 6 then j.ding_ndocto end seis, " & vbCrLf &_
"        case protic.numero_compromiso (b.ingr_ncorr, b.ting_ccod, b.ding_ndocto) when 7 then j.ding_ndocto end siete, " & vbCrLf &_
"        case protic.numero_compromiso (b.ingr_ncorr, b.ting_ccod, b.ding_ndocto) when 8 then j.ding_ndocto end ocho, " & vbCrLf &_
"        case protic.numero_compromiso (b.ingr_ncorr, b.ting_ccod, b.ding_ndocto) when 9 then j.ding_ndocto end nueve, " & vbCrLf &_
"        case protic.numero_compromiso (b.ingr_ncorr, b.ting_ccod, b.ding_ndocto) when 10 then j.ding_ndocto end diez, " & vbCrLf &_
"        case protic.numero_compromiso (b.ingr_ncorr, b.ting_ccod, b.ding_ndocto) when 11 then j.ding_ndocto end oncee, " & vbCrLf &_
"        case protic.numero_compromiso (b.ingr_ncorr, b.ting_ccod, b.ding_ndocto) when 12 then j.ding_ndocto end doce, " & vbCrLf &_
"        case protic.numero_compromiso (b.ingr_ncorr, b.ting_ccod, b.ding_ndocto) when 13 then j.ding_ndocto end trece, " & vbCrLf &_   
"        case protic.numero_compromiso (b.ingr_ncorr, b.ting_ccod, b.ding_ndocto) when 14 then j.ding_ndocto end catorce, " & vbCrLf &_  
"        case protic.numero_compromiso (b.ingr_ncorr, b.ting_ccod, b.ding_ndocto) when 15 then j.ding_ndocto end quince, " & vbCrLf &_
"        case protic.numero_compromiso (b.ingr_ncorr, b.ting_ccod, b.ding_ndocto) when 16 then j.ding_ndocto end dieciseis, " & vbCrLf &_
"        case protic.numero_compromiso (b.ingr_ncorr, b.ting_ccod, b.ding_ndocto) when 17 then j.ding_ndocto end diecisiete, " & vbCrLf &_
"        case protic.numero_compromiso (b.ingr_ncorr, b.ting_ccod, b.ding_ndocto) when 18 then j.ding_ndocto end dieciocho, " & vbCrLf &_
"        case protic.numero_compromiso (b.ingr_ncorr, b.ting_ccod, b.ding_ndocto) when 19 then j.ding_ndocto end diecinueve, " & vbCrLf &_   
"        case protic.numero_compromiso (b.ingr_ncorr, b.ting_ccod, b.ding_ndocto) when 20 then j.ding_ndocto end veinte, " & vbCrLf &_  
"        case protic.numero_compromiso (b.ingr_ncorr, b.ting_ccod, b.ding_ndocto) when 1 then j.ding_mdetalle end m_uno, " & vbCrLf &_
"        case protic.numero_compromiso (b.ingr_ncorr, b.ting_ccod, b.ding_ndocto) when 2 then j.ding_mdetalle end m_dos, " & vbCrLf &_
"        case protic.numero_compromiso (b.ingr_ncorr, b.ting_ccod, b.ding_ndocto) when 3 then j.ding_mdetalle end m_tres, " & vbCrLf &_
"        case protic.numero_compromiso (b.ingr_ncorr, b.ting_ccod, b.ding_ndocto) when 4 then j.ding_mdetalle end m_cuatro, " & vbCrLf &_
"        case protic.numero_compromiso (b.ingr_ncorr, b.ting_ccod, b.ding_ndocto) when 5 then j.ding_mdetalle end m_cinco, " & vbCrLf &_
"        case protic.numero_compromiso (b.ingr_ncorr, b.ting_ccod, b.ding_ndocto) when 6 then j.ding_mdetalle end m_seis, " & vbCrLf &_
"        case protic.numero_compromiso (b.ingr_ncorr, b.ting_ccod, b.ding_ndocto) when 7 then j.ding_mdetalle end m_siete, " & vbCrLf &_
"        case protic.numero_compromiso (b.ingr_ncorr, b.ting_ccod, b.ding_ndocto) when 8 then j.ding_mdetalle end m_ocho, " & vbCrLf &_
"        case protic.numero_compromiso (b.ingr_ncorr, b.ting_ccod, b.ding_ndocto) when 9 then j.ding_mdetalle end m_nueve, " & vbCrLf &_
"        case protic.numero_compromiso (b.ingr_ncorr, b.ting_ccod, b.ding_ndocto) when 10 then j.ding_mdetalle end m_diez, " & vbCrLf &_
"        case protic.numero_compromiso (b.ingr_ncorr, b.ting_ccod, b.ding_ndocto) when 11 then j.ding_mdetalle end m_oncee, " & vbCrLf &_
"        case protic.numero_compromiso (b.ingr_ncorr, b.ting_ccod, b.ding_ndocto) when 12 then j.ding_mdetalle end m_doce, " & vbCrLf &_
"        case protic.numero_compromiso (b.ingr_ncorr, b.ting_ccod, b.ding_ndocto) when 13 then j.ding_mdetalle end m_trece, " & vbCrLf &_  
"        case protic.numero_compromiso (b.ingr_ncorr, b.ting_ccod, b.ding_ndocto) when 14 then j.ding_mdetalle end m_catorce, " & vbCrLf &_  
"        case protic.numero_compromiso (b.ingr_ncorr, b.ting_ccod, b.ding_ndocto) when 15 then j.ding_mdetalle end m_quince, " & vbCrLf &_
"        case protic.numero_compromiso (b.ingr_ncorr, b.ting_ccod, b.ding_ndocto) when 16 then j.ding_mdetalle end m_dieciseis, " & vbCrLf &_
"        case protic.numero_compromiso (b.ingr_ncorr, b.ting_ccod, b.ding_ndocto) when 17 then j.ding_mdetalle end m_diecisiete, " & vbCrLf &_
"        case protic.numero_compromiso (b.ingr_ncorr, b.ting_ccod, b.ding_ndocto) when 18 then j.ding_mdetalle end m_dieciocho, " & vbCrLf &_  
"        case protic.numero_compromiso (b.ingr_ncorr, b.ting_ccod, b.ding_ndocto) when 19 then j.ding_mdetalle end m_diecinueve, " & vbCrLf &_  
"        case protic.numero_compromiso (b.ingr_ncorr, b.ting_ccod, b.ding_ndocto) when 20 then j.ding_mdetalle end m_veinte, " & vbCrLf &_
"        case protic.numero_compromiso (b.ingr_ncorr, b.ting_ccod, b.ding_ndocto) when 1 then j.ding_fdocto end f_uno, " & vbCrLf &_
"        case protic.numero_compromiso (b.ingr_ncorr, b.ting_ccod, b.ding_ndocto) when 2 then j.ding_fdocto end f_dos, " & vbCrLf &_
"        case protic.numero_compromiso (b.ingr_ncorr, b.ting_ccod, b.ding_ndocto) when 3 then j.ding_fdocto end f_tres, " & vbCrLf &_
"        case protic.numero_compromiso (b.ingr_ncorr, b.ting_ccod, b.ding_ndocto) when 4 then j.ding_fdocto end f_cuatro, " & vbCrLf &_
"        case protic.numero_compromiso (b.ingr_ncorr, b.ting_ccod, b.ding_ndocto) when 5 then j.ding_fdocto end f_cinco, " & vbCrLf &_
"        case protic.numero_compromiso (b.ingr_ncorr, b.ting_ccod, b.ding_ndocto) when 6 then j.ding_fdocto end f_seis, " & vbCrLf &_
"        case protic.numero_compromiso (b.ingr_ncorr, b.ting_ccod, b.ding_ndocto) when 7 then j.ding_fdocto end f_siete, " & vbCrLf &_
"        case protic.numero_compromiso (b.ingr_ncorr, b.ting_ccod, b.ding_ndocto) when 8 then j.ding_fdocto end f_ocho, " & vbCrLf &_
"        case protic.numero_compromiso (b.ingr_ncorr, b.ting_ccod, b.ding_ndocto) when 9 then j.ding_fdocto end f_nueve, " & vbCrLf &_
"        case protic.numero_compromiso (b.ingr_ncorr, b.ting_ccod, b.ding_ndocto) when 10 then j.ding_fdocto end f_diez, " & vbCrLf &_
"        case protic.numero_compromiso (b.ingr_ncorr, b.ting_ccod, b.ding_ndocto) when 11 then j.ding_fdocto end f_oncee, " & vbCrLf &_
"        case protic.numero_compromiso (b.ingr_ncorr, b.ting_ccod, b.ding_ndocto) when 12 then j.ding_fdocto end f_doce, " & vbCrLf &_
"        case protic.numero_compromiso (b.ingr_ncorr, b.ting_ccod, b.ding_ndocto) when 13 then j.ding_fdocto end f_trece, " & vbCrLf &_  
"        case protic.numero_compromiso (b.ingr_ncorr, b.ting_ccod, b.ding_ndocto) when 14 then j.ding_fdocto end f_catorce, " & vbCrLf &_  
"        case protic.numero_compromiso (b.ingr_ncorr, b.ting_ccod, b.ding_ndocto) when 15 then j.ding_fdocto end f_quince, " & vbCrLf &_
"        case protic.numero_compromiso (b.ingr_ncorr, b.ting_ccod, b.ding_ndocto) when 16 then j.ding_fdocto end f_dieciseis, " & vbCrLf &_
"        case protic.numero_compromiso (b.ingr_ncorr, b.ting_ccod, b.ding_ndocto) when 17 then j.ding_fdocto end f_diecisiete, " & vbCrLf &_
"        case protic.numero_compromiso (b.ingr_ncorr, b.ting_ccod, b.ding_ndocto) when 18 then j.ding_fdocto end f_dieciocho, " & vbCrLf &_  
"        case protic.numero_compromiso (b.ingr_ncorr, b.ting_ccod, b.ding_ndocto) when 19 then j.ding_fdocto end f_diecinueve, " & vbCrLf &_  
"        case protic.numero_compromiso (b.ingr_ncorr, b.ting_ccod, b.ding_ndocto) when 20 then j.ding_fdocto end f_veinte " & vbCrLf &_
"		    		 from envios a     " & vbCrLf &_ 
"		                  join detalle_envios b on a.envi_ncorr = b.envi_ncorr      " & vbCrLf &_
"		                  join detalle_ingresos c on b.ting_ccod = c.ting_ccod and b.ding_ndocto = c.ding_ndocto and b.ingr_ncorr = c.ingr_ncorr      " & vbCrLf &_
"		                  left outer join personas d  " & vbCrLf &_
"                                on c.pers_ncorr_codeudor = d.pers_ncorr      " & vbCrLf &_
"		                  left outer join direcciones e  " & vbCrLf &_
"                                on d.pers_ncorr = e.pers_ncorr      " & vbCrLf &_
"		                  left outer join ciudades f  " & vbCrLf &_
"                                on e.ciud_ccod = f.ciud_ccod     " & vbCrLf &_
"		                  right outer join (select 1 xri) xr  " & vbCrLf &_
"                                on e.tdir_ccod = xri      " & vbCrLf &_
"		                  left outer join instituciones_envio g  " & vbCrLf &_
"                                on a.inen_ccod = g.inen_ccod     " & vbCrLf &_
"		                  left outer join plazas h  " & vbCrLf &_
"                                on a.plaz_ccod = h.plaz_ccod     " & vbCrLf &_
"		                  join ingresos i  " & vbCrLf &_
"                                on b.ingr_ncorr = i.ingr_ncorr     " & vbCrLf &_
"		                  join personas o  " & vbCrLf &_
"                                on i.pers_ncorr = o.pers_ncorr     " & vbCrLf &_
"		                  join detalle_ingresos j  " & vbCrLf &_
"                                on b.ting_ccod = j.ting_ccod  " & vbCrLf &_
"                                and b.ding_ndocto = j.ding_ndocto  " & vbCrLf &_
"                                and b.ingr_ncorr = j.ingr_ncorr  " & vbCrLf &_
"		                  left outer join cuentas_corrientes k  " & vbCrLf &_
"                                on a.ccte_ccod = k.ccte_ccod,     " & vbCrLf &_
"		                  ofertas_academicas l     " & vbCrLf &_
"		                  left outer join sedes m  " & vbCrLf &_
"                                on l.sede_ccod = m.sede_ccod    " & vbCrLf &_ 
"		                  left outer join ciudades n  " & vbCrLf &_
"                                on m.ciud_ccod = n.ciud_ccod       " & vbCrLf &_            
"		    		 where l.ofer_ncorr = protic.ultima_oferta_matriculado(i.pers_ncorr)      " & vbCrLf &_
"		    		    and c.ding_ncorrelativo > 0       " & vbCrLf &_
"		                and a.envi_ncorr = '" & folio_envio & "' " & vbCrLf &_
 "                    ) as tabla " & vbCrLf &_
"                     group by tabla.pers_ncorr    " & vbCrLf &_
                     "   order by  rut_alumno asc "
		  
 


f_letras.Consultar cadena




%>


<html>
<head>
<title> Detalle Envio a Banco</title>
<meta http-equiv="Content-Type" content="text/html;">
</head>
<body >
<table width="100%" border="1">
  <tr> 
    <td ><div align="center"><strong>Rut Aceptante</strong></div></td>
	<td ><div align="center"><strong>Dv Aceptante</strong></div></td>
    <td><div align="center"><strong>Nombre Aceptante</strong></div></td>
	<td><div align="center"><strong>Apellido Paterno </strong></div></td>
	<td><div align="center"><strong>Apellido Materno </strong></div></td>
    <td ><div align="center"><strong>Dirección Aceptante</strong></div></td>
    <td ><div align="center"><strong>Comuna</strong></div></td>
    <td ><div align="center"><strong>Ciudad </strong></div></td>
	<td ><div align="center"><strong>Email </strong></div></td>
    <td ><div align="center"><strong>Rut Alumno</strong></div></td>
	<td ><div align="center"><strong>Dv Alumno</strong></div></td>
	<td ><div align="center"><strong>N&ordm; Letra</strong></div></td>
	<td ><div align="center"><strong>Monto</strong></div></td>
    <td ><div align="center"><strong>Fecha pago </strong></div></td>
    <td ><div align="center"><strong>N&ordm; Letra2</strong></div></td>
	<td ><div align="center"><strong>Monto2</strong></div></td>
    <td ><div align="center"><strong>Fecha pago2 </strong></div></td>
	<td ><div align="center"><strong>N&ordm; Letra3</strong></div></td>
	<td ><div align="center"><strong>Monto3</strong></div></td>
    <td ><div align="center"><strong>Fecha pago3 </strong></div></td>
	<td ><div align="center"><strong>N&ordm; Letra4</strong></div></td>
	<td ><div align="center"><strong>Monto4</strong></div></td>
    <td ><div align="center"><strong>Fecha pago4 </strong></div></td>
	<td ><div align="center"><strong>N&ordm; Letra5</strong></div></td>
	<td ><div align="center"><strong>Monto5</strong></div></td>
    <td ><div align="center"><strong>Fecha pago5 </strong></div></td>
	<td ><div align="center"><strong>N&ordm; Letra6</strong></div></td>
	<td ><div align="center"><strong>Monto6</strong></div></td>
    <td ><div align="center"><strong>Fecha pago6 </strong></div></td>
	<td ><div align="center"><strong>N&ordm; Letra7</strong></div></td>
	<td ><div align="center"><strong>Monto7</strong></div></td>
    <td ><div align="center"><strong>Fecha pago7 </strong></div></td>
	<td ><div align="center"><strong>N&ordm; Letra8</strong></div></td>
	<td ><div align="center"><strong>Monto8</strong></div></td>
    <td ><div align="center"><strong>Fecha pago8 </strong></div></td>
	<td ><div align="center"><strong>N&ordm; Letra9</strong></div></td>
	<td ><div align="center"><strong>Monto9</strong></div></td>
    <td ><div align="center"><strong>Fecha pago9 </strong></div></td>
	<td ><div align="center"><strong>N&ordm; Letra10</strong></div></td>
	<td ><div align="center"><strong>Monto10</strong></div></td>
    <td ><div align="center"><strong>Fecha pago10 </strong></div></td>
	<td ><div align="center"><strong>N&ordm; Letra11</strong></div></td>
	<td ><div align="center"><strong>Monto11</strong></div></td>
    <td ><div align="center"><strong>Fecha pago11 </strong></div></td>
	<td ><div align="center"><strong>N&ordm; Letra12</strong></div></td>
	<td ><div align="center"><strong>Monto12</strong></div></td>
    <td ><div align="center"><strong>Fecha pago12 </strong></div></td>
	<td ><div align="center"><strong>N&ordm; Letra13</strong></div></td>
	<td ><div align="center"><strong>Monto13</strong></div></td>
    <td ><div align="center"><strong>Fecha pago13 </strong></div></td>
	<td ><div align="center"><strong>N&ordm; Letra14</strong></div></td>
	<td ><div align="center"><strong>Monto14</strong></div></td>
    <td ><div align="center"><strong>Fecha pago14 </strong></div></td>
	<td ><div align="center"><strong>N&ordm; Letra15</strong></div></td>
	<td ><div align="center"><strong>Monto15</strong></div></td>
    <td ><div align="center"><strong>Fecha pago15 </strong></div></td>

	<td ><div align="center"><strong>N&ordm; Letra16</strong></div></td>
	<td ><div align="center"><strong>Monto16</strong></div></td>
    <td ><div align="center"><strong>Fecha pago16 </strong></div></td>
	<td ><div align="center"><strong>N&ordm; Letra17</strong></div></td>
	<td ><div align="center"><strong>Monto17</strong></div></td>
    <td ><div align="center"><strong>Fecha pago17 </strong></div></td>
	<td ><div align="center"><strong>N&ordm; Letra18</strong></div></td>
	<td ><div align="center"><strong>Monto18</strong></div></td>
    <td ><div align="center"><strong>Fecha pago18 </strong></div></td>
	<td ><div align="center"><strong>N&ordm; Letra19</strong></div></td>
	<td ><div align="center"><strong>Monto19</strong></div></td>
    <td ><div align="center"><strong>Fecha pago19 </strong></div></td>
	<td ><div align="center"><strong>N&ordm; Letra20</strong></div></td>
	<td ><div align="center"><strong>Monto20</strong></div></td>
    <td ><div align="center"><strong>Fecha pago20 </strong></div></td>



  </tr>
  <%  while f_letras.Siguiente %>
  <tr> 
    <td><div align="right"> <% =f_letras.ObtenerValor("rut_apoderado")%></div></td>
	<td><div align="left"><%=f_letras.ObtenerValor("dv_apoderado") %></div></td>
	<td><div align="left"><%=f_letras.ObtenerValor("nombre_apoderado") %></div></td>
    <td><div align="left"><%=f_letras.ObtenerValor("paterno_apoderado") %></div></td>
	<td><div align="left"><%=f_letras.ObtenerValor("materno_apoderado") %></div></td>
    <td><div align="left"><%=f_letras.ObtenerValor("direccion")%></div></td>
    <td><div align="left"><%=f_letras.ObtenerValor("comuna")%></div></td>
    <td><div align="left"><%=f_letras.ObtenerValor("ciudad")%></div></td>
	<td><div align="left"><%=f_letras.ObtenerValor("email")%></div></td>
    <td><div align="right"><%=f_letras.ObtenerValor("rut_alumno")%> </div></td>
	 <td><div align="right"><%=f_letras.ObtenerValor("dv_alumno")%> </div></td>
	<td><div align="center"><%=f_letras.ObtenerValor("uno") %> </div></td>
	<td><div align="right"><%=f_letras.ObtenerValor("m_uno") %> </div></td>
    <td><div align="right"><%=f_letras.ObtenerValor("f_uno") %> </div></td>
	<td><div align="center"><%=f_letras.ObtenerValor("dos") %> </div></td>
	<td><div align="right"><%=f_letras.ObtenerValor("m_dos") %> </div></td>
    <td><div align="right"><%=f_letras.ObtenerValor("f_dos") %> </div></td>
	<td><div align="center"><%=f_letras.ObtenerValor("tres") %> </div></td>
	<td><div align="right"><%=f_letras.ObtenerValor("m_tres") %> </div></td>
    <td><div align="right"><%=f_letras.ObtenerValor("f_tres") %> </div></td>
	<td><div align="center"><%=f_letras.ObtenerValor("cuatro") %> </div></td>
	<td><div align="right"><%=f_letras.ObtenerValor("m_cuatro") %> </div></td>
    <td><div align="right"><%=f_letras.ObtenerValor("f_cuatro") %> </div></td>
	<td><div align="center"><%=f_letras.ObtenerValor("cinco") %> </div></td>
	<td><div align="right"><%=f_letras.ObtenerValor("m_cinco") %> </div></td>
    <td><div align="right"><%=f_letras.ObtenerValor("f_cinco") %> </div></td>
	<td><div align="center"><%=f_letras.ObtenerValor("seis") %> </div></td>
	<td><div align="right"><%=f_letras.ObtenerValor("m_seis") %> </div></td>
    <td><div align="right"><%=f_letras.ObtenerValor("f_seis") %> </div></td>
	<td><div align="center"><%=f_letras.ObtenerValor("siete") %> </div></td>
	<td><div align="right"><%=f_letras.ObtenerValor("m_siete") %> </div></td>
    <td><div align="right"><%=f_letras.ObtenerValor("f_siete") %> </div></td>
	<td><div align="center"><%=f_letras.ObtenerValor("ocho") %> </div></td>
	<td><div align="right"><%=f_letras.ObtenerValor("m_ocho") %> </div></td>
    <td><div align="right"><%=f_letras.ObtenerValor("f_ocho") %> </div></td>
	<td><div align="center"><%=f_letras.ObtenerValor("nueve") %> </div></td>
	<td><div align="right"><%=f_letras.ObtenerValor("m_nueve") %> </div></td>
    <td><div align="right"><%=f_letras.ObtenerValor("f_nueve") %> </div></td>
	<td><div align="center"><%=f_letras.ObtenerValor("diez") %> </div></td>
	<td><div align="right"><%=f_letras.ObtenerValor("m_diez") %> </div></td>
    <td><div align="right"><%=f_letras.ObtenerValor("f_diez") %> </div></td>
	<td><div align="center"><%=f_letras.ObtenerValor("oncee") %> </div></td>
	<td><div align="right"><%=f_letras.ObtenerValor("m_oncee") %> </div></td>
    <td><div align="right"><%=f_letras.ObtenerValor("f_oncee") %> </div></td>
	<td><div align="center"><%=f_letras.ObtenerValor("doce") %> </div></td>
	<td><div align="right"><%=f_letras.ObtenerValor("m_doce") %> </div></td>
    <td><div align="right"><%=f_letras.ObtenerValor("f_doce") %> </div></td>
	<td><div align="center"><%=f_letras.ObtenerValor("trece") %> </div></td>
	<td><div align="right"><%=f_letras.ObtenerValor("m_trece") %> </div></td>
    <td><div align="right"><%=f_letras.ObtenerValor("f_trece") %> </div></td>
	<td><div align="center"><%=f_letras.ObtenerValor("catorce") %> </div></td>
	<td><div align="right"><%=f_letras.ObtenerValor("m_catorce") %> </div></td>
    <td><div align="right"><%=f_letras.ObtenerValor("f_catorce") %> </div></td>
	<td><div align="center"><%=f_letras.ObtenerValor("quince") %> </div></td>
	<td><div align="right"><%=f_letras.ObtenerValor("m_quince") %> </div></td>
    <td><div align="right"><%=f_letras.ObtenerValor("f_quince") %> </div></td>
	<td><div align="center"><%=f_letras.ObtenerValor("dieciseis") %> </div></td>
	<td><div align="right"><%=f_letras.ObtenerValor("m_dieciseis") %> </div></td>
    <td><div align="right"><%=f_letras.ObtenerValor("f_dieciseis") %> </div></td>
	<td><div align="center"><%=f_letras.ObtenerValor("diecisiete") %> </div></td>
	<td><div align="right"><%=f_letras.ObtenerValor("m_diecisiete") %> </div></td>
    <td><div align="right"><%=f_letras.ObtenerValor("f_diecisiete") %> </div></td>
	<td><div align="center"><%=f_letras.ObtenerValor("dieciocho") %> </div></td>
	<td><div align="right"><%=f_letras.ObtenerValor("m_dieciocho") %> </div></td>
    <td><div align="right"><%=f_letras.ObtenerValor("f_dieciocho") %> </div></td>
	<td><div align="center"><%=f_letras.ObtenerValor("diecinueve") %> </div></td>
	<td><div align="right"><%=f_letras.ObtenerValor("m_diecinueve") %> </div></td>
    <td><div align="right"><%=f_letras.ObtenerValor("f_diecinueve") %> </div></td>
	<td><div align="center"><%=f_letras.ObtenerValor("veinte") %> </div></td>
	<td><div align="right"><%=f_letras.ObtenerValor("m_veinte") %> </div></td>
    <td><div align="right"><%=f_letras.ObtenerValor("f_veinte") %> </div></td>
 </tr>
  <%  wend %>
</table>
<p>&nbsp; 
</p> 
<div align="center"></div>
</body>
</html>