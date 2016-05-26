<!-- #include file = "../biblioteca/_conexion.asp" -->
<!-- #include file = "../biblioteca/_negocio.asp" -->

<%
Response.AddHeader "Content-Disposition", "attachment;filename=cantidad_hora_de_docente_por_sede_y_grado.xls"
Response.ContentType = "application/vnd.ms-excel"
Server.ScriptTimeOut = 4500000
set conexion = new CConexion
conexion.Inicializar "upacifico"
set negocio = new CNegocio
negocio.Inicializa conexion
'-----------------------------------------------------------------------
peri_ccod=request.QueryString("peri_ccod")
tido_ccod=request.QueryString("tido_ccod")
sede_ccod=request.QueryString("sede_ccod")
tcar_ccod=request.QueryString("tcar_ccod")

'------------------------------------------------------------------------------------


'--------------------------------listado general de docentes (datos reales)--------------------------------


'response.write("<br/>peri_ccod="&peri_ccod&"<br/>")
'response.write("<br/>tido_ccod="&tido_ccod&"<br/>")
response.write("<br/>sede_ccod="&sede_ccod&"<br/>")
'response.write("<br/>tcar_ccod="&tcar_ccod&"<br/>")
'response.End()
'peri_ccod=210
'tcar_ccod=1
'tido_ccod=3
'sede_ccod=2
 if sede_ccod = "0" then
	

  	filtro=filtro&"and sede_ccod in (1,2,4,8)"
  					
end if
 if sede_ccod = "1" then
	

  	filtro=filtro&"and sede_ccod in (1,2,8)"
  					
end if
 if sede_ccod = "4" then
	

  	filtro=filtro&"and sede_ccod =4"
  					
end if

 if tido_ccod <> "0" then

filtro2=filtro2&"and tido_ccod="&tido_ccod&""

end if
 if tido_ccod = "0" then

filtro2=filtro2&"and tido_ccod in (1,3)"

end if


 if tcar_ccod <> "0" then

filtro3=filtro3&"and tcar_ccod="&tcar_ccod&""

end if


tcar_tdesc=conexion.ConsultaUno("select tcar_tdesc from tipos_carrera where tcar_ccod="&tcar_ccod&"")
tido_tdesc=conexion.ConsultaUno("select tido_tdesc from tipos_docente where tido_ccod="&tido_ccod&"")
sede=conexion.ConsultaUno("select sede_tdesc from sedes where sede_ccod="&sede_ccod&"")
periodo_academico=conexion.ConsultaUno("select lower(peri_tdesc) from periodos_academicos where peri_ccod="&peri_ccod&"")
'response.End()
ano=conexion.ConsultaUno("select anos_ccod from periodos_academicos where peri_ccod="&peri_ccod&"")
'response.write(sede)
'response.End()
 set f_docentes_doctorado_1_19_M = new CFormulario
 f_docentes_doctorado_1_19_M.Carga_Parametros "tabla_vacia.xml", "tabla" 
 f_docentes_doctorado_1_19_M.Inicializar conexion
 'response.End()
 
profesores_doctores_1_19_M="select isnull(count(pers_ncorr),0)as cantidad_profesores_1_a_19_MASCULINO,isnull(sum(horas),0)as profesores_1_a_19_MASCULINO"& vbCrLf &_
"from(select pers_ncorr, case when tido_ccod=3 then ((45-sum(cast(horas as numeric)))+sum(cast(horas as numeric))) else sum(horas) end as horas from horas_docente_totales_semestre"& vbCrLf &_
"where sexo=1"& vbCrLf &_
"and titulo_grado_obtenido='DOCTORADO'"& vbCrLf &_
"and peri_ccod="&peri_ccod&""& vbCrLf &_
" " &filtro&" "& vbCrLf &_
" " &filtro2&" "& vbCrLf &_
" " &filtro3&" "& vbCrLf &_
"group by pers_ncorr,tido_ccod)pp"& vbCrLf &_
"where  horas between 1 and 19"


 
'response.Write("<pre>"&profesores_doctores_1_19_M&"</pre>")
'response.end()
f_docentes_doctorado_1_19_M.Consultar profesores_doctores_1_19_M
f_docentes_doctorado_1_19_M.siguiente

'-----------------------------------------------------------------------------------------------------------------------------------------

 set f_docentes_doctorado_1_19_F = new CFormulario
 f_docentes_doctorado_1_19_F.Carga_Parametros "tabla_vacia.xml", "tabla" 
f_docentes_doctorado_1_19_F.Inicializar conexion
 
 profesores_doctores_1_19_F="select isnull(count(pers_ncorr),0)as cantidad_profesores_1_a_19_FEMENINO,isnull(sum(horas),0)as profesores_1_a_19_FEMENINO"& vbCrLf &_
"from(select pers_ncorr, case when tido_ccod=3 then ((45-sum(cast(horas as numeric)))+sum(cast(horas as numeric))) else sum(horas) end as horas from horas_docente_totales_semestre"& vbCrLf &_
"where sexo=2"& vbCrLf &_
"and titulo_grado_obtenido='DOCTORADO'"& vbCrLf &_
"and peri_ccod=" &peri_ccod&""& vbCrLf &_
" " &filtro&" "& vbCrLf &_
" " &filtro2&" "& vbCrLf &_
" " &filtro3&" "& vbCrLf &_
"group by pers_ncorr,tido_ccod)pp"& vbCrLf &_
"where  horas between 1 and 19"

 
f_docentes_doctorado_1_19_F.Consultar profesores_doctores_1_19_F
f_docentes_doctorado_1_19_F.siguiente
'response.Write("<pre>"&profesores_doctores_1_19_F&"</pre>")

'-----------------------------------------------------------------------------------------------------------------------------------------

set f_docentes_doctorado_20_32_M = new CFormulario
 f_docentes_doctorado_20_32_M.Carga_Parametros "tabla_vacia.xml", "tabla" 
 f_docentes_doctorado_20_32_M.Inicializar conexion
 'response.End()
profesores_doctores_20_32_M="select isnull(count(pers_ncorr),0)as cantidad_profesores_20_a_32_MASCULINO ,isnull(sum(horas),0)as profesores_20_a_32_MASCULINO"& vbCrLf &_
"from(select pers_ncorr, case when tido_ccod=3 then ((45-sum(cast(horas as numeric)))+sum(cast(horas as numeric))) else sum(horas) end as horas from horas_docente_totales_semestre"& vbCrLf &_
"where sexo=1"& vbCrLf &_
"and titulo_grado_obtenido='DOCTORADO'"& vbCrLf &_
"and peri_ccod=" &peri_ccod&""& vbCrLf &_
" " &filtro&" "& vbCrLf &_
" " &filtro2&" "& vbCrLf &_
" " &filtro3&" "& vbCrLf &_
"group by pers_ncorr,tido_ccod)pp"& vbCrLf &_
"where  horas between 20 and 32" 
'response.Write("<pre>"&profesores_doctores_20_32_M&"</pre>")
'response.end()
f_docentes_doctorado_20_32_M.Consultar profesores_doctores_20_32_M
f_docentes_doctorado_20_32_M.siguiente

'-----------------------------------------------------------------------------------------------------------------------------------------

 set f_docentes_doctorado_20_32_F = new CFormulario
 f_docentes_doctorado_20_32_F.Carga_Parametros "tabla_vacia.xml", "tabla" 
 f_docentes_doctorado_20_32_F.Inicializar conexion
 
 profesores_doctores_20_32_F="select isnull(count(pers_ncorr),0)as cantidad_profesores_20_a_32_FEMENINO,isnull(sum(horas),0)as profesores_20_a_32_FEMENINO"& vbCrLf &_
"from(select pers_ncorr, case when tido_ccod=3 then ((45-sum(cast(horas as numeric)))+sum(cast(horas as numeric))) else sum(horas) end as horas from horas_docente_totales_semestre"& vbCrLf &_
"where sexo=2"& vbCrLf &_
"and titulo_grado_obtenido='DOCTORADO'"& vbCrLf &_
"and peri_ccod=" &peri_ccod&""& vbCrLf &_
" " &filtro&" "& vbCrLf &_
" " &filtro2&" "& vbCrLf &_
" " &filtro3&" "& vbCrLf &_
"group by pers_ncorr,tido_ccod)pp"& vbCrLf &_
"where  horas between 20 and 32"

 
f_docentes_doctorado_20_32_F.Consultar profesores_doctores_20_32_F
f_docentes_doctorado_20_32_F.siguiente
'response.Write("<pre>"&profesores_doctores_20_32_F&"</pre>")

'-----------------------------------------------------------------------------------------------------------------------------------------

set f_docentes_doctorado_33_44_M = new CFormulario
 f_docentes_doctorado_33_44_M.Carga_Parametros "tabla_vacia.xml", "tabla" 
 f_docentes_doctorado_33_44_M.Inicializar conexion
 'response.End()
profesores__doctorado_33_44_M="select isnull(count(pers_ncorr),0)as cantidad_profesores_33_a_44_MASCULINO ,isnull(sum(horas),0)as profesores_33_a_44_MASCULINO"& vbCrLf &_
"from(select pers_ncorr, case when tido_ccod=3 then ((45-sum(cast(horas as numeric)))+sum(cast(horas as numeric))) else sum(horas) end as horas from horas_docente_totales_semestre"& vbCrLf &_
"where sexo=1"& vbCrLf &_
"and titulo_grado_obtenido='DOCTORADO'"& vbCrLf &_
"and peri_ccod=" &peri_ccod&""& vbCrLf &_
" " &filtro&" "& vbCrLf &_
" " &filtro2&" "& vbCrLf &_
" " &filtro3&" "& vbCrLf &_
"group by pers_ncorr,tido_ccod)pp"& vbCrLf &_
"where  horas between 33 and 45" 



'response.end()
f_docentes_doctorado_33_44_M.Consultar profesores__doctorado_33_44_M
f_docentes_doctorado_33_44_M.siguiente
'response.Write("<pre>"&profesores__doctorado_33_44_M&"</pre>")
'-----------------------------------------------------------------------------------------------------------------------------------------

