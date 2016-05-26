<!-- #include file = "../biblioteca/_conexion.asp" -->
<!-- #include file = "../biblioteca/_negocio.asp" -->

<%
q_pers_nrut =Request.QueryString("a[0][pers_nrut]")
q_pers_xdv = Request.QueryString("a[0][pers_xdv]")
q_tasi_ncorr= request.QueryString("a[0][tasi_ncorr]")
q_sede_ccod= request.QueryString("a[0][sede_ccod]")
q_peri_ccod= request.QueryString("a[0][peri_ccod]")
q_carr_ccod= request.QueryString("a[0][carr_ccod]")
q_fecha= request.QueryString("a[0][fecha]")
'---------------------------------------------------------------------------------------------------

set errores= new CErrores

set conexion = new CConexion
conexion.Inicializar "upacifico"

set negocio = new CNegocio
negocio.Inicializa conexion

'---------------------------------------------------------------------------------------------------
set pagina = new cPagina
set botonera = new CFormulario
botonera.carga_parametros "crea_modulos_sicologos.xml", "botonera"
'---------------------------------------------------------------------------------------------------
set f_botonera = new CFormulario
f_botonera.Carga_Parametros "crea_modulos_sicologos.xml", "botonera"

'---------------------------------------------------------------------------------------------------

'---------------------------------------------------------------------------------------------------
set f_cheques = new CFormulario
f_cheques.Carga_Parametros "crea_modulos_sicologos.xml", "crea"
f_cheques.Inicializar conexion


sql_descuentos= "select ''"




					
'response.Write("<pre>"&sql_descuentos&"</pre>")
'response.Write("<pre>"&numero_total&"</pre>")
'response.Write("<pre>"&q_sfun_ccod&"</pre>")
'response.End()

f_cheques.Consultar sql_descuentos
f_cheques.Siguiente
 usu=negocio.obtenerUsuario
 
 set f_sedes_sicologos = new CFormulario
f_sedes_sicologos.Carga_Parametros "crea_modulos_sicologos.xml", "sede_sicologos"
f_sedes_sicologos.Inicializar conexion


sql_descuentos= "select c.sede_ccod,sede_tdesc "& vbcrlf & _
 "from sicologos a,"& vbcrlf & _
 "sicologos_sede b,"& vbcrlf & _
 "sedes c"& vbcrlf & _
"where a.sico_ncorr=b.sico_ncorr"& vbcrlf & _
"and b.sede_ccod=c.SEDE_CCOD"& vbcrlf & _
"and a.pers_ncorr=protic.obtener_pers_ncorr("&usu&") order by c.sede_ccod"

f_sedes_sicologos.Consultar sql_descuentos
'response.Write(sql_descuentos)
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
var patron = new Array(2,2)
function mascara(d,sep,pat,nums){
if(d.valant != d.value){
	val = d.value
	largo = val.length
	val = val.split(sep)
	val2 = ''
	for(r=0;r<val.length;r++){
		val2 += val[r]	
	}
	if(nums){
		for(z=0;z<val2.length;z++){
			if(isNaN(val2.charAt(z))){
				letra = new RegExp(val2.charAt(z),"g")
				val2 = val2.replace(letra,"")
			}
		}
	}
	val = ''
	val3 = new Array()
	for(s=0; s<pat.length; s++){
		val3[s] = val2.substring(0,pat[s])
		val2 = val2.substr(pat[s])
	}
	for(q=0;q<val3.length; q++){
		if(q ==0){
			val = val3[q]
		}
		else{
			if(val3[q] != ""){
				val += sep + val3[q]
				}
		}
	}
	d.value = val
	d.valant = val
	}
}
function Eshora()
{

hora_ingresada1=document.edicion.elements['a[0][hora_ini]'].value
hora_ingresada2=document.edicion.elements['a[0][hora_fin]'].value


var a_hora_1 = hora_ingresada1.split(':');
var a_hora_2 = hora_ingresada2.split(':');
var hora1 = a_hora_1[0];
var minuto1 = a_hora_1[1];
var hora2 = a_hora_2[0];
var minuto2 = a_hora_2[1];

	if ((hora1>=0)&&(hora1<24)&&(minuto1>=0)&&(minuto1<60))
	{
		
	}
	else
	{	
		
		alert('la hora no es válida'); 
		document.edicion.elements['a[0][hora_ini]'].focus();
		document.edicion.elements['a[0][hora_ini]'].select();
		return false
	}
		if ((hora2>=0)&&(hora2<24)&&(minuto2>=0)&&(minuto2<60))
	{
		
	}
	else
	{	
		
		alert('la hora no es válida'); 
		document.edicion.elements['a[0][hora_fin]'].focus();
		document.edicion.elements['a[0][hora_fin]'].select();
		return false
	}
	
	hora_1_=new Date('01','01','2010',hora1,minuto1)
	
	hora_2_=new Date('01','01','2010',hora2,minuto2)
	//alert('hora incio='+hora_1_+' la hora de termino'+hora_2_)
	
	if (hora_1_>hora_2_)
	{
		alert('La hora de Incio no puede ser mayor a la de Termino')
		return false
	}
	
	return true
}



