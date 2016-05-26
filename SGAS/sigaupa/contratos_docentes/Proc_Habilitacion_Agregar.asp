<!-- #include file = "../biblioteca/_conexion.asp" -->

<%

'for each x in request.querystring
'	response.write("<br>"&x&"->"&request.querystring(x))
'next
'response.end()

set conexion = new CConexion
conexion.Inicializar "upacifico"

carr_ccod = request.querystring("carr_ccod")
pers_ncorr = request.querystring("pers_ncorr")
peri_ccod = request.querystring("peri_ccod")
sede_ccod = request.querystring("sede_ccod")
jorn_ccod = request.querystring("jorn_ccod")


set f_periodos = new CFormulario
f_periodos.Carga_Parametros "tabla_vacia.xml", "tabla"
f_periodos.Inicializar conexion

v_periodo_lectivo=conexion.ConsultaUno("select plec_ccod from periodos_academicos where peri_ccod="&peri_ccod)

sql_cat_antigua=" select top 1 tcat_ccod  "&_
				"from CARRERAS_DOCENTE a, periodos_academicos b "&_
				"where sede_ccod ="&sede_ccod&" "&_
				"and pers_ncorr  ="&pers_ncorr&" "&_
				"and carr_ccod   ='"& carr_ccod & "' "&_
				"and jorn_ccod   ="& jorn_ccod & " "&_
				"and a.peri_ccod=b.peri_ccod "&_
				"and a.tcat_ccod is not null "&_
				"and anos_ccod not in (select anos_ccod from periodos_academicos pa where peri_ccod="& peri_ccod &") "&_
				"order by a.peri_ccod desc "
'response.Write(sql_cat_antigua)
v_tcat_ant	=conexion.ConsultaUno(sql_cat_antigua)


sql_cat_actual	="select tcat_ccod from tipos_categoria where cast(tcat_ccod_referencia as varchar)='"&v_tcat_ant&"'"
'response.Write(sql_cat_actual&"<br>")
v_tcat_actual	=conexion.ConsultaUno(sql_cat_actual)

if v_tcat_actual<>"" then
	v_tcat_actual=v_tcat_actual
else
	v_tcat_actual="null"
end if


if v_periodo_lectivo="1" or v_periodo_lectivo="2" then
	sql_periodos= "select b.peri_ccod "&_
					"from periodos_academicos a, periodos_academicos b "&_
					"where a.anos_ccod=b.anos_ccod "&_
					"and a.peri_ccod="& peri_ccod &" order by b.peri_ccod desc"
	
	f_periodos.Consultar sql_periodos
	
	cantidad=f_periodos.nroFilas
	if cantidad >0  then
		while f_periodos.siguiente
				
			v_periodo=f_periodos.ObtenerValor("peri_ccod")
			v_existe_periodo=conexion.ConsultaUno("select count(*) from CARRERAS_DOCENTE where peri_ccod="&v_periodo&" and sede_ccod="&sede_ccod&" and pers_ncorr="&pers_ncorr&" and carr_ccod='"& carr_ccod & "' and jorn_ccod="& jorn_ccod & " ")
'response.Write("<hr>"&v_existe_periodo&"")			
			if (cint(v_periodo) <> cint(peri_ccod)) and v_existe_periodo=0 then
				'crea un registro por cada periodo académico que ha sido creado, excluyendo al periodo actual
				sql_insert=	" insert into CARRERAS_DOCENTE (tcat_ccod,peri_ccod,sede_ccod,pers_ncorr,carr_ccod,jorn_ccod,audi_tusuario,audi_fmodificacion) "&_
					" values ("&v_tcat_actual&","&v_periodo&","&sede_ccod&","&pers_ncorr&",'"& carr_ccod & "',"& jorn_ccod & ","&session("rut_usuario")&",getdate()) "
'response.Write("<br> perido :"&cint(v_periodo)&" <> "&peri_ccod&" ")
'response.Write("<hr> otro periodo : "&sql_insert)
				conexion.ejecutas (sql_insert)		
			end if
		wend	
	end if
end if ' Fin del if que regula si pertenece al primer semestre del Año Académico

sql_inserta=	" insert into CARRERAS_DOCENTE (tcat_ccod,peri_ccod,sede_ccod,pers_ncorr,carr_ccod,jorn_ccod,audi_tusuario,audi_fmodificacion) "&_
				" values ("&v_tcat_actual&","&peri_ccod&","&sede_ccod&","&pers_ncorr&",'"& carr_ccod & "',"& jorn_ccod & ","&session("rut_usuario")&",getdate()) "
'response.Write(" Sql : "&sql_inserta)
'response.Write("<br>1 "&conexion.obtenerEstadoTransaccion)
conexion.ejecutas(sql_inserta)
'response.End()


'response.Write("<br>2 "&conexion.obtenerEstadoTransaccion)
'conexion.estadoTransaccion false
'response.End()

%>
<script language="JavaScript" src="../biblioteca/funciones.js"></script>
<script language="JavaScript">
CerrarActualizar();
</script>