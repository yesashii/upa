<!-- #include file = "../biblioteca/_conexion.asp" -->
<!-- #include file = "../biblioteca/_negocio.asp" -->

<%
sede_ccod = Request.QueryString("busqueda[0][sede_ccod]")
jorn_ccod = Request.QueryString("busqueda[0][jorn_ccod]")
carr_ccod = Request.QueryString("busqueda[0][carr_ccod]")
estado_ccod = Request.QueryString("estado_ccod")
estado_alumno = Request.QueryString("estado_alumno")
paso=request.QueryString("paso")
q_pers_nrut=request.QueryString("busqueda[0][pers_nrut]")
q_pers_xdv=request.QueryString("busqueda[0][pers_xdv]")

'response.Write("estado "&estado_ccod)
'busqueda=request.QueryString("paso")
'response.Write("sede= "&sede_ccod & " carrera "&carr_ccod&" jornada "&jorn_ccod)


'if sede_ccod="" then
'	sede_ccod=1
'end if	
	
'---------------------------------------------------------------------------------------------------
set pagina = new CPagina
pagina.Titulo = "Listado Pases de Matricula"

'---------------------------------------------------------------------------------------------------
set conexion = new CConexion
conexion.Inicializar "upacifico"
set negocio = new CNegocio
negocio.Inicializa conexion
usuario=negocio.obtenerUsuario
pers_ncorr_encargado=conexion.consultaUno("Select pers_ncorr from personas where cast(pers_nrut as varchar)='"&usuario&"'")

set f_botonera = new CFormulario
f_botonera.Carga_Parametros "listado_pases.xml", "botonera"
v_peri_ccod = negocio.ObtenerPeriodoAcademico("POSTULACION")
'usuario=negocio.ObtenerUsuario()

'pers_ncorr_encargado=conexion.consultaUno("Select pers_ncorr from personas where cast(pers_nrut as varchar)='"&usuario&"'")
'response.Write(pers_ncorr_encargado)
set lista = new CFormulario
lista.carga_parametros "listado_pases.xml", "list_alumnos1"
lista.inicializar conexion
if paso<>"" then
consulta="select protic.format_rut(d.pers_nrut)as rut, d.pers_tape_paterno+' '+d.pers_tape_materno +' '+ d.pers_tnombre as nombre," & vbCrLf &_ 
		 " e.carr_tdesc as carrera,a.pama_tobservaciones as tipo," & vbCrLf &_ 
		 " cast(DATEPART(day,a.audi_fmodificacion)as varchar)+'-'+cast(DATEPART(month,a.audi_fmodificacion)as varchar)+'-'+cast(DATEPART(year,a.audi_fmodificacion)as varchar)as fecha," & vbCrLf &_ 
		 " case (select count(*)  from alumnos a, ofertas_academicas b, personas c where c.pers_nrut= d.pers_nrut  and c.pers_ncorr=a.pers_ncorr  and a.ofer_ncorr=b.ofer_ncorr  and a.emat_ccod=1  and b.peri_ccod>="&v_peri_ccod&") when 0 then 'No Matriculado' else '<b>Matriculado</b>' end as estado, pa.peri_tdesc" & vbCrLf &_ 
		 " from pase_matricula a, ofertas_academicas b,especialidades c,personas d,carreras e, PERIODOS_ACADEMICOS pa " & vbCrLf &_ 
		 " where a.ofer_ncorr=b.ofer_ncorr" & vbCrLf &_ 
		 " and b.espe_ccod=c.espe_ccod" & vbCrLf &_ 
		 " and c.carr_ccod=e.carr_ccod" & vbCrLf &_ 
		 " and a.pers_ncorr=d.pers_ncorr" & vbCrLf &_ 
		 " and a.peri_ccod = pa.PERI_CCOD "& vbCrLf &_ 
		 " and a.peri_ccod="&v_peri_ccod&" "& vbCrLf &_ 
		 " and b.espe_ccod in(Select espe_ccod from sis_especialidades_usuario where cast(pers_ncorr as varchar)='"&pers_ncorr_encargado&"')"
		 if sede_ccod<>"" and sede_ccod<>"-1" then
		 	consulta=consulta & " and cast(b.sede_ccod as varchar)='"&sede_ccod&"'" 
		 end if
		 if jorn_ccod<>"" and jorn_ccod<>"-1" then	
  		    consulta=consulta & " and cast(b.jorn_ccod as varchar)='"&jorn_ccod&"'"
		 end if
		 if carr_ccod<>"" and carr_ccod<>"-1" then
		    consulta=consulta & " and cast(e.carr_ccod as varchar)='"&carr_ccod&"'"
		 end if
		 if q_pers_nrut<>"" and q_pers_xdv<>"" then
		    consulta=consulta & " and cast(d.pers_nrut as varchar)='"&q_pers_nrut&"'"
		 end if	
