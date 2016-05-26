<!-- #include file = "../biblioteca/_conexion.asp" -->

<!-- #include file = "../biblioteca/_negocio.asp" -->

<%
paie_ncorr =Request.QueryString("paie_ncorr")
pers_nrut=Request.QueryString("pers_nrut")
pers_ncorr=Request.QueryString("pers_ncorr")
pers_xdv=Request.QueryString("pers_xdv")
pais_ccod=Request.QueryString("pais_ccod")
ciex_ccod=Request.QueryString("ciex_ccod")
univ_ccod=Request.QueryString("univ_ccod")
peri_ccod=Request.QueryString("peri_ccod")
pers_tpasaporte=Request.QueryString("pers_tpasaporte")
 pais_tdesc=Request.QueryString("pais_tdesc")
 ciex_tdesc=Request.QueryString("ciex_tdesc")
 univ_tdesc=Request.QueryString("univ_tdesc")
 espi_ccod =Request.QueryString("espi_ccod")
'---------------------------------------------------------------------------------------------------
set errores = new CErrores

set pagina = new CPagina
pagina.Titulo = "Extension Intercambio Extranjero"


'---------------------------------------------------------------------------------------------------
set conexion = new CConexion
conexion.Inicializar "upacifico"

set negocio = new CNegocio
negocio.Inicializa conexion

'---------------------------------------------------------------------------------------------------
set pagina = new cPagina
'---------------------------------------------------------------------------------------------------
set f_botonera = new CFormulario
f_botonera.Carga_Parametros "extension_intercambio_extranjero.xml", "botonera"

set f_dato_alumno = new CFormulario
f_dato_alumno.Carga_Parametros "extension_intercambio_extranjero.xml", "datos"
f_dato_alumno.Inicializar conexion
sql_descuentos="select pers_tnombre+' '+pers_tape_paterno+' '+pers_tape_materno as nombre,peri_tdesc,c.peri_ccod,"& vbCrLf &_
 "pais_tdesc,"& vbCrLf &_
 "ciex_tdesc,"& vbCrLf &_
 "univ_tdesc"& vbCrLf &_
"from personas_postulante a,rrii_postulacion_alumnos_intercambio_extranjero c,universidad_ciudad d,universidades e,ciudades_extranjeras g, paises f,periodos_academicos h"& vbCrLf &_
"where a.PERS_NCORR=c.PERS_NCORR"& vbCrLf &_
"and c.unci_ncorr=d.unci_ncorr"& vbCrLf &_
"and d.univ_ccod=e.univ_ccod"& vbCrLf &_
"and d.ciex_ccod=g.ciex_ccod"& vbCrLf &_
"and g.pais_ccod=f.PAIS_CCOD"& vbCrLf &_
"and c.peri_ccod=h.peri_ccod"& vbCrLf &_
"and c.paie_ncorr="&paie_ncorr&""		
'response.Write("<pre>"&sql_descuentos&"</pre>")	
f_dato_alumno.Consultar sql_descuentos
f_dato_alumno.siguiente

tiene_documentacion= conexion.ConsultaUno("select count(*) from rrii_documentacion_intercambio_extranjero where paie_ncorr="&paie_ncorr&"")

'response.Write("<pre>tiene_documentacion==="&tiene_documentacion&"</pre>")
'tiene_documentacion="1"
set f_proceso = new CFormulario
f_proceso.Carga_Parametros "extension_intercambio_extranjero.xml", "muestra_proceso"
f_proceso.Inicializar conexion
if tiene_documentacion<>"0" then
sql_descuentos="select a.paie_ncorr,tdin_ccod,doie_ncorr,unci_ncorr,pers_ncorr,carr_ccod,espi_ccod,peri_ccod,peri_ccod_fin,protic.trunc(paie_finscripcion)as paie_finscripcion"& vbCrLf &_
"from rrii_postulacion_alumnos_intercambio_extranjero a,rrii_documentacion_intercambio_extranjero b"& vbCrLf &_
				"where a.paie_ncorr=b.paie_ncorr"& vbCrLf &_
				"and a.paie_ncorr="&paie_ncorr&""
else

sql_descuentos="select ''"

end if 									
'response.Write("<pre>"&sql_descuentos&"</pre>")
'response.Write("<pre>"&numero_total&"</pre>")
'response.Write("<pre>"&q_sfun_ccod&"</pre>")
'response.End()

f_proceso.Consultar sql_descuentos
f_proceso.siguiente

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
<script language="JavaScript" src="jquery-1.6.4.min.js"></script>
<script language="JavaScript">


var patron = new Array(2,2,4)
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