set f_docentes_doctorado_33_44_F = new CFormulario
 f_docentes_doctorado_33_44_F.Carga_Parametros "tabla_vacia.xml", "tabla" 
 f_docentes_doctorado_33_44_F.Inicializar conexion
 
 profesores_doctores_33_44_F="select isnull(count(pers_ncorr),0)as cantidad_profesores_33_a_44_FEMENINO,isnull(sum(horas),0)as profesores_33_a_44_FEMENINO"& vbCrLf &_
"from(select pers_ncorr, case when tido_ccod=3 then ((45-sum(cast(horas as numeric)))+sum(cast(horas as numeric))) else sum(horas) end as horas from horas_docente_totales_semestre"& vbCrLf &_
"where sexo=2"& vbCrLf &_
"and titulo_grado_obtenido='DOCTORADO'"& vbCrLf &_
"and peri_ccod=" &peri_ccod&""& vbCrLf &_
" " &filtro&" "& vbCrLf &_
" " &filtro2&" "& vbCrLf &_
" " &filtro3&" "& vbCrLf &_
"group by pers_ncorr,tido_ccod)pp"& vbCrLf &_
"where  horas between 33 and 45"

 
f_docentes_doctorado_33_44_F.Consultar profesores_doctores_33_44_F
f_docentes_doctorado_33_44_F.siguiente
'response.Write("<pre>"&profesores_doctores_33_44_F&"</pre>")


'-----------------------------------------------------------------------------------------------------------------------------------------


 set f_docentes_magister_1_19_M = new CFormulario
 f_docentes_magister_1_19_M.Carga_Parametros "tabla_vacia.xml", "tabla" 
 f_docentes_magister_1_19_M.Inicializar conexion
 'response.End()
profesores_magister_1_19_M="select isnull(count(pers_ncorr),0)as cantidad_profesores_1_a_19_MASCULINO,isnull(sum(horas),0)as profesores_1_a_19_MASCULINO"& vbCrLf &_
"from(select pers_ncorr, case when tido_ccod=3 then ((45-sum(cast(horas as numeric)))+sum(cast(horas as numeric))) else sum(horas) end as horas from horas_docente_totales_semestre"& vbCrLf &_
"where sexo=1"& vbCrLf &_
"and titulo_grado_obtenido in ('MAGISTER','MAESTRIA')"& vbCrLf &_
"and peri_ccod=" &peri_ccod&""& vbCrLf &_
" " &filtro&" "& vbCrLf &_
" " &filtro2&" "& vbCrLf &_
" " &filtro3&" "& vbCrLf &_
"group by pers_ncorr,tido_ccod)pp"& vbCrLf &_
"where  horas between 1 and 19" 
'response.end()
f_docentes_magister_1_19_M.Consultar profesores_magister_1_19_M
f_docentes_magister_1_19_M.siguiente
'
'response.Write("<pre>"&profesores_magister_1_19_M&"</pre>")

'-----------------------------------------------------------------------------------------------------------------------------------------


 set f_docentes_magister_1_19_F = new CFormulario
 f_docentes_magister_1_19_F.Carga_Parametros "tabla_vacia.xml", "tabla" 
 f_docentes_magister_1_19_F.Inicializar conexion
 'response.End()
profesores_magister_1_19_F="select isnull(count(pers_ncorr),0)as cantidad_profesores_1_a_19_FEMENINO,isnull(sum(horas),0)as profesores_1_a_19_FEMENINO"& vbCrLf &_
"from(select pers_ncorr, case when tido_ccod=3 then ((45-sum(cast(horas as numeric)))+sum(cast(horas as numeric))) else sum(horas) end as horas from horas_docente_totales_semestre"& vbCrLf &_
"where sexo=2"& vbCrLf &_
"and titulo_grado_obtenido in ('MAGISTER','MAESTRIA')"& vbCrLf &_
"and peri_ccod=" &peri_ccod&""& vbCrLf &_
" " &filtro&" "& vbCrLf &_
" " &filtro2&" "& vbCrLf &_
" " &filtro3&" "& vbCrLf &_
"group by pers_ncorr,tido_ccod)pp"& vbCrLf &_
"where  horas between 1 and 19" 
'response.end()
f_docentes_magister_1_19_F.Consultar profesores_magister_1_19_F
f_docentes_magister_1_19_F.siguiente
'response.Write("<pre>"&profesores_magister_1_19_F&"</pre>")


'-----------------------------------------------------------------------------------------------------------------------------------------

'
set f_docentes_magister_20_32_M = new CFormulario
 f_docentes_magister_20_32_M.Carga_Parametros "tabla_vacia.xml", "tabla" 
 f_docentes_magister_20_32_M.Inicializar conexion
 'response.End()
profesores_magister_20_32_M="select isnull(count(pers_ncorr),0)as cantidad_profesores_20_a_32_MASCULINO,isnull(sum(horas),0)as profesores_20_a_32_MASCULINO"& vbCrLf &_
"from(select pers_ncorr, case when tido_ccod=3 then ((45-sum(cast(horas as numeric)))+sum(cast(horas as numeric))) else sum(horas) end as horas from horas_docente_totales_semestre"& vbCrLf &_
"where sexo=1"& vbCrLf &_
"and titulo_grado_obtenido in ('MAGISTER','MAESTRIA')"& vbCrLf &_
"and peri_ccod=" &peri_ccod&""& vbCrLf &_
" " &filtro&" "& vbCrLf &_
" " &filtro2&" "& vbCrLf &_
" " &filtro3&" "& vbCrLf &_
"group by pers_ncorr,tido_ccod)pp"& vbCrLf &_
"where  horas between 20 and 32"
'response.end()
f_docentes_magister_20_32_M.Consultar profesores_magister_20_32_M
f_docentes_magister_20_32_M.siguiente
'response.end()
'response.Write("<pre>"&profesores_magister_20_32_M&"</pre>")

''-----------------------------------------------------------------------------------------------------------------------------------------

'
set f_docentes_magister_20_32_F = new CFormulario
 f_docentes_magister_20_32_F.Carga_Parametros "tabla_vacia.xml", "tabla" 
 f_docentes_magister_20_32_F.Inicializar conexion
 'response.End()
profesores_magister_20_32_F="select isnull(count(pers_ncorr),0)as cantidad_profesores_20_a_32_FEMENINO,isnull(sum(horas),0)as profesores_20_a_32_FEMENINO"& vbCrLf &_
"from(select pers_ncorr, case when tido_ccod=3 then ((45-sum(cast(horas as numeric)))+sum(cast(horas as numeric))) else sum(horas) end as horas from horas_docente_totales_semestre"& vbCrLf &_
"where sexo=2"& vbCrLf &_
"and titulo_grado_obtenido in ('MAGISTER','MAESTRIA')"& vbCrLf &_
"and peri_ccod=" &peri_ccod&""& vbCrLf &_
" " &filtro&" "& vbCrLf &_
" " &filtro2&" "& vbCrLf &_
" " &filtro3&" "& vbCrLf &_
"group by pers_ncorr,tido_ccod)pp"& vbCrLf &_
"where  horas between 20 and 32"
'response.end()
f_docentes_magister_20_32_F.Consultar profesores_magister_20_32_F
f_docentes_magister_20_32_F.siguiente
'response.Write("<pre>"&profesores_magister_20_32_F&"</pre>")

''-----------------------------------------------------------------------------------------------------------------------------------------

set f_docentes_magister_33_44_M = new CFormulario
 f_docentes_magister_33_44_M.Carga_Parametros "tabla_vacia.xml", "tabla"
 f_docentes_magister_33_44_M.Inicializar conexion
 'response.End()
profesores_magister_33_44_M="select isnull(count(pers_ncorr),0)as cantidad_profesores_33_a_44_MASCULINO,isnull(sum(horas),0)as profesores_33_a_44_MASCULINO"& vbCrLf &_
"from(select pers_ncorr, case when tido_ccod=3 then ((45-sum(cast(horas as numeric)))+sum(cast(horas as numeric))) else sum(horas) end as horas from horas_docente_totales_semestre"& vbCrLf &_
"where sexo=1"& vbCrLf &_
"and titulo_grado_obtenido in ('MAGISTER','MAESTRIA')"& vbCrLf &_
"and peri_ccod=" &peri_ccod&""& vbCrLf &_
" " &filtro&" "& vbCrLf &_
" " &filtro2&" "& vbCrLf &_
" " &filtro3&" "& vbCrLf &_
"group by pers_ncorr,tido_ccod)pp"& vbCrLf &_
"where  horas between 33 and 45"
'response.end()
f_docentes_magister_33_44_M.Consultar profesores_magister_33_44_M
f_docentes_magister_33_44_M.siguiente
'response.Write("<pre>"&profesores_magister_33_44_M&"</pre>")

'
'-----------------------------------------------------------------------------------------------------------------------------------------
set f_docentes_magister_33_44_F = new CFormulario
 f_docentes_magister_33_44_F.Carga_Parametros "tabla_vacia.xml", "tabla"
 f_docentes_magister_33_44_F.Inicializar conexion
 'response.End()
profesores_magister_33_44_F="select isnull(count(pers_ncorr),0)as cantidad_profesores_33_a_44_FEMENINO,isnull(sum(horas),0)as profesores_33_a_44_FEMENINO"& vbCrLf &_
"from(select pers_ncorr, case when tido_ccod=3 then ((45-sum(cast(horas as numeric)))+sum(cast(horas as numeric))) else sum(horas) end as horas from horas_docente_totales_semestre"& vbCrLf &_
"where sexo=2"& vbCrLf &_
"and titulo_grado_obtenido in ('MAGISTER','MAESTRIA')"& vbCrLf &_
"and peri_ccod=" &peri_ccod&""& vbCrLf &_
" " &filtro&" "& vbCrLf &_
" " &filtro2&" "& vbCrLf &_
" " &filtro3&" "& vbCrLf &_
"group by pers_ncorr,tido_ccod)pp"& vbCrLf &_
"where  horas between 33 and 45"
'response.end()
f_docentes_magister_33_44_F.Consultar profesores_magister_33_44_F
f_docentes_magister_33_44_F.siguiente
'response.Write("<pre>"&profesores_magister_33_44_F&"</pre>")

