<!-- #include file = "../biblioteca/_conexion.asp" -->
<!-- #include file = "../biblioteca/_negocio.asp" -->

<%
'for each x in request.querystring
'	response.Write("<br>"&x&" : "&request.querystring(x))
'next

'response.Write("<br> valor: "&valor)
'response.End()
q_pers_nrut = Request.QueryString("busqueda[0][pers_nrut]")
q_pers_xdv = Request.QueryString("busqueda[0][pers_xdv]")
periodo_combo = Request.QueryString("busqueda[0][peri_ccod]")
carr_ccod= request.QueryString("a[0][carrera]")
condicionales=request.QueryString("condicionales")
peri_acad=request.QueryString("peri_acad")
v_sin_ficha=false
v_mostrar_pase=true
'response.Write("carr "&carr_ccod&" pase_semestral "&pase_semestral)
if pase_semestral="" then
	pase_semestral=0
end if
if peri_acad="" then
	peri_acad=0
end if


'---------------------------------------------------------------------------------------------------
set pagina = new CPagina
pagina.Titulo = "Pase Matricula"

'---------------------------------------------------------------------------------------------------
set conexion = new CConexion
conexion.Inicializar "upacifico"

set negocio = new CNegocio
negocio.Inicializa conexion

'---------------------------------------------------------------------------------------------------
set f_botonera = new CFormulario
f_botonera.Carga_Parametros "pase_matricula.xml", "botonera"

'------------------------------------
periodo=negocio.obtenerPeriodoAcademico("POSTULACION")

if periodo_combo="" then
	periodo_combo=periodo
end if	
'---------------------------------------------------------------------------------------------------
set f_busqueda = new CFormulario
f_busqueda.Carga_Parametros "pase_matricula.xml", "busqueda"
f_busqueda.Inicializar conexion

f_busqueda.Consultar "select ''"
f_busqueda.Siguiente
f_busqueda.AgregaCampoCons "pers_nrut", q_pers_nrut
f_busqueda.AgregaCampoCons "pers_xdv", q_pers_xdv
f_busqueda.AgregaCampoCons "peri_ccod", periodo_combo


'---------------------------------------------------------------------------------------------------

v_peri_ccod = negocio.ObtenerPeriodoAcademico("POSTULACION")
v_pers_ncorr = conexion.consultauno("select pers_ncorr from personas where cast(pers_nrut as varchar)  = '"&q_pers_nrut&"'")		   
ultimo_periodo = conexion.consultaUno(" select top 1 max(b.peri_ccod)as periodo from postulantes a, periodos_academicos b where cast(a.pers_ncorr as varchar)='"&v_pers_ncorr&"' and a.peri_ccod=b.peri_ccod and a.audi_tusuario not like '%ajuste%' order by periodo desc")

ano_periodo = conexion.consultaUno("select anos_ccod from periodos_academicos where cast(peri_ccod as varchar)='"&periodo_combo&"'")

'response.Write(ano_periodo)
' obtiene el post_ncorr actual
v_post_ncorr = conexion.consultaUno("select max(post_ncorr) from postulantes where cast(pers_ncorr as varchar)='"&v_pers_ncorr&"' and cast(peri_ccod as varchar)='"&periodo_combo&"' and epos_ccod=2 and audi_tusuario not like '%ajuste%' ")
' obtiene el post_ncorr de la ultima postulacion del peiodo anterior
'v_post_ncorr = conexion.consultaUno("select post_ncorr from postulantes where cast(pers_ncorr as varchar)='"&v_pers_ncorr&"' and cast(peri_ccod as varchar)='"&ultimo_periodo&"'")
if EsVacio(v_post_ncorr) and request.QueryString()<>"" then
	v_sin_ficha=true
	v_mostrar_pase=false
end if


peri_tdesc = conexion.consultaUno("select peri_tdesc from periodos_academicos where cast(peri_ccod as varchar)='"&periodo_combo&"'")
'response.Write(peri_tdesc)
'********** ANTES DE MRIFFO
'ofer_ncorr=conexion.consultaUno("select ofer_ncorr from postulantes where cast(post_ncorr as varchar)='"&v_post_ncorr&"'")

