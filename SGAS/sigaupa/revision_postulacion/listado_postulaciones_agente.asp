<!-- #include file = "../biblioteca/_conexion.asp" -->
<!-- #include file = "../biblioteca/_negocio.asp" -->

<%
set pagina = new CPagina
pagina.Titulo = "Listado de Postulantes asociados al Agente"
rut = request.querystring("busqueda[0][pers_nrut]")
digito = request.querystring("busqueda[0][pers_xdv]")
'---------------------------------------------------------------------------------------------------
set conexion = new CConexion
conexion.Inicializar "upacifico"

set negocio = new CNegocio
negocio.Inicializa conexion

 set f_busqueda = new CFormulario
 f_busqueda.Carga_Parametros "listado_postulaciones_agente.xml", "busqueda_usuarios_nuevo"
 f_busqueda.Inicializar conexion
 f_busqueda.Consultar "select '' "
 f_busqueda.Siguiente
 
 f_busqueda.AgregaCampoCons "pers_nrut", rut
 f_busqueda.AgregaCampoCons "pers_xdv", digito


'--------------------------------------------------------------------------
periodo = negocio.obtenerPeriodoAcademico("Postulacion")
pers_ncorr_agente = conexion.consultaUno("select pers_ncorr from personas where cast(pers_nrut as varchar)='"&negocio.obtenerUsuario&"'")
rut_agente = conexion.consultaUno("select cast(pers_nrut as varchar)+ '-'+ pers_xdv from personas where cast(pers_nrut as varchar)='"&negocio.obtenerUsuario&"'")
nombre_agente = conexion.consultaUno("select protic.initcap(Pers_tnombre + ' ' + pers_tape_paterno + ' ' +pers_tape_materno) from personas where cast(pers_nrut as varchar)='"&negocio.obtenerUsuario&"'")
peri_tdesc = conexion.consultaUno("select protic.initCap(peri_tdesc) from periodos_academicos where cast(peri_ccod as varchar)='"&periodo&"'")
'--------------------------------------------------------------------------
set botonera = new CFormulario
botonera.Carga_Parametros "listado_postulaciones_agente.xml", "botonera"
'--------------------------------------------------------------------------
set formulario = new CFormulario
formulario.Carga_Parametros "listado_postulaciones_agente.xml", "f_listado"
formulario.Inicializar conexion
if rut_agente = "17176569-2" then
	filtro = ""
	filtro2 = ""
else
	filtro = " and cast(a.pers_ncorr as varchar)='"&pers_ncorr_agente&"'"'para solo mostrar los postulantes del agente
	filtro2 = " and cc.sede_ccod= a.sede_ccod"'para ver si fue gestionado por el agente de la sede
end if
consulta_llamados = ""'variable que guardará la consulta para todos los alumnos a llamar el día en que se abra la función

consulta = " select distinct c.pers_ncorr,cast(c.pers_nrut as varchar)+'-'+c.pers_xdv as rut, "& vbcrlf & _
		   " c.pers_tnombre + ' ' +c.pers_tape_paterno + ' ' + c.pers_tape_materno as alumno,fecha_ingreso, protic.trunc(fecha_ingreso) as ingresado, "& vbcrlf & _
		   " (select count(*) from postulantes_por_agente bb where bb.post_ncorr=b.post_ncorr) as total_agentes,   "& vbcrlf & _
		   " (select count(*) from detalle_postulantes bb where bb.post_ncorr=b.post_ncorr) as total_carreras, "& vbcrlf & _
		   " (select case count(*) when 0 then 'No' else 'Sí' end from observaciones_postulacion bb,ofertas_academicas cc where bb.ofer_ncorr=cc.ofer_ncorr and bb.post_ncorr=b.post_ncorr "&filtro2&") as gestionado, "& vbcrlf & _
		   " (select protic.trunc(max(bb.audi_fmodificacion)) from observaciones_postulacion bb,ofertas_academicas cc where bb.ofer_ncorr=cc.ofer_ncorr and bb.post_ncorr=b.post_ncorr "&filtro2&") as ultima_modificacion "& vbcrlf & _
		   " from postulantes_por_agente a, postulantes b, personas_postulante c "& vbcrlf & _
		   " where a.post_ncorr=b.post_ncorr and b.pers_ncorr=c.pers_ncorr and cast(b.peri_ccod as varchar)='"&periodo&"'"& vbcrlf & _
		   " " & filtro & vbcrlf & _
		   " and not exists (select 1 from alumnos cc where cc.post_ncorr=b.post_ncorr) "
		   
