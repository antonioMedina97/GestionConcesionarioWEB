<%@page import="org.apache.jasper.tagplugins.jstl.core.ForEach"%>
<%@page import="org.apache.jasper.tagplugins.jstl.core.If"%>
<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
	pageEncoding="UTF-8"%>
<%@ page
	import="java.util.List,
	modelo.Concesionario,
	modelo.controladores.ConcesionarioControlador"%>

<jsp:include page="Header.jsp" flush="true">
	<jsp:param name="tituloDePagina" value="Listado de Concesionarios" />
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


<% offset = getOffset(request.getParameter("idPag"));%>

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

			<%
				// Hasta la fila anterior ha llegado la primera fila de títulos de la tabla de profesores del centro educativo
			// En las siguietnes líneas se crea una fila "elemento <tr>" por cada fila de la tabla de BBDD "profesor"
			List<Concesionario> conces = ConcesionarioControlador.getControlador().findAllLimited(5, offset);
			for (Concesionario c : conces) {
			%>
			<tr>

				<td><a
					href="fichaConcesionario.jsp?idConcesionario=<%=c.getId()%>"><%=c.getCif()%>  
				</a></td>
				<td><%=c.getNombre()%></td>
				<td><%=c.getLocalidad()%></td>

			</tr>
			<%
				}
			// Al finalizar de exponer la lista de Concesionarios termino la tabla y cierro el fichero HTML
			%>
		</tbody>
	</table>
	<p />
	<input type="submit" class="btn btn-primary justify-content-center" name="nuevo" value="Nuevo"
		onclick="window.location='fichaConcesionario.jsp?idConcesionario=0'" />

	<div class="row justify-content-center">
		<div clas="col">
			<jsp:include page="Pagination.jsp" flush="true">
				<jsp:param name="entity" value="Concesionario" />
				<jsp:param name="idPag" value='<%=request.getParameter("idPag")%>' />
			</jsp:include>	
		</div>
	</div>
	
</div>
</body>
</html>