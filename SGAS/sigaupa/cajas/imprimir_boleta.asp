<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1">
</head>
<body topmargin="0" onUnload="cerrar_pagina();">
<!-- #include file = "../biblioteca/_conexion.asp" -->
<!-- #include file = "../biblioteca/_negocio.asp" -->
<!-- #include file = "../biblioteca/funciones_formateo.asp" -->
<%
set conexion = new CConexion
conexion.Inicializar "upacifico"
set negocio = new CNegocio
negocio.Inicializa conexion
'------------datos sesiones-----------------------
	v_sucu_ncorr = negocio.ObtenerSede
	v_usuario = negocio.ObtenerUsuario
	Periodo = negocio.ObtenerPeriodoAcademico("POSTULACION")	
'-------------------------------------------------

Periodo=238 ' dato fijo para evitar equivocaciones

v_anio_admision=conexion.consultaUno("select anos_ccod from periodos_academicos where peri_ccod='"&Periodo&"'")

v_bole_ncorr = request.querystring("bole_ncorr")
v_pers_ncorr = Request.QueryString("pers_ncorr")
v_pers_ncorr_aval = Request.QueryString("pers_ncorr_aval")
flag = request.querystring("flag")

v_estado		=	conexion.ConsultaUno("select ebol_ccod from boletas where bole_ncorr="&v_bole_ncorr)
v_numero_boleta	=	conexion.ConsultaUno("select bole_nboleta from boletas where bole_ncorr="&v_bole_ncorr)
v_tbol_ccod		=	conexion.ConsultaUno("select tbol_ccod from boletas where bole_ncorr="&v_bole_ncorr)
v_inst_ccod		=	conexion.ConsultaUno("select isnull(inst_ccod,1) from boletas where bole_ncorr="&v_bole_ncorr)

if flag=1 then
	response.Write(v_anio_admision)
end if

 sql_tipo_pago="select count(*) from detalle_boletas a, tipos_detalle b " & vbCrLf &_
				" where a.tdet_ccod=b.tdet_ccod" & vbCrLf &_
				" and b.tcom_ccod=7 " & vbCrLf &_
				" and bole_ncorr='" & v_bole_ncorr & "'"
v_tipo_pago= conexion.consultaUno(sql_tipo_pago)

'-----------------------------------------------------------------------
set f_consulta_alumno = new CFormulario
f_consulta_alumno.Carga_Parametros "parametros.xml", "tabla"
f_consulta_alumno.inicializar conexion



consulta_alumno= "Select protic.obtener_rut(c.pers_ncorr) as rut_alumno,  "& vbCrLf &_
		" protic.obtener_nombre_completo(c.pers_ncorr,'n') as nombre_alumno,  "& vbCrLf &_
		" b.peri_ccod,protic.obtener_nombre_carrera(b.ofer_ncorr,'CJ') as carrera  "& vbCrLf &_
		" from personas c  "& vbCrLf &_
		"    left outer join alumnos a "& vbCrLf &_
		"        on  c.pers_ncorr=a.pers_ncorr  "& vbCrLf &_
		"    left outer join  ofertas_academicas b  "& vbCrLf &_
		"        on a.ofer_ncorr=b.ofer_ncorr "& vbCrLf &_
		"        and a.emat_ccod=1 "& vbCrLf &_
		" where c.pers_ncorr="&v_pers_ncorr&"  "& vbCrLf &_
		" order by b.peri_ccod desc,a.matr_ncorr desc "
			
'response.Write("<PRE>" & consulta_alumno & "</PRE>")
'response.End()

f_consulta_alumno.consultar consulta_alumno
f_consulta_alumno.siguiente

v_carrera_alumno	=	f_consulta_alumno.ObtenerValor ("carrera")
v_rut_alumno	=	f_consulta_alumno.ObtenerValor ("rut_alumno")


'---------------------------------------------------------------------------------
set f_consulta_aval = new CFormulario
f_consulta_aval.Carga_Parametros "parametros.xml", "tabla"
f_consulta_aval.inicializar conexion



if v_tipo_pago>0 then
consulta = " Select protic.obtener_rut(a.pers_ncorr) as rut_aval, protic.obtener_nombre_completo(a.pers_ncorr,'n') as nombre_aval, "& vbCrLf &_
			 " c.ciud_tcomuna, c.ciud_tdesc, isnull(protic.obtener_direccion_letra(a.pers_ncorr,1,'CNPB'),protic.obtener_direccion(a.pers_ncorr,1,'CNPB')) as direccion "& vbCrLf &_
			 " From personas a "& vbCrLf &_
			 " LEFT OUTER JOIN direcciones b "& vbCrLf &_
			 "   ON A.pers_ncorr = B.pers_ncorr "& vbCrLf &_
			 "   and b.tdir_ccod = 1 "& vbCrLf &_ 
			 " LEFT OUTER JOIN ciudades c "& vbCrLf &_
			 "   ON b.ciud_ccod = c.ciud_ccod  "& vbCrLf &_
			 " where a.pers_ncorr= '"&v_pers_ncorr_aval&"' "