if periodo = "226" then
	consulta = " select distinct c.pers_ncorr,cast(c.pers_nrut as varchar)+'-'+c.pers_xdv as rut, "& vbcrlf & _
			   " protic.initcap(c.pers_tnombre + ' ' +c.pers_tape_paterno + ' ' + c.pers_tape_materno) as alumno,fecha_ingreso, "& vbcrlf & _
			   " protic.trunc(fecha_ingreso) as ingresado,  "& vbcrlf & _
			   " (select count(*) from admi_postulantes_por_agente bb where bb.pers_ncorr=b.pers_ncorr "& vbcrlf & _
			   "                  and bb.peri_ccod=b.peri_ccod ) as total_agentes,    "& vbcrlf & _
			   " (select count(*) from detalle_postulantes bb where bb.post_ncorr=b.post_ncorr) as total_carreras,  "& vbcrlf & _
			   " (select case count(*) when 0 then 'No' else 'Sí' end  "& vbcrlf & _
			   "  from observaciones_postulacion bb,ofertas_academicas cc where bb.ofer_ncorr=cc.ofer_ncorr and bb.post_ncorr=b.post_ncorr) as gestionado,  "& vbcrlf & _
			   " (select protic.trunc(max(bb.audi_fmodificacion))  "& vbcrlf & _
			   "  from observaciones_postulacion bb,ofertas_academicas cc  "& vbcrlf & _
			   "  where bb.ofer_ncorr=cc.ofer_ncorr and bb.post_ncorr=b.post_ncorr) as ultima_modificacion  "& vbcrlf & _
			   " from admi_postulantes_por_agente a, postulantes b, personas_postulante c  "& vbcrlf & _
			   " where a.pers_ncorr=b.pers_ncorr  "& vbcrlf & _
			   " and a.peri_ccod=b.peri_ccod "& vbcrlf & _
			   " and b.pers_ncorr=c.pers_ncorr  "& vbcrlf & _
   			   " and cast(b.peri_ccod as varchar)='"&periodo&"'"& vbcrlf & _
			   " and cast(a.pers_ncorr_agente as varchar)='"&pers_ncorr_agente&"'" & vbcrlf & _
			   " and not exists (select 1 from alumnos cc where cc.post_ncorr=b.post_ncorr) "
			   
consulta_llamados= " select distinct c.pers_ncorr,cast(c.pers_nrut as varchar)+'-'+c.pers_xdv as rut, "& vbcrlf & _
				   " protic.initcap(c.pers_tnombre + ' ' +c.pers_tape_paterno + ' ' + c.pers_tape_materno) as alumno,fecha_ingreso, "& vbcrlf & _
				   " protic.trunc(fecha_ingreso) as ingresado,  "& vbcrlf & _
				   " (select count(*) from admi_postulantes_por_agente bb where bb.pers_ncorr=b.pers_ncorr "& vbcrlf & _
				   "                  and bb.peri_ccod=b.peri_ccod ) as total_agentes,    "& vbcrlf & _
				   " (select count(*) from detalle_postulantes bb where bb.post_ncorr=b.post_ncorr) as total_carreras,  "& vbcrlf & _
				   " (select case count(*) when 0 then 'No' else 'Sí' end  "& vbcrlf & _
				   "  from observaciones_postulacion bb,ofertas_academicas cc where bb.ofer_ncorr=cc.ofer_ncorr and bb.post_ncorr=b.post_ncorr) as gestionado,  "& vbcrlf & _
				   " (select protic.trunc(max(bb.audi_fmodificacion))  "& vbcrlf & _
				   "  from observaciones_postulacion bb,ofertas_academicas cc  "& vbcrlf & _
				   "  where bb.ofer_ncorr=cc.ofer_ncorr and bb.post_ncorr=b.post_ncorr) as ultima_modificacion  "& vbcrlf & _
				   " from admi_postulantes_por_agente a, postulantes b, personas_postulante c  "& vbcrlf & _
				   " where a.pers_ncorr=b.pers_ncorr  "& vbcrlf & _
				   " and a.peri_ccod=b.peri_ccod "& vbcrlf & _
				   " and b.pers_ncorr=c.pers_ncorr  "& vbcrlf & _
				   " and cast(b.peri_ccod as varchar)='"&periodo&"'"& vbcrlf & _
				   " and cast(a.pers_ncorr_agente as varchar)='"&pers_ncorr_agente&"'" & vbcrlf & _
				   " and exists (select 1  "& vbcrlf & _
 				   "             from observaciones_postulacion tt   "& vbcrlf & _
				   "             where convert(datetime,protic.trunc(tt.fecha_llamado),103)=convert(datetime,protic.trunc(getDate()),103)  "& vbcrlf & _
				   "             and tt.post_ncorr=b.post_ncorr   "& vbcrlf & _
             	   "            )  "& vbcrlf & _
				   " and not exists (select 1 from alumnos cc where cc.post_ncorr=b.post_ncorr) "

