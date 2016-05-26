<!-- #include file = "../biblioteca/_conexion.asp" -->
<!-- #include file = "../biblioteca/_negocio.asp" -->

<%
set conexion = new CConexion
conexion.Inicializar "upacifico"
'
set negocio = new CNegocio
negocio.Inicializa conexion
anos_ccod=request.Form("bu[0][anos_ccod]")	
tipo_mantenedora=request.Form("bu[0][tipo_mantenedora]")
tipo_indi=request.Form("bu[0][tipo_indi]") 	
sede=request.Form("bu[0][sede_ccod]")

if anos_ccod="" then
anos_ccod=2009
end if
%>
<script language="JavaScript" src="../biblioteca/tabla.js"></script>
<script language="JavaScript" src="../biblioteca/funciones.js"></script>
<script language="JavaScript" src="../biblioteca/validadores.js"></script>
<script language="JavaScript">

function ir_pagina()
{

var valor;
valor=<%=tipo_indi%>


if (valor ==1)
	{
		formulario=document.forms['direccion']
		p_url="m_1_1_a.asp"
		formulario.action = p_url;
		formulario.method = "post";
		formulario.submit();	
		
	}
else if (valor ==2)
	{
			
		formulario=document.forms['direccion']
		p_url="m_1_2.asp"
		formulario.action = p_url;
		formulario.method = "post";
		formulario.submit();
	}
else if (valor ==3)
	{
			
		formulario=document.forms['direccion']
		p_url="m_1_5_a.asp"
		formulario.action = p_url;
		formulario.method = "post";
		formulario.submit();
	}
else if (valor ==4)
	{
			
		formulario=document.forms['direccion']
		p_url="m_1_5_b.asp"
		formulario.action = p_url;
		formulario.method = "post";
		formulario.submit();
	}
else if (valor ==5)
	{
			
		formulario=document.forms['direccion']
		p_url="m_1_5_c.asp"
		formulario.action = p_url;
		formulario.method = "post";
		formulario.submit();
	}								

else if (valor == 72)
	{
			
		formulario=document.forms['direccion']
		p_url="m_1_6_a.asp"
		formulario.action = p_url;
		formulario.method = "post";
		formulario.submit();
	}	
else if (valor == 73)
	{
			
		formulario=document.forms['direccion']
		p_url="m_1_6_b.asp"
		formulario.action = p_url;
		formulario.method = "post";
		formulario.submit();
	}
else if (valor ==7)
	{
			
		formulario=document.forms['direccion']
		p_url="m_1_7_b.asp"
		formulario.action = p_url;
		formulario.method = "post";
		formulario.submit();
	}
else if (valor ==8)
	{
			
		formulario=document.forms['direccion']
		p_url="m_2_1_a.asp"
		formulario.action = p_url;
		formulario.method = "post";
		formulario.submit();
	}
else if (valor ==9)
	{
			
		formulario=document.forms['direccion']
		p_url="m_2_1_b.asp"
		formulario.action = p_url;
		formulario.method = "post";
		formulario.submit();
	}
else if (valor ==10)
	{
			
		formulario=document.forms['direccion']
		p_url="m_2_2_a.asp"
		formulario.action = p_url;
		formulario.method = "post";
		formulario.submit();
	}
	
else if (valor ==11)
	{
			
		formulario=document.forms['direccion']
		p_url="m_2_3_a.asp"
		formulario.action = p_url;
		formulario.method = "post";
		formulario.submit();
	}

else if (valor ==12)
	{
			
		formulario=document.forms['direccion']
		p_url="m_2_3_b.asp"
		formulario.action = p_url;
		formulario.method = "post";
		formulario.submit();
	}
	
else if (valor ==13)
	{
			
		formulario=document.forms['direccion']
		p_url="m_3_4_b.asp"
		formulario.action = p_url;
		formulario.method = "post";
		formulario.submit();
	}
else if (valor ==14)
	{
			
		formulario=document.forms['direccion']
		p_url="m_3_1_1_a.asp"
		formulario.action = p_url;
		formulario.method = "post";
		formulario.submit();
	}	
else if (valor ==15)
	{
			
		formulario=document.forms['direccion']
		p_url="m_3_4_a.asp"
		formulario.action = p_url;
		formulario.method = "post";
		formulario.submit();
	}
else if (valor ==16)
	{
			
		formulario=document.forms['direccion']
		p_url="m_1_1_b.asp"
		formulario.action = p_url;
		formulario.method = "post";
		formulario.submit();
	}
else if (valor ==17)
	{
			
		formulario=document.forms['direccion']
		p_url="m_1_3_a.asp"
		formulario.action = p_url;
		formulario.method = "post";
		formulario.submit();
	}		

else if (valor ==18)
	{
			
		formulario=document.forms['direccion']
		p_url="m_1_3_b.asp"
		formulario.action = p_url;
		formulario.method = "post";
		formulario.submit();
	}	
	
else if (valor ==19)
	{
			
		formulario=document.forms['direccion']
		p_url="m_1_4_a.asp"
		formulario.action = p_url;
		formulario.method = "post";
		formulario.submit();
	}
	
else if (valor ==20)
	{
			
		formulario=document.forms['direccion']
		p_url="m_1_8_a.asp"
		formulario.action = p_url;
		formulario.method = "post";
		formulario.submit();
	}
else if (valor ==21)
	{
			
		formulario=document.forms['direccion']
		p_url="m_1_8_c.asp"
		formulario.action = p_url;
		formulario.method = "post";
		formulario.submit();
	}	
else if (valor ==22)
	{
			
		formulario=document.forms['direccion']
		p_url="m_1_8_d.asp"
		formulario.action = p_url;
		formulario.method = "post";
		formulario.submit();
	}
else if (valor ==23)
	{
			
		formulario=document.forms['direccion']
		p_url="m_1_8_e.asp"
		formulario.action = p_url;
		formulario.method = "post";
		formulario.submit();
	}

else if (valor ==24)
	{
			
		formulario=document.forms['direccion']
		p_url="m_1_8_f.asp"
		formulario.action = p_url;
		formulario.method = "post";
		formulario.submit();
	}
else if (valor ==25)
	{
			
		formulario=document.forms['direccion']
		p_url="m_2_1_c.asp"
		formulario.action = p_url;
		formulario.method = "post";
		formulario.submit();
	}
else if (valor ==26)
	{
			
		formulario=document.forms['direccion']
		p_url="m_2_1_d.asp"
		formulario.action = p_url;
		formulario.method = "post";
		formulario.submit();
	}
	
else if (valor ==27)
	{
			
		formulario=document.forms['direccion']
		p_url="m_2_1_e.asp"
		formulario.action = p_url;
		formulario.method = "post";
		formulario.submit();
	}
	
else if (valor ==28)
	{
			
		formulario=document.forms['direccion']
		p_url="m_2_1_f.asp"
		formulario.action = p_url;
		formulario.method = "post";
		formulario.submit();
	}	
	
else if (valor ==29)
	{
			
		formulario=document.forms['direccion']
		p_url="m_2_1_g.asp"
		formulario.action = p_url;
		formulario.method = "post";
		formulario.submit();
	}
	
else if (valor ==30)
	{
			
		formulario=document.forms['direccion']
		p_url="m_2_3_c.asp"
		formulario.action = p_url;
		formulario.method = "post";
		formulario.submit();
	}	
else if (valor ==31)
	{
			
		formulario=document.forms['direccion']
		p_url="m_2_3_d.asp"
		formulario.action = p_url;
		formulario.method = "post";
		formulario.submit();
	}
else if (valor ==32)
	{
			
		formulario=document.forms['direccion']
		p_url="m_2_3_e.asp"
		formulario.action = p_url;
		formulario.method = "post";
		formulario.submit();
	}	

else if (valor ==33)
	{
			
		formulario=document.forms['direccion']
		p_url="m_2_4_a.asp"
		formulario.action = p_url;
		formulario.method = "post";
		formulario.submit();
	}
	
else if (valor ==34)
	{
			
		formulario=document.forms['direccion']
		p_url="m_2_4_b.asp"
		formulario.action = p_url;
		formulario.method = "post";
		formulario.submit();
	}

else if (valor ==35)
	{
			
		formulario=document.forms['direccion']
		p_url="m_2_4_c.asp"
		formulario.action = p_url;
		formulario.method = "post";
		formulario.submit();
	}		

else if (valor ==36)
	{
			
		formulario=document.forms['direccion']
		p_url="m_2_4_d.asp"
		formulario.action = p_url;
		formulario.method = "post";
		formulario.submit();
	}
else if (valor ==37)
	{
			
		formulario=document.forms['direccion']
		p_url="m_2_4_e.asp"
		formulario.action = p_url;
		formulario.method = "post";
		formulario.submit();
	}	
else if (valor ==38)
	{
			
		formulario=document.forms['direccion']
		p_url="m_2_4_f.asp"
		formulario.action = p_url;
		formulario.method = "post";
		formulario.submit();
	}
	
else if (valor ==39)
	{
			
		formulario=document.forms['direccion']
		p_url="m_3_1_b.asp"
		formulario.action = p_url;
		formulario.method = "post";
		formulario.submit();
	}
	
else if (valor ==40)
	{
			
		formulario=document.forms['direccion']
		p_url="m_3_2_a.asp"
		formulario.action = p_url;
		formulario.method = "post";
		formulario.submit();
	}
		
else if (valor ==41)
	{
			
		formulario=document.forms['direccion']
		p_url="m_3_2_b.asp"
		formulario.action = p_url;
		formulario.method = "post";
		formulario.submit();
	}	
else if (valor ==42)
	{
			
		formulario=document.forms['direccion']
		p_url="m_3_2_c.asp"
		formulario.action = p_url;
		formulario.method = "post";
		formulario.submit();
	}
else if (valor ==43)
	{
			
		formulario=document.forms['direccion']
		p_url="m_3_2_d.asp"
		formulario.action = p_url;
		formulario.method = "post";
		formulario.submit();
	}	
else if (valor ==44)
	{
			
		formulario=document.forms['direccion']
		p_url="m_3_2_e.asp"
		formulario.action = p_url;
		formulario.method = "post";
		formulario.submit();
	}	
else if (valor ==45)
	{
			
		formulario=document.forms['direccion']
		p_url="m_3_3_a.asp"
		formulario.action = p_url;
		formulario.method = "post";
		formulario.submit();
	}		
else if (valor ==46)
	{
			
		formulario=document.forms['direccion']
		p_url="m_3_3_b.asp"
		formulario.action = p_url;
		formulario.method = "post";
		formulario.submit();
	}	
	
else if (valor ==47)
	{
			
		formulario=document.forms['direccion']
		p_url="m_3_3_c.asp"
		formulario.action = p_url;
		formulario.method = "post";
		formulario.submit();
	}	
else if (valor ==48)
	{
			
		formulario=document.forms['direccion']
		p_url="m_3_3_d.asp"
		formulario.action = p_url;
		formulario.method = "post";
		formulario.submit();
	}	
else if (valor ==49)
	{
			
		formulario=document.forms['direccion']
		p_url="m_3_4_c.asp"
		formulario.action = p_url;
		formulario.method = "post";
		formulario.submit();
	}	
					
else if (valor ==50)
	{
			
		formulario=document.forms['direccion']
		p_url="m_4_1_a.asp"
		formulario.action = p_url;
		formulario.method = "post";
		formulario.submit();
	}
	
else if (valor ==51)
	{
			
		formulario=document.forms['direccion']
		p_url="m_4_1_b.asp"
		formulario.action = p_url;
		formulario.method = "post";
		formulario.submit();
	}
else if (valor ==52)
	{
			
		formulario=document.forms['direccion']
		p_url="m_4_2_a.asp"
		formulario.action = p_url;
		formulario.method = "post";
		formulario.submit();
	}
	
else if (valor ==53)
	{
			
		formulario=document.forms['direccion']
		p_url="m_4_2_b.asp"
		formulario.action = p_url;
		formulario.method = "post";
		formulario.submit();
	}
	
else if (valor ==54)
	{
			
		formulario=document.forms['direccion']
		p_url="m_4_2_c.asp"
		formulario.action = p_url;
		formulario.method = "post";
		formulario.submit();
	}		

else if (valor ==55)
	{
			
		formulario=document.forms['direccion']
		p_url="m_4_2_d.asp"
		formulario.action = p_url;
		formulario.method = "post";
		formulario.submit();
	}
	
else if (valor ==56)
	{
			
		formulario=document.forms['direccion']
		p_url="m_4_2_e.asp"
		formulario.action = p_url;
		formulario.method = "post";
		formulario.submit();
	}
else if (valor ==57)
	{
			
		formulario=document.forms['direccion']
		p_url="m_4_2_f.asp"
		formulario.action = p_url;
		formulario.method = "post";
		formulario.submit();
	}		
else if (valor ==58)
	{
			
		formulario=document.forms['direccion']
		p_url="m_4_2_g.asp"
		formulario.action = p_url;
		formulario.method = "post";
		formulario.submit();
	}
	
else if (valor ==59)
	{
			
		formulario=document.forms['direccion']
		p_url="m_4_2_h.asp"
		formulario.action = p_url;
		formulario.method = "post";
		formulario.submit();
	}
else if (valor ==60)
	{
			
		formulario=document.forms['direccion']
		p_url="m_4_2_i.asp"
		formulario.action = p_url;
		formulario.method = "post";
		formulario.submit();
	}		
else if (valor ==61)
	{
			
		formulario=document.forms['direccion']
		p_url="m_4_3_a.asp"
		formulario.action = p_url;
		formulario.method = "post";
		formulario.submit();
	}
	
else if (valor ==62)
	{
			
		formulario=document.forms['direccion']
		p_url="m_4_3_b.asp"
		formulario.action = p_url;
		formulario.method = "post";
		formulario.submit();
	}
	
else if (valor ==63)
	{
			
		formulario=document.forms['direccion']
		p_url="m_4_3_c.asp"
		formulario.action = p_url;
		formulario.method = "post";
		formulario.submit();
	}	
else if (valor ==64)
	{
			
		formulario=document.forms['direccion']
		p_url="m_4_4_a.asp"
		formulario.action = p_url;
		formulario.method = "post";
		formulario.submit();
	}
	
else if (valor ==65)
	{
			
		formulario=document.forms['direccion']
		p_url="m_4_4_b.asp"
		formulario.action = p_url;
		formulario.method = "post";
		formulario.submit();
	}
	
else if (valor ==66)
	{
			
		formulario=document.forms['direccion']
		p_url="m_4_4_c.asp"
		formulario.action = p_url;
		formulario.method = "post";
		formulario.submit();
	}
	
else if (valor ==67)
	{
			
		formulario=document.forms['direccion']
		p_url="m_4_4_d.asp"
		formulario.action = p_url;
		formulario.method = "post";
		formulario.submit();
	}
	
else if (valor ==68)
	{
			
		formulario=document.forms['direccion']
		p_url="m_4_4_e.asp"
		formulario.action = p_url;
		formulario.method = "post";
		formulario.submit();
	}	
else if (valor ==69)
	{
			
		formulario=document.forms['direccion']
		p_url="m_4_5_a.asp"
		formulario.action = p_url;
		formulario.method = "post";
		formulario.submit();
	}		
else if (valor ==70)
	{
			
		formulario=document.forms['direccion']
		p_url="m_4_5_b.asp"
		formulario.action = p_url;
		formulario.method = "post";
		formulario.submit();
	}	
	
else if (valor ==71)
	{
			
		formulario=document.forms['direccion']
		p_url="m_4_5_c.asp"
		formulario.action = p_url;
		formulario.method = "post";
		formulario.submit();
	}					
}

   
</script>
<body onLoad="ir_pagina();" bgcolor="#CC6600" leftmargin="0" topmargin="0" marginwidth="0" marginheight="0">
<form name="direccion">
<input type="hidden" name="bu[0][anos_ccod]" value="<%=anos_ccod%>">
<input type="hidden" name="bu[0][tipo_mantenedora]" value="<%=tipo_mantenedora%>">
<input type="hidden" name="bu[0][tipo_indi]" value="<%=tipo_indi%>">

</form>
<table align="center">
<tr>
  <td>&nbsp;</td>
</tr>
<tr>
  <td>&nbsp;</td>
</tr>
<tr align="center" valign="middle">
<td align="center">
	Espere Un momento mientras los Datos Se Cargar
</td>
</tr>
<tr>
  <td align="center">&nbsp;</td>
</tr>
</table>
</body>

