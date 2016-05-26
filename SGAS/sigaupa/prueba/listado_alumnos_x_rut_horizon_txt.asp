<!-- #include file = "../biblioteca/_conexion.asp" -->
<%

Response.AddHeader "Content-Disposition", "attachment;filename=alumnos_nuevos_horizon_2013.txt"
Response.ContentType = "text/plain"
Server.ScriptTimeOut = 150000

set conexion = new CConexion
conexion.Inicializar "upacifico"
'------------------------------------------------------------------------------------
fecha=conexion.consultaUno("select cast(datePart(day,getDate())as varchar)+'-'+cast(datePart(month,getDate()) as varchar)+'-'+cast(datePart(year,getDate()) as varchar) as fecha")
'------------------------------------------------------------------------------------
set formulario = new CFormulario
formulario.Carga_Parametros "tabla_vacia.xml", "tabla"
formulario.Inicializar conexion
coma=","

consulta ="select 'A' as action_code,protic.obtener_rut(c.pers_ncorr)as bbarcode, "& vbCrLf &_
" '"&CHR(034)&"'+(select pers_tape_paterno+' '+pers_tape_materno+' , '+pers_tnombre from personas aa where pers_ncorr=c.pers_ncorr )+'"&CHR(034)&"' as 'name',"& vbCrLf &_
" (select top 1 email_nuevo from cuentas_email_upa zz where zz.pers_ncorr=c.pers_ncorr)as email_address,"& vbCrLf &_
" replace(protic.obtener_direccion(c.pers_ncorr,1,'CNPB'),"&CHR(039)&""&CHR(044)&""&CHR(039)&","&CHR(039)&" "&CHR(039)&")as address1,"& vbCrLf &_
" (select case when pers_tfono='' then (select case when dire_tfono='' then dire_tcelular else dire_tfono end from direcciones zz where zz.pers_ncorr=c.pers_ncorr and tdir_ccod=1) else pers_tfono end from personas zz where zz.pers_ncorr=c.pers_ncorr) as phone_no,"& vbCrLf &_
" (select isnull(protic.obtener_ciudades_horizon(aa.ciud_ccod),'Stgo') from direcciones aa  where aa.pers_ncorr=c.pers_ncorr and tdir_ccod=1)as city_st,"& vbCrLf &_
" protic.obtener_carrera_horizon(d.carr_ccod,a.jorn_ccod)as bstat,"& vbCrLf &_
"protic.obtener_sede_horizon(b.sede_ccod )location,"& vbCrLf &_
"case when a.jorn_ccod =1 then 'AD' else 'AV'end as btype,"& vbCrLf &_
"c.pers_ncorr,protic.obtener_rut(c.pers_ncorr)as second_id,"& vbCrLf &_
"b.sede_ccod, sede_tdesc  "& vbCrLf &_
"        from ofertas_academicas a "& vbCrLf &_
"            left outer join sedes b "& vbCrLf &_
"                on a.sede_ccod =b.sede_ccod "& vbCrLf &_
"            left outer join alumnos c "& vbCrLf &_
"                on a.ofer_ncorr =c.ofer_ncorr "& vbCrLf &_
"            right outer join especialidades d "& vbCrLf &_
"                on a.espe_ccod = d.espe_ccod "& vbCrLf &_
"			join carreras e"& vbCrLf &_
"           on d.CARR_CCOD=e.CARR_CCOD"& vbCrLf &_ 
"			where c.emat_ccod in (1,4,8,2,15,16)  and c.audi_tusuario not like '%ajunte matricula%'"& vbCrLf &_
"			and protic.afecta_estadistica(c.matr_ncorr) > 0 "& vbCrLf &_
"			and a.peri_ccod in (230) "& vbCrLf &_
"			--and e.TCAR_CCOD=2"& vbCrLf &_
"			and isnull(c.alum_nmatricula,0) not in (7777) "& vbCrLf &_
"	        and c.audi_tusuario not in ('Agregabase_saenzBeta2','AgregaBaseSaenzBeta2','AgregaNota2T','AgregaNota37','AgregaNota3Nuevo','AgregaNota41','AgregaNota42',"& vbCrLf &_
"                   'AgregaNota43','AgregaNota45','AgregaNota46','AgregaNota49','AgregaNota491T','AgregaNota492T','AgregaNota4diu2003','AgregaNota4diurno', "& vbCrLf &_
"                   'AgregaNota4T','AgregaNota4vesp','AgregaNota4vesp2003','AgregaNota52','AgregaNota60','AgregaNota61','AgregaNota64','AgregaNota65', "& vbCrLf &_
"                   'AgregaNota69','AgregaNota80','AgregaNota81','AgregaNota83','AgregaNota85','AgregaNota88','AgregaNota98','AgregaNota99','AgregaNotaN', "& vbCrLf &_
"                   'AgregaNotaProtix','AgregaNotaprotix1','Agreganotas_saenzBeta2','AgregaNotas46$','AgregaNotas46$Beta','AgregaNotas46$Beta2','AgregaNotasSaenzBeta2', "& vbCrLf &_
"                   'Agregaprotix_saenzBeta2','AgregaProtixSaenzBeta2') "& vbCrLf &_
" 		 		And c.pers_ncorr > 0 "& vbCrLf &_
"		 and (select post_bnuevo from postulantes where post_ncorr=c.post_ncorr) = 'S' "
'" and pers_ncorr in (156163	,"& vbCrLf &_
'"176613	,"& vbCrLf &_
'"16140	,"& vbCrLf &_
'"176592	,"& vbCrLf &_
'"176599	)"


