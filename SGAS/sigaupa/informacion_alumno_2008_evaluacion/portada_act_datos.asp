<%
Rut = session("rut_usuario")
URL = "Act_Usuarios.asp?pers_nrut="&Rut
'response.Write(URL)
%>
<frameset rows="128,*" border=0> 
<frame name="superior" src="frame_superior.asp" noresize scrolling="no">

<frameset cols="270,*"> 

<frame name="izquierda" src="calendario_izquierda.asp" noresize scrolling="no">
<frame name="central" src="<%=URL%>" noresize> 
</frameset> 

</frameset>