else
consulta = " Select protic.obtener_rut(a.pers_ncorr) as rut_aval, protic.obtener_nombre_completo(a.pers_ncorr,'n') as nombre_aval, "& vbCrLf &_
			 " c.ciud_tcomuna, c.ciud_tdesc, protic.obtener_direccion_letra(a.pers_ncorr,1,'CNPB') as direccion "& vbCrLf &_
			 " From personas_POSTULANTE a "& vbCrLf &_
			 " LEFT OUTER JOIN direcciones b "& vbCrLf &_
			 "   ON A.pers_ncorr = B.pers_ncorr "& vbCrLf &_
			 "   and b.tdir_ccod = 1 "& vbCrLf &_ 
			 " LEFT OUTER JOIN ciudades c "& vbCrLf &_
			 "   ON b.ciud_ccod = c.ciud_ccod  "& vbCrLf &_
			 " where a.pers_ncorr= '"&v_pers_ncorr_aval&"' "
end if			 

'response.Write("<PRE>" & consulta & "</PRE>")
f_consulta_aval.consultar consulta
f_consulta_aval.siguiente

v_nombre_aval	=	f_consulta_aval.ObtenerValor ("nombre_aval")
v_rut_aval		=	f_consulta_aval.ObtenerValor ("rut_aval")
v_comuna_aval	=	f_consulta_aval.ObtenerValor ("ciud_tdesc")
v_ciudad_aval	=	f_consulta_aval.ObtenerValor ("ciud_tcomuna")
v_direccion_aval=	f_consulta_aval.ObtenerValor ("direccion")




'---------------------------------------------------------------------------------
set f_consulta_compromiso = new CFormulario
f_consulta_compromiso.Carga_Parametros "parametros.xml", "tabla"
f_consulta_compromiso.inicializar conexion

	consulta	 =  " Select tdet_tdesc + case when d.tcom_ccod in (1,2) then ' ("&v_anio_admision&")' else '' end as tdet_tdesc, " & vbCrLf &_
					" dbol_mtotal as c_dbol_mtotal , protic.trunc(a.bole_fboleta) as fecha_boleta ,* " & vbCrLf &_
					" from boletas a, detalle_boletas b, personas c, TIPOS_DETALLE d " & vbCrLf &_
					" where a.bole_ncorr=b.bole_ncorr " & vbCrLf &_
					" and a.pers_ncorr=c.pers_ncorr " & vbCrLf &_
					" and b.tdet_ccod=d.tdet_ccod " & vbCrLf &_
					" and a.bole_ncorr = '" & v_bole_ncorr & "'" & vbCrLf &_
					"order by b.tdet_ccod desc"

		
f_consulta_compromiso.consultar consulta
f_consulta_compromiso.siguiente
'-----------------------------------------------------------------
' Funcion para dibujar texto alineado
function Ac(texto,ancho,alineado)
    largo =Len(Trim(texto))
	if isnull(largo) then largo=0
	if largo > ancho then largo=ancho
    if ucase(alineado) = "D" then 
	   Ac=space(ancho-largo)&Left(texto,largo)
	else
	   Ac=Left(texto,cint(largo))&space(ancho-largo)
	end if   
end function

function nombre_Mes(valor)
if valor=1 then
	nombre_Mes="Enero"
elseif valor=2 then
    nombre_Mes="Febrero"
elseif valor=3 then
    nombre_Mes="Marzo"
elseif valor=4 then
    nombre_Mes="Abril"
elseif valor=5 then
    nombre_Mes="Mayo"
elseif valor=6 then
    nombre_Mes="Junio"
elseif valor=7 then
    nombre_Mes="Julio"
elseif valor=8 then
    nombre_Mes="Agosto"
elseif valor=9 then
    nombre_Mes="Septiembre"
elseif valor=10 then
    nombre_Mes="Octubre"
elseif valor=11 then
    nombre_Mes="Noviembre"
elseif valor=12 then
    nombre_Mes="Diciembre"
end if
end function
'-----------------------------------------------------------------
sin_totales=0
'for each x in Request.Form
 'response.write("<br>"& x & "="& Request.Form(x))
'Next
v_num_boleta	= f_consulta_compromiso.ObtenerValor ("bole_nboleta")

FechaObtenida	= f_consulta_compromiso.ObtenerValor ("fecha_boleta")

'response.Write(FechaObtenida)
if not EsVacio(FechaObtenida)  then
	arr_fecha=split(FechaObtenida,"/")
	Dia=arr_fecha(0)
	Mes2=nombre_Mes(arr_fecha(1))
	Ano=arr_fecha(2)
