<!-- #include file = "../biblioteca/_conexion.asp" -->
<%
Response.AddHeader "Content-Disposition", "attachment;filename=estadisticas_egreso_titulacion_personas.xls"
Response.ContentType = "application/vnd.ms-excel"
Server.ScriptTimeOut = 999999999
Response.Buffer = False


set conexion = new CConexion
conexion.Inicializar "upacifico"

contador = 1

'numero = conexion.consultaUno("select count(*) from personas")
'response.write(numero)
%>
<html>
<head></head>
<body>
<table border="1" >
<tr>
		<td>Nº</td>	
		<td>RUT</td>	
		<td>NOMBRE COMPLETO</td>	
		<td>BECA</td>
		<td>CARRERA</td>	
		<td>SEDE</td>		
		<td>A&Ntilde;O INGRESO A LA CARRERA</td>
		<td>MAIL</td>
		<td>ASIGNATURAS INSCRITAS AÑO 2014</td>
		<td>ASIGNATURAS APROBADAS  AÑO 2014</td>
		<td>PORCENTAJE DE APROBACI&Oacute;N 2014 </td>
	</tr>
<%
set f_personas = new cformulario
f_personas.carga_parametros "tabla_vacia.xml","tabla"
f_personas.inicializar conexion	
consulta = ""& vbCrLf &_
"select rut, id_becas_2014 from becas_2014"

f_personas.Consultar consulta
while f_personas.siguiente

