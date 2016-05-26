<!-- #include file = "../biblioteca/_conexion.asp" -->
<!-- #include file = "../biblioteca/_negocio.asp" -->

<%
'for each k in request.form
'	response.Write(k&" = "&request.Form(k)&"<br>")
'next

set pagina = new CPagina
pagina.Titulo = "Datos Personales"

'---------------------------------------------------------------------------------------------------
pers_ncorr = request("pers_ncorr")
rut = request("rut")
dv = request("dv")
'RESPONSE.Write("RUT "&rut&" dv "&dv)
set negocio = new CNegocio
set conectar = new CConexion
set formulario = new CFormulario

conectar.inicializar "upacifico"
formulario.carga_parametros "editar_docente.xml", "edicion_docente"
formulario.inicializar conectar
negocio.inicializa conectar
sede=negocio.obtenerSede

if (isnull(pers_ncorr) or isempty(pers_ncorr) or pers_ncorr = "") and (rut="" or isempty(rut) or isnull(rut)) then
	pers_ncorr = conectar.consultauno("select pers_ncorr from personas where cast(pers_nrut as varchar)= '"&negocio.obtenerusuario&"'" )
	session("sin_pers_ncorr")= 1
end if

if rut = "" then

    direc_laboral=conectar.consultauno("select count(*) from direcciones where cast(pers_ncorr as varchar)='"&pers_ncorr&"' and tdir_ccod=3")
	perso = " select '"&sede&"' as sede_ccod,C.PROF_HORAS_CONTRATADAS,a.TDIR_CCOD,a.CIUD_CCOD,a.DIRE_TCALLE,a.DIRE_TNRO, " &vbCrlf &_
			" a.DIRE_TPOBLACION,a.DIRE_TBLOCK,a.DIRE_TDEPTO,a.DIRE_TLOCALIDAD,a.DIRE_TFONO,  " &vbCrlf &_
			" a.DIRE_TCELULAR,c.*,b.pais_ccod, pers_nrut as rut, pers_xdv as dv,b.*,   " &vbCrlf &_
			" d.TDIR_CCOD as TDIR_CCOD_laboral,d.CIUD_CCOD as CIUD_CCOD_laboral,d.DIRE_TCALLE as DIRE_TCALLE_laboral,d.DIRE_TNRO as DIRE_TNRO_laboral, " &vbCrlf &_
			" d.DIRE_TPOBLACION,d.DIRE_TBLOCK,d.DIRE_TDEPTO,d.DIRE_TLOCALIDAD,d.DIRE_TFONO,  " &vbCrlf &_
			" d.DIRE_TCELULAR as DIRE_TCELULAR_laboral " &vbCrlf &_
			" from personas b, direcciones a, profesores c,direcciones d   " &vbCrlf &_
			" where a.pers_ncorr=b.pers_ncorr  " &vbCrlf &_
			" and b.pers_ncorr = c.pers_ncorr  "
			if direc_laboral > "0" then
			perso=perso & " and d.pers_ncorr=b.pers_ncorr and d.tdir_ccod = 3 " 
			end if
			perso=perso & " and cast(b.pers_ncorr as varchar)='"&pers_ncorr&"'  " &vbCrlf &_
			" and a.tdir_ccod=1 " &vbCrlf &_
			" and cast(c.sede_ccod as varchar)='"&sede&"' " 
