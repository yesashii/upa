<!-- #include file = "../biblioteca/_conexion.asp" -->
<!-- #include file = "../biblioteca/_negocio.asp" -->

<%
set pagina = new CPagina
pagina.Titulo = "SOLICITUD DE SEGURO DE ESCOLARIDAD"
'---------------------------------------------------------------------------------------------------
set conexion = new CConexion
conexion.Inicializar "upacifico"

set negocio = new CNegocio
negocio.Inicializa conexion

'---------------------------------------------------------------------------------------------------
rut = request.querystring("busqueda[0][pers_nrut]")
digito = request.querystring("busqueda[0][pers_xdv]")
q_pare_ccod = Request("pare_ccod")
'--------------------------------------------------------------------------

periodo = negocio.obtenerPeriodoAcademico("POSTULACION")
anio = conexion.consultaUno("select anos_ccod from periodos_academicos where cast(peri_ccod as varchar)='"&periodo&"'")
'response.Write(anio)
 set f_busqueda = new CFormulario
 f_busqueda.Carga_Parametros "info_alumnos.xml", "busqueda_usuarios_nuevo"
 f_busqueda.Inicializar conexion
 f_busqueda.Consultar "select '' "
 f_busqueda.Siguiente
 
 f_busqueda.AgregaCampoCons "pers_nrut", rut
 f_busqueda.AgregaCampoCons "pers_xdv", digito
'--------------------------------------------------------------------------
set botonera = new CFormulario
botonera.Carga_Parametros "m_seguros_escolaridad.xml", "botonera"
'--------------------------------------------------------------------------
codigo = conexion.consultaUno("select pers_ncorr from personas where cast(pers_nrut as varchar)='"&rut&"'")

'response.Write(codigo)


c_post_ncorr = " select top 1 a.post_ncorr  "& vbCrLf	&_
			   " from postulantes a,alumnos b "& vbCrLf	&_
			   " where cast(a.pers_ncorr as varchar)='"&codigo&"' "& vbCrLf	&_
			   " and a.peri_ccod = ( "& vbCrLf	&_
			   " select max(aa.peri_ccod) "& vbCrLf	&_
			   " from postulantes aa, codeudor_postulacion ba, contratos cc, compromisos dd,periodos_academicos pea "& vbCrLf	&_
			   " where cast(aa.pers_ncorr as varchar)='"&codigo&"' "& vbCrLf	&_
			   " and aa.post_ncorr=ba.post_ncorr "& vbCrLf	&_
			   " and aa.post_ncorr=cc.post_ncorr "& vbCrLf	&_
			   " and cc.cont_ncorr= dd.comp_ndocto and dd.tcom_ccod  in (1,2) "& vbCrLf	&_
			   " and aa.peri_ccod=pea.peri_ccod and cast(pea.anos_ccod as varchar)='"&anio&"') "& vbCrLf	&_
			   " and a.post_ncorr=b.post_ncorr and b.emat_ccod <> 9 "& vbCrLf	&_
			   " order by post_fpostulacion desc"
ultimo_post_ncorr = conexion.consultaUno(c_post_ncorr)

'response.Write("<pre>"&ultimo_post_ncorr&"</pre>")

'---------------------------------------------------------------------------------------------------
set f_codeudor = new CFormulario
f_codeudor.Carga_Parametros "m_seguros_escolaridad.xml", "codeudor"
f_codeudor.Inicializar conexion

if EsVacio(q_pare_ccod) then
	v_pare_ccod = conexion.ConsultaUno("select pare_ccod from codeudor_postulacion where cast(post_ncorr as varchar)= '" & ultimo_post_ncorr & "'")
else
	v_pare_ccod = q_pare_ccod
end if

c_contratante = " select pers_ncorr "&_
				" from (select a.pare_ccod,pers_ncorr from codeudor_postulacion a, parentescos b where cast(post_ncorr as varchar)='" & ultimo_post_ncorr & "' and a.pare_ccod=b.pare_ccod "&_
				"		union "&_
				"	  select a.pare_ccod,pers_ncorr from grupo_familiar a, parentescos b where cast(post_ncorr as varchar)='" & ultimo_post_ncorr & "' and a.pare_ccod=b.pare_ccod "&_
				"	  ) as table_1 "&_
				" where cast(table_1.pare_ccod as varchar)= '"&v_pare_ccod&"'"
codigo_contratante = conexion.consultaUno(c_contratante)	

'response.Write(codigo_contratante)
'response.End()
if EsVacio(v_pare_ccod) then
	v_pare_ccod="null"
	filtro ="1=2"
else
	filtro = "1=1"
end if

consulta = "select '"&v_pare_ccod&"' as pare_ccod"
f_codeudor.Consultar consulta

consulta_parentescos=" pare_ccod in (select a.pare_ccod  from codeudor_postulacion a, parentescos b where cast(post_ncorr as varchar)='"&ultimo_post_ncorr&"' "&_
					 " and a.pare_ccod=b.pare_ccod)"

consulta_parentescos=" pare_ccod in ( "&_
                     " select a.pare_ccod  from codeudor_postulacion a, parentescos b where cast(post_ncorr as varchar)='"&ultimo_post_ncorr&"' "&_
					 " and a.pare_ccod=b.pare_ccod "&_
					 " union "&_
					 " select a.pare_ccod  from grupo_familiar a, parentescos b where cast(post_ncorr as varchar)='"&ultimo_post_ncorr&"' "&_
					 " and a.pare_ccod=b.pare_ccod)"
