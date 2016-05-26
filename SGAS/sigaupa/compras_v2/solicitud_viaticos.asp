<!-- #include file = "../biblioteca/_conexion.asp" -->
<!-- #include file = "../biblioteca/_negocio.asp" -->
<!-- #include file = "../biblioteca/_conexion_softland.asp" -->

<%
set pagina = new CPagina
pagina.Titulo = "Solicitud de Viatico"

v_sovi_ncorr	= request.querystring("busqueda[0][sovi_ncorr]")


set botonera = new CFormulario
botonera.carga_parametros "solicitud_viaticos.xml", "botonera"


set conectar = new cconexion
conectar.inicializar "upacifico"

set negocio = new cnegocio
negocio.Inicializa conectar

set conexion = new Cconexion2
conexion.Inicializar "upacifico"



v_usuario=negocio.ObtenerUsuario()

 set f_busqueda = new CFormulario
 f_busqueda.Carga_Parametros "solicitud_viaticos.xml", "datos_funcionario"
 f_busqueda.Inicializar conectar


if  v_sovi_ncorr<>"" then
	sql_viatico	=	"select protic.trunc(sovi_fpago) as sovi_fpago,protic.trunc(sovi_fllegada) as sovi_fllegada,protic.trunc(sovi_fsalida) as sovi_fsalida, "&_
					" a.*,  b.pers_nrut, pers_xdv, protic.obtener_nombre_completo(a.pers_ncorr,'n') as pers_tnombre "&_
					" from ocag_solicitud_viatico a, personas b "&_
					" where a.pers_ncorr=b.pers_ncorr and sovi_ncorr="&v_sovi_ncorr
else
	sql_viatico="select ''"
end if 
f_busqueda.Consultar sql_viatico
 

sql_codigo_pre= " (select a.cod_pre, a.cod_tdesc +' ('+a.cod_pre+')' as valor from ocag_codigos_presupuesto a ,ocag_permisos_presupuestos b "&_
				"	where a.cod_pre=b.cod_pre "&_
				"	and pers_nrut="&v_usuario&" ) as tabla"
		
f_busqueda.agregaCampoParam "cod_pre","destino", sql_codigo_pre
 
f_busqueda.Siguiente


set f_area = new CFormulario
f_area.Carga_Parametros "solicitud_viaticos.xml", "buscador_area"
f_area.Inicializar conexion
 
sql_area= "select a.area_ccod, area_tdesc as descripcion "&_
			" from presupuesto_upa.protic.area_presupuesto_usuario a, presupuesto_upa.protic.area_presupuestal b "&_
			" where rut_usuario="&v_usuario&" "&_
			" and a.area_ccod=b.area_ccod "
			
f_area.Consultar sql_area
f_area.AgregaCampoCons "area_ccod",  f_busqueda.obtenerValor("area_ccod")
f_area.SiguienteF

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

function Eshora(v_hora)
{
v_name=v_hora.name;
var a_hora 	= v_hora.value.split(':');
var hora 	= a_hora[0];
var minuto 	= a_hora[1];


	if(v_hora.value){
		if((!hora)||(!minuto)){
			alert('La hora no ingresada es válida, ingrese con un formato (hh:mm)'); 
			document.datos.elements[v_name].value="";
			return false;
		}else{
			if ((hora<0)||(hora>23)||(minuto<0)|(minuto>59)){
				alert('La hora no ingresada es válida, ingrese con un formato (hh:mm)'); 
				document.datos.elements[v_name].value="";
				return false;
			}
		}
	}
	return true;
}

function Enviar(){
	return true;
}

