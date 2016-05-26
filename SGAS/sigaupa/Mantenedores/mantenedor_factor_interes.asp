<!-- #include file = "../biblioteca/_conexion.asp" -->
<!-- #include file = "../biblioteca/_negocio.asp" -->

<%
set pagina = new CPagina
pagina.Titulo = "Mantiene Factor Interes"
'-----------------------------------------------------------------------

set conexion = new CConexion
conexion.Inicializar "upacifico"

set negocio = new CNegocio
negocio.Inicializa conexion


set errores = new CErrores
'-----------------------------------------------------------------------
set botonera = new CFormulario
botonera.Carga_Parametros "mantener_factor_interes.xml", "botonera"
'-----------------------------------------------------------------------

v_nuevo_rango = request.querystring("nuevo_rango")


'================================================================================= 
if v_nuevo_rango="S" then

	consulta	=	" Select '' "
	
	v_factor_uno	=	conexion.consultaUno(consulta)
	v_factor_dos	=	conexion.consultaUno(consulta)
	v_factor_tres	=	conexion.consultaUno(consulta)
	v_factor_cuatro	=	conexion.consultaUno(consulta)
	v_factor_cinco	=	conexion.consultaUno(consulta)

else

	consulta_1	=	" Select fint_nfactor_anual from factor_interes where rafi_ccod=1 and efin_ccod=1 "
	consulta_2	=	" Select fint_nfactor_anual from factor_interes where rafi_ccod=2 and efin_ccod=1 "
	consulta_3	=	" Select fint_nfactor_anual from factor_interes where rafi_ccod=3 and efin_ccod=1 "
	consulta_4	=	" Select fint_nfactor_anual from factor_interes where rafi_ccod=4 and efin_ccod=1 "
	consulta_5	=	" Select fint_nfactor_anual from factor_interes where rafi_ccod=5 and efin_ccod=1 "

	consulta_fecha	=	" Select protic.trunc(audi_fmodificacion) from factor_interes where rafi_ccod=5 and efin_ccod=1 "
	
	v_factor_uno	=	conexion.consultaUno(consulta_1)
	v_factor_dos	=	conexion.consultaUno(consulta_2)
	v_factor_tres	=	conexion.consultaUno(consulta_3)
	v_factor_cuatro	=	conexion.consultaUno(consulta_4)
	v_factor_cinco	=	conexion.consultaUno(consulta_5)
	v_fecha_ingreso	=	conexion.consultaUno(consulta_fecha)

end if
'=================================================================================
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

function Guardar_Rangos(form){
	if (preValidaFormulario(form)){
		for (i=1; i < 6 ; i++ ){
			variable=eval("form.factor_interes_"+i);
			if (variable.value==""){
				alert("debe completar los campos vacios");
				variable.focus();
				return false;
			}else{
				if (isNumber(variable.value)){	
					return true;
				}else{
					alert("ingreso un numero");
				}
			}
		}
	}	
	return false;
} 

</script>


