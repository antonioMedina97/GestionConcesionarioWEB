<%@page import="org.apache.jasper.tagplugins.jstl.core.ForEach"%>
<%@page import="org.apache.jasper.tagplugins.jstl.core.If"%>
<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
	pageEncoding="UTF-8"%>
<%@ page
	import="java.util.List,
	modelo.Fabricante,
	modelo.controladores.FabricanteControlador"%>

<jsp:include page="Header.jsp" flush="true">
	<jsp:param name="tituloDePagina" value="Listado de Fabricantes" />
</jsp:include>

<%!public int getOffset(String param) {
		int offset = Integer.parseInt(param);
		if (offset > 1) {
			return 5 * offset;
		} else {
			return 0;
		}

	}%>

<%!private int offset, paginationIndex; %>
<%
	paginationIndex = Integer.parseInt(request.getParameter("idPag")); 
%>

<% offset = getOffset(request.getParameter("idPag"));%>

<div class="container">
	<h1>Listado de Fabricantes</h1>


	<table class="table table-hover">
		<thead class="thead-dark">
			<tr>
			
				<th>Cif</th>
				<th>Nombre</th>
				
			</tr>
		</thead>
		<tbody>

			<%
				// Hasta la fila anterior ha llegado la primera fila de títulos de la tabla de profesores del centro educativo
			// En las siguietnes líneas se crea una fila "elemento <tr>" por cada fila de la tabla de BBDD "profesor"
			List<Fabricante> fab = FabricanteControlador.getControlador().findAllLimited(5, offset);
			for (Fabricante c : fab) {
			%>
			<tr>

				<td><a
					href="fichaFabricante.jsp?idFabricante=<%=c.getId()%>"> <%=c.getNombre()%>
				</a></td>
				<td><%=c.getCif()%></td>
	
			</tr>
			<%
				}
			// Al finalizar de exponer la lista de Concesionarios termino la tabla y cierro el fichero HTML
			%>
		</tbody>
	</table>
	<p />
	<input type="submit" class="btn btn-primary justify-content-center" name="nuevo" value="Nuevo"
		onclick="window.location='fichaFabricante.jsp?idCliente=0'" />

	<div class="row justify-content-center">
		<div clas="col">

			<jsp:include page="Pagination.jsp" flush="true">
				<jsp:param name="entity" value="Fabricante" />
				<jsp:param name="idPag" value='<%=request.getParameter("idPag")%>' />
			</jsp:include>	
		</div>
	</div>
	
</div>
</body>
</html>