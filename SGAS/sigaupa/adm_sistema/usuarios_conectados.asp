<!-- #include file = "../biblioteca/_conexion.asp" -->
<%


v_hora_sys		=	Hour(now())
v_minuto_sys	=	Minute(now())
v_dia_sys		=	WeekDay(now())
v_dia_actual 	= 	Day(now())
v_mes_actual	= 	Month(now())
' si el dia es 1=domingo o 7= sabado, se amplia el numero de alumnos permitidos
'response.Write("<br>Dia: "&v_dia_sys)
'response.Write("<br>Hora: "&v_hora_sys)
'response.Write("<br>Minu: "&v_minuto_sys&"<hr>")
if (v_dia_actual=25 and v_mes_actual=12 )or (v_dia_actual=1 and v_mes_actual=1) then
	v_numero_alumnos=185
else
	if v_dia_sys=1 or v_dia_sys=7 then
		v_numero_alumnos=85
		'v_numero_alumnos=0
	else
	' se restringe el numero entre las 8 de la mañana y las 8 (20:00 hrs) de la noche (dias de semana)
		if cint(v_hora_sys)<20 and cint(v_hora_sys)>7 then
			v_numero_alumnos=15
			'v_numero_alumnos=0
		else
			v_numero_alumnos=85
			'v_numero_alumnos=0
		end if
	end if
end if
'response.Write("Numero: "&v_numero_alumnos)
' Maneja Usuarios Conectados
set conexion_logeo = new CLogin
conexion_logeo.Inicializa
 


v_cantidad=conexion_logeo.CantidadUsuariosActivos
v_cantidad_alumnos=conexion_logeo.CantidadAlumnosActivos
conexion_logeo.CierraConexionesInactivas
' variables y funciones para filtrar alumnos por modulos
v_modulo="ESTADISTICAS DE USUARIOS" 
conexion_logeo.ActualizaEstadoLogin v_usuario_login,v_modulo


'conexion_logeo.ControlaNumeroUsuariosPagina 3,"ESTADISTICAS DE USUARIOS"
conexion_logeo.CierraConexion

'---------------------------------------------------------------------------------------------------
set conexion = new CConexion
conexion.Inicializar "upacifico"

set f_botonera = new CFormulario
f_botonera.Carga_Parametros "usuarios_conectados.xml", "botonera"


'---------------------------------------------------------------------------------------------------
set f_datos = new CFormulario
f_datos.Carga_Parametros "usuarios_conectados.xml", "f_datos"
f_datos.Inicializar conexion

  sql = " Select isnull(lusu_tusuario,'F') as tipo_usuario, a.pers_ncorr, b.pers_tnombre+' '+b.pers_tape_paterno as nombre_usuario, "&_ 
        " datediff(mi,lusu_flogeo,lusu_factualiza) as minutos_activo,c.elog_tdesc as estado,"&_
		" datediff(mi,lusu_factualiza,getdate()) as minutos_inactivo,"&_
		" case when datediff(mi,lusu_factualiza,getdate()) > case isnull(lusu_tusuario,'F') when 'A' then 10 else 20 end then '<font color=#FF0000 ><b>Inactivo</b></font>' else '<font color=#0000FF ><b>Activo</b></font>' end  as actividad, "&_
		" cast(datepart(hh,lusu_flogeo) as varchar)+':'+cast(datepart(mi,lusu_flogeo) as varchar)+':'+cast(datepart(ss,lusu_flogeo) as varchar) as inicio_login,  "&_
		" cast(datepart(hh,lusu_factualiza) as varchar)+':'+cast(datepart(mi,lusu_factualiza) as varchar)+':'+cast(datepart(ss,lusu_factualiza) as varchar) as ultima_actualizacion  "&_
		" from login_usuarios a, personas b, estados_login c "&_
        " where a.pers_ncorr=b.pers_ncorr "&_
		 " and a.elog_ccod=c.elog_ccod "&_
		 " and a.elog_ccod=1 "&_
         " and protic.trunc(lusu_flogeo)=protic.trunc(getdate())"&_
		 " order by lusu_ncorr, nombre_usuario "

f_datos.Consultar sql
'f_datos.Siguiente
'response.End()
'v_valor=f_datos.nrofilas
'response.Write(v_valor)

