<%@LANGUAGE="VBSCRIPT" CODEPAGE="1252"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1" />
<title>Documento sin t&iacute;tulo</title>
</head>

<body>
</body>
</html>
<%
v_num_alumnos=46
v_limite_fac=15
suma=4895839 
v_tfac_ccod=0
fin_division=	v_num_alumnos \ v_limite_fac
resto		= 	v_num_alumnos mod v_limite_fac

response.Write("fin_division:"&fin_division&"| resto:"&resto)

if resto=0 then
	fin_division=fin_division-1
end if
v_monto_parte=clng(suma/(fin_division+1))
v_monto_alumno=clng(suma/v_num_alumnos)  '#### Monto correspondiente a cada alumno
v_monto_acumulado=0

'#### for generara tantas facturas como divisiones existan (casos de ordenes de compra con muchos alumnos)
for ind = 0 to fin_division
response.Write("<b><br>"&ind&"</b>")
	if v_cambio_anio=1 then '### para cuando es cambio de año (UN CURSO PASA DE UN AÑO PARA OTRO)
		
		if v_tfac_ccod=1 then
			if ind=0 then
				'bruto_ocupado	= clng(suma_total\2) valor al dividir en 2 cuotas iguales
				bruto_ocupado	= clng(vdario * v_primer_tramo)
				v_monto_neto	= clng(bruto_ocupado*0.81)   
				v_monto_iva 	= clng(bruto_ocupado-v_monto_neto)
			else
				saldo_bruto=clng(suma_total-bruto_ocupado)
				v_monto_neto=clng(saldo_bruto*0.81) 
				v_monto_iva =clng(saldo_bruto-v_monto_neto)
			end if
		else ' EXENTAS
			if ind=0 then
				'v_monto_neto=clng(suma_total\2)  valor al dividir en 2 cuotas iguales
				v_monto_neto=clng(vdario * v_primer_tramo)     
				v_monto_iva =0
				ocupado_neto=v_monto_neto
			else
				v_monto_neto=clng(suma_total-ocupado_neto)
				v_monto_iva =0
			end if
			
		end if	

	else ' ### para facturas con mas de 15 alumnos (ACA SE DEBE VERIFICAR QUE SI CAMBIA DE AÑO Y ADEMAS TIENE MAS DE 15 ALUMNOS)
	
		if v_num_alumnos>v_limite_fac and fin_division>0 then
			'response.Write(ind&"<<<"&fin_division)
				divi=ind-1
				if divi=0 then
					divi=1
				else
					divi=ind-1
				end if	
	'#### segun tipos de facuras se calculan los montos			
			if v_tfac_ccod=1 then
				if ind=fin_division then
					restantes=v_num_alumnos-(v_limite_fac* ind ) '#### los alumnos que sobran de dividir las facturas
					v_monto_neto	=clng((v_monto_alumno*restantes)*0.81)
					v_monto_iva		=clng((v_monto_alumno*restantes)-v_monto_neto)
					v_monto_parte	=suma-v_monto_acumulado
					v_monto_iva_parte=clng((v_monto_alumno*restantes)-v_monto_neto)
				else
					v_monto_neto	=clng((v_monto_alumno*v_limite_fac)*0.81)
					v_monto_iva		=clng((v_monto_alumno*v_limite_fac)-v_monto_neto)
					v_monto_acumulado=v_monto_acumulado+v_monto_parte
				end if
			else ' EXENTAS
			
				if ind=fin_division then '#### los alumnos que sobran de dividir las facturas
					'restantes=v_num_alumnos-(v_limite_fac*ind) 
					v_monto_neto	=suma-v_monto_acumulado
					v_monto_iva		=0
					v_monto_parte	=suma-v_monto_acumulado
				'response.Write("restantes "&restantes)				
				else
					v_monto_neto=v_monto_parte
					v_monto_iva=0
					v_monto_acumulado=v_monto_acumulado+v_monto_parte
				end if
	
			end if	
		else
			if v_tfac_ccod=1 then
				v_monto_neto	=	clng(suma*0.81)
				v_monto_iva		=	suma-v_monto_neto
			else
				v_monto_neto=suma
				v_monto_iva=0
			end if	
		end if

	end if ' Fin if tipos divisiones (por cambio de año o por cantidad de alumnos)
response.Write("<br>v_monto_neto"&v_monto_neto&" --> Parte:"&v_monto_parte)
response.Write("<br>v_monto_iva"&v_monto_iva&" -->Parte Iva:"&v_monto_iva_parte)
response.Write("<hr>")
next

response.Write("************************************************** <br>")
response.Write(suma)
%>