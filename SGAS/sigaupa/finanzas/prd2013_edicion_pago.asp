<!-- #include file = "../biblioteca/_conexion.asp" -->
<!-- #include file = "../biblioteca/_negocio.asp" -->
<%

set pagina = new CPagina
set botonera = new CFormulario
botonera.carga_parametros "paulo.xml", "btn_edicion_pago"


nro				=	cint(request.form("nro_docto"))
rut				=	request.Form("rut")

'******************************* NUEVO  *****************************
'nro_campos		=	request.form("nro_campos")
nro_docto2		=	cint(request.form("nro_docto2"))
'nro_campos2		=	request.form("nro_campos2")
monto_nabono	=	clng(request.form("mnabono"))
'******************************* FIN NUEVO  *****************************

set conexion = new cConexion
conexion.inicializar "upacifico"

set ftitulo = new cFormulario
set form_docto = new cFormulario
set form_docto2 = new cFormulario
set f_efec = new cFormulario
set negocio = new cnegocio
set impresora = new cformulario

set variable = new cVariables
variable.procesaForm

suma=0
if  variable.nrofilas("CC_COMPROMISOS_PENDIENTES") <> 0 then
	for i=0 to variable.nrofilas("CC_COMPROMISOS_PENDIENTES")-1
			if variable.obtenerValor("CC_COMPROMISOS_PENDIENTES",i,"DCOM_NCOMPROMISO") <> "" then
				tcom_ccod = variable.obtenerValor("CC_COMPROMISOS_PENDIENTES",i,"tcom_ccod")
				inst_ccod = variable.obtenerValor("CC_COMPROMISOS_PENDIENTES",i,"inst_ccod")
				comp_ndocto = variable.obtenerValor("CC_COMPROMISOS_PENDIENTES",i,"comp_ndocto")
				dcom_ncompromiso = variable.obtenerValor("CC_COMPROMISOS_PENDIENTES",i,"dcom_ncompromiso")
				dcom_mcompromiso = conexion.consultauno("select dcom_mcompromiso from detalle_compromisos where cast(tcom_ccod as varchar)= '"&tcom_ccod&"' and cast(inst_ccod as varchar)= '"&inst_ccod&"' and cast(comp_ndocto as varchar)= '"&comp_ndocto&"' and cast(dcom_ncompromiso as varchar)= '"&dcom_ncompromiso&"'")
				'suma=suma+clng(dcom_mcompromiso) - conexion.consultauno("select total_abonado_cuota("&tcom_ccod&","&inst_ccod&","&comp_ndocto&","&dcom_ncompromiso&") from dual")
				suma = suma + conexion.ConsultaUno("select cast(protic.total_recepcionar_cuota("&tcom_ccod&","&inst_ccod&","&comp_ndocto&","&dcom_ncompromiso&") as varchar)")
			end if
		next
end if


set variable2 = new cVariables
variable2.procesaForm

set inp = new cVariables
set inp2 = new cVariables


if variable.nrofilas("CC_COMPROMISOS_PENDIENTES") > 0 then
	inst=request.form("cc_compromisos_pendientes[0][inst_ccod]")
	'nro_campos=request.form("nro_campos")
	v1=variable.nrofilas("CC_COMPROMISOS_PENDIENTES")
else
			inst=request.form("cc_compromisos_pendientes[0][inst_ccod]")
			'nro_campos=request.form("nro_campos")
			'nro_campos2=request.form("nro_campos2")
'	end if
end if

form_docto.carga_parametros "paulo.xml", "docto"
form_docto.inicializar conexion

'-----------------------------------------------------------------------------------------------------------
'if variable.NroFilas("cc_compromisos_pendientes") > 0 then
	str_variable = "CC_COMPROMISOS_PENDIENTES"
'else
'	str_variable = "MM"
'end if


str_filtro = ""
for i_ = 0 to variable.NroFilas(str_variable)
	v_dcom_ncompromiso = variable.ObtenerValor(str_variable, i_, "dcom_ncompromiso")	
		
	if v_dcom_ncompromiso <> "" then
		v_comp_ndocto = variable.ObtenerValor(str_variable, i_, "comp_ndocto")
		v_inst_ccod = variable.ObtenerValor(str_variable, i_, "inst_ccod")
		v_tcom_ccod = variable.ObtenerValor(str_variable, i_, "tcom_ccod")
		
		if str_filtro <> "" then
			str_filtro = str_filtro & " or "
		end if
		
		str_filtro = str_filtro & "(cast(a.tcom_ccod as varchar)= '" & v_tcom_ccod & "' and cast(a.inst_ccod as varchar)= '" & v_inst_ccod & "' and cast(a.comp_ndocto as varchar)= '" & v_comp_ndocto & "') "
		
	end if
