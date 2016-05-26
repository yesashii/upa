<!-- #include file = "../biblioteca/_conexion.asp" -->

<!-- #include file = "../biblioteca/_negocio.asp" -->

<%
pers_nrut=Request.QueryString("a[0][pers_nrut]")
pers_xdv=Request.QueryString("a[0][pers_xdv]")
peri_ccod=Request.QueryString("a[0][peri_ccod_busqueda]")
'---------------------------------------------------------------------------------------------------
set errores = new CErrores

set pagina = new CPagina
pagina.Titulo = "Convenios Internacionales"


'---------------------------------------------------------------------------------------------------
set conexion = new CConexion
conexion.Inicializar "upacifico"

set negocio = new CNegocio
negocio.Inicializa conexion

'---------------------------------------------------------------------------------------------------
set pagina = new cPagina
'---------------------------------------------------------------------------------------------------
set f_botonera = new CFormulario
f_botonera.Carga_Parametros "alumnos_intercambio_upa.xml", "botonera"

set f_dato_alumno = new CFormulario
f_dato_alumno.Carga_Parametros "alumnos_intercambio_upa.xml", "postulacion"
f_dato_alumno.Inicializar conexion



if ((pers_nrut<>"") and (peri_ccod<>"")) then

consulta_tiene_matricula="select case count(*) when 0 then 'N' else 'S' end tiene_matricula from personas a,alumnos b,ofertas_academicas c"& vbCrLf &_
"where a.pers_ncorr=b.pers_ncorr"& vbCrLf &_
"and b.ofer_ncorr=c.ofer_ncorr"& vbCrLf &_
"and peri_ccod="&peri_ccod&""& vbCrLf &_
"and pers_nrut="&pers_nrut&""& vbCrLf &_
"and emat_ccod=1"
existe=conexion.ConsultaUno(consulta_tiene_matricula)


	sql_descuentos="select dtil_ccod,e.paiu_ncorr,a.pers_ncorr,pers_tnombre,pers_tape_paterno,tdin_ccod,pers_tfono,pers_tcelular,pers_tape_materno,carr_tdesc"& vbCrLf &_
	",protic.obtener_direccion (a.pers_ncorr,1,'CNPB')as direccion,peri_ccod_fin,"& vbCrLf &_
	"cpiu_tnombre, pare_ccod, cpiu_tfono, cpiu_tfax, cpiu_temail, cpiu_tdireccion,nidi_ccod, idio_ccod,case when protic.ES_MOROSO (a.pers_ncorr,getdate())= 'S' then 'SI' else 'NO' end as es_moroso,"& vbCrLf &_
	"protic.trunc(paiu_fvuelta_upa)as paiu_fvuelta_upa,paiu_temail,e.anos_ccod,h.unci_ncorr,i.ciex_ccod,univ_ccod,j.pais_ccod,e.peri_ccod,idio_ccod,nidi_ccod"& vbCrLf &_
	"from personas a"& vbCrLf &_
	"join alumnos b"& vbCrLf &_
	"on a.pers_ncorr=b.pers_ncorr"& vbCrLf &_
	"join ofertas_academicas c"& vbCrLf &_
	"on b.ofer_ncorr=c.ofer_ncorr"& vbCrLf &_
	"join especialidades d"& vbCrLf &_
	"on c.espe_ccod=d.espe_ccod"& vbCrLf &_
	"join carreras k"& vbCrLf &_
	"on d.carr_ccod=k.carr_ccod"& vbCrLf &_
	"left outer join rrii_postulacion_alumnos_intercambio_upa e"& vbCrLf &_
	"on a.pers_ncorr=e.pers_ncorr"& vbCrLf &_
	"left outer join rrii_contacto_postulacion_intermcambio_upa f"& vbCrLf &_
	"on e.paiu_ncorr=f.paiu_ncorr"& vbCrLf &_
	"left outer join rrii_idiomas_postulante_intercambio_upa g"& vbCrLf &_
	"on e.paiu_ncorr=g.paiu_ncorr"& vbCrLf &_
	"left outer join universidad_ciudad h"& vbCrLf &_
	"on e.unci_ncorr=h.unci_ncorr"& vbCrLf &_
	"left outer join ciudades_extranjeras i"& vbCrLf &_
	"on h.ciex_ccod=i.ciex_ccod"& vbCrLf &_
	"left outer join paises j"& vbCrLf &_
	"on i.pais_ccod=j.pais_ccod "& vbCrLf &_
	"where c.peri_ccod="&peri_ccod&""& vbCrLf &_
	"and emat_ccod=1"& vbCrLf &_
	"and a.pers_nrut="&pers_nrut&""