</head>
<body bgcolor="#CC6600" leftmargin="0" topmargin="0" marginwidth="0" marginheight="0" onLoad="MM_preloadImages('../imagenes/botones/buscar_f2.gif','../images/bot_deshabilitar_f2.gif','../images/agregar2_f2_p.gif','im&amp;#225;genes/marco1_r3_c2_f2.gif');MM_preloadImages('im&amp;#225;genes/marco1_r3_c4_f2.gif');MM_preloadImages('im&amp;#225;genes/marco1_r3_c6_f2.gif');MM_preloadImages('im&amp;#225;genes/marco1_r3_c8_f2.gif');MM_preloadImages('../imagenes/botones/cargar_f2.gif','../imagenes/botones/continuar_f2.gif')" onBlur="revisaVentana();">
<table width="750" border="0" align="center" cellpadding="0" cellspacing="0">
  <tr>
    <td valign="top"><img src="../imagenes/vineta2_r1_c1.gif" width="750" height="62" border="0"></td>
  </tr>
  <%pagina.DibujarEncabezado()%>  
  <tr>
    <td valign="top" bgcolor="#EAEAEA">
	<table width="90%" border="0" align="center" cellpadding="0" cellspacing="0">
        <tr>
          <td><table border="0" cellpadding="0" cellspacing="0" width="100%">
              <tr>
                <td><img src="../imagenes/spacer.gif" width="9" height="1" border="0" alt=""></td>
                <td><img src="../imagenes/spacer.gif" width="100%" height="1" border="0" alt=""></td>
                <td><img src="../imagenes/spacer.gif" width="7" height="1" border="0" alt=""></td>
              </tr>
              <tr>
                <td width="9"><img name="top_r1_c1" src="../imagenes/top_r1_c1.gif" width="9" height="8" border="0" alt=""></td>
              <td height="8"><img name="top_r1_c2" src="../imagenes/top_r1_c2.gif" width="100%" height="8" border="0" alt=""></td>
              <td width="7"><img name="top_r1_c3" src="../imagenes/top_r1_c3.gif" width="7" height="8" border="0" alt=""></td>
              </tr>			  
              <tr>
                <td><img name="top_r2_c1" src="../imagenes/top_r2_c1.gif" width="9" height="17" border="0" alt=""></td>
                <td bgcolor="#D8D8DE">
				<%pagina.DibujarLenguetas Array("Resultados de la búsqueda"), 1 %>				
				</td>
                <td><img name="top_r2_c3" src="../imagenes/top_r2_c3.gif" width="7" height="17" border="0" alt=""></td>
              </tr>
              <tr>
                <td><img name="top_r3_c1" src="../imagenes/top_r3_c1.gif" width="9" height="2" border="0" alt=""></td>
                <td><img name="top_r3_c2" src="../imagenes/top_r3_c2.gif" width="100%" height="2" border="0" alt=""></td>
                <td><img name="top_r3_c3" src="../imagenes/top_r3_c3.gif" width="7" height="2" border="0" alt=""></td>
              </tr>			 
            </table>
              <table width="100%" border="0" cellspacing="0" cellpadding="0">
                <tr>
                  <td width="9" align="left" background="../imagenes/izq.gif">&nbsp;</td>
                  <td bgcolor="#D8D8DE">&nbsp;<div align="center"><%pagina.DibujarTituloPagina%></div>
				    <%pagina.DibujarSubtitulo "Factor Interes"%>
				    <br>
				  <form name="edicion">
					<table class=v1 width='100%' border='1' cellpadding='0' cellspacing='0' bordercolor='#999999' bgcolor='#ADADAD'>
						<tr bgcolor='#99CC99' bordercolor='#999999'>
							<td width="45%">Fecha actualizacion : <%=v_fecha_ingreso%></td>
							<td width="12%"></td>
							<td width="43%"><b>Interés Máximo Convencional (Anual) </b></td>
						</tr>	
						<tr bgcolor='#C4D7FF' bordercolor='#999999'><th colspan="3">Operaciones no reajustables en moneda nacional de menos de 90 días</th></tr>
						<tr>
							<td width="45%">Inferiores o iguales al equivalente de 5.000 unidades de fomento</td>
							<td></td>
							<td width="43%" align="left"><input type="text" name="factor_interes_1" value="<%=replace(v_factor_uno,",",".")%>" size="5" maxlength="5">
							% (Ej:45.23)</td>
						</tr>
						<tr>
							<td>Superiores al equivalente de 5.000 unidades de fomento</td>
							<td></td>
							<td align="left"><input type="text" name="factor_interes_2" value="<%=replace(v_factor_dos,",",".")%>" size="5" maxlength="5">
							%</td>
						</tr>
						<tr bgcolor='#C4D7FF' bordercolor='#999999'><th colspan="3">Operaciones no reajustables en moneda nacional 90 días o más</th></tr>
						<tr>
							<td>Inferiores o iguales al equivalente de 200 unidades de fomento</td>
							<td></td>
							<td align="left"><input type="text" name="factor_interes_3" value="<%=replace(v_factor_tres,",",".")%>" size="5" maxlength="5">
							%</td>
						</tr>
						<tr>
							<td>Inferiores o iguales al equivalente de 5.000 unidades de fomento y superiores al equivalente de 200</td>
							<td></td>
							<td align="left"><input type="text" name="factor_interes_4" value="<%=replace(v_factor_cuatro,",",".")%>" size="5" maxlength="5">
							%</td>
						</tr>
						<tr>
							<td>Superiores al equivalente de 5.000 unidades de fomento</td>
							<td></td>
							<td align="left"><input type="text" name="factor_interes_5" value="<%=replace(v_factor_cinco,",",".")%>" size="5" maxlength="5">
							%</td>
						</tr>
					</table>
                  </form>
				  <br>				 </td>
                  <td width="7" align="right" background="../imagenes/der.gif">&nbsp;</td>
                </tr>
            </table>
              <table width="100%" border="0" cellspacing="0" cellpadding="0">
                <tr>
                  <td width="9" rowspan="2"><img src="../imagenes/abajo_r1_c1.gif" width="9" height="28"></td>
                  <td width="198" bgcolor="#D8D8DE"><table width="90%"  border="0" align="center" cellpadding="0" cellspacing="0">
                    <tr>
                      <td width="20%">&nbsp;
                      </td>
                      <td width="20%"> <div align="left">
                        <% 	if v_nuevo_rango="S" then
								botonera.agregabotonparam "guardar", "url", "proc_guardar_factor_interes.asp?nuevo_rango=S"
							end if
							botonera.DibujaBoton ("guardar")%> 
                        </div></td>
                      <td width="31%"> <div align="left"> <%
					  botonera.agregabotonparam "nuevo_rango", "url", "mantenedor_factor_interes.asp?nuevo_rango=S" 
					  botonera.DibujaBoton ("nuevo_rango")%></div></td>
                      <td width="49%"> <div align="left"> 
                          <%botonera.DibujaBoton ("salir")%>
                        </div></td>
                    </tr>
                  </table>                    
                  </td>
                  <td width="157" rowspan="2" background="../imagenes/abajo_r1_c4.gif"><img src="../imagenes/abajo_r1_c3.gif" width="12" height="28"></td>
                  <td width="311" rowspan="2" align="right" background="../imagenes/abajo_r1_c4.gif"><img src="../imagenes/abajo_r1_c5.gif" width="7" height="28"></td>
                </tr>
                <tr>
                  <td valign="bottom" bgcolor="#D8D8DE"><img src="../imagenes/abajo_r2_c2.gif" width="100%" height="8"></td>
                </tr>
            </table>			
		  </td>
        </tr>
      </table>	
   <p>&nbsp;</p></td>
  </tr>  
</table>
</body>
</html>