next

if str_filtro = "" then
	str_filtro = " 1 = 2 "
end if

					
sql_instituciones = "select distinct c.inst_ccod, isnull(b.inem_ccod, c.inst_ccod) as inem_ccod," & vbCrLf &_
					"        isnull(b.inem_tdesc, c.inst_trazon_social) as institucion " & vbCrLf &_
					"from (select * " & vbCrLf &_
					"      from compromisos a " & vbCrLf &_
					"	  where " & str_filtro & "  " & vbCrLf &_
					"	  ) a, instituciones_empresas b, instituciones c " & vbCrLf &_
					"where a.inst_ccod *= b.inst_ccod  " & vbCrLf &_
					"  and a.sede_ccod *= b.sede_ccod  " & vbCrLf &_
					"  and a.inst_ccod = c.inst_ccod"
					
set f_consulta = new CFormulario
f_consulta.Carga_Parametros "andres.xml", "consulta"
f_consulta.Inicializar conexion

f_consulta.Consultar sql_instituciones


if f_consulta.NroFilas > 1 then
	b_instituciones_distintas = true	
	
	%>
<script language="JavaScript">
	alert('Ha seleccionado compromisos de instituciones distintas.');
	close();
	</script>
<%
	
else
	b_instituciones_distintas = false
	
	f_consulta.Siguiente
	v_institucion = f_consulta.ObtenerValor("institucion")
	
	v_inst_ccod = f_consulta.ObtenerValor("inst_ccod")
	v_inem_ccod = f_consulta.ObtenerValor("inem_ccod")
end if
					

'----------------------------------------------------------------------------------------------------------

form_docto2.carga_parametros "paulo.xml", "docto2"
form_docto2.inicializar conexion

negocio.inicializa conexion

set cajero = new ccajero
cajero.inicializar conexion,negocio.obtenerusuario,negocio.obtenersede
mcaj_ncorr = cajero.obtenercajaabierta

sede = negocio.obtenerSede
periodo = negocio.ObtenerPeriodoAcademico("CLASES")

coin_nfolio_referencia = conexion.consultauno("execute obtenersecuencia 'ingresos_referencia'")

rut_v 		= 	split (rut,"-")
rut_alumno	=	rut_v(0)

matricula	=	conexion.consultauno("select max(a.matr_ncorr)  "& vbcrlf & _
			" from  alumnos a, personas b "& vbcrlf & _
			" where  "& vbcrlf & _
			"	 a.pers_ncorr=b.pers_ncorr  "& vbcrlf & _
			"	 and a.emat_ccod=1  "& vbcrlf & _
			"	 and cast(b.pers_nrut as varchar)='"& rut_alumno &"'")
			
sede_alumno	=	conexion.consultauno("select a.sede_ccod from ofertas_academicas a, alumnos b  "& vbcrlf & _
									"	where a.ofer_ncorr=b.ofer_ncorr  "& vbcrlf & _
									"	and cast(b.matr_ncorr as varchar)='"& matricula &"' ")

itt="select inst_trazon_social as institucion from instituciones where cast(inst_ccod as varchar)='" & inst & "'"
insti = conexion.consultaUno(itt)

inem_ccod	=	inst



f_efec.carga_parametros "paulo.xml","pagos"
f_efec.inicializar conexion 

impresora.carga_parametros "paulo.xml","impresora"
impresora.inicializar conexion

impres="select impr_truta from impresoras where cast(impr_truta as varchar)='" & session("impresora") & "'"

impresora.consultar impres
impresora.siguientef
impresora.agregacampoparam "impr_truta","filtro","sede_ccod=" & sede & " "

docto = "select '' as ding_ndocto ,'11' as tipo,'' as ting_ccod,'' as ingr_fpago,'' as banc_ccod,'' as ding_tcuenta_corriente,'' as plaz_ccod,'' as ding_mdetalle" 

efec="select '' as ingr_mefectivo"


form_docto.consultar docto
form_docto2.consultar docto
f_efec.consultar efec

f_efec.agregacampocons "ingr_mefectivo" , "0"
f_efec.agregacampocons "ingr_mintereses" , "0"
f_efec.agregacampocons "ingr_mmultas" , "0"

f_efec.agregacampoparam "ting_ccod" ,"filtro", "ting_ccod in (17)"

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