'********** DESPUES DE MRIFFO (OBTENCION DE LAS OFERTAS)
set f_ofertas_postulantes = new CFormulario
f_ofertas_postulantes.Carga_Parametros "tabla_vacia.xml", "tabla"
f_ofertas_postulantes.Inicializar conexion

sql_ofertas_post="select ofer_ncorr from detalle_postulantes where cast(post_ncorr as varchar)='"&v_post_ncorr&"'"

f_ofertas_postulantes.Consultar sql_ofertas_post

indice=0
filtro_ofertas="''"
while f_ofertas_postulantes.siguiente

	v_oferta=f_ofertas_postulantes.ObtenerValor ("ofer_ncorr")
	
	if indice=0 then
		filtro_ofertas="'"&v_oferta&"'"
	else	
		filtro_ofertas=filtro_ofertas&",'"&v_oferta&"'"
	end if
	indice=indice+1
wend 

'********** Obtener las carreras a las que ha postulado
set f_carreras_postulantes = new CFormulario
f_carreras_postulantes.Carga_Parametros "tabla_vacia.xml", "tabla"
f_carreras_postulantes.Inicializar conexion

sql_ofertas_carr="Select b.carr_ccod,ofer_ncorr from ofertas_Academicas a, especialidades b where cast(a.ofer_ncorr as varchar) in ("&filtro_ofertas&") and a.espe_ccod=b.espe_ccod"
'response.Write(sql_ofertas_carr)
f_carreras_postulantes.Consultar sql_ofertas_carr

indice=0
carrera="''"
while f_carreras_postulantes.siguiente

	v_carr=f_carreras_postulantes.ObtenerValor ("carr_ccod")
	if carr_ccod=v_carr then
		ofer_ncorr=f_carreras_postulantes.ObtenerValor ("ofer_ncorr")
	end if
	if indice=0 then
		carrera="'"&v_carr&"'"
	else	
		carrera=carrera&",'"&v_carr&"'"
	end if
	indice=indice+1
wend 

'*******************************************************************************
sede=negocio.obtenerSede	
'--------------------------------------------------------------------------------------------------

consulta="Select count(*) from alumnos a, ofertas_academicas b where cast(pers_ncorr as varchar)='"&v_pers_ncorr&"' and cast(post_ncorr as varchar)='"&v_post_ncorr&"' and emat_ccod='1' and a.ofer_ncorr=b.ofer_ncorr and b.peri_ccod='"&periodo_combo&"'"
'response.Write("<pre>"&consulta&"</pre>")
estado_alumno=conexion.consultaUno(consulta)
estado_alumno=0

set fc_datos = new CFormulario
fc_datos.Carga_Parametros "pase_matricula.xml", "pase_escolar"
fc_datos.Inicializar conexion
		   
if q_pers_nrut <> "" and q_pers_xdv <> "" then
	filtro = " and cast(b.pers_nrut as varchar)='" & q_pers_nrut & "' and cast(b.pers_xdv as varchar)='" & q_pers_xdv & "'"  
else
	filtro = " "
end if
 
consulta = "select  top 1 a.pers_ncorr, pers_tape_paterno + ' ' +  pers_tape_materno + ' ' + pers_tnombre as alumno," & vbCrLf &_
			"    espe_tdesc,f.carr_ccod, cast(pers_nrut as varchar)  + '-' + pers_xdv as rut, alum_fmatricula" & vbCrLf &_
			" from alumnos a,personas b,postulantes c,ofertas_academicas d,especialidades e,carreras f" & vbCrLf &_
			" where a.pers_ncorr = b.pers_ncorr" & vbCrLf &_
			"    and a.post_ncorr = c.post_ncorr" & vbCrLf &_
			"    and a.ofer_ncorr = d.ofer_ncorr" & vbCrLf &_
			"    and d.espe_ccod = e.espe_ccod" & vbCrLf &_
			"    and e.carr_ccod = f.carr_ccod" & vbCrLf &_
			"    and emat_ccod = '1'" & vbCrLf &_
			"    and cast(c.peri_ccod as varchar)<> '" & periodo_combo &  "' " & vbCrLf &_
			"" & filtro & ""& vbCrLf &_
			"order by f.carr_ccod asc"
