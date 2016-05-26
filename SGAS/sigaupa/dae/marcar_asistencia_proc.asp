<!-- #include file = "../biblioteca/_conexion.asp" -->
<!-- #include file = "../biblioteca/_negocio.asp" -->


<%
'-----------------------------------------------------
	for each k in request.form
	response.Write(k&" = "&request.Form(k)&"<br>")
	next


set conectar = new cconexion
conectar.inicializar "upacifico"

set negocio = new CNegocio
negocio.Inicializa conectar

set f_agrega = new CFormulario
f_agrega.Carga_Parametros "modifica_hora.xml", "hora"
f_agrega.Inicializar conectar




hoto_ncorr =request.Form("hoto_ncorr")' f_agrega.ObtenerValorPost (filai, "peri_ccod")
peri_ccod =request.Form("peri_ccod")
sede_ccod =request.Form("sede_ccod")
fecha =request.Form("fecha")
indice =request.Form("indice")

 usu=negocio.obtenerUsuario
 
 blsi_ncorr=conectar.ConsultaUno("select  blsi_ncorr from  horas_tomadas where hoto_ncorr="&hoto_ncorr&"")
 
 s_comenzo_hora="select case when convert(datetime,hoto_fecha+' '+hora_ini,103)< getdate() then 'S' else 'N' end  from "& vbCrLf &_
 				"horas_tomadas a,"& vbCrLf &_
				"bloques_sicologos b"& vbCrLf &_
				"where a.blsi_ncorr=b.blsi_ncorr"& vbCrLf &_
				"and a.blsi_ncorr="&blsi_ncorr&""& vbCrLf &_
				"and hoto_ncorr="&hoto_ncorr&""
 
 comenzo_hora=conectar.ConsultaUno(s_comenzo_hora)
 

if comenzo_hora="S" then

	sql_genera="update horas_tomadas set esho_ccod=2 , audi_tusuario="&usu&", audi_fmodificacion=getdate() where hoto_ncorr="&hoto_ncorr&""	
		
		  conectar.EjecutaS(sql_genera)
		session("mensajeerror")= "La asistencia fue registrada Correctamente"  
		response.Redirect("muestra_horas.asp?sede_ccod="&sede_ccod&"&peri_ccod="&peri_ccod&"&fecha_consulta="&fecha&"&indice="&indice&"")

else
		session("mensajeerror")= "No pueda marca la asistencia ya que esta hora aún no comienza"  
		response.Redirect("muestra_horas.asp?sede_ccod="&sede_ccod&"&peri_ccod="&peri_ccod&"&fecha_consulta="&fecha&"&indice="&indice&"")

end if		

%>