'response.Write(consulta_parentescos)
f_codeudor.agregaCampoParam "pare_ccod","filtro",consulta_parentescos
 if f_codeudor.nroFilas = 0 and rut <> "" then
 	f_codeudor.AgregaCampoCons "pers_nrut",rut
	f_codeudor.AgregaCampoCons "pers_xdv",digito
 end if 
 
f_codeudor.Siguiente
'response.End()

'------------------------------------------------------------------------------------------------------------
if v_pare_ccod ="0" then
	paterno = conexion.consultaUno("select pers_tape_paterno from personas where cast(pers_ncorr as varchar)='"&codigo&"'")
	materno = conexion.consultaUno("select pers_tape_materno from personas where cast(pers_ncorr as varchar)='"&codigo&"'")
	nombres = conexion.consultaUno("select pers_tnombre from personas where cast(pers_ncorr as varchar)='"&codigo&"'")
	codigo_contratante = codigo
else
    'response.Write("select pers_ncorr from grupo_familiar where cast(post_ncorr as varchar)='"&ultimo_post_ncorr&"' and cast(pare_ccod as varchar)='"&v_pare_ccod&"'")
    'codigo_contratante = conexion.consultaUno("select pers_ncorr from codeudor_postulacion where cast(post_ncorr as varchar)='"&ultimo_post_ncorr&"' -- and cast(pare_ccod as varchar)='"&v_pare_ccod&"'")	
    if codigo_contratante = "" then 
		codigo_contratante = conexion.consultaUno("select pers_ncorr from codeudor_postulacion where cast(post_ncorr as varchar)='"&ultimo_post_ncorr&"'")	
	end if
	paterno = conexion.consultaUno("select pers_tape_paterno from personas where cast(pers_ncorr as varchar)='"&codigo_contratante&"'")
	materno = conexion.consultaUno("select pers_tape_materno from personas where cast(pers_ncorr as varchar)='"&codigo_contratante&"'")
	nombres = conexion.consultaUno("select pers_tnombre from personas where cast(pers_ncorr as varchar)='"&codigo_contratante&"'")

end if

'response.Write(codigo_contratante)
'------------------------------------------------------------------------------------------------------------
'response.End()
if ultimo_post_ncorr <> "" then 
   paterno_codeudor = conexion.consultaUno("select pers_tape_paterno from personas  where cast(pers_ncorr as varchar)='"&codigo_contratante&"' ")
   materno_codeudor = conexion.consultaUno("select pers_tape_materno from personas  where cast(pers_ncorr as varchar)='"&codigo_contratante&"' ")
   nombres_codeudor = conexion.consultaUno("select pers_tnombre from personas where cast(pers_ncorr as varchar)='"&codigo_contratante&"' ") 
   codigo_codeudor = conexion.consultaUno("select pers_ncorr from personas where cast(pers_ncorr as varchar)='"&codigo_contratante&"' ")
   nacimiento_codeudor = conexion.consultaUno("select isnull(protic.trunc(pers_fnacimiento),'') from personas where cast(pers_ncorr as varchar)='"&codigo_contratante&"' ") 
   rut_codeudor = conexion.consultaUno("select cast(pers_nrut as varchar) + '-' + pers_xdv from personas a where cast(pers_ncorr as varchar)='"&codigo_contratante&"' ")
   fonos_codeudor = conexion.consultaUno("select 'Fono: ' + ltrim(rtrim(isnull(pers_tfono,'--'))) + ' Celular: ' + ltrim(rtrim(isnull(pers_tcelular,'--'))) from personas where cast(pers_ncorr as varchar)='"&codigo_contratante&"' ")
end if
edad = "0"
'response.Write(nacimiento_codeudor)
if nacimiento_codeudor <> " " and not esVacio(nacimiento_codeudor) then
    'response.Write("select datediff(year,protic.trunc(convert(datetime,case '"&nacimiento_codeudor&"' when '' then getDate() else '"&nacimiento_codeudor&"' end ,103)),protic.trunc(getDate()))")
	'edad = "40"'conexion.consultaUno("select datediff(year,convert(datetime,case '"&nacimiento_codeudor&"' when '' then getDate() else '"&nacimiento_codeudor&"' end ,103),getDate())")
	edad = conexion.consultaUno("select datediff(year, convert(datetime,isnull('"&nacimiento_codeudor&"',convert(datetime,protic.trunc(getDate()),103)) ,103), convert(datetime,protic.trunc(getDate()),103))")
'response.Write(edad)
end if
'response.End()
'response.Write(edad)

if codigo <> "" then
	nombre_alumno = conexion.consultaUno("select pers_tape_paterno + ' ' + pers_tape_materno + ', ' + pers_tnombre from personas where cast(pers_ncorr as varchar)='"&codigo&"'")
	rut_alumno = conexion.consultaUno("select cast(pers_nrut as varchar) + '-' + pers_xdv from personas where cast(pers_ncorr as varchar)='"&codigo&"'")
	nacimiento_alumno = conexion.consultaUno("select isnull(protic.trunc(pers_fnacimiento),'--') from personas where cast(pers_ncorr as varchar)='"&codigo&"'")
	carrera_alumno = conexion.consultaUno("select c.sede_tdesc + ' - ' + protic.obtener_nombre_carrera(b.ofer_ncorr,'CJ') from postulantes a, ofertas_academicas  b, sedes c where cast(a.post_ncorr as varchar)='"&ultimo_post_ncorr&"' and a.ofer_ncorr=b.ofer_ncorr and  b.sede_ccod = c.sede_ccod")