end if

'###############################################################################################
'#################################		IMPRESION DE BOLETA		################################
'###############################################################################################

'---------------------------------------------------------------
' Sangria encabezado
'---------------------------------------------------------------

   	'archivo = archivo &Ac("h " ,4,"I")& chr(13) & chr(10) & Ac("b " ,4,"I")& space(5) & Ac("c " ,4,"I")
   	archivo = archivo &  space(10) & space(60) & Ac("N°:" ,3,"I") & Ac(v_num_boleta,7,"I")
'---------------------------------------------------------------
' datos generales (glosa)
'---------------------------------------------------------------
   archivo = archivo & chr(13) & chr(10) &  space(10) & Ac(Dia,6,"C")& Ac(" " ,4,"I") & Ac(Mes2,22,"C") & Ac(" " ,4,"I") & Ac(Ano,4,"I")&  space(20) 
   
   archivo = archivo & chr(13) & chr(10) &  space(10) &Ac(v_nombre_aval,50,"I")& Ac(" ",3,"I") & Ac(v_rut_aval,12,"D")
   archivo = archivo & chr(13) & chr(10) &  space(10) & v_direccion_aval
   archivo = archivo & chr(13) & chr(10) &  space(10) & Ac(v_comuna_aval,40,"I")& Ac(" ",6,"I") & Ac(v_ciudad_aval,20,"I")
   archivo = archivo & chr(13) & chr(10) &  space(5)
   archivo = archivo & chr(13) & chr(10) &  space(5)
   archivo = archivo & chr(13) & chr(10) &  space(5)
   contador=0
   columna=20
   total=0
   
f_consulta_compromiso.primero
   while f_consulta_compromiso.Siguiente 
	     datos= chr(13) & chr(10) & space(10) 
		 datos= datos & Ac("",4,"I") & Ac(f_consulta_compromiso.ObtenerValor("tdet_tdesc"),40,"C")
		 'columna=columna-24
		 columna=15
		 datos =datos &Ac(" ",columna,"I")& Ac("$ ",1,"I") & AC(FormatNumber(f_consulta_compromiso.ObtenerValor("c_dbol_mtotal"),0,-1,0,-1),10,"D")
		 total = cdbl(total) + cdbl(f_consulta_compromiso.ObtenerValor("c_dbol_mtotal"))
		 archivo= archivo & datos
		 contador= contador + 1
   wend 
   
   
   archivo = archivo & chr(13) & chr(10) &  space(6)
   
   archivo = archivo & chr(13) & chr(10) &  space(45) & Ac("TOTAL  ",24,"I")& Ac("$ ",1,"I") & Ac(FormatNumber(cdbl(total),0,-1,0,-1),10,"D")
   
   archivo = archivo & chr(13) & chr(10) &  space(6)
if v_inst_ccod="1" then
   archivo = archivo & chr(13) & chr(10) &  space(20) & Ac("CARRERA:  ",12,"I")& Ac(v_carrera_alumno,50,"I")
   archivo = archivo & chr(13) & chr(10) &  space(20) & Ac("RUT ALUMNO:  ",12,"I")& Ac(v_rut_alumno,13,"I")
else
   archivo = archivo & chr(13) & chr(10) &  space(20)
   archivo = archivo & chr(13) & chr(10) &  space(20)
end if
   response.Write("<pre>" & archivo & "</pre>")
   response.Flush()

'###############################################################################################
'#################################	FIN IMPRESION DE BOLETA		################################
'###############################################################################################
   'impresora  	= 	"\\mriffo\Okid"
   'Set oFile      = CreateObject("Scripting.FileSystemObject")
   'Set oPrinter   = oFile.CreateTextFile(impresora) 

   'Set oPrinter   = oFile.CreateTextFile(impresora, true, true) 
   
   'oPrinter.write("Test")
 
   'Set oWshnet    = Nothing
   'Set oFile      = Nothing
   'set oPrinter   = Nothing
   'set iPrinter   = Nothing 
   
%>
<script language="javascript1.1">
window.print();
</script>
<script language="javascript1.1">

function cerrar_pagina(){
mensaje="Se ha impreso correctamente la boleta ??";
var estado='<%=v_estado%>';
	if ((estado!='2') && (estado!='3')){
		if (confirm(mensaje)){
			window.opener.location.href="../cajas/proc_cierra_boleta.asp?cod_boleta=<%=v_bole_ncorr%>";
		}else{
			url_ventana="../cajas/ver_boletas.asp?busqueda[0][bole_nboleta]=<%=v_numero_boleta%>&busqueda[0][tbol_ccod]=<%=v_tbol_ccod%>";
			window.open(url_ventana,"ventana_maneja","");
			window.opener.close();
		}
	}
}
</script>
</body>
</html>