'

'-----------------------------------------------------------------------------------------------------------------------------------------

set f_docentes_licenciado_1_19_M = new CFormulario
 f_docentes_licenciado_1_19_M.Carga_Parametros "tabla_vacia.xml", "tabla" 
 f_docentes_licenciado_1_19_M.Inicializar conexion
 'response.End()
profesores_licenciado_1_19_M="select isnull(count(pers_ncorr),0)as cantidad_profesores_1_a_19_MASCULINO,isnull(sum(horas),0)as profesores_1_a_19_MASCULINO"& vbCrLf &_
"from(select pers_ncorr, case when tido_ccod=3 then ((45-sum(cast(horas as numeric)))+sum(cast(horas as numeric))) else sum(horas) end as horas from horas_docente_totales_semestre"& vbCrLf &_
"where sexo=1"& vbCrLf &_
"and titulo_grado_obtenido='LICENCIADO'"& vbCrLf &_
"and peri_ccod=" &peri_ccod&""& vbCrLf &_
" " &filtro&" "& vbCrLf &_
" " &filtro2&" "& vbCrLf &_
" " &filtro3&" "& vbCrLf &_
"group by pers_ncorr,tido_ccod)pp"& vbCrLf &_
"where  horas between 1 and 19" 

'response.end()
f_docentes_licenciado_1_19_M.Consultar profesores_licenciado_1_19_M
f_docentes_licenciado_1_19_M.siguiente
'response.Write("<pre>"&profesores_licenciado_1_19_M&"</pre>")

'-----------------------------------------------------------------------------------------------------------------------------------------

set f_docentes_licenciado_1_19_F = new CFormulario
 f_docentes_licenciado_1_19_F.Carga_Parametros "tabla_vacia.xml", "tabla" 
 f_docentes_licenciado_1_19_F.Inicializar conexion
 'response.End()
profesores_licenciado_1_19_F="select isnull(count(pers_ncorr),0)as cantidad_profesores_1_a_19_FEMENINO,isnull(sum(horas),0)as profesores_1_a_19_FEMENINO"& vbCrLf &_
"from(select pers_ncorr, case when tido_ccod=3 then ((45-sum(cast(horas as numeric)))+sum(cast(horas as numeric))) else sum(horas) end as horas from horas_docente_totales_semestre"& vbCrLf &_
"where sexo=2"& vbCrLf &_
"and titulo_grado_obtenido='LICENCIADO'"& vbCrLf &_
"and peri_ccod=" &peri_ccod&""& vbCrLf &_
" " &filtro&" "& vbCrLf &_
" " &filtro2&" "& vbCrLf &_
" " &filtro3&" "& vbCrLf &_
"group by pers_ncorr,tido_ccod)pp"& vbCrLf &_
"where  horas between 1 and 19"
'response.end()
f_docentes_licenciado_1_19_F.Consultar profesores_licenciado_1_19_F
f_docentes_licenciado_1_19_F.siguiente
'response.Write("<pre>"&profesores_licenciado_1_19_F&"</pre>")

'-----------------------------------------------------------------------------------------------------------------------------------------
set f_docentes_licenciado_20_32_M = new CFormulario
 f_docentes_licenciado_20_32_M.Carga_Parametros "tabla_vacia.xml", "tabla" 
 f_docentes_licenciado_20_32_M.Inicializar conexion
 'response.End()
profesores_licenciado_20_32_M="select isnull(count(pers_ncorr),0)as cantidad_profesores_20_a_32_MASCULINO,isnull(sum(horas),0)as profesores_20_a_32_MASCULINO"& vbCrLf &_
"from(select pers_ncorr, case when tido_ccod=3 then ((45-sum(cast(horas as numeric)))+sum(cast(horas as numeric))) else sum(horas) end as horas from horas_docente_totales_semestre"& vbCrLf &_
"where sexo=1"& vbCrLf &_
"and titulo_grado_obtenido='LICENCIADO'"& vbCrLf &_
"and peri_ccod=" &peri_ccod&""& vbCrLf &_
" " &filtro&" "& vbCrLf &_
" " &filtro2&" "& vbCrLf &_
" " &filtro3&" "& vbCrLf &_
"group by pers_ncorr,tido_ccod)pp"& vbCrLf &_
"where  horas between 20 and 32"

 

'response.end()
f_docentes_licenciado_20_32_M.Consultar profesores_licenciado_20_32_M
f_docentes_licenciado_20_32_M.siguiente
'response.Write("<pre>"&profesores_licenciado_20_32_M&"</pre>")

'-----------------------------------------------------------------------------------------------------------------------------------------
set f_docentes_licenciado_20_32_F = new CFormulario
 f_docentes_licenciado_20_32_F.Carga_Parametros "tabla_vacia.xml", "tabla" 
 f_docentes_licenciado_20_32_F.Inicializar conexion
 'response.End()
profesores_licenciado_20_32_F="select isnull(count(pers_ncorr),0)as cantidad_profesores_20_a_32_FEMENINO,isnull(sum(horas),0)as profesores_20_a_32_FEMENINO"& vbCrLf &_
"from(select pers_ncorr, case when tido_ccod=3 then ((45-sum(cast(horas as numeric)))+sum(cast(horas as numeric))) else sum(horas) end as horas from horas_docente_totales_semestre"& vbCrLf &_
"where sexo=2"& vbCrLf &_
"and titulo_grado_obtenido='LICENCIADO'"& vbCrLf &_
"and peri_ccod=" &peri_ccod&""& vbCrLf &_
" " &filtro&" "& vbCrLf &_
" " &filtro2&" "& vbCrLf &_
" " &filtro3&" "& vbCrLf &_
"group by pers_ncorr,tido_ccod)pp"& vbCrLf &_
"where  horas between 20 and 32"
'response.end()
f_docentes_licenciado_20_32_F.Consultar profesores_licenciado_20_32_F
f_docentes_licenciado_20_32_F.siguiente
'response.Write("<pre>"&profesores_licenciado_20_32_F&"</pre>")

'-----------------------------------------------------------------------------------------------------------------------------------------
'
'
set f_docentes_licenciado_33_44_M = new CFormulario
 f_docentes_licenciado_33_44_M.Carga_Parametros "tabla_vacia.xml", "tabla" 
 f_docentes_licenciado_33_44_M.Inicializar conexion
 'response.End()
profesores_licenciado_33_44_M="select isnull(count(pers_ncorr),0)as cantidad_profesores_33_a_44_MASCULINO,isnull(sum(horas),0)as profesores_33_a_44_MASCULINO"& vbCrLf &_
"from(select pers_ncorr, case when tido_ccod=3 then ((45-sum(cast(horas as numeric)))+sum(cast(horas as numeric))) else sum(horas) end as horas from horas_docente_totales_semestre"& vbCrLf &_
"where sexo=1"& vbCrLf &_
"and titulo_grado_obtenido='LICENCIADO'"& vbCrLf &_
"and peri_ccod=" &peri_ccod&""& vbCrLf &_
" " &filtro&" "& vbCrLf &_
" " &filtro2&" "& vbCrLf &_
" " &filtro3&" "& vbCrLf &_
"group by pers_ncorr,tido_ccod)pp"& vbCrLf &_
"where  horas between 33 and 45" 
'response.end()
f_docentes_licenciado_33_44_M.Consultar profesores_licenciado_33_44_M
f_docentes_licenciado_33_44_M.siguiente
'response.Write("<pre>"&profesores_licenciado_33_44_M&"</pre>")


''-----------------------------------------------------------------------------------------------------------------------------------------

set f_docentes_licenciado_33_44_F = new CFormulario
 f_docentes_licenciado_33_44_F.Carga_Parametros "tabla_vacia.xml", "tabla" 
 f_docentes_licenciado_33_44_F.Inicializar conexion

profesores_licenciado_33_44_F="select isnull(count(pers_ncorr),0)as cantidad_profesores_33_a_44_FEMENINO,isnull(sum(horas),0)as profesores_33_a_44_FEMENINO"& vbCrLf &_
"from(select pers_ncorr, case when tido_ccod=3 then ((45-sum(cast(horas as numeric)))+sum(cast(horas as numeric))) else sum(horas) end as horas from horas_docente_totales_semestre"& vbCrLf &_
"where sexo=2"& vbCrLf &_
"and titulo_grado_obtenido='LICENCIADO'"& vbCrLf &_
"and peri_ccod=" &peri_ccod&""& vbCrLf &_
" " &filtro&" "& vbCrLf &_
" " &filtro2&" "& vbCrLf &_
" " &filtro3&" "& vbCrLf &_
"group by pers_ncorr,tido_ccod)pp"& vbCrLf &_
"where  horas between 33 and 45"
f_docentes_licenciado_33_44_F.Consultar profesores_licenciado_33_44_F
f_docentes_licenciado_33_44_F.siguiente
'response.Write("<pre>"&profesores_licenciado_33_44_F&"</pre>")

''-----------------------------------------------------------------------------------------------------------------------------------------

set f_docentes_profesional_1_19_M = new CFormulario
 f_docentes_profesional_1_19_M.Carga_Parametros "tabla_vacia.xml", "tabla" 
 f_docentes_profesional_1_19_M.Inicializar conexion
 'response.End()
