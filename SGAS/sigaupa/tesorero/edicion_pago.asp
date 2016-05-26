<!-- #include file = "../biblioteca/_conexion.asp" -->
<!-- #include file = "../biblioteca/_negocio.asp" -->

<%
set pagina = new CPagina
set botonera = new CFormulario
botonera.carga_parametros "paulo.xml", "btn_edicion_pago"

nro=cint(request.form("nro_docto"))
alumno=request.Form("nombre")
rut=request.Form("rut")
mcaj_ncorr=request.form("mcaj_ncorr")

'******************************* NUEVO  *****************************
nro_campos=request.form("nro_campos")
nro_docto2=cint(request.form("nro_docto2"))
nro_campos2=request.form("nro_campos2")

'******************************* FIN NUEVO  *****************************

set variable = new cVariables
set conexion = new cConexion
set ftitulo = new cFormulario
set form_docto = new cFormulario
set form_docto2 = new cFormulario
set f_efec = new cFormulario
set inp = new cVariables
set negocio = new cnegocio
set variable2 = new cVariables
set inp2 = new cVariables
set impresora = new cformulario

variable.procesaForm

if  variable.nrofilas("M") <> 0 then
	suma=0
		for i=0 to variable.nrofilas("M")-1
			if variable.obtenerValor("M",i,"DCOM_NCOMPROMISO") <> "" then
				suma=suma+variable.obtenerValor("M",i,"DCOM_mCOMPROMISO_oculto")
			end if
		next
end if


variable2.procesaForm

if  variable2.nrofilas("MM") > 0 then
	suma=0
	for j=0 to variable2.nrofilas("MM")-1
		if variable.obtenerValor("MM",j,"DCOM_NCOMPROMISO") <> "" then
			suma=suma+variable.obtenerValor("MM",j,"DCOM_mCOMPROMISO_oculto")
		end if
	next
end if

if variable.nrofilas("M") > 0 then
	inst=request.form("m[0][inst_ccod]")
	nro_campos=request.form("nro_campos")
	v1=variable.nrofilas("M")
else
	if variable2.nrofilas("MM") > 0 then
		inst=request.form("mm[0][inst_ccod]")
		nro_campos2=request.form("nro_campos2")
		v2=variable2.nrofilas("MM")
	else 
			inst=request.form("m[0][inst_ccod]")
			nro_campos=request.form("nro_campos")
			nro_campos2=request.form("nro_campos2")
	end if
end if

conexion.inicializar "desauas"
form_docto.carga_parametros "tesorero.xml", "docto_teso_subdaf"
form_docto.inicializar conexion

form_docto2.carga_parametros "paulo.xml", "docto2"
form_docto2.inicializar conexion

negocio.inicializa conexion
sede =negocio.obtenerSede
'sede="1"

bole_ccorr = conexion.consultaUno("SELECT CTRA_NCORR_SEQ.NEXTVAL FROM DUAL")
itt="select inst_trazon_social as institucion from instituciones where inst_ccod=' " & inst & " '"

insti = conexion.consultaUno(itt)

f_efec.carga_parametros "paulo.xml","pagos"
f_efec.inicializar conexion 

impresora.carga_parametros "paulo.xml","impresora"
impresora.inicializar conexion

impres="select impr_truta from impresoras where impr_truta='" & session("impresora") & "'"

impresora.consultar impres
impresora.siguientef
impresora.agregacampoparam "impr_truta","filtro","sede_ccod=" & sede & " "

docto = "select '' as ding_ndocto ,'11' as tipo,'' as ting_ccod,'' as ingr_fpago,'' as banc_ccod,'' as ding_tcuenta_corriente,'' as plaz_ccod,'' as ding_mdetalle from dual" 

efec="select '' as ingr_mefectivo from dual"

form_docto.consultar docto
form_docto.agregacampocons	"ding_ndocto", bole_ccorr

form_docto2.consultar docto