function MuestraPeri(){
	
tdin='<%=f_proceso.ObtenerValor("tdin_ccod")%>'	
	
	if (tdin!=''){
	 AgregaPeri(tdin)
	 document.proceso.elements['a[0][peri_ccod_fin]'].value='<%=f_proceso.ObtenerValor("peri_ccod_fin")%>'	 
	}
}

function AgregaPeri(valor){
   
    if ((valor=="1")||(valor=="2"))	{
		$("#td_p").css("display","none");  
	}
	else if ((valor=="3")||(valor=="4")){
		$("#td_p").css("display","inline");  
	}
}

function verifica_periodos(valor,nombre)
{
	//alert(valor+" nombre "+ nombre )
	if (nombre=='a[0][peri_ccod]'){		
		tdin =document.proceso.elements['a[0][tdin_ccod]'].value
		tdin=tdin*1
		
		if (tdin >2){
			valor_com=document.proceso.elements['a[0][peri_ccod_fin]'].value
			
			if((valor>=valor_com)&&(valor_com!='')){
				alert("No Puedes ser menor o igual el periodo de inicio al de fin")
			}
		}	
	}
	else if (nombre=='a[0][peri_ccod_fin]')
	{		
		valor_com=document.proceso.elements['a[0][peri_ccod]'].value
		
		if((valor<=valor_com)&&(valor_com!='')){
			alert("No Puedes ser menor o igual el periodo de inicio al de fin")
		}
	}
}



