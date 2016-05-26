<!-- #include file = "../biblioteca/_conexion.asp" -->
<% 
'------------------------------------------------------
pers_ncorr = Request.QueryString("pers_ncorr")
tipo = Request.QueryString("tipo")

set conexion = new CConexion
conexion.Inicializar "upacifico"


susu_tlogin = conexion.consultaUno("Select susu_tlogin from sis_usuarios where cast(pers_ncorr as varchar)='"&pers_ncorr&"'")
susu_tclave = conexion.consultaUno("Select susu_tclave from sis_usuarios where cast(pers_ncorr as varchar)='"&pers_ncorr&"'")
email_upa = conexion.consultaUno("Select lower(email_nuevo) from cuentas_email_upa where cast(pers_ncorr as varchar)='"&pers_ncorr&"'")

UADI_NCORR = conexion.consultaUno("execute obtenerSecuencia 'USO_ACCESOS_DIRECTOS'")											
IF tipo = "1" then
 c_insert = " insert into USO_ACCESOS_DIRECTOS (UADI_NCORR,PERS_NCORR,TIPO,SISTEMA,FECHA) "&_
            " values ("&UADI_NCORR&","&pers_ncorr&",'ALUMNO','MOODLE',getDate())"
else
 c_insert = " insert into USO_ACCESOS_DIRECTOS (UADI_NCORR,PERS_NCORR,TIPO,SISTEMA,FECHA) "&_
            " values ("&UADI_NCORR&","&pers_ncorr&",'ALUMNO','EMAIL',getDate())"
end if
conexion.ejecutaS c_insert

%>

<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<html>
<head>
<title>Redirecciona</title>
<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1">
<link href="../estilos/estilos_alumnos.css" rel="stylesheet" type="text/css">
<link href="../estilos/tabla.css" rel="stylesheet" type="text/css">

<script language="JavaScript" src="../biblioteca/tabla.js"></script>
<script language="JavaScript" src="../biblioteca/funciones.js"></script>
<script language="JavaScript" src="../biblioteca/validadores.js"></script>

<script language="JavaScript">
function cargar (tipo)
{
	if (tipo==1)
	{
		document.login.submit();
	}
	else
	{
		document.formu_email.submit();
	}
}
</script>
<style type="text/css">
#menu div.barraMenu,
#menu div.barraMenu a.botonMenu {
font-family: sans-serif, Verdana, Arial;
font-size: 8pt;
color: white;
}

#menu div.barraMenu {
text-align: left;
}

#menu div.barraMenu a.botonMenu {
background-color: #4b73a6;
border-bottom-style:double;
border-color:#FFFFFF;
color: white;
cursor: pointer;
padding: 4px 6px 2px 5px;
text-decoration: none;
}

#menu div.barraMenu a.botonMenu:hover {
background-color: #FFFFFF;
color:#4b73a6;
}

#menu div.barraMenu a.botonMenu:active {
background-color: #637D4D;
color: black;
}
</style>

</head>

<body leftmargin="0" topmargin="0" marginwidth="0" marginheight="0" bgcolor="#CC6600" background="imagenes/fondo.jpg" onLoad="javascript:cargar(<%=tipo%>);">
<center>
<table align="center" width="700">
	<tr>
		<td width="100%">
           <!--<form action="http://fangorn.upacifico.cl/sigaupa/PRUEBA/mantenimiento.html" method="post" name="login" target="_top">-->
           <form action="http://www.pacificovirtual.cl/aula/login/index.php" method="post" name="login" target="_top">
               <input name="username" type="hidden" class="upacifico" id="username" value="<%=susu_tlogin%>" size="15" />
               <input name="password" type="hidden" class="upacifico" id="password" value="<%=susu_tclave%>" size="15" />
           </form>
           <form action="http://alumnos.upacifico.cl" method="POST" target="_top" name="formu_email">
               <input type="hidden" name="user" value="<%=email_upa%>" />
               <input type="hidden" name="pass" value="<%=susu_tclave%>" />
               <input type="hidden" name="js_autodetect_results" value="0" />
               <input type="hidden" name="just_logged_in" value="1" />
			   <input type="hidden" name="goto_uri" value="/horde/login.php" />
			   <input type="hidden" name="login_theme" value="cpanel" />
          </form>       
        </td>
	</tr>
	
</table>
</center>
</body>
</html>