'response.Write("<pre>"&consulta&"</pre> CARRERA:"&carr_ccod&"")
 
'response.End()
fc_datos.Consultar consulta
encontrado=fc_datos.nroFilas
fc_datos.siguiente
fc_datos.AgregaCampoCons "carrera",carr_ccod
fc_datos.AgregaCampoParam "carrera","filtro"," cast(carr_ccod as varchar) in ("&carrera&")"
'response.Write(fc_datos.nrofilas)
'-----------------------------------------contamos la cantidad de registros que hay en la tabla alumnos----------------------------
'-------------para saber la cantidad de años que dicho alumno lleva en la universidad ---------------------------------------------
tipo_carrera=conexion.consultaUno("select b.ttit_ccod from ofertas_academicas a, especialidades b where cast(a.ofer_ncorr as varchar)='"&ofer_ncorr&"' and a.espe_ccod=b.espe_ccod")
'ver si la carrera es profesional o técnica y si es profesional se revisa si la cantidad de años que lleva son + de 4 en el caso de ser técnica se revisa si son mas de 2
primer_ano=conexion.consultaUno("Select DATEDIFF(year,alum_fmatricula,getDate()) from alumnos  where cast(pers_ncorr as varchar)='"&v_pers_ncorr&"' order by alum_fmatricula asc")
'se calcula la diferencia entre la primera vez que el alumno se matriculo y la fecha actual

if q_pers_nrut<>"" and q_pers_xdv<>"" then

	if condicionales ="" then
		sql="Select pama_tipo_pase from pase_matricula where cast(post_ncorr as varchar)='"&v_post_ncorr&"' and cast(pers_ncorr as varchar)='"&v_pers_ncorr&"' and cast(peri_ccod as varchar)='"&periodo_combo&"'"
		'response.write sql
		condicionales=conexion.consultaUno(sql)
		
	end if
	if condicionales = "1" then ' Nueva condicion para tipo pase semestral 26-10-2015 Rpavez
		
		sql2 = "Select pama_ncorr from pase_matricula where cast(post_ncorr as varchar)='"&v_post_ncorr&"' and cast(pers_ncorr as varchar)='"&v_pers_ncorr&"' and cast(peri_ccod as varchar)='"&periodo_combo&"'"
		
		pama_ncorr = conexion.consultaUno(sql2)
	
		if isnull(pama_ncorr) then
			pama_ncorr = 0
		end if
		'response.write sql2
		
		pase_semestral = conexion.consultaUno("select pmse_tipo_pase from pase_matricula_semestral where pama_ncorr="&pama_ncorr&"")
		'response.Write("select pmse_tipo_pase from pase_matricula_semestral where pama_ncorr="&pama_ncorr&"")
		'response.End()
		if isnull(pase_semestral) then
			pase_semestral = 0
		end if
	end if
	'response.Write("condicionales "&condicionales)
	'response.Write("<br>pase_semestral: "&pase_semestral)
	'response.End()
end if
'response.End()
if carr_ccod<>"" and condicionales<>"" and estado_alumno="0" then
'valor_matricula=conexion.consultaUno("select aran_mmatricula from aranceles where cast(carr_ccod as varchar)='"&carr_ccod&"' and cast(peri_ccod as varchar)='"&periodo&"' and cast(jorn_ccod as varchar)='"&jorn_ccod&"'")
'valor_arancel=conexion.consultaUno("select aran_mcolegiatura from aranceles where cast(carr_ccod as varchar)='"&carr_ccod&"' and cast(peri_ccod as varchar)='"&periodo&"' and cast(jorn_ccod as varchar)='"&jorn_ccod&"'")
'response.Write("matricula "&valor_matricula&" arancel "&valor_arancel)

	if condicionales="1" then
		total_beneficio=0'clng(valor_arancel)/2
		matricula_bene=0
		matricula_porc=0
		arancel_bene=0'clng(valor_arancel)/2
		arancel_porc=50
	elseif condicionales="2" then
	    total_beneficio=0
		matricula_bene=0
		matricula_porc=0
		arancel_bene=0
		arancel_porc=0	
	elseif condicionales="3" then
	    total_beneficio=0'clng(valor_arancel)
		matricula_bene=0
		matricula_porc=0
		arancel_bene=0'valor_arancel
		arancel_porc=100
	elseif condicionales="4" then
	    total_beneficio=0'clng(valor_arancel)
		matricula_bene=0
		matricula_porc=0
		arancel_bene=0'valor_arancel
		arancel_porc=100		
	elseif condicionales="5" then
	    total_beneficio=0'clng(valor_arancel)/2
		matricula_bene=0
		matricula_porc=0
		arancel_bene=0'clng(valor_arancel)/2
		arancel_porc=50	
	elseif condicionales="6" then
	    total_beneficio=0'clng(valor_arancel)/2
		matricula_bene=0
		matricula_porc=0
		arancel_bene=0'clng(valor_arancel)/2
		arancel_porc=50			
	end if