else
sql_descuentos="select ''"	
end if	

'response.Write(sql_descuentos)		
f_dato_alumno.Consultar sql_descuentos
f_dato_alumno.siguiente
f_dato_alumno.AgregaCampoCons "pers_nrut",pers_nrut
f_dato_alumno.AgregaCampoCons "pers_xdv",pers_xdv
f_dato_alumno.AgregaCampoCons "peri_ccod_busqueda",peri_ccod

set f_univ_convenios = new CFormulario
f_univ_convenios.Carga_Parametros "alumnos_intercambio_upa.xml", "universidades_convenio"
f_univ_convenios.Inicializar conexion
sql_descuentos="select a.pais_ccod,pais_tdesc,b.ciex_ccod,ciex_tdesc,c.univ_ccod,univ_tdesc"& vbcrlf & _
				"from paises a,"& vbcrlf & _
				"ciudades_extranjeras b,"& vbcrlf & _
				"universidad_ciudad c,"& vbcrlf & _
				"universidades d"& vbcrlf & _
				"where a.pais_ccod=b.pais_ccod"& vbcrlf & _
				"and b.ciex_ccod=c.ciex_ccod"& vbcrlf & _
				"and c.univ_ccod=d.univ_ccod"& vbcrlf & _
				"order by pais_tdesc,ciex_tdesc,univ_tdesc"				
f_univ_convenios.Consultar sql_descuentos
f_univ_convenios.inicializaListaDependiente "lBusqueda", sql_descuentos
f_univ_convenios.siguiente


f_univ_convenios.AgregaCampoCons "pais_ccod",f_dato_alumno.ObtenerValor("pais_ccod")
f_univ_convenios.AgregaCampoCons "ciex_ccod",f_dato_alumno.ObtenerValor("ciex_ccod")
f_univ_convenios.AgregaCampoCons "univ_ccod",f_dato_alumno.ObtenerValor("univ_ccod")
%>

<html>
<head>
<title><%=pagina.Titulo%></title>
<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1">
<link href="../estilos/estilos.css" rel="stylesheet" type="text/css">
<link href="../estilos/tabla.css" rel="stylesheet" type="text/css">
<% f_univ_convenios.generaJS %>
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

function MuestraPeri()
{
	
tdin='<%=f_dato_alumno.ObtenerValor("tdin_ccod")%>'	
	
	if (tdin!=''){
	 AgregaPeri(tdin)
	 document.postulacion.elements['a[0][peri_ccod_fin]'].value='<%=f_dato_alumno.ObtenerValor("peri_ccod_fin")%>'
	 
	}
}

function bloqueacombo()
{
	asd = document.postulacion.elements['a[0][idio_ccod]'].value;

	if (asd == 9){
		
		document.postulacion.elements['a[0][nidi_ccod]'].disabled  = true;
			
	}else{
	
		document.postulacion.elements['a[0][nidi_ccod]'].disabled  = false;
		
	}
}


function AgregaPeri(valor)
{
   //alert(valor)
    if ((valor=="1")||(valor=="2"))
	{
		$("#td_p").css("display","none");  
	}
	else if ((valor=="3")||(valor=="4"))
	{
		$("#td_p").css("display","inline");  
	}
}

function verifica_periodos(valor,nombre)
{

//alert("valor "+valor+" nombre "+nombre)
var nombre_comp

	if (nombre=='a[0][peri_ccod]')
	{
		
		tdin =document.postulacion.elements['a[0][tdin_ccod]'].value
		tdin=tdin*1
		//alert(tdin)
		if (tdin >2)
		{
			nombre_comp='a[0][peri_ccod_fin]'
			valor_com=document.postulacion.elements[nombre_comp].value
			
			if((valor>valor_com)&&(valor_com!=''))
			{
				alert("No Puedes ser menor el periodo de inicio al de fin")
			}
		}
		
		
		//if() 
		
		//document.postulacion.elements[nombre_comp].value=valor
	
	}
	else if (nombre=='a[0][peri_ccod_fin]')
	{
		
		nombre_comp='a[0][peri_ccod]'
		valor_com=document.postulacion.elements[nombre_comp].value
		
		if((valor<valor_com)&&(valor_com!=''))
		{
			alert("No Puedes ser menor el periodo de inicio al de fin")
		}
	}
	
	

}