consulta_estadistica = " select distinct c.pers_ncorr,cast(c.pers_nrut as varchar)+'-'+c.pers_xdv as rut, "& vbcrlf & _
					   " protic.initcap(c.pers_tnombre + ' ' +c.pers_tape_paterno + ' ' + c.pers_tape_materno) as alumno, fecha_ingreso, "& vbcrlf & _
					   " protic.trunc(fecha_ingreso) as ingresado,  "& vbcrlf & _
					   " (select count(*) from admi_postulantes_por_agente bb where bb.pers_ncorr=b.pers_ncorr "& vbcrlf & _
					   "                  and bb.peri_ccod=b.peri_ccod ) as total_agentes,    "& vbcrlf & _
					   " (select count(*) from detalle_postulantes bb where bb.post_ncorr=b.post_ncorr) as total_carreras,  "& vbcrlf & _
					   " (select case count(*) when 0 then 'No' else 'Sí' end  "& vbcrlf & _
					   "  from observaciones_postulacion bb,ofertas_academicas cc where bb.ofer_ncorr=cc.ofer_ncorr and bb.post_ncorr=b.post_ncorr) as gestionado,  "& vbcrlf & _
					   " (select protic.trunc(max(bb.audi_fmodificacion))  "& vbcrlf & _
					   "  from observaciones_postulacion bb,ofertas_academicas cc  "& vbcrlf & _
					   "  where bb.ofer_ncorr=cc.ofer_ncorr and bb.post_ncorr=b.post_ncorr) as ultima_modificacion,  "& vbcrlf & _
					   " (select case count(*) when 0 then 'No' else 'Sí' end from alumnos cc where cc.post_ncorr=b.post_ncorr) as matriculado "& vbcrlf & _
					   " from admi_postulantes_por_agente a, postulantes b, personas_postulante c  "& vbcrlf & _
					   " where a.pers_ncorr=b.pers_ncorr  "& vbcrlf & _
					   " and a.peri_ccod=b.peri_ccod "& vbcrlf & _
					   " and b.pers_ncorr=c.pers_ncorr  "& vbcrlf & _
					   " and cast(b.peri_ccod as varchar)='"&periodo&"'"& vbcrlf & _
					   " and cast(a.pers_ncorr_agente as varchar)='"&pers_ncorr_agente&"'"
						   			   				   			   
end if

if rut_agente = "6289563-2" or rut_agente = "12863241-7"	then ' para mostrar a Susana Arancibia los postulados a magister
consulta = " select distinct c.pers_ncorr,cast(c.pers_nrut as varchar)+'-'+c.pers_xdv as rut, "& vbcrlf & _
		   " c.pers_tnombre + ' ' +c.pers_tape_paterno + ' ' + c.pers_tape_materno as alumno,b.post_fpostulacion as fecha_ingreso, protic.trunc(b.post_fpostulacion) as ingresado, "& vbcrlf & _
		   " '1' as total_agentes,   "& vbcrlf & _
		   " (select count(*) from detalle_postulantes bb where bb.post_ncorr=b.post_ncorr) as total_carreras, "& vbcrlf & _
		   " (select case count(*) when 0 then 'No' else 'Sí' end from observaciones_postulacion bb,ofertas_academicas cc where bb.ofer_ncorr=cc.ofer_ncorr and bb.post_ncorr=b.post_ncorr) as gestionado, "& vbcrlf & _
		   " (select protic.trunc(max(bb.audi_fmodificacion)) from observaciones_postulacion bb,ofertas_academicas cc where bb.ofer_ncorr=cc.ofer_ncorr and bb.post_ncorr=b.post_ncorr) as ultima_modificacion "& vbcrlf & _
		   " from postulantes b, personas_postulante c, detalle_postulantes d, ofertas_academicas e "& vbcrlf & _
		   " where b.pers_ncorr=c.pers_ncorr and cast(b.peri_ccod as varchar)='"&periodo&"'"& vbcrlf & _
		   " and b.post_ncorr=d.post_ncorr and d.ofer_ncorr=e.ofer_ncorr and cast(e.espe_ccod as varchar)='349' " & vbcrlf & _
		   " and not exists (select 1 from alumnos cc where cc.post_ncorr=b.post_ncorr) "
