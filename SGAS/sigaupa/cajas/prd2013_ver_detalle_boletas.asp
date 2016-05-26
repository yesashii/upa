<%
q_origen = Request.QueryString("origen")
if(q_origen="1") then
	q_rut = Request.QueryString("rut")
	q_peri = Request.QueryString("peri")
	q_sede = Request.QueryString("sede")
	session("sede")=q_sede
	session("_periodo")=q_peri
	session("rut_usuario")=q_rut
end if
%>
<!-- #include file = "../biblioteca/_conexion.asp" -->
<!-- #include file = "../biblioteca/_negocio.asp" -->

<%
q_bole_ncorr = Request.QueryString("bole_ncorr")
q_pers_ncorr = Request.QueryString("pers_ncorr")
q_pers_ncorr_aval = Request.QueryString("pers_ncorr_aval")

set errores = new CErrores

'---------------------------------------------------------------------------------------------------
set pagina = new CPagina
pagina.Titulo = "Detalle Boleta"

'---------------------------------------------------------------------------------------------------
set conexion = new CConexion
conexion.Inicializar "upacifico"

set negocio = new CNegocio
negocio.Inicializa conexion

set f_botonera = new CFormulario
f_botonera.Carga_Parametros "detalle_boletas.xml", "botonera"


 sql_tipo_pago="select count(*) from detalle_boletas a, tipos_detalle b " & vbCrLf &_
				" where a.tdet_ccod=b.tdet_ccod" & vbCrLf &_
				" and b.tcom_ccod=7 " & vbCrLf &_
				" and bole_ncorr='" & q_bole_ncorr & "'"
v_tipo_pago= conexion.consultaUno(sql_tipo_pago)
'---------------------------------------------------------------------------------------------------
set f_contrato = new CFormulario
f_contrato.Carga_Parametros "detalle_boletas.xml", "detalle_pagos"
f_contrato.Inicializar conexion

	consulta	 =  " Select a.bole_ncorr,a.tbol_ccod,isnull(dbol_mtotal,0) dbol_mtotal, isnull(dbol_mtotal,0) as c_dbol_mtotal , isnull(bole_nboleta,0) bole_nboleta , ISNULL(tdet_ccod,0) as tdet_ccod " & vbCrLf &_
					" from boletas a, detalle_boletas b, personas c " & vbCrLf &_
					" where a.bole_ncorr*=b.bole_ncorr " & vbCrLf &_
					" and a.pers_ncorr*=c.pers_ncorr " & vbCrLf &_
					" and a.bole_ncorr = '" & q_bole_ncorr & "'" & vbCrLf &_
					"order by b.tdet_ccod asc"
'response.Write("<pre>"&consulta&"</pre>")
f_contrato.Consultar consulta

v_usuario=negocio.ObtenerUsuario()

sql_rol=" Select count(*) from sis_roles_usuarios a, personas b "& vbCrLf &_
		" Where a.srol_ncorr in (28,1) "& vbCrLf &_
		" And a.pers_ncorr=b.pers_ncorr "& vbCrLf &_
		" And cast(pers_nrut as varchar)='"&v_usuario&"'"
		
v_rol_ccod=conexion.ConsultaUno(sql_rol)


sql_tipo_boleta="Select b.tbol_tdesc from boletas a, tipos_boletas b where a.tbol_ccod=b.tbol_ccod and a.bole_ncorr="&q_bole_ncorr
v_tipo_boleta=conexion.consultaUno(sql_tipo_boleta)

sql_num_boleta="Select a.bole_nboleta from boletas a where a.bole_ncorr="&q_bole_ncorr
v_num_boleta=conexion.consultaUno(sql_num_boleta)

sql_fecha="select cast(DATEPART(dd,getdate()) as varchar)+ ' de ' +(select mes_tdesc  from meses  where mes_ccod=DATEPART(mm,getdate())) + ' de ' +cast(DATEPART(yyyy,getdate())as varchar)"
v_fecha_hoy=conexion.consultaUno(sql_fecha)
'---------------------------------------------------------------------------------------------------
set f_datos_alumnos = new CFormulario
f_datos_alumnos.Carga_Parametros "detalle_boletas.xml", "datos_alumno"
f_datos_alumnos.Inicializar conexion


consulta= "Select protic.obtener_rut(c.pers_ncorr) as rut_alumno,  "& vbCrLf &_
		" protic.obtener_nombre_completo(c.pers_ncorr,'n') as nombre_alumno,  "& vbCrLf &_
		" b.peri_ccod,protic.obtener_nombre_carrera(b.ofer_ncorr,'CJ') as carrera  "& vbCrLf &_
		" from personas_postulante c  "& vbCrLf &_
		"    left outer join alumnos a "& vbCrLf &_
		"        on  c.pers_ncorr=a.pers_ncorr  "& vbCrLf &_
		"    left outer join  ofertas_academicas b  "& vbCrLf &_
		"        on a.ofer_ncorr=b.ofer_ncorr "& vbCrLf &_
		"        and a.emat_ccod=1 "& vbCrLf &_
		" where c.pers_ncorr="&q_pers_ncorr&"  "& vbCrLf &_
		" order by b.peri_ccod desc, a.matr_ncorr desc  "
 

