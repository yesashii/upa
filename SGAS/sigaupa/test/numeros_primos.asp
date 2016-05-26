<!-- #include file = "../biblioteca/_conexion.asp" -->
<!-- #include file = "../biblioteca/_negocio.asp" -->

<%
'dim numero,contador,coincide
'contador 	= 	1
'numero 		= 	20
'coincide	=	true
'	do while contador < numero-1
'		if numero mod contador = 0 then
'		   coincide=false
'		else
'		   coincide=true
'		   'response.Write("<br> aa"&contador)
'		end if
'		
'		
'		response.flush()
'		if not coincide then 
'			response.write  " Primos:"&contador &","
'		end if
'		contador=contador+1
'	loop
'
'
'
'dim a, b, c
'a =	0
'b =	0
'c = true
'   for a = 1 to  a <= 100
'		for b = 1 to b <= a
'			if a mod b = 0 then
'			   c = true
'			else
'				c = false
'			end if
'		next
'		if not c then
'		   Response.Write("<center> Salida:"& a &"<br></center>")
'		end if
'next	
''------------------------------------------------------------------------------


n1 = 1 
n2 = 50
for i = 1 to n2 step 1
	nDiv = 0  
	for n = 1 to i step 1 
		salida= i mod n
		if  salida= 0 then 
			nDiv = nDiv + 1 
		end if
	next
	if nDiv = 2 or i = 1 then 
		response.Write(i&",")
	end if
next
%>