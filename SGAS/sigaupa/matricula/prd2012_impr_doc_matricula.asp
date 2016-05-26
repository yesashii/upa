<!-- #include file = "../biblioteca/_conexion.asp" -->
<!-- #include file = "../biblioteca/_negocio.asp" -->

<%
q_pers_nrut = Request.QueryString("pers_nrut")

'---------------------------------------------------------------------------------------------------
set pagina = new CPagina
pagina.Titulo = "DOCUMENTOS RECIBIDOS POR MATRICULA"

'---------------------------------------------------------------------------------------------------
set conexion = new CConexion
conexion.Inicializar "upacifico"

set negocio = new CNegocio
negocio.Inicializa conexion

'---------------------------------------------------------------------------------------------------
set f_botonera = new CFormulario
f_botonera.Carga_Parametros "documentacion_matricula.xml", "botonera"

fecha_01=conexion.consultaUno("select cast(datePart(day,getDate())as varchar)+'-'+cast(datePart(month,getDate())as varchar)+'-'+cast(datePart(year,getDate())as varchar) as fecha")
'---------------------------------------------------------------------------------------------------
set f_documentos = new CFormulario
f_documentos.Carga_Parametros "documentacion_matricula.xml", "impr_documentos"
f_documentos.Inicializar conexion

v_peri_ccod = negocio.ObtenerPeriodoAcademico("POSTULACION")

consulta="select a.* ," & vbcrlf & _
         " case a.doma_entregado" & vbcrlf & _
         " when  0 then 'N'" & vbcrlf & _
         " else 'S'" & vbcrlf & _
         " end as bentregado," & vbcrlf & _
         " case a.fecha when null then '' else a.fecha end as fecha_entrega" & vbcrlf & _
         " from(select '"&v_pers_ncorr&"' as pers_ncorr,a.doma_ccod, isnull(b.doma_ccod,0) as doma_entregado, a.doma_tdesc," & vbcrlf & _
         " cast(datePart(day,b.audi_fmodificacion)as varchar)+'-'+cast(datePart(month,b.audi_fmodificacion)as varchar)+'-'+cast(datePart(year,b.audi_fmodificacion)as varchar) as fecha" & vbcrlf & _
         " from documentos_matricula a,documentos_postulantes b" & vbcrlf & _
         " where a.doma_ccod = b.doma_ccod " & vbcrlf & _
         " and cast(b.pers_ncorr as varchar)= '"&v_pers_ncorr&"')a "


v_pers_ncorr = conexion.consultauno("select pers_ncorr from personas_postulante where cast(pers_nrut as varchar)  = '"&q_pers_nrut&"'")		   

consulta = "select a.* ," & vbcrlf & _
" case a.doma_entregado" & vbcrlf & _
" when  0 then 'N'" & vbcrlf & _
"  else 'S'" & vbcrlf & _
"  end as bentregado" & vbcrlf & _
" from(select '"&v_pers_ncorr&"' as pers_ncorr,a.doma_ccod, isnull(b.doma_ccod,0) as doma_entregado," & vbcrlf & _
"  			protic.trunc(b.audi_fmodificacion) as fecha_entrega, a.doma_tdesc" & vbcrlf & _
" 			from documentos_matricula a,documentos_postulantes b" & vbcrlf & _
" 			where a.doma_ccod *= b.doma_ccod " & vbcrlf & _
" 			and cast(b.pers_ncorr as varchar)= '"&v_pers_ncorr&"' and isnull(entregado,'S')<>'N') a " 

'response.Write("<pre>"&consulta&"</pre>")		

f_documentos.Consultar consulta

if f_documentos.NroFilas = 0 then
	f_botonera.AgregaBotonParam "guardar", "deshabilitado", "TRUE"
end if

'--------------------------------------------------------------------------------------------------
set fc_datos = new CFormulario
fc_datos.Carga_Parametros "consulta.xml", "consulta"
fc_datos.Inicializar conexion
		   
