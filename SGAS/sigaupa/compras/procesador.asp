<!-- #include file = "../biblioteca/_conexion.asp" -->
<!-- #include file = "../biblioteca/_conexion_softland.asp" -->

<%
set conexion = new Cconexion2
conexion.Inicializar "upacifico"
Function codigo_veri(rut)
	tur=strreverse(rut)
	mult = 2

	for i = 1 to len(tur)
		if mult > 7 then mult = 2 end if
		
		suma = mult * mid(tur,i,1) + suma
		mult = mult +1
	next

	valor = 11 - (suma mod 11)

	if valor = 11 then
		codigo_veri = "0"
	elseif valor = 10 then
		codigo_veri = "k"
	else
		codigo_veri = valor
	end if
end function 

run	= request.Form("run")

set f_rut = new cFormulario
f_rut.carga_parametros "tabla_vacia.xml", "tabla_vacia"
f_rut.inicializar conexion

sql_datos_persona= " Select top 1 codaux as pers_nrut,NomAux as pers_tnombre, NomAux as v_nombre "&_
					   	" from softland.cwtauxi a "&_
					   	" where CodAux='"&run&"'"

'response.write(sql_datos_persona)
'response.end()
						
f_rut.consultar sql_datos_persona
f_rut.Siguiente	
					
v_nombre=f_rut.obtenerValor("v_nombre")
v_xdv=codigo_veri(run)

xml="<?xml version='1.0' encoding='ISO-8859-1'?>"
xml=xml&"<datos>"
xml=xml&"<funcionario><![CDATA["&v_nombre&"]]></funcionario>"
xml=xml&"<xdv><![CDATA["&v_xdv&"]]></xdv>"
xml=xml&"</datos>"
response.ContentType = "text/xml"
response.Write(xml)
%>