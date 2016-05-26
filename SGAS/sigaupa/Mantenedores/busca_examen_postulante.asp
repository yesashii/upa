<!-- #include file = "../biblioteca/_conexion.asp" -->
<!-- #include file = "../biblioteca/_negocio.asp" -->

<%
'*******************************************************************
'DESCRIPCION		:
'FECHA CREACIÓN		:
'CREADO POR 		:
'ENTRADA		:NA
'SALIDA			:NA
'MODULO QUE ES UTILIZADO: ADMISION Y MATRICULA
'
'--ACTUALIZACION--
'
'FECHA ACTUALIZACION 	:15/01/2013
'ACTUALIZADO POR		:JAIME PAINEMAL A.
'MOTIVO			:Optimizar código, eliminar sentencia *=
'LINEA			:104
'********************************************************************
function SQLExamenesPostulantes()

usuario = negocio.ObtenerUsuario()
'response.Write("usuario "&usuario)

pers_ncorr_encargado=conexion.consultaUno("Select pers_ncorr from personas where cast(pers_nrut as varchar)='"&usuario&"'")

'if usuario = "8988079" or usuario = "9769512" or usuario="5644492" then
'	filtro_especialidades = ""
'else
	filtro_especialidades = " and c.espe_ccod in (Select espe_ccod from sis_especialidades_usuario where cast(pers_ncorr as varchar)='"&pers_ncorr_encargado&"')"	
'end if

'response.Write("usuario "&usuario)
'consulta = "select distinct case c.ofer_bpaga_examen when 'S' then 1 else 0 end as ofer_bpaga_examen,isnull((select top 1 cast(cast(pa.comp_mneto AS integer) - (protic.total_abonado_cuota(ba.tcom_ccod,  pa.inst_ccod, "  & vbCrLf &_
'		 " pa.comp_ndocto, ba.dcom_ncompromiso) + protic.total_abono_documentado_cuota(ba.tcom_ccod, pa.inst_ccod, "  & vbCrLf &_
'		 " pa.comp_ndocto, ba.dcom_ncompromiso))as integer) "  & vbCrLf &_
'		 " from compromisos pa,detalle_compromisos ba "  & vbCrLf &_
'		 " where pa.pers_ncorr=b.pers_ncorr "  & vbCrLf &_
'		 " and pa.tcom_ccod=15 "  & vbCrLf &_
'		 " and pa.tcom_ccod=ba.tcom_ccod "  & vbCrLf &_
'		 " and pa.inst_ccod=ba.inst_ccod "  & vbCrLf &_
'		 " And pa.comp_ndocto=ba.comp_ndocto "  & vbCrLf &_
'		 " And pa.ecom_ccod=1),-1) as deuda , "& vbCrLf &_
'		 " (Select count(*) from postulantes where post_ncorr =b.post_ncorr and post_bpaga='N') as exento, "  & vbCrLf &_
'		 " a.pers_ncorr, cast(a.pers_nrut as varchar) + '-' + a.pers_xdv as rut,"  & vbCrLf &_
'							"       a.pers_tnombre + ' ' + a.pers_tape_paterno + ' ' + a.pers_tape_materno as nombre_completo, " & vbCrLf &_
'							"       e.carr_tdesc + '-' + d.espe_tdesc as carrera,f.ofer_ncorr,d.espe_ccod,e.carr_ccod,g.eepo_tdesc," & vbCrLf &_
'							"       f.eepo_ccod,f.post_ncorr,a.pers_nrut as q_pers_nrut" & vbCrLf &_
'							"from personas_postulante a, postulantes b,ofertas_academicas c,especialidades d,carreras e," & vbCrLf &_
'							"     detalle_postulantes f, estado_examen_postulantes g,areas_academicas h" & vbCrLf &_
'							"where a.pers_ncorr = b.pers_ncorr  " 
'							
'							if q_pers_nrut<>"" and q_pers_xdv<>"" then
'							    consulta=consulta & " and cast(a.pers_nrut as varchar)='"&q_pers_nrut&"'"
'							end if	
'							consulta=consulta & "  and f.post_ncorr = b.post_ncorr and c.post_bnuevo='S' " & vbCrLf &_
'							"  and f.eepo_ccod *= g.eepo_ccod" 
'							 if jorn_ccod<>"" and jorn_ccod<>"-1" then
'		                     	consulta=consulta&" and cast(c.jorn_ccod as varchar)='"&jorn_ccod&"'"
'		                     end if
'							consulta=consulta & "  and f.ofer_ncorr = c.ofer_ncorr" & vbCrLf &_
'							"  " & filtro_especialidades 
'							if sede_ccod<>"" and sede_ccod<>"-1" then
'                             consulta=consulta & " and cast(c.sede_ccod as varchar)= '"&sede_ccod&"'"
'		                    end if
'							consulta=consulta & "  and c.espe_ccod = d.espe_ccod"
'							 if carr_ccod<>"" and carr_ccod<>"-1" then
'                              consulta=consulta & " and cast(e.carr_ccod as varchar)= '"&carr_ccod&"'" 
'		                      end if
'							consulta=consulta & "  and d.carr_ccod = e.carr_ccod" & vbCrLf &_
'							"  and e.area_ccod = h.area_ccod " & vbCrLf &_
'							"  and b.peri_ccod = '"&negocio.obtenerperiodoacademico("postulacion")&"' " & vbCrLf &_
'							"  and b.epos_ccod in (1,2) " & vbCrLf &_
'							"  and not exists (select 1 " & vbCrLf &_
'							"                  from alumnos a2 " & vbCrLf &_
'							"				  where a2.post_ncorr = b.post_ncorr " & vbCrLf &_
'							"				    and a2.emat_ccod = 1)"