else
consulta = "select  pers_ncorr, cast(a.pers_nrut as varchar) as rut,  " &_
            "a.PERS_TAPE_PATERNO+' '+a.PERS_TAPE_MATERNO+' '+a.PERS_TNOMBRE as nombre  " &_ 
            "from personas a  where 1=2"
end if 
'response.Write("<pre>"&consulta&"</pre>")

lista.consultar consulta & " order by nombre"
if lista.nroFilas > 0 then
	cantidad_encontrados=conexion.consultaUno("Select Count(*) from ("&consulta&")a")
else
	cantidad_encontrados=0
end if

'----------------------------------------------------------------------- 
 set f_sedes2 = new CFormulario
 f_sedes2.Carga_Parametros "tabla_vacia.xml", "tabla"
 f_sedes2.Inicializar conexion
 consulta_sedes = "select distinct b.sede_ccod as ccod from ofertas_academicas a, sedes b where cast(peri_ccod as varchar)='"&v_peri_ccod&"' and a.sede_ccod=b.sede_ccod "
 f_sedes2.Consultar consulta_sedes
 while f_sedes2.siguiente
 	if cad_sedes="" then
	   cad_sedes=cad_sedes&f_sedes2.obtenerValor("ccod")
	else
	   cad_sedes=cad_sedes&","&f_sedes2.obtenerValor("ccod")   
	end if
 wend
 '------------------------------------------consultamos las carreras--------------------------------------------------------
 if sede_ccod<>"" and sede_ccod<>"-1" then
		 set f_carreras = new CFormulario
		 f_carreras.Carga_Parametros "tabla_vacia.xml", "tabla"
		 f_carreras.Inicializar conexion
		 consulta_carreras = "Select distinct c.carr_ccod,c.carr_tdesc" & vbCrLf &_ 
         			         " from ofertas_academicas a, especialidades b,carreras c" & vbCrLf &_ 
					  		 " where cast(a.sede_ccod as varchar)='"&sede_ccod&"'" & vbCrLf &_ 
                    		 " and cast(a.peri_ccod as varchar)='"&v_peri_ccod&"'" & vbCrLf &_ 
                    		 " and a.espe_ccod=b.espe_ccod" & vbCrLf &_
							 " and b.espe_ccod in (Select espe_ccod from sis_especialidades_usuario where pers_ncorr='"&pers_ncorr_encargado&"')" & vbCrLf &_
                   		     " and b.carr_ccod=c.carr_ccod" & vbCrLf &_
                             " order by carr_tdesc"
		'response.Write("<br>"&consulta_carreras&"</pre>")
		f_carreras.Consultar consulta_carreras
		
		while f_carreras.siguiente
			if cad_carreras="" then
			    cad_carreras=cad_carreras&f_carreras.obtenerValor("carr_ccod")
			else
		        cad_carreras=cad_carreras&","&f_carreras.obtenerValor("carr_ccod")
		    end if
        wend
 end if