'------------------------------------------------------------------------------------------------------
form_docto.AgregaCampoParam "ding_ndocto", "soloLectura", "TRUE"
form_docto.AgregaCampoCons "ding_ndocto", coin_nfolio_referencia
form_docto.AgregaCampoParam "ting_ccod", "filtro", "ting_bregularizacion='S'"
form_docto.AgregaCampoCons "ding_mdetalle", suma

f_efec.AgregaCampoParam "ingr_mintereses", "soloLectura", "TRUE"
f_efec.AgregaCampoParam "ingr_mmultas", "soloLectura", "TRUE"
f_efec.AgregaCampoParam "ingr_mefectivo", "soloLectura", "TRUE"
f_efec.AgregaCampoCons "ingr_mefectivo", "0"

'botonera.AgregaBotonParam "guardar", "url", "../cajas/actualizar_pago.asp"
botonera.AgregaBotonParam "guardar", "url", "actualizar_pago.asp"


'---------------------------------------------------------------------------------------------------------
set fc_nabono = new CFormulario
fc_nabono.Carga_Parametros "andres.xml", "consulta"
fc_nabono.Inicializar conexion

arr_rut = split(rut, "-")
v_pers_nrut = arr_rut(0)

consulta = "SELECT a.*, a.ingr_mtotal AS monto_nota,  isnull(b.ding_mdetalle,0) AS monto_utilizado, a.ingr_mtotal - isnull(b.ding_mdetalle,0) AS saldo_nota " & vbCrLf &_
           "FROM ( SELECT a.ingr_ncorr, a.ingr_fpago, a.ingr_nfolio_referencia, a.ting_ccod, a.inst_ccod, a.ingr_mtotal, d.ting_tdesc " & vbCrLf &_
		   "       FROM ingresos a, notascreditos_documentos b, personas c, tipos_ingresos d " & vbCrLf &_
		   "	   WHERE a.ingr_ncorr = b.ingr_ncorr_notacredito AND " & vbCrLf &_
		   "	         a.pers_ncorr = c.pers_ncorr AND " & vbCrLf &_
		   "			 a.ting_ccod = d.ting_ccod AND " & vbCrLf &_
		   "			 a.eing_ccod = 1 AND " & vbCrLf &_
		   "			 d.ting_brebaje = 'S' AND " & vbCrLf &_
		   "			 a.ting_ccod not in (4,15) AND " & vbCrLf &_
		   "			 cast(c.pers_nrut as varchar)= '" & v_pers_nrut & "' " & vbCrLf &_
		   "	    ) a, " & vbCrLf &_
		   "	  (SELECT b.ding_ndocto, sum(b.ding_mdetalle) AS ding_mdetalle " & vbCrLf &_
		   "	   FROM ingresos a, detalle_ingresos b, personas c " & vbCrLf &_
		   "	   WHERE a.ingr_ncorr = b.ingr_ncorr AND " & vbCrLf &_
		   "	         a.pers_ncorr = c.pers_ncorr AND " & vbCrLf &_
		   "			 a.eing_ccod = 1 AND " & vbCrLf &_
		   "			 b.ting_ccod = 52 AND " & vbCrLf &_
		   "			 cast(c.pers_nrut as varchar)= '" & v_pers_nrut & "' " & vbCrLf &_
		   "	   GROUP BY b.ding_ndocto) b " & vbCrLf &_
		   "WHERE a.ingr_nfolio_referencia *= b.ding_ndocto "
fc_nabono.Consultar consulta

'---------------------------------------------------------------------------------------------------------
set fc_montos_alumno = new CFormulario
fc_montos_alumno.Carga_Parametros "andres.xml", "consulta"


		   
consulta = "select tmal_ccod, malu_ncorr, (malu_mtotal - malu_mutilizado) as malu_saldo, malu_nfolio_referencia" & vbCrLf &_
			"    from montos_alumnos a,personas b" & vbCrLf &_
			"    where a.pers_ncorr = b.pers_ncorr " & vbCrLf &_
			"        and a.tmal_ccod in (1) " & vbCrLf &_
			"        and malu_mtotal - isnull(malu_mutilizado,0) > 0" & vbCrLf &_
			"        and cast(b.pers_nrut as varchar)= '" & v_pers_nrut & "'"
			
'response.Write("<pre>"&consulta&"</pre>")
'response.End()				   
fc_montos_alumno.Inicializar conexion
fc_montos_alumno.Consultar consulta

'---------------------------------------------------------------------------------------------------------

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
<script language="JavaScript">
arr_nabono = new Array();
var existe_vvista = false;

