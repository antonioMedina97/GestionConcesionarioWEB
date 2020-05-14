<%@page import="modelo.Venta"%>
<%@page import="org.apache.jasper.tagplugins.jstl.core.ForEach"%>
<%@page import="org.apache.jasper.tagplugins.jstl.core.If"%>
<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
	pageEncoding="UTF-8"%>
<%@ page
	import="java.util.List,
	modelo.Cliente,
	modelo.Venta,
	modelo.Coche,
	modelo.Concesionario,
	modelo.controladores.ClienteControlador,
	modelo.controladores.VentaControlador,
	modelo.controladores.CocheControlador,
	modelo.controladores.ConcesionarioControlador"%>

<jsp:include page="Header.jsp" flush="true">
	<jsp:param name="tituloDePagina" value="Listado de Ventas" />
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
	<h1>Listado de Ventas</h1>


	<table class="table table-hover">
		<thead class="thead-dark">
			<tr>
				<th>Cliente</th>
				<th>Concesionario</th>
				<th>Coche</th>
				<th>Fecha</th>
				<th>Precio de venta</th>
			</tr>
		</thead>
		<tbody>

			<%
				// Hasta la fila anterior ha llegado la primera fila de títulos de la tabla de profesores del centro educativo
			// En las siguietnes líneas se crea una fila "elemento <tr>" por cada fila de la tabla de BBDD "profesor"
			List<Venta> ven = VentaControlador.getControlador().findAllLimited(5, offset);
			for (Venta c : ven) {
			%>
			<tr>

				<td><a
					href="fichaVenta.jsp?idVenta=<%=c.getId()%>"> <%=c.getCliente().toString()%>
				</a></td>
				<td><%=c.getConcesionario().toString()%></td>
				<td><%=c.getCoche().toString()%></td>
				<td><%=c.getFecha()%></td>
				<td><%=c.getPrecioVenta()%></td>
				
			</tr>
			<%
				}
			// Al finalizar de exponer la lista de Concesionarios termino la tabla y cierro el fichero HTML
			%>
		</tbody>
	</table>
	<p />
	<input type="submit" class="btn btn-primary justify-content-center" name="nuevo" value="Nuevo"
		onclick="window.location='fichaCliente.jsp?idCliente=0'" />

	<div class="row justify-content-center">
		<div clas="col">

			<jsp:include page="Pagination.jsp" flush="true">
				<jsp:param name="entity" value="Venta" />
				<jsp:param name="idPag" value='<%=request.getParameter("idPag")%>' />
			</jsp:include>
		</div>
	</div>
	
</div>
</body>
</html>