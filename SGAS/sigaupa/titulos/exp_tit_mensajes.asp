<!-- #include file = "../biblioteca/_conexion.asp" -->
<!-- #include file = "../biblioteca/_negocio.asp" -->

<%
'for each k in request.queryString
'	response.Write(k&" = "&request.querystring(k)&"<br>")
'next
saca_ncorr = Request.QueryString("saca_ncorr")
pers_ncorr = Request.QueryString("pers_ncorr")

'---------------------------------------------------------------------------------------------------
set pagina = new CPagina
pagina.Titulo = "Mensajes asociados al expediente"

'---------------------------------------------------------------------------------------------------
set conexion = new CConexion
conexion.Inicializar "upacifico"

set negocio = new CNegocio
negocio.Inicializa conexion

set f_salida = new CFormulario
f_salida.Carga_Parametros "expediente_titulacion.xml", "salida"
f_salida.Inicializar conexion

SQL = " select b.pers_ncorr,a.saca_ncorr,cast(b.pers_nrut as varchar)+'-'+b.pers_xdv as rut, b.pers_nrut, b.pers_xdv,  "& vbCrLf &_
      " b.pers_tnombre + ' ' + b.pers_tape_paterno + ' ' + b.pers_tape_materno as alumno, "& vbCrLf &_
	  " a.saca_tdesc as salida, c.tsca_ccod,case c.tsca_ccod when 1 then '<font color=#073299><strong>' "& vbCrLf &_ 
      "            when 2 then '<font color=#004000><strong>' "& vbCrLf &_ 
  	  " 		   when 3 then '<font color=#b76d05><strong>' "& vbCrLf &_ 
	  "			   when 4 then '<font color=#714e9c><strong>' "& vbCrLf &_ 
	  " 		   when 5 then '<font color=#ab2b05><strong>' "& vbCrLf &_ 
	  "  		   when 6 then '<font color=#0078c0><strong>' end + c.tsca_tdesc + '</strong></font>' as tipo_salida, d.carr_ccod, d.carr_tdesc, "& vbCrLf &_
      "    (select top 1 sede_ccod from alumnos t1 INNER JOIN ofertas_academicas t2 "& vbCrLf &_
      "            ON t1.ofer_ncorr = t2.ofer_ncorr "& vbCrLf &_
      "            INNER JOIN especialidades t3 "& vbCrLf &_
      "            ON t2.espe_ccod = t3.espe_ccod "& vbCrLf &_
      "            WHERE t1.pers_ncorr = b.pers_ncorr and t3.carr_ccod = a.carr_ccod order by t2.peri_ccod desc) as sede_ccod, "& vbCrLf &_
      "    (select top 1 sede_tdesc from alumnos t1 INNER JOIN ofertas_academicas t2 "& vbCrLf &_
      "            ON t1.ofer_ncorr = t2.ofer_ncorr "& vbCrLf &_
      "            INNER JOIN especialidades t3 "& vbCrLf &_
      "            ON t2.espe_ccod = t3.espe_ccod "& vbCrLf &_
      "            INNER JOIN sedes t4 "& vbCrLf &_
      "            ON t2.sede_ccod = t4.sede_ccod "& vbCrLf &_
      "            WHERE t1.pers_ncorr = b.pers_ncorr and t3.carr_ccod = a.carr_ccod order by t2.peri_ccod desc) as sede_tdesc, "& vbCrLf &_
      "    (select top 1 t4.jorn_ccod from alumnos t1 INNER JOIN ofertas_academicas t2 "& vbCrLf &_
      "            ON t1.ofer_ncorr = t2.ofer_ncorr "& vbCrLf &_
      "            INNER JOIN especialidades t3 "& vbCrLf &_
      "            ON t2.espe_ccod = t3.espe_ccod "& vbCrLf &_
      "            INNER JOIN jornadas t4 "& vbCrLf &_
      "            ON t2.jorn_ccod = t4.jorn_ccod "& vbCrLf &_
      "            WHERE t1.pers_ncorr = b.pers_ncorr and t3.carr_ccod = a.carr_ccod order by t2.peri_ccod desc) as jorn_ccod, "& vbCrLf &_
	  "    (select top 1 jorn_tdesc from alumnos t1 INNER JOIN ofertas_academicas t2 "& vbCrLf &_
      "            ON t1.ofer_ncorr = t2.ofer_ncorr "& vbCrLf &_
      "            INNER JOIN especialidades t3 "& vbCrLf &_
      "            ON t2.espe_ccod = t3.espe_ccod "& vbCrLf &_
      "            INNER JOIN jornadas t4 "& vbCrLf &_
      "            ON t2.jorn_ccod = t4.jorn_ccod "& vbCrLf &_
      "            WHERE t1.pers_ncorr = b.pers_ncorr and t3.carr_ccod = a.carr_ccod order by t2.peri_ccod desc) as jorn_tdesc, "& vbCrLf &_
      "    (select top 1 peri_ccod from alumnos t1 INNER JOIN ofertas_academicas t2 "& vbCrLf &_
      "            ON t1.ofer_ncorr = t2.ofer_ncorr "& vbCrLf &_
      "            INNER JOIN especialidades t3 "& vbCrLf &_
      "            ON t2.espe_ccod = t3.espe_ccod "& vbCrLf &_
      "            WHERE t1.pers_ncorr = b.pers_ncorr and t3.carr_ccod = a.carr_ccod and t1.emat_ccod in (4,8) "& vbCrLf &_
      "            order by t2.peri_ccod desc) as peri_ccod, "& vbCrLf &_
      "    (select top 1 peri_tdesc from alumnos t1 INNER JOIN ofertas_academicas t2 "& vbCrLf &_
      "            ON t1.ofer_ncorr = t2.ofer_ncorr "& vbCrLf &_
      "            INNER JOIN especialidades t3 "& vbCrLf &_
      "            ON t2.espe_ccod=t3.espe_ccod "& vbCrLf &_
      "            INNER JOIN periodos_academicos t4 "& vbCrLf &_
      "            ON t2.peri_ccod = t4.peri_ccod "& vbCrLf &_
      "            WHERE t1.pers_ncorr = b.pers_ncorr and t3.carr_ccod = a.carr_ccod and t1.emat_ccod in (4,8) "& vbCrLf &_
      "            order by t2.peri_ccod desc) as peri_tdesc, "& vbCrLf &_
      "    (select case count(*) when 0 then 'N' else 'S' end  from alumnos t1 INNER JOIN ofertas_academicas t2 "& vbCrLf &_
      "            ON t1.ofer_ncorr = t2.ofer_ncorr "& vbCrLf &_
      "            INNER JOIN especialidades t3 "& vbCrLf &_
      "            ON t2.espe_ccod=t3.espe_ccod "& vbCrLf &_
      "            WHERE t1.pers_ncorr = b.pers_ncorr and t3.carr_ccod = a.carr_ccod and t1.emat_ccod in (4)) as egresado, "& vbCrLf &_
      "    (select case count(*) when 0 then 'N' else 'S' end  from alumnos t1 INNER JOIN ofertas_academicas t2 "& vbCrLf &_
      "            ON t1.ofer_ncorr = t2.ofer_ncorr "& vbCrLf &_
      "            INNER JOIN especialidades t3 "& vbCrLf &_
      "            ON t2.espe_ccod = t3.espe_ccod "& vbCrLf &_
      "            WHERE t1.pers_ncorr = b.pers_ncorr and t3.carr_ccod = a.carr_ccod and t1.emat_ccod in (8)) as titulado, "& vbCrLf &_
      "    (select top 1 t1.plan_ccod  from alumnos t1 INNER JOIN ofertas_academicas t2 "& vbCrLf &_
      "            ON t1.ofer_ncorr = t2.ofer_ncorr "& vbCrLf &_
      "            INNER JOIN especialidades t3 "& vbCrLf &_
      "            ON t2.espe_ccod = t3.espe_ccod "& vbCrLf &_
      "            WHERE t1.pers_ncorr = b.pers_ncorr and t3.carr_ccod = a.carr_ccod and t1.emat_ccod in (4) order by peri_ccod desc ) as plan_ccod, "& vbCrLf &_
      " asca_ncorr, protic.trunc(asca_fsalida) as asca_fsalida, asca_nfolio, asca_nregistro, replace(cast(asca_nnota as decimal(2,1)),',','.') as asca_nnota, ' '  as asca_bingr_manual, "& vbCrLf &_
      "    (select max(peri_ccod) "& vbCrLf &_
      "			from alumnos t1 INNER JOIN ofertas_academicas t2 "& vbCrLf &_
      "			ON t1.pers_ncorr = b.pers_ncorr "& vbCrLf &_
      "			INNER JOIN especialidades t3 "& vbCrLf &_
      "			ON t1.ofer_ncorr = t2.ofer_ncorr "& vbCrLf &_
      "			WHERE t2.espe_ccod = t3.espe_ccod and t3.carr_ccod = d.carr_ccod and isnull(t1.emat_ccod,0) <> 9) as ultimo_periodo "& vbCrLf &_
      " from salidas_carrera a INNER JOIN personas b "& vbCrLf &_
      " ON cast(b.pers_ncorr as varchar)='"&pers_ncorr&"' and cast(a.saca_ncorr as varchar)='"&saca_ncorr&"' "& vbCrLf &_
      " INNER JOIN tipos_salidas_carrera c "& vbCrLf &_
      " ON a.tsca_ccod=c.tsca_ccod "& vbCrLf &_
      " INNER JOIN  carreras d "& vbCrLf &_
      " ON a.carr_ccod=d.carr_ccod "& vbCrLf &_
      " LEFT OUTER JOIN alumnos_salidas_carrera e "& vbCrLf &_
      " ON a.saca_ncorr = e.saca_ncorr and b.pers_ncorr = e.pers_ncorr" 