elseif rut_agente = "6939582-1"	then ' para mostrar a Sonia Soler los postulados a magister
consulta = " select distinct c.pers_ncorr,cast(c.pers_nrut as varchar)+'-'+c.pers_xdv as rut, "& vbcrlf & _
		   " c.pers_tnombre + ' ' +c.pers_tape_paterno + ' ' + c.pers_tape_materno as alumno,b.post_fpostulacion as fecha_ingreso, protic.trunc(b.post_fpostulacion) as ingresado, "& vbcrlf & _
		   " '1' as total_agentes,   "& vbcrlf & _
		   " (select count(*) from detalle_postulantes bb where bb.post_ncorr=b.post_ncorr) as total_carreras, "& vbcrlf & _
		   " (select case count(*) when 0 then 'No' else 'Sí' end from observaciones_postulacion bb,ofertas_academicas cc where bb.ofer_ncorr=cc.ofer_ncorr and bb.post_ncorr=b.post_ncorr) as gestionado, "& vbcrlf & _
		   " (select protic.trunc(max(bb.audi_fmodificacion)) from observaciones_postulacion bb,ofertas_academicas cc where bb.ofer_ncorr=cc.ofer_ncorr and bb.post_ncorr=b.post_ncorr) as ultima_modificacion "& vbcrlf & _
		   " from postulantes b, personas_postulante c, detalle_postulantes d, ofertas_academicas e "& vbcrlf & _
		   " where b.pers_ncorr=c.pers_ncorr and cast(b.peri_ccod as varchar)='"&periodo&"'"& vbcrlf & _
		   " and b.post_ncorr=d.post_ncorr and d.ofer_ncorr=e.ofer_ncorr and e.espe_ccod in ('351','18') " & vbcrlf & _
		   " and not exists (select 1 from alumnos cc where cc.post_ncorr=b.post_ncorr) "
elseif rut_agente = "14461680-4"	then ' para mostrar a PATRICK LAUREAU  los postulados a magister
consulta = " select distinct c.pers_ncorr,cast(c.pers_nrut as varchar)+'-'+c.pers_xdv as rut, "& vbcrlf & _
		   " c.pers_tnombre + ' ' +c.pers_tape_paterno + ' ' + c.pers_tape_materno as alumno,b.post_fpostulacion as fecha_ingreso, protic.trunc(b.post_fpostulacion) as ingresado, "& vbcrlf & _
		   " '1' as total_agentes,   "& vbcrlf & _
		   " (select count(*) from detalle_postulantes bb where bb.post_ncorr=b.post_ncorr) as total_carreras, "& vbcrlf & _
		   " (select case count(*) when 0 then 'No' else 'Sí' end from observaciones_postulacion bb,ofertas_academicas cc where bb.ofer_ncorr=cc.ofer_ncorr and bb.post_ncorr=b.post_ncorr) as gestionado, "& vbcrlf & _
		   " (select protic.trunc(max(bb.audi_fmodificacion)) from observaciones_postulacion bb,ofertas_academicas cc where bb.ofer_ncorr=cc.ofer_ncorr and bb.post_ncorr=b.post_ncorr) as ultima_modificacion "& vbcrlf & _
		   " from postulantes b, personas_postulante c, detalle_postulantes d, ofertas_academicas e "& vbcrlf & _
		   " where b.pers_ncorr=c.pers_ncorr and cast(b.peri_ccod as varchar)='"&periodo&"'"& vbcrlf & _
		   " and b.post_ncorr=d.post_ncorr and d.ofer_ncorr=e.ofer_ncorr and e.espe_ccod in ('350') " & vbcrlf & _
		   " and not exists (select 1 from alumnos cc where cc.post_ncorr=b.post_ncorr) "