consulta = "select distinct case c.ofer_bpaga_examen when 'S' then 1 else 0 end as ofer_bpaga_examen, case when e.carr_ccod IN (43,840) then 0 else isnull((select top 1 cast(cast(pa.comp_mneto AS integer) - (protic.total_abonado_cuota(ba.tcom_ccod,  pa.inst_ccod, "  & vbCrLf &_
		 " pa.comp_ndocto, ba.dcom_ncompromiso) + protic.total_abono_documentado_cuota(ba.tcom_ccod, pa.inst_ccod, "  & vbCrLf &_
		 " pa.comp_ndocto, ba.dcom_ncompromiso))as integer) "  & vbCrLf &_
		 " from compromisos pa,detalle_compromisos ba "  & vbCrLf &_
		 " where pa.pers_ncorr=b.pers_ncorr "  & vbCrLf &_
		 " and pa.tcom_ccod=15 "  & vbCrLf &_
		 " and pa.tcom_ccod=ba.tcom_ccod "  & vbCrLf &_
		 " and pa.inst_ccod=ba.inst_ccod "  & vbCrLf &_
		 " And pa.comp_ndocto=ba.comp_ndocto "  & vbCrLf &_
		 " And pa.ecom_ccod=1),-1) end  as deuda , "& vbCrLf &_
		 " (Select count(*) from postulantes where post_ncorr =b.post_ncorr and post_bpaga='N') as exento, "  & vbCrLf &_
		 " a.pers_ncorr, cast(a.pers_nrut as varchar) + '-' + a.pers_xdv as rut,"  & vbCrLf &_
							"       a.pers_tnombre + ' ' + a.pers_tape_paterno + ' ' + a.pers_tape_materno as nombre_completo, " & vbCrLf &_
							"       e.carr_tdesc + '-' + d.espe_tdesc as carrera,f.ofer_ncorr,d.espe_ccod,e.carr_ccod,g.eepo_tdesc," & vbCrLf &_
							"       f.eepo_ccod,f.post_ncorr,a.pers_nrut as q_pers_nrut" & vbCrLf &_
							"from personas_postulante a INNER JOIN postulantes b " & vbCrLf &_
							" ON a.pers_ncorr = b.pers_ncorr " 
							' 1. if
							if q_pers_nrut<>"" and q_pers_xdv<>"" then
							    consulta=consulta & " and cast(a.pers_nrut as varchar)='"&q_pers_nrut&"'" 
							end if	

							consulta=consulta & " INNER JOIN detalle_postulantes f " & vbCrLf &_
							" ON f.post_ncorr = b.post_ncorr " & vbCrLf &_
							" LEFT OUTER JOIN estado_examen_postulantes g " & vbCrLf &_
							" ON f.eepo_ccod = g.eepo_ccod "  & vbCrLf &_
							" INNER JOIN ofertas_academicas c " & vbCrLf &_
							" ON f.ofer_ncorr = c.ofer_ncorr and c.post_bnuevo='S' " 
							' 2. if
							 if jorn_ccod<>"" and jorn_ccod<>"-1" then
		                     	consulta=consulta&" and cast(c.jorn_ccod as varchar)='"&jorn_ccod&"'"
		                     end If

							consulta=consulta & filtro_especialidades 
							' 3. if
							if sede_ccod<>"" and sede_ccod<>"-1" then
                             consulta=consulta & " and cast(c.sede_ccod as varchar)= '"&sede_ccod&"'"
		                    end If

							consulta=consulta & " INNER JOIN especialidades d " & vbCrLf &_
							" ON c.espe_ccod = d.espe_ccod " & vbCrLf &_
							" INNER JOIN carreras e " & vbCrLf &_
							" ON d.carr_ccod = e.carr_ccod " 
							' 4 if
							 if carr_ccod<>"" and carr_ccod<>"-1" then
                             consulta=consulta & " and cast(e.carr_ccod as varchar)= '"&carr_ccod&"'" 
		                     end If

							consulta=consulta & " INNER JOIN areas_academicas h" & vbCrLf &_
							" ON e.area_ccod = h.area_ccod " & vbCrLf &_
							" WHERE b.peri_ccod = '"&negocio.obtenerperiodoacademico("postulacion")&"' " & vbCrLf &_
							"  and b.epos_ccod in (1,2) " & vbCrLf &_
							"  and not exists (select 1 " & vbCrLf &_
							"                  from alumnos a2 " & vbCrLf &_
							"				  where a2.post_ncorr = b.post_ncorr " & vbCrLf &_
							"				    and a2.emat_ccod = 1)"
