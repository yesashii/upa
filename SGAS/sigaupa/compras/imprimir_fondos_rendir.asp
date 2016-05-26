<!-- #include file = "../biblioteca/_conexion.asp" -->
<!-- #include file = "../biblioteca/_negocio.asp" -->
<!-- #include file = "../biblioteca/_conexion_softland.asp" -->

<%
set pagina = new CPagina
pagina.Titulo = "Fondos a Rendir"

v_fren_ncorr	= request.querystring("fren_ncorr")


set botonera = new CFormulario
botonera.carga_parametros "fondos_rendir.xml", "botonera"


set conectar = new cconexion
conectar.inicializar "upacifico"

set conexion2 = new CConexion2
conexion2.Inicializar "upacifico"

set negocio = new cnegocio
negocio.Inicializa conectar


v_usuario=negocio.ObtenerUsuario()

	if  v_fren_ncorr<>"" then
	
		sql_fondo_rendir	= " select protic.trunc(fren_fpago) as fren_fpago,protic.trunc(fren_factividad) as fren_factividad,* "&_
						  " from ocag_fondos_a_rendir a, personas c "&_
						  "	where a.pers_ncorr=c.pers_ncorr and a.fren_ncorr="&v_fren_ncorr
	else
		if v_rut<>"" then
			sql_fondo_rendir	= "select pers_nrut,pers_xdv, protic.obtener_nombre_completo(pers_ncorr,'n') as pers_tnombre "&_
									" from personas where pers_nrut="&v_rut 
		else
			sql_fondo_rendir	=	"select ''"
		end if

	end if


 set f_busqueda = new CFormulario
 f_busqueda.Carga_Parametros "fondos_rendir.xml", "imprimir_datos_proveedor"
 f_busqueda.Inicializar conectar
 f_busqueda.Consultar sql_fondo_rendir
 f_busqueda.Siguiente


set f_cod_pre = new CFormulario
f_cod_pre.carga_parametros "fondos_rendir.xml", "imprimir_codigo_presupuesto"
f_cod_pre.inicializar conexion2
f_cod_pre.consultar "select '' "

sql_codigo_pre="(select distinct cod_pre, 'Area('+cast(cast(cod_area as numeric) as varchar)+')-'+concepto +' ('+cod_pre+')' as valor "&_
			    " from presupuesto_upa.protic.presupuesto_upa_2010 	"&_
			    "	where cod_anio=2010 "&_
				"	and cod_area in (   select distinct area_ccod "&_ 
				"		 from  presupuesto_upa.protic.area_presupuesto_usuario  "&_
				"		 where rut_usuario in ("&v_usuario&")) "&_
				" ) as tabla "

f_cod_pre.agregaCampoParam "cod_pre","destino", sql_codigo_pre
f_cod_pre.siguiente
f_cod_pre.agregaCampoCons "cod_pre", f_busqueda.obtenerValor("cod_pre")
%>


<html>
<head>
<title><%=pagina.Titulo%></title>
<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1">

<script language="JavaScript">


</script></head>
<body bgcolor="" leftmargin="0" topmargin="0" marginwidth="0" marginheight="0" onLoad="">
<table width="700" border="0" align="center" cellpadding="0" cellspacing="0">
  <tr>
    <td valign="top" bgcolor="">
	<br>
	<table width="100%" border="0" align="center" cellpadding="0" cellspacing="0">
		<tr>
          <td>
		  <table border="0" cellpadding="0" cellspacing="0" width="100%">
            </table>
              <table width="100%" align="center" cellpadding="0" cellspacing="0">
                  <tr> 
                    <td bgcolor="#D8D8DE">
					<center><h2>Solicitud de Fondo a Rendir</h2></center>
					<table width="100%" border="1">
                      <tr> 
                        <td width="11%">Rut funcionario </td>
                        <td width="27%"> <%f_busqueda.dibujaCampo("pers_nrut")%>
                          -<%f_busqueda.dibujaCampo("pers_xdv")%></td>
                        <td width="14%">Fecha actividad</td>
                        <td colspan="3"><%f_busqueda.dibujaCampo("fren_factividad")%></td>
                      </tr>
                      <tr> 
                        <td> Nombre funcionario </td>
                        <td><%f_busqueda.dibujaCampo("pers_tnombre")%></td>
                        <td> codigo presupuesto </td>
                        <td width="48%"><%f_cod_pre.dibujaCampo("cod_pre")%></td>
                      </tr>
                      <tr> 
                        <td>Monto girar </td>
                        <td><%f_busqueda.dibujaCampo("fren_mmonto")%></td>
                        <td>Mes </td>
                        <td><%f_busqueda.dibujaCampo("mes_ccod")%></td>
                      </tr>
                      <tr> 
                        <td>Fecha. Pago </td>
                        <td><%f_busqueda.dibujaCampo("fren_fpago")%></td>
                        <td>A&ntilde;o</td>
                        <td><%f_busqueda.dibujaCampo("anos_ccod")%></td>
                      </tr>
                      <tr>
                        <td>Descripcion actividad </td>
                        <td colspan="3"><%f_busqueda.dibujaCampo("fren_tdescripcion_actividad")%></td>
                      </tr>
                    </table>
					<br><p></p>
                      <table width="100%" border="0">
                        <tr> 
                          <td><hr/></td>
                        </tr>
						<tr>
							<td>
							<table border ="1" align="center" width="100%">
								<tr valign="top">
								<td>Yo: <b><%=f_busqueda.obtenerValor("pers_tnombre")%></b>
								   Rut: <b><%=f_busqueda.obtenerValor("pers_nrut")%></b>-<b><%=f_busqueda.obtenerValor("pers_xdv")%></b>
								<br>
								<p>Autorizo que, en caso de NO rendir 30 dias despues de la fecha de la actividad (evento),<br>
								la Universidad del Pacifico descuente el monto autorizado, de mi remuneracion mensual o<br> 
								de mi indemnizacion por años de servicios que tenga derecho, desahucio y/u otros emolumentos legales.</p>
								<br>
								<br>
								<center><p>____________________</p></center>
								<center><p>Firma trabajador</p></center>								</td>
								</tr>
							  </table>
								
							</td>
						</tr>
						<tr>
						<td>
						</td>
						</tr>
                      </table>
                      </td>
                  </tr>
                </table>
		  </td>
        </tr>
      </table>	
  <center><a href="javascript:window.print()">Imprimir</a></center>
   </td>
  </tr>  
</table>
</body>
</html>