f_efec.consultar efec
f_efec.agregacampoparam "ingr_mintereses","script","readOnly"
f_efec.agregacampoparam "ingr_mmultas","script","readOnly"

f_efec.agregacampocons "ingr_mefectivo" , "0"
f_efec.agregacampocons "ingr_mintereses" , "0"
f_efec.agregacampocons "ingr_mmultas" , "0"

'f_efec.agregacampoparam "ting_ccod" ,"filtro", "ting_ccod in (32,45)"
f_efec.agregacampoparam "ting_ccod", "filtro", "" 

if nro <> 0   then
	for i=1 to nro-1
		form_docto.clonafilacons 0
	next
end if

if nro_docto2 <> 0   then
	for i=1 to nro_docto2-1
		form_docto2.clonafilacons 0
	next
end if

f_efec.siguiente

%>


<html>
<head>
<title>Detalle Pagos</title>
<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1">
<link href="../estilos/estilos.css" rel="stylesheet" type="text/css">
<link href="../estilos/tabla.css" rel="stylesheet" type="text/css">

<script language="JavaScript" src="../biblioteca/tabla.js"></script>
<script language="JavaScript" src="../biblioteca/funciones.js"></script>
<script language="JavaScript" src="../biblioteca/validadores.js"></script>

<script language="JavaScript" type="text/JavaScript">
var pago

function actualizaTotal(formulario) {
	nElementos = formulario.elements.length;
	desc=0;
	total = <%=suma%>;	
	for(i=0;i<nElementos;i++) {
		nombre = formulario.elements[i].name;
		var elem = new RegExp ("ingr_mintereses|ingr_mmultas","gi");
		if (elem.test(nombre)){
			desc+=Number(formulario.elements[i].value);
		}
	}
	formulario.total_a_pagar.value = total + desc;
}

function compara_ndocto(formulario){
	nro=<%=nro%>;
	var c = new Array();
	xx=0;
	repetido=0;
	for (k=0;k<nro;k++){
	var aa=MM_findObj('d['+k+'][ding_ndocto]',formulario);
			c[xx]=aa.value;
			xx=xx+1;		
	}
	for (j=1;j<xx;j++){
		for (pp=0;pp<j;pp++){
			if (c[j]==c[pp]){
				repetido=repetido+1;
			}
		}
	}
	if (repetido>0){
		return(false);
	}
	else{
		return(true);
	}
}

function nro_documento(algo) {
	num=algo.form.elements.length;
	contador='<%=nro%>';
	for(i=0;i<contador;i++){
		var ting_ccod=MM_findObj('i[0][ting_ccod]');
		var ding_ndocto=MM_findObj('d['+i+'][ding_ndocto]');
		if(ting_ccod.value==9){
		 for (k=0;k<contador;k++){
		 	ding_ndocto.value=document.buscador.n_folio.value;
		 }
		} 
		else{
			ding_ndocto.value='';
		}
	}
}

function deshabilitar(objeto) {
	boleta='<%=bole_ccorr%>';
	num=objeto.form.elements.length;
	if (objeto.value==45 ){
	    estado=true;
			document.buscador.n_folio.value=boleta;
			document.buscador.n_folio.readOnly=true;
	}
	else {
		estado=false;
			document.buscador.n_folio.readOnly=false;
	}	
	a=objeto.name.substr(2,1);
	for(i=0;i<num;i++){
		/*nfolio='n_folio';
		switch (objeto.form.elements[i].name) {
		    case nfolio :
				objeto.form.elements[i].disabled=estado;
		}*/
		/*if (objeto.value==33 ){
			document.buscador.n_folio.value=boleta;
			document.buscador.n_folio.readOnly=true;
			
		}
		else {
			document.buscador.n_folio.readOnly=false;
		}*/
		var ding_ccod=MM_findObj('d['+i+'][ding_ndocto]')
		if (ding_ccod!=null) {
			if (objeto.value==9 ){

			 ding_ccod.value=document.buscador.n_folio.value;
			 }
			/*else{
				ding_ccod.value='';
			}*/
		}
	}
}