<%
iFila = 0
while fc_nabono.Siguiente
	%>
arr_nabono[<%=iFila%>] = new Array();
arr_nabono[<%=iFila%>]["ding_ndocto"] = '<%=fc_nabono.ObtenerValor("ingr_nfolio_referencia")%>';
arr_nabono[<%=iFila%>]["ting_ccod"] = '<%=fc_nabono.ObtenerValor("ting_ccod")%>';
arr_nabono[<%=iFila%>]["saldo_nota"] = '<%=fc_nabono.ObtenerValor("saldo_nota")%>';
	<%
	iFila = iFila + 1
wend
%>

arr_montos_alumno = new Array();
<%
iFila = 0
while fc_montos_alumno.Siguiente
	%>
arr_montos_alumno[<%=iFila%>] = new Array();
arr_montos_alumno[<%=iFila%>]["malu_nfolio_referencia"] = '<%=fc_montos_alumno.ObtenerValor("malu_nfolio_referencia")%>';
arr_montos_alumno[<%=iFila%>]["malu_saldo"] = '<%=fc_montos_alumno.ObtenerValor("malu_saldo")%>';
arr_montos_alumno[<%=iFila%>]["tmal_ccod"] = '<%=fc_montos_alumno.ObtenerValor("tmal_ccod")%>';
	<%
	iFila = iFila + 1
wend
%>


function activa_pago(parametro){
	return false;
}

function validar_monto_alumno(formulario){
	nElementos = formulario.elements.length;	
	for (i=0;i < nElementos;i++){
		nombre = formulario.elements[i].name;
		var elem = new RegExp ("ting_ccod","gi");
		if (elem.test(nombre)){
			if(formulario.elements[i].value == 74){	
				encontrado=false;
				nro_docto=formulario.elements[i-1].value;
				valor=formulario.elements[i+5].value;
				for (j=0;j < arr_montos_alumno.length;j++){
					if ((nro_docto==arr_montos_alumno[j]["malu_nfolio_referencia"]) && (arr_montos_alumno[j]["tmal_ccod"] == '1')) {
						encontrado=true;
						if (parseFloat(valor)>parseFloat(arr_montos_alumno[j]["malu_saldo"])){
							alert('El total de Pagos Reconocidos para el pagaré Nº ' + arr_montos_alumno[j]["malu_nfolio_referencia"] + ' es de $' + arr_montos_alumno[j]["malu_saldo"] + '.');
							formulario.elements[i+5].focus();
							formulario.elements[i+5].select();
							return (false);
						}
					}
				}
				
				if (!encontrado) {
					alert('No existe el pagaré Nº '+ formulario.elements[i-1].value +' para el alumno.');
					formulario.elements[i-1].focus();
					formulario.elements[i-1].select();												
					return false;
				}
			}
			
			if(formulario.elements[i].value == 75){	
				encontrado=false;
				nro_docto=formulario.elements[i-1].value;
				valor=formulario.elements[i+5].value;
				for (j=0;j < arr_montos_alumno.length;j++){
					if ((nro_docto==arr_montos_alumno[j]["malu_nfolio_referencia"]) && (arr_montos_alumno[j]["tmal_ccod"] == '2')) {
						encontrado=true;
						if (parseFloat(valor)>parseFloat(arr_montos_alumno[j]["malu_saldo"])){
							alert('El total de Cuotas Anticipadas para el pagaré Nº ' + arr_montos_alumno[j]["malu_nfolio_referencia"] + ' es de $' + arr_montos_alumno[j]["malu_saldo"] + '.');
							formulario.elements[i+5].focus();
							formulario.elements[i+5].select();
							return (false);
						}
					}
				}
				
				if (!encontrado) {
					alert('No existe el pagaré Nº '+ formulario.elements[i-1].value +' para el alumno.');
					formulario.elements[i-1].focus();
					formulario.elements[i-1].select();												
					return false;
				}
			}			
		}
	}	
	
	return true;
}