f_salida.Consultar SQL
f_salida.Siguiente
plan_ccod = f_salida.obtenerValor("plan_ccod")
ultimo_periodo = f_salida.obtenerValor("ultimo_periodo")
carr_ccod = f_salida.obtenerValor("carr_ccod")
jorn_ccod = f_salida.obtenerValor("jorn_ccod")
rut = f_salida.obtenerValor("rut")
alumno = f_salida.obtenerValor("alumno")
v_sede_ccod = conexion.consultaUno("select top 1 sede_ccod from personas a, alumnos b, ofertas_academicas c where cast(a.pers_nrut as varchar)='"&q_pers_nrut&"' and a.pers_ncorr=b.pers_ncorr and cast(b.plan_Ccod as varchar)='"&q_plan_ccod&"' and b.ofer_ncorr=c.ofer_ncorr order by peri_ccod desc")

q_plan_ccod  = plan_ccod
q_peri_ccod  = ultimo_periodo
q_pers_nrut = conexion.consultaUno("Select pers_nrut from personas where cast(pers_ncorr as varchar)='"&pers_ncorr&"'")
q_pers_xdv  = conexion.consultaUno("Select pers_xdv from personas where cast(pers_ncorr as varchar)='"&pers_ncorr&"'")

c_email_escuela = " select top 1 replace(pers_temail,' ','%20') as email  "& vbCrLf &_
                  " from EMAIL_DIRECTORES_CARRERA where carr_ccod='" & carr_ccod & "' and cast(sede_ccod as varchar)='" & v_sede_ccod & "'  "& vbCrLf &_
			      " and cast(jorn_ccod as varchar)='" & jorn_ccod & "' "