else
    pers_ncorr = conectar.ConsultaUno("select pers_ncorr from personas where cast(pers_nrut as varchar) = '"&rut&"'")
    direc_laboral=conectar.consultauno("select count(*) from direcciones where cast(pers_ncorr as varchar)='"&pers_ncorr&"' and tdir_ccod=3")
	if pers_ncorr<>"" then
	    perso= " select top 1 '"&sede&"' as sede_ccod,C.PROF_HORAS_CONTRATADAS,a.TDIR_CCOD,a.CIUD_CCOD,a.DIRE_TCALLE,a.DIRE_TNRO, " &vbCrlf &_
			" a.DIRE_TPOBLACION,a.DIRE_TBLOCK,a.DIRE_TDEPTO,a.DIRE_TLOCALIDAD,a.DIRE_TFONO,  " &vbCrlf &_
			" a.DIRE_TCELULAR,c.*,b.pais_ccod, pers_nrut as rut, pers_xdv as dv,b.*,   " &vbCrlf &_
			" d.TDIR_CCOD as TDIR_CCOD_laboral,d.CIUD_CCOD as CIUD_CCOD_laboral,d.DIRE_TCALLE as DIRE_TCALLE_laboral,d.DIRE_TNRO as DIRE_TNRO_laboral, " &vbCrlf &_
			" d.DIRE_TPOBLACION,d.DIRE_TBLOCK,d.DIRE_TDEPTO,d.DIRE_TLOCALIDAD,d.DIRE_TFONO,  " &vbCrlf &_
			" d.DIRE_TCELULAR as DIRE_TCELULAR_laboral " &vbCrlf &_
			" from personas b, direcciones a,profesores c,direcciones d " &vbCrlf &_
			" where b.pers_ncorr *= c.pers_ncorr" &vbCrlf &_
			" and b.pers_ncorr=a.pers_ncorr " 
			if direc_laboral > "0" then
			perso=perso & " and d.pers_ncorr=b.pers_ncorr and d.tdir_ccod = 3 " 
			end if
			perso=perso & " and cast(b.pers_nrut as varchar)='" & rut &"'"&vbCrlf &_
			" and a.tdir_ccod=1" &vbCrlf &_
			" and cast(c.sede_ccod as varchar)='" & sede & "'"				
	else	
	perso= " select '"&sede&"' as sede_ccod,C.PROF_HORAS_CONTRATADAS,a.TDIR_CCOD,a.CIUD_CCOD,a.DIRE_TCALLE,a.DIRE_TNRO, " &vbCrlf &_
			" a.DIRE_TPOBLACION,a.DIRE_TBLOCK,a.DIRE_TDEPTO,a.DIRE_TLOCALIDAD,a.DIRE_TFONO,  " &vbCrlf &_
			" a.DIRE_TCELULAR,c.*,b.pais_ccod, pers_nrut as rut, pers_xdv as dv,b.*,   " &vbCrlf &_
			" d.TDIR_CCOD as TDIR_CCOD_laboral,d.CIUD_CCOD as CIUD_CCOD_laboral,d.DIRE_TCALLE as DIRE_TCALLE_laboral,d.DIRE_TNRO as DIRE_TNRO_laboral, " &vbCrlf &_
			" d.DIRE_TPOBLACION,d.DIRE_TBLOCK,d.DIRE_TDEPTO,d.DIRE_TLOCALIDAD,d.DIRE_TFONO,  " &vbCrlf &_
			" d.DIRE_TCELULAR as DIRE_TCELULAR_laboral " &vbCrlf &_
			" from personas b, direcciones a,profesores c,direcciones d " &vbCrlf &_
			" where c.pers_ncorr=b.pers_ncorr " &vbCrlf &_
			" and b.pers_ncorr=a.pers_ncorr " 
			if direc_laboral > "0" then
			perso=perso & " and d.pers_ncorr=b.pers_ncorr and d.tdir_ccod = 3 " 
			end if
			perso=perso & " and cast(b.pers_nrut as varchar)='" & rut &"'"&vbCrlf &_
			" and a.tdir_ccod=1" &vbCrlf &_
			" and cast(c.sede_ccod as varchar)='" & sede & "'"				
	end if		
	
	 'if EsVacio(pers_ncorr) then
	 	'pers_ncorr = conectar.ConsultaUno("select pers_ncorr_seq.nextval from dual")
	' end if
end if
'response.Write("<pre>"&perso&"</pre>")

formulario.consultar perso


if rut <> "" and dv <> "" then
	formulario.agregacampocons "pers_nrut", rut
	formulario.agregacampocons "pers_xdv", dv
	formulario.agregacampocons "rut", rut
	formulario.agregacampocons "dv", dv
	formulario.agregacampocons "sede_ccod", sede