function validar_nabono(formulario){
	nElementos = formulario.elements.length;	
	for (i=0;i < nElementos;i++){
		nombre = formulario.elements[i].name;
		var elem = new RegExp ("ting_ccod","gi");
		if (elem.test(nombre)){
			if(formulario.elements[i].value == 52){	
				encontrado=false;
				nro_docto=formulario.elements[i-1].value;
				valor=formulario.elements[i+5].value;				
				for (j=0;j < arr_nabono.length;j++){
					if (nro_docto==arr_nabono[j]["ding_ndocto"]){
						encontrado=true;
						if (parseFloat(valor)>parseFloat(arr_nabono[j]["saldo_nota"])){
							alert('El saldo de la nota Nº ' + arr_nabono[j]["ding_ndocto"] + ' es de $' + arr_nabono[j]["saldo_nota"] + '.');
							formulario.elements[i+5].focus();
							formulario.elements[i+5].select();
							return (false);
						}
					}
				}
				
				if (!encontrado) {
					alert('No existe la nota de crédito Nº '+ formulario.elements[i-1].value +' para el alumno.');
					formulario.elements[i-1].focus();
					formulario.elements[i-1].select();												
					return false;
				}
			}
		}
	}	
	
	return true;
}

</script>
<script language="JavaScript" type="text/JavaScript">
var pago

function m_nabano(formulario){
	nElementos = formulario.elements.length;
	var nota='<%=monto_nabono%>';
	montodetalle=0;
	for (i = 0; i < <%=form_docto.NroFilas%> ; i++) {
		if (formulario.elements["d[" + i + "][ting_ccod]"].value == 52) {
			montodetalle  += parseInt(formulario.elements["d[" + i + "][ding_mdetalle]"].value);
		}		
	}
	
	if (montodetalle>nota){
		return(false);
	}
	else {
		return(true);
	}
}

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
	

	nro = <%=nro%>;
	
	for (i = 0; i < nro; i++) {		
		for (j = 0; j < nro; j++) {
			if (i != j) {
				if ((formulario.elements["d[" + i + "][ding_ndocto]"].value == formulario.elements["d[" + j + "][ding_ndocto]"].value) && (formulario.elements["d[" + i + "][ting_ccod]"].value == formulario.elements["d[" + j + "][ting_ccod]"].value)) {
					return false;
				}
			}
		}
	}
	
	return true;	
}


function deshabilitar(objeto) {
	num=objeto.form.elements.length;
	if (objeto.value!=16 ){
	    estado=true;
	}
	else {
		estado=false;
	}	
	a=objeto.name.substr(2,1);
	for(i=0;i<num;i++){
		imprimir='imprimir';
		impr_truta='ip[0][impr_truta]';
		switch (objeto.form.elements[i].name) {
		    case imprimir :
			case impr_truta:
				//objeto.form.elements[i].disabled=estado;
		}
		if (objeto.value==32 ){
			document.buscador.n_folio.value=0;
			document.buscador.n_folio.readOnly=true;
		}
		else {
			document.buscador.n_folio.readOnly=false;
		}

	}
}