profesores_licenciado_1_19_M="select isnull(count(pers_ncorr),0)as cantidad_profesores_1_a_19_MASCULINO,isnull(sum(horas),0)as profesores_1_a_19_MASCULINO"& vbCrLf &_
"from(select pers_ncorr, case when tido_ccod=3 then ((45-sum(cast(horas as numeric)))+sum(cast(horas as numeric))) else sum(horas) end as horas from horas_docente_totales_semestre"& vbCrLf &_
"where sexo=1"& vbCrLf &_
"and titulo_grado_obtenido='PROFESIONAL'"& vbCrLf &_
"and peri_ccod=" &peri_ccod&""& vbCrLf &_
" " &filtro&" "& vbCrLf &_
" " &filtro2&" "& vbCrLf &_
" " &filtro3&" "& vbCrLf &_
"group by pers_ncorr,tido_ccod)pp"& vbCrLf &_
"where  horas between 1 and 19"
'response.Write("<pre>"&profesores_licenciado_20_32&"</pre>")
'response.end()
f_docentes_profesional_1_19_M.Consultar profesores_licenciado_1_19_M
f_docentes_profesional_1_19_M.siguiente
'response.Write("<pre>"&profesores_licenciado_1_19_M&"</pre>")

'-----------------------------------------------------------------------------------------------------------------------------------------
set f_docentes_profesional_1_19_F = new CFormulario
 f_docentes_profesional_1_19_F.Carga_Parametros "tabla_vacia.xml", "tabla" 
 f_docentes_profesional_1_19_F.Inicializar conexion
 'response.End()
profesores_licenciado_1_19_F="select isnull(count(pers_ncorr),0)as cantidad_profesores_1_a_19_FEMENINO,isnull(sum(horas),0)as profesores_1_a_19_FEMENINO"& vbCrLf &_
"from(select pers_ncorr, case when tido_ccod=3 then ((45-sum(cast(horas as numeric)))+sum(cast(horas as numeric))) else sum(horas) end as horas from horas_docente_totales_semestre"& vbCrLf &_
"where sexo=2"& vbCrLf &_
"and titulo_grado_obtenido='PROFESIONAL'"& vbCrLf &_
"and peri_ccod=" &peri_ccod&""& vbCrLf &_
" " &filtro&" "& vbCrLf &_
" " &filtro2&" "& vbCrLf &_
" " &filtro3&" "& vbCrLf &_
"group by pers_ncorr,tido_ccod)pp"& vbCrLf &_
"where  horas between 1 and 19"

'response.end()
f_docentes_profesional_1_19_F.Consultar profesores_licenciado_1_19_F
f_docentes_profesional_1_19_F.siguiente
'response.Write("<pre>"&profesores_licenciado_1_19_F&"</pre>")
'-----------------------------------------------------------------------------------------------------------------------------------------

set f_docentes_profesional_20_32_M = new CFormulario
 f_docentes_profesional_20_32_M.Carga_Parametros "tabla_vacia.xml", "tabla" 
 f_docentes_profesional_20_32_M.Inicializar conexion
 'response.End()
profesores_licenciado_20_32_M="select isnull(count(pers_ncorr),0)as cantidad_profesores_20_a_32_MASCULINO,isnull(sum(horas),0)as profesores_20_a_32_MASCULINO"& vbCrLf &_
"from(select pers_ncorr, case when tido_ccod=3 then ((45-sum(cast(horas as numeric)))+sum(cast(horas as numeric))) else sum(horas) end as horas from horas_docente_totales_semestre"& vbCrLf &_
"where sexo=1"& vbCrLf &_
"and titulo_grado_obtenido='PROFESIONAL'"& vbCrLf &_
"and peri_ccod=" &peri_ccod&""& vbCrLf &_
" " &filtro&" "& vbCrLf &_
" " &filtro2&" "& vbCrLf &_
" " &filtro3&" "& vbCrLf &_
"group by pers_ncorr,tido_ccod)pp"& vbCrLf &_
"where  horas between 20 and 32" 
'response.end()
f_docentes_profesional_20_32_M.Consultar profesores_licenciado_20_32_M
f_docentes_profesional_20_32_M.siguiente
'response.Write("<pre>"&profesores_licenciado_20_32_M&"</pre>")

'-----------------------------------------------------------------------------------------------------------------------------------------

set f_docentes_profesional_20_32_F = new CFormulario
 f_docentes_profesional_20_32_F.Carga_Parametros "tabla_vacia.xml", "tabla" 
 f_docentes_profesional_20_32_F.Inicializar conexion
 'response.End()
profesores_licenciado_20_32_F="select isnull(count(pers_ncorr),0)as cantidad_profesores_20_a_32_FEMENINO,isnull(sum(horas),0)as profesores_20_a_32_FEMENINO"& vbCrLf &_
"from(select pers_ncorr, case when tido_ccod=3 then ((45-sum(cast(horas as numeric)))+sum(cast(horas as numeric))) else sum(horas) end as horas from horas_docente_totales_semestre"& vbCrLf &_
"where sexo=2"& vbCrLf &_
"and titulo_grado_obtenido='PROFESIONAL'"& vbCrLf &_
"and peri_ccod=" &peri_ccod&""& vbCrLf &_
" " &filtro&" "& vbCrLf &_
" " &filtro2&" "& vbCrLf &_
" " &filtro3&" "& vbCrLf &_
"group by pers_ncorr,tido_ccod)pp"& vbCrLf &_
"where  horas between 20 and 32" 
'response.end()
f_docentes_profesional_20_32_F.Consultar profesores_licenciado_20_32_F
f_docentes_profesional_20_32_F.siguiente
'response.Write("<pre>"&profesores_licenciado_20_32_F&"</pre>")

''-----------------------------------------------------------------------------------------------------------------------------------------

set f_docentes_profesional_33_44_M = new CFormulario
 f_docentes_profesional_33_44_M.Carga_Parametros "tabla_vacia.xml", "tabla" 
 f_docentes_profesional_33_44_M.Inicializar conexion
 'response.End()
profesores_profesional_33_44_M="select isnull(count(pers_ncorr),0)as cantidad_profesores_33_a_44_MASCULINO,isnull(sum(horas),0)as profesores_33_a_44_MASCULINO"& vbCrLf &_
"from(select pers_ncorr, case when tido_ccod=3 then ((45-sum(cast(horas as numeric)))+sum(cast(horas as numeric))) else sum(horas) end as horas from horas_docente_totales_semestre"& vbCrLf &_
"where sexo=1"& vbCrLf &_
"and titulo_grado_obtenido='PROFESIONAL'"& vbCrLf &_
"and peri_ccod=" &peri_ccod&""& vbCrLf &_
" " &filtro&" "& vbCrLf &_
" " &filtro2&" "& vbCrLf &_
" " &filtro3&" "& vbCrLf &_
"group by pers_ncorr,tido_ccod)pp"& vbCrLf &_
"where  horas between 33 and 45"
'response.end()
f_docentes_profesional_33_44_M.Consultar profesores_profesional_33_44_M
f_docentes_profesional_33_44_M.siguiente
'response.Write("<pre>"&profesores_profesional_33_44_M&"</pre>")

''-----------------------------------------------------------------------------------------------------------------------------------------

set f_docentes_profesional_33_44_F = new CFormulario
 f_docentes_profesional_33_44_F.Carga_Parametros "tabla_vacia.xml", "tabla" 
 f_docentes_profesional_33_44_F.Inicializar conexion
 'response.End()
profesores_profesional_33_44_F="select isnull(count(pers_ncorr),0)as cantidad_profesores_33_a_44_FEMENINO,isnull(sum(horas),0)as profesores_33_a_44_FEMENINO"& vbCrLf &_
"from(select pers_ncorr, case when tido_ccod=3 then ((45-sum(cast(horas as numeric)))+sum(cast(horas as numeric))) else sum(horas) end as horas from horas_docente_totales_semestre"& vbCrLf &_
"where sexo=2"& vbCrLf &_
"and titulo_grado_obtenido='PROFESIONAL'"& vbCrLf &_
"and peri_ccod=" &peri_ccod&""& vbCrLf &_
" " &filtro&" "& vbCrLf &_
" " &filtro2&" "& vbCrLf &_
" " &filtro3&" "& vbCrLf &_
"group by pers_ncorr,tido_ccod)pp"& vbCrLf &_
"where  horas between 33 and 45"
'response.end()
f_docentes_profesional_33_44_F.Consultar profesores_profesional_33_44_F
f_docentes_profesional_33_44_F.siguiente
'response.Write("<pre>"&profesores_profesional_33_44_F&"</pre>")

'-----------------------------------------------------------------------------------------------------------------------------------------

'
'
set f_docentes_tecnico_1_19_M = new CFormulario
 f_docentes_tecnico_1_19_M.Carga_Parametros "tabla_vacia.xml", "tabla" 
 f_docentes_tecnico_1_19_M.Inicializar conexion
 'response.End()
profesores_tecnico_1_19_M="select isnull(count(pers_ncorr),0)as cantidad_profesores_1_a_19_MASCULINO,isnull(sum(horas),0)as profesores_1_a_19_MASCULINO"& vbCrLf &_
"from(select pers_ncorr, case when tido_ccod=3 then ((45-sum(cast(horas as numeric)))+sum(cast(horas as numeric))) else sum(horas) end as horas from horas_docente_totales_semestre"& vbCrLf &_
"where sexo=1"& vbCrLf &_
"and titulo_grado_obtenido='TECNICO'"& vbCrLf &_
"and peri_ccod=" &peri_ccod&""& vbCrLf &_
" " &filtro&" "& vbCrLf &_
" " &filtro2&" "& vbCrLf &_
" " &filtro3&" "& vbCrLf &_
"group by pers_ncorr,tido_ccod)pp"& vbCrLf &_
"where  horas between 1 and 19"
 
'response.end()
f_docentes_tecnico_1_19_M.Consultar profesores_tecnico_1_19_M
f_docentes_tecnico_1_19_M.siguiente
'response.Write("<pre>"&profesores_tecnico_1_19_M&"</pre>")

'-----------------------------------------------------------------------------------------------------------------------------------------
'
set f_docentes_tecnico_1_19_F = new CFormulario
 f_docentes_tecnico_1_19_F.Carga_Parametros "tabla_vacia.xml", "tabla" 
 f_docentes_tecnico_1_19_F.Inicializar conexion
 'response.End()
