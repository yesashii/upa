A&ntilde;o de Promoci&oacute;n	:
<select name="selectAnioPromo" id="selectAnioPromo">
	<option value="0">todos</option>	
<%
	anioInicio = 1976
	anioTermino = Cint(Year(Date))
	anioAux = anioTermino
	for varfor = anioInicio to anioTermino
	%>
    	<option value="<% response.Write(CStr(anioAux))%>"><%response.Write(CStr(anioAux))%></option>
	<%
	anioAux = anioAux - 1
	next	
%>    							  
</select> 