</script>
</head>
<body bgcolor="#CC6600" leftmargin="0" topmargin="0" marginwidth="0" marginheight="0" onLoad=MuestraPeri();>
<table width="750"  border="0" align="center" cellpadding="0" cellspacing="0">
  <tr>
    <td height="62" valign="top"><img src="../imagenes/vineta2_r1_c1.gif" width="750" height="62" border="0"></td>
  </tr>
  <%pagina.DibujarEncabezado()%>  
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
        <td width="9" background="../imagenes/izq.gif"></td>
        <td>
			<table width="100%"  border="0" cellspacing="0" cellpadding="0">
				  <tr>
					<td><%pagina.DibujarLenguetas Array("Datos Alumno"), 1 %></td>
				  </tr>
				  <tr>
					<td height="2" background="../imagenes/top_r3_c2.gif"></td>
				  </tr>
				  <tr>
					<td>
						 <form name="buscador">
						 <input type="hidden" name="buscar">
						 
						 
							<table align="center" width="100%">
								<tr>
									<td width="6%"><strong>Nombre</strong></td>
									<td width="94%"><%f_dato_alumno.DibujaCampo("nombre")%></td>
							  </tr>
							</table>
							<table align="center" width="100%">
								<tr>
									<td width="30%"><strong>Periodo Acad&eacute;mico Intercambio </strong></td>
							      <td width="70%"><%f_dato_alumno.DibujaCampo("peri_tdesc")%></td>
								</tr>
							</table>
							<table>
								<tr>
									<td width="5%"><strong>Pais</strong></td>
									<td width="17%"><%f_dato_alumno.DibujaCampo("pais_tdesc")%></td>
									<td width="11%" align="right"><strong>Ciudad</strong></td>
								    <td width="17%"><%f_dato_alumno.DibujaCampo("ciex_tdesc")%></td>
									<td width="11%"><strong>Universidad</strong></td>
								  <td width="39%"><%f_dato_alumno.DibujaCampo("univ_tdesc")%></td>
								</tr>
							</table>							
						 </form>
					</td>
				  </tr>
        	</table>
		</td>
        <td width="7" background="../imagenes/der.gif"></td>
      </tr>
      <tr>
        <td width="9" height="13"><img src="../imagenes/base1.gif" width="9" height="13"></td>
        <td height="13" background="../imagenes/base2.gif"></td>
        <td width="7" height="13"><img src="../imagenes/base3.gif" width="7" height="13"></td>
      </tr>
    </table>

	<br>
	<table width="90%"  border="0" align="center" cellpadding="0" cellspacing="0" bgcolor="#D8D8DE">
      <tr>
        <td width="9" height="8"><img name="top_r1_c1" src="../imagenes/top_r1_c1.gif" width="9" height="8" border="0" alt=""></td>
        <td height="8" background="../imagenes/top_r1_c2.gif"></td>
        <td width="7" height="8"><img name="top_r1_c3" src="../imagenes/top_r1_c3.gif" width="7" height="8" border="0" alt=""></td>
      </tr>
      <tr>
        <td width="9" background="../imagenes/izq.gif">&nbsp;</td>
        <td>
			<table width="100%"  border="0" cellspacing="0" cellpadding="0">
			  <tr>
				<td><%pagina.DibujarLenguetas Array("Documentación"), 1 %></td>
			  </tr>
			  <tr>
				<td height="2" background="../imagenes/top_r3_c2.gif"></td>
			  </tr>
			  <tr>
				<td><div align="center"><br>
				  <%pagina.DibujarTituloPagina%><br>
					</div>
						 <form name="proceso">
						 <input type="hidden" name="a[0][doie_ncorr]" value="<%=f_proceso.ObtenerValor("doie_ncorr")%>">
						  <input type="hidden" name="a[0][paie_ncorr]" value="<%=paie_ncorr%>">
						  <input type="hidden" name="peri_ccod" value="<%=peri_ccod%>">
						  <input type="hidden" name="pais_ccod" value="<%=pais_ccod%>">
						 <input type="hidden" name="ciex_ccod" value="<%=ciex_ccod%>">
						 <input type="hidden" name="univ_ccod" value="<%=univ_ccod%>">
						 <input type="hidden" name="pers_nrut" value="<%=pers_nrut%>">
						 <input type="hidden" name="pers_xdv" value="<%=pers_xdv%>">
						 <input type="hidden" name="pers_tpasaporte" value="<%=pers_tpasaporte%>">
							<table width="98%"  border="0" align="center" cellpadding="0" cellspacing="0">
							  <tr>
								<td><%pagina.DibujarSubtitulo "EXTENSION ALUMNOS EXTRANJEROS"%>
								  <table width="98%"  border="0" align="center">
                                    <tr>
                                      <td width="12%" align="left"><strong>Fecha Inscripción :</strong> </td>
                                      <td width="31%" valign="bottom"><%f_proceso.DibujaCampo("paie_finscripcion")%></td>
                                      <td width="13%" align="left"><strong>Duración Intercambio :</strong> </td>
                                      <td width="44%"><%f_proceso.DibujaCampo("tdin_ccod")%></td>
                                    </tr>
                                  </table>
                                  <table width="98%"  border="0" align="center">
                                    <td width="18%"><strong>Periodo Acad&eacute;mico Intercambio</strong></td>
								  <td width="82%"><table><tr><td><%f_proceso.DibujaCampo("peri_ccod")%></td><td><%f_proceso.DibujaCampo("peri_ccod_fin")%></td></tr></table></td>
                                  </table>
							 </tr>
						</table>
				  </form>
				</td>
			  </tr>
			</table>
		</td>
        <td width="7" background="../imagenes/der.gif">&nbsp;</td>
      </tr>
      <tr>
        <td width="9" height="28"><img src="../imagenes/abajo_r1_c1.gif" width="9" height="28"></td>
        <td height="28"><table width="100%" height="28"  border="0" cellpadding="0" cellspacing="0">
          <tr>
            <td width="20%" height="20"><div align="center">
              <table width="100%"  border="0" cellspacing="0" cellpadding="0">
                <tr>
                  <td><div align="center"><%f_botonera.AgregaBotonParam "volver", "url", "extension_alumnos_intercambio_extranjero.asp?buscar=&b%5B0%5D%5Bpers_nrut%5D="&rut&"&b%5B0%5D%5Bpers_xdv%5D="&pers_xdv&"&b%5B0%5D%5Bperi_ccod%5D="&peri_ccod&"&b%5B0%5D%5Bpais_ccod%5D="&pais_ccod&"&b%5B0%5D%5Bciex_ccod%5D="&ciex_ccod&"&b%5B0%5D%5Buniv_ccod%5D="&univ_ccod&"&b%5B0%5D%5Bpers_ncorr="&pers_ncorr&"&b%5B0%5D%5Bespi_ccod="&espi_ccod&""
				  							f_botonera.DibujaBoton("volver")%></div></td>
				  <td><div align="center"><%f_botonera.DibujaBoton("guardar_proceso")%></div></td>
                  </tr>
              </table>
             </td>
            <td width="80%" rowspan="2" background="../imagenes/abajo_r1_c4.gif"><img src="../imagenes/abajo_r1_c3.gif" width="12" height="28"></td>
            </tr>
          <tr>
            <td height="8" background="../imagenes/abajo_r2_c2.gif"></td>
          </tr>
        </table></td>
        <td width="7" height="28"><img src="../imagenes/abajo_r1_c5.gif" width="7" height="28"></td>
      </tr>
    </table>
	 <%buscar=""%>
	<br>
	</td>
  </tr>  
</table>
</body>
</html>