profesores_tecnico_1_19_F="select isnull(count(pers_ncorr),0)as cantidad_profesores_1_a_19_FEMENINO,isnull(sum(horas),0)as profesores_1_a_19_FEMENINO"& vbCrLf &_
"from(select pers_ncorr, case when tido_ccod=3 then ((45-sum(cast(horas as numeric)))+sum(cast(horas as numeric))) else sum(horas) end as horas from horas_docente_totales_semestre"& vbCrLf &_
"where sexo=2"& vbCrLf &_
"and titulo_grado_obtenido='TECNICO'"& vbCrLf &_
"and peri_ccod=" &peri_ccod&""& vbCrLf &_
" " &filtro&" "& vbCrLf &_
" " &filtro2&" "& vbCrLf &_
" " &filtro3&" "& vbCrLf &_
"group by pers_ncorr,tido_ccod)pp"& vbCrLf &_
"where  horas between 1 and 19"
'response.end()
f_docentes_tecnico_1_19_F.Consultar profesores_tecnico_1_19_F
f_docentes_tecnico_1_19_F.siguiente
'response.Write("<pre>"&profesores_tecnico_1_19_F&"</pre>")

'-----------------------------------------------------------------------------------------------------------------------------------------

'
set f_docentes_tecnico_20_32_M = new CFormulario
 f_docentes_tecnico_20_32_M.Carga_Parametros "tabla_vacia.xml", "tabla" 
 f_docentes_tecnico_20_32_M.Inicializar conexion
 'response.End()
profesores_tecnico_20_32_M="select isnull(count(pers_ncorr),0)as cantidad_profesores_20_a_32_MASCULINO,isnull(sum(horas),0)as profesores_20_a_32_MASCULINO"& vbCrLf &_
"from(select pers_ncorr, case when tido_ccod=3 then ((45-sum(cast(horas as numeric)))+sum(cast(horas as numeric))) else sum(horas) end as horas from horas_docente_totales_semestre"& vbCrLf &_
"where sexo=1"& vbCrLf &_
"and titulo_grado_obtenido='TECNICO'"& vbCrLf &_
"and peri_ccod=" &peri_ccod&""& vbCrLf &_
" " &filtro&" "& vbCrLf &_
" " &filtro2&" "& vbCrLf &_
" " &filtro3&" "& vbCrLf &_
"group by pers_ncorr,tido_ccod)pp"& vbCrLf &_
"where  horas between 20 and 32" 
'response.end()
f_docentes_tecnico_20_32_M.Consultar profesores_tecnico_20_32_M
f_docentes_tecnico_20_32_M.siguiente
'response.Write("<pre>"&profesores_tecnico_20_32_M&"</pre>")

''-----------------------------------------------------------------------------------------------------------------------------------------
set f_docentes_tecnico_20_32_F = new CFormulario
 f_docentes_tecnico_20_32_F.Carga_Parametros "tabla_vacia.xml", "tabla" 
 f_docentes_tecnico_20_32_F.Inicializar conexion
 'response.End()
profesores_tecnico_20_32_F="select isnull(count(pers_ncorr),0)as cantidad_profesores_20_a_32_FEMENINO,isnull(sum(horas),0)as profesores_20_a_32_FEMENINO"& vbCrLf &_
"from(select pers_ncorr, case when tido_ccod=3 then ((45-sum(cast(horas as numeric)))+sum(cast(horas as numeric))) else sum(horas) end as horas from horas_docente_totales_semestre"& vbCrLf &_
"where sexo=2"& vbCrLf &_
"and titulo_grado_obtenido='TECNICO'"& vbCrLf &_
"and peri_ccod=" &peri_ccod&""& vbCrLf &_
" " &filtro&" "& vbCrLf &_
" " &filtro2&" "& vbCrLf &_
" " &filtro3&" "& vbCrLf &_
"group by pers_ncorr,tido_ccod)pp"& vbCrLf &_
"where  horas between 20 and 32" 
'response.end()
f_docentes_tecnico_20_32_F.Consultar profesores_tecnico_20_32_F
f_docentes_tecnico_20_32_F.siguiente
'response.Write("<pre>"&profesores_tecnico_20_32_F&"</pre>")

''-----------------------------------------------------------------------------------------------------------------------------------------

set f_docentes_tecnico_33_44_M = new CFormulario
 f_docentes_tecnico_33_44_M.Carga_Parametros "tabla_vacia.xml", "tabla" 
 f_docentes_tecnico_33_44_M.Inicializar conexion
 'response.End()
profesores_tecnico_33_44_M="select isnull(count(pers_ncorr),0)as cantidad_profesores_33_a_44_MASCULINO,isnull(sum(horas),0)as profesores_33_a_44_MASCULINO"& vbCrLf &_
"from(select pers_ncorr, case when tido_ccod=3 then ((45-sum(cast(horas as numeric)))+sum(cast(horas as numeric))) else sum(horas) end as horas from horas_docente_totales_semestre"& vbCrLf &_
"where sexo=1"& vbCrLf &_
"and titulo_grado_obtenido='TECNICO'"& vbCrLf &_
"and peri_ccod=" &peri_ccod&""& vbCrLf &_
" " &filtro&" "& vbCrLf &_
" " &filtro2&" "& vbCrLf &_
" " &filtro3&" "& vbCrLf &_
"group by pers_ncorr,tido_ccod)pp"& vbCrLf &_
"where  horas between 33 and 45" 
'response.end()
f_docentes_tecnico_33_44_M.Consultar profesores_tecnico_33_44_M
f_docentes_tecnico_33_44_M.siguiente
'
'response.Write("<pre>"&profesores_tecnico_33_44_M&"</pre>")

''-----------------------------------------------------------------------------------------------------------------------------------------

set f_docentes_tecnico_33_44_F = new CFormulario
 f_docentes_tecnico_33_44_F.Carga_Parametros "tabla_vacia.xml", "tabla" 
 f_docentes_tecnico_33_44_F.Inicializar conexion
 'response.End()
profesores_tecnico_33_44_F="select isnull(count(pers_ncorr),0)as cantidad_profesores_33_a_44_FEMENINO,isnull(sum(horas),0)as profesores_33_a_44_FEMENINO"& vbCrLf &_
"from(select pers_ncorr, case when tido_ccod=3 then ((45-sum(cast(horas as numeric)))+sum(cast(horas as numeric))) else sum(horas) end as horas from horas_docente_totales_semestre"& vbCrLf &_
"where sexo=2"& vbCrLf &_
"and titulo_grado_obtenido='TECNICO'"& vbCrLf &_
"and peri_ccod=" &peri_ccod&""& vbCrLf &_
" " &filtro&" "& vbCrLf &_
" " &filtro2&" "& vbCrLf &_
" " &filtro3&" "& vbCrLf &_
"group by pers_ncorr,tido_ccod)pp"& vbCrLf &_
"where  horas between 33 and 45"

f_docentes_tecnico_33_44_F.Consultar profesores_tecnico_33_44_F
f_docentes_tecnico_33_44_F.siguiente
'response.Write("<pre>"&profesores_tecnico_33_44_F&"</pre>")

'-----------------------------------------------------------------------------------------------------------------------------------------

'
 set f_docentes_sintitulo_1_19_M = new CFormulario
 f_docentes_sintitulo_1_19_M.Carga_Parametros "tabla_vacia.xml", "tabla" 
 f_docentes_sintitulo_1_19_M.Inicializar conexion
 'response.End()
profesores_sintitulo_1_19_M="select isnull(count(pers_ncorr),0)as cantidad_profesores_1_a_19_MASCULINO,isnull(sum(horas),0)as profesores_1_a_19_MASCULINO"& vbCrLf &_
"from(select pers_ncorr, case when tido_ccod=3 then ((45-sum(cast(horas as numeric)))+sum(cast(horas as numeric))) else sum(horas) end as horas from horas_docente_totales_semestre"& vbCrLf &_
"where sexo=1"& vbCrLf &_
"and titulo_grado_obtenido='SIN_TITULO'"& vbCrLf &_
"and peri_ccod=" &peri_ccod&""& vbCrLf &_
" " &filtro&" "& vbCrLf &_
" " &filtro2&" "& vbCrLf &_
" " &filtro3&" "& vbCrLf &_
"group by pers_ncorr,tido_ccod)pp"& vbCrLf &_
"where  horas between 1 and 19" 

'response.end()
f_docentes_sintitulo_1_19_M.Consultar profesores_sintitulo_1_19_M
f_docentes_sintitulo_1_19_M.siguiente
'response.end()
'response.Write("<pre>"&profesores_sintitulo_1_19_M&"</pre>")

'
''-----------------------------------------------------------------------------------------------------------------------------------------

 set f_docentes_sintitulo_1_19_F = new CFormulario
 f_docentes_sintitulo_1_19_F.Carga_Parametros "tabla_vacia.xml", "tabla" 
 f_docentes_sintitulo_1_19_F.Inicializar conexion
 'response.End()
profesores_sintitulo_1_19_F="select isnull(count(pers_ncorr),0)as cantidad_profesores_1_a_19_FEMENINO,isnull(sum(horas),0)as profesores_1_a_19_FEMENINO"& vbCrLf &_
"from(select pers_ncorr, case when tido_ccod=3 then ((45-sum(cast(horas as numeric)))+sum(cast(horas as numeric))) else sum(horas) end as horas from horas_docente_totales_semestre"& vbCrLf &_
"where sexo=2"& vbCrLf &_
"and titulo_grado_obtenido='SIN_TITULO'"& vbCrLf &_
"and peri_ccod=" &peri_ccod&""& vbCrLf &_
" " &filtro&" "& vbCrLf &_
" " &filtro2&" "& vbCrLf &_
" " &filtro3&" "& vbCrLf &_
"group by pers_ncorr,tido_ccod)pp"& vbCrLf &_
"where  horas between 1 and 19" 

'response.end()
f_docentes_sintitulo_1_19_F.Consultar profesores_sintitulo_1_19_F
f_docentes_sintitulo_1_19_F.siguiente
'response.end()
'response.Write("<pre>"&profesores_sintitulo_1_19_F&"</pre>")

