<%@page import="org.apache.jasper.tagplugins.jstl.core.ForEach"%>
<%@page import="org.apache.jasper.tagplugins.jstl.core.If"%>
<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
	pageEncoding="UTF-8"%>
<%@ page
	import="java.util.List,
	modelo.Coche,
	modelo.controladores.CocheControlador,
	modelo.Fabricante"%>

<jsp:include page="Header.jsp" flush="true">
	<jsp:param name="tituloDePagina" value="Listado de Coches" />
</jsp:include>

<%!public int getOffset(String param) {
		int offset = Integer.parseInt(param);
		if (offset > 1) {
			return 5 * offset;
		} else {
			return 0;
		}

	}%>

<%!private int offset;%>


<%
	offset = getOffset(request.getParameter("idPag"));
%>

<div class="container">
	<h1>Listado de Coches</h1>


	<table class="table table-hover">
		<thead class="thead-dark">
			<tr>
				<th>Bastidor</th>
				<th>Fabricante</th>
				<th>Modelo</th>
				<th>Color</th>
			</tr>
		</thead>
		<tbody>

			<%
				// Hasta la fila anterior ha llegado la primera fila de títulos de la tabla de profesores del centro educativo
			// En las siguietnes líneas se crea una fila "elemento <tr>" por cada fila de la tabla de BBDD "profesor"
			List<Coche> coc = CocheControlador.getControlador().findAllLimited(5, offset);
			for (Coche c : coc) {
			%>
			<tr>

				<td><a href="fichaCoche.jsp?idCoche=<%=c.getId()%>"> <%=c.getBastidor()%>
				</a></td>
				<td><%=c.getFabricante().toString()%></td>
				<td><%=c.getModelo()%></td>
				<td><%=c.getColor()%></td>
			</tr>
			<%
				}
			// Al finalizar de exponer la lista de Concesionarios termino la tabla y cierro el fichero HTML
			%>
		</tbody>
	</table>
	<p />
	<input type="submit" class="btn btn-primary justify-content-center"
		name="nuevo" value="Nuevo"
		onclick="window.location='fichaCoche.jsp?idCoche=0'" />

	<div class="row justify-content-center">
		<div clas="col">

			<jsp:include page="Pagination.jsp" flush="true">
				<jsp:param name="entity" value="Coche" />
				<jsp:param name="idPag" value='<%=request.getParameter("idPag")%>' />
			</jsp:include>

		</div>
	</div>

</div>
</body>
</html>