SQLExamenesPostulantes = consulta
'response.Write(consulta)
'---------- IP DE PRUEBA ----------
ip_usuario = Request.ServerVariables("REMOTE_ADDR")
'response.Write("ip_usuario = "&ip_usuario&"</br>") 
ip_de_prueba = "172.16.100.128"
'----------------------------------

if ip_usuario = ip_de_prueba then
'response.Write("secc_ccod = "&secc_ccod&"</br>") 
'response.Write("asig_tdesc = "&asig_tdesc&"</br>") 
'response.Write("ip_usuario = "&ip_usuario&"</br>") 
'RESPONSE.Write("<PRE>"&consulta&"</PRE>")
end if

end function

q_pers_nrut = Request.QueryString("busqueda[0][pers_nrut]")
q_pers_xdv = Request.QueryString("busqueda[0][pers_xdv]")
sede_ccod = Request.QueryString("busqueda[0][sede_ccod]")
jorn_ccod = Request.QueryString("busqueda[0][jorn_ccod]")
carr_ccod = Request.QueryString("busqueda[0][carr_ccod]")
paso=request.QueryString("paso")
v_anula_edicion=0


'---------------------------------------------------------------------------------------------------

set pagina = new CPagina
pagina.Titulo = "Examenes Admisión Postulantes"

set errores = new CErrores

'---------------------------------------------------------------------------------------------------
set conexion = new CConexion
conexion.Inicializar "upacifico"

set negocio = new CNegocio
negocio.Inicializa conexion
v_peri_ccod = negocio.ObtenerPeriodoAcademico("POSTULACION")
usuario=negocio.ObtenerUsuario()
pers_ncorr_encargado=conexion.consultaUno("Select pers_ncorr from personas where cast(pers_nrut as varchar)='"&usuario&"'")

'if usuario = "8988079" or usuario = "9769512" or usuario="5644492" then
''	filtro_especialidades = ""
'	filtro_especialidades2 = ""
'else
	filtro_especialidades = " and a.espe_ccod in (Select espe_ccod from sis_especialidades_usuario where cast(pers_ncorr as varchar)='"&pers_ncorr_encargado&"')"	
	filtro_especialidades2 = " and b.espe_ccod in (Select espe_ccod from sis_especialidades_usuario where cast(pers_ncorr as varchar)='"&pers_ncorr_encargado&"')"	
'end if

set f_botonera = new CFormulario
f_botonera.Carga_Parametros "busca_examen_postulante.xml", "botonera"

sede_ccod_usuario=negocio.ObtenerSede()
if sede_ccod="" then
	sede_ccod=sede_ccod_usuario
end if
'---------------------------------------------------------------------------------------------------
'---------------------------------------Agregado ingenieril para los combos ------------------------
 set f_sedes2 = new CFormulario
 f_sedes2.Carga_Parametros "tabla_vacia.xml", "tabla"
 f_sedes2.Inicializar conexion
 consulta_sedes = "select distinct b.sede_ccod as ccod from ofertas_academicas a, sis_sedes_usuarios b where cast(a.peri_ccod as varchar)='"&v_peri_ccod&"' and a.sede_ccod=b.sede_ccod and b.pers_ncorr="&pers_ncorr_encargado&"  " &filtro_especialidades
 f_sedes2.Consultar consulta_sedes
 'response.Write(consulta_sedes)
 'sedes_usuarios="select * from sis_sedes_usuarios where pers_ncorr="&pers_ncorr_encargado
 
 'response.Write(sedes_usuarios)

 while f_sedes2.siguiente
 	if cad_sedes="" then
	   cad_sedes=cad_sedes&f_sedes2.obtenerValor("ccod")
	else
	   cad_sedes=cad_sedes&","&f_sedes2.obtenerValor("ccod")   
	end if
 wend
 'response.Write("<pre>"&cad_sedes&"->"&sede_ccod&"</pre>")
 '------------------------------------------consultamos las carreras--------------------------------------------------------
 if sede_ccod<>"" and sede_ccod<>"-1" then
		 set f_carreras = new CFormulario
		 f_carreras.Carga_Parametros "tabla_vacia.xml", "tabla"
		 f_carreras.Inicializar conexion
		 consulta_carreras = "Select distinct c.carr_ccod,c.carr_tdesc" & vbCrLf &_ 
         			         " from ofertas_academicas a, especialidades b,carreras c" & vbCrLf &_ 
					  		 " where cast(a.sede_ccod as varchar)='"&sede_ccod&"'" & vbCrLf &_ 
                    		 " and a.post_bnuevo='S'" & vbCrLf &_ 
                    		 " and cast(a.peri_ccod as varchar)='"&v_peri_ccod&"'" & vbCrLf &_ 
                    		 " and a.espe_ccod=b.espe_ccod" & vbCrLf &_
							 " "& filtro_especialidades & vbCrLf &_
                   		     " and b.carr_ccod=c.carr_ccod" & vbCrLf &_
                             " order by carr_tdesc"
		
		f_carreras.Consultar consulta_carreras
		
		while f_carreras.siguiente
			if cad_carreras="" then
			    cad_carreras=cad_carreras & "'" & f_carreras.obtenerValor("carr_ccod") & "'"
			else
		        cad_carreras=cad_carreras & ",'" & f_carreras.obtenerValor("carr_ccod") & "'"
		    end if
        wend
 end if