''-----------------------------------------------------------------------------------------------------------------------------------------

 set f_docentes_sintitulo_20_32_M = new CFormulario
 f_docentes_sintitulo_20_32_M.Carga_Parametros "tabla_vacia.xml", "tabla" 
 f_docentes_sintitulo_20_32_M.Inicializar conexion
 'response.End()
profesores_sintitulo_20_32_M="select isnull(count(pers_ncorr),0)as cantidad_profesores_20_a_32_MASCULINO,isnull(sum(horas),0)as profesores_20_a_32_MASCULINO"& vbCrLf &_
"from(select pers_ncorr, case when tido_ccod=3 then ((45-sum(cast(horas as numeric)))+sum(cast(horas as numeric))) else sum(horas) end as horas from horas_docente_totales_semestre"& vbCrLf &_
"where sexo=1"& vbCrLf &_
"and titulo_grado_obtenido='SIN_TITULO'"& vbCrLf &_
"and peri_ccod=" &peri_ccod&""& vbCrLf &_
" " &filtro&" "& vbCrLf &_
" " &filtro2&" "& vbCrLf &_
" " &filtro3&" "& vbCrLf &_
"group by pers_ncorr,tido_ccod)pp"& vbCrLf &_
"where  horas between 20 and 32" 
'response.end()
f_docentes_sintitulo_20_32_M.Consultar profesores_sintitulo_20_32_M
f_docentes_sintitulo_20_32_M.siguiente
'response.Write("<pre>"&profesores_sintitulo_20_32_M&"</pre>")

''-----------------------------------------------------------------------------------------------------------------------------------------

 set f_docentes_sintitulo_20_32_F = new CFormulario
 f_docentes_sintitulo_20_32_F.Carga_Parametros "tabla_vacia.xml", "tabla" 
 f_docentes_sintitulo_20_32_F.Inicializar conexion
 'response.End()
profesores_sintitulo_20_32_F="select isnull(count(pers_ncorr),0)as cantidad_profesores_20_a_32_FEMENINO,isnull(sum(horas),0)as profesores_20_a_32_FEMENINO"& vbCrLf &_
"from(select pers_ncorr, case when tido_ccod=3 then ((45-sum(cast(horas as numeric)))+sum(cast(horas as numeric))) else sum(horas) end as horas from horas_docente_totales_semestre"& vbCrLf &_
"where sexo=2"& vbCrLf &_
"and titulo_grado_obtenido='SIN_TITULO'"& vbCrLf &_
"and peri_ccod=" &peri_ccod&""& vbCrLf &_
" " &filtro&" "& vbCrLf &_
" " &filtro2&" "& vbCrLf &_
" " &filtro3&" "& vbCrLf &_
"group by pers_ncorr,tido_ccod)pp"& vbCrLf &_
"where  horas between 20 and 32" 
'response.end()
f_docentes_sintitulo_20_32_F.Consultar profesores_sintitulo_20_32_F
f_docentes_sintitulo_20_32_F.siguiente
'response.Write("<pre>"&profesores_sintitulo_20_32_F&"</pre>")

''-----------------------------------------------------------------------------------------------------------------------------------------

set f_docentes_sintitulo_33_44_M = new CFormulario
 f_docentes_sintitulo_33_44_M.Carga_Parametros "tabla_vacia.xml", "tabla" 
 f_docentes_sintitulo_33_44_M.Inicializar conexion
 'response.End()
profesores_sintitulo_33_44_M="select isnull(count(pers_ncorr),0)as cantidad_profesores_33_a_44_MASCULINO,isnull(sum(horas),0)as profesores_33_a_44_MASCULINO"& vbCrLf &_
"from(select pers_ncorr, case when tido_ccod=3 then ((45-sum(cast(horas as numeric)))+sum(cast(horas as numeric))) else sum(horas) end as horas from horas_docente_totales_semestre"& vbCrLf &_
"where sexo=1"& vbCrLf &_
"and titulo_grado_obtenido='SIN_TITULO'"& vbCrLf &_
"and peri_ccod=" &peri_ccod&""& vbCrLf &_
" " &filtro&" "& vbCrLf &_
" " &filtro2&" "& vbCrLf &_
" " &filtro3&" "& vbCrLf &_
"group by pers_ncorr,tido_ccod)pp"& vbCrLf &_
"where  horas between 33 and 45" 
  

'response.end()
f_docentes_sintitulo_33_44_M.Consultar profesores_sintitulo_33_44_M
f_docentes_sintitulo_33_44_M.siguiente
'response.Write("<pre>"&profesores_sintitulo_33_44_M&"</pre>")

''-----------------------------------------------------------------------------------------------------------------------------------------

set f_docentes_sintitulo_33_44_F = new CFormulario
 f_docentes_sintitulo_33_44_F.Carga_Parametros "tabla_vacia.xml", "tabla" 
 f_docentes_sintitulo_33_44_F.Inicializar conexion
 'response.End()
profesores_sintitulo_33_44_F="select isnull(count(pers_ncorr),0)as cantidad_profesores_33_a_44_FEMENINO,isnull(sum(horas),0)as profesores_33_a_44_FEMENINO"& vbCrLf &_
"from(select pers_ncorr, case when tido_ccod=3 then ((45-sum(cast(horas as numeric)))+sum(cast(horas as numeric))) else sum(horas) end as horas from horas_docente_totales_semestre"& vbCrLf &_
"where sexo=2"& vbCrLf &_
"and titulo_grado_obtenido='SIN_TITULO'"& vbCrLf &_
"and peri_ccod=" &peri_ccod&""& vbCrLf &_
" " &filtro&" "& vbCrLf &_
" " &filtro2&" "& vbCrLf &_
" " &filtro3&" "& vbCrLf &_
"group by pers_ncorr,tido_ccod)pp"& vbCrLf &_
"where  horas between 33 and 45"  
'response.end()
f_docentes_sintitulo_33_44_F.Consultar profesores_sintitulo_33_44_F
f_docentes_sintitulo_33_44_F.siguiente
'response.Write("<pre>"&profesores_sintitulo_33_44_F&"</pre>")

''-----------------------------------------------------------------------------------------------------------------------------------------




%>

