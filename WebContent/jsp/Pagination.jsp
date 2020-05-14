			<%@page import="modelo.Controlador"%>
	
				<%
				String entidad = request.getParameter("entity");
				int paginationIndex = Integer.parseInt(request.getParameter("idPag"));
				
				int count = 0;
				try {
					Class claseDelControlador = Class.forName("modelo.controladores." + entidad + "Controlador");
					Controlador controlador = (Controlador) claseDelControlador.getMethod("getControlador", null).invoke(null, null);
					count = controlador.getCount();
				}
				catch (Exception e) {
					e.printStackTrace();
				}
				
				
				int size = Math.round(count / 5);
				%>

			
			<ul class="pagination">
				<li class="page-item "><a class="page-link" href="?idPag=1">Primero</a></li>
				<li class="page-item "><a class="page-link"
					href="?idPag=<%=paginationIndex - 1%>">Anterior</a></li>



				<%
				if (paginationIndex > 2) {
				%>
				<li class="page-item"><a class="page-link"
					href="?idPag=<%=paginationIndex - 2%>"><%=paginationIndex - 2%></a></li>
				<%
					}
				%>

				<%
					if (paginationIndex > 1) {
				%>
				<li class="page-item"><a class="page-link"
					href="?idPag=<%=paginationIndex - 1%>"><%=paginationIndex - 1%></a></li>
				<%
					}
				%>

				<!-- Actual -->
				<li class="page-item active"><a class="page-link"
					href="?idPag=<%=paginationIndex%>"><%=paginationIndex%></a></li>



				<%
					if (paginationIndex < size) {
				%>
				<li class="page-item"><a class="page-link"
					href="?idPag=<%=paginationIndex + 1%>"><%=paginationIndex + 1%></a></li>
				<%
					}
				%>
				<%
					if (paginationIndex < size - 1) {
				%>
				<li class="page-item"><a class="page-link"
					href="?idPag=<%=paginationIndex + 2%>"><%=paginationIndex + 2%></a></li>
				<%
					}
				%>

				<li class="page-item"><a class="page-link"
					href="?idPag=<%=paginationIndex + 1%>">Siguiente</a></li>
						
				<li class="page-item"><a class="page-link"
					href="?idPag=<%=size%>">Fin</a></li>
			</ul>