function habilitar(objeto) {
	num=objeto.form.elements.length;
	if (objeto.value==6){
	    estado=false;
	}
	else {
		estado=true;
	}	
	a=objeto.name.substr(2,1);
	for(i=0;i<num;i++){
		ding_fdocto='d['+a+'][ding_fdocto]';
		banc_ccod='d['+a+'][banc_ccod]';
		ding_tcuenta_corriente='d['+a+'][ding_tcuenta_corriente]';
		plaz_ccod='d['+a+'][plaz_ccod]';
		switch (objeto.form.elements[i].name) {
		    case ding_fdocto :
		    case banc_ccod :
		    case ding_tcuenta_corriente :
		    case plaz_ccod :
				objeto.form.elements[i].disabled=estado;
		}
	}
}

function revisa_cheque(formulario){
	nroElementos = formulario.elements.length;
	for (i=1;i<nroElementos;i++){
			if (formulario.elements[i].value==6){
		nombre= formulario.elements[i].name;
		var tipo = new RegExp ("ting_ccod","gi");
		if (tipo.test(nombre)){
				for (i=1;i<nroElementos;i++){
					nombre2= formulario.elements[i].name;
					var doc = new RegExp ("ding_fdocto|ding_tcuenta_corriente","gi");
					if(doc.test(nombre2)){
						if(formulario.elements[i].value!=''){
						formulario.elements[i].disabled=false;
						}
					}
					nombre3= formulario.elements[i].name;
					var banco = new RegExp ("banc_ccod","gi");
					if(banco.test(nombre3)){
						if(formulario.elements[i].value !=''){
						formulario.elements[i].disabled=false;
						}
					}
					nombre4= formulario.elements[i].name;
					var plaza = new RegExp ("plaz_ccod","gi");
					if(plaza.test(nombre4)){
						if(formulario.elements[i].value !=''){
						formulario.elements[i].disabled=false;
						}
					}
				}
			}
		}
	}
}

function pagos(formulario){
	a_pagar=<%=suma%>;
	num=formulario.elements.length;
	var int = MM_findObj('i[0][ingr_mintereses]',formulario);
	var mul = MM_findObj('i[0][ingr_mmultas]',formulario);
	x=parseFloat(int.value);
	y=parseFloat(mul.value);
	int_mul=x+y;
	pago=0;
	for (i=0;i<num;i++){
		nombre = formulario.elements[i].name;
		var elem = new RegExp ("ding_mdetalle|ingr_mefectivo","gi");
		if (elem.test(nombre)){
			if (parseFloat(formulario.elements[i].value)>=0) {
				s=parseFloat(formulario.elements[i].value);
				pago= pago + s;
			}
			else {
				return(true);
				//return (false);
			}
		}
		var elem2 = new RegExp ("ingr_mintereses|ingr_mmultas","gi");
		if (elem2.test(nombre)){
			if (parseFloat(formulario.elements[i].value)>=0) {
				s=parseFloat(formulario.elements[i].value);
				a_pagar += s;
			}
			else {
				return(true);
				//return (false);
			}
		}
	}
		if (a_pagar < pago){ //&& pago > int_mul ){
			return (1);
		}
		else {
			if (pago <= int_mul){
				return(2);
			}
			else {
				return(0);
			}
			//return(false);
//			return (false);
		}
}


function cerrarVentana() {
	self.close();
}


function modificar(formulario){
		if(preValidaFormulario(formulario)){
			if(compara_ndocto(formulario)){
				if (pagos(formulario)==1) {
				 	alert('El monto ingresado es mayor que el monto a pagar.');
					return(false);
					//formulario.total.value = pago;
					//return (true);
				}
				else {
				 	if(pagos(formulario)==2){
						alert('Lo que va a abonar debe ser mayor a la suma de los intereses y las multas');
						return(false);
					}
				    else {
						formulario.total.value = pago;
						return(true);
					}
					//	alert('Error: \nEl monto ingresado no corresponde al monto a pagar.');
					//return (false);
				}
			}
			else{
				alert('Ha ingresado documentos con el mismo número');
				return(false);
			}
		 }
		 else {
			return (false);
		}
}


