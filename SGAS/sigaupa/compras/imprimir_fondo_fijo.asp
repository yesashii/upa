<!-- #include file = "../biblioteca/_conexion.asp" -->
<!-- #include file = "../biblioteca/_negocio.asp" -->
<!-- #include file = "../biblioteca/_conexion_softland.asp" -->

<%
set pagina = new CPagina
pagina.Titulo = "Fondo Fijo"

v_ffij_ncorr	= request.querystring("ffij_ncorr")

set botonera = new CFormulario
botonera.carga_parametros "fondo_fijo.xml", "botonera"


set conectar = new cconexion
conectar.inicializar "upacifico"

set negocio = new cnegocio
negocio.Inicializa conectar


set conexion = new Cconexion2
conexion.Inicializar "upacifico"

v_usuario=negocio.ObtenerUsuario()


	if  v_ffij_ncorr<>"" then
	
		sql_fondo	= "select protic.trunc(ffij_fpago) as ffij_fpago,* from ocag_fondo_fijo a, personas c "&_
						 "	where a.pers_ncorr=c.pers_ncorr and a.ffij_ncorr="&v_ffij_ncorr
	else
		if v_rut<>"" then
			sql_fondo	= "select pers_nrut,pers_xdv, protic.obtener_nombre_completo(pers_ncorr,'n') as pers_tnombre "&_
									" from personas where pers_nrut="&v_rut 
		else
			sql_fondo	=	"select ''"
		end if
	end if

set f_busqueda = new CFormulario
f_busqueda.Carga_Parametros "fondo_fijo.xml", "imprimir_datos_solicitud"
f_busqueda.Inicializar conectar
f_busqueda.Consultar sql_fondo
f_busqueda.Siguiente


set f_area = new CFormulario
f_area.Carga_Parametros "fondo_fijo.xml", "imprimir_buscador_area"
f_area.Inicializar conexion
 
sql_area= "select a.area_ccod, area_tdesc as descripcion "&_
			" from presupuesto_upa.protic.area_presupuesto_usuario a, presupuesto_upa.protic.area_presupuestal b "&_
			" where rut_usuario="&v_usuario&" "&_
			" and a.area_ccod=b.area_ccod "
			
f_area.Consultar sql_area
f_area.AgregaCampoCons "area_ccod",  f_busqueda.obtenerValor("area_ccod")
f_area.SiguienteF


set f_cod_pre = new CFormulario
f_cod_pre.carga_parametros "fondo_fijo.xml", "imprimir_codigo_presupuesto"
f_cod_pre.inicializar conexion
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
              <table width="100%" border="0" cellspacing="0" cellpadding="0">
                <tr>
                  <td width="9" align="left" background="../imagenes/izq.gif">&nbsp;</td>
                  <td bgcolor="#D8D8DE">
				  <br>
                   <center><h2>Solicitud de Fondo a Fijo</h2></center>
                    <table width="100%" align="center" cellpadding="0" cellspacing="0">
                  <tr> 
                    <td>
					<form name="datos" method="post">
					<table width="100%" border="1">
                      <tr> 
                        <td width="11%">Rut Funcionario  </td>
                        <td width="27%"> <%f_busqueda.dibujaCampo("pers_nrut")%>
                          -<%f_busqueda.dibujaCampo("pers_xdv")%></td>
                        <td width="14%">Mes </td>
                        <td colspan="3"><%f_busqueda.dibujaCampo("mes_ccod")%></td>
                      </tr>
                      <tr> 
                        <td> Nombre Funcionario </td>
                        <td> <%f_busqueda.dibujaCampo("pers_tnombre")%> </td>
                        <td> Area que presupuesta   </td>
                        <td width="48%"><%f_area.dibujaCampo("area_ccod")%></td>
                      </tr>
					 <tr> 
                        <td>Fecha. Pago </td>
                        <td><%f_busqueda.dibujaCampo("ffij_fpago")%></td>
                        <td>Codigo presupuesto</td>
                        <td><%f_cod_pre.dibujaCampo("cod_pre")%></td>
					 </tr>
                      <tr> 
                        <td>Monto a girar Pesos</td>
                        <td><%f_busqueda.dibujaCampo("ffij_mmonto_pesos")%></td>
                        <td>Detalle presupuesto</td>
                        <td><%f_busqueda.dibujaCampo("ffij_tdetalle_presu")%></td>
                      </tr>
					  <tr>
					  <td colspan="4"><hr></td>
					  </tr>	
					  <tr valign="top">
								<td colspan="4">
								<br/>
								<br/>
								Yo: <b><%=f_busqueda.obtenerValor("pers_tnombre")%></b> 
								Rut:<b><%=f_busqueda.obtenerValor("pers_nrut")%></b>-<b><%=f_busqueda.obtenerValor("pers_xdv")%></b>
								<br>
								<p>Autorizo que, en caso de no devolver el Fondo asignado al segundo dia habil desde cuando se solicita su devolución, la Universidad del Pacifico descuente el monto autorizado de mi remuneracion mensual o de mi indemnizacion por a&ntilde;os de servicios a que tenga derecha, deshaucio y/u otros emolumentos legales.</p>
								<p>la solicitud de devolucion sera efectuada por el departamento de contabilidad de la Universidad del Pacifico via Correo electrónico o Pase Interno.  <br>
							      <br>
								  </p>
								<center><p>____________________</p></center>
								<center><p>Firma Trabajador</p></center>								
								</td>
					</tr>				  
                    </table>
					</form>	
                      </td>
                  </tr>
                </table>
				  <br>				  
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