elseif rut_agente = "11592558-K"	then ' para mostrar a Marco Perelli  los postulados a todos los postgrados
consulta = " select distinct c.pers_ncorr,cast(c.pers_nrut as varchar)+'-'+c.pers_xdv as rut, "& vbcrlf & _
		   " c.pers_tnombre + ' ' +c.pers_tape_paterno + ' ' + c.pers_tape_materno as alumno,b.post_fpostulacion as fecha_ingreso, protic.trunc(b.post_fpostulacion) as ingresado, "& vbcrlf & _
		   " '1' as total_agentes,   "& vbcrlf & _
		   " (select count(*) from detalle_postulantes bb where bb.post_ncorr=b.post_ncorr) as total_carreras, "& vbcrlf & _
		   " (select case count(*) when 0 then 'No' else 'Sí' end from observaciones_postulacion bb,ofertas_academicas cc where bb.ofer_ncorr=cc.ofer_ncorr and bb.post_ncorr=b.post_ncorr) as gestionado, "& vbcrlf & _
		   " (select protic.trunc(max(bb.audi_fmodificacion)) from observaciones_postulacion bb,ofertas_academicas cc where bb.ofer_ncorr=cc.ofer_ncorr and bb.post_ncorr=b.post_ncorr) as ultima_modificacion "& vbcrlf & _
		   " from postulantes b, personas_postulante c, detalle_postulantes d, ofertas_academicas e "& vbcrlf & _
		   " where b.pers_ncorr=c.pers_ncorr and cast(b.peri_ccod as varchar)='"&periodo&"'"& vbcrlf & _
		   " and b.post_ncorr=d.post_ncorr and d.ofer_ncorr=e.ofer_ncorr and e.espe_ccod in ('349','350','351','18') " & vbcrlf & _
		   " and not exists (select 1 from alumnos cc where cc.post_ncorr=b.post_ncorr) "
elseif rut_agente = "7825297-9" or rut_agente = "7741077-5"	then ' para mostrar a Juan Basso y Leonor Herrera  los postulados a todos los postgrados
consulta = " select distinct c.pers_ncorr,cast(c.pers_nrut as varchar)+'-'+c.pers_xdv as rut, "& vbcrlf & _
		   " c.pers_tnombre + ' ' +c.pers_tape_paterno + ' ' + c.pers_tape_materno as alumno,b.post_fpostulacion as fecha_ingreso, protic.trunc(b.post_fpostulacion) as ingresado, "& vbcrlf & _
		   " '1' as total_agentes,   "& vbcrlf & _
		   " (select count(*) from detalle_postulantes bb where bb.post_ncorr=b.post_ncorr) as total_carreras, "& vbcrlf & _
		   " (select case count(*) when 0 then 'No' else 'Sí' end from observaciones_postulacion bb,ofertas_academicas cc where bb.ofer_ncorr=cc.ofer_ncorr and bb.post_ncorr=b.post_ncorr) as gestionado, "& vbcrlf & _
		   " (select protic.trunc(max(bb.audi_fmodificacion)) from observaciones_postulacion bb,ofertas_academicas cc where bb.ofer_ncorr=cc.ofer_ncorr and bb.post_ncorr=b.post_ncorr) as ultima_modificacion "& vbcrlf & _
		   " from postulantes b, personas_postulante c, detalle_postulantes d, ofertas_academicas e "& vbcrlf & _
		   " where b.pers_ncorr=c.pers_ncorr and cast(b.peri_ccod as varchar)='"&periodo&"'"& vbcrlf & _
		   " and b.post_ncorr=d.post_ncorr and d.ofer_ncorr=e.ofer_ncorr and e.espe_ccod in ('18','349','350') " & vbcrlf & _
		   " and not exists (select 1 from alumnos cc where cc.post_ncorr=b.post_ncorr) "		   
end if


if len(rut) > 0 then
	consulta = consulta & " and cast(c.pers_nrut as varchar)='"&rut&"' "
end if		  

cantidad_encontrados = conexion.consultaUno("select count(*) from ("&consulta&")a")	   
'response.Write("<pre>"&consulta&"</pre>")		   
'response.End()
formulario.Consultar consulta & " order by gestionado,fecha_ingreso desc"
'response.Write("<pre>"&consulta & " order by gestionado,fecha_ingreso desc")	   

if consulta_llamados <> "" then
	set formulario_llamados = new CFormulario
	formulario_llamados.Carga_Parametros "listado_postulaciones_agente.xml", "f_listado_del_dia"
	formulario_llamados.Inicializar conexion
	
	formulario_llamados.Consultar consulta_llamados & " order by gestionado,fecha_ingreso desc"
	
	set formulario_estadistica = new CFormulario
	formulario_estadistica.Carga_Parametros "tabla_vacia.xml", "tabla"
	formulario_estadistica.Inicializar conexion
	formulario_estadistica.Consultar consulta_estadistica 
	total_gestionado=0
	total_completo=0
	total_matriculado=0
	total_sin_gestion=0
	while formulario_estadistica.siguiente
		total_completo = total_completo + 1
		if formulario_estadistica.obtenerValor("gestionado") = "Sí" and formulario_estadistica.obtenerValor("matriculado")="No" then
			total_gestionado = total_gestionado + 1 
		elseif formulario_estadistica.obtenerValor("gestionado") = "No" and formulario_estadistica.obtenerValor("matriculado")="No" then
			total_sin_gestion = total_sin_gestion + 1
		end if
		if formulario_estadistica.obtenerValor("matriculado")="Sí" then
			total_matriculado = total_matriculado + 1 
		end if
	wend
	'total_sin_gestion = total_completo - total_gestionado
	if total_completo > 0 then 
		porc_sin_gestion  = Round ((total_sin_gestion * 100) / total_completo , 2)
		porc_sin_gestion_r  = Round ((total_sin_gestion * 100) / total_completo)
		porc_gestion      = Round ((total_gestionado  * 100) / total_completo , 2)
		porc_gestion_r    = Round ((total_gestionado  * 100) / total_completo)
		porc_matricu      = Round ((total_matriculado * 100) / total_completo , 2)
		porc_matricu_r    = Round ((total_matriculado * 100) / total_completo)
	end if
	