function valida(formulario) {
	var fecha = new Date();
	dia=fecha.getDate();
	mes=fecha.getMonth();
	agno=fecha.getFullYear();
	sysdate=dia+'/'+mes+'/'+agno;
	nroElementos = formulario.elements.length;
	j=1;
	flag = true;
		for(i=0; i < nroElementos ; i++ ) {
			var expresion = new RegExp('ding_fdocto','gi');
			if (expresion.test(formulario.elements[i].name) ) {
				switch(j%2) {
					case 1 :
						fechaInicio = formulario.elements[i].value;
						break;
					case 0 :
						fechaTermino = formulario.elements[i].value;
						if(!comparaFechas(sysdate,fechaInicio)) {
							flag=false;
						}
						break;
				}
				j++;
			}
		}
		if(!flag) {
			alert('Complete correctamente las fechas de los documentos');
			return(false);
		}
	return(flag);
}

function MM_findObj(n, d) { //v4.01
  var p,i,x;  if(!d) d=document; if((p=n.indexOf("?"))>0&&parent.frames.length) {
    d=parent.frames[n.substring(p+1)].document; n=n.substring(0,p);}
  if(!(x=d[n])&&d.all) x=d.all[n]; for (i=0;!x&&i<d.forms.length;i++) x=d.forms[i][n];
  for(i=0;!x&&d.layers&&i<d.layers.length;i++) x=MM_findObj(n,d.layers[i].document);
  if(!x && d.getElementById) x=d.getElementById(n); return x;
}


	
</script>

</head>
<body bgcolor="#EAEAEA" leftmargin="0" topmargin="0" marginwidth="0" marginheight="0" onLoad="MM_preloadImages('../imagenes/botones/buscar_f2.gif','../images/bot_deshabilitar_f2.gif','../images/agregar2_f2_p.gif','im&amp;#225;genes/marco1_r3_c2_f2.gif');MM_preloadImages('im&amp;#225;genes/marco1_r3_c4_f2.gif');MM_preloadImages('im&amp;#225;genes/marco1_r3_c6_f2.gif');MM_preloadImages('im&amp;#225;genes/marco1_r3_c8_f2.gif');MM_preloadImages('../imagenes/botones/cargar_f2.gif','../imagenes/botones/continuar_f2.gif')" onBlur="revisaVentana();">
<table width="750" border="0" cellpadding="0" cellspacing="0">
  <tr>
  </tr>
  <tr>
    <td valign="top" bgcolor="#EAEAEA">
	<form action="actualizar_pago.asp" method="post" name="buscador">
	<table width="87%" border="0" cellpadding="0" cellspacing="0">
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
                <td><img src="../imagenes/top_r1_c2.gif" alt="" name="top_r1_c2" width="700" height="8" border="0"></td>
                <td><img name="top_r1_c3" src="../imagenes/top_r1_c3.gif" width="7" height="8" border="0" alt=""></td>
              </tr>
              <tr>
                <td><img name="top_r2_c1" src="../imagenes/top_r2_c1.gif" width="9" height="17" border="0" alt=""></td>
                <td><table width="100%" border="0" cellspacing="0" cellpadding="0">
                    <tr>
                      <td width="13" background="../imagenes/fondo1.gif"><img src="../imagenes/izq_1.gif" width="5" height="17"></td>
                      <td width="209" valign="middle" background="../imagenes/fondo1.gif">
                      <div align="left"><font color="#FFFFFF" size="1" face="Verdana, Arial, Helvetica, sans-serif">Detalle
                          de Recepci&oacute;n de Ingresos</font></div></td>
                      <td width="448" bgcolor="#D8D8DE"><img src="../imagenes/derech1.gif" width="6" height="17"></td>
                    </tr>
                </table></td>
                <td><img name="top_r2_c3" src="../imagenes/top_r2_c3.gif" width="7" height="17" border="0" alt=""></td>
              </tr>
              <tr>
                <td><img name="top_r3_c1" src="../imagenes/top_r3_c1.gif" width="9" height="2" border="0" alt=""></td>
                <td><img name="top_r3_c2" src="../imagenes/top_r3_c2.gif" width="700" height="2" border="0" alt=""></td>
                <td><img name="top_r3_c3" src="../imagenes/top_r3_c3.gif" width="7" height="2" border="0" alt=""></td>
              </tr>
            </table>
              <table width="100%" border="0" cellspacing="0" cellpadding="0">
                <tr>
                  <td width="9" align="left" background="../imagenes/izq.gif">&nbsp;</td>
                  <td bgcolor="#D8D8DE">
				    &nbsp;
				 <strong><input type="hidden" name="total">
        <input type="hidden" name="alumno" value="<%=alumno%>">
        <input type="hidden" name="rut" value="<%=rut%>">
        <%