'response.Write("<pre>"&perso&"</pre> <br> pers_ncorr="&pers_ncorr)
'response.End()
end if
formulario.agregacampocons "pers_ncorr", pers_ncorr


formulario.siguiente





'---------------------------------------------------------------------------------------------------
set f_botonera = new CFormulario
f_botonera.Carga_Parametros "editar_docente.xml", "botonera"
lenguetas_masignaturas = Array(Array("Informacion Docente", "editar_docente.asp?pers_ncorr="&pers_ncorr&"&rut="&rut&"&dv="&dv),Array("Antecedentes Profesionales", "perfeccionamiento.asp?pers_ncorr="&pers_ncorr&"&rut="&rut&"&dv="&dv),Array("Antecedentes Academicos", "grado_academico.asp?pers_ncorr="&pers_ncorr&"&rut="&rut&"&dv="&dv), Array("Experiencia Laboral", "experiencia_laboral.asp?pers_ncorr="&pers_ncorr&"&rut="&rut&"&dv="&dv),Array("Experiencia Docente", "experiencia_docente.asp?pers_ncorr="&pers_ncorr&"&rut="&rut&"&dv="&dv))
%>


<html>
<head>
<title>Informaci&oacute;n del Docente</title>
<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1">
<link href="../estilos/estilos.css" rel="stylesheet" type="text/css">
<link href="../estilos/tabla.css" rel="stylesheet" type="text/css">

<script language="JavaScript" src="../biblioteca/tabla.js"></script>
<script language="JavaScript" src="../biblioteca/funciones.js"></script>
<script language="JavaScript" src="../biblioteca/validadores.js"></script>

<script language="JavaScript">
function edad(formulario){
var fecha = new Date();
var ing = MM_findObj('m[0][pers_fnacimiento]',formulario);
y=ing.value.substr(6,4);
m=ing.value.substr(3,2)
d=ing.value.substr(0,2)
dia=fecha.getDate();
mes=fecha.getMonth();
agno=fecha.getFullYear();
aa=agno-y;
mm=mes+1-m;
dd=dia-d;
	if (mm > 1){
		a=aa
	}
	else{
		if ((mm=0) || (dd>=0)){
			aa=aa
		}
		else{
			aa=aa-1
		}
	}
	if (aa>=18){
		return (true);
	}
	else{
		return (false);
	}

}


function ValidaForm(formulario, pagina)
{
	formulario.pag.value = pagina;
	
	if (!edad(formulario)) {
		alert('Edad del docente: ' + aa + '  años.\nPor favor revise la fecha de nacimiento.')
		return false;
	}
	
	return true;
}


function enviar(formulario, pagina){
	formulario.pag.value=pagina;
	
	if(preValidaFormulario(formulario)){
		if (edad(formulario)) {
			formulario.action ='actualizar_docente.asp';	  
		  	formulario.submit();
		}
		else{
			alert('Edad del docente: ' + aa + '  años.\nPor favor revise la fecha de nacimiento.') 
		}
	}
}




</script>