end if
'response.Write("cantidad_anos "&cantidad_anos)


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

//lanza Mensajes.
function agregaTexto(valor)
{
	//document.getElementById("auxTexto").innerHTML = "Valor = ";// + valor;
	//pase_semestral = semestre;
	//alert(valor);
	if(valor=="") {
		document.getElementById("auxTexto").innerHTML = "";
		document.getElementById("auxPeri").innerHTML = "";
		document.getElementById("nomPeri").innerHTML = "";
	}
	if(valor==1) {
		semestre = <%=pase_semestral%>;
		peri_acad = <%=peri_acad%>;
		//alert(peri_acad);
		if ((semestre!=peri_acad)&&(peri_acad!=0)){
			semestre = peri_acad;
		}
		//alert(semestre);
	document.getElementById("auxTexto").innerHTML = "Seleccionaste \"hasta 2 Asignaturas\".<br> Este Pase Matrícula equivale a pagar valor de matrícula y 50% de arancel anual.";
	switch(semestre) {
		case 0:
		document.getElementById("auxPeri").innerHTML = "<select name='peri_acad'><option value='1' selected>Primer Semestre</option><option value='2'>Segundo Semestre</option><option value='3' >Ambos Semestres</option></select>";
		break;
		case 1:
		document.getElementById("auxPeri").innerHTML = "<select name='peri_acad'><option value='1' selected>Primer Semestre</option><option value='2'>Segundo Semestre</option><option value='3' >Ambos Semestres</option></select>";
		break;
		case 2:
		document.getElementById("auxPeri").innerHTML = "<select name='peri_acad'><option value='1'>Primer Semestre</option><option value='2' selected>Segundo Semestre</option><option value='3'>Ambos Semestres</option></select>";
		break;
		case 3:
		document.getElementById("auxPeri").innerHTML = "<select name='peri_acad'><option value='1'>Primer Semestre</option><option value='2'>Segundo Semestre</option><option value='3' selected>Ambos Semestres</option></select>";
		break;
	}
	document.getElementById("nomPeri").innerHTML = "Periodo";
	}
	if(valor==2) {
	document.getElementById("auxTexto").innerHTML = "Seleccionaste \"desde 3 Asignaturas\".<br> Este Pase Matrícula equivale a pagar valor de matrícula y arancel anual.";
	}
	if(valor==3) {
	document.getElementById("auxTexto").innerHTML = "Seleccionaste \"Práctica Profesional\".<br> Este Pase Matrícula equivale a pagar sólo valor de matrícula.<br> En caso de carreras profesionales pagar además arancel de titulación.";
	}
	if(valor==4) {
	document.getElementById("auxTexto").innerHTML = "Seleccionaste \"Examen de título por rendir\".<br> Este Pase Matrícula corresponde a los alumnos con Examen de Título pendiente o inconcluso.<br> Equivale a pagar valor de matrícula y arancel de título.";
	}
	if(valor==5) {
	document.getElementById("auxTexto").innerHTML = "Seleccionaste \"Alumno último semestre\".<br> Este Pase Matrícula corresponde a los alumnos que completan la malla curricular el primer semestre, pudiendo quedar pendiente la práctica profesional y/o examen de Título.<br> Equivale a pagar el valor matrícula y 50% arancel anual.";
	}
	if(valor==6) {
	document.getElementById("auxTexto").innerHTML = "Seleccionaste \"Alumno con Carga Académica 2do. Semestre.<br> Este Pase Matrícula corresponde a los alumnos que tienen carga académica solo en el segundo semestre, no permite inscribir asignaturas en el prímero.<br> Equivale a pagar el valor matrícula y 50% arancel anual.";
	}
	
}
function ValidaFormBusqueda()
{
	var formulario = document.buscador;
	peri_combo = formulario.elements["busqueda[0][peri_ccod]"].value;
	peri_text = formulario.elements["busqueda[0][peri_ccod]"].options[formulario.elements["busqueda[0][peri_ccod]"].selectedIndex].text;
	periodo_sga = <%=periodo%>;
	if (peri_combo!=periodo_sga){
		msj = "Emitira un pase matricula para el "+ peri_text;
	}else{
		msj = "Emitira un pase matricula para el "+ peri_text;
	}
	if (confirm(msj)){
		
		var	rut = formulario.elements["busqueda[0][pers_nrut]"].value + '-' + formulario.elements["busqueda[0][pers_xdv]"].value;
	
		if (!valida_rut(rut)) {
			alert('Ingrese un RUT válido.');
			formulario.elements["busqueda[0][pers_xdv]"].select();
			return false;
		}
	
		return true;
	}else{
		return false;
	}
	
}

