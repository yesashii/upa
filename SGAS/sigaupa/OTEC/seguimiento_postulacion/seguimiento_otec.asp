<!-- #include file = "../biblioteca/_conexion.asp" -->
<!-- #include file = "../biblioteca/_negocio.asp" -->

<%
pers_nrut = request.querystring("b[0][pers_nrut]")
pers_xdv = request.querystring("b[0][pers_xdv]")

'response.Write("detalle "&detalle)
'response.Write("../mantenedores/m_modulos.asp?mote_tdesc="&mote_tdesc&"&mote_ccod="&mote_ccod)
set pagina = new CPagina
pagina.Titulo = "Seguimiento de Postulaciones a Programas OTEC"


set botonera =  new CFormulario
botonera.carga_parametros "seguimiento_otec.xml", "botonera"


'---------------------------------------------------------------------------------------------------
set conexion = new CConexion
conexion.Inicializar "upacifico"

set negocio = new CNegocio
negocio.Inicializa conexion

set errores 	= new cErrores


usu=negocio.ObtenerUsuario()
'response.Write(carr_ccod)

'----------------------------------------------------------------------- 
 set f_busqueda = new CFormulario
 f_busqueda.Carga_Parametros "seguimiento_otec.xml", "f_busqueda_persona"
 f_busqueda.Inicializar conexion

 consulta =  "select ''"
 
 f_busqueda.consultar  consulta
 f_busqueda.Siguiente
 f_busqueda.agregaCampoCons "pers_nrut",pers_nrut
 f_busqueda.agregaCampoCons "pers_xdv",pers_xdv
'---------------------------------------------------------------------------------------------------
set listado_postulaciones = new cformulario
listado_postulaciones.carga_parametros "seguimiento_otec.xml", "f_listado_postulantes"
listado_postulaciones.inicializar conexion

if pers_nrut<>"" and pers_xdv<>"" then
filtro=filtro&"and a.pers_ncorr=protic.Obtener_pers_ncorr("&pers_nrut&")"
end if


consulta= "select a.PERS_NCORR,cast(a.pers_nrut as varchar)+'-'+a.pers_xdv as rut,a.pers_nrut,a.pers_xdv," & vbCrlf & _ 
 "pers_tnombre +' '+ pers_tape_paterno + ' ' + pers_tape_materno as alumno, " & vbCrlf & _
 "protic.trunc((select min(fecha_postulacion) from postulacion_otec zz, ofertas_otec yy where zz.dgso_ncorr=yy.dgso_ncorr and zz.pers_ncorr=a.PERS_NCORR and yy.anio_admision=datepart(yyyy,getdate())))as fecha_ingreso," & vbCrlf & _
 "(select count( distinct aa.dgso_ncorr) from postulacion_otec aa,ofertas_otec bb,ofertas_otec cc,responsable_unidad dd,responsable_programa ee  where aa.dgso_ncorr=bb.dgso_ncorr and bb.anio_admision=datepart(yyyy,getdate()) and aa.pers_ncorr=a.pers_ncorr and aa.epot_ccod<>5 and aa.dgso_ncorr=bb.dgso_ncorr and dd.udpo_ccod=bb.udpo_ccod and dd.reun_ncorr=ee.reun_ncorr and aa.dgso_ncorr=ee.dgso_ncorr and dd.pers_ncorr=protic.obtener_pers_ncorr("&usu&"))as n_programas," & vbCrlf & _