consulta = "select protic.FORMAT_RUT(cast(a.pers_nrut as varchar)) as rut," & vbCrLf &_
			"         a.pers_tnombre + ' ' + a.pers_tape_paterno + ' ' + a.pers_tape_materno as nombre_completo " & vbCrLf &_
			"from personas_postulante a " & vbCrLf &_
			"where cast(a.pers_nrut as varchar) = '" & q_pers_nrut & "'"
		   
fc_datos.Consultar consulta
fc_datos.Siguiente

max_periodo_matricula = conexion.consultaUno("select max(peri_ccod) from alumnos a, ofertas_academicas b where a.ofer_ncorr=b.ofer_ncorr and a.emat_ccod=1 and cast(a.pers_ncorr as varchar)='"&v_pers_ncorr&"'")

if not esVacio(max_periodo_matricula) and max_periodo_matricula <> "" then
	cod_carrera = conexion.consultaUno("select carr_ccod from alumnos a, ofertas_academicas b,especialidades c where a.ofer_ncorr=b.ofer_ncorr and a.emat_ccod=1 and cast(a.pers_ncorr as varchar)='"&v_pers_ncorr&"' and cast(peri_ccod as varchar)='"&max_periodo_matricula&"' and b.espe_ccod = c.espe_ccod")
	carrera = conexion.consultaUno("select protic.initCap(carr_tdesc) from carreras where carr_ccod ='"&cod_carrera&"'")	
	ano_ingreso = conexion.consultaUno("select protic.ANO_INGRESO_CARRERA("&v_pers_ncorr&",'"&cod_carrera&"')")
	sede_ccod = conexion.consultaUno("select sede_ccod from alumnos a, ofertas_academicas b,especialidades c where a.ofer_ncorr=b.ofer_ncorr and a.emat_ccod=1 and cast(a.pers_ncorr as varchar)='"&v_pers_ncorr&"' and cast(peri_ccod as varchar)='"&max_periodo_matricula&"' and b.espe_ccod = c.espe_ccod and cast(c.carr_ccod as varchar)='"&cod_carrera&"'")
	sede = conexion.consultaUno("select protic.initCap(sede_tdesc) from sedes where sede_ccod ='"&sede_ccod&"'")	
	jornada = conexion.consultaUno("select case b.jorn_ccod when 1 then 'Diurna' else 'Vespertina' end from alumnos a, ofertas_academicas b,especialidades c where a.ofer_ncorr=b.ofer_ncorr and a.emat_ccod=1 and cast(a.pers_ncorr as varchar)='"&v_pers_ncorr&"' and cast(peri_ccod as varchar)='"&max_periodo_matricula&"' and b.espe_ccod = c.espe_ccod and cast(c.carr_ccod as varchar)='"&cod_carrera&"'")
end if
%>


<html>
<head>
<title><%=pagina.Titulo%></title>
<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1">
<link href="../estilos/estilos_inicial.css" rel="stylesheet" type="text/css">
<link href="../estilos/tabla.css" rel="stylesheet" type="text/css">
<style>
@media print{ .noprint {visibility:hidden; }}
</style>

<script language="JavaScript" src="../biblioteca/tabla.js"></script>
<script language="JavaScript" src="../biblioteca/funciones.js"></script>
<script language="JavaScript" src="../biblioteca/validadores.js"></script>

<script language="JavaScript">
function imprimir() {
  //alert("Enviando a imprimir....");
  window.print()
}

function salir(){
window.close();
}
function InicioPagina(formulario)
{

}
</script>