end if


'---------------------------------------------------------------------------------------------------
set f_ingreso = new CFormulario
f_ingreso.Carga_Parametros "m_seguros_escolaridad.xml", "ingreso_preexistencias"
f_ingreso.Inicializar conexion

consulta = "select '"&ultimo_post_ncorr&"' as post_ncorr,'"&codigo_contratante&"' as pers_ncorr"
f_ingreso.Consultar consulta

c_enfermedades = " (select enfe_ccod,enfe_tdesc "&_
				 " from enfermedades a "&_
				 " where not exists (select 1 from  enfermedades_solicitud_seguro bb where cast(bb.pers_ncorr as varchar)='"&codigo_contratante&"' "&_
				 "                  and cast(bb.post_ncorr as varchar)='"&ultimo_post_ncorr&"' and a.enfe_ccod=bb.enfe_ccod) ) aa"
'response.Write(consulta)
f_ingreso.agregaCampoParam "enfe_ccod","destino",c_enfermedades 
f_ingreso.Siguiente	


set lista_preexistencias = new CFormulario
lista_preexistencias.Carga_Parametros "m_seguros_escolaridad.xml", "lista_preexistencias"
lista_preexistencias.Inicializar conexion
consulta_acceso =  " select b.pers_tnombre + ' ' + b.pers_tape_paterno + ' ' + b.pers_tape_materno as nombre,"& vbCrLf	&_
				   " c.enfe_tdesc + ' ' + isnull(a.esse_tdescripcion,'') as enfermedad, protic.trunc(a.esse_tfecha) as fecha "& vbCrLf	&_
				   " from enfermedades_solicitud_seguro a, personas b,enfermedades c "& vbCrLf	&_
				   " where a.pers_ncorr=b.pers_ncorr and cast(a.pers_ncorr as varchar)='"&codigo_contratante&"' "& vbCrLf	&_
			       " and cast(a.post_ncorr as varchar)='"&ultimo_post_ncorr&"' "& vbCrLf	&_
				   " and a.enfe_ccod = c.enfe_ccod"

'response.Write("<pre>"&consulta_acceso&"</pre>")
lista_preexistencias.Consultar consulta_acceso
'lista_preexistencias.siguiente

consulta_grabado = "select 'Ya existe una solicitud a nombre de ' + protic.initcap(b.pers_tnombre + ' ' + b.pers_tape_paterno + ' ' + b.pers_tape_materno) "& vbCrLf	&_
				   " + ' el día ' + protic.trunc(sses_fpostulacion) "& vbCrLf	&_
				   " from solicitud_seguro_escolaridad a, personas b,postulantes c, periodos_academicos d "& vbCrLf	&_
				   " where a.pers_ncorr_contratante=b.pers_ncorr "& vbCrLf	&_
				   " and cast(c.pers_ncorr as varchar)='"&codigo&"' "& vbCrLf	&_
				   " and a.post_ncorr=c.post_ncorr "& vbCrLf	&_
				   " and c.peri_ccod=d.peri_ccod "& vbCrLf	&_
				   " --and exists (select 1 from compromisos comp where comp.post_ncorr=c.post_ncorr and tcom_ccod=26 and ecom_ccod <> 3) "& vbCrLf	&_
				   " and cast(d.anos_ccod as varchar)='"&anio&"'"

mensaje  = conexion.consultaUno(consulta_grabado)
grabado = conexion.consultaUno("select count(*) from solicitud_seguro_escolaridad a, postulantes b, periodos_academicos c where a.post_ncorr=b.post_ncorr and cast(b.pers_ncorr as varchar)='"&codigo&"' and b.peri_ccod=c.peri_ccod and cast(c.anos_ccod as varchar)='"&anio&"'")
grabado_con_cargo = conexion.consultaUno("select count(*) from solicitud_seguro_escolaridad a, postulantes b, periodos_academicos c where a.post_ncorr=b.post_ncorr and cast(b.pers_ncorr as varchar)='"&codigo&"' and b.peri_ccod=c.peri_ccod and cast(c.anos_ccod as varchar)='"&anio&"' and exists(Select 1 from compromisos cc where cc.post_ncorr=a.post_ncorr and cc.ofer_ncorr=a.ofer_ncorr and cc.ecom_ccod<> 3 and cc.tcom_ccod=26)")

if cint(grabado_con_cargo) > 0 then 
    'response.Write(grabado_con_cargo)
	valor_check= "N"
else
	if cint(grabado) > 0 then 
		valor_check = conexion.consultaUno("select no_deseo from solicitud_seguro_escolaridad a, postulantes b, periodos_academicos c where a.post_ncorr=b.post_ncorr and cast(b.pers_ncorr as varchar)='"&codigo&"' and b.peri_ccod=c.peri_ccod and cast(c.anos_ccod as varchar)='"&anio&"'")
	else
		valor_check = "N"	
	end if
end if
'response.Write(valor_check)
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

function Validar()
{
	formulario = document.buscador;
	
	rut_alumno = formulario.elements["busqueda[0][pers_nrut]"].value + "-" + formulario.elements["busqueda[0][pers_xdv]"].value;	
	if (formulario.elements["busqueda[0][pers_nrut]"].value  != '')
  	  if (!valida_rut(rut_alumno)) {
		alert('Ingrese un RUT válido.');
		formulario.elements["busqueda[0][pers_xdv]"].focus();
		formulario.elements["busqueda[0][pers_xdv]"].select();
		return false;
	  }
	
	
	return true;
}