<style type="text/css">
<!--
.style4 {font-size: 10px}
.style6 {font-size: 10px; color: #333333; }
.Estilo1 {color: #FF0000}
-->
</style>
</head>
<body bgcolor="#cc6600" leftmargin="0" topmargin="0" marginwidth="0" marginheight="0" onLoad="MM_preloadImages('../imagenes/botones/buscar_f2.gif','../images/bot_deshabilitar_f2.gif','../images/agregar2_f2_p.gif','im&amp;#225;genes/marco1_r3_c2_f2.gif');MM_preloadImages('im&amp;#225;genes/marco1_r3_c4_f2.gif');MM_preloadImages('im&amp;#225;genes/marco1_r3_c6_f2.gif');MM_preloadImages('im&amp;#225;genes/marco1_r3_c8_f2.gif');MM_preloadImages('../imagenes/botones/cargar_f2.gif','../imagenes/botones/continuar_f2.gif')" onBlur="revisaVentana();">
<table width="750" border="0" align="center" cellpadding="0" cellspacing="0">
  <tr>
    <td><img src="../imagenes/vineta2_r1_c1.gif" width="750" height="62" border="0"></td>
  </tr>
  <%pagina.DibujarEncabezado()%>  
  <tr>
    <td valign="top" bgcolor="#EAEAEA">
	<br>
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
                <td background="../imagenes/top_r1_c2.gif"><img src="../imagenes/top_r1_c2.gif" alt="" name="top_r1_c2" width="670" height="8" border="0"></td>
                <td><img name="top_r1_c3" src="../imagenes/top_r1_c3.gif" width="7" height="8" border="0" alt=""></td>
              </tr>
              <tr>
                <td><img name="top_r2_c1" src="../imagenes/top_r2_c1.gif" width="9" height="17" border="0" alt=""></td>
                <td><table width="100%" border="0" cellspacing="0" cellpadding="0">
                  <tr>
                   
                    <td bgcolor="#D8D8DE"><%pagina.DibujarLenguetas lenguetas_masignaturas, 1%></td>
                  </tr>
                </table></td>
                <td><img name="top_r2_c3" src="../imagenes/top_r2_c3.gif" width="7" height="17" border="0" alt=""></td>
              </tr>
              <tr>
                <td height="3"><img name="top_r3_c1" src="../imagenes/top_r3_c1.gif" width="9" height="2" border="0" alt=""></td>
                <td><img name="top_r3_c2" src="../imagenes/top_r3_c2.gif" width="670" height="2" border="0" alt=""></td>
                <td><img name="top_r3_c3" src="../imagenes/top_r3_c3.gif" width="7" height="2" border="0" alt=""></td>
              </tr>
            </table>
              <table width="100%" border="0" cellspacing="0" cellpadding="0">
                <tr>
                  <td width="9" align="left" background="../imagenes/izq.gif">&nbsp;</td>
                  <td bgcolor="#D8D8DE">
				    &nbsp;
				    <form name="editar" method="post">
					  
					  <input type="hidden" name="pag" value="">
					  <input type="hidden" name="pers_ncorr" value=<%=pers_ncorr%>>
					  <input type="hidden" name="pers_nrut" value=<%=formulario.obtenervalor("pers_nrut")%>>
					  					
					  <br><div align="center"> 
                              <%pagina.DibujarTituloPagina%>
                          </div>
					  <table width="85%" align="center">
                        <tr> 
                          <td width="3%"><font color="#CC3300">&nbsp;</font></td>
                          <td width="40%" align="left">&nbsp;</td>
                          <td colspan="4" align="right"><font color="#CC3300">*</font> 
                            Campos Obligatorios</td>
                        </tr>
                        <tr> 
                          <td><font color="#CC3300">*</font></td>
                          <td align="left"> <font size="1" face="Verdana, Arial, Helvetica, sans-serif">RUT</font></td>
                          <td colspan="3"><div align="left"><font size="1" face="Verdana, Arial, Helvetica, sans-serif"><strong>:</strong><%=formulario.dibujaCampo("pers_nrut")%><%=formulario.dibujaCampo("rut")%> - <%=formulario.dibujaCampo("pers_xdv")%> <%=formulario.dibujaCampo("dv")%></font></div></td>
                          <td width="18%" >&nbsp;</td>
                        </tr>
                        <tr> 
                          <td ><font color="#CC3300">*</font></td>
                          <td align="left" > <font size="1" face="Verdana, Arial, Helvetica, sans-serif">Apellido 
                            Patern</font>o </td>
                          <td colspan="4" align="left" valign="top"> <div align="left"><strong><font size="1" face="Verdana, Arial, Helvetica, sans-serif">: 
                              <%=formulario.dibujaCampo("pers_tape_paterno")%></font></strong></div>
                            <div align="left"><strong></strong></div>
                          <div align="left"><strong></strong></div></td>
                        </tr>
                        <tr> 
                          <td ><font color="#CC3300">*</font></td>
                          <td align="left" > <font size="1" face="Verdana, Arial, Helvetica, sans-serif">Apellido 
                            Materno </font></td>
                          <td colspan="4" ><strong><font size="1" face="Verdana, Arial, Helvetica, sans-serif">: 
                            <%=formulario.dibujaCampo("pers_tape_materno")%> </font></strong><strong><font size="1" face="Verdana, Arial, Helvetica, sans-serif"> 
                            </font></strong><strong><font size="1" face="Verdana, Arial, Helvetica, sans-serif"> 
                          </font></strong></td>
                        </tr>
                        <tr> 
                          <td ><font color="#CC3300">*</font></td>
                          <td align="left" > <font size="1" face="Verdana, Arial, Helvetica, sans-serif">Nombres 
                            </font></td>
                          <td colspan="4" ><strong><font size="1" face="Verdana, Arial, Helvetica, sans-serif">: 
                            <%=formulario.dibujaCampo("pers_tnombre")%></font></strong></td>
                        </tr>
                        <tr> 
                          <td valign="bottom" ><font color="#CC3300">*</font></td>
                          <td align="left" > Fec. de Nacimiento </td>
                          <td colspan="3" ><strong><font size="1" face="Verdana, Arial, Helvetica, sans-serif">: 
                            <%=formulario.dibujaCampo("pers_fnacimiento")%></font></strong>(dd/mm/aaaa)</td>
                          <td >&nbsp;</td>
                        </tr>
                        <tr> 
                          <td valign="top"><font color="#CC3300">&nbsp;</font></td>
                          <td align="left"> Sexo </td>
                          <td colspan="4" ><strong><font size="1" face="Verdana, Arial, Helvetica, sans-serif"><%=formulario.dibujaCampo("sexo_ccod")%></font></strong></td>
                        </tr>
                        <tr> 
                          <td valign="top"><font color="#CC3300">&nbsp;</font></td>
                          <td align="left" valign="top"> Estado Civil </td>
                          <td width="19%" ><strong><font size="1" face="Verdana, Arial, Helvetica, sans-serif">: 
                            <%=formulario.dibujaCampo("eciv_ccod")%></font></strong></td>
                          <td width="3%" >&nbsp;</td>
                          <td width="17%" >&nbsp;</td>
                          <td >&nbsp;</td>
                        </tr>
                       
						<tr> 
                          <td valign="top"><font color="#CC3300">&nbsp;</font></td>
                          
                        <td align="left" valign="top">A&ntilde;o Ingreso UPacifico</td>
                          <td colspan="4"><strong><font size="1" face="Verdana, Arial, Helvetica, sans-serif">: <%=formulario.dibujaCampo("prof_ingreso_uas")%>&nbsp;&nbsp;&nbsp;&nbsp;
						  &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;</font></strong><font size="1" face="Verdana, Arial, Helvetica, sans-serif">Horas Contratadas :<font size="1" face="Verdana, Arial, Helvetica, sans-serif"><%=formulario.dibujaCampo("PROF_HORAS_CONTRATADAS")%></font></font></td>
                        </tr>
												<tr> 
                          <td valign="top"><font color="#CC3300">&nbsp;</font></td>
                          <td align="left" valign="top">Experiencia Academica (en a&ntilde;os)</td>
                          <td colspan="4" ><strong><font size="1" face="Verdana, Arial, Helvetica, sans-serif">: <%=formulario.dibujaCampo("prof_exacademica")%></font></strong></td>
                        </tr>
												<tr> 
                          <td valign="top"><font color="#CC3300">&nbsp;</font></td>
                          <td align="left" valign="top">Experiencia Profesional (en a&ntilde;os)</td>
                          <td colspan="4" ><strong><font size="1" face="Verdana, Arial, Helvetica, sans-serif">: <%=formulario.dibujaCampo("prof_exprofesional")%></font></strong></td>
                        </tr>
                        <tr> 
                          <td colspan="3"><font color="#CC3300"><strong>&nbsp;</strong></font><strong>Direcci&oacute;n 
                            Particular</strong></td>
                          <td >&nbsp;</td>
                          <td >&nbsp;</td>
                          <td >&nbsp;</td>
                        </tr>
                        <tr> 
                          <td><font color="#CC3300">*</font></td>
                          <td valign="top" >Av./Calle/Pasaje </td>
                          <td nowrap ><strong><font size="1" face="Verdana, Arial, Helvetica, sans-serif">: 
                            <%=formulario.dibujaCampo("dire_tcalle")%></font></strong></td>
                          <td ><font color="#FF0000">*</font></td>
                          <td >N&uacute;mero </td>
                          <td ><strong><font size="1" face="Verdana, Arial, Helvetica, sans-serif">:<%=formulario.dibujaCampo("dire_tnro")%></font></strong></td>
                        </tr>
                        <tr> 
                          <td valign="top"><font color="#CC3300">&nbsp;</font></td>
                          <td> Block </td>
                          <td ><strong><font size="1" face="Verdana, Arial, Helvetica, sans-serif">: 
                            <%=formulario.dibujaCampo("dire_tblock")%></font></strong></td>
                          <td >&nbsp;</td>
                          <td >Depto. </td>
                          <td ><strong><font size="1" face="Verdana, Arial, Helvetica, sans-serif">:<%=formulario.dibujaCampo("dire_tdepto")%></font></strong></td>
                        </tr>
                        <tr> 
                          <td valign="top"><font color="#CC3300">&nbsp;</font></td>
                          <td> Villa/Poblaci&oacute;n </td>
                          <td ><strong><font size="1" face="Verdana, Arial, Helvetica, sans-serif">: 
                            <%=formulario.dibujaCampo("dire_tpoblacion")%></font></strong></td>
                          <td >&nbsp;</td>
                          <td >&nbsp;</td>
                          <td >&nbsp;</td>
                        </tr>
                        <tr>
                          <td valign="top"><span class="Estilo1">*</span></td>
                          <td>Ciudad</td>
                          <td colspan="4" ><strong><font size="1" face="Verdana, Arial, Helvetica, sans-serif">: <%=formulario.dibujaCampo("ciud_ccod")%></font></strong></td>
                        </tr>
                        <tr> 
                          <td valign="top"><font color="#CC3300">&nbsp;</font></td>
                          <td> Tel&eacute;fono </td>
                          <td ><strong><font size="1" face="Verdana, Arial, Helvetica, sans-serif">: 
                            <%=formulario.dibujaCampo("pers_tfono")%></font></strong></td>
                          <td >&nbsp;</td>
                          <td >&nbsp;</td>
                          <td >&nbsp;</td>
                        </tr>
                        <tr> 
                          <td valign="top"><font color="#CC3300">&nbsp;</font></td>
                          <td height="9"> Celular </td>
                          <td ><font size="1" face="Verdana, Arial, Helvetica, sans-serif"><strong>:</strong> 0 
                            -<strong> <%=formulario.dibujaCampo("pers_tcelular")%></strong></font></td>
                          <td >&nbsp;</td>
                          <td >&nbsp;</td>
                          <td >&nbsp;</td>
                        </tr>
                        <tr>
                          <td height="10" colspan="6" valign="top"> <strong> &nbsp;Direcci&oacute;n Laboral</strong></td>
                        </tr>
						<tr>
                          <td valign="top">&nbsp;</td>
                          <td height="10">Av./Calle/Pasaje </td>
                          <td ><strong><font size="1" face="Verdana, Arial, Helvetica, sans-serif">: <%=formulario.dibujaCampo("dire_tcalle_laboral")%></font></strong></td>
                          <td >&nbsp;</td>
                          <td >N&uacute;mero</td>
                          <td ><strong><font size="1" face="Verdana, Arial, Helvetica, sans-serif">:<%=formulario.dibujaCampo("dire_tnro_laboral")%></font></strong></td>
                        </tr>
						<tr>
                          <td valign="top">&nbsp;</td>
                          <td height="10">Block</td>
                          <td ><strong><font size="1" face="Verdana, Arial, Helvetica, sans-serif">: <%=formulario.dibujaCampo("dire_tblock_laboral")%></font></strong></td>
                          <td >&nbsp;</td>
                          <td >Depto</td>
                          <td ><strong><font size="1" face="Verdana, Arial, Helvetica, sans-serif">:<%=formulario.dibujaCampo("dire_tdepto_laboral")%></font></strong></td>
                        </tr>
						<tr>
                          <td valign="top">&nbsp;</td>
                          <td height="10"> Villa/Poblaci&oacute;n </td>
                          <td ><strong><font size="1" face="Verdana, Arial, Helvetica, sans-serif">: <%=formulario.dibujaCampo("dire_tpoblacion_laboral")%></font></strong></td>
                          <td >&nbsp;</td>
                          <td >&nbsp;</td>
                          <td >&nbsp;</td>
                        </tr>
						<tr>
						  <td valign="top">&nbsp;</td>
						  <td height="10">Ciudad</td>
						  <td colspan="4" ><strong><font size="1" face="Verdana, Arial, Helvetica, sans-serif">: <%=formulario.dibujaCampo("ciud_ccod_laboral")%></font></strong></td>
					    </tr>
						<tr>
                          <td valign="top">&nbsp;</td>
                          <td height="10">Tel&eacute;fono</td>
                          <td ><strong><font size="1" face="Verdana, Arial, Helvetica, sans-serif">: <%=formulario.dibujaCampo("pers_tfono_laboral")%></font></strong></td>
                          <td >&nbsp;</td>
                          <td >&nbsp;</td>
                          <td >&nbsp;</td>
                        </tr>
						<tr>
                          <td valign="top">&nbsp;</td>
                          <td height="10">&nbsp;</td>
                          <td >&nbsp;</td>
                          <td >&nbsp;</td>
                          <td >&nbsp;</td>
                          <td >&nbsp;</td>
                        </tr>
                        <tr> 
                          <td valign="top" ><font color="#CC3300">&nbsp;</font></td>
                          <td > Correo Electr&oacute;nico</td>
                          <td colspan="4" ><strong><font size="1" face="Verdana, Arial, Helvetica, sans-serif">:<%=formulario.dibujaCampo("pers_temail")%></font></strong>(mail@hotmail.com)</td>
                        </tr>
                      </table>
                      <p> 
                        <% formulario.dibujacampo("pers_ncorr") %>
                        <% 'formulario.dibujacampo("sede_ccod") %>
                        <% formulario.dibujacampo("tdir_ccod") %>
                        En esta p&aacute;gina usted puede modificar datos del 
                        docente.<br>
                        El bot&oacute;n &quot;Siguiente&quot; graba los cambios 
                        realizados. 
					
		            </form>
				  <br>				  </td>
                  <td width="7" align="right" background="../imagenes/der.gif">&nbsp;</td>
                </tr>
            </table>
              <table width="100%" border="0" cellspacing="0" cellpadding="0">
                <tr>
                  <td width="9" rowspan="2"><img src="../imagenes/abajo_r1_c1.gif" width="9" height="28"></td>
                  <td width="237" bgcolor="#D8D8DE"><table width="90%"  border="0" align="center" cellpadding="0" cellspacing="0">
                    <tr>
                      <td><div align="center"><%if session("sin_pers_ncorr") <> 1 then%><%f_botonera.DibujaBoton("anterior")%><%end if%></div></td>
                      <td><div align="center"><%f_botonera.DibujaBoton("siguiente")%></div></td>
                      <td><div align="center"><%f_botonera.DibujaBoton("salir")%></div></td>
                    </tr>
                  </table>                    
                  </td>
                  <td width="125" rowspan="2" background="../imagenes/abajo_r1_c4.gif"><img src="../imagenes/abajo_r1_c3.gif" width="12" height="28"></td>
                  <td width="315" rowspan="2" align="right" background="../imagenes/abajo_r1_c4.gif"><img src="../imagenes/abajo_r1_c5.gif" width="7" height="28"></td>
                </tr>
                <tr>
                  <td valign="bottom" bgcolor="#D8D8DE"><img src="../imagenes/abajo_r2_c2.gif" width="100%" height="8"></td>
                </tr>
            </table>
			<br>
		  </td>
        </tr>
      </table>	
   </td>
  </tr>  
</table>
</body>
</html>