q_email_escuela = conexion.consultaUno(c_email_escuela)
q_email_titulos = "titulosygrados@upacifico.cl"

c_de_titulos = "select count(*) from personas a, sis_roles_usuarios b where a.pers_ncorr=b.pers_ncorr and b.srol_ncorr in (49,95) and cast(a.pers_nrut as varchar)='"&negocio.obtenerUsuario&"'"
de_titulos = conexion.consultaUno(c_de_titulos)

if de_titulos = "0" then
	desde = q_email_escuela
	hasta = q_email_titulos
else
	hasta = q_email_escuela
	desde = q_email_titulos
end if

'---------------------------------------------------------------------------------------------------
set f_botonera = new CFormulario
f_botonera.Carga_Parametros "expediente_titulacion.xml", "botonera"
'---------------------------------------------------------------------------------------------------

'---------------------------------------------------------------------------------------------------
set f_titulado = new CFormulario
f_titulado.Carga_Parametros "expediente_titulacion.xml", "encabezado_de"
f_titulado.Inicializar conexion

SQL = " select f.sede_ccod, a.pers_ncorr, b.plan_ccod, c.espe_ccod, e.peri_ccod, d.carr_tdesc, c.espe_tdesc, e.peri_tdesc, f.sede_tdesc, plan_tdesc as plan_ncorrelativo, protic.obtener_rut(a.pers_ncorr) as rut, protic.obtener_nombre_completo(a.pers_ncorr,'n') as nombre " & vbCrLf & _
	  " from personas a, planes_estudio b, especialidades c, carreras d, periodos_academicos e, sedes f " & vbCrLf & _
	  " where b.espe_ccod = c.espe_ccod " & vbCrLf & _
	  "   and c.carr_ccod = d.carr_ccod " & vbCrLf & _
	  "   and cast(f.sede_ccod as varchar)= '" & v_sede_ccod & "' " & vbCrLf & _
	  "   and cast(e.peri_ccod as varchar)= '" & q_peri_ccod & "' " & vbCrLf & _
	  "   and cast(a.pers_nrut as varchar)= '" & q_pers_nrut & "' " & vbCrLf & _
	  "   and cast(b.plan_ccod as varchar)= '" & q_plan_ccod & "'"