'response.End()
 '-----------------------------------------buscamos las jornadas que pertenecen a la carrera
 if carr_ccod<>"" and carr_ccod<>"-1" then
	  	set f_jornadas = new CFormulario
		f_jornadas.Carga_Parametros "tabla_vacia.xml", "tabla"
		f_jornadas.Inicializar conexion
		consulta_jornadas = "select distinct d.jorn_tdesc,d.jorn_ccod" & vbCrLf &_  
							" from ofertas_academicas a, carreras b,especialidades c, jornadas d " & vbCrLf &_ 
                		    " where cast(b.carr_ccod as varchar)='"&carr_ccod&"'" & vbCrLf &_ 
                    		" and b.carr_ccod=c.carr_ccod" & vbCrLf &_ 
                    		" and c.espe_ccod=a.espe_ccod" & vbCrLf &_ 
                    		" and a.jorn_ccod=d.jorn_ccod" & vbCrLf &_ 
                    		" and cast(a.sede_ccod as varchar)='"&sede_ccod&"'" & vbCrLf &_ 
                    		" and cast(a.peri_ccod as varchar)='"&v_peri_ccod&"'"
		f_jornadas.Consultar consulta_jornadas
		
		while f_jornadas.siguiente
			if cad_jornadas="" then
			    cad_jornadas=cad_jornadas&f_jornadas.obtenerValor("jorn_ccod")
			else
		        cad_jornadas=cad_jornadas&","&f_jornadas.obtenerValor("jorn_ccod")
		    end if
        wend
 'response.End()		
 end if
'--------------------------------------------fin seleccion combos carreras--------------------------
set f_busqueda = new CFormulario
f_busqueda.Carga_Parametros "busca_examen_postulante.xml", "busqueda2"
f_busqueda.Inicializar conexion
f_busqueda.Consultar "Select ''"
f_busqueda.AgregaCampoCons "pers_nrut", q_pers_nrut
f_busqueda.AgregaCampoCons "pers_xdv", q_pers_xdv
'--------------------------------------------agregamos filtros a los select que mostraran la sede, asignatura, jornada
 if cad_sedes<>"" then
 	   f_busqueda.Agregacampoparam "sede_ccod", "filtro" , "sede_ccod in ("&cad_sedes&")"
	   'response.Write("sede_ccod in ("&cad_sedes&")")
 end if
 f_busqueda.AgregaCampoCons "sede_ccod", sede_ccod 
  
 	if  EsVacio(sede_ccod) or sede_ccod="-1" then
  		f_busqueda.Agregacampoparam "carr_ccod", "filtro" , "1=2"
	else
		f_busqueda.Agregacampoparam "carr_ccod", "filtro" , "carr_ccod in ("&cad_carreras&")"
	    f_busqueda.AgregaCampoCons "carr_ccod", carr_ccod 
		'response.Write("carr_ccod in ("&cad_carreras&")")
	end if
'response.End()
		
	if EsVacio(carr_ccod) or carr_ccod="-1" then
		f_busqueda.Agregacampoparam "jorn_ccod", "filtro" , "1=2"
	else
		f_busqueda.Agregacampoparam "jorn_ccod", "filtro" , "jorn_ccod in ("&cad_jornadas&")"
	    f_busqueda.AgregaCampoCons "jorn_ccod", jorn_ccod 
	end if
'-----------------------------------------------------------fin filtros------------------------------------------------
f_busqueda.Siguiente
'response.End()
if q_pers_nrut<>"" and q_pers_xdv<>"" then
	sql_pers_ncorr="select pers_ncorr from personas_postulante where cast(pers_nrut as varchar)='"&q_pers_nrut&"'"
	v_pers_ncorr=conexion.ConsultaUno(sql_pers_ncorr)
end if

