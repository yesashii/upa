<!-- #include file = "../biblioteca/_conexion.asp" -->
<!-- #include file = "../biblioteca/_conexion_softland.asp" -->
<!-- #include file = "../biblioteca/_negocio.asp" -->

<%
cod_sol	= request.querystring("cod")
nro_t	= request.querystring("nro")

set conexion2 = new CConexion2
conexion2.Inicializar "upacifico"

if cod_sol <> "" and nro_t <>"" then


	select case (nro_t)
		case 1:
			sql_motivo="select ccau_tmotivo as motivo from presupuesto_upa.protic.centralizar_solicitud_audiovisual where ccau_ncorr="&cod_sol&" " 
		case 2:
			sql_motivo="select ccbi_tmotivo as motivo from presupuesto_upa.protic.centralizar_solicitud_biblioteca where ccbi_ncorr="&cod_sol&" "
		case 3:
			sql_motivo="select ccco_tmotivo as motivo from presupuesto_upa.protic.centralizar_solicitud_computacion where ccco_ncorr="&cod_sol&" "
		case 4:
			sql_motivo="select ccsg_tmotivo as motivo from presupuesto_upa.protic.centralizar_solicitud_servicios_generales where ccsg_ncorr="&cod_sol&" "
		case 5:
			sql_motivo="select ccpe_tmotivo as motivo from presupuesto_upa.protic.centralizar_solicitud_personal where ccpe_ncorr="&cod_sol&" "
		case 6:
			sql_motivo="select ccau_tmotivo as motivo from presupuesto_upa.protic.centralizar_solicitud_dir_docencia where ccau_ncorr="&cod_sol&" "
	end select	

'response.Write(sql_motivo)
'response.End()
 	v_motivo=conexion2.consultaUno(sql_motivo)
	
end if

set botonera =  new CFormulario
botonera.carga_parametros "solicitud_presupuestaria.xml", "botonera"

%>

<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<html>
<head>
<title>Motivo Rechazo</title>
<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1">
<link href="../estilos/estilos.css" rel="stylesheet" type="text/css">
<link href="../estilos/tabla.css" rel="stylesheet" type="text/css">

<script language="JavaScript" src="../biblioteca/tabla.js"></script>
<script language="JavaScript" src="../biblioteca/funciones.js"></script>
<script language="JavaScript" src="../biblioteca/validadores.js"></script>
<script language="JavaScript">
</script>
</head>

<body leftmargin="0" topmargin="0" onLoad="MM_preloadImages('../images/enviar2_f2.gif')">
<form name="formu" method="get" >
<input type="hidden" name="nro" value="<%=nro_solicitud%>">
<input type="hidden" name="cod" value="<%=codigo_solicitud%>">
  <table align="center" width="250" border="1" cellpadding="0" cellspacing="0" bordercolor="#A0C0EB" bgcolor="#D8D8DE">
    <tr> 
      <td width="258" align="right">
<div align="center">

          <p><strong>Motivo rechazo solicitud<br>
          </strong></p>
          <table width="100%" border="1" cellspacing="0" cellpadding="0" bordercolor="#FFFFFF">
            <tr> 
              <td><div align="center">
                  <textarea name="rechazo" cols="40" rows="5" readonly="readonly"><%=v_motivo%></textarea>
                  </div></td>
            </tr>
          </table>
          <p><strong><%botonera.dibujaboton "cerrar2"%></strong></p>
          <p>&nbsp;</p>
</div></td>
    </tr>
  </table>
</form>
</body>
</html>