function valida(){
var formulario=document.edicion;
tipo_nuevo=formulario.elements["condicionales"].value;
tipo_guardado=formulario.elements["tipo"].value;
	if (tipo_nuevo!=tipo_guardado)
		{alert("Presione nuevamente el botón calcular para considerar los últimos cambios");
         return false;}
return true;		 
}

function calcular()
{ var formulario; 
  formulario=document.edicion;
  formulario.method="GET";
  formulario.action="pase_matricula.asp"
  formulario.submit();
  //alert("Comenzando el cálculo");
}

function mensaje(numero)
{  
    if(numero==1){
		alert("El usuario al que pertenece el RUT no registra información de matriculas anteriores");
	}
	if(numero==2){
		alert("El alumno solicitado ya se encuentra matriculado, ya no se pueden generar pases de matricula para el");
	}
	if(numero==3){
		alert("El alumno no presenta una postulación para este período académico.\n\n (*) Comuniquese con el departamento de computación para mayor información.");
	}
    var formulario = document.buscador;
	formulario.elements("busqueda[0][pers_nrut]").focus();
}

</script>

</head>
<body bgcolor="#CC6600" leftmargin="0" topmargin="0" marginwidth="0" marginheight="0" onLoad="agregaTexto(<%=condicionales%>); MM_preloadImages('../imagenes/botones/buscar_f2.gif','../images/bot_deshabilitar_f2.gif','../images/agregar2_f2_p.gif','../matricula/im&amp;#225;genes/marco1_r3_c2_f2.gif');MM_preloadImages('../matricula/im&amp;#225;genes/marco1_r3_c4_f2.gif');MM_preloadImages('../matricula/im&amp;#225;genes/marco1_r3_c6_f2.gif');MM_preloadImages('../matricula/im&amp;#225;genes/marco1_r3_c8_f2.gif');MM_preloadImages('../imagenes/botones/cargar_f2.gif','../imagenes/botones/continuar_f2.gif')" onBlur="revisaVentana();">
<table width="750" height="50%" border="0" align="center" cellpadding="0" cellspacing="0">
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
        <td><table width="100%"  border="0" cellspacing="0" cellpadding="0">
          <tr>
            <td><%pagina.DibujarLenguetas Array("Buscador"), 1 %></td>
          </tr>
          <tr>
            <td height="2" background="../imagenes/top_r3_c2.gif"></td>
          </tr>
          <tr>
            <td><form name="buscador">
              <br>
              <table width="98%"  border="0" align="center">
                <tr>
                  <td width="81%"><div align="center">
                    <table width="90%"  border="0" cellspacing="0" cellpadding="0">
                     
                      <tr>
                        <td><div align="right">R.U.T. Alumno </div></td>
                        <td width="7%"><div align="center">:</div></td>
                        <td><%f_busqueda.DibujaCampo("pers_nrut")%> 
                          - 
                          <%f_busqueda.DibujaCampo("pers_xdv")%><%pagina.DibujarBuscaPersonas "busqueda[0][pers_nrut]", "busqueda[0][pers_xdv]"%></td>
                      </tr>
                       <tr>
                         <td>&nbsp;</td>
                         <td><br /></td>
                         <td>&nbsp;</td>
                       </tr>
                       <tr>
                        <td><div align="right">Periodo Academico </div></td>
                        <td><div align="center">:</div></td>
                        <td><%f_busqueda.DibujaCampo("peri_ccod")%> </td>
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
	<br><% if q_pers_nrut <>"" and encontrado > 0  and estado_alumno="0" and v_mostrar_pase=true then 'and aceptado=true then %>
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
            <td><%pagina.DibujarLenguetas Array("Resultados de la búsqueda"), 1 %></td>
          </tr>
          <tr>
            <td height="2" background="../imagenes/top_r3_c2.gif"></td>
          </tr>
          <tr>
            <td><div align="center"><br>
              <%pagina.DibujarTituloPagina%><br>              
                </div>
				<br><%pagina.DibujarSubtitulo "Informacion Alumno"%>	<br>
				<table width="98%"  border="0" align="center" cellpadding="0" cellspacing="0">
                <form name="edicion">
				<input type="hidden" name="busqueda[0][pers_nrut]" value="<%=q_pers_nrut%>">
				<input type="hidden" name="busqueda[0][pers_xdv]" value="<%=q_pers_xdv%>">
				<input type="hidden" name="total_beneficio" value="<%=total_beneficio%>">
				<input type="hidden" name="matricula_bene" value="<%=matricula_bene%>">
		        <input type="hidden" name="matricula_porc"  value="<%=matricula_porc%>">
				<input type="hidden" name="arancel_bene" value="<%=arancel_bene%>">
		        <input type="hidden" name="arancel_porc" value="<%=arancel_porc%>">
				<input type="hidden" name="post_ncorr" value="<%=v_post_ncorr%>">
				<input type="hidden" name="ofer_ncorr" value="<%=ofer_ncorr%>">
				<input type="hidden" name="pers_ncorr" value="<%=v_pers_ncorr%>">
				<input type="hidden" name="peri_ccod" value="<%=periodo_combo%>">
				<input type="hidden" name="tipo" value="<%=condicionales%>">
                <input type="hidden" name="tipo2" value="<%=peri_acad%>">
				<tr>
                  <td width="134" height="25"><strong>Rut Alumno</strong></td>
                  <td width="9"><strong>:</strong></td>
                  <td colspan="5"><%=fc_datos.DibujaCampo("rut")%></td>
                </tr>
				  <tr>
                  <td width="134" height="25"><strong>Nombre</strong></td>
                  <td width="9"><strong>:</strong></td>
                  <td colspan="5"><%=fc_datos.DibujaCampo("alumno")%></td>
                </tr>
				  <tr>
                  <td width="134" height="25"><strong>Carreras</strong></td>
                  <td width="9"><strong>:</strong></td>
                  <td colspan="5"><%=fc_datos.DibujaCampo("carrera")%></td>
                </tr>
				<tr>
                  <td width="134" height="25"><strong>Pase Matr&iacute;cula</strong></td>
                  <td width="9"><strong>:</strong></td>
                  <td width="172"><select name="condicionales" onChange="agregaTexto(this.value);" >
				   <%if condicionales="" then%>
                    <option value="" selected>Seleccione una Condición</option>
                    <%else%>
                    <option value="">Seleccione una Condición</option>
                    <%end if%>
                    <%if condicionales="1" then%>
                    <option value="1" selected>Hasta 2 Asignaturas</option>
                    <%else%>
                    <option value="1">Hasta 2 Asignaturas</option>
                    <%end if%>
                    <%if condicionales="2" then%>
                    <option value="2" selected>Desde 3 Asignaturas</option>
                    <%else%>
                    <option value="2">Desde 3 Asignaturas</option>
                    <%end if%>
                    <%if condicionales="3" then%>
                    <option value="3" selected>Práctica Profesional</option>
                    <%else%>
                    <option value="3">Práctica Profesional</option>
                    <%end if%>
                    <%if condicionales="4" then%>
                    <option value="4" selected>Examen de Título por rendir</option>
                    <%else%>
                    <option value="4">Examen de Título por rendir</option>
                    <%end if%>
                     <%if condicionales="5" then%>
                    <option value="5" selected>Alumno Último semestre</option>
                    <%else%>
                    <option value="5">Alumno Último semestre</option>
                    <%end if%>
                    <%if condicionales="6" then%>
                    <option value="6" selected>Alumno con Carga Académica 2do. Semestre</option>
                    <%else%>
                    <option value="6">Alumno con Carga Académica 2do. Semestre</option>
                    <%end if%>
                  </select></td>
	                <td  valign="top" colspan="4"><div align="justify"><%f_botonera.DibujaBoton("calcular")%></div></td>
                    </tr>
                    <tr>
                      <td><strong><span id="nomPeri"></span></strong></td>
                      <td></td>
                      <td colspan="4"><span style="color:#0033FF" id="auxPeri"></span> </td>
                    </tr>
                    <tr>
                    <td></td>
                    <td></td>
        			<td colspan="4"><span style="color:#0033FF" id="auxTexto"></span></td>
                    </tr>
					<%if total_beneficio <>"" then%>
					<tr> 
                      <td width="134" height="25"><strong> Descuento Matr&iacute;cula</strong></td>
                      <td width="9"><strong>:</strong></td>
                      <td colspan="2"><font color="#0000FF" ><%=matricula_porc%> %</font> </td>
					  <td width="150" height="25"><strong> Descuento Colegiatura</strong></td>
                      <td width="4"><strong>:</strong></td>
                      <td width="176"><font color="#0000FF" ><%=arancel_porc%>%</font> </td>
                    </tr>
					<%end if%>
					<% if ano_periodo < "2006" and q_pers_nrut <> "" then %>
					<tr> 
                      <td colspan="7">&nbsp;</td>
                    </tr>
					<tr> 
                      <td colspan="7" align="center"><font size="2"><strong>No puede generar un pase de matricula para el año <%=ano_periodo%>. <br>
					  Debe seleccionar, en el menú superior, la actividad postulación y el periodo Primer Semestre 2006.</strong></font></td>
                    </tr>
					<%end if%>
			   </form>
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
            <td width="28%" height="20"><div align="center">
              <table width="90%"  border="0" cellspacing="0" cellpadding="0">
                <tr>
                  <td><div align="center"><% if total_beneficio="" or (ano_periodo < "2006" and q_pers_nrut <> "") then
				         						f_botonera.agregabotonparam "guardar", "deshabilitado" ,"TRUE"
				    						 end if
				                            f_botonera.DibujaBoton("guardar")%></div></td>
                  <td><div align="center">
                    <%f_botonera.DibujaBoton("salir")%>
                  </div></td>
                  </tr>
              </table>
            </div></td>
            <td width="72%" rowspan="2" background="../imagenes/abajo_r1_c4.gif"><img src="../imagenes/abajo_r1_c3.gif" width="12" height="28"></td>
            </tr>
          <tr>
            <td height="8" background="../imagenes/abajo_r2_c2.gif"></td>
          </tr>
        </table></td>
        <td width="7" height="28"><img src="../imagenes/abajo_r1_c5.gif" width="7" height="28"></td>
      </tr>
    </table><%end if%>
	<br>
	<br>
	</td>
  </tr>  
</table>

</body>
</html>
<% if q_pers_nrut <>"" and encontrado = 0 and estado_alumno="0" then 
	response.Write("<script language='JavaScript'>")
	response.Write("mensaje(1);")
	response.Write("</script>")
   elseif q_pers_nrut <>"" and encontrado <> 0 and estado_alumno>"0" then 
	response.Write("<script language='JavaScript'>")
	response.Write("mensaje(2);")
	response.Write("</script>")
	elseif v_sin_ficha=true then
		response.Write("<script language='JavaScript'>")
		response.Write("mensaje(3);")
		response.Write("</script>")	
end if
%>