' response.End()
 '-----------------------------------------buscamos las jornadas que pertenecen a la carrera
 if carr_ccod<>"" and carr_ccod<>"-1" then
	  	set f_jornadas = new CFormulario
		f_jornadas.Carga_Parametros "tabla_vacia.xml", "tabla"
		f_jornadas.Inicializar conexion
		consulta_jornadas = "select distinct d.jorn_tdesc,d.jorn_ccod" & vbCrLf &_  
							" from ofertas_academicas a, carreras b,especialidades c, jornadas d " & vbCrLf &_ 
                		    " where cast(b.carr_ccod as varchar)='"&carr_ccod&"'" & vbCrLf &_ 
                    		" and b.carr_ccod=c.carr_ccod" & vbCrLf &_ 
                    		" and c.espe_ccod=a.espe_ccod" & vbCrLf &_ 
                    		" and a.jorn_ccod=d.jorn_ccod" & vbCrLf &_ 
                    		" and cast(a.sede_ccod as varchar)='"&sede_ccod&"'" & vbCrLf &_ 
                    		" and cast(a.peri_ccod as varchar)='"&v_peri_ccod&"'"
		f_jornadas.Consultar consulta_jornadas
		
		while f_jornadas.siguiente
			if cad_jornadas="" then
			    cad_jornadas=cad_jornadas&f_jornadas.obtenerValor("jorn_ccod")
			else
		        cad_jornadas=cad_jornadas&","&f_jornadas.obtenerValor("jorn_ccod")
		    end if
        wend
 end if
 
 'response.Write("sedes "&cad_sedes)
 set f_busqueda = new CFormulario
 f_busqueda.Carga_Parametros "listado_pases.xml", "f_busqueda"
 f_busqueda.Inicializar conexion
 f_busqueda.Consultar "select ''"
 
 if cad_sedes<>"" then
 	   f_busqueda.Agregacampoparam "sede_ccod", "filtro" , "sede_ccod in ("&cad_sedes&")"
 end if
 f_busqueda.AgregaCampoCons "sede_ccod", sede_ccod 
  
 	if  EsVacio(sede_ccod) or sede_ccod="-1" then
  		f_busqueda.Agregacampoparam "carr_ccod", "filtro" , "1=2"
	else
		f_busqueda.Agregacampoparam "carr_ccod", "filtro" , "carr_ccod in ("&cad_carreras&")"
	    f_busqueda.AgregaCampoCons "carr_ccod", carr_ccod 
	end if
	
		
	if EsVacio(carr_ccod) or carr_ccod="-1" then
		f_busqueda.Agregacampoparam "jorn_ccod", "filtro" , "1=2"
	else
		f_busqueda.Agregacampoparam "jorn_ccod", "filtro" , "jorn_ccod in ("&cad_jornadas&")"
	    f_busqueda.AgregaCampoCons "jorn_ccod", jorn_ccod 
	end if
	
	
f_busqueda.Siguiente
f_busqueda.AgregaCampoCons "pers_nrut", q_pers_nrut
f_busqueda.AgregaCampoCons "pers_xdv", q_pers_xdv
'----------------------------------------------------------------------------------------------------------------

consulta_carreras = "Select distinct c.carr_ccod,c.carr_tdesc,a.sede_ccod" & vbCrLf &_ 
                    " from ofertas_academicas a, especialidades b,carreras c" & vbCrLf &_ 
					" where cast(a.peri_ccod as varchar)='"&v_peri_ccod&"'" & vbCrLf &_ 
                    " and a.espe_ccod=b.espe_ccod" & vbCrLf &_
					" and b.espe_ccod in (Select espe_ccod from sis_especialidades_usuario where pers_ncorr='"&pers_ncorr_encargado&"')" & vbCrLf &_
                    " and b.carr_ccod=c.carr_ccod" 
conexion.Ejecuta consulta_carreras
'response.Write("<pre>"&consulta_carreras&"</pre>")
set rec_carreras = conexion.ObtenerRS

consulta_jornadas = "select distinct d.jorn_tdesc,d.jorn_ccod,b.carr_ccod" & vbCrLf &_  
					" from ofertas_academicas a, carreras b,especialidades c, jornadas d " & vbCrLf &_ 
                    " where b.carr_ccod=c.carr_ccod" & vbCrLf &_ 
                    " and c.espe_ccod=a.espe_ccod" & vbCrLf &_ 
                    " and a.jorn_ccod=d.jorn_ccod" & vbCrLf &_ 
                    " and cast(a.peri_ccod as varchar)='"&v_peri_ccod&"'"

