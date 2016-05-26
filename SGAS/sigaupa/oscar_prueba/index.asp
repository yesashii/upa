<!-- #include file = "../biblioteca/_conexion.asp" -->

<%
	set conexion = new CConexion
	conexion.Inicializar "upacifico"
	
	set formulario = new CFormulario
	formulario.Carga_Parametros "tabla_vacia.xml", "tabla_vacia"
	formulario.Inicializar conexion 

	sql="SELECT su.susu_tlogin AS login FROM sis_roles sr" & vbCrLf &_
		"	INNER JOIN sis_roles_usuarios sru   " & vbCrLf &_
		"		ON sr.srol_ncorr=sru.srol_ncorr " & vbCrLf &_
		"	INNER JOIN personas p               " & vbCrLf &_
		"		ON sru.pers_ncorr=p.pers_ncorr  " & vbCrLf &_
		"	INNER JOIN sis_usuarios su          " & vbCrLf &_
		"		ON p.pers_ncorr=su.pers_ncorr   " & vbCrLf &_
		"	WHERE sr.srol_tdesc='Desarrollador'"
	formulario.Consultar sql
	i= formulario.nroFilas
	valor =""
	for i = 0 to formulario.nroFilas
		formulario.Siguiente
		valor=valor&","&formulario.ObtenerValor("login")
	next
	valor = Right(valor, Len(valor)-1)
%>
<script>
	function OK(a)
	{
		var str = "<%=valor%>";
		var res = str.split(",");
		if(contains(res, a.value))
		{
			document.getElementById("pass").style.display = '';
		}
		else
		{
			document.getElementById("pass").style.display = 'none';
		}
	}
	
	function contains(a, obj) {
		for (var i = 0; i < a.length; i++) {
			if (a[i] === obj.toUpperCase()) {
				return true;
			}
		}
		return false;
	}
	
</script>
<form>
	<input type="text" id="usuario" id="usuario" onkeypress="esusuario(this)" onkeyup="esusuario(this)">
	<input type="password" id="pass" id="pass" style="display:none">
</form>