<!-- #include file = "../biblioteca/_conexion.asp" -->
<!-- #include file = "../biblioteca/_negocio.asp" -->

<%

'for each x in request.form
'	response.write("<br>"&x&"->"&request.form(x))
'next
'response.end()


set conexion = new CConexion
conexion.Inicializar "upacifico"

set negocio = new CNegocio
negocio.Inicializa conexion


v_observaciones1=request.Form("mmm[0][OBSERVACIONES1]")
v_observaciones2=request.Form("mmm[0][OBSERVACIONES2]")
v_tcat_ccod=request.Form("mmm[0][TCAT_CCOD]")
v_tcat_ccod_1=request.Form("mmm[0][TCAT_CCOD_1]")
v_tcat_ccod_2=request.Form("mmm[0][TCAT_CCOD_2]")
v_tcat_ccod_3=request.Form("mmm[0][TCAT_CCOD_3]")
carr_ccod = request.querystring("carr_ccod")
pers_ncorr = request.querystring("pers_ncorr")
peri_ccod = negocio.obtenerPeriodoAcademico("PLANIFICACION")
jorn_ccod = request.querystring("JORN_ccod")
sede_ccod = request.querystring("SEDE_ccod")

if v_tcat_ccod_1="" then
	v_tcat_ccod_1="null"
end if
if v_tcat_ccod_2="" then
	v_tcat_ccod_2="null"
end if
if v_tcat_ccod_3="" then
	v_tcat_ccod_3="null"
end if

set f_periodos = new CFormulario
f_periodos.Carga_Parametros "tabla_vacia.xml", "tabla"
f_periodos.Inicializar conexion


	sql_periodos= "select b.peri_ccod "&_
					"from periodos_academicos a, periodos_academicos b "&_
					"where a.anos_ccod=b.anos_ccod "&_
					"and a.peri_ccod="& peri_ccod &" order by b.peri_ccod desc "
'response.Write("<pre>"&sql_periodos&"</pre>")
'response.end()

	f_periodos.Consultar sql_periodos
	cantidad=f_periodos.nroFilas

	if cantidad >0  then
		while f_periodos.siguiente
				
			v_periodo=f_periodos.ObtenerValor ("peri_ccod")
			
				sql_actualiza = " update CARRERAS_DOCENTE set  OBSERVACIONES1='"&v_observaciones1&"' ,OBSERVACIONES2='"&v_observaciones2&"', "&_ 
								" tcat_ccod="&v_tcat_ccod&",tcat_ccod_1="&v_tcat_ccod_1&",tcat_ccod_2="&v_tcat_ccod_2&",tcat_ccod_3="&v_tcat_ccod_3&",  "&_ 
								" audi_tusuario="&session("rut_usuario")&" ,audi_fmodificacion=getdate() "&_ 								
								" where peri_ccod="&v_periodo&" and sede_ccod="&sede_ccod&" " &_
								" and pers_ncorr="&pers_ncorr&" and carr_ccod='"&carr_ccod&"' and jorn_ccod="&jorn_ccod&" "				
'response.Write("<pre>"&sql_actualiza&"</pre><br>")
'response.Flush()
				conexion.ejecutas (sql_actualiza)		

		wend	
	end if

'conexion.estadotransaccion false  'roolback 
'response.End()
%>
<script language="JavaScript" src="../biblioteca/funciones.js"></script>
<script language="JavaScript">
CerrarActualizar();
</script>