inp.procesaForm
if inp.nrofilas("M") >0 then
	z=0
	for i=0 to inp.nrofilas("M")-1
		if inp.obtenerValor("M",i,"DCOM_NCOMPROMISO") <> "" then
			z=z+1
			a=inp.obtenerValor("M",i,"tcom_ccod")
			b=inp.obtenerValor("M",i,"inst_ccod")
			c=inp.obtenerValor("M",i,"comp_ndocto")
			d=inp.obtenerValor("M",i,"dcom_mcompromiso_oculto")
			e=inp.obtenerValor("M",i,"dcom_ncompromiso")
			f=inp.obtenerValor("M",i,"abon_fabono")
			g=inp.obtenerValor("M",i,"tcom_tdesc")
			p=inp.obtenerValor("M",i,"pers_ncorr")
			response.Write("<input type='hidden' name='m["& i &"][pers_ncorr]' value='"& p &"'>")
			response.Write("<input type='hidden' name='m["& i &"][dcom_ncompromiso]' value='"& e &"'>")
			response.Write("<input type='hidden' name='m["& i &"][tcom_ccod]' value='"& a &"'>")
			response.Write("<input type='hidden' name='m["& i &"][inst_ccod]' value='"& b &"'>")
			response.Write("<input type='hidden' name='m["& i &"][comp_ndocto]' value='"& c &"'>")
			response.Write("<input type='hidden' name='m["& i &"][abono]' value='"& d &"'>")
			response.Write("<input type='hidden' name='m["& i &"][abon_fabono]' value='"& f &"'>")
			response.Write("<input type='hidden' name='m["& i &"][concepto]' value='"& g &"'>")
			response.Write("<input type='hidden' name='campos' value='"& z &"'>")
	
		end if
	next
end if


