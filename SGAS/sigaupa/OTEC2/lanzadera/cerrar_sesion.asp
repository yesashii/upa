<!-- #include file = "../biblioteca/_conexion.asp" -->
<%
set conexion = new CConexion
conexion.Inicializar "upacifico"
usuario = session("rut_usuario")
	if usuario<>"" then
		sql_pers_ncorr = "SELECT pers_ncorr FROM personas WHERE pers_nrut=" & usuario
		v_pers_ncorr =  conexion.ConsultaUno(sql_pers_ncorr)
	
		sql_existe_tabla = "SELECT top 1 count(pers_ncorr) FROM login_usuarios WHERE pers_ncorr="&v_pers_ncorr&" and elog_ccod=1"
		v_existe_login =  conexion.ConsultaUno(sql_existe_tabla)
		if v_existe_login >0 then
			sql_atualiza="update login_usuarios set elog_ccod=3 where pers_ncorr="&v_pers_ncorr&" and elog_ccod=1"
			conexion.ejecutaS(sql_atualiza)
		end if
	end if
Session.Abandon()
Response.Redirect("../portada/portada.asp")
%>