var_rut = f_personas.obtenerValor("rut")
var_id = f_personas.obtenerValor("id_becas_2014")
'response.write(f_personas.obtenerValor("rut" )&"<br/>")
'----------------------------------------------------------------------------------------------------------------->>
set f_personas_2 = new cformulario
f_personas_2.carga_parametros "tabla_vacia.xml","tabla"
f_personas_2.inicializar conexion	
consulta = ""& vbCrLf &_
"select b.* from becas_2014 as a																																	"& vbCrLf &_
"inner  join (                                                                                                                                                      "& vbCrLf &_
"select table2.*,                                                                                                                                                   "& vbCrLf &_
"       Cast(( ( total_carga_aprobada * 100 ) / case total_carga when 0 then 1 else total_carga end ) as decimal(5, 2)) 	as PORCENTAJE_APROBACION                "& vbCrLf &_
"from   (select pers_nrut                                                     											as RUT,                                     "& vbCrLf &_
"               pers_xdv                                                      											as DV,                                      "& vbCrLf &_
"               nombre                                                        											as NOMBRE_COMPLETO,                         "& vbCrLf &_
"               (select tipo from becas_2014 where rut = '"&var_rut&"' and id_becas_2014 = '"&var_id&"'  )				as tipo,                                    	"& vbCrLf &_
"               (select carr_tdesc 											                                                                                        "& vbCrLf &_
"                from   carreras 											                                                                                        "& vbCrLf &_
"                where  carr_ccod = carr_ccod_2014)                           											as CARRERA,                                 "& vbCrLf &_
"               (select sede_tdesc                                                                                                                                  "& vbCrLf &_
"                from   sedes                                                                                                                                       "& vbCrLf &_
"                where  sede_ccod = sede_ccod_2014)                           											as SEDE,                                    "& vbCrLf &_
"               protic.ano_ingreso_carrera(table1.pers_ncorr, carr_ccod_2014) 											as ANO_INGRESO_CARRERA,                     "& vbCrLf &_
"               table1.pers_temail                                            											as EMAIL_PERSONAL,                          "& vbCrLf &_
"               ------------------------------------------ sector TOTAL CARGA --------------------------------------------------------------------->>               "& vbCrLf &_
"			   (select Count(*)                                                                                                                                     "& vbCrLf &_
"                from   alumnos ttt,                                                                                                                                "& vbCrLf &_
"                       ofertas_academicas tt2,                                                                                                                     "& vbCrLf &_
"                       periodos_academicos tt3,                                                                                                                    "& vbCrLf &_
"                       especialidades tt4,                                                                                                                         "& vbCrLf &_
"                       cargas_academicas tt5,                                                                                                                      "& vbCrLf &_
"                       situaciones_finales tt6                                                                                                                     "& vbCrLf &_
"                where  ttt.pers_ncorr = table1.pers_ncorr                                                                                                          "& vbCrLf &_
"                       and ttt.ofer_ncorr = tt2.ofer_ncorr                                                                                                         "& vbCrLf &_
"                       and tt2.peri_ccod = tt3.peri_ccod                                                                                                           "& vbCrLf &_
"                       and tt2.espe_ccod = tt4.espe_ccod                                                                                                           "& vbCrLf &_
"                       and tt4.carr_ccod = table1.carr_ccod_2014                                                                                                   "& vbCrLf &_
"                       and ttt.matr_ncorr = tt5.matr_ncorr                                                                                                         "& vbCrLf &_
"                       and tt5.sitf_ccod = tt6.sitf_ccod                                                                                                           "& vbCrLf &_
"                       and ttt.emat_ccod <> 9                                                                                                                      "& vbCrLf &_
"                       and tt3.anos_ccod = 2014)                             											as total_carga,                             "& vbCrLf &_
"				------------------------------------------ sector TOTAL CARGA ---------------------------------------------------------------------<<	            "& vbCrLf &_
"				------------------------------------------ sector total_carga_aprobada --------------------------------------------------------------------->>		"& vbCrLf &_
"               (select Count(*)                                                                                                                                    "& vbCrLf &_
"                from   alumnos ttt,                                                                                                                                "& vbCrLf &_
"                       ofertas_academicas tt2,                                                                                                                     "& vbCrLf &_
"                       periodos_academicos tt3,                                                                                                                    "& vbCrLf &_
"                       especialidades tt4,                                                                                                                         "& vbCrLf &_
"                       cargas_academicas tt5,                                                                                                                      "& vbCrLf &_
"                       situaciones_finales tt6                                                                                                                     "& vbCrLf &_
"                where  ttt.pers_ncorr = table1.pers_ncorr                                                                                                          "& vbCrLf &_
"                       and ttt.ofer_ncorr = tt2.ofer_ncorr                                                                                                         "& vbCrLf &_
"                       and tt2.peri_ccod = tt3.peri_ccod                                                                                                           "& vbCrLf &_
"                       and tt2.espe_ccod = tt4.espe_ccod                                                                                                           "& vbCrLf &_
"                       and tt4.carr_ccod = table1.carr_ccod_2014                                                                                                   "& vbCrLf &_
"                       and ttt.matr_ncorr = tt5.matr_ncorr                                                                                                         "& vbCrLf &_
"                       and tt5.sitf_ccod = tt6.sitf_ccod                                                                                                           "& vbCrLf &_
"                       and ttt.emat_ccod <> 9                                                                                                                      "& vbCrLf &_
"                       and tt3.anos_ccod = 2014                                                                                                                    "& vbCrLf &_
"                       and sitf_baprueba = 'S')                              											as total_carga_aprobada                     "& vbCrLf &_
"				------------------------------------------ sector total_carga_aprobada ---------------------------------------------------------------------<<	    "& vbCrLf &_
"        from   (select a.pers_ncorr, --TABLE_1----------->>	                                                                                                    "& vbCrLf &_
"                       a.pers_temail,                                                                                                                              "& vbCrLf &_
"                       a.pers_nrut,                                                                                                                                "& vbCrLf &_
"                       a.pers_xdv,                                                                                                                                 "& vbCrLf &_
"                       pers_tape_paterno + ' ' + pers_tape_materno                                                                                                 "& vbCrLf &_
"                       + ', ' + pers_tnombre         as nombre,                                                                                                    "& vbCrLf &_
"                       (select top 1 t4.carr_ccod                                                                                                                  "& vbCrLf &_
"                        from   alumnos tt,                                                                                                                         "& vbCrLf &_
"                               ofertas_academicas t2,                                                                                                              "& vbCrLf &_
"                               periodos_academicos t3,                                                                                                             "& vbCrLf &_
"                               especialidades t4                                                                                                                   "& vbCrLf &_
"                        where  tt.pers_ncorr = a.pers_ncorr                                                                                                        "& vbCrLf &_
"                               and tt.ofer_ncorr = t2.ofer_ncorr                                                                                                   "& vbCrLf &_
"                               and t2.peri_ccod = t3.peri_ccod                                                                                                     "& vbCrLf &_
"                               and t2.espe_ccod = t4.espe_ccod                                                                                                     "& vbCrLf &_
"                               and t3.anos_ccod = '2014'                                                                                                           "& vbCrLf &_
"                               and tt.emat_ccod <> 9                                                                                                               "& vbCrLf &_
"                        order  by t3.peri_ccod desc) as carr_ccod_2014,                                                                                            "& vbCrLf &_
"                       (select top 1 t2.sede_ccod                                                                                                                  "& vbCrLf &_
"                        from   alumnos tt,                                                                                                                         "& vbCrLf &_
"                               ofertas_academicas t2,                                                                                                              "& vbCrLf &_
"                               periodos_academicos t3,                                                                                                             "& vbCrLf &_
"                               especialidades t4                                                                                                                   "& vbCrLf &_
"                        where  tt.pers_ncorr = a.pers_ncorr                                                                                                        "& vbCrLf &_
"                               and tt.ofer_ncorr = t2.ofer_ncorr                                                                                                   "& vbCrLf &_
"                               and t2.peri_ccod = t3.peri_ccod                                                                                                     "& vbCrLf &_
"                               and t2.espe_ccod = t4.espe_ccod                                                                                                     "& vbCrLf &_
"                               and t3.anos_ccod = '2014'                                                                                                           "& vbCrLf &_
"                               and tt.emat_ccod <> 9                                                                                                               "& vbCrLf &_
"                        order  by t3.peri_ccod desc) as sede_ccod_2014                                                                                             "& vbCrLf &_
"                from   personas a                                                                                                                                  "& vbCrLf &_
"                where  pers_nrut = '"&var_rut&"')table1--TABLE_1-----------<<                                                                                           "& vbCrLf &_
"		)table2                                                                                                                                                     "& vbCrLf &_
"where  table2.carrera is not null                                                                                                                                  "& vbCrLf &_
"                                                                                                                                                                   "& vbCrLf &_
") as b                                                                                                                                                             "& vbCrLf &_
"on a.rut = b.rut                                                                                                                                                   "