'-------------------------------------------------------------------
set f_alumno = new CFormulario
f_alumno.Carga_Parametros "busca_examen_postulante.xml", "alumno"
f_alumno.Inicializar conexion


consulta = "select distinct a.pers_ncorr, protic.obtener_rut(a.pers_ncorr) as rut, protic.obtener_nombre_completo(a.pers_ncorr,'ap') as nombre_completo " & vbCrLf &_
           "from personas a, alumnos b, postulantes c" & vbCrLf &_
		   "where a.pers_ncorr = b.pers_ncorr " & vbCrLf &_
		   "  and b.emat_ccod = 1 " & vbCrLf &_
		   "  and b.post_ncorr=c.post_ncorr " & vbCrLf &_
		   "  and cast(c.peri_ccod as varchar)= '"&v_peri_ccod&"'" & vbCrLf &_
		   "  and cast(a.pers_nrut as varchar) = '" & q_pers_nrut & "' " & vbCrLf &_
		   "  and not exists (select 1 " & vbCrLf &_
		   "                  from alumnos a2, ofertas_academicas b2" & vbCrLf &_
		   "				  where a2.ofer_ncorr = b2.ofer_ncorr" & vbCrLf &_
		   "				    and cast(b2.peri_ccod as varchar) = '" & v_peri_ccod & "'" & vbCrLf &_
		   "					and a2.pers_ncorr = b.pers_ncorr" & vbCrLf &_
		   "					and a2.emat_ccod = 1)"
		   

'response.Write("<pre>" & consulta & "</pre>")
'response.End()
f_alumno.Consultar consulta
'response.End()
if f_alumno.NroFilas = 0 then	
'response.End()
if paso<>"" then
'response.End()
consulta=SQLExamenesPostulantes()
'response.End()
else
consulta="Select * from sexos where 1=2"
end if
'response.End()
   'response.write("<pre>"&consulta&"</pre>")
			   'response.end 
'response.End()
	f_alumno.Consultar consulta
	'response.End()
	'response.Write("Select count(*) from ("&consulta&")a")
	cantidad_encontrados=conexion.consultaUno("Select count(*) from ("&consulta&")a")
	'response.Write(cantidad_encontrados)
	'response.Write("pers_ncorr "&v_pers_ncorr) 
	if v_pers_ncorr<>"" then
		sql_examen_pagado="select cast(cast(a.comp_mneto AS integer) - (protic.total_abonado_cuota(b.tcom_ccod,  a.inst_ccod, "&_
							" a.comp_ndocto, b.dcom_ncompromiso) + protic.total_abono_documentado_cuota(b.tcom_ccod, a.inst_ccod, "&_
							" a.comp_ndocto, b.dcom_ncompromiso))as integer) AS saldo"&_
							" from compromisos a,detalle_compromisos b "&_
							" where cast(a.pers_ncorr as varchar)='"&v_pers_ncorr&"'"&_
							" and a.tcom_ccod=15 "&_
							" and a.tcom_ccod=b.tcom_ccod "&_
							" and a.inst_ccod=b.inst_ccod "&_
							" And a.comp_ndocto=b.comp_ndocto "&_
							" And a.ecom_ccod=1 "
		
		'response.Write("<br>"&sql_examen_pagado)
		v_saldo_examen=conexion.consultaUno(sql_examen_pagado)
	'response.End()	
		if v_saldo_examen>0 or isnull(v_saldo_examen) then
			v_anula_edicion=1 ' no ha pagado todo
				sql_post_ncorr	="Select post_ncorr from postulantes where cast(pers_ncorr as varchar)='"&v_pers_ncorr&"'"
				v_post_ncorr	=conexion.consultaUno(sql_post_ncorr)
				sql_paga_o_no="Select count(*) from postulantes where cast(post_ncorr as varchar)='"&v_post_ncorr&"' and post_bpaga='N'"
				'response.Write(sql_paga_o_no)
				v_paga=conexion.consultaUno(sql_paga_o_no)
					if (v_paga = 1) then
						v_anula_edicion=0 ' El alumno esta exento de pago
					end if
		end if

	end if
	if f_alumno.NroFilas = 0 then
		f_botonera.AgregaBotonParam "siguiente", "deshabilitado", "TRUE"
	end if
	
end if

'---------------------------modificaciones nuevos filtros-------------------------------------------------
consulta_carreras = "Select distinct c.carr_ccod,c.carr_tdesc,a.sede_ccod" & vbCrLf &_ 
                    " from ofertas_academicas a, especialidades b,carreras c" & vbCrLf &_ 
					" where a.post_bnuevo='S'" & vbCrLf &_ 
                    " and cast(a.peri_ccod as varchar)='"&v_peri_ccod&"'" & vbCrLf &_ 
                    " and a.espe_ccod=b.espe_ccod" & vbCrLf &_
					" "&filtro_especialidades2 & vbCrLf &_
                    " and b.carr_ccod=c.carr_ccod" 