"(select case when count(*)> 0 then 'Si' else 'No' end  from observaciones_postulacion_otec aa, ofertas_otec bb,responsable_unidad cc,responsable_programa dd where aa.dgso_ncorr=bb.dgso_ncorr and bb.udpo_ccod=cc.udpo_ccod and cc.reun_ncorr=dd.reun_ncorr and dd.dgso_ncorr=aa.dgso_ncorr and cc.pers_ncorr=protic.Obtener_pers_ncorr("&usu&") and aa.pote_ncorr=b.pote_ncorr)as gestionado,"& vbCrlf & _
"(select protic.trunc(max(aa.audi_fmodificacion))  from observaciones_postulacion_otec aa, ofertas_otec bb,responsable_unidad cc,responsable_programa dd where aa.dgso_ncorr=bb.dgso_ncorr and bb.udpo_ccod=cc.udpo_ccod and cc.reun_ncorr=dd.reun_ncorr and dd.dgso_ncorr=aa.dgso_ncorr and cc.pers_ncorr=protic.Obtener_pers_ncorr("&usu&")and aa.pote_ncorr=b.pote_ncorr)as ultima_gestion"& vbCrlf & _
 "from personas a, " & vbCrlf & _
 "postulacion_otec b," & vbCrlf & _
 "estados_postulacion_otec c," & vbCrlf & _
 "ofertas_otec d," & vbCrlf & _
 "responsable_unidad e," & vbCrlf & _
 "responsable_programa f" & vbCrlf & _
 "where a.pers_ncorr=b.pers_ncorr " & vbCrlf & _
 "and b.epot_ccod=c.epot_ccod " & vbCrlf & _
 "and b.dgso_ncorr=d.dgso_ncorr" & vbCrlf & _
 "and d.udpo_ccod=e.udpo_ccod" & vbCrlf & _
 "and e.reun_ncorr=f.reun_ncorr" & vbCrlf & _
 "and b.dgso_ncorr=f.dgso_ncorr" & vbCrlf & _
 "and e.esre_ccod=1" & vbCrlf & _
 "and b.epot_ccod<>5" & vbCrlf & _
 ""&filtro&""& vbCrlf & _
 "and e.pers_ncorr=protic.Obtener_pers_ncorr("&usu&")" & vbCrlf & _
 "group by a.pers_nrut,a.pers_xdv,pers_tnombre,pers_tape_paterno,pers_tape_materno,a.PERS_NCORR,b.pote_ncorr"& vbCrlf & _
 "order by fecha_ingreso asc"

'response.write("<pre>"&consulta&"</pre>")

listado_postulaciones.consultar consulta 
'listado_postulaciones.siguiente
'response.End()
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
function Validar_rut()
{
//alert(rut_)
	formulario = document.buscador;
	rut=formulario.elements['b[0][pers_nrut]'].value;
	dv=formulario.elements['b[0][pers_xdv]'].value;
		dv=dv.toUpperCase()
	rut_alumno = rut + "-" + dv;
	if (formulario.elements['b[0][pers_nrut]'].value  != ''){
	  	  if (!valida_rut(rut_alumno)) {
		  alert("Ingrese un RUT válido");
		  
		formulario.elements['b[0][pers_nrut]'].focus;
	 	formulario.elements['b[0][pers_nrut]'].select();
		return false;
	  }
	 else
	 {
	 	return true;
	 }
	}
	
} 


function buscar()
{
valor=Validar_rut()
	
 if (valor==true)
   {
   	formulario = document.buscador;
	formulario.method = "get";
	formulario.submit();
	}
}

function listar()
{
location.href='seguimiento_otec.asp'

}
</script>

</head>
<body bgcolor="#EAEAEA" leftmargin="0" topmargin="0" marginwidth="0" marginheight="0" onLoad="MM_preloadImages('../imagenes/botones/buscar_f2.gif','../images/bot_deshabilitar_f2.gif','../images/agregar2_f2_p.gif','im&amp;#225;genes/marco1_r3_c2_f2.gif');MM_preloadImages('im&amp;#225;genes/marco1_r3_c4_f2.gif');MM_preloadImages('im&amp;#225;genes/marco1_r3_c6_f2.gif');MM_preloadImages('im&amp;#225;genes/marco1_r3_c8_f2.gif');MM_preloadImages('../imagenes/botones/cargar_f2.gif','../imagenes/botones/continuar_f2.gif')" onBlur="revisaVentana();">
<table width="700" height="100%">
<tr valign="top" height="30">
	<td bgcolor="#EAEAEA">
</td>
</tr>
<tr valign="top">
	<td bgcolor="#EAEAEA">
