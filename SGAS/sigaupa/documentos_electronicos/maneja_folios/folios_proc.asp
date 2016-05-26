<!-- #include file = "../../biblioteca/_conexion.asp" -->
<!-- #include file = "../../biblioteca/_negocio_MVC.asp" -->
<%
cont = 0
for each x in request.Form
	
	'response.Write("<br>"&x&" : "&request.Form(x))
	'response.Write(request.Form("boleta["&cont&"][bole_ncorr]"))
	if request.Form("folio["&cont&"][foel_ccod]") = "" then
		cont = cont+1
	else
		foel_ccod = request.Form("folio["&cont&"][foel_ccod]")
		foel_nini  = request.Form("folio["&cont&"][foel_nini]")
		foel_nfin = request.Form("folio["&cont&"][foel_nfin]")
		foel_nact  = request.Form("folio["&cont&"][foel_nact]")
	end if
next

'response.Write("ccod: "&foel_ccod)
'response.Write("<br>nini: "&foel_nini)
'response.Write("<br>nfin: "&foel_nfin)
'response.Write("<br>nact: "&foel_nact)

set conexion = new CConexion
conexion.Inicializar "upacifico"

set negocio = new CNegocio
negocio.Inicializa conexion

user = negocio.ObtenerUsuario

sql_actualiza_folio = "update folios_electronicos set foel_nini="&foel_nini&", foel_nfin="&foel_nfin&", foel_nact="&foel_nact&", audi_tusuario="&user&",audi_fmodificacion=getdate() where foel_ccod="&foel_ccod

conexion.EjecutaS(sql_actualiza_folio)

%>

<script language="JavaScript" src="../../biblioteca/tabla.js"></script>
<script language="JavaScript" src="../../biblioteca/funciones.js"></script>
<script language="JavaScript" src="../../biblioteca/validadores.js"></script>
<script language="JavaScript" src="../../biblioteca/PopCalendar.js"></script>

<%
response.Write("<script>CerrarActualizar();</script>")
%>