function genera_digito (rut){
 var IgStringVerificador, IgN, IgSuma, IgDigito, IgDigitoVerificador, rut;
 var texto_rut = new String(rut);
 var posicion_guion = 0;
 
 posicion_guion = texto_rut.indexOf("-");
 if (posicion_guion != -1)
 {
    texto_rut = texto_rut.substring(0,posicion_guion);
    document.buscador.elements["busqueda[0][pers_nrut]"].value= texto_rut;
	rut = texto_rut;
 }
// texto_rut.
 //alert(texto_rut);
   if (rut.length==7) rut = '0' + rut; 

   
   IgStringVerificador = '32765432';
   IgSuma = 0;
   for( IgN = 0; IgN < 8 && IgN < rut.length; IgN++)
      IgSuma = eval(IgSuma + '+' + rut.substr(IgN, 1) + '*' + IgStringVerificador.substr(IgN, 1) + ';');
   IgDigito = 11 - IgSuma % 11;
   IgDigitoVerificador = IgDigito==10?'K':IgDigito==11?'0':IgDigito;
   //alert(IgDigitoVerificador);
buscador.elements["busqueda[0][pers_xdv]"].value=IgDigitoVerificador;
//alert(rut+IgDigitoVerificador);
_Buscar(this, document.forms['buscador'],'', 'Validar();', 'FALSE');
}
function refrescar(valor)
{
 var rut = '<%=rut%>';
 var digito = '<%=digito%>';
 var url="";
 
 if ((rut != "" )&&(digito!=""))
 {
   url = "m_seguros_escolaridad.asp?pare_ccod="+valor+"&busqueda[0][pers_nrut]="+rut+"&busqueda[0][pers_xdv]="+digito;	
   document.location = url;
 }
//alert(url);

}

function ocultar(valor)
{
	
	if (document.edicion.elements["desea_seguro"].checked)
	{
	    //document.getElementById("tabla").style.visibility = "hidden" ;
		//document.getElementById("tabla2").style.visibility = "hidden" ;
		//document.getElementById("tabla3").style.visibility = "hidden" ;
		//document.getElementById("tabla4").style.visibility = "hidden" ;
		document.getElementById("tabla5").style.visibility = "hidden" ;
		document.getElementById("tabla6").style.visibility = "hidden" ;
		//document.getElementById("tabla7").style.visibility = "hidden" ;
		document.getElementById("tabla8").style.visibility = "hidden" ;
		document.edicion2.elements["no_deseo"].value="S";
	}
	else
	{
	    //document.getElementById("tabla").style.visibility = "visible" ;
		//document.getElementById("tabla2").style.visibility = "visible" ;
		//document.getElementById("tabla3").style.visibility = "visible" ;
		//document.getElementById("tabla4").style.visibility = "visible" ;
		document.getElementById("tabla5").style.visibility = "visible" ;
		document.getElementById("tabla6").style.visibility = "visible" ;
		//document.getElementById("tabla7").style.visibility = "visible" ;
		document.getElementById("tabla8").style.visibility = "visible" ;
		document.edicion2.elements["no_deseo"].value="N";
	}
}

function bloquear(valor)
{
//alert(valor);
if (valor==0)
	{  
	   document.edicion.elements["ip[0][esse_tdescripcion]"].disabled=false;
	   document.edicion.elements["ip[0][esse_tdescripcion]"].id="TO-N";
	}
else
	{
	  document.edicion.elements["ip[0][esse_tdescripcion]"].id="TO-S";
	}	
}

function revisar()
{var codigo_codeudor = '<%=codigo_codeudor%>';
 var codigo_contratante = '<%=codigo_contratante%>';
// alert ("codeudor "+codigo_codeudor+" contratante "+ codigo_contratante);
 if ((codigo_codeudor!=codigo_contratante) && (codigo_contratante!=''))
 {
 	alert("Lo sentimos, sólo puede solicitar el seguro si el contratante es el mismo sostenedor económico de la matricula del alumno");
	return false;
 }
 else if ((codigo_codeudor==codigo_contratante) && (codigo_contratante!=''))
 {
 	if (!confirm("¿Desea enviar la solicitud de Seguro de Escolaridad?, esto generará un cargo en su cuenta corriente"))
	{
		return false;
	}
	else
	{	
		return true;
	}
 } 
 
return false;
}

function revisar_fecha()
{
var fecha = document.edicion.elements["ip[0][esse_tfecha]"].value;
var v_fecha = new Date();
	dia=v_fecha.getDate();
	mes=v_fecha.getMonth()+1;
	agno=v_fecha.getFullYear();
	if (dia<10){dia='0'+dia;}

array_pag=fecha.split('/');

dia_pag  = array_pag[0];
mes_pag  = array_pag[1];
agno_pag = array_pag[2];

// con formatos mm/dd/yyyy
fecha_pag=mes_pag+'/'+dia_pag+'/'+agno_pag;
sysdate=mes+'/'+dia+'/'+agno;

// convertir a milisegundos
m_sysdate = Date.parse(sysdate);
m_fecha_ingresada= Date.parse(fecha_pag);
//alert("m_sysdate "+m_sysdate+" m_fecha_ingresada "+m_fecha_ingresada);

diferencia=eval(m_fecha_ingresada-m_sysdate);
//alert ("diferencia "+diferencia);
	if (diferencia<0)
	{
		dias = eval(Math.round(diferencia/86400000))*-1;
		//alert ("agno_pag "+agno_pag);
		if (agno_pag < 1940)
		{
			alert("La fecha del diagnóstico nos indica que usted no cumple el requisito de edad menor a 68 años");
			return false;
		}
		else
		{
		   //alert ("pasé");
		   return true;
		}
    }
	else if (diferencia > 0)
	{
		alert("Al parecer la fecha de diagnóstico esta errada pues es posterior a la fecha actual, haga el favor de corregir");
		return false;
	}
	
//alert("En días "+dias);
//return false;
}
</script>