function habilitar(objeto) {
	num=objeto.form.elements.length;
	if (objeto.value==3 ){
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
	if (!existe_vvista){
			if (a_pagar < pago) { 
				return (1);
			}
			else {
				if (pago <= int_mul){
					return(2);
				}
				else {
					return(0);
				}
			}
	}
	else {
		return(0);
	}
}

function valida_vvista(formulario){
	var ok=true;	
	existe_vvista = false;
	num= formulario.elements.length;
	for (i=0;i<num;i++){
	nombre = formulario.elements[i].name;
	tipo	=	new RegExp ("ting_ccod","gi")
		if (tipo.test(nombre)){
			if (formulario.elements[i].value==14){
				existe_vvista=true;
			}
		}
	}
	if (existe_vvista){
		for (i=0;i< <%=nro%>;i++){
			if (formulario.elements["d["+i+"][ting_ccod]"].value != 14){
				ok = false;
			}
		}
		if (formulario.elements["i[0][ingr_mefectivo]"].value!=0){
			ok = false;
		}
	}
	return(ok);
}

function cerrarVentana() {
	self.close();
}


function modificar(formulario){
	var doctos='<%=nro%>';
	var flagret = false
	if (doctos >0){
		if(preValidaFormulario(formulario)){
			if (validar_nabono(formulario)){
				if (validar_monto_alumno(formulario)){
					if(compara_ndocto(formulario)){
						if(valida_vvista(formulario)){
							//if (!existe_vvista) {
								if (pagos(formulario)==1) {
									alert('El monto ingresado es mayor que el monto a pagar.');
								} else {
									if(pagos(formulario)==2){
										alert('Lo que va a abonar debe ser mayor a la suma de los intereses y las multas');
									} else {									
										formulario.total.value = pago;
										flagret  = true;
									}
								}
							//}
						} else {
							alert('Todas las formas de pago deben ser \"Vale Vista\" y el monto en efectivo = 0');
						}
					} else {
						alert('Ha ingresado documentos con el mismo número');
					}
				} else{
					//return (false);
				}
			} else {
				alert('El monto del pago con nota(s) de abono es mayor que el saldo de la(s) nota(s) de abono');
				//return(false);
			}			
		 } else {
			//return (false);
		 }
	} else {	
		if(preValidaFormulario(formulario)){
			if(compara_ndocto(formulario)){
				if (pagos(formulario)==1) {
					alert('El monto ingresado es mayor que el monto a pagar.');
				} else {
					if(pagos(formulario)==2){
						alert('Lo que va a abonar debe ser mayor a la suma de los intereses y las multas');
					} else {							
						formulario.total.value = pago;
						flagret = true
					}
				}
			} else{
				alert('Ha ingresado documentos con el mismo número');
			}			
		} else {
			//return (false);
		}
	}
	return flagret
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
<body bgcolor="#EAEAEA" leftmargin="0" topmargin="0" marginwidth="0" marginheight="0" onLoad="MM_preloadImages('../imagenes/botones/buscar_f2.gif','../images/bot_deshabilitar_f2.gif','../images/agregar2_f2_p.gif','im&amp;#225;genes/marco1_r3_c2_f2.gif');MM_preloadImages('im&amp;#225;genes/marco1_r3_c4_f2.gif');MM_preloadImages('im&amp;#225;genes/marco1_r3_c6_f2.gif');MM_preloadImages('im&amp;#225;genes/marco1_r3_c8_f2.gif');MM_preloadImages('../imagenes/botones/cargar_f2.gif','../imagenes/botones/continuar_f2.gif');deshabilitar(document.buscador.elements['i[0][ting_ccod]'])" onBlur="revisaVentana();"> 
<table width="711" border="0" cellpadding="0" cellspacing="0"> 
  <tr> </tr> 
  <tr> 
    <td valign="top" bgcolor="#EAEAEA"> <br> 
      <table width="90%" border="0" align="center" cellpadding="0" cellspacing="0"> 
        <tr> 
          <td><table border="0" cellpadding="0" cellspacing="0" width="100%"> 
              <!-- fwtable fwsrc="marco contenidos.png" fwbase="top.gif" fwstyle="Dreamweaver" fwdocid = "742308039" fwnested="0" --> 
              <tr> 
                <td><img src="../imagenes/spacer.gif" width="9" height="1" border="0" alt=""></td> 
                <td><img src="../imagenes/spacer.gif" width="100%" height="1" border="0" alt=""></td> 
                <td><img src="../imagenes/spacer.gif" width="7" height="1" border="0" alt=""></td> 
              </tr> 
              <tr> 
                <td><img name="top_r1_c1" src="../imagenes/top_r1_c1.gif" width="9" height="8" border="0" alt=""></td> 
                <td><img src="../imagenes/top_r1_c2.gif" alt="" name="top_r1_c2" width="100%" height="8" border="0"></td> 
                <td><img name="top_r1_c3" src="../imagenes/top_r1_c3.gif" width="7" height="8" border="0" alt=""></td> 
              </tr> 
              <tr> 
                <td><img name="top_r2_c1" src="../imagenes/top_r2_c1.gif" width="9" height="17" border="0" alt=""></td> 
                <td><table width="100%" border="0" cellspacing="0" cellpadding="0"> 
                    <tr> 
                      <td width="13" background="../imagenes/fondo1.gif"><img src="../imagenes/izq_1.gif" width="5" height="17"></td> 
                      <td width="214" valign="middle" background="../imagenes/fondo1.gif"> <div align="left"><font color="#FFFFFF" size="1" face="Verdana, Arial, Helvetica, sans-serif">Detalle de Recepci&oacute;n de Ingresos</font></div></td> 
                      <td width="443" bgcolor="#D8D8DE"><img src="../imagenes/derech1.gif" width="6" height="17"></td> 
                    </tr> 
                  </table></td> 
                <td><img name="top_r2_c3" src="../imagenes/top_r2_c3.gif" width="7" height="17" border="0" alt=""></td> 
              </tr> 
              <tr> 
                <td><img name="top_r3_c1" src="../imagenes/top_r3_c1.gif" width="9" height="2" border="0" alt=""></td> 
                <td><img name="top_r3_c2" src="../imagenes/top_r3_c2.gif" width="100%" height="2" border="0" alt=""></td> 
                <td><img name="top_r3_c3" src="../imagenes/top_r3_c3.gif" width="7" height="2" border="0" alt=""></td> 
              </tr> 
            </table> 
            <table width="100%" border="0" cellspacing="0" cellpadding="0"> 
              <tr> 
                <td width="9" align="left" background="../imagenes/izq.gif">&nbsp;</td> 
                <td bgcolor="#D8D8DE"> &nbsp; 
                  <form action="actualizar_pago.asp" method="post" name="buscador"> 
                    <strong> 
                    <input type="hidden" name="total"> 
                    <input type="hidden" name="rut" value="<%=rut%>"> 
                    <input type="hidden" name="h_inst_ccod" value="<%=v_inst_ccod%>"> 
                    <input type="hidden" name="h_inem_ccod" value="<%=v_inem_ccod%>"> 
                    <%
inp.procesaForm
if inp.nrofilas("CC_COMPROMISOS_PENDIENTES") >0 then
	z=0
	for i=0 to inp.nrofilas("CC_COMPROMISOS_PENDIENTES")-1
		'if inp.obtenerValor("cc_compromisos_pendientes",i,"DCOM_NCOMPROMISO") <> "" then
			z=z+1
			a=inp.obtenerValor("cc_compromisos_pendientes",i,"tcom_ccod")
			b=inp.obtenerValor("cc_compromisos_pendientes",i,"inst_ccod")
			c=inp.obtenerValor("cc_compromisos_pendientes",i,"comp_ndocto")
			d=inp.obtenerValor("cc_compromisos_pendientes",i,"dcom_mcompromiso_oculto")
			e=inp.obtenerValor("cc_compromisos_pendientes",i,"dcom_ncompromiso")
			f=inp.obtenerValor("cc_compromisos_pendientes",i,"abon_fabono")
			g=inp.obtenerValor("cc_compromisos_pendientes",i,"tcom_tdesc")
			p=inp.obtenerValor("cc_compromisos_pendientes",i,"pers_ncorr")
			'response.Write("<input type='hidden' name='cc_compromisos_pendientes["& i &"][pers_ncorr]' value='"& p &"'>")
			response.Write("<input type='hidden' name='cc_compromisos_pendientes["& i &"][dcom_ncompromiso]' value='"& e &"'>")
			response.Write("<input type='hidden' name='cc_compromisos_pendientes["& i &"][tcom_ccod]' value='"& a &"'>")
			response.Write("<input type='hidden' name='cc_compromisos_pendientes["& i &"][inst_ccod]' value='"& b &"'>")
			response.Write("<input type='hidden' name='cc_compromisos_pendientes["& i &"][comp_ndocto]' value='"& c &"'>")
			'response.Write("<input type='hidden' name='cc_compromisos_pendientes["& i &"][abono]' value='"& d &"'>")
			'response.Write("<input type='hidden' name='cc_compromisos_pendientes["& i &"][abon_fabono]' value='"& f &"'>")
			'response.Write("<input type='hidden' name='cc_compromisos_pendientes["& i &"][concepto]' value='"& g &"'>")
			response.Write("<input type='hidden' name='campos' value='"& z &"'>")	
		'end if
	next
end if

%> 
                    <input type="hidden" name="i[0][mcaj_ncorr]" value="<%=mcaj_ncorr%>"> 
                    <!-- ******************************* NUEVO  ***************************** --> 
                    <!-- <input type="hidden" name="nro_campos" value="<%=nro_campos%>">
                    <input type="hidden" name="nro_campos2" value="<%=nro_campos2%>"> --> 
                    <input type="hidden" name="cant_detalle" value="<%=nro%>"> 
                    <!-- ******************************* FIN NUEVO  ***************************** --> 
                    <table width="100%" cellpadding="0" cellspacing="0"> 
                      <tr> 
                        <td width="176" align="right" nowrap><strong>&nbsp;&nbsp;Monto a amortizar :</strong></td> 
                        <td width="72" nowrap><strong> $&nbsp; <%=suma%> </strong></td> 
                        <td colspan="2" align="right" nowrap><strong>Instituci&oacute;n a Pagar :</strong></td> 
                        <td colspan="3"> <%response.write(v_institucion)%> </td> 
                      </tr> 
                      <tr> 
                        <th align="right">Intereses :</th> 
                        <td>$ <strong><%=f_efec.dibujaCampo("ingr_mintereses")%></strong></td> 
                        <td width="136">&nbsp;</td> 
                        <td width="20">&nbsp;</td> 
                        <td width="104" align="right">&nbsp;</td> 
                        <td width="48" align="right">&nbsp;</td> 
                        <td width="112">&nbsp;</td> 
                      </tr> 
                      <tr> 
                        <th align="right" nowrap><strong>Multas : </strong></th> 
                        <td nowrap><strong>$<strong> <%=f_efec.dibujaCampo("ingr_mmultas")%></strong> </strong></td> 
                        <td colspan="2" align="right"><strong>Documento :</strong></td> 
                        <td><strong> <%=f_efec.dibujaCampo("ting_ccod")%> </strong></td> 
                        <td align="right"><strong> N&uacute;mero:&nbsp;</strong></td> 
                        <td align="left"> <strong>&nbsp; <%=coin_nfolio_referencia%>.
                          <input name="n_folio" type="hidden"  size="10" maxlength="8" id="IN-N" value="<%=coin_nfolio_referencia%>"> 
                          </strong> </td> 
                      </tr> 
                      <tr> 
                        <th align="right" nowrap>Total a pagar :</th> 
                        <td>$<strong> 
                          <input name="total_a_pagar" type="text" readonly="true" id="total_a_pagar" value="<%= suma %>" size="10" maxlength="9"> 
                          </strong></td> 
                        <td>&nbsp;</td> 
                        <td align="right"> <!--<input name="imprimir" type="checkbox" value="2"> </td> 
                        <td><strong>Imprimir Comprobante</strong></td> 
                        <td align="right"><!--e<strong>n&nbsp;</strong--></td> 
                        <td><%'=impresora.dibujacampo("impr_truta")%></td> 
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
                        <th align="right" nowrap> <!--    NUEVO    --> 
                          <% if  variable2.nrofilas("MM") = 0 then%> 
                          <strong>&nbsp;&nbsp;Monto en efectivo :</strong> 
                          <%end if%></th> 
                        <td align="left"><% if  variable2.nrofilas("MM") = 0 then%> 
                          <strong>$&nbsp;<%=f_efec.dibujaCampo("ingr_mefectivo")%></strong> 
                          <%end if%></td> 
                        <!--   FIN  NUEVO    --> 
                        <td> <input type="hidden" name="sede_ccod" value="<%=sede%>"> 
                          <input type="hidden" name="inem_ccod" value="<%=inem_ccod%>"> </td> 
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
                        <td align="left"> <br> 
                          <%if nro <> 0 then%> 
                          <strong>&nbsp; Detalle Pago con Documento(s)<br> 
                          </strong> 
                          <table width="98%" border="0" align="center" cellpadding="0" cellspacing="0"> 
                            <tr> 
                              <td align="center" valign="top"> <%form_docto.dibujaTabla()%> </td> 
                            </tr> 
                            <tr> 
                              <td align="center" valign="top">&nbsp;</td> 
                            </tr> 
                          </table> 
                          <%end if%> 
&nbsp; 
                          <table width="100%" border="0"> 
                            <tr> 
                              <td width="81%">&nbsp;</td> 
                              <td width="19%"> <div align="center"> 
                                  <%botonera.DibujaBoton "guardar"%> 
                                </div></td> 
                            </tr> 
                          </table> 
                      </tr> 
                    </table> 
                  </form> 
                  <br> </td> 
                <td width="7" align="right" background="../imagenes/der.gif">&nbsp;</td> 
              </tr> 
            </table> 
            <table width="100%" border="0" cellspacing="0" cellpadding="0"> 
              <tr> 
                <td width="9" rowspan="2"><img src="../imagenes/abajo_r1_c1.gif" width="9" height="28"></td> 
                <td width="129" bgcolor="#D8D8DE"><table width="90%"  border="0" align="center" cellpadding="0" cellspacing="0"> 
                    <tr> 
                      <td><div align="center"></div></td> 
                      <td><div align="center"> 
                          <%botonera.DibujaBoton "salir"%> 
                        </div></td> 
                    </tr> 
                  </table></td> 
                <td width="233" rowspan="2" background="../imagenes/abajo_r1_c4.gif"><img src="../imagenes/abajo_r1_c3.gif" width="12" height="28"></td> 
                <td width="315" rowspan="2" align="right" background="../imagenes/abajo_r1_c4.gif"><img src="../imagenes/abajo_r1_c5.gif" width="7" height="28"></td> 
              </tr> 
              <tr> 
                <td valign="bottom" bgcolor="#D8D8DE"><img src="../imagenes/abajo_r2_c2.gif" width="100%" height="8"></td> 
              </tr> 
            </table></td> 
        </tr> 
      </table></td> 
  </tr> 
</table> 
</body>
<script language="javascript">
	document.buscador.elements["i[0][ting_ccod]"].value=17
</script>
</html>