<html>
<head>
<title>docentes por grado, sexo</title>
<meta http-equiv="Content-Type" content="text/html;">
<style type="text/css">
<!--
.estilo1 {
font-family: Arial, Helvetica, sans-serif;
font-size: 12px;
color: #003366;
}
.estilo2 {
color: #990000;
font-weight: bold;
}
.estilo3 {font-family: Arial, Helvetica, sans-serif; font-size: 12px; color: #ffffff; }

.estilo4 {font-family: Arial, Helvetica, sans-serif; font-size: 12px; color: #000000; }
-->
</style>

</head>
<body >
<table width="100%" border="0">
 <tr> 
    <td colspan="2">&nbsp;</td>
  </tr>
 <tr> 
    <td colspan="2"><div align="center"><font size="+2" face="Arial, Helvetica, sans-serif">Docentes <%=periodo_academico%> <%if sede <> null then%> Sede <%=sede%><%end if%> </font></div>
	  <div align="right"></div></td>
  </tr>
 
</table>
<p>&nbsp;</p>
<table width="1230">
  <tr width="50%">
    <td><table width="100%" border="1">
      <tr bordercolor="#999999" bgcolor="#c4d7ff">
        <td width="70%" colspan="4" valign="bottom"><font color="#333333">
          <div align="center"><strong>GRADOS DE <%=tido_tdesc%> DE <%=tcar_tdesc%> </strong></div>
        </font></td>
      </tr>
      <tr bordercolor="#999999" bgcolor="#c4d7ff">
        <td width="60%" rowspan="1" valign="bottom"><font color="#333333">
          <div align="center">Grados</div>
        </font></td>
        <td width="10%" colspan="1" valign="bottom"><font color="#333333">
          <div align="center">Hombres</div>
        </font></td>
        <td width="10%" colspan="1" valign="top"><font color="#333333">&nbsp;
          </font>
        <div align="center"><font color="#333333">Cantidad de Horas Acad&eacute;micas </font></div>        </td>
      </tr>
     
      <tr bgcolor="#0000FF">
        <td class="estilo3" align="left">Doctores Jornada Completa </td>
        <td class="estilo3" align="center"><%=f_docentes_doctorado_33_44_M.ObtenerValor("cantidad_profesores_33_a_44_MASCULINO")%></td>
        <td class="estilo3" align="center"><%=f_docentes_doctorado_33_44_M.ObtenerValor("profesores_33_a_44_MASCULINO")%></td>
      </tr>
     
      <tr bgcolor="#0000FF">
        <td class="estilo3" align="left">Doctores Media Jornada </td>
        <td class="estilo3" align="center"><%=f_docentes_doctorado_20_32_M.ObtenerValor("cantidad_profesores_20_a_32_MASCULINO")%></td>
        <td class="estilo3" align="center"><%=f_docentes_doctorado_20_32_M.ObtenerValor("profesores_20_a_32_MASCULINO")%></td>
      </tr>
      <tr bgcolor="#0000FF">
        <td class="estilo3" align="left">Doctores Jornada Hora</td>
        <td class="estilo3" align="center"><%=f_docentes_doctorado_1_19_M.ObtenerValor("cantidad_profesores_1_a_19_MASCULINO")%></td>
        <td class="estilo3" align="center"><%=f_docentes_doctorado_1_19_M.ObtenerValor("profesores_1_a_19_MASCULINO")%></td>
      </tr>
      <tr bgcolor="#003300">
        <td class="estilo3" align="center"><div align="left" class="Estilo3">Magíster Jornada Completa</div></td>
        <td class="estilo3" align="center"><div align="center" class="Estilo3">
          <%=f_docentes_magister_33_44_M.ObtenerValor("cantidad_profesores_33_a_44_MASCULINO")%>
        </div></td>
        <td class="estilo3" align="center"><div align="center" class="Estilo3">
          <%=f_docentes_magister_33_44_M.ObtenerValor("profesores_33_a_44_MASCULINO")%>
        </div></td>
      </tr>
      <tr bgcolor="#003300">
        <td class="estilo3" align="center"><div align="left" class="Estilo3">Magíster Media Jornada </div></td>
        <td class="estilo3" align="center"><div align="center" class="Estilo3">
          <%=f_docentes_magister_20_32_M.ObtenerValor("cantidad_profesores_20_a_32_MASCULINO")%>
        </div></td>
        <td class="estilo3" align="center"><div align="center" class="Estilo3">
          <%=f_docentes_magister_20_32_M.ObtenerValor("profesores_20_a_32_MASCULINO")%>
        </div></td>
      </tr>
      <tr bgcolor="#003300">
        <td class="estilo3" align="center"><div align="left" class="Estilo3">Magíster Jornada Hora  </div></td>
        <td class="estilo3" align="center"><div align="center" class="Estilo3">
          <%=f_docentes_magister_1_19_M.ObtenerValor("cantidad_profesores_1_a_19_MASCULINO")%>
        </div></td>
        <td class="estilo3" align="center"><div align="center" class="Estilo3">
          <%=f_docentes_magister_1_19_M.ObtenerValor("profesores_1_a_19_MASCULINO")%>
        </div></td>
      </tr>
      <tr bgcolor="#00CC66">
        <td class="estilo3" align="center"><div align="left" class="Estilo3">Licenciados Jornada Completa</div></td>
        <td class="estilo3" align="center"><div align="center" class="Estilo3">
          <%=f_docentes_licenciado_33_44_M.ObtenerValor("cantidad_profesores_33_a_44_MASCULINO")%>
        </div></td>
        <td class="estilo3" align="center"><div align="center" class="Estilo3">
          <%=f_docentes_licenciado_33_44_M.ObtenerValor("profesores_33_a_44_MASCULINO")%>
        </div></td>
      </tr>
      <tr bgcolor="#00CC66">
        <td class="estilo3" align="center"><div align="left" class="Estilo3">Licenciados Media Jornada </div></td>
        <td class="estilo3" align="center"><div align="center" class="Estilo3">
          <%=f_docentes_licenciado_20_32_M.ObtenerValor("cantidad_profesores_20_a_32_MASCULINO")%>
        </div></td>
        <td class="estilo3" align="center"><div align="center" class="Estilo3">
          <%=f_docentes_licenciado_20_32_M.ObtenerValor("profesores_20_a_32_MASCULINO")%>
        </div></td>
      </tr>
      <tr bgcolor="#00CC66">
        <td class="estilo3" align="center"><div align="left" class="Estilo3">Licenciados Jornada Hora </div></td>
        <td class="estilo3" align="center"><div align="center" class="Estilo3">
          <%=f_docentes_licenciado_1_19_M.ObtenerValor("cantidad_profesores_1_a_19_MASCULINO")%>
        </div></td>
        <td class="estilo3" align="center"><div align="center" class="Estilo3">
          <%=f_docentes_licenciado_1_19_M.ObtenerValor("profesores_1_a_19_MASCULINO")%>
        </div></td>
      </tr>
      <tr bgcolor="#99FFCC">
        <td class="estilo4" align="center"><div align="left" class="Estilo4">Profesionales Jornada Completa</span></div></td>
        <td class="estilo4" align="center"><div align="center" class="Estilo4">
          <%=f_docentes_profesional_33_44_M.ObtenerValor("cantidad_profesores_33_a_44_MASCULINO")%>
        </div></td>
        <td class="estilo4" align="center"><div align="center" class="Estilo4">
          <%=f_docentes_profesional_33_44_M.ObtenerValor("profesores_33_a_44_MASCULINO")%>
        </div></td>
      </tr>
      <tr bgcolor="#99FFCC">
        <td class="estilo4" align="center"><div align="left" class="Estilo4">Profesionales Media Jornada </span></div></td>
        <td class="estilo4" align="center"><div align="center" class="Estilo4">
          <%=f_docentes_profesional_20_32_M.ObtenerValor("cantidad_profesores_20_a_32_MASCULINO")%>
        </div></td>
        <td class="estilo4" align="center"><div align="center" class="Estilo4">
          <%=f_docentes_profesional_20_32_M.ObtenerValor("profesores_20_a_32_MASCULINO")%>
        </div></td>
      </tr>
      <tr bgcolor="#99FFCC">
        <td class="estilo4" align="center"><div align="left" class="Estilo4">Profesionales Jornada Hora </span></div></td>
        <td class="estilo4" align="center"><div align="center" class="Estilo4">
          <%=f_docentes_profesional_1_19_M.ObtenerValor("cantidad_profesores_1_a_19_MASCULINO")%>
        </div></td>
        <td class="estilo4" align="center"><div align="center" class="Estilo4">
          <%=f_docentes_profesional_1_19_M.ObtenerValor("profesores_1_a_19_MASCULINO")%>
        </div></td>
      </tr>
      <tr bgcolor="#996600">
        <td class="estilo3" align="center"><div align="left" class="Estilo3">Téc. Nivel Súperior Jornada Completa</div></td>
        <td class="estilo3" align="center"><div align="center" class="Estilo3">
          <%=f_docentes_tecnico_33_44_M.ObtenerValor("cantidad_profesores_33_a_44_MASCULINO")%>
        </div></td>
        <td><div align="center" class="Estilo3">
          <%=f_docentes_tecnico_33_44_M.ObtenerValor("profesores_33_a_44_MASCULINO")%>
        </div></td>
      </tr>
      <tr bgcolor="#996600">
        <td class="estilo3" align="center"><div align="left" class="Estilo3">Téc. Nivel Súperior Media Jornada </div></td>
        <td class="estilo3" align="center"><div align="center" class="Estilo3">
          <%=f_docentes_tecnico_20_32_M.ObtenerValor("cantidad_profesores_20_a_32_MASCULINO")%>
        </div></td>
        <td><div align="center" class="Estilo3">
          <%=f_docentes_tecnico_20_32_M.ObtenerValor("profesores_20_a_32_MASCULINO")%>
        </div></td>
      </tr>
      <tr bgcolor="#996600">
        <td class="estilo3" align="center"><div align="left" class="Estilo3">Téc. Nivel Súperior Jornada Hora </div></td>
        <td class="estilo3" align="center"><div align="center" class="Estilo3">
          <%=f_docentes_tecnico_1_19_M.ObtenerValor("cantidad_profesores_1_a_19_MASCULINO")%>
        </div></td>
        <td><div align="center" class="Estilo3">
          <%=f_docentes_tecnico_1_19_M.ObtenerValor("profesores_1_a_19_MASCULINO")%>
        </div></td>
      </tr>
      <tr bgcolor="#CC6600">
        <td class="estilo3" align="center"><div align="left" class="Estilo3">Sin título o grado Jornada Completa</div></td>
        <td class="estilo3" align="center"><div align="center" class="Estilo3">
          <%=f_docentes_sintitulo_33_44_M.ObtenerValor("cantidad_profesores_33_a_44_MASCULINO")%>
        </div></td>
        <td class="estilo3" align="center"><div align="center" class="Estilo3">
          <%=f_docentes_sintitulo_33_44_M.ObtenerValor("profesores_33_a_44_MASCULINO")%>
        </div></td>
      </tr>
	  <tr bgcolor="#CC6600">
        <td class="estilo3" align="center"><div align="left" class="Estilo3">Sin título o grado Media Jornada </div></td>
        <td class="estilo3" align="center"><div align="center" class="Estilo3">
          <%=f_docentes_sintitulo_20_32_M.ObtenerValor("cantidad_profesores_20_a_32_MASCULINO")%>
        </div></td>
        <td class="estilo3" align="center"><div align="center" class="Estilo3">
          <%=f_docentes_sintitulo_20_32_M.ObtenerValor("profesores_20_a_32_MASCULINO")%>
        </div></td>
      </tr>
	  <tr bgcolor="#CC6600">
        <td class="estilo3" align="center"><div align="left" class="Estilo3">Sin título o grado Jornada Hora </div></td>
        <td class="estilo3" align="center"><div align="center" class="Estilo3">
          <%=f_docentes_sintitulo_1_19_M.ObtenerValor("cantidad_profesores_1_a_19_MASCULINO")%>
        </div></td>
        <td class="estilo3" align="center"><div align="center" class="Estilo3">
          <%=f_docentes_sintitulo_1_19_M.ObtenerValor("profesores_1_a_19_MASCULINO")%>
        </div></td>
      </tr>
    </table></td>
    <td><table width="100%" border="1">
      <tr bordercolor="#999999" bgcolor="#c4d7ff">
        <td width="70%" colspan="4" valign="bottom"><font color="#333333">
          <div align="center"><strong>GRADOS DE <%=tido_tdesc%> DE <%=tcar_tdesc%> </strong></div>
        </font></td>
      </tr>
      <tr bordercolor="#999999" bgcolor="#c4d7ff">
        <td width="60%" rowspan="1" valign="bottom"><font color="#333333">
          <div align="center">Grados</div>
        </font></td>
        <td width="10%" colspan="1" valign="bottom"><font color="#333333">
          <div align="center">Mujeres</div>
        </font></td>
        <td width="10%" colspan="1" valign="top"><font color="#333333">&nbsp;
          </font><div align="center"><font color="#333333">Cantidad de Horas Acad&eacute;micas </font></div>        </td>
      </tr>
      
      <tr bgcolor="#0000FF">
        <td class="estilo3" align="left">Doctores Jornada Completa </td>
        <td class="estilo3" align="center"><%=f_docentes_doctorado_33_44_F.ObtenerValor("cantidad_profesores_33_a_44_FEMENINO")%></td>
        <td class="estilo3" align="center"><%=f_docentes_doctorado_33_44_F.ObtenerValor("profesores_33_a_44_FEMENINO")%></td>
      </tr>
      
      <tr bgcolor="#0000FF">
        <td class="estilo3" align="left">Doctores Media Jornada </td>
        <td class="estilo3" align="center"><%=f_docentes_doctorado_20_32_F.ObtenerValor("cantidad_profesores_20_a_32_FEMENINO")%></td>
        <td class="estilo3" align="center"><%=f_docentes_doctorado_20_32_F.ObtenerValor("profesores_20_a_32_FEMENINO")%></td>
      </tr>
      <tr bgcolor="#0000FF">
        <td class="estilo3" align="left">Doctores Jornada Hora </td>
        <td class="estilo3" align="center"><%=f_docentes_doctorado_1_19_F.ObtenerValor("cantidad_profesores_1_a_19_FEMENINO")%></td>
        <td class="estilo3" align="center"><%=f_docentes_doctorado_1_19_F.ObtenerValor("profesores_1_a_19_FEMENINO")%></td>
      </tr>
      <tr bgcolor="#003300">
        <td class="estilo3" align="center"><div align="left" class="Estilo3">Magíster Jornada Completa</div></td>
        <td class="estilo3" align="center"><div align="center" class="Estilo3">
          <%=f_docentes_magister_33_44_F.ObtenerValor("cantidad_profesores_33_a_44_FEMENINO")%>
        </div></td>
        <td class="estilo3" align="center"><div align="center" class="Estilo3">
          <%=f_docentes_magister_33_44_F.ObtenerValor("profesores_33_a_44_FEMENINO")%>
        </div></td>
      </tr>
      <tr bgcolor="#003300">
        <td class="estilo3" align="center"><div align="left" class="Estilo3">Magíster Media Jornada </div></td>
        <td class="estilo3" align="center"><div align="center" class="Estilo3">
          <%=f_docentes_magister_20_32_F.ObtenerValor("cantidad_profesores_20_a_32_FEMENINO")%>
        </div></td>
        <td class="estilo3" align="center"><div align="center" class="Estilo3">
          <%=f_docentes_magister_20_32_F.ObtenerValor("profesores_20_a_32_FEMENINO")%>
        </div></td>
      </tr>
      <tr bgcolor="#003300">
        <td class="estilo3" align="center"><div align="left" class="Estilo3">Magíster Jornada Hora  </div></td>
        <td class="estilo3" align="center"><div align="center" class="Estilo3">
          <%=f_docentes_magister_1_19_F.ObtenerValor("cantidad_profesores_1_a_19_FEMENINO")%>
        </div></td>
        <td class="estilo3" align="center"><div align="center" class="Estilo3">
          <%=f_docentes_magister_1_19_F.ObtenerValor("profesores_1_a_19_FEMENINO")%>
        </div></td>
      </tr>
      <tr bgcolor="#00CC66">
        <td class="estilo3" align="center"><div align="left" class="Estilo3">Licenciados Jornada Completa</div></td>
        <td class="estilo3" align="center"><div align="center" class="Estilo3">
          <%=f_docentes_licenciado_33_44_F.ObtenerValor("cantidad_profesores_33_a_44_FEMENINO")%>
        </div></td>
        <td class="estilo3" align="center"><div align="center" class="Estilo3">
          <%=f_docentes_licenciado_33_44_F.ObtenerValor("profesores_33_a_44_FEMENINO")%>
        </div></td>
      </tr>
      <tr bgcolor="#00CC66">
        <td class="estilo3" align="center"><div align="left" class="Estilo3">Licenciados Media Jornada </div></td>
        <td class="estilo3" align="center"><div align="center" class="Estilo3">
          <%=f_docentes_licenciado_20_32_F.ObtenerValor("cantidad_profesores_20_a_32_FEMENINO")%>
        </div></td>
        <td class="estilo3" align="center"><div align="center" class="Estilo3">
          <%=f_docentes_licenciado_20_32_F.ObtenerValor("profesores_20_a_32_FEMENINO")%>
        </div></td>
      </tr>
      <tr bgcolor="#00CC66">
        <td class="estilo3" align="center"><div align="left" class="Estilo3">Licenciados Jornada Hora </div></td>
        <td class="estilo3" align="center"><div align="center" class="Estilo3">
          <%=f_docentes_licenciado_1_19_F.ObtenerValor("cantidad_profesores_1_a_19_FEMENINO")%>
        </div></td>
        <td class="estilo3" align="center"><div align="center" class="Estilo3"><%=f_docentes_licenciado_1_19_F.ObtenerValor("profesores_1_a_19_FEMENINO")%></div></td>
      </tr>
      <tr bgcolor="#99FFCC">
        <td class="estilo4" align="center"><div align="left" class="Estilo4">Profesionales Jornada Completa</span></div></td>
        <td class="estilo4" align="center"><div align="center" class="Estilo4">
          <%=f_docentes_profesional_33_44_F.ObtenerValor("cantidad_profesores_33_a_44_FEMENINO")%>
        </div></td>
        <td class="estilo4" align="center"><div align="center" class="Estilo4">
          <%=f_docentes_profesional_33_44_F.ObtenerValor("profesores_33_a_44_FEMENINO")%>
        </div></td>
      </tr>
      <tr bgcolor="#99FFCC">
        <td class="estilo4" align="center"><div align="left" class="Estilo4">Profesionales Media Jornada </span></div></td>
        <td class="estilo4" align="center"><div align="center" class="Estilo4">
          <%=f_docentes_profesional_20_32_F.ObtenerValor("cantidad_profesores_20_a_32_FEMENINO")%>
        </div></td>
        <td class="estilo4" align="center"><div align="center" class="Estilo4">
          <%=f_docentes_profesional_20_32_F.ObtenerValor("profesores_20_a_32_FEMENINO")%>
        </div></td>
      </tr>
      <tr bgcolor="#99FFCC">
        <td class="estilo4" align="center"><div align="left" class="Estilo4">Profesionales Jornada Hora </span></div></td>
        <td class="estilo4" align="center"><div align="center" class="Estilo4">
          <%=f_docentes_profesional_1_19_F.ObtenerValor("cantidad_profesores_1_a_19_FEMENINO")%>
        </div></td>
        <td class="estilo4" align="center"><div align="center" class="Estilo4">
          <%=f_docentes_profesional_1_19_F.ObtenerValor("profesores_1_a_19_FEMENINO")%>
        </div></td>
      </tr>
      <tr bgcolor="#996600">
        <td class="estilo3" align="center"><div align="left" class="Estilo3">Téc. Nivel SúperiorJornada Completa</div></td>
        <td class="estilo3" align="center"><div align="center" class="Estilo3">
          <%=f_docentes_tecnico_33_44_F.ObtenerValor("cantidad_profesores_33_a_44_FEMENINO")%>
        </div></td>
        <td><div align="center" class="Estilo3">
          <%=f_docentes_tecnico_33_44_F.ObtenerValor("profesores_33_a_44_FEMENINO")%>
        </div></td>
      </tr>
      <tr bgcolor="#996600">
        <td class="estilo3" align="center"><div align="left" class="Estilo3">Téc. Nivel Súperior Media Jornada </div></td>
        <td class="estilo3" align="center"><div align="center" class="Estilo3">
          <%=f_docentes_tecnico_20_32_F.ObtenerValor("cantidad_profesores_20_a_32_FEMENINO")%>
        </div></td>
        <td><div align="center" class="Estilo3">
          <%=f_docentes_tecnico_20_32_F.ObtenerValor("profesores_20_a_32_FEMENINO")%>
        </div></td>
      </tr>
      <tr bgcolor="#996600">
        <td class="estilo3" align="center"><div align="left" class="Estilo3">Téc. Nivel Súperior Jornada Hora </div></td>
        <td class="estilo3" align="center"><div align="center" class="Estilo3">
          <%=f_docentes_tecnico_1_19_F.ObtenerValor("cantidad_profesores_1_a_19_FEMENINO")%>
        </div></td>
        <td><div align="center" class="Estilo3">
          <%=f_docentes_tecnico_1_19_F.ObtenerValor("profesores_1_a_19_FEMENINO")%>
        </div></td>
      </tr>
      <tr bgcolor="#CC6600">
        <td class="estilo3" align="center"><div align="left" class="Estilo3">Sin título o grado Jornada Completa</div></td>
        <td class="estilo3" align="center"><div align="center" class="Estilo3">
          <%=f_docentes_sintitulo_33_44_F.ObtenerValor("cantidad_profesores_33_a_44_FEMENINO")%>
        </div></td>
        <td class="estilo3" align="center"><div align="center" class="Estilo3">
          <%=f_docentes_sintitulo_33_44_F.ObtenerValor("profesores_33_a_44_FEMENINO")%>
        </div></td>
      </tr>
	     <tr bgcolor="#CC6600">
        <td class="estilo3" align="center"><div align="left" class="Estilo3">Sin título o grado Media Jornada </div></td>
        <td class="estilo3" align="center"><div align="center" class="Estilo3">
          <%=f_docentes_sintitulo_20_32_F.ObtenerValor("cantidad_profesores_20_a_32_FEMENINO")%>
        </div></td>
        <td class="estilo3" align="center"><div align="center" class="Estilo3">
          <%=f_docentes_sintitulo_20_32_F.ObtenerValor("profesores_20_a_32_FEMENINO")%>
        </div></td>
      </tr>
	     <tr bgcolor="#CC6600">
        <td class="estilo3" align="center"><div align="left" class="Estilo3">Sin título o grado Jornada Hora </div></td>
        <td class="estilo3" align="center"><div align="center" class="Estilo3">
          <%=f_docentes_sintitulo_1_19_F.ObtenerValor("cantidad_profesores_1_a_19_FEMENINO")%>
        </div></td>
        <td class="estilo3" align="center"><div align="center" class="Estilo3">
          <%=f_docentes_sintitulo_1_19_F.ObtenerValor("profesores_1_a_19_FEMENINO")%>
        </div></td>
      </tr>
    </table></td>
  </tr>
</table>
<p>&nbsp; 
</p> 
<div align="center"></div>
</body>
</html>