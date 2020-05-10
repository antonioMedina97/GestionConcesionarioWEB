<%@page import="org.apache.jasper.tagplugins.jstl.core.ForEach"%>
<%@page import="org.apache.jasper.tagplugins.jstl.core.If"%>
<%@ page language="java" contentType="text/html; charset=ISO-8859-1" pageEncoding="UTF-8"%>
<%@ page import="java.util.List,
	modelo.Concesionario,
	modelo.controladores.ConcesionarioControlador" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=ISO-8859-1">
<link rel="stylesheet" href="https://maxcdn.bootstrapcdn.com/bootstrap/4.0.0-beta.3/css/bootstrap.min.css" integrity="sha384-Zug+QiDoJOrZ5t4lssLdxGhVrurbmBWopoEl+M6BdEfwnCJZtKxi1KgxUyJq13dy" crossorigin="anonymous">
<title>Listado de Concesionarios</title>
</head>
<body>
<div class="container">
	<h1>Listado de Concesionarios</h1> 
	<table class="table table-hover">
		<thead class="thead-dark">
			<tr> 
				<th>Cif</th>
				<th>Nombre</th> 
 				<th>Localidad</th>
			</tr>
		</thead>
		<tbody>
		<%!
			public int getOffset(String param){
				int offset = Integer.parseInt(param);
				if(offset > 1){
					return 5 * offset;
				}
				else{
					return 0;
				}
				
			}
		%>
		<%! private int offset; %>
		<%= offset = getOffset(request.getParameter("idPag"))  %>
		<%
		// Hasta la fila anterior ha llegado la primera fila de títulos de la tabla de profesores del centro educativo
		// En las siguietnes líneas se crea una fila "elemento <tr>" por cada fila de la tabla de BBDD "profesor"
		List<Concesionario> conces = ConcesionarioControlador.getControlador().findAllLimited(5, offset );
		for (Concesionario c : conces) { %>
			<tr> 

				<td><a href="fichaConcesionario.jsp?idConcesionario=<%=c.getId()%>"> <%=c.getNombre()%> </a></td> 
				<td><%=c.getCif()%></td>
				<td><%=c.getLocalidad()%></td>

			</tr>
		<% } 
		// Al finalizar de exponer la lista de Concesionarios termino la tabla y cierro el fichero HTML 
		%>
		</tbody>
	</table> 
	<p/><input type="submit" class="btn btn-primary"  name="nuevo" value="Nuevo"  onclick="window.location='fichaConcesionario.jsp?idConcesionario=0'"/> 
	
	<ul class="pagination">
	  <li class="page-item disabled"><a class="page-link" href="#">Previous</a></li>
	  <%
	  List<Concesionario> c = ConcesionarioControlador.getControlador().findAll();
	  double size = Math.ceil(c.size() / 5);
	  for(int i = 1; i <= size; i++){
	  %> 
		  <li class="page-item"><a class="page-link" href="?idPag=<%= i %>" ><%= i %></a></li>
	  <%
	  }
	  %>
<!--  <li class="page-item"><a class="page-link" href="?idPag=1">1</a></li>
	  <li class="page-item"><a class="page-link" href="?idPag=2">2</a></li>
	  <li class="page-item"><a class="page-link" href="?idPag=3">3</a></li>
	  <li class="page-item"><a class="page-link" href="#">Next</a></li>
-->	</ul> 
</div>
</body> 
</html>