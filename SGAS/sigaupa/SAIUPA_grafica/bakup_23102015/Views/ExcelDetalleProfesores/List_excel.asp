      <%
	    Response.AddHeader "Content-Disposition", "attachment;filename=detalle_profesores.xls"
        Response.ContentType = "application/vnd.ms-excel"
	  %>
      <script type="text/javascript">
          //two variables Controller and Action have to be initialized in the View HTML code
          var Controller ='ExcelDetalleProfesores';
          var Action = 'List_excel';
      </script>
      <%
	  chequeo_2005="checked='checked'"
	  chequeo_2006="checked='checked'"
	  chequeo_2007="checked='checked'"
	  chequeo_2008="checked='checked'"
	  chequeo_2009="checked='checked'"
	  chequeo_2010="checked='checked'"
	  chequeo_2011="checked='checked'"
	  chequeo_2012="checked='checked'"
	  chequeo_2013="checked='checked'"
	  if request.QueryString("e2005")="" then
	  	chequeo_2005=""
	  end if
	  if request.QueryString("e2006")="" then
	  	chequeo_2006=""
	  end if
	  if request.QueryString("e2007")="" then
	  	chequeo_2007=""
	  end if
	  if request.QueryString("e2008")="" then
	  	chequeo_2008=""
	  end if
	  if request.QueryString("e2009")="" then
	  	chequeo_2009=""
	  end if
	  if request.QueryString("e2010")="" then
	  	chequeo_2010=""
	  end if
	  if request.QueryString("e2011")="" then
	  	chequeo_2011=""
	  end if
	  if request.QueryString("e2012")="" then
	  	chequeo_2012=""
	  end if
	  if request.QueryString("e2013")="" then
	  	chequeo_2013=""
	  end if
	  %>
      <html>
      <head>
      <title>Detalle profesores</title>
      <meta http-equiv="Content-Type" content="text/html;">
      </head>
      <body >
      <table width="100%">
       	<tr>
        	          <th align="center" bgcolor="#99CC00">A&ntilde;o</th>
        	          <th align="center" bgcolor="#99CC00">Rut</th>	
        	          <th align="center" bgcolor="#99CC00">Ap.Paterno</th>	
        	          <th align="center" bgcolor="#99CC00">Ap.Materno</th>
        	          <th align="center" bgcolor="#99CC00">Nombre</th>
        	          <th align="center" bgcolor="#99CC00">Sexo</th>
        	          <th align="center" bgcolor="#99CC00">Fecha Nacimiento</th>	 
        	          <th align="center" bgcolor="#99CC00">Nacionalidad</th>
        	          <th align="center" bgcolor="#99CC00">Año Inst</th>	
        	          <th align="center" bgcolor="#99CC00">P Unidad</th>
        	          <th align="center" bgcolor="#99CC00">P Region</th>
        	          <th align="center" bgcolor="#99CC00">S Unidad</th>
        	          <th align="center" bgcolor="#99CC00">S Region</th>
        	          <th align="center" bgcolor="#99CC00">Nivel Acad</th>
        	          <th align="center" bgcolor="#99CC00">Titulo</th>
        	          <th align="center" bgcolor="#99CC00">Inst Titulo</th>	
        	          <th align="center" bgcolor="#99CC00">Pais Titulo</th>	
        	          <th align="center" bgcolor="#99CC00">Fecha Titulo</th>
        	          <th align="center" bgcolor="#99CC00">Acad Horas Cind</th>	
        	          <th align="center" bgcolor="#99CC00">Acad Horas Cfij</th>	
        	          <th align="center" bgcolor="#99CC00">Acad Horas Chon</th>	
        	          <th align="center" bgcolor="#99CC00">Acad Horas Total</th>	
        	          <th align="center" bgcolor="#99CC00">Func Horas Cind</th>	
        	          <th align="center" bgcolor="#99CC00">Func Horas Cfij</th>	
        	          <th align="center" bgcolor="#99CC00">Func Horas Chon</th>	
        	          <th align="center" bgcolor="#99CC00">Func Horas Total</th>	
        	          <th align="center" bgcolor="#99CC00">Total Horas</th>	
        	          <th align="center" bgcolor="#99CC00">Cargo</th> 
         </tr>
            
                    <%
                    Dim obj
                    For each obj in Model.Items
                    %>
        <tr>
                      <td align="left"><%=Html.Encode(obj.Anio) %></td>
                      <td align="left"><%=Html.Encode(obj.Rut) %></td>
                      <td align="left"><%=Html.Encode(obj.ApPaterno) %></td>	
                      <td align="left"><%=Html.Encode(obj.ApMaterno) %></td>
                      <td align="left"><%=Html.Encode(obj.Nombre) %></td>
                      <td align="left"><%=Html.Encode(obj.Sexo) %></td>
                      <td align="left"><%=Html.Encode(obj.FechaNacimiento) %></td>	 
                      <td align="left"><%=Html.Encode(obj.Nacionalidad) %></td>	
                      <td align="left"><%=Html.Encode(obj.AnoInst) %></td>
                      <td align="left"><%=Html.Encode(obj.PUnidad) %></td>
                      <td align="left"><%=Html.Encode(obj.PRegion) %></td>
                      <td align="left"><%=Html.Encode(obj.SUnidad) %></td>
                      <td align="left"><%=Html.Encode(obj.SRegion) %></td>
                      <td align="left"><%=Html.Encode(obj.NivelAcad) %></td>
                      <td align="left"><%=Html.Encode(obj.Titulo) %></td>
                      <td align="left"><%=Html.Encode(obj.InstTitulo) %></td>	
                      <td align="left"><%=Html.Encode(obj.PaisTitulo) %></td>	
                      <td align="left"><%=Html.Encode(obj.FechaTitulo) %></td>
                      <td align="left"><%=Html.Encode(obj.AcadHorasCind) %></td>
                      <td align="left"><%=Html.Encode(obj.AcadHorasCfij) %></td>	
                      <td align="left"><%=Html.Encode(obj.AcadHorasChon) %></td>
                      <td align="left"><%=Html.Encode(obj.AcadHorasTotal) %></td>	
                      <td align="left"><%=Html.Encode(obj.FuncHorasCind) %></td>	
                      <td align="left"><%=Html.Encode(obj.FuncHorasCfij) %></td>	
                      <td align="left"><%=Html.Encode(obj.FuncHorasChon) %></td>	
                      <td align="left"><%=Html.Encode(obj.FuncHorasTotal) %></td>	
                      <td align="left"><%=Html.Encode(obj.TotalHoras) %></td>	
                      <td align="left"><%=Html.Encode(obj.Cargo) %></td>
        </tr>
                    <% 
                    Next
                    %>
     </table>
</body>
</html>

    