conexion.Ejecuta consulta_jornadas
set rec_jornadas=conexion.ObtenerRS

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
function ValidaFormBusqueda()
{
	var formulario = document.buscador;
	var	rut = formulario.elements["busqueda[0][pers_nrut]"].value + '-' + formulario.elements["busqueda[0][pers_xdv]"].value;
	
	if (!valida_rut(rut)) {
		alert('Ingrese un RUT válido.');
		formulario.elements["busqueda[0][pers_xdv]"].select();
		return false;
	}
	return true;
}
function filtrarFacultades(formulario)
{
formulario.paso.value="";
formulario.method="get";
formulario.action="listado_pases.asp";
formulario.submit();
}
function filtrarCarreras(formulario)
{
formulario.paso.value="";
formulario.method="get";
formulario.action="listado_pases.asp";
formulario.submit();
}
function enviar(formulario)
{   var formulario = document.buscador;
	var	rut = formulario.elements["busqueda[0][pers_nrut]"].value + '-' + formulario.elements["busqueda[0][pers_xdv]"].value;
	
	document.buscador.elements("paso").value=1;
	document.buscador.method="get";
	document.buscador.action="listado_pases.asp";

	if  ((formulario.elements["busqueda[0][pers_nrut]"].value!="") && (formulario.elements["busqueda[0][pers_xdv]"].value!="")){
	if (!valida_rut(rut)) {
		alert('Ingrese un RUT válido.');
		formulario.elements["busqueda[0][pers_xdv]"].select();
	}
	else
	document.buscador.submit();
	}
    else
	document.buscador.submit();

}
function salir(){
location.href="../lanzadera/lanzadera_up.asp?resolucion=1152";
}
function MM_nbGroup(event, grpName) { //v6.0
  var i,img,nbArr,args=MM_nbGroup.arguments;
  if (event == "init" && args.length > 2) {
    if ((img = MM_findObj(args[2])) != null && !img.MM_init) {
      img.MM_init = true; img.MM_up = args[3]; img.MM_dn = img.src;
      if ((nbArr = document[grpName]) == null) nbArr = document[grpName] = new Array();
      nbArr[nbArr.length] = img;
      for (i=4; i < args.length-1; i+=2) if ((img = MM_findObj(args[i])) != null) {
        if (!img.MM_up) img.MM_up = img.src;
        img.src = img.MM_dn = args[i+1];
        nbArr[nbArr.length] = img;
    } }
  } else if (event == "over") {
    document.MM_nbOver = nbArr = new Array();
    for (i=1; i < args.length-1; i+=3) if ((img = MM_findObj(args[i])) != null) {
      if (!img.MM_up) img.MM_up = img.src;
      img.src = (img.MM_dn && args[i+2]) ? args[i+2] : ((args[i+1])? args[i+1] : img.MM_up);
      nbArr[nbArr.length] = img;
    }
  } else if (event == "out" ) {
    for (i=0; i < document.MM_nbOver.length; i++) {
      img = document.MM_nbOver[i]; img.src = (img.MM_dn) ? img.MM_dn : img.MM_up; }
  } else if (event == "down") {
    nbArr = document[grpName];
    if (nbArr)
      for (i=0; i < nbArr.length; i++) { img=nbArr[i]; img.src = img.MM_up; img.MM_dn = 0; }
    document[grpName] = nbArr = new Array();
    for (i=2; i < args.length-1; i+=2) if ((img = MM_findObj(args[i])) != null) {
      if (!img.MM_up) img.MM_up = img.src;
      img.src = img.MM_dn = (args[i+1])? args[i+1] : img.MM_up;
      nbArr[nbArr.length] = img;
  } }
}

arr_carreras = new Array();
arr_jornadas = new Array();

<%
rec_carreras.MoveFirst
i = 0
while not rec_carreras.Eof
%>
arr_carreras[<%=i%>] = new Array();
arr_carreras[<%=i%>]["carr_ccod"] = '<%=rec_carreras("carr_ccod")%>';
arr_carreras[<%=i%>]["carr_tdesc"] = '<%=rec_carreras("carr_tdesc")%>';
arr_carreras[<%=i%>]["sede_ccod"] = '<%=rec_carreras("sede_ccod")%>';
<%	
	rec_carreras.MoveNext
	i = i + 1
wend
%>