inp2.procesaForm
if inp2.nrofilas("MM") >0 then
	z=0
	for i=0 to inp2.nrofilas("MM")-1
		if inp2.obtenerValor("MM",i,"DCOM_NCOMPROMISO") <> "" then
			z=z+1
			a1=inp2.obtenerValor("MM",i,"tcom_ccod")
			b1=inp2.obtenerValor("MM",i,"inst_ccod")
			c1=inp2.obtenerValor("MM",i,"comp_ndocto")
			d1=inp2.obtenerValor("MM",i,"dcom_mcompromiso_oculto")
			e1=inp2.obtenerValor("MM",i,"dcom_ncompromiso")
			f1=inp2.obtenerValor("MM",i,"abon_fabono")
			g1=inp2.obtenerValor("MM",i,"tcom_tdesc")
			p1=inp2.obtenerValor("MM",i,"pers_ncorr")
			response.Write("<input type='hidden' name='mm["& i &"][pers_ncorr]' value='"& p1 &"'>")
			response.Write("<input type='hidden' name='mm["& i &"][dcom_ncompromiso]' value='"& e1 &"'>")
			response.Write("<input type='hidden' name='mm["& i &"][tcom_ccod]' value='"& a1 &"'>")
			response.Write("<input type='hidden' name='mm["& i &"][inst_ccod]' value='"& b1 &"'>")
			response.Write("<input type='hidden' name='mm["& i &"][comp_ndocto]' value='"& c1 &"'>")
			response.Write("<input type='hidden' name='mm["& i &"][abono]' value='"& d1 &"'>")
			response.Write("<input type='hidden' name='mm["& i &"][abon_fabono]' value='"& f1 &"'>")
			response.Write("<input type='hidden' name='mm["& i &"][concepto]' value='"& g1 &"'>")
			response.Write("<input type='hidden' name='campos2' value='"& z1 &"'>")
	
		end if
	next
end if

%><input type="hidden" name="i[0][mcaj_ncorr]" value="<%=mcaj_ncorr%>">
       <!-- ******************************* NUEVO  ***************************** -->
			 <input type="hidden" name="nro_campos" value="<%=nro_campos%>">
			 <input type="hidden" name="nro_campos2" value="<%=nro_campos2%>">
			 <input type="hidden" name="cant_detalle" value="<%=nro%>">
       <!-- ******************************* FIN NUEVO  ***************************** -->


        <table width="95%" cellpadding="0" cellspacing="0">
          <tr> 
            <td align="right" nowrap><strong>&nbsp;&nbsp;Monto a amortizar :</strong></td>
            <td nowrap><strong> $&nbsp; 
              <%
		RESPONSE.WRITE(suma)
		%>
              </strong></td>
            <td colspan="2" align="right" nowrap><strong>Instituci&oacute;n a 
              Pagar :</strong></td>
            <td colspan="3"> <%response.write(insti)%> </td>
          </tr>
          <tr> 
            <th height="24" align="right">Intereses :</th>
            <td>$ <strong><%=f_efec.dibujaCampo("ingr_mintereses")%></strong></td>
            <td width="150">&nbsp;</td>
            <td>&nbsp;</td>
            <td align="right">&nbsp;</td>
            <td align="right">&nbsp;</td>
            <td>&nbsp;</td>
          </tr>
          <tr> 
            <th align="right" nowrap><strong>Multas : </strong></th>
            <td nowrap><strong>$<strong> <%=f_efec.dibujaCampo("ingr_mmultas")%></strong> </strong></td>
            <td colspan="2" align="right"><strong>Documento :</strong></td>
            <td><strong> <%=f_efec.dibujaCampo("ting_ccod")%> </strong></td>
            <td align="right"><strong> N&uacute;mero&nbsp;&nbsp;&nbsp;</strong></td>
            <td align="left"> <strong> 
              <input name="n_folio" type="text"  size="10" maxlength="8" id="IN-N" value="<%=bole_ccorr%>" readonly="true">
              </strong> </td>
          </tr>
          <tr> 
            <th align="right" nowrap>Total a pagar :</th>
            <td>$<strong> 
              <input name="total_a_pagar" type="text" readonly="true" id="total_a_pagar" value="<%= suma %>" size="10" maxlength="9">
              </strong></td>
            <td>&nbsp;</td>
            <td align="right">&nbsp; </td>
            <td>&nbsp;</td>
            <td align="right">&nbsp;</td>
            <td><p>&nbsp;</p>
              <p>&nbsp;</p></td>
          </tr>
          <tr> 
            <th align="right" nowrap>&nbsp;</th>
            <td align="left">&nbsp;</td>
            <td>&nbsp;</td>
            <td align="right">&nbsp;</td>
            <td>&nbsp;</td>
            <td align="right">&nbsp;</td>
            <td>&nbsp;</td>
          </tr>
          <tr> 
            <th align="right" nowrap>&nbsp;</th>
            <td align="left">&nbsp;</td>
            <!--   FIN  NUEVO    -->
            <td>&nbsp;</td>
            <td align="right">&nbsp;</td>
            <td>&nbsp;</td>
            <td align="right">&nbsp;</td>
            <td>&nbsp;</td>
          </tr>
          <tr> 
            <th align="right" nowrap>&nbsp;</th>
            <th align="left">&nbsp;</th>
            <td>&nbsp;</td>
            <td align="right">&nbsp;</td>
            <td>&nbsp;</td>
            <td align="right">&nbsp;</td>
            <td>&nbsp;</td>
          </tr>
        </table>
        </strong> <br>
        <table width="98%" border="1" align="center" cellpadding="0" cellspacing="0" bordercolor="#A0C0EB" bgcolor="#FBFBF7">
          <tr> 
            <td align="left">

              <br>
              <%if nro <> 0 then%>
              <strong>&nbsp; Detalle Pago con Documento(s)<br>
              </strong> 
              <table width="98%" border="0" align="center" cellpadding="0" cellspacing="0">
                <tr>
                    
                  <td align="center" valign="top">