</head>
<body bgcolor="#CC6600" leftmargin="0" topmargin="0" marginwidth="0" marginheight="0" onLoad="MM_preloadImages('../imagenes/botones/buscar_f2.gif','../images/bot_deshabilitar_f2.gif','../images/agregar2_f2_p.gif','im&amp;#225;genes/marco1_r3_c2_f2.gif');MM_preloadImages('im&amp;#225;genes/marco1_r3_c4_f2.gif');MM_preloadImages('im&amp;#225;genes/marco1_r3_c6_f2.gif');MM_preloadImages('im&amp;#225;genes/marco1_r3_c8_f2.gif');MM_preloadImages('../imagenes/botones/cargar_f2.gif','../imagenes/botones/continuar_f2.gif')">
<table width="750" border="0" align="center" cellpadding="0" cellspacing="0">
  <tr>
    <td><img src="../imagenes/vineta2_r1_c1.gif" width="750" height="72" border="0"></td>
  </tr>
  <%pagina.DibujarEncabezado()%>  
  <tr>
    <td valign="top" bgcolor="#EAEAEA">
	<br>
	<table width="90%" border="0" align="center" cellpadding="0" cellspacing="0">
      <tr>
        <td><table width="90%" border="0" align="center" cellpadding="0" cellspacing="0">
              <tr> 
                <td><table border="0" cellpadding="0" cellspacing="0" width="100%">
                    <!-- fwtable fwsrc="marco contenidos.png" fwbase="top.gif" fwstyle="Dreamweaver" fwdocid = "742308039" fwnested="0" -->
                    <tr> 
                      <td><img src="../imagenes/spacer.gif" width="9" height="1" border="0" alt=""></td>
                      <td><img src="../imagenes/spacer.gif" width="559" height="1" border="0" alt=""></td>
                      <td><img src="../imagenes/spacer.gif" width="7" height="1" border="0" alt=""></td>
                    </tr>
                    <tr> 
                      <td><img name="top_r1_c1" src="../imagenes/top_r1_c1.gif" width="9" height="8" border="0" alt=""></td>
                      <td height="8"><img name="top_r1_c2" src="../imagenes/top_r1_c2.gif" width="670" height="8" border="0" alt=""></td>
                      <td><img name="top_r1_c3" src="../imagenes/top_r1_c3.gif" width="7" height="8" border="0" alt=""></td>
                    </tr>
                    <tr> 
                      <td><img name="top_r2_c1" src="../imagenes/top_r2_c1.gif" width="9" height="17" border="0" alt=""></td>
                      <td><table width="100%" border="0" cellspacing="0" cellpadding="0">
                          <tr> 
                            <td width="15" background="../imagenes/fondo1.gif"><img src="../imagenes/izq_1.gif" width="5" height="17"></td>
                            <td width="210" valign="bottom" background="../imagenes/fondo1.gif"> 
                              <div align="left"><font color="#FFFFFF" size="2" face="Verdana, Arial, Helvetica, sans-serif">Buscador 
                                </font></div></td>
                            <td width="6"><img src="../imagenes/derech1.gif" width="6" height="17"></td>
                            <td width="423" bgcolor="#D8D8DE"><font color="#D8D8DE" size="1">.</font></td>
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
                      <td width="9" height="62" align="left" background="../imagenes/izq.gif">&nbsp;</td>
                      <td bgcolor="#D8D8DE"><div align="center"> 
                          <form name="buscador">
                            <table width="98%"  border="0">
                              <tr> 
                                <td width="81%"><table width="524" border="0">
                                    <tr> 
                                      <td width="98">Rut Alumno</td>
                                      <td width="23">:</td>
                                      <td width="389"><font face="Verdana, Arial, Helvetica, sans-serif" size="1"> 
                                        <%f_busqueda.DibujaCampo("pers_nrut") %>
                                        - 
                                        <%f_busqueda.DibujaCampo("pers_xdv")%>
                                        </font><a href="javascript:buscar_persona('busqueda[0][pers_nrut]', 'busqueda[0][pers_xdv]');"><img src="../imagenes/lupa_f2.gif" width="16" height="15" border="0"></a></td>
                                    </tr>
                                  </table></td>
                                <td width="19%"><div align="center"> 
                                    <%botonera.DibujaBoton "buscar" %>
                                  </div></td>
                              </tr>
                            </table>
                          </form>
                        </div></td>
                      <td width="7" align="right" background="../imagenes/der.gif">&nbsp;</td>
                    </tr>
                    <tr> 
                      <td align="left" valign="top"><img src="../imagenes/base1.gif" width="9" height="13"></td>
                      <td valign="top" bgcolor="#D8D8DE"><img src="../imagenes/base2.gif" width="670" height="13"></td>
                      <td align="right" valign="top"><img src="../imagenes/base3.gif" width="7" height="13"></td>
                    </tr>
                  </table></td>
              </tr>
            </table></td>
      </tr>
    </table>	
	<br>		
	<table width="90%" border="0" align="center" cellpadding="0" cellspacing="0">
        <tr>
          <td><table border="0" cellpadding="0" cellspacing="0" width="100%">
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
                      <div align="left"><font color="#FFFFFF" size="1" face="Verdana, Arial, Helvetica, sans-serif">Datos 
                          Encontrados</font></div></td>
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
              <table width="100%" border="0" cellspacing="0" cellpadding="0" aling="center">
                <tr>
                  <td width="9" align="left" background="../imagenes/izq.gif">&nbsp;</td>
                  
                <td bgcolor="#D8D8DE"> 
				  <table width="100%" border="0">
                   	<tr> 
                      <td colspan="3" align="center">
					  	 <table width="100%">
						 	  <tr><td>&nbsp;</td></tr>
							  <tr> 
								<td align="center">
									<table width="90%" cellpadding="0" cellspacing="0" border="1">
										<TR>
											<TD align="center"><div align="center"><font size="4"><strong>SOLICITUD DE SEGURO DE ESCOLARIDAD</strong></font></div></TD>
										</TR>
									</table></td>
							  </tr>
							  <tr><td>&nbsp;</td></tr>
							  <%if rut <> "" and digito <> "" and ultimo_post_ncorr <> "" then %>
							  <tr><td>&nbsp;</td></tr>
							  <tr> 
								<td align="center">
									<table width="90%" cellpadding="0" cellspacing="0">
										<TR>
											<TD align="left"><div align="left"><font size="2"><strong>Contratante Contrato de Servicios Educacionales - Año <%=anio%></strong></font></div></TD>
										</TR>
									</table></td>
							  </tr>
							  <tr> 
								<td align="center">
									<table width="90%" cellpadding="0" cellspacing="0" border="1">
										<tr><td colspan="3" align="center"><%f_codeudor.DibujaCampo("pare_ccod")%>  </td></tr>
										<TR>
											<TD align="center" width="33%"><div align="center"><font size="2">Apellido Paterno</font></div></TD>
											<TD align="center" width="33%"><div align="center"><font size="2">Apellido Materno</font></div></TD>
											<TD align="center" width="33%"><div align="center"><font size="2">Nombres</font></div></TD>
										</TR>
										<TR>
											<TD align="center" width="33%"><div align="center"><font size="2"><%=paterno%></font></div></TD>
											<TD align="center" width="33%"><div align="center"><font size="2"><%=materno%></font></div></TD>
											<TD align="center" width="33%"><div align="center"><font size="2"><%=nombres%></font></div></TD>
										</TR>
									</table></td>
							  </tr>
							  <tr><td>&nbsp;</td></tr>
							  <tr><td>&nbsp;</td></tr>
							  <form name="edicion">
							  <tr> 
								<td align="center">
									<table width="90%" cellpadding="0" cellspacing="0">
									   <%if valor_check = "S" then%>
										<TR>
											<TD align="center"><div align="center"><input type="checkbox" name="desea_seguro" value="0" onClick="ocultar(this);" checked>&nbsp;&nbsp;<strong><font size="2" style="text-decoration:underline">NO</font>&nbsp;&nbsp;<font size="2">DESEO EL SEGURO DE ESCOLARIDAD</strong></font></div></TD>
										</TR>
										<%else%>
										<TR>
											<TD align="center"><div align="center"><input type="checkbox" name="desea_seguro" value="0" onClick="ocultar(this);">&nbsp;&nbsp;<strong><font size="2" style="text-decoration:underline">NO</font>&nbsp;&nbsp;<font size="2">DESEO EL SEGURO DE ESCOLARIDAD</strong></font></div></TD>
										</TR>
										<%end if%>
									</table></td>
							  </tr>
							  
							  <tr><td>&nbsp;</td></tr>
							   <tr><td>&nbsp;</td></tr>
							  <tr> 
								<td align="center">
									<table width="90%" cellpadding="0" cellspacing="0" id="tabla" style="visibility:visible">
										<TR>
											<TD align="Left" width="20%"><div align="left"><font size="2"><strong>1er Sostenedor</strong></font></div></TD>
											<TD align="center" width="10%"><div align="center"><font size="2">&nbsp;</font></div></TD>
											<TD align="left"><div align="left"><font size="2">(Edad m&aacute;xima asegurable 68 años, 364 d&iacute;as)</font></div></TD>
										</TR>
									</table></td>
							  </tr>
							  <tr> 
								<td align="center">
									<table width="90%" cellpadding="0" cellspacing="0" border="1" id="tabla2" style="visibility:visible">
										<TR>
											<TD align="center" width="33%"><div align="center"><font size="2">Apellido Paterno</font></div></TD>
											<TD align="center" width="33%"><div align="center"><font size="2">Apellido Materno</font></div></TD>
											<TD align="center" width="33%"><div align="center"><font size="2">Nombres</font></div></TD>
										</TR>
										<TR>
											<TD align="center" width="33%"><div align="center"><font size="2"><%=paterno_codeudor%></font></div></TD>
											<TD align="center" width="33%"><div align="center"><font size="2"><%=materno_codeudor%></font></div></TD>
											<TD align="center" width="33%"><div align="center"><font size="2"><%=nombres_codeudor%></font></div></TD>
										</TR>
										<TR>
											<TD align="center" width="33%"><div align="center"><font size="2">F. Nacimiento</font></div></TD>
											<TD align="center" width="33%"><div align="center"><font size="2">R.U.T.</font></div></TD>
											<TD align="center" width="33%"><div align="center"><font size="2">Fonos</font></div></TD>
										</TR>
										<TR>
											<TD align="center" width="33%"><div align="center"><font size="2"><%=nacimiento_codeudor%></font></div></TD>
											<TD align="center" width="33%"><div align="center"><font size="2"><%=rut_codeudor%></font></div></TD>
											<TD align="center" width="33%"><div align="center"><font size="2"><%=fonos_codeudor%></font></div></TD>
										</TR>
										<%if (cint(edad) <= 0 or cint(edad) > 68) then%>
										<tr>
											<td colspan="3" align="center" bgcolor="#000099"><font size="2" color="#ffffff"><strong>No cumple requisito de edad menor a 68 años, o no registra fecha de nacimiento el codeudor.</strong></font></td>
										</tr>
										
										<%end if%>
									</table></td>
							  </tr>
							  <tr><td>&nbsp;</td></tr>
							  <tr><td>&nbsp;</td></tr>
							  <tr><td>&nbsp;</td></tr>
							  <tr> 
								<td align="center">
									<table width="90%" cellpadding="0" cellspacing="0" id="tabla3" style="visibility:visible">
										<TR>
											<TD align="left"><div align="left"><font size="2"><strong>Datos Alumnos (s)</strong></font></div></TD>
										</TR>
									</table></td>
							  </tr>
							  <tr> 
								<td align="center">
									<table width="90%" cellpadding="0" cellspacing="0" border="1" id="tabla4" style="visibility:visible">
										<TR>
											<TD align="center" width="30%"><div align="center"><font size="2">Nombre completo</font></div></TD>
											<TD align="center" width="15%"><div align="center"><font size="2">RUT</font></div></TD>
											<TD align="center" width="15%"><div align="center"><font size="2">F. Nacimiento</font></div></TD>
											<TD align="center" width="40%"><div align="center"><font size="2">Carrera</font></div></TD>
										</TR>
										<TR>
											<TD align="center" width="30%"><div align="center"><font size="2"><%=nombre_alumno%></font></div></TD>
											<TD align="center" width="15%"><div align="center"><font size="2"><%=rut_alumno%></font></div></TD>
											<TD align="center" width="15%"><div align="center"><font size="2"><%=nacimiento_alumno%></font></div></TD>
											<TD align="center" width="40%"><div align="center"><font size="2"><%=carrera_alumno%></font></div></TD>
										</TR>
										<TR>
											<TD align="center" width="30%"><div align="center"><font size="2">&nbsp;</font></div></TD>
											<TD align="center" width="15%"><div align="center"><font size="2">&nbsp;</font></div></TD>
											<TD align="center" width="15%"><div align="center"><font size="2">&nbsp;</font></div></TD>
											<TD align="center" width="40%"><div align="center"><font size="2">&nbsp;</font></div></TD>
										</TR>
										<TR>
											<TD align="center" width="30%"><div align="center"><font size="2">&nbsp;</font></div></TD>
											<TD align="center" width="15%"><div align="center"><font size="2">&nbsp;</font></div></TD>
											<TD align="center" width="15%"><div align="center"><font size="2">&nbsp;</font></div></TD>
											<TD align="center" width="40%"><div align="center"><font size="2">&nbsp;</font></div></TD>
										</TR>
									</table></td>
							  </tr>
							   <tr><td>&nbsp;</td></tr>
							  <tr><td>&nbsp;</td></tr>
							  <tr> 
								<td align="center">
									<table width="90%" cellpadding="0" cellspacing="0" id="tabla5" style="visibility:visible">
										<TR>
											<TD align="left"><div align="left"><font size="2"><strong>Declaración simple</strong></font></div></TD>
										</TR>
									</table></td>
							  </tr>
							  <tr> 
								<td align="center">
									<table width="90%" cellpadding="0" cellspacing="0" border="1" id="tabla6" style="visibility:visible">
										<TR>
											<TD align="center" width="100%">
												<div align="justify">
												   <font size="2">Declaro estar en buenas condiciones de salud y que no padezco ni he padecido ninguna de las siguientes enfermedades:
																  Diabetes, cáncer o tumores de cualquier naturaleza, trastornos mentales o del sistema nervioso, enfermedades cardiovasculares
																  y/o hipertensión, broncopulmonares, genitourinarias, renales y de transmisión sexual (venereas o sida). En caso contrario detallar
																  en "Declaración de Preexistencias".<br><br>Preexistencia: Se entiende por preexistencia cualquier enfermedad o accidente conocida y/o 
																  diagnosticada  con anterioridad a la fecha de llenado de este formulario.             
												   </font>
												 </div>
											  </TD>
										</TR>
										
										<TR>
											  <TD align="center" width="100%"><br>
													<table width="90%">
														<tr>
															<td colspan="6" align="center"><strong>Ingreso de Preexistencias de <%=nombres%>&nbsp;<%=paterno%>&nbsp;<%=materno%></strong></td>
														</tr>
														<tr>
															<td width="25%"><strong>Enfermedad o Accidente</strong></td>
															<td width="1%"><strong>:</strong><%f_ingreso.dibujaCampo("post_ncorr")%></td>
															<td width="34%"><%f_ingreso.dibujaCampo("enfe_ccod")%></td>
															<td width="15%" align="right"><strong>Fecha</strong></td>
															<td width="1%"><strong>:</strong><%f_ingreso.dibujaCampo("pers_ncorr")%></td>
															<td width="24%"><%f_ingreso.dibujaCampo("esse_tfecha")%></td>
														</tr>
														<tr>
															<td width="25%"><strong>Descripción</strong></td>
															<td width="1%"><strong>:</strong></td>
															<td colspan="4"><%f_ingreso.dibujaCampo("esse_tdescripcion")%></td>
														</tr>
														<tr><td colspan="6" align="right"><%botonera.dibujaBoton("agregar_preexistencia")%></td></tr>
														<tr>
															<td colspan="6" align="center">&nbsp;</td>
														</tr>
														<tr>
															<td colspan="6" align="center"><strong>Declaraci&oacute;n de Preexistencia</strong></td>
														</tr>
														<tr>
															<td colspan="6" align="center"><%lista_preexistencias.DibujaTabla %></td>
														</tr>
													</table>
											  </TD>
										</TR>
									</table></td>
							  </tr>
							  <tr><td>&nbsp;</td></tr>
							  <tr><td><div align="justify">Confirmo la exactitud y veracidad de las declaraciones arriba expresadas y que nada he omitido y/o disimulado
		                             y autorizo a la Compañía a recabar todos aquellos antecedentes que de una u otra forma le permitan realizar una 
									 mejor evaluación de esta Solicitud de Seguro.</div></td></tr>
							  </form>
							  <form name="edicion2">
							  <tr><td><input type="hidden" name="post_ncorr" value="<%=ultimo_post_ncorr%>">
							          <input type="hidden" name="pers_ncorr_contratante" value="<%=codigo_contratante%>">
									  <input type="hidden" name="no_deseo" value="<%=valor_check%>">
								   </td>
							   </tr>
							  </form>
								  <%if mensaje <> "" then %>
									  <tr><td>&nbsp;</td></tr>
									  <tr><td align="center" bgcolor="#0033CC"><font size="2" color="#FFFFFF"><strong><%=mensaje%></strong></font></td></tr>
									  <tr><td></td></tr>
								  <%end if%>
							  <%end if
							  if (ultimo_post_ncorr="" or esVacio(ultimo_post_ncorr)) and rut <> "" and digito <>"" then%>
							  <tr><td>&nbsp;</td></tr>
							  <tr><td align="center" bgcolor="#0033FF"><font size="2" color="#FFFFFF">No se ha encontrado ningún contrato en el año, para el alumno solicitado.</font></td></tr>
							  <tr><td>&nbsp;</td></tr>
							  <%end if%>
													 </table>	
												  </td>
												</tr>
												</table>
																 
											  <br>				  </td>
											  <td width="7" align="right" background="../imagenes/der.gif">&nbsp;</td>
											</tr>
										</table>
										  <table width="100%" border="0" cellspacing="0" cellpadding="0">
											<tr>
											  <td width="9" rowspan="2"><img src="../imagenes/abajo_r1_c1.gif" width="9" height="28"></td>
											  <td width="101" nowrap bgcolor="#D8D8DE"><table width="100%" border="0" cellpadding="0" cellspacing="0">
												<tr> 
												   <td width="27%">
													<%  botonera.dibujaboton "salir"%>
												  </td>
												  <td width="23%">
																  <table width="100%" border="0" cellpadding="0" cellspacing="0" id="tabla7" style="visibility:visible">
																  <tr>
																  	<td align="center">
																		<%'response.Write(edad)
																		  if  grabado_con_cargo = "0" and cint(edad) <> 0  then 
																		     botonera.dibujaboton "guardar_solicitud"
																		  end if%>
																	</td>
																  </tr>
																  </table>
													
												  </td>
												  <td width="23%">
																  <table width="100%" border="0" cellpadding="0" cellspacing="0" id="tabla8" style="visibility:visible">
																  <tr>
																  	<td align="center">
																		<%'response.Write(edad)
																		  if  grabado <> "0" then 
																		     botonera.agregaBotonParam "excel2","url","imprimir_seguro_escolaridad.asp?post_ncorr="&ultimo_post_ncorr&"&pers_ncorr="&codigo_contratante
																			 botonera.dibujaboton "excel2"
																		  end if%>
																	</td>
																  </tr>
																  </table>
													 </td>
													 <td width="27%">
													<%  botonera.agregaBotonParam "listado_solicitudes","url","m_seguros_escolaridad_excel.asp"
														botonera.dibujaboton "listado_solicitudes"%>
												  </td>
												</tr>
											  </table></td>
											  <td width="309" rowspan="2" background="../imagenes/abajo_r1_c4.gif"><img src="../imagenes/abajo_r1_c3.gif" width="12" height="28"></td>
											  <td width="267" rowspan="2" align="right" background="../imagenes/abajo_r1_c4.gif"><img src="../imagenes/abajo_r1_c5.gif" width="7" height="28"></td>
											</tr>
											<tr>
											  <td valign="bottom" bgcolor="#D8D8DE"><img src="../imagenes/abajo_r2_c2.gif" width="100%" height="8"></td>
											</tr>
										</table>

			<BR>
		  </td>
        </tr>
		
      </table>	
   </td>
  </tr>  
</table>
</body>
</html>