'response.Write("<pre>"&consulta&"</pre>")

f_datos_alumnos.Consultar consulta
f_datos_alumnos.siguiente

set f_datos_aval = new CFormulario
f_datos_aval.Carga_Parametros "detalle_boletas.xml", "datos_aval"
f_datos_aval.Inicializar conexion

if v_tipo_pago>0 then
consulta = " Select protic.obtener_rut(a.pers_ncorr) as rut_aval, protic.obtener_nombre_completo(a.pers_ncorr,'n') as nombre_aval, "& vbCrLf &_
			 " c.ciud_tcomuna, c.ciud_tdesc, isnull(protic.obtener_direccion_letra(a.pers_ncorr,1,'CNPB'),protic.obtener_direccion(a.pers_ncorr,1,'CNPB')) as direccion "& vbCrLf &_
			 " From personas a "& vbCrLf &_
			 " LEFT OUTER JOIN direcciones b "& vbCrLf &_
			 "   ON A.pers_ncorr = B.pers_ncorr "& vbCrLf &_
			 "   and b.tdir_ccod = 1 "& vbCrLf &_ 
			 " LEFT OUTER JOIN ciudades c "& vbCrLf &_
			 "   ON b.ciud_ccod = c.ciud_ccod  "& vbCrLf &_
			 " where a.pers_ncorr= '"&q_pers_ncorr_aval&"' "

else
consulta = " Select protic.obtener_rut(a.pers_ncorr) as rut_aval, protic.obtener_nombre_completo(a.pers_ncorr,'n') as nombre_aval, "& vbCrLf &_
			 " c.ciud_tcomuna, c.ciud_tdesc, protic.obtener_direccion_letra(a.pers_ncorr,1,'CNPB') as direccion "& vbCrLf &_
			 " From personas_POSTULANTE a "& vbCrLf &_
			 " LEFT OUTER JOIN direcciones b "& vbCrLf &_
			 "   ON A.pers_ncorr = B.pers_ncorr "& vbCrLf &_
			 "   and b.tdir_ccod = 1 "& vbCrLf &_ 
			 " LEFT OUTER JOIN ciudades c "& vbCrLf &_
			 "   ON b.ciud_ccod = c.ciud_ccod  "& vbCrLf &_
			 " where a.pers_ncorr= '"&q_pers_ncorr_aval&"' "
end if			 
'response.Write("<pre>"&consulta&"</pre>")
f_datos_aval.Consultar consulta
f_datos_aval.siguiente

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
</script>

