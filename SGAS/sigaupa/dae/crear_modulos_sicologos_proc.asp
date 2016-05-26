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
f_agrega.Carga_Parametros "edicion_talleres.xml", "cheques"
f_agrega.Inicializar conectar




peri_ccod =request.Form("a[0][peri_ccod]")' f_agrega.ObtenerValorPost (filai, "peri_ccod")
sede_ccod =request.Form("a[0][sede_ccod]") 'f_agrega.ObtenerValorPost (filai, "sede_ccod")
hora_incio =request.Form("a[0][hora_ini]") 'f_agrega.ObtenerValorPost (filai, "hora_ini")
hora_termino =request.Form("a[0][hora_fin]") 'f_agrega.ObtenerValorPost (filai, "hora_fin")
intervalo=request.Form("a[0][intervalo]") 'f_agrega.ObtenerValorPost (filai, "intervalo")


 usu=negocio.obtenerUsuario

	s_sede_sicologo="select a.side_ncorr "& vbcrlf & _
	"from sicologos_sede a, sicologos b"& vbcrlf & _
	"where a.sico_ncorr=b.sico_ncorr"& vbcrlf & _
	"and pers_ncorr=protic.obtener_pers_ncorr("&usu&")"& vbcrlf & _
	"and sede_ccod="&sede_ccod&""
side_ncorr=conectar.consultaUno(s_sede_sicologo)

	s_existe_bloque_sede="select case count(*) when 0 then 'N' else 'S' end "& vbcrlf & _
						"from bloques_sicologos a ,"& vbcrlf & _
						"sicologos_sede b,"& vbcrlf & _
						"sicologos c "& vbcrlf & _
						"where b.side_ncorr=a.side_ncorr and b.side_ncorr="&side_ncorr&" and c.pers_ncorr=protic.obtener_pers_ncorr("&usu&") and a.peri_ccod="&peri_ccod&""
						
	existe_bloque_sede=conectar.consultaUno(s_existe_bloque_sede)
	response.Write("<pre>"&s_existe_bloque_sede&"</pre>")
response.Write("<pre>"&existe_bloque_sede&"</pre>")

if existe_bloque_sede="N"then

	sql_genera="exec CREA_BLOQUES_SICOLOGOS "&side_ncorr&","&peri_ccod&",'"&hora_incio&"','"&hora_termino&"',"&intervalo&""	
		
		  conectar.EjecutaP(sql_genera)
		  
		response.Redirect("bloques_sicologos_anula.asp?side_ncorr="&side_ncorr&"&peri_ccod="&peri_ccod&"")

		

else 
		session("mensajeerror")= "Para este semestre y sede ya tienes bloques creados"
		response.Redirect("crear_modulos_sicologos.asp")
end if
%>