f_titulado.Consultar SQL
f_titulado.SiguienteF
v_sede_ccod = f_titulado.obtenerValor("sede_ccod")


set f_mensajes = new CFormulario
f_mensajes.Carga_Parametros "expediente_titulacion.xml", "listado_msj"
f_mensajes.Inicializar conexion

SQL = " select fecha_envio fe,megr_ncorr,pers_ncorr,saca_ncorr,email_desde,email_hasta,  " & vbCrLf & _
	  "		   protic.trunc(fecha_envio) as fecha_envio,protic.trunc(fecha_lectura) as fecha_lectura,titulo  " & vbCrLf & _
	  "	from mensajes_egreso  " & vbCrLf & _
	  "	where cast(pers_ncorr as varchar)='"&pers_ncorr&"'  " & vbCrLf & _
	  "	and cast(saca_ncorr as varchar)='"&saca_ncorr&"' " & vbCrLf & _
	  "	order by fecha_envio desc"

f_mensajes.Consultar SQL

'---------------------------------------------------------------------------------------------------
f_botonera.AgregaBotonUrlParam "siguiente", "pers_nrut", q_pers_nrut
f_botonera.AgregaBotonUrlParam "siguiente", "pers_xdv", q_pers_xdv
'---------------------------------------------------------------------------------------------------