end if
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

function Validar()
{
	formulario = document.buscador;
	
	rut_alumno = formulario.elements["busqueda[0][pers_nrut]"].value + "-" + formulario.elements["busqueda[0][pers_xdv]"].value;	
	if (formulario.elements["busqueda[0][pers_nrut]"].value  != '')
  	  if (!valida_rut(rut_alumno)) {
		alert('Ingrese un RUT válido.');
		formulario.elements["busqueda[0][pers_xdv]"].focus();
		formulario.elements["busqueda[0][pers_xdv]"].select();
		return false;
	  }
	
	
	return true;
}

function genera_digito (rut){
 var IgStringVerificador, IgN, IgSuma, IgDigito, IgDigitoVerificador, rut;
 var texto_rut = new String(rut);
 var posicion_guion = 0;
 
 posicion_guion = texto_rut.indexOf("-");
 if (posicion_guion != -1)
 {
    texto_rut = texto_rut.substring(0,posicion_guion);
    document.buscador.elements["busqueda[0][pers_nrut]"].value= texto_rut;
	rut = texto_rut;
 }
// texto_rut.
 //alert(texto_rut);
   if (rut.length==7) rut = '0' + rut; 

   
   IgStringVerificador = '32765432';
   IgSuma = 0;
   for( IgN = 0; IgN < 8 && IgN < rut.length; IgN++)
      IgSuma = eval(IgSuma + '+' + rut.substr(IgN, 1) + '*' + IgStringVerificador.substr(IgN, 1) + ';');
   IgDigito = 11 - IgSuma % 11;
   IgDigitoVerificador = IgDigito==10?'K':IgDigito==11?'0':IgDigito;
   //alert(IgDigitoVerificador);
buscador.elements["busqueda[0][pers_xdv]"].value=IgDigitoVerificador;
//alert(rut+IgDigitoVerificador);
_Buscar(this, document.forms['buscador'],'', 'Validar();', 'FALSE');
}

</script>