'------------------------------------DEBUG>>
'RESPONSE.WRITE("<PRE>"&consulta&"</PRE>")
'RESPONSE.END()		
'------------------------------------DEBUG<<
f_personas_2.Consultar consulta
f_personas_2.siguiente
%>

	<tr>
		<td><%response.write(contador)%> </td>	
		<td><%response.write(f_personas_2.obtenerValor("RUT" )&" - "&f_personas_2.obtenerValor("DV" ) )%> </td>	
		<td><%response.write(f_personas_2.obtenerValor("NOMBRE_COMPLETO" ))%> </td>	
		<td><%response.write(f_personas_2.obtenerValor("tipo" ))%> </td>
		<td><%response.write(f_personas_2.obtenerValor("CARRERA" ))%> </td>	
		<td><%response.write(f_personas_2.obtenerValor("SEDE" ))%> </td>		
		<td><%response.write(f_personas_2.obtenerValor("ANO_INGRESO_CARRERA" ))%> </td>
		<td><%response.write(f_personas_2.obtenerValor("EMAIL_PERSONAL" ))%> </td>
		<td><%response.write(f_personas_2.obtenerValor("total_carga" ))%> </td>
		<td><%response.write(f_personas_2.obtenerValor("total_carga_aprobada" ))%> </td>
		<td><%response.write(f_personas_2.obtenerValor("PORCENTAJE_APROBACION" ))%> </td>
	</tr>

<%	
contador = contador + 1
wend
%>
</table>
</body>
</html>