</head>
<body bgcolor="#ffffff" leftmargin="0" topmargin="0" marginwidth="0" marginheight="0" onLoad="MM_preloadImages('../imagenes/botones/buscar_f2.gif','../images/bot_deshabilitar_f2.gif','../images/agregar2_f2_p.gif','im&amp;#225;genes/marco1_r3_c2_f2.gif');MM_preloadImages('im&amp;#225;genes/marco1_r3_c4_f2.gif');MM_preloadImages('im&amp;#225;genes/marco1_r3_c6_f2.gif');MM_preloadImages('im&amp;#225;genes/marco1_r3_c8_f2.gif');MM_preloadImages('../imagenes/botones/cargar_f2.gif','../imagenes/botones/continuar_f2.gif')" onBlur="revisaVentana();">
<table width="500" height="50%" border="1" align="center" cellpadding="0" cellspacing="0">
  <tr>
    <td valign="top" bgcolor="#ffffff">
	<br>
	
	<table width="98%"  border="0" align="center" cellpadding="0" cellspacing="0" bgcolor="#ffffff">
      <tr>
        <td width="9">&nbsp;</td>
        <td><table width="100%"  border="0" cellspacing="0" cellpadding="0">
          <tr>
            <td><%pagina.DibujarLenguetas Array("Documentos Entregados"), 1 %></td>
          </tr>
          <tr>
            <td height="2"></td>
          </tr>
          <tr>
            <td><div align="center"><br>
              <%pagina.DibujarTituloPagina%><br>              
                </div>
				<br>				<br>
				<table width="98%"  border="0" align="center" cellpadding="0" cellspacing="0">
				<tr>
                  <td width="20%"><strong>R.U.T.</strong></td>
                  <td width="1%"><strong>:</strong></td>
                  <td width="79%"><%=fc_datos.ObtenerValor("rut")%></td>
                </tr>
                <tr>
                  <td width="20%"><strong>NOMBRE</strong></td>
                  <td width="1%"><strong>:</strong></td>
                  <td width="79%"><%=fc_datos.ObtenerValor("nombre_completo")%></td>
                </tr>
				<%if not esVacio(max_periodo_matricula) and max_periodo_matricula <> "" then%>
				<tr>
                  <td width="20%"><strong>CARRERA</strong></td>
                  <td width="1%"><strong>:</strong></td>
                  <td width="79%" ><%=carrera%></td>
                </tr>
				<tr>
                  <td width="20%"><strong>AÑO INGRESO</strong></td>
                  <td width="1%"><strong>:</strong></td>
                  <td width="79%"><%=ano_ingreso%></td>
                </tr>
                <tr>
                  <td width="20%"><strong>SEDE</strong></td>
                  <td width="1%"><strong>:</strong></td>
                  <td width="79%"><%=sede%></td>
                </tr>
				<tr>
                  <td width="20%"><strong>JORNADA</strong></td>
                  <td width="1%"><strong>:</strong></td>
                  <td width="79%"><%=jornada%></td>
                </tr>
				<%end if%>
				 <tr>
                  <td width="20%"><strong>Impresi&oacute;n</strong></td>
                  <td width="1%"><strong>:</strong></td>
                  <td width="79%"><%=fecha_01%></td>
                </tr>
              </table>
              <form name="edicion">
                <table width="98%"  border="0" align="center" cellpadding="0" cellspacing="0">
                  <tr>
                    <td colspan="2">
                          <%pagina.DibujarSubtitulo "Documentos"%>                          

                      <br><div align="center"><%f_documentos.DibujaTabla%></div></td>
                  </tr>
				  <tr>
				      <td colspan="2">
					<br>
					<br>
					<br>
					<br>
                      <table width="98%"  border="0" align="center" cellpadding="0" cellspacing="0">
                        <tr>
                          <td><div align="center"><strong>_______________</strong></div></td>
						  <td></td>
						  <td><div align="center"><strong>_______________</strong></div></td>
                        </tr>
						 <tr>
                          <td><div align="center">Alumno/Apoderado</div></td>
						  <td></td>
						  <td><div align="center">Registro Curricular</div></td>
                        </tr>
                      </table>
					  </td>
				  </tr>
				  <tr>
				  	<td>&nbsp; <br><br><br>
				  	</td>
				  </tr>
				  <tr  class="noprint">
                  <td width="8%"><div align="center">
                            <%f_botonera.DibujaBoton("salir2")%>
                          </div></td>
                  <td width="92%"><div align="left"> 
				            <%f_botonera.DibujaBoton ("imprimir")%>
				  </div></td>
                  </tr>
                </table>
                          <br>
            </form></td></tr>
        </table></td>
        <td width="7">&nbsp;</td>
      </tr>
     </table>
	<br>
	<br>
	</td>
  </tr>  
</table>
</body>
</html>