</head>
<body bgcolor="#D8D8DE" leftmargin="0" topmargin="0" marginwidth="0" marginheight="0" onLoad="MM_preloadImages('../imagenes/botones/buscar_f2.gif','../images/bot_deshabilitar_f2.gif','../images/agregar2_f2_p.gif','im&amp;#225;genes/marco1_r3_c2_f2.gif');MM_preloadImages('im&amp;#225;genes/marco1_r3_c4_f2.gif');MM_preloadImages('im&amp;#225;genes/marco1_r3_c6_f2.gif');MM_preloadImages('im&amp;#225;genes/marco1_r3_c8_f2.gif');MM_preloadImages('../imagenes/botones/cargar_f2.gif','../imagenes/botones/continuar_f2.gif')" onBlur="revisaVentana();">
<table width="100%" height="100%" border="0" align="center" cellpadding="0" cellspacing="0">
  <tr>
    <td valign="top" bgcolor="#EAEAEA">
	<br>
	<table width="90%"  border="0" align="center" cellpadding="0" cellspacing="0" bgcolor="#D8D8DE">
      <tr>
        <td width="9" height="8"><img name="top_r1_c1" src="../imagenes/top_r1_c1.gif" width="9" height="8" border="0" alt=""></td>
        <td height="8" background="../imagenes/top_r1_c2.gif"></td>
        <td width="7" height="8"><img name="top_r1_c3" src="../imagenes/top_r1_c3.gif" width="7" height="8" border="0" alt=""></td>
      </tr>
      <tr>
        <td width="9" background="../imagenes/izq.gif">&nbsp;</td>
        <td><table width="100%"  border="0" cellspacing="0" cellpadding="0">
          <tr>
            <td><%pagina.DibujarLenguetas Array("Forma de Pago"), 1 %></td>
          </tr>
          <tr>
            <td height="2" background="../imagenes/top_r3_c2.gif"></td>
          </tr>
          <tr>
            <td><div align="center"><br>
              <%pagina.DibujarTituloPagina%>
              <br>
              <br>
			  <table width="100%">
			  <tr>
				  <td width="90%"></td>
				  <td width="3%" align="left"><font color="#0066FF" size="+1"><strong>N°: </strong></font></td>
				  <td width="7%" align="left"><font color="#0066FF" size="+1"><strong><%=v_num_boleta%></strong></font></td>
			  </tr>
			  </table>
              <table width="96%"  border="0" cellspacing="0" cellpadding="0">
                <tr>
				<th align="left">Santiago :</th>
				<td><%=v_fecha_hoy%></td>
				</tr>
				<tr>
				  <th width="9%" align="left"> Rut : </th>
                  <td width="26%"><%f_datos_aval.DibujaCampo("rut_aval")%></td>
				  <th width="8%" align="left">Nombre :</th>
				  <td width="57%"><%f_datos_aval.DibujaCampo("nombre_aval")%></td>
                </tr>
                <tr>
                  <th align="left">Direccion :</th>
                  <td colspan="3"><%f_datos_aval.DibujaCampo("direccion")%></td>
                  </tr>
                <tr>
                  <th align="left">Comuna :</th>
                  <td><%f_datos_aval.DibujaCampo("Ciud_tdesc")%></td>
                  <th align="left">Ciudad :</th>
                  <td><%f_datos_aval.DibujaCampo("ciud_tcomuna")%></td>
                </tr>
              </table>
                </div>
              <form name="edicion" action="proc_editar_boletas.asp" method="post" onSubmit="return(preValidaFormulario(document.edicion));">
                <table width="98%"  border="0" align="center" cellpadding="0" cellspacing="0">
                  <tr>
                    <td><%pagina.DibujarSubtitulo "Detalle Boleta"%>
                      <table width="98%"  border="0" align="center" cellpadding="0" cellspacing="0">
                        <tr>
                          <td><div align="center"><%f_contrato.DibujaTabla%></div></td>
                        </tr>
                        
                      </table>
					  <br>
					  <% 
					  if f_contrato.ObtenerValor("ebol_ccod")<>"1" and v_rol_ccod>="1" then%>
					  <table>
					  <input type="hidden" name="boleta[0][bole_ncorr]" value="<%=f_contrato.DibujaCampo("bole_ncorr")%>" >
					  <input type="hidden" name="boleta[0][tbol_ccod]" value="<%=f_contrato.DibujaCampo("tbol_ccod")%>" >
					  <tr>
						  <td>Cambiar N&deg;:</td>
						  <td><input type="text" name="boleta[0][bole_nboleta]" id="NU-S" value="<%=f_contrato.DibujaCampo("bole_nboleta")%>" size="5" maxlength="5"></td>
						  <td><input type="submit" value="Cambiar" ></td>
					  </tr>
					  
				  </table>
				  <%End if%>
					<br>
                      </td>
                  </tr>
                </table>
                         <table width="96%"  border="0" cellspacing="0" cellpadding="0">
							 <tr>
							 	<th width="15%" align="left">Carrera : </th>
								<td width="33%" ><%f_datos_alumnos.DibujaCampo("carrera")%></td>
								<td width="52%" rowspan="2" align="center"><font size="+1" color="#0033FF"> Boleta <%=v_tipo_boleta%></font></td>
							 </tr>
							 <tr>
							 	<th align="left">Rut Alumno :</th>
								<td><%f_datos_alumnos.DibujaCampo("rut_alumno")%></td>
							 </tr>

						 </table>
						 <br>
            </form></td></tr>
        </table></td>
        <td width="7" background="../imagenes/der.gif">&nbsp;</td>
      </tr>
      <tr>
        <td width="9" height="28"><img src="../imagenes/abajo_r1_c1.gif" width="9" height="28"></td>
        <td height="28"><table width="100%" height="28"  border="0" cellpadding="0" cellspacing="0">
          <tr>
            <td width="15%" height="20"><div align="center">
              <table width="90%"  border="0" cellspacing="0" cellpadding="0">
                <tr>
                  <td><div align="center"><%f_botonera.DibujaBoton("cerrar")%></div></td>
				  <td><%
				  f_botonera.AgregaBotonParam "imprimir", "url", "imprimir_boleta.asp?bole_ncorr="&q_bole_ncorr&"&pers_ncorr="&q_pers_ncorr&"&pers_ncorr_aval="&q_pers_ncorr_aval&" "
				  f_botonera.DibujaBoton("imprimir")%></td>
                  </tr>
              </table>
            </div></td>
            <td width="85%" rowspan="2" background="../imagenes/abajo_r1_c4.gif"><img src="../imagenes/abajo_r1_c3.gif" width="12" height="28"></td>
            </tr>
          <tr>
            <td height="8" background="../imagenes/abajo_r2_c2.gif"></td>
          </tr>
        </table></td>
        <td width="7" height="28"><img src="../imagenes/abajo_r1_c5.gif" width="7" height="28"></td>
      </tr>
    </table>
	<br>
	<br>	</td>
  </tr>  
</table>
</body>
</html>