' "c.PERS_TEMAIL as email_address,"& vbCrLf &_

'/****************************Usar para alumnos de diplomados **********************************************************************************/
'consulta=" select 'A' as action_code,protic.obtener_rut(c.pers_ncorr)as bbarcode, "& vbCrLf &_
'" '"&comillas&"'+(select pers_tape_paterno+' '+pers_tape_materno+' , '+pers_tnombre from personas aa where pers_ncorr=c.pers_ncorr )+'"&CHR(034)&"' as 'name',"& vbCrLf &_
' " (select top 1 email_nuevo from cuentas_email_upa zz where zz.pers_ncorr=c.pers_ncorr)as email_address,"& vbCrLf &_
' "case when replace(protic.obtener_direccion(c.pers_ncorr,1,'CNPB'),',',' ')= '. .' then 'No Registra' else replace(protic.obtener_direccion(c.pers_ncorr,1,'CNPB'),',',' ') end as address1,"& vbCrLf &_
' "(select case when pers_tfono='' then (select case when dire_tfono='' then dire_tcelular else dire_tfono end from direcciones zz where zz.pers_ncorr=c.pers_ncorr and tdir_ccod=1) else pers_tfono end from personas zz where zz.pers_ncorr=c.pers_ncorr) as phone_no,"& vbCrLf &_
' "(select isnull(protic.obtener_ciudades_horizon(aa.ciud_ccod),'Stgo') from direcciones aa  where aa.pers_ncorr=c.pers_ncorr and tdir_ccod=1)as city_st,"& vbCrLf &_
' "'MCE'as bstat,"& vbCrLf &_
'"protic.obtener_sede_horizon(2) as location,"& vbCrLf &_
'"'AV' as btype,"& vbCrLf &_
'"c.pers_ncorr,protic.obtener_rut(c.pers_ncorr)as second_id,"& vbCrLf &_
'"'' as sede_ccod, "& vbCrLf &_
'"'' as sede_tdesc  "& vbCrLf &_
'"        from personas c"& vbCrLf &_
'"		where pers_nrut in (16356289"& vbCrLf &_
'",7959091"& vbCrLf &_
'",15370467"& vbCrLf &_
'",10031378"& vbCrLf &_
'",10808258"& vbCrLf &_
'") "



'/*******************************************************************************************************************************************/

response.Write("<pre>"&consulta&"</pre>")
response.End()

formulario.Consultar consulta
response.Write("action_code,bbarcode,name,email_address,address1,phone_no,city_st,bstat,location,btype,second_id")
Response.Write(vbCrLf)
while formulario.siguiente
				action_code = formulario.obtenerValor("action_code")
				response.Write(action_code&",")
				bbarcode = formulario.obtenerValor("bbarcode")
				response.Write(bbarcode&",")
				names = formulario.obtenerValor("name")
				response.Write(names&",")
				email_address = formulario.obtenerValor("email_address")
				response.Write(email_address&",")
				address1 = formulario.obtenerValor("address1")
				response.Write(address1&",")
				phone_no = formulario.obtenerValor("phone_no")
				response.Write(phone_no&",")
				city_st = formulario.obtenerValor("city_st")				
				response.Write(city_st&",")
				bstat = formulario.obtenerValor("bstat")
				response.Write(bstat&",")
				location = formulario.obtenerValor("location")
				response.Write(location&",")
				btype = formulario.obtenerValor("btype")
				response.Write(btype&",")
				second_id = formulario.obtenerValor("second_id")
				response.Write(second_id)
				Response.Write(vbCrLf)
wend

%>
