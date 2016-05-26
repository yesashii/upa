<!-- #include file = "../biblioteca/_conexion.asp" -->
<!-- #include file = "../biblioteca/_negocio.asp" -->
<%
for each k in request.form
	response.Write(k&" = "&request.Form(k)&"<br>")
next

set conectar = new CConexion
conectar.Inicializar "upacifico"

set negocio = new CNegocio
negocio.Inicializa conectar

set f_horarios = new cformulario
sede_ccod	=	negocio.obtenersede


sql ="select count(*) from " &_
	 " horarios_sedes where sede_ccod = '"&sede_ccod &"' " &_
	 " and hora_ccod ='"&request.Form("ag_s[0][hora_ccod]")&"'"

v_update = conectar.consultauno(sql)

if v_update>0 then
'sentencia = " update horarios_sedes " &_
'			 " set hora_ccod = '"&request.Form("ag_s[0][hora_ccod]")&"'," & _
'			 " SEDE_CCOD = '"&sede_ccod&"', "& _
'			 " HORA_HINICIO = to_date('"&request.Form("ag_s[0][hora_hinicio]")&"','hh24:mi') ,  " & _
'			 " HORA_HTERMINO =to_date('"&request.Form("ag_s[0][hora_htermino]")&"','hh24:mi') ,  " & _
'			 " AUDI_TUSUARIO='"&negocio.obtenerusuario&"',  " & _
'			 " AUDI_FMODIFICACION = SYSDATE  " & _
'			 " where HORA_CCOD = '"&request.Form("ag_s[0][hora_ccod]")&"' and SEDE_CCOD = '"&sede_ccod&"' "

sentencia = " update horarios_sedes " &_
			 " set hora_ccod = '"&request.Form("ag_s[0][hora_ccod]")&"'," & _
			 " SEDE_CCOD = '"&sede_ccod&"', "& _
			 " HORA_HINICIO = convert(datetime,'"&request.Form("ag_s[0][hora_hinicio]")&"',108) ,  " & _
			 " HORA_HTERMINO =convert(datetime,'"&request.Form("ag_s[0][hora_htermino]")&"',108) ,  " & _
			 " AUDI_TUSUARIO='"&negocio.obtenerusuario&"',  " & _
			 " AUDI_FMODIFICACION = getdate()  " & _
			 " where HORA_CCOD = '"&request.Form("ag_s[0][hora_ccod]")&"' and SEDE_CCOD = '"&sede_ccod&"' "
else
'response.Write("sede_ccod "&sede_ccod)
sentencia=" insert into horarios_sedes (hora_ccod,SEDE_CCOD,HORA_HINICIO,HORA_HTERMINO,AUDI_TUSUARIO,AUDI_FMODIFICACION)" & _
" values ('"&request.Form("ag_s[0][hora_ccod]")&"','"&sede_ccod&"',convert(datetime,'"&request.Form("ag_s[0][hora_hinicio]")&"',108), " & _
" convert(datetime,'"&request.Form("ag_s[0][hora_htermino]")&"',108) , '"&negocio.obtenerusuario&"',getdate()) "
end if
'response.Write("consulta "& sentencia)
'response.End()
conectar.EstadoTransaccion conectar.EjecutaS(sentencia)
'response.Redirect(request.ServerVariables("HTTP_REFERER"))
%>
<script language="javascript" src="../biblioteca/funciones.js"></script>
<script language="javascript">
	self.opener.location.reload();
	window.close();
</script>