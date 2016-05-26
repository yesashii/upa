      <%
	    Response.AddHeader "Content-Disposition", "attachment;filename=PSU_Desviacion_estandar_nuevos.xls"
        Response.ContentType = "application/vnd.ms-excel"
	  %>
      <script type="text/javascript">
          //two variables Controller and Action have to be initialized in the View HTML code
          var Controller ='NemDesviacion';
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
      <title>Indicador de Desviación Estandar NEM alumnos nuevos</title>
      <meta http-equiv="Content-Type" content="text/html;">
      </head>
      <body >
      <table width="100%">
       	<tr>
        	          <th align="center" bgcolor="#99CC00">Sede</th>
                      <%if chequeo_2005 <> "" then%>
                      <th bgcolor="#99CC00">2005</th>
                      <%end if%>
                      <%if chequeo_2006 <> "" then%>
                      <th bgcolor="#99CC00">2006</th>
                      <%end if%>
                      <%if chequeo_2007 <> "" then%>
                      <th bgcolor="#99CC00">2007</th>
                      <%end if%>
                      <%if chequeo_2008 <> "" then%>
                      <th bgcolor="#99CC00">2008</th>
                      <%end if%>
                      <%if chequeo_2009 <> "" then%>
                      <th bgcolor="#99CC00">2009</th>
                      <%end if%>
                      <%if chequeo_2010 <> "" then%>
                      <th bgcolor="#99CC00">2010</th>
                      <%end if%>
                      <%if chequeo_2011 <> "" then%>
                      <th bgcolor="#99CC00">2011</th>
                      <%end if%>
                      <%if chequeo_2012 <> "" then%>
                      <th bgcolor="#99CC00">2012</th>
                      <%end if%>
                      <%if chequeo_2013 <> "" then%>
                      <th bgcolor="#99CC00">2013</th>
                      <%end if%>
         </tr>
            
                    <%
                    Dim obj
                    For each obj in Model.Items
                    %>
        <tr>
                      <td align="left"><%=Html.Encode(obj.cabecera) %></td>
                      <%if chequeo_2005 <> "" then%>
                      <td><%=Html.Encode(obj.a2005) %></td>
                      <%end if%>
                      <%if chequeo_2006 <> "" then%>
                      <td><%=Html.Encode(obj.a2006) %></td>
                      <%end if%>
                      <%if chequeo_2007 <> "" then%>
                      <td><%=Html.Encode(obj.a2007) %></td>
                      <%end if%>
                      <%if chequeo_2008 <> "" then%>
                      <td><%=Html.Encode(obj.a2008) %></td>
                      <%end if%>
                      <%if chequeo_2009 <> "" then%>
                      <td><%=Html.Encode(obj.a2009) %></td>
                      <%end if%>
                      <%if chequeo_2010 <> "" then%>
                      <td><%=Html.Encode(obj.a2010) %></td>
                      <%end if%>
                      <%if chequeo_2011 <> "" then%>
                      <td><%=Html.Encode(obj.a2011) %></td>
                      <%end if%>
                      <%if chequeo_2012 <> "" then%>
                      <td><%=Html.Encode(obj.a2012) %></td>
                      <%end if%>
                      <%if chequeo_2013 <> "" then%>
                      <td><%=Html.Encode(obj.a2013) %></td>
                      <%end if%>
        </tr>
                      <% 
                    Next
					Dim obj_tot_sede
                    For each obj_tot_sede in ModelTotalSede.Items
                    %>
        <tr>
                      <td align="right"><strong><%=Html.Encode(obj_tot_sede.cabecera) %></strong></td>
                      <%if chequeo_2005 <> "" then%>
                      <td><%=Html.Encode(obj_tot_sede.a2005) %></td>
                      <%end if%>
                      <%if chequeo_2006 <> "" then%>
                      <td><%=Html.Encode(obj_tot_sede.a2006) %></td>
                      <%end if%>
                      <%if chequeo_2007 <> "" then%>
                      <td><%=Html.Encode(obj_tot_sede.a2007) %></td>
                      <%end if%>
                      <%if chequeo_2008 <> "" then%>
                      <td><%=Html.Encode(obj_tot_sede.a2008) %></td>
                      <%end if%>
                      <%if chequeo_2009 <> "" then%>
                      <td><%=Html.Encode(obj_tot_sede.a2009) %></td>
                      <%end if%>
                      <%if chequeo_2010 <> "" then%>
                      <td><%=Html.Encode(obj_tot_sede.a2010) %></td>
                      <%end if%>
                      <%if chequeo_2011 <> "" then%>
                      <td><%=Html.Encode(obj_tot_sede.a2011) %></td>
                      <%end if%>
                      <%if chequeo_2012 <> "" then%>
                      <td><%=Html.Encode(obj_tot_sede.a2012) %></td>
                      <%end if%>
                      <%if chequeo_2013 <> "" then%>
                      <td><%=Html.Encode(obj_tot_sede.a2013) %></td>
                      <%end if%>
        </tr>
                      <% 
                    Next
                    %>
       <!--
	   <tr>
                      <th align="center" bgcolor="#CC9900">Facultad</th>
                      <%if chequeo_2005 <> "" then%>
                      <th bgcolor="#CC9900">2005</th>
                      <%end if%>
                      <%if chequeo_2006 <> "" then%>
                      <th bgcolor="#CC9900">2006</th>
                      <%end if%>
                      <%if chequeo_2007 <> "" then%>
                      <th bgcolor="#CC9900">2007</th>
                      <%end if%>
                      <%if chequeo_2008 <> "" then%>
                      <th bgcolor="#CC9900">2008</th>
                      <%end if%>
                      <%if chequeo_2009 <> "" then%>
                      <th bgcolor="#CC9900">2009</th>
                      <%end if%>
                      <%if chequeo_2010 <> "" then%>
                      <th bgcolor="#CC9900">2010</th>
                      <%end if%>
                      <%if chequeo_2011 <> "" then%>
                      <th bgcolor="#CC9900">2011</th>
                      <%end if%>
                      <%if chequeo_2012 <> "" then%>
                      <th bgcolor="#CC9900">2012</th>
                      <%end if%>
                      <%if chequeo_2013 <> "" then%>
                      <th bgcolor="#CC9900">2013</th>
                      <%end if%>
        </tr>
            
                    <%
                    Dim obj2
                    For each obj2 in ModelFacultad.Items
                    %>
        <tr>
                      <td align="left"><%=Html.Encode(obj2.cabecera) %></td>
                      <%if chequeo_2005 <> "" then%>
                      <td><%=Html.Encode(obj2.a2005) %></td>
                      <%end if%>
                      <%if chequeo_2006 <> "" then%>
                      <td><%=Html.Encode(obj2.a2006) %></td>
                      <%end if%>
                      <%if chequeo_2007 <> "" then%>
                      <td><%=Html.Encode(obj2.a2007) %></td>
                      <%end if%>
                      <%if chequeo_2008 <> "" then%>
                      <td><%=Html.Encode(obj2.a2008) %></td>
                      <%end if%>
                      <%if chequeo_2009 <> "" then%>
                      <td><%=Html.Encode(obj2.a2009) %></td>
                      <%end if%>
                      <%if chequeo_2010 <> "" then%>
                      <td><%=Html.Encode(obj2.a2010) %></td>
                      <%end if%>
                      <%if chequeo_2011 <> "" then%>
                      <td><%=Html.Encode(obj2.a2011) %></td>
                      <%end if%>
                      <%if chequeo_2012 <> "" then%>
                      <td><%=Html.Encode(obj2.a2012) %></td>
                      <%end if%>
                      <%if chequeo_2013 <> "" then%>
                      <td><%=Html.Encode(obj2.a2013) %></td>
                      <%end if%>
         </tr>
                      <% 
                    Next
					Dim obj_tot_facu
                    For each obj_tot_facu in ModelTotalFacultad.Items
                    %>
        <tr>
                      <td align="right"><strong><%=Html.Encode(obj_tot_facu.cabecera) %></strong></td>
                      <%if chequeo_2005 <> "" then%>
                      <td><%=Html.Encode(obj_tot_facu.a2005) %></td>
                      <%end if%>
                      <%if chequeo_2006 <> "" then%>
                      <td><%=Html.Encode(obj_tot_facu.a2006) %></td>
                      <%end if%>
                      <%if chequeo_2007 <> "" then%>
                      <td><%=Html.Encode(obj_tot_facu.a2007) %></td>
                      <%end if%>
                      <%if chequeo_2008 <> "" then%>
                      <td><%=Html.Encode(obj_tot_facu.a2008) %></td>
                      <%end if%>
                      <%if chequeo_2009 <> "" then%>
                      <td><%=Html.Encode(obj_tot_facu.a2009) %></td>
                      <%end if%>
                      <%if chequeo_2010 <> "" then%>
                      <td><%=Html.Encode(obj_tot_facu.a2010) %></td>
                      <%end if%>
                      <%if chequeo_2011 <> "" then%>
                      <td><%=Html.Encode(obj_tot_facu.a2011) %></td>
                      <%end if%>
                      <%if chequeo_2012 <> "" then%>
                      <td><%=Html.Encode(obj_tot_facu.a2012) %></td>
                      <%end if%>
                      <%if chequeo_2013 <> "" then%>
                      <td><%=Html.Encode(obj_tot_facu.a2013) %></td>
                      <%end if%>
         </tr>
                      <% 
                    Next
                      %>
         -->
		 <tr>  
                      <th align="center" bgcolor="#3399CC">Jornada</th>
                      <%if chequeo_2005 <> "" then%>
                      <th bgcolor="#3399CC">2005</th>
                      <%end if%>
                      <%if chequeo_2006 <> "" then%>
                      <th bgcolor="#3399CC">2006</th>
                      <%end if%>
                      <%if chequeo_2007 <> "" then%>
                      <th bgcolor="#3399CC">2007</th>
                      <%end if%>
                      <%if chequeo_2008 <> "" then%>
                      <th bgcolor="#3399CC">2008</th>
                      <%end if%>
                      <%if chequeo_2009 <> "" then%>
                      <th bgcolor="#3399CC">2009</th>
                      <%end if%>
                      <%if chequeo_2010 <> "" then%>
                      <th bgcolor="#3399CC">2010</th>
                      <%end if%>
                      <%if chequeo_2011 <> "" then%>
                      <th bgcolor="#3399CC">2011</th>
                      <%end if%>
                      <%if chequeo_2012 <> "" then%>
                      <th bgcolor="#3399CC">2012</th>
                      <%end if%>
                      <%if chequeo_2013 <> "" then%>
                      <th bgcolor="#3399CC">2013</th>
                      <%end if%>
          </tr>
            
                    <%
                    Dim obj3
                    For each obj3 in ModelJornada.Items
                    %>
         <tr>
                      <td align="left"><%=Html.Encode(obj3.cabecera) %></td>
                      <%if chequeo_2005 <> "" then%>
                      <td><%=Html.Encode(obj3.a2005) %></td>
                      <%end if%>
                      <%if chequeo_2006 <> "" then%>
                      <td><%=Html.Encode(obj3.a2006) %></td>
                      <%end if%>
                      <%if chequeo_2007 <> "" then%>
                      <td><%=Html.Encode(obj3.a2007) %></td>
                      <%end if%>
                      <%if chequeo_2008 <> "" then%>
                      <td><%=Html.Encode(obj3.a2008) %></td>
                      <%end if%>
                      <%if chequeo_2009 <> "" then%>
                      <td><%=Html.Encode(obj3.a2009) %></td>
                      <%end if%>
                      <%if chequeo_2010 <> "" then%>
                      <td><%=Html.Encode(obj3.a2010) %></td>
                      <%end if%>
                      <%if chequeo_2011 <> "" then%>
                      <td><%=Html.Encode(obj3.a2011) %></td>
                      <%end if%>
                      <%if chequeo_2012 <> "" then%>
                      <td><%=Html.Encode(obj3.a2012) %></td>
                      <%end if%>
                      <%if chequeo_2013 <> "" then%>
                      <td><%=Html.Encode(obj3.a2013) %></td>
                      <%end if%>
         </tr>
                      <% 
                    Next
					Dim obj_tot_jorn
                    For each obj_tot_jorn in ModelTotalJornada.Items
                    %>
         <tr>
                      <td align="right"><strong><%=Html.Encode(obj_tot_jorn.cabecera) %></strong></td>
                      <%if chequeo_2005 <> "" then%>
                      <td><%=Html.Encode(obj_tot_jorn.a2005) %></td>
                      <%end if%>
                      <%if chequeo_2006 <> "" then%>
                      <td><%=Html.Encode(obj_tot_jorn.a2006) %></td>
                      <%end if%>
                      <%if chequeo_2007 <> "" then%>
                      <td><%=Html.Encode(obj_tot_jorn.a2007) %></td>
                      <%end if%>
                      <%if chequeo_2008 <> "" then%>
                      <td><%=Html.Encode(obj_tot_jorn.a2008) %></td>
                      <%end if%>
                      <%if chequeo_2009 <> "" then%>
                      <td><%=Html.Encode(obj_tot_jorn.a2009) %></td>
                      <%end if%>
                      <%if chequeo_2010 <> "" then%>
                      <td><%=Html.Encode(obj_tot_jorn.a2010) %></td>
                      <%end if%>
                      <%if chequeo_2011 <> "" then%>
                      <td><%=Html.Encode(obj_tot_jorn.a2011) %></td>
                      <%end if%>
                      <%if chequeo_2012 <> "" then%>
                      <td><%=Html.Encode(obj_tot_jorn.a2012) %></td>
                      <%end if%>
                      <%if chequeo_2013 <> "" then%>
                      <td><%=Html.Encode(obj_tot_jorn.a2013) %></td>
                      <%end if%>
         </tr>
                      <% 
                    Next
                     %>
         <tr>
                      <th align="center" bgcolor="#CC6600">Carrera</th>
                      <%if chequeo_2005 <> "" then%>
                      <th bgcolor="#CC6600">2005</th>
                      <%end if%>
                      <%if chequeo_2006 <> "" then%>
                      <th bgcolor="#CC6600">2006</th>
                      <%end if%>
                      <%if chequeo_2007 <> "" then%>
                      <th bgcolor="#CC6600">2007</th>
                      <%end if%>
                      <%if chequeo_2008 <> "" then%>
                      <th bgcolor="#CC6600">2008</th>
                      <%end if%>
                      <%if chequeo_2009 <> "" then%>
                      <th bgcolor="#CC6600">2009</th>
                      <%end if%>
                      <%if chequeo_2010 <> "" then%>
                      <th bgcolor="#CC6600">2010</th>
                      <%end if%>
                      <%if chequeo_2011 <> "" then%>
                      <th bgcolor="#CC6600">2011</th>
                      <%end if%>
                      <%if chequeo_2012 <> "" then%>
                      <th bgcolor="#CC6600">2012</th>
                      <%end if%>
                      <%if chequeo_2013 <> "" then%>
                      <th bgcolor="#CC6600">2013</th>
                      <%end if%>
           </tr>
            
                    <%
                    Dim obj4
                    For each obj4 in ModelCarrera.Items
                    %>
           <tr>
                      <td align="left"><%=Html.Encode(obj4.cabecera) %></td>
                      <%if chequeo_2005 <> "" then%>
                      <td><%=Html.Encode(obj4.a2005) %></td>
                      <%end if%>
                      <%if chequeo_2006 <> "" then%>
                      <td><%=Html.Encode(obj4.a2006) %></td>
                      <%end if%>
                      <%if chequeo_2007 <> "" then%>
                      <td><%=Html.Encode(obj4.a2007) %></td>
                      <%end if%>
                      <%if chequeo_2008 <> "" then%>
                      <td><%=Html.Encode(obj4.a2008) %></td>
                      <%end if%>
                      <%if chequeo_2009 <> "" then%>
                      <td><%=Html.Encode(obj4.a2009) %></td>
                      <%end if%>
                      <%if chequeo_2010 <> "" then%>
                      <td><%=Html.Encode(obj4.a2010) %></td>
                      <%end if%>
                      <%if chequeo_2011 <> "" then%>
                      <td><%=Html.Encode(obj4.a2011) %></td>
                      <%end if%>
                      <%if chequeo_2012 <> "" then%>
                      <td><%=Html.Encode(obj4.a2012) %></td>
                      <%end if%>
                      <%if chequeo_2013 <> "" then%>
                      <td><%=Html.Encode(obj4.a2013) %></td>
                      <%end if%>
           </tr>
                    <% 
                    Next
					Dim obj_tot_carr
                    For each obj_tot_carr in ModelTotalCarrera.Items
                    %>
           <tr>
                      <td align="right"><strong><%=Html.Encode(obj_tot_carr.cabecera) %></strong></td>
                      <%if chequeo_2005 <> "" then%>
                      <td><%=Html.Encode(obj_tot_carr.a2005) %></td>
                      <%end if%>
                      <%if chequeo_2006 <> "" then%>
                      <td><%=Html.Encode(obj_tot_carr.a2006) %></td>
                      <%end if%>
                      <%if chequeo_2007 <> "" then%>
                      <td><%=Html.Encode(obj_tot_carr.a2007) %></td>
                      <%end if%>
                      <%if chequeo_2008 <> "" then%>
                      <td><%=Html.Encode(obj_tot_carr.a2008) %></td>
                      <%end if%>
                      <%if chequeo_2009 <> "" then%>
                      <td><%=Html.Encode(obj_tot_carr.a2009) %></td>
                      <%end if%>
                      <%if chequeo_2010 <> "" then%>
                      <td><%=Html.Encode(obj_tot_carr.a2010) %></td>
                      <%end if%>
                      <%if chequeo_2011 <> "" then%>
                      <td><%=Html.Encode(obj_tot_carr.a2011) %></td>
                      <%end if%>
                      <%if chequeo_2012 <> "" then%>
                      <td><%=Html.Encode(obj_tot_carr.a2012) %></td>
                      <%end if%>
                      <%if chequeo_2013 <> "" then%>
                      <td><%=Html.Encode(obj_tot_carr.a2013) %></td>
                      <%end if%>
           </tr>
                    <% 
                    Next
                    %>
     </table>
</body>
</html>

    