%>


<html>
<head>
<title>Administración de usuarios conectados</title>
<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1">
<link href="../estilos/estilos.css" rel="stylesheet" type="text/css">
<link href="../estilos/tabla.css" rel="stylesheet" type="text/css">

<script language="JavaScript" src="../biblioteca/tabla.js"></script>
<script language="JavaScript" src="../biblioteca/funciones.js"></script>
<script language="JavaScript" src="../biblioteca/validadores.js"></script>

<script language="JavaScript">

</script>

<style type="text/css">
<!--
.Estilo1 {color: #FF0000}
-->
</style>
</head>
<body bgcolor="#CC6600" leftmargin="0" topmargin="0" marginwidth="0" marginheight="0" onLoad="MM_preloadImages('../imagenes/botones/buscar_f2.gif','../images/bot_deshabilitar_f2.gif','../images/agregar2_f2_p.gif','im&amp;#225;genes/marco1_r3_c2_f2.gif');MM_preloadImages('im&amp;#225;genes/marco1_r3_c4_f2.gif');MM_preloadImages('im&amp;#225;genes/marco1_r3_c6_f2.gif');MM_preloadImages('im&amp;#225;genes/marco1_r3_c8_f2.gif');MM_preloadImages('../imagenes/botones/cargar_f2.gif','../imagenes/botones/continuar_f2.gif')" >
<table width="500" height="380" border="0" align="center" cellpadding="0" cellspacing="0">
  <tr>
    <td height="62" valign="top"><img src="../imagenes/vineta2_r1_c1.gif" width="750" height="72" border="0"></td>
  </tr>
  <tr>
    <td valign="top" bgcolor="#EAEAEA">
	<br>
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
            <td valign="middle" nowrap background="../imagenes/fondo1.gif" >
   <div align="center"><font color="#FFFFFF" face="Verdana, Arial, Helvetica, sans-serif">Control de Usuarios</font></div></td>
<td width="6"><img src="../imagenes/derech1.gif" width="6" height="17" ></td>
          </tr>
          <tr>
            <td height="2" background="../imagenes/top_r3_c2.gif"></td>
          </tr>
          <tr>
            <td><div align="center"><br>
                         <font face="Verdana, Arial, Helvetica, sans-serif"><span style="color:#42424A; font-weight: bold; font-size: 17px">ADMINISTRACIÓN DE USUARIOS CONECTADOS</span></font><br></div>
              <form name="edicion">
		        <br>
 
                <table width="98%"  border="0" align="center" cellpadding="0" cellspacing="0">
					<tr>
						<td width="38%" height="20" align="left"><font color="#0000FF" size="2">Usuarios Reales Activos: <b><%=v_cantidad%></b></font></td>
					
			            <td width="31%" align="left"><font color="#660000" size="2">Alumnos Activos: <b><%=v_cantidad_alumnos%></b></font></td>
					    <td width="31%" align="left"><font color="#660000" size="2">Funcionarios Activos: <b><%=v_cantidad-v_cantidad_alumnos%></b></font></td>
					</tr>
					<tr>
						<td colspan="3" align="left">Paginas: <%f_datos.AccesoPagina%></td>
					</tr>
					<tr align="center">
						<td colspan="3"><%f_datos.DibujaTabla()%></td>
					</tr>
<tr>
<td colspan="3"><br><P>Descripcion del campo tipo</P></td>
</tr>
						<tr align="left">
					  		<td colspan="3">A: Alumno</td>
					  </tr>
						<tr align="left">
					  		<td colspan="3">F: Funcionario</td>
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
            <td width="21%" height="20"><div align="center">
                    <table width="90%"  border="0" cellspacing="0" cellpadding="0">
                      <tr> 
                        <td> <div align="left"> </div></td>
                        <td> <div align="left">
                            <%f_botonera.DibujaBoton "salir" %>
                          </div></td>
                      </tr>
                    </table>
            </div></td>
            <td width="79%" rowspan="2" background="../imagenes/abajo_r1_c4.gif"><img src="../imagenes/abajo_r1_c3.gif" width="12" height="28"></td>
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
<%'conexion.CierraConexion%>
</html>