<%
rec_jornadas.MoveFirst
j = 0
while not rec_jornadas.Eof
%>
arr_jornadas[<%=j%>] = new Array();
arr_jornadas[<%=j%>]["jorn_ccod"] = '<%=rec_jornadas("jorn_ccod")%>';
arr_jornadas[<%=j%>]["jorn_tdesc"] = '<%=rec_jornadas("jorn_tdesc")%>';
arr_jornadas[<%=j%>]["carr_ccod"] = '<%=rec_jornadas("carr_ccod")%>';
<%	
	rec_jornadas.MoveNext
	j = j + 1
wend
%>

function CargarCarreras(formulario, sede_ccod)
{
	formulario.elements["busqueda[0][carr_ccod]"].length = 0;
	op = document.createElement("OPTION");
	op.value = "-1";
	op.text = "Seleccione Carreras";
	formulario.elements["busqueda[0][carr_ccod]"].add(op)
	for (i = 0; i < arr_carreras.length; i++)
	  { 
		if (arr_carreras[i]["sede_ccod"] == sede_ccod)
		 {
			op = document.createElement("OPTION");
			op.value = arr_carreras[i]["carr_ccod"];
			op.text = arr_carreras[i]["carr_tdesc"];
			formulario.elements["busqueda[0][carr_ccod]"].add(op)			
		 }
	}	
}

function CargarJornadas(formulario, carr_ccod)
{
	formulario.elements["busqueda[0][jorn_ccod]"].length = 0;
	op = document.createElement("OPTION");
	op.value = "-1";
	op.text = "Seleccione Jornada";
	formulario.elements["busqueda[0][jorn_ccod]"].add(op)
	for (j = 0; j < arr_jornadas.length; j++)
	  { 
		if (arr_jornadas[j]["carr_ccod"] == carr_ccod)
		 {
			op = document.createElement("OPTION");
			op.value = arr_jornadas[j]["jorn_ccod"];
			op.text = arr_jornadas[j]["jorn_tdesc"];
			formulario.elements["busqueda[0][jorn_ccod]"].add(op)			
		 }
	}	
}

function inicio()
{
  <%if sede_ccod <> "" then%>
    CargarCarreras(buscador, <%=sede_ccod%>);
	buscador.elements["busqueda[0][carr_ccod]"].value ='<%=carr_ccod%>'; 
  <%end if%>
  <%if carr_ccod <> "" then%>
    CargarJornadas(buscador, <%=carr_ccod%>);
	buscador.elements["busqueda[0][jorn_ccod]"].value ='<%=jorn_ccod%>'; 
  <%end if%>
}

</script>