</script>

</head>
<body bgcolor="#CC6600" leftmargin="0" topmargin="0" marginwidth="0" marginheight="0" onLoad="MM_preloadImages('../imagenes/botones/buscar_f2.gif','../images/bot_deshabilitar_f2.gif','../images/agregar2_f2_p.gif','im&amp;#225;genes/marco1_r3_c2_f2.gif');MM_preloadImages('im&amp;#225;genes/marco1_r3_c4_f2.gif');MM_preloadImages('im&amp;#225;genes/marco1_r3_c6_f2.gif');MM_preloadImages('im&amp;#225;genes/marco1_r3_c8_f2.gif');MM_preloadImages('../imagenes/botones/cargar_f2.gif','../imagenes/botones/continuar_f2.gif')" onBlur="revisaVentana();">
<form name="edicion">
<table width="750" height="100%" border="0" align="center" cellpadding="0" cellspacing="0">
  <tr>
    <td height="62" valign="top"><img src="../imagenes/vineta2_r1_c1.gif" width="750" height="62" border="0"></td>
  </tr>
  <%pagina.DibujarEncabezado()%>  
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
            <td height="2" background="../imagenes/top_r3_c2.gif"></td>
          </tr>
		  <tr>
		  <td><div align="center">
                    <br>
                    <table width="100%" border="0">
                     
                    </table>
					</tr>
          <tr>
            <td>
				
              
                <table width="98%"  border="0" align="center" cellpadding="0" cellspacing="0">
                  <tr>
                    <td width="50%">
						  <table width="75%"  border="0" align="center">
								 <tr>						
								   <td width="20%"><span class="Estilo2"></span><strong>Periodo Académico</strong><br><%f_cheques.DibujaCampo("peri_ccod")%></td>
												
								   <td width="20%"><span class="Estilo2"></span><strong>Sede</strong><br>  
									   <select name='a[0][sede_ccod]'  id='NU-N' >
										<option value=''>Seleccione una Sede</option>
										<%while f_sedes_sicologos.Siguiente%>
										<option value='<%=f_sedes_sicologos.Obtenervalor("sede_ccod")%>' ><%=f_sedes_sicologos.Obtenervalor("sede_tdesc")%></option>
										<%wend%>
										</select>
									</td>
								  </tr>
							</table>
						   <table width="75%" align="center">
								   <tr>
									  <td width="33%" align="up"><span class="Estilo2"></span><strong> Hora Inicio del Bloque </strong><br>
									    <%f_cheques.DibujaCampo("hora_ini")%> ej. 08:00</td>
									   <td width="33%" align="up"><span class="Estilo2"></span><strong> Hora Termino del Bloque </strong><br>
									     <%f_cheques.DibujaCampo("hora_fin")%> ej. 18:00</td>
										<td width="34%" align="up"><span class="Estilo2"></span><strong> Duración del Bloque </strong><br>
									     <%f_cheques.DibujaCampo("intervalo")%>Minutos ej. 45</td>
								   </tr>
						  </table>
				   </td>
                  </tr>
                </table>
                          <br>
           </td></tr>
        </table></td>
        <td width="7" background="../imagenes/der.gif">&nbsp;</td>
      </tr>
      <tr>
        <td width="9" height="28"><img src="../imagenes/abajo_r1_c1.gif" width="9" height="28"></td>
        <td height="28"><table width="100%" height="28"  border="0" cellpadding="0" cellspacing="0">
          <tr>
            <td width="31%" height="20"><div align="center">
              <table width="90%"  border="0" cellspacing="0" cellpadding="0">
                <tr>
				
                  <td><div align="center"><%f_botonera.DibujaBoton"siguiente"%></div></td>
				  
							 
                  <td><div align="center"><%f_botonera.DibujaBoton("salir")%></div></td>
				  
				  
				 
                  </tr>
              </table>
            </div></td>
            <td width="69%" rowspan="2" background="../imagenes/abajo_r1_c4.gif"><img src="../imagenes/abajo_r1_c3.gif" width="12" height="28"></td>
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
</table> </form>
</body>
</html>