<html>
<head>
<title>Example ASPCanvas image</title>
</head>
<body>
<!--
This example file uses ASPCanvas to generate shapes based on this pages form
input. The image is displayed using the input type="image" field and the clicked
coordinates are sent on to image.asp for processing.
-->
<form method="post" id=form1 name=form1>
<%
Dim sQueryString, lRadius

if Request("circle_radius") <> "" then lRadius = Request("circle_radius") else lRadius = 10

Select Case Request("object_type")
	Case "circle"
		sQueryString = "?type=circle&radius=" & lRadius
	Case "square"
		sQueryString = "?type=square"
	Case "line"
		sQueryString = "?type=line"
	Case Else
		sQueryString = "?type="
End Select

sQueryString = sQueryString & "&x=" & Request("image.x") & "&y=" & Request("image.y")
%>
<h1>ASPCanvas drawing example</h1>
<p align="center">
	<input width="320" height="240" type="image" src="image.asp<%=sQueryString%>" name="image">
</p>
<table cellspacing="3" cellpadding="3" border="1" align="center">
	<tr>
		<td colspan="4" align="center">Click on the image to draw</td>
	</tr>
	<tr>
		<td align="right">Circle:</td>
<% if Request("object_type") = "circle" then sChecked = "checked" else sChecked = "" %>
		<td><input type="radio" name="object_type" value="circle" <%=sChecked%>></td>
		<td align="right">Radius:</td>
		<td><input type="text" name="circle_radius" value="<%=lRadius%>"></td>
	</tr>
	<tr>
		<td align="right">Square:</td>
<% if Request("object_type") = "square" then sChecked = "checked" else sChecked = "" %>
		<td colspan="3"><input type="radio" name="object_type" value="square" <%=sChecked%>></td>
	</tr>
	<tr>
		<td align="right">Line:</td>
<% if Request("object_type") = "line" then sChecked = "checked" else sChecked = "" %>
		<td colspan="3"><input type="radio" name="object_type" value="line" <%=sChecked%>></td>
	</tr>
</table>
</form>
</body>
</html>