</head>
<body bgcolor="#CC6600" leftmargin="0" topmargin="0" marginwidth="0" marginheight="0" onLoad="MM_preloadImages('../imagenes/botones/buscar_f2.gif','../images/bot_deshabilitar_f2.gif','../images/agregar2_f2_p.gif','../jefe_carrera/im&amp;#225;genes/marco1_r3_c2_f2.gif');MM_preloadImages('../jefe_carrera/im&amp;#225;genes/marco1_r3_c4_f2.gif');MM_preloadImages('../jefe_carrera/im&amp;#225;genes/marco1_r3_c6_f2.gif');MM_preloadImages('../jefe_carrera/im&amp;#225;genes/marco1_r3_c8_f2.gif');MM_preloadImages('../imagenes/botones/cargar_f2.gif','../imagenes/botones/continuar_f2.gif')" onBlur="revisaVentana();" >
<table width="750" border="0" align="center" cellpadding="0" cellspacing="0">
  <tr>
    <td height="72" valign="top"><img src="../imagenes/vineta2_r1_c1.gif" width="750" height="72" border="0"></td>
  </tr>
  <%pagina.DibujarEncabezado()%>  
  <tr>
    <td valign="top" bgcolor="#EAEAEA">
	<br>
	<table width="98%"  border="0" align="center" cellpadding="0" cellspacing="0" bgcolor="#D8D8DE">
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
            <td><form name="buscador" method="get" action="">
              <br><input type="hidden" name="paso" value="">
              <table width="98%"  border="0" align="center">
                <tr>
                  <td width="81%"><div align="center">
                    <table width="100%"  border="0" cellspacing="0" cellpadding="0">
                      <tr>
                        <td width="61"><div align="left"><strong>R.U.T. Alumno</strong></div></td>
                        <td width="20"><div align="center">:</div></td>
                        <td><%f_busqueda.DibujaCampo("pers_nrut")%> 
                            - 
                            <%f_busqueda.DibujaCampo("pers_xdv")%><%pagina.DibujarBuscaPersonas "busqueda[0][pers_nrut]", "busqueda[0][pers_xdv]"%></td>
                        </tr> 
					    <tr>
                        <td width="61"><div align="left"><strong>Sede </strong></div></td>
                        <td width="20"><div align="center">:</div></td>
                        <td width="426"><%f_busqueda.DibujaCampo("sede_ccod")%></td>				
					  </tr>
					  <tr>
                        <td><div align="left"><strong>Carrera </strong></div></td>
                        <td width="20"><div align="center">:</div></td>
                        <td><%f_busqueda.DibujaCampo("carr_ccod")%> 
						    
						</td>	
                      </tr>
					  <tr>
                        <td><div align="left"><strong>Jornada </strong></div></td>
                        <td width="20"><div align="center">:</div></td>
                        <td><%f_busqueda.DibujaCampo("jorn_ccod")%> 
				        </td>	
                      </tr>
				   </table>
                  </div></td>
                  <td width="19%"><div align="center"><%f_botonera.DibujaBoton("buscar")%></div></td>
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
	<br>
	<table width="98%"  border="0" align="center" cellpadding="0" cellspacing="0" bgcolor="#D8D8DE">
      <tr>
        <td width="9" height="8"><img name="top_r1_c1" src="../imagenes/top_r1_c1.gif" width="9" height="8" border="0" alt=""></td>
        <td height="8" background="../imagenes/top_r1_c2.gif"></td>
        <td width="7" height="8"><img name="top_r1_c3" src="../imagenes/top_r1_c3.gif" width="7" height="8" border="0" alt=""></td>
      </tr>
      <tr>
        <td width="9" background="../imagenes/izq.gif">&nbsp;</td>
        <td><table width="100%"  border="0" cellspacing="0" cellpadding="0">
          <tr>
            <td><%pagina.DibujarLenguetas Array("Resultados de la búsqueda"), 1 %></td>
          </tr>
          <tr>
            <td height="2" background="../imagenes/top_r3_c2.gif"></td>
          </tr>
          <tr>
            <td><div align="center"> 
                    <%pagina.DibujarTituloPagina%>
                </div>
              <form name="edicion" method="post" action="">
			  <input type="hidden" name="sede" value="<%=sede_ccod%>">
              <input type="hidden" name="jornada" value="<%=jorn_ccod%>">
			  <input type="hidden" name="carrera" value="<%=carr_ccod%>">
			  <input type="hidden" name="rut" value="<%=q_pers_nrut%>">
                <table width="98%"  border="0" align="center" cellpadding="0" cellspacing="0">
                  <tr>
                    <td><strong>Cantidad Encontrados :&nbsp;&nbsp;</strong><%=cantidad_encontrados%>&nbsp; Alumnos
                      <table width="100%"  border="0" align="center" cellpadding="0" cellspacing="0">
                        <tr>
                             <td align="right">P&aacute;gina:
                                 <%lista.accesopagina%>
                             </td>
                             </tr>
                               <tr>
                                 <td align="center">
                                    <%lista.dibujaTabla()%>
                                  </td>
                             </tr>
							 <tr>
							    <td>&nbsp;
								</td>
							</tr>
                                              </table>
                     </td>
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
            <td width="16%" height="20"><div align="center">
              <table width="90%"  border="0" cellspacing="0" cellpadding="0">
                <tr>
                  <td><div align="center"><%f_botonera.DibujaBoton("salir")%></div></td>
				     <td width="14%"> <div align="center">  <%
					                       f_botonera.agregabotonparam "excel", "url", "listado_pases_excel.asp"
										   f_botonera.dibujaboton "excel"
										%>
					 </div>
                  </td>
                  </tr>
              </table>
            </div></td>
            <td width="84%" rowspan="2" background="../imagenes/abajo_r1_c4.gif"><img src="../imagenes/abajo_r1_c3.gif" width="12" height="28"></td>
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