</head>
<body bgcolor="#CC6600" leftmargin="0" topmargin="0" marginwidth="0" marginheight="0" onLoad="MM_preloadImages('../imagenes/botones/buscar_f2.gif','../images/bot_deshabilitar_f2.gif','../images/agregar2_f2_p.gif','im&amp;#225;genes/marco1_r3_c2_f2.gif');MM_preloadImages('im&amp;#225;genes/marco1_r3_c4_f2.gif');MM_preloadImages('im&amp;#225;genes/marco1_r3_c6_f2.gif');MM_preloadImages('im&amp;#225;genes/marco1_r3_c8_f2.gif');MM_preloadImages('../imagenes/botones/cargar_f2.gif','../imagenes/botones/continuar_f2.gif')">
<table width="750" border="0" align="center" cellpadding="0" cellspacing="0">
  <tr>
    <td><img src="../imagenes/vineta2_r1_c1.gif" width="750" height="72" border="0"></td>
  </tr>
  <%pagina.DibujarEncabezado()%>  
  <tr>
    <td valign="top" bgcolor="#EAEAEA">
	<br>
      <table width="90%" border="0" align="center" cellpadding="0" cellspacing="0">
        <tr>
          <td><table border="0" cellpadding="0" cellspacing="0" width="100%">
              <!-- fwtable fwsrc="marco contenidos.png" fwbase="top.gif" fwstyle="Dreamweaver" fwdocid = "742308039" fwnested="0" -->
              <tr>
                <td><img src="../imagenes/spacer.gif" width="9" height="1" border="0" alt=""></td>
                <td><img src="../imagenes/spacer.gif" width="559" height="1" border="0" alt=""></td>
                <td><img src="../imagenes/spacer.gif" width="7" height="1" border="0" alt=""></td>
              </tr>
              <tr>
                <td><img name="top_r1_c1" src="../imagenes/top_r1_c1.gif" width="9" height="8" border="0" alt=""></td>
                <td><img src="../imagenes/top_r1_c2.gif" alt="" name="top_r1_c2" width="670" height="8" border="0"></td>
                <td><img name="top_r1_c3" src="../imagenes/top_r1_c3.gif" width="7" height="8" border="0" alt=""></td>
              </tr>
              <tr>
                <td><img name="top_r2_c1" src="../imagenes/top_r2_c1.gif" width="9" height="17" border="0" alt=""></td>
                <td><table width="100%" border="0" cellspacing="0" cellpadding="0">
                    <tr>
                      <td width="13" background="../imagenes/fondo1.gif"><img src="../imagenes/izq_1.gif" width="5" height="17"></td>
                      <td width="209" valign="middle" background="../imagenes/fondo1.gif">
                      <div align="left"><font color="#FFFFFF" size="1" face="Verdana, Arial, Helvetica, sans-serif">Listado 
                          Postulantes del Agente<br></font></div></td>
                      <td width="448" bgcolor="#D8D8DE"><img src="../imagenes/derech1.gif" width="6" height="17"></td>
                    </tr>
                </table></td>
                <td><img name="top_r2_c3" src="../imagenes/top_r2_c3.gif" width="7" height="17" border="0" alt=""></td>
              </tr>
              <tr>
                <td><img name="top_r3_c1" src="../imagenes/top_r3_c1.gif" width="9" height="2" border="0" alt=""></td>
                <td><img name="top_r3_c2" src="../imagenes/top_r3_c2.gif" width="670" height="2" border="0" alt=""></td>
                <td><img name="top_r3_c3" src="../imagenes/top_r3_c3.gif" width="7" height="2" border="0" alt=""></td>
              </tr>
            </table>
              <table width="100%" border="0" cellspacing="0" cellpadding="0" aling="center">
                <tr>
                  <td width="9" align="left" background="../imagenes/izq.gif">&nbsp;</td>
                  
                <td bgcolor="#D8D8DE">
				  <table width="98%" border="0">
					<tr> 
                       <td width="100%">&nbsp;</td>
					</tr>
					<tr> 
                       <td width="100%"><div align="center"><%pagina.DibujarTituloPagina%>
                        </div></td>
					</tr>
					<tr> 
                       <td width="100%">&nbsp;</td>
					</tr>
					<tr> 
                       <td width="100%" align="center">
					      <table width="60%" bgcolor="#f7f5ef">
						   <form name="buscador">
						  	<tr>
								<td width="40%" align="right"><font color="#0000FF"><strong>RUT a Buscar:</strong></font></td>
								<td width="40%" align="left"><font face="Verdana, Arial, Helvetica, sans-serif" size="1"> 
                                        <%f_busqueda.DibujaCampo("pers_nrut") %>
                                        - 
                                        <%f_busqueda.DibujaCampo("pers_xdv")%>
                                        </font><a href="javascript:buscar_persona('busqueda[0][pers_nrut]', 'busqueda[0][pers_xdv]');"><img src="../imagenes/lupa_f2.gif" width="16" height="15" border="0"></a></td>
								<td width="20%" align="left"><input type="button" name="buscar" value="Buscar" onClick="_Buscar(this, document.forms['buscador'],'', 'Validar();', 'FALSE')"></td>
							</tr>
							</form>
						  </table>
					   </td>
					</tr>
					
					<tr> 
                       <td width="100%" align="left"></td>
					</tr>
					<tr> 
                       <td width="100%"><%pagina.DibujarSubTitulo("Postulantes asignados")%></td>
					</tr>
					<tr> 
                       <td width="100%"><div align="left"><strong>Rut Agente :</strong><%=rut_agente%></div></td>
					</tr>
					<tr> 
                       <td width="100%"><div align="left"><strong>Nombre Agente :</strong><%=nombre_agente%></div></td>
					</tr>
					<tr> 
                       <td width="100%"><div align="left"><strong><font color="#993300">Total encontrado :<%=cantidad_encontrados%> postulante(s) sin matricular</font></strong></div></td>
					</tr>
                    <tr> 
                       <td width="100%"><div align="left"><strong>Periodo :</strong><%=peri_tdesc%></div></td>
					</tr>
					<%if total_completo > 0 then %>
					<tr> 
                       <td width="100%" align="left"></td>
					</tr>
					<tr> 
                       <td width="100%" align="center">
					   		<table width="95%" cellpadding="1" cellspacing="2" border="1">
								<tr>
									<td width="<%=porc_sin_gestion_r%>%" bgcolor="#CC3300" align="center"><%=porc_sin_gestion_r%>%<br>Sin Gestión<br><font size="3" color="#0033CC"><%=total_sin_gestion%><br>PERS</font></td>
									<td width="<%=porc_gestion_r%>%" bgcolor="#FFFF99" align="center"><%=porc_gestion_r%>%<br>Gestiondos<br><font size="3"  color="#0033CC"><%=total_gestionado%><br>PERS</font></td>
									<td width="<%=porc_matricu_r%>%" bgcolor="#66FF99" align="center"><%=porc_matricu_r%>%<br>Matriculados<br><font size="3"  color="#0033CC"><%=total_matriculado%><br>PERS</font></td>
								</tr>
								<tr>
								   <td colspan="3"align="center">
										<div align="center">  
											<%botonera.agregabotonparam "excel_test_pendiente", "url", "test_pendientes_agente_excel.asp"
											  botonera.dibujaboton "excel_test_pendiente"%>
									   </div>
								   </td>
								</tr>
							</table>
					   </td>
					</tr>
					<tr> 
                       <td width="100%" align="left"></td>
					</tr>
					<tr> 
                       <td width="100%" align="left"></td>
					</tr>
					<%end if%>
					<tr> 
                       <td width="100%">
                        <div align="right">P&aacute;ginas: &nbsp; 
                          <%formulario.AccesoPagina%>
                        </div></td>
					</tr>
					<tr> 
                       <td width="100%" align="center"><form name="edicion"> 
														<div align="center">
														  <% formulario.DibujaTabla %>
														</div>
													  </form>
													  <br>
				        </td>
					</tr>
					<%if consulta_llamados <> "" then%>
					<tr> 
                       <td width="100%" align="left"></td>
					</tr>
					<tr> 
                       <td width="100%" align="left"></td>
					</tr>
					<tr> 
                       <td width="100%"><%pagina.DibujarSubTitulo("Llamados agendados para realizar hoy")%></td>
					</tr>
					<tr> 
                       <td width="100%" align="left"></td>
					</tr>
					<tr> 
                       <td width="100%">
                        <div align="right">P&aacute;ginas: &nbsp; 
                          <%formulario_llamados.AccesoPagina%>
                        </div></td>
					</tr>
					<tr> 
                       <td width="100%" align="center"><form name="edicion2"> 
														<div align="center">
														  <% formulario_llamados.DibujaTabla %>
														</div>
													  </form>
													  <br>
				        </td>
					</tr>
					<%end if%>
                  </table> 
                  </td>
                  <td width="7" align="right" background="../imagenes/der.gif">&nbsp;</td>
                </tr>
            </table>
              <table width="100%" border="0" cellspacing="0" cellpadding="0">
                <tr>
                  <td width="9" rowspan="2"><img src="../imagenes/abajo_r1_c1.gif" width="9" height="28"></td>
                  <td width="101" nowrap bgcolor="#D8D8DE"><table width="100%" border="0" cellpadding="0" cellspacing="0">
                    <tr> 
                      <td width="94%">
                        <%  botonera.dibujaboton "salir"%>
                      </td>
					   <td><div align="center">  
				            <%botonera.agregabotonparam "excel", "url", "listado_postulaciones_agente_excel.asp"
					          botonera.dibujaboton "excel"%>
				             </div>
					   </td>
				       <td><div align="center">  
				        <%botonera.agregabotonparam "excel_encuesta", "url", "listado_ev_admision_excel.asp"
					      botonera.dibujaboton "excel_encuesta"%>
				           </div>
					   </td>
                    </tr>
                  </table></td>
                  <td width="309" rowspan="2" background="../imagenes/abajo_r1_c4.gif"><img src="../imagenes/abajo_r1_c3.gif" width="12" height="28"></td>
                  <td width="267" rowspan="2" align="right" background="../imagenes/abajo_r1_c4.gif"><img src="../imagenes/abajo_r1_c5.gif" width="7" height="28"></td>
                </tr>
                <tr>
                  <td valign="bottom" bgcolor="#D8D8DE"><img src="../imagenes/abajo_r2_c2.gif" width="100%" height="8"></td>
                </tr>
            </table>
			<BR>
		  </td>
        </tr>
      </table>	
   </td>
  </tr>  
</table>
</body>
</html>