'---------------------------------------------------------------------------------------------------
url_leng_0 = "exp_tit_mensajes.asp?saca_ncorr=" & saca_ncorr & "&pers_ncorr=" & pers_ncorr
url_leng_1 = "exp_tit_datos_personales.asp?saca_ncorr=" & saca_ncorr & "&pers_ncorr=" & pers_ncorr
url_leng_2 = "exp_tit_doctos_entregados.asp?saca_ncorr=" & saca_ncorr & "&pers_ncorr=" & pers_ncorr
url_leng_3 = "exp_tit_historico_notas.asp?saca_ncorr=" & saca_ncorr & "&pers_ncorr=" & pers_ncorr
url_leng_4 = "exp_tit_practica.asp?saca_ncorr=" & saca_ncorr & "&pers_ncorr=" & pers_ncorr
url_leng_5 = "exp_tit_egreso.asp?saca_ncorr=" & saca_ncorr & "&pers_ncorr=" & pers_ncorr
url_leng_6 = "exp_tit_salida.asp?saca_ncorr=" & saca_ncorr & "&pers_ncorr=" & pers_ncorr
url_leng_7 = "exp_tit_titulo.asp?saca_ncorr=" & saca_ncorr & "&pers_ncorr=" & pers_ncorr
url_leng_8 = "exp_tit_concentracion.asp?saca_ncorr=" & saca_ncorr & "&pers_ncorr=" & pers_ncorr

'---------------------------------------------------------------------------------------------------

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


var t_datos;
var o_pers_nrut;
var flag;





function dBlur()
{
	flag = 1;
}


function InicioPagina()
{
	t_datos = new CTabla("dp");
	
	flag = 0;
}

contenido_textarea = ""; 
num_caracteres_permitidos = 1000;

function valida_longitud()
{ 
   num_caracteres = document.forms[0].contenido.value.length; 

   if (num_caracteres > num_caracteres_permitidos)
   { 
      document.forms[0].contenido.value = contenido_textarea; 
   }
   else
   { 
      contenido_textarea = document.forms[0].contenido.value; 
   } 

   if (num_caracteres >= num_caracteres_permitidos)
   { 
      document.forms[0].caracteres.style.color="#ff0000"; 
   }
   else{ 
      document.forms[0].caracteres.style.color="#000000"; 
   } 
   cuenta(); 
} 

function cuenta(){ 
   document.forms[0].caracteres.value= num_caracteres_permitidos - document.forms[0].contenido.value.length; 
} 

</script>