'response.Write(consulta_carreras)
conexion.Ejecuta consulta_carreras

set rec_carreras = conexion.ObtenerRS

consulta_jornadas = "select distinct d.jorn_tdesc,d.jorn_ccod,b.carr_ccod" & vbCrLf &_  
					" from ofertas_academicas a, carreras b,especialidades c, jornadas d " & vbCrLf &_ 
                    " where b.carr_ccod=c.carr_ccod" & vbCrLf &_ 
                    " and c.espe_ccod=a.espe_ccod" & vbCrLf &_ 
                    " and a.jorn_ccod=d.jorn_ccod" & vbCrLf &_ 
                    " and cast(a.peri_ccod as varchar)='"&v_peri_ccod&"'"

conexion.Ejecuta consulta_jornadas
set rec_jornadas=conexion.ObtenerRS
'---------------------------------------------------------------------------------------------------------
%>

<html>
<head>
<title><%=pagina.Titulo%></title>
<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1">
<link href="../estilos/estilos.css" rel="stylesheet" type="text/css">
<link href="../estilos/tabla.css" rel="stylesheet" type="text/css">

<script language="JavaScript" src="../biblioteca/tabla.js"></script>
<script language="JavaScript" src="../biblioteca/funciones.js"></script>
<script language="JavaScript" src="../biblioteca/validadores.js"></script>

<script language="JavaScript">

function detalle(deuda,exento,ofer_paga,q_pers_nrut,post_ncorr,ofer_ncorr){
	//alert("DEuda:"+deuda+" -> exento:"+exento+" Oferta:"+ofer_paga);
	//deuda= 0 pagado, -1 sin cargo,>0 con deuda
	//deuda -1 exento 0 oferta 1
	//
v_url="edita_examen_postulante.asp?q_pers_nrut="+q_pers_nrut+"&post_ncorr="+post_ncorr+"&ofer_ncorr="+ofer_ncorr;	

	
	if ((deuda > 0) && (exento==0) && (ofer_paga==1)){ // tiene deuda y no esta exento y la carrera a la que postula cobra, debe pagar
		alert("El alumno aun no ha cancelado el pago para poder rendir el examen de admision");
	}else if (exento==1){ //esta exento de pago
		//alert("Esta exento del pago, porque no necesita pagar");
		window.open(v_url,"examen","resizable,width=800,height=400");
	}else if ((deuda == 0) && (exento==0)){ // no tiene deuda y no esta exento, puede rendir examne
		//alert("Esta exento del pago porque ya pago");
		window.open(v_url,"examen","resizable,width=800,height=400");
	}else if ((deuda == -1) && (ofer_paga==0)){ // no tiene cargo y su carrera no paga , esta bien... pasa
		//alert("El postulo a una carrera que no necesita pagar");
		window.open(v_url,"examen","resizable,width=800,height=400");
	}else if ((deuda > 0) && (ofer_paga==0)){ // si tiene deuda pero no corresponde a la carrera selecionada
		window.open(v_url,"examen","resizable,width=800,height=400");
	}else if (deuda == -1){ // no tiene cargo , no esta exento
		alert(" El alumno no presenta cargos por concepto de pago de examen y no esta exento de este pago.\n No puede ser ingresado su examen en esta condición a menos que sea eximido de este pago.");
	}
	
}
//edita_examen_postulante.asp?q_pers_nrut=%q_pers_nrut%&amp;post_ncorr=%post_ncorr%&amp;ofer_ncorr=%ofer_ncorr%
function filtrarFacultades(formulario)
{
formulario.paso.value="";
formulario.method="get";
formulario.action="busca_examen_postulante.asp";
formulario.submit();
}
function filtrarCarreras(formulario)
{
formulario.paso.value="";
formulario.method="get";
formulario.action="busca_examen_postulante.asp";
formulario.submit();
}
function enviar(formulario)
{
document.buscador.paso.value="1";
document.buscador.method="get";
document.buscador.action="busca_examen_postulante.asp";
document.buscador.submit();
}


arr_carreras = new Array();
arr_jornadas =new Array();

<%
rec_carreras.MoveFirst
i = 0
while not rec_carreras.Eof
%>
arr_carreras[<%=i%>] = new Array();
arr_carreras[<%=i%>]["carr_ccod"] = '<%=rec_carreras("carr_ccod")%>';
arr_carreras[<%=i%>]["carr_tdesc"] = '<%=rec_carreras("carr_tdesc")%>';
arr_carreras[<%=i%>]["sede_ccod"] = '<%=rec_carreras("sede_ccod")%>';
<%	
	rec_carreras.MoveNext
	i = i + 1
wend
%>