<table width="700" border="0" align="center" cellpadding="0" cellspacing="0">
  <tr>
    <td valign="top" bgcolor="#EAEAEA" align="center">
	<table width="90%">
	<tr>
		<td align="center">
	
	<table width="55%"  border="0" align="center" cellpadding="0" cellspacing="0" bgcolor="#D8D8DE">
      <tr>
        <td width="9" height="8"><img name="top_r1_c1" src="../imagenes/top_r1_c1.gif" width="9" height="8" border="0" alt=""></td>
        <td height="8" background="../imagenes/top_r1_c2.gif"></td>
        <td width="7" height="8"><img name="top_r1_c3" src="../imagenes/top_r1_c3.gif" width="7" height="8" border="0" alt=""></td>
      </tr>
      <tr>
        <td width="9" background="../imagenes/izq.gif"></td>
        <td><table width="100%"  border="0" cellspacing="0" cellpadding="0">
          <tr>
            <td><%pagina.DibujarLenguetas Array("Buscador"), 1 %></td>
          </tr>
          <tr>
            <td height="2" background="../imagenes/top_r3_c2.gif"></td>
          </tr>
          <tr>
            <td align="left"><form name="buscador">
              <br>
              <table width="98%"  border="0" align="center">
                <tr>
                    <td width="37%" align="right"><strong>Rut :</strong>
                      <%f_busqueda.Dibujacampo("pers_nrut")%></td>
					<td width="5%"><strong>-</strong></td>
                    <td width="58%"><%f_busqueda.Dibujacampo("pers_xdv")%></td>
                 </tr>
				  
				 <tr> 
				  <td colspan="3">
				  				<table width="100%">
				                      <tr>
									  	<td width="61%" align="center"><%botonera.dibujaboton "todos"%></td>
										<td width="39%" align="right"><%botonera.dibujaboton "buscar"%></td>
									  </tr>
				                  </table>
			       </td>
                </tr>
              </table>
            </form></td>
          </tr>
        </table></td>
        <td width="7" background="../imagenes/der.gif"></td>
      </tr>
      <tr>
        <td width="9" height="13"><img src="../imagenes/base1.gif" width="9" height="13"></td>
        <td height="13" background="../imagenes/base2.gif"></td>
        <td width="7" height="13"><img src="../imagenes/base3.gif" width="7" height="13"></td>
      </tr>
    </table>
	</td>
	</tr>
	</table>
	</td></tr>
	
	
	<tr>
    <td valign="top" bgcolor="#EAEAEA" align="left">&nbsp;</td></tr>
	<tr>
    <td valign="top" bgcolor="#EAEAEA" align="left">
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
            <td><%pagina.DibujarLenguetas Array("Listado Postulantes"), 1 %></td>
          </tr>
          <tr>
            <td height="2" background="../imagenes/top_r3_c2.gif"></td>
          </tr>
          <tr>
            <td><form name="edicion">
                <table width="95%"  border="0" align="center" cellpadding="0" cellspacing="0">
                  <tr>
                    <td>                        <div align="center"><%pagina.DibujarTituloPagina%> <br>
                    </div></td>
                    </tr>
                  
                  <tr>
                    <td>&nbsp;</td>
                  </tr>
				  <tr>
				  	<td>&nbsp;</td>
				  </tr>
				  <tr>
					  <td><div align="right"><strong>P&aacute;ginas :</strong>                          
						  <%listado_postulaciones.accesopagina%></div>
					   </td>
				  </tr>
				  <tr>
					  <td>&nbsp;</td>
				  </tr>
				  <tr>
					  <td colspan="2"><div align="center">
									  <%listado_postulaciones.dibujatabla()%>
					  </div></td>
				  </tr>
				  <tr>
					  <td>&nbsp;</td>
				  </tr>
				  <tr>
				  	<td align="right"><%' url_excel = "seguimiento_otec_excel.asp?b[0][dcur_ncorr]="&dcur_ncorr&"&b[0][sede_ccod]="&sede_ccod&"&b[0][epot_ccod]="&epot_ccod&"&b[0][f_inicio]="&f_inicio&"&b[0][f_termino]="&f_termino
					                     'botonera.agregaBotonParam "excel","url",url_excel
										 'botonera.dibujaBoton "excel"%></td>
				  </tr>
				   <tr>
                    <td>&nbsp;</td>
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
				  <td align="center"><%
				  botonera.AgregaBotonParam "excel", "url", "seguimiento_otec_excel.asp?pers_nrut="&pers_nrut&" "
				  botonera.DibujaBoton("excel")%></td>
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
	</td>
  </tr>  
</table>
</td>
</tr>
</table>
</body>
</html>