</script>
</head>
<body bgcolor="#CC6600" leftmargin="0" topmargin="0" marginwidth="0" marginheight="0" onLoad="MM_preloadImages('../imagenes/botones/buscar_f2.gif','../images/bot_deshabilitar_f2.gif','../images/agregar2_f2_p.gif','im&amp;#225;genes/marco1_r3_c2_f2.gif');MM_preloadImages('im&amp;#225;genes/marco1_r3_c4_f2.gif');MM_preloadImages('im&amp;#225;genes/marco1_r3_c6_f2.gif');MM_preloadImages('im&amp;#225;genes/marco1_r3_c8_f2.gif');MM_preloadImages('../imagenes/botones/cargar_f2.gif','../imagenes/botones/continuar_f2.gif')" onBlur="revisaVentana();">
<table width="750" border="0" align="center" cellpadding="0" cellspacing="0">
  <tr>
    <td><img src="../imagenes/vineta2_r1_c1.gif" width="750" height="62" border="0"></td>
  </tr>
  <%pagina.DibujarEncabezado()%>  
  <tr>
    <td valign="top" bgcolor="#EAEAEA">
	<br>
	<table width="90%" border="0" align="center" cellpadding="0" cellspacing="0">
		<tr>
          <td>
		  <table border="0" cellpadding="0" cellspacing="0" width="100%">
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
                      <div align="left"><font color="#FFFFFF" size="1" face="Verdana, Arial, Helvetica, sans-serif">Solicitud de viaticos</font></div></td>
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
              <table width="100%" border="0" cellspacing="0" cellpadding="0">
                <tr>
                  <td width="9" align="left" background="../imagenes/izq.gif">&nbsp;</td>
                  <td bgcolor="#D8D8DE">
				  <br>
                    <div align="center"><font size="+1">
                      <%pagina.DibujarTituloPagina()%> 
                      </font>                    </div>
                    <table width="100%" align="center" cellpadding="0" cellspacing="0">
                  <tr> 
                    <td><strong><font color="000000" size="1"> </font></strong>
				<form name="datos">
				<%f_busqueda.dibujaCampo("sovi_ncorr")%>	
					<table width="100%" border="1">
                      <tr> 
                        <td width="11%">Rut funcionario </td>
                        <td width="27%"> <%f_busqueda.dibujaCampo("pers_nrut")%>
                          -<%f_busqueda.dibujaCampo("pers_xdv")%></td>
                        <td width="14%">Mes </td>
                        <td colspan="3"><%f_busqueda.dibujaCampo("mes_ccod")%></td>
                      </tr>
                      <tr> 
                        <td> Nombre funcionario </td>
                        <td><%f_busqueda.dibujaCampo("pers_tnombre")%></td>
                        <td> Area presupuesto  </td>
                        <td width="48%"><%f_area.dibujaCampo("area_ccod")%></td>
                      </tr>
					 <tr> 
                        <td>Fecha. Pago </td>
                        <td><%f_busqueda.dibujaCampo("sovi_fpago")%> dd/mm/aaaa</td>
                        <td>Codigo presupuesto</td>
                        <td><%f_busqueda.dibujaCampo("cod_pre")%></td>
					 </tr>
                      <tr>
                        <td>A&ntilde;o</td>
                        <td><%f_busqueda.dibujaCampo("anos_ccod")%></td> 
                        <td>detalle Presupuestado </td>
                        <td><%f_busqueda.dibujaCampo("sovi_tdetalle_presu")%></td>
                      </tr>
                      <tr> 
                        <td><em><strong>Origen </strong></em></td>
                        <td><%f_busqueda.dibujaCampo("sovi_torigen")%></td>
                        <td><em><strong>Destino </strong></em></td>
                        <td><%f_busqueda.dibujaCampo("sovi_tdestino")%></td>
                      </tr>
                      <tr> 
                        <td><em><strong>Fecha Salida </strong></em></td>
                        <td><%f_busqueda.dibujaCampo("sovi_fsalida")%></td>
                        <td><em><strong>Fecha llegada </strong></em></td>
                        <td><%f_busqueda.dibujaCampo("sovi_fllegada")%></td>
                      </tr>
                      <tr> 
                        <td><em><strong>Hora salida </strong></em></td>
                        <td><%f_busqueda.dibujaCampo("sovi_hsalida")%>
                          (hh:mm)</td>
                        <td><em><strong>Hora llegada </strong></em></td>
                        <td><%f_busqueda.dibujaCampo("sovi_hllegada")%>
                          (hh:mm)  </td>
                      </tr>					  					  
                      <tr>
                        <td>Monto día </td>
                        <td colspan="3"><%f_busqueda.dibujaCampo("sovi_mmonto_dia")%></td>
                      </tr>
                      <tr>
                        <td>Monto girar Origen </td>
                        <td colspan="3"><%f_busqueda.dibujaCampo("sovi_mmonto_origen")%></td>
                      </tr>
                      <tr>
                        <td>Monto a girar Pesos </td>
                        <td colspan="3"><%f_busqueda.dibujaCampo("sovi_mmonto_pesos")%></td>
                      </tr>
                      <tr>
                        <td>Motivo de viatico </td>
                        <td colspan="3"><%f_busqueda.dibujatextarea("sovi_tmotivo")%></td>
                      </tr>					  
                    </table>
					</form>
                      <table width="100%" border="0">
                        <tr> 
                          <td><hr/></td>
                        </tr>
						<tr>
							<td>
							<form name="visto_bueno" method="post">
							<table border ="1" align="center" width="100%">
								<tr valign="top">
								  <td> V°B° Responsable <select name="visto_bueno">
											  <option>-Seleccione Opcion-</option>
											  <option>Jefe Directo</option>
											  <option>Control Presupuesto</option>
											  <option>Direccion Finanzas</option>
											  <option>Vicerrectoria Finanzas</option>
											</select>
											<input type="submit" name="grabar" value="Grabar"/>
								  </td>
							    </tr>
							  </table>
							</form>	
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
	  <br/>
				  
				  </td>
                  <td width="7" align="right" background="../imagenes/der.gif">&nbsp;</td>
                </tr>
            </table>
              <table width="100%" border="0" cellspacing="0" cellpadding="0">
                <tr>
                  <td width="9" rowspan="2"><img src="../imagenes/abajo_r1_c1.gif" width="9" height="28"></td>
                  <td width="241" bgcolor="#D8D8DE">
				  <table width="49%" height="19"  border="0" align="center" cellpadding="0" cellspacing="0">
                    <tr>
                      <td width="30%"> <%botonera.dibujaboton "guardar"%> </td>
					  <td><%botonera.dibujaboton "salir"%></td>
                    </tr>
                  </table>                </td>
                  <td width="121" rowspan="2" background="../imagenes/abajo_r1_c4.gif"><img src="../imagenes/abajo_r1_c3.gif" width="12" height="28"></td>
                  <td width="317" rowspan="2" align="right" background="../imagenes/abajo_r1_c4.gif"><img src="../imagenes/abajo_r1_c5.gif" width="7" height="28"></td>
                </tr>
                <tr>
                  <td height="8" valign="bottom" bgcolor="#D8D8DE"><img src="../imagenes/abajo_r2_c2.gif" width="100%" height="8"></td>
                </tr>
            </table>
			<p><br>
			<p><br>
			<p><br>
		  </td>
        </tr>
      </table>	
   </td>
  </tr>  
</table>
</body>
</html>