<%
rec_jornadas.MoveFirst
j = 0
while not rec_jornadas.Eof
%>
arr_jornadas[<%=j%>] = new Array();
arr_jornadas[<%=j%>]["jorn_ccod"] = '<%=rec_jornadas("jorn_ccod")%>';
arr_jornadas[<%=j%>]["jorn_tdesc"] = '<%=rec_jornadas("jorn_tdesc")%>';
arr_jornadas[<%=j%>]["carr_ccod"] = '<%=rec_jornadas("carr_ccod")%>';
<%	
	rec_jornadas.MoveNext
	j = j + 1
wend
%>

function CargarCarreras(formulario, sede_ccod)
{
	formulario.elements["busqueda[0][carr_ccod]"].length = 0;
	op = document.createElement("OPTION");
	op.value = "-1";
	op.text = "Seleccione Carreras";
	formulario.elements["busqueda[0][carr_ccod]"].add(op)
	for (i = 0; i < arr_carreras.length; i++)
	  { 
		if (arr_carreras[i]["sede_ccod"] == sede_ccod)
		 {
			op = document.createElement("OPTION");
			op.value = arr_carreras[i]["carr_ccod"];
			op.text = arr_carreras[i]["carr_tdesc"];
			formulario.elements["busqueda[0][carr_ccod]"].add(op)			
		 }
	}	
}

function CargarJornadas(formulario, carr_ccod)
{
	formulario.elements["busqueda[0][jorn_ccod]"].length = 0;
	op = document.createElement("OPTION");
	op.value = "-1";
	op.text = "Seleccione Jornada";
	formulario.elements["busqueda[0][jorn_ccod]"].add(op)
	for (j = 0; j < arr_jornadas.length; j++)
	  { 
		if (arr_jornadas[j]["carr_ccod"] == carr_ccod)
		 {
			op = document.createElement("OPTION");
			op.value = arr_jornadas[j]["jorn_ccod"];
			op.text = arr_jornadas[j]["jorn_tdesc"];
			formulario.elements["busqueda[0][jorn_ccod]"].add(op)			
		 }
	}	
}
function inicio()
{
  <%if sede_ccod <> "" then%>
    CargarCarreras(buscador, <%=sede_ccod%>);
	buscador.elements["busqueda[0][carr_ccod]"].value ='<%=carr_ccod%>'; 
  <%end if%>
  <%if carr_ccod <> "" then%>
    CargarJornadas(buscador, <%=carr_ccod%>);
	buscador.elements["busqueda[0][jorn_ccod]"].value ='<%=jorn_ccod%>'; 
  <%end if%>
}
</script>