</head>
<body bgcolor="#D8D8DE" leftmargin="0" topmargin="0" marginwidth="0" marginheight="0" onLoad="MM_preloadImages('../imagenes/botones/buscar_f2.gif','../images/bot_deshabilitar_f2.gif','../images/agregar2_f2_p.gif','im&amp;#225;genes/marco1_r3_c2_f2.gif');MM_preloadImages('im&amp;#225;genes/marco1_r3_c4_f2.gif');MM_preloadImages('im&amp;#225;genes/marco1_r3_c6_f2.gif');MM_preloadImages('im&amp;#225;genes/marco1_r3_c8_f2.gif');MM_preloadImages('../imagenes/botones/cargar_f2.gif','../imagenes/botones/continuar_f2.gif'); InicioPagina();" onBlur="revisaVentana();">
<table width="100%" height="100%" border="0" align="center" cellpadding="0" cellspacing="0">
  <tr>
    <td align="right" valign="top" bgcolor="#EAEAEA">	  <br>
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
            <td><%pagina.DibujarLenguetasFClaro Array(Array("Mensajes", url_leng_0), Array("Datos Pers.", url_leng_1), Array("Docs Alumno", url_leng_2),Array("Hist. Notas", url_leng_3), Array("Práctica prof.", url_leng_4), Array("Datos Egreso", url_leng_5),Array("Reg. Salida", url_leng_6), Array("Tesis y comisión", url_leng_7), Array("Conc. Notas", url_leng_8)), 1%></td>
          </tr>
          <tr>
            <td height="2" background="../imagenes/top_r3_c2.gif"></td>
          </tr>
          <tr>
            <td>
			   <form name="edicion">
			    <input type="hidden" name="rut" value="<%=rut%>">
				<input type="hidden" name="alumno" value="<%=alumno%>">
				<input type="hidden" name="audi_tusuario" value="<%=negocio.obtenerUsuario%>">
				<input type="hidden" name="pers_ncorr" value="<%=pers_ncorr%>">
				<input type="hidden" name="saca_ncorr" value="<%=saca_ncorr%>">
                <table width="98%"  border="0" align="center" cellpadding="0" cellspacing="0">
                  <tr> 
                      <td>
                        <table width="98%"  border="0" align="center">
                          <tr> 
                            <td width="100%">
							  <div align="center">
                                <%f_titulado.DibujaRegistro%>
                              </div>
							</td>
                          </tr>
						  <tr> 
                            <td width="100%">&nbsp;</td>
                          </tr>
						  <tr> 
                            <td width="100%">
								<table width="98%"  border="0" align="center">
							      <tr valign="top"> 
									<td><font size="2" face="Georgia, Times New Roman, Times, serif" color="#496da6"><strong>De</strong></font></td>
									<td><strong>:</strong></td>
									<td><input type="text" size='50' maxlength='50' id='EM-N' name="email_desde" value="<%=desde%>"> </td>
								  </tr>
								  <tr valign="top"> 
									<td><font size="2" face="Georgia, Times New Roman, Times, serif" color="#496da6"><strong>Para</strong></font></td>
									<td><strong>:</strong></td>
								    <td><input type="text" size='50' maxlength='50' id='EM-N' name="email_hasta" value="<%=hasta%>"></td>
								  </tr>
								  <tr valign="top"> 
									<td><font size="2" face="Georgia, Times New Roman, Times, serif" color="#496da6"><strong>Asunto</strong></font></td>
									<td><strong>:</strong></td>
									<td><input type='text'  name='titulo' value='<%=titulo%>' size='50'  maxlength='50'  id='TO-N' ></td>
								  </tr>
								  <tr valign="top"> 
									<td><font size="2" face="Georgia, Times New Roman, Times, serif" color="#496da6"><strong>Contenido</strong></font></td>
									<td><strong>:</strong></td>
									<td><textarea  cols='60'  rows='10'  id='TO-N' name='contenido' onKeyDown="valida_longitud()" onKeyUp="valida_longitud()"><%=contenido%></textarea><input type="text" name="caracteres" size="4"></td>
								  </tr>
								  <tr>
									<td colspan="3" align="center">
									     <%f_botonera.dibujaboton "enviar_mensaje"%>
									</td>
								  </tr>
								</table>
								   
							</td>
                          </tr>
                        </table></td>
                  </tr>
				  <tr>
                    <td>
					  <%pagina.DibujarSubtitulo "Mensajes asociados al expediente"%>
                      <table width="98%"  border="0" align="center">
                        <tr>
							<td width="100%">
							    <%f_mensajes.DibujaTabla%>
							</td>
						</tr>
                      </table>
					</td>
                  </tr>
				  <tr>
                    <td>&nbsp;</td>
                  </tr>
				  <tr>
                    <td>&nbsp;</td>
                  </tr>
	           </table>
            </form></td></tr>
        </table></td>
        <td width="7" background="../imagenes/der.gif">&nbsp;</td>
      </tr>
      <tr>
        <td width="9" height="28"><img src="../imagenes/abajo_r1_c1.gif" width="9" height="28"></td>
        <td height="28"><table width="100%" height="28"  border="0" cellpadding="0" cellspacing="0">
          <tr>
            <td width="23%" height="20"><div align="center">
              <table width="90%"  border="0" cellspacing="0" cellpadding="0">
                <tr>
                  <td><div align="center"><%f_botonera.DibujaBoton "guardar_doc"%></div></td>
                  <td><div align="center"><%f_botonera.DibujaBoton "cerrar"%></div></td>
                </tr>
              </table>
            </div></td>
            <td width="77%" rowspan="2" background="../imagenes/abajo_r1_c4.gif"><img src="../imagenes/abajo_r1_c3.gif" width="12" height="28"></td>
            </tr>
          <tr>
            <td height="8" background="../imagenes/abajo_r2_c2.gif"></td>
          </tr>
        </table></td>
        <td width="7" height="28"><img src="../imagenes/abajo_r1_c5.gif" width="7" height="28"></td>
      </tr>
    </table>
	<br>
	<br>
	</td>
  </tr>  
</table>
</body>
</html>