</script>
</head>
<body bgcolor="#CC6600" leftmargin="0" topmargin="0" marginwidth="0" marginheight="0" onLoad="MM_preloadImages('../imagenes/botones/buscar_f2.gif','../images/bot_deshabilitar_f2.gif','../images/agregar2_f2_p.gif','im&amp;#225;genes/marco1_r3_c2_f2.gif');MM_preloadImages('im&amp;#225;genes/marco1_r3_c4_f2.gif');MM_preloadImages('im&amp;#225;genes/marco1_r3_c6_f2.gif');MM_preloadImages('im&amp;#225;genes/marco1_r3_c8_f2.gif');MM_preloadImages('../imagenes/botones/cargar_f2.gif','../imagenes/botones/continuar_f2.gif');MuestraPeri();bloqueacombo();" onBlur="revisaVentana();">
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
							<table align="center" width="100%">
								<tr>
									<td width="4%"><strong>Rut</strong></td>
									<td width="26%"><%f_dato_alumno.DibujaCampo("pers_nrut")%>-<%f_dato_alumno.DibujaCampo("pers_xdv")%><%pagina.DibujarBuscaPersonas "a[0][pers_nrut]", "a[0][pers_xdv]"%></td>
									<td width="19%"><strong>Periodo Academica</strong></td>
								  <td width="51%" colspan="4"><%f_dato_alumno.DibujaCampo("peri_ccod_busqueda")%></td>
							  </tr>
							  <tr>
							  		<td colspan="4"><%f_botonera.DibujaBoton("buscar")%></td>
							  </tr>
							</table>
							</form>
				<%if(existe="S") then%>
						<form name="postulacion">
						 <input type="hidden" name='a[0][pers_ncorr]' value="<%=f_dato_alumno.ObtenerValor("pers_ncorr")%>">
						 <input type="hidden" name="a[0][paiu_ncorr]" value="<%=f_dato_alumno.ObtenerValor("paiu_ncorr")%>"/>
							<br>
							<table width="100%">
								<tr>
									<td width="10%"><strong>Nombre:</strong></td>
								  <td width="17%"><%f_dato_alumno.DibujaCampo("pers_tnombre")%></td>
								
									<td width="10%"><strong>Apellido Paterno:</strong></td>
								  <td width="24%"><%f_dato_alumno.DibujaCampo("pers_tape_paterno")%></td>
								
									<td width="17%"><strong>Apellido materno:</strong></td>
								  <td width="22%"><%f_dato_alumno.DibujaCampo("pers_tape_materno")%></td>
								</tr>
								<tr>
									<td width="10%"><strong>Es Moroso:</strong></td>
								  <td width="17%" colspan="5"><%f_dato_alumno.DibujaCampo("es_moroso")%></td>
								</tr>
								<tr>
								  <td width="10%"><strong>Pasaporte:</strong></td>
								  <td width="17%"><%f_dato_alumno.DibujaCampo("pers_tpasaporte")%></td>
								  <td width="10%"><strong>Direccion:</strong></td>
								  <td colspan="4"><%f_dato_alumno.DibujaCampo("direccion")%></td>
								</tr>
								<tr>
								  <td width="10%"><strong>Telefono:</strong></td>
								  <td width="17%"><%f_dato_alumno.DibujaCampo("pers_tfono")%></td>
								  <td width="10%"><strong>Celular:</strong></td>
								  <td colspan="4"><%f_dato_alumno.DibujaCampo("pers_tcelular")%></td>
								</tr>
								<tr>
								  <td><strong>Email Personal:</strong></td>
								  <td colspan="5"><%f_dato_alumno.DibujaCampo("paiu_temail")%></td>
								</tr>
							</table>
							<table width="100%">
								<tr>
									<td width="12%"><strong>Carrera UPA</strong></td>
									<td width="88%" colspan="4"><%f_dato_alumno.DibujaCampo("carr_tdesc")%></td>
									
								</tr>
							</table>
							<table align="center" width="100%">
								<tr>
								  <td width="18%"><strong>Duración Intercambio </strong></td>
								  <td width="82%"><%f_dato_alumno.DibujaCampo("tdin_ccod")%></td>
								</tr>
								<tr>
								  <td width="18%"><strong>periodo Acad&eacute;mico Intercambio </strong></td>
								  <td width="82%"><table><tr><td><%f_dato_alumno.DibujaCampo("peri_ccod")%></td><td id="td_p" style="display:none"><%f_dato_alumno.DibujaCampo("peri_ccod_fin")%></td></tr></table></td>
								</tr>
								<tr>
									<td width="18%"><strong>Fecha Regreso</strong></td>
								  <td width="82%"><%f_dato_alumno.DibujaCampo("paiu_fvuelta_upa")%></td>
								</tr>
                                <tr>
									<td width="18%"><strong><font color="#0000FF">Doble Titulación</font></strong></td>
								  <td width="82%"><%f_dato_alumno.DibujaCampo("dtil_ccod")%></td>
								</tr>
							</table>
							<table width="100%">
								<tr>
									<td width="7%"><strong>Idioma</strong></td>
								  <td width="10%"><%f_dato_alumno.DibujaCampo("idio_ccod")%></td>
									<td width="16%" align="right"><strong>Nivel Idioma</strong></td>
								  <td width="67%"><%f_dato_alumno.DibujaCampo("nidi_ccod")%></td>
								</tr>
							</table>
							<br>
							<label><strong><font size="2">Lugar de Intercambio</font></strong></label>
							<table width="100%">
								<tr>
									<td width="5%"><strong>Pais</strong></td>
								  <td width="22%"><%f_univ_convenios.dibujaCampoLista "lBusqueda", "pais_ccod" %></td>
									<td width="6%" align="right"><strong>Ciudad</strong></td>
								    <td width="17%"><%f_univ_convenios.dibujaCampoLista "lBusqueda", "ciex_ccod"%></td>
									<td width="11%"><strong>Universidad</strong></td>
								  <td width="39%"><%f_univ_convenios.dibujaCampoLista "lBusqueda", "univ_ccod"%></td>
								</tr>
							</table>
							
							<br>
							<label><strong><font size="2">Contacto en Caso de Emergencia</font></strong></label>
							<table width="100%">
								<tr>
									<td width="9%"><strong>Nombre</strong></td>
								  <td width="37%"><%f_dato_alumno.DibujaCampo("cpiu_tnombre")%></td>
									<td width="11%" align="left"><strong>Parentesco</strong></td>
							      <td width="43%"><%f_dato_alumno.DibujaCampo("pare_ccod")%></td>
								</tr>
								<tr>
									<td><strong>Direccion</strong></td>
								  <td colspan="3"><%f_dato_alumno.DibujaCampo("cpiu_tdireccion")%></td>
								</tr>
								<tr>
								  <td width="9%"><strong>Telefono:</strong></td>
								  <td width="37%"><%f_dato_alumno.DibujaCampo("cpiu_tfono")%></td>
								  <td width="11%"><strong>Celular:</strong></td>
								  <td colspan="4"><%f_dato_alumno.DibujaCampo("cpiu_tfax")%></td>
								</tr>
								<tr>
								 	<td><strong>Email</strong></td>
								  <td colspan="3"><%f_dato_alumno.DibujaCampo("cpiu_temail")%></td>
								</tr>
							</table>
					<%elseif(existe="N") then%>
						<table align="center" width="100%">
							<tr>
								<td align="center"><font color="#FF0000" size="3">EL ALUMNO NO TIENE MATRICULA ACTIVA</font></td>
							</tr>
						</table>		
					<%end if%>
					
						 </form>
					</td>
				  </tr>
        	</table>
		</td>
        <td width="7" background="../imagenes/der.gif"></td>
      </tr>
     <tr>
        <td width="9" height="28"><img src="../imagenes/abajo_r1_c1.gif" width="9" height="28"></td>
        <td height="28"><table width="100%" height="28"  border="0" cellpadding="0" cellspacing="0">
          <tr>
            <td width="31%" height="20"><div align="center">
              <table width="90%"  border="0" cellspacing="0" cellpadding="0">
                <tr>
				 <td><div align="center"><%f_botonera.DibujaBoton("salir")%></div></td>	
                  <td><div align="center">
					<%f_botonera.DibujaBoton"guardar_postulacion"%></div></td>
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
</table>
</body>
</html>