</head>
<body bgcolor="#CC6600" leftmargin="0" topmargin="0" marginwidth="0" marginheight="0" onLoad="MM_preloadImages('../imagenes/botones/buscar_f2.gif','../images/bot_deshabilitar_f2.gif','../images/agregar2_f2_p.gif','im&amp;#225;genes/marco1_r3_c2_f2.gif');MM_preloadImages('im&amp;#225;genes/marco1_r3_c4_f2.gif');MM_preloadImages('im&amp;#225;genes/marco1_r3_c6_f2.gif');MM_preloadImages('im&amp;#225;genes/marco1_r3_c8_f2.gif');MM_preloadImages('../imagenes/botones/cargar_f2.gif','../imagenes/botones/continuar_f2.gif')" onBlur="revisaVentana();">
<table width="750" border="0" align="center" cellpadding="0" cellspacing="0">
  <tr>
    <td height="62" valign="top"><img src="../imagenes/vineta2_r1_c1.gif" width="750" height="62" border="0"></td>
  </tr>
  <%pagina.DibujarEncabezado()%>  
  <tr>
    <td valign="top" bgcolor="#EAEAEA">
	<br>
	<table width="97%"  border="0" align="center" cellpadding="0" cellspacing="0" bgcolor="#D8D8DE">
      <tr>
        <td width="9" height="8"><img name="top_r1_c1" src="../imagenes/top_r1_c1.gif" width="9" height="8" border="0" alt=""></td>
        <td height="8" background="../imagenes/top_r1_c2.gif"></td>
        <td width="7" height="8"><img name="top_r1_c3" src="../imagenes/top_r1_c3.gif" width="7" height="8" border="0" alt=""></td>
      </tr>
      <tr>
        <td width="9" background="../imagenes/izq.gif"></td>
        <td><table width="100%"  border="0" cellspacing="0" cellpadding="0">
          <tr>
            <td><%pagina.DibujarLenguetas Array("Buscador"), 1 %></td>
          </tr>
          <tr>
            <td height="2" background="../imagenes/top_r3_c2.gif"></td>
          </tr>
          <tr>
            <td><form name="buscador">
			    <input type="hidden" name="paso" value="">
              <br>
              <table width="98%"  border="0" align="center">
                <tr>
                  <td width="81%"><div align="center">
                    <table width="98%"  border="0" cellspacing="0" cellpadding="0">
                      <tr>
                        <td width="99"><div align="left"><strong>R.U.T. Alumno</strong></div></td>
						<td width="23"><div align="center">:</div></td>
						<td width="385"><%f_busqueda.DIbujaCampo("pers_nrut")%> - <%f_busqueda.DibujaCampo("pers_xdv")%> <%pagina.DibujarBuscaPersonas "busqueda[0][pers_nrut]", "busqueda[0][pers_xdv]"%></td>
						</tr>
					    <tr>
                        <td width="99"><div align="left"><strong>Sede </strong></div></td>
                        <td width="23"><div align="center">:</div></td>
                        <td width="385"><%f_busqueda.DibujaCampo("sede_ccod")%></td>				
					  </tr>	
                       <tr>
                        <td><div align="left"><strong>Carrera </strong></div></td>
                        <td width="23"><div align="center">:</div></td>
                        <td><%f_busqueda.DibujaCampo("carr_ccod")%></td>	
                      </tr>
					  <tr>
                        <td><div align="left"><strong>Jornada </strong></div></td>
                        <td width="23"><div align="center">:</div></td>
                        <td><%f_busqueda.DibujaCampo("jorn_ccod")%></td>	
                      </tr>
                    </table>
                  </div></td>
                  <td width="19%"><div align="center"><%f_botonera.DibujaBoton("buscar2")%></div></td>
                </tr>
              </table>
            </form></td>
          </tr>
        </table></td>
        <td width="7" background="../imagenes/der.gif"></td>
      </tr>
      <tr>
        <td width="9" height="13"><img src="../imagenes/base1.gif" width="9" height="13"></td>
        <td height="13" background="../imagenes/base2.gif"></td>
        <td width="7" height="13"><img src="../imagenes/base3.gif" width="7" height="13"></td>
      </tr>
    </table>
	<br>
	<table width="97%"  border="0" align="center" cellpadding="0" cellspacing="0" bgcolor="#D8D8DE">
      <tr>
        <td width="9" height="8"><img name="top_r1_c1" src="../imagenes/top_r1_c1.gif" width="9" height="8" border="0" alt=""></td>
        <td height="8" background="../imagenes/top_r1_c2.gif"></td>
        <td width="7" height="8"><img name="top_r1_c3" src="../imagenes/top_r1_c3.gif" width="7" height="8" border="0" alt=""></td>
      </tr>
      <tr>
        <td width="9" background="../imagenes/izq.gif">&nbsp;</td>
        <td><table width="100%"  border="0" cellspacing="0" cellpadding="0">
          <tr>
            <td><%pagina.DibujarLenguetas Array("Resultados de la búsqueda"), 1 %></td>
          </tr>
          <tr>
            <td height="2" background="../imagenes/top_r3_c2.gif"></td>
          </tr>
          <tr>
            <td><div align="center"><br>
              <%pagina.DibujarTituloPagina%><br>
                </div>
              <form name="edicion">
			  <input type="hidden" name="act_antecedentes" value="S">
                <table width="100%"  border="0" align="center" cellpadding="0" cellspacing="0">
                  <tr>
                    <td><%pagina.DibujarSubtitulo "Postulante"%>
                      <br>
                      <table width="100%"  border="0" align="center" cellpadding="0" cellspacing="0">
                        <tr>
						   <td><strong>Cantidad Encontrados :&nbsp;&nbsp;</strong><%=cantidad_encontrados%>&nbsp; Alumnos
						   </td>
						</tr>
						<tr>
                          <td><div align="right">P&aacute;gina:<%f_alumno.accesopagina%></div></td>
                        </tr>
					    <tr>
                          <td><div align="center"><%f_alumno.DibujaTabla%></div></td>
                        </tr>
                      </table></td>
                  </tr>
                </table>
                          <br>
            </form></td></tr>
        </table></td>
        <td width="7" background="../imagenes/der.gif">&nbsp;</td>
      </tr>
      <tr>
        <td width="9" height="28"><img src="../imagenes/abajo_r1_c1.gif" width="9" height="28"></td>
        <td height="28"><table width="100%" height="28"  border="0" cellpadding="0" cellspacing="0">
          <tr>
            <td width="9%" height="20"><div align="center">
              <table width="90%"  border="0" cellspacing="0" cellpadding="0">
                <tr>
                  <td><div align="left"><%f_botonera.DibujaBoton("salir")%></div></td>
                  </tr>
              </table>
            </div></td>
            <td width="71%" rowspan="2" background="../imagenes/abajo_r1_c4.gif"><img src="../imagenes/abajo_r1_c3.gif" width="12" height="28"></td>
            </tr>
          <tr>
            <td height="8" background="../imagenes/abajo_r2_c2.gif"></td>
          </tr>
        </table></td>
        <td width="7" height="28"><img src="../imagenes/abajo_r1_c5.gif" width="7" height="28"></td>
      </tr>
    </table>
	<br>
	<br>
	</td>
  </tr>  
</table>
</body>
</html>