<%form_docto.dibujaTabla()%>
                  </td>
                  </tr>
                </table>
                
              <p>
                <%end if%>
              </p>
			<%if nro_docto2 <> 0 then%>
              <strong>&nbsp; Detalle Pago con Remesa<br>
              </strong> 
              <table width="98%" border="0" align="center" cellpadding="0" cellspacing="0">
                <tr>
                    
                  <td align="center" valign="top">
<%form_docto2.dibujaTabla()%>
                  </td>
                  </tr>
                </table>
                <%end if%>
              <p>
              </p>
              <p>&nbsp; </p>
              <table border="0" align="right" cellpadding="0" cellspacing="0">
                <tr align="center"> 
                  <td width="60" nowrap>&nbsp; </td>
                  <td width="205" colspan="2" align="left" nowrap>&nbsp;</td>
                  <td width="66" nowrap> <%botonera.DibujaBoton "guardar"%>
                  </td>
                </tr>
                <tr align="center"> 
                  <td>&nbsp;</td>
                  <td colspan="2">&nbsp;</td>
                  <td>&nbsp;</td>
                  <td width="1">&nbsp;</td>
                </tr>
              </table>
             </tr>
        </table>				  </td>
                  <td width="7" align="right" background="../imagenes/der.gif">&nbsp;</td>
                </tr>
            </table>
              <table width="100%" border="0" cellspacing="0" cellpadding="0">
                <tr>
                  <td width="9" rowspan="2"><img src="../imagenes/abajo_r1_c1.gif" width="9" height="28"></td>
                  <td width="110" bgcolor="#D8D8DE"><table width="90%"  border="0" align="center" cellpadding="0" cellspacing="0">
                    <tr>
                      <td><div align="center"></div></td>
                      <td><div align="center"></div></td>
                      <td><div align="center">
                        <%botonera.DibujaBoton "salir"%>
                      </div></td>
                    </tr>
                  </table>                    
                  </td>
                  <td width="557" rowspan="2" background="../imagenes/abajo_r1_c4.gif"><img src="../imagenes/abajo_r1_c3.gif" width="12" height="28"></td>
                  <td width="10" rowspan="2" align="right" background="../imagenes/abajo_r1_c4.gif"><img src="../imagenes/abajo_r1_c5.gif" width="7" height="28"></td>
                </tr>
                <tr>
                  <td valign="bottom" bgcolor="#D8D8DE"><img src="../imagenes/abajo_r2_c2.gif" width="100%" height="8"></td>
                </tr>
            </table>
			<p><br>
			<p><br>
			<p><br>
		  </td>
        </tr>
      </table>	
</form>
   </td>
  </tr>  
</table>
</body>
</html>
