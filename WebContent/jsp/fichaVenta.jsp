
<%@ page language="java" contentType="text/html; charset=ISO-8859-1" pageEncoding="ISO-8859-1"%>
<%@ page import="java.util.List, 
	java.util.HashMap,
	utils.RequestUtils,
	java.util.Date,
	java.text.SimpleDateFormat,
	modelo.Cliente,
	modelo.controladores.ClienteControlador,
	modelo.Coche,
	modelo.controladores.CocheControlador,
	modelo.Concesionario,
	modelo.controladores.ConcesionarioControlador,
	modelo.Venta,
	modelo.controladores.VentaControlador" %>

<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
  <meta name="viewport" content="width=device-width, initial-scale=1">
  <link rel="stylesheet" href="https://maxcdn.bootstrapcdn.com/bootstrap/4.3.1/css/bootstrap.min.css">
  <script src="https://ajax.googleapis.com/ajax/libs/jquery/3.4.0/jquery.min.js"></script>
  <script src="https://cdnjs.cloudflare.com/ajax/libs/popper.js/1.14.7/umd/popper.min.js"></script>
  <script src="https://maxcdn.bootstrapcdn.com/bootstrap/4.3.1/js/bootstrap.min.js"></script>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">

<title>Ficha de Venta</title>
</head>
	<%
	//Simple date format to parse
	SimpleDateFormat sdfFecha = new SimpleDateFormat("dd/MM/yyyy");
	// Obtengo una HashMap con todos los parámetros del request, sea este del tipo que sea;
	HashMap<String, Object> hashMap = RequestUtils.requestToHashMap(request);
	
	// Para plasmar la información de un profesor determinado utilizaremos un parámetro, que debe llegar a este Servlet obligatoriamente
	// El parámetro se llama "idProfesor" y gracias a él podremos obtener la información del profesor y mostrar sus datos en pantalla
	Venta venta = null;
	// Obtengo el profesor a editar, en el caso de que el profesor exista se cargarán sus datos, en el caso de que no exista quedará a null
	try {
		int idVenta = RequestUtils.getIntParameterFromHashMap(hashMap, "idVenta"); // Necesito obtener el id del profesor que se quiere editar. En caso de un alta
		// de profesor obtendríamos el valor 0 como idProfesor
		if (idVenta != 0) {
			venta = (Venta) VentaControlador.getControlador().find(idVenta);
		}
	} catch (Exception e) {
		e.printStackTrace();
	}
	// Inicializo unos valores correctos para la presentación del profesor
	if (venta == null) {
		venta = new Venta();
	}
	
	if (venta.getCliente() == null) venta.setCliente(ClienteControlador.getControlador().find(1));
	if (venta.getConcesionario() == null) venta.setConcesionario(ConcesionarioControlador.getControlador().find(1));
	if (venta.getCoche() == null) venta.setCoche(CocheControlador.getControlador().find(1));
	if (venta.getPrecioVenta() == 0f) venta.setPrecioVenta(0f);
	if (venta.getFecha() == null) venta.setFecha(null);

	
	
	// Ahora debo determinar cuál es la acción que este página debería llevar a cabo, en función de los parámetros de entrada al Servlet.
	// Las acciones que se pueden querer llevar a cabo son tres:
	//    - "eliminar". Sé que está es la acción porque recibiré un un parámetro con el nombre "eliminar" en el request
	//    - "guardar". Sé que está es la acción elegida porque recibiré un parámetro en el request con el nombre "guardar"
	//    - Sin acción. En este caso simplemente se quiere editar la ficha
	
	// Variable con mensaje de información al usuario sobre alguna acción requerida
	String mensajeAlUsuario = "";
	
	// Primera acción posible: eliminar
	if (RequestUtils.getStringParameterFromHashMap(hashMap, "eliminar") != null) {
		// Intento eliminar el registro, si el borrado es correcto redirijo la petición hacia el listado de profesores
		try {
			VentaControlador.getControlador().remove(venta);
			response.sendRedirect(request.getContextPath() + "/jsp/listadoVentas.jsp?idPag=1"); // Redirección del response hacia el listado
		}
		catch (Exception ex) {
			mensajeAlUsuario = "ERROR - Imposible eliminar. Es posible que existan restricciones.";
		}
	}
	
	// Segunda acción posible: guardar
	if (RequestUtils.getStringParameterFromHashMap(hashMap, "guardar") != null) {
		// Obtengo todos los datos del profesor y los almaceno en BBDD
		try {

			venta.setCliente(ClienteControlador.getControlador().find(RequestUtils.getIntParameterFromHashMap(hashMap, "idCliente")));
			venta.setConcesionario(ConcesionarioControlador.getControlador().find(RequestUtils.getIntParameterFromHashMap(hashMap, "idConcesionario")));
			venta.setCoche(CocheControlador.getControlador().find(RequestUtils.getIntParameterFromHashMap(hashMap, "idCoche")));
			
			venta.setPrecioVenta(Float.parseFloat(RequestUtils.getStringParameterFromHashMap(hashMap, "precio")));	
			try {
				venta.setFecha(sdfFecha.parse(RequestUtils.getStringParameterFromHashMap(hashMap, "fecha")));
			}
			catch (Exception e) {
				e.printStackTrace();
			}						

			// Finalmente guardo el objeto de tipo profesor 
			VentaControlador.getControlador().save(venta);
			mensajeAlUsuario = "Guardado correctamente";
		} catch (Exception e) {
			throw new ServletException(e);
		}
	}

	// Ahora muestro la pantalla de respuesta al usuario
	%>	
		
<body>
<div class="container py-3">
	<% 
	String tipoAlerta = "alert-success";
	if (mensajeAlUsuario != null && mensajeAlUsuario != "") {
		if (mensajeAlUsuario.startsWith("ERROR")) {
			tipoAlerta = "alert-danger";
		}
	%>
	  <div class="alert <%=tipoAlerta%> alert-dismissible fade show">
		<button type="button" class="close" data-dismiss="alert">&times;</button>
	    <%=mensajeAlUsuario%>
	  </div>
	<% } %>
    <div class="row">
        <div class="mx-auto col-sm-6">
	        <!-- form user info -->
	        <div class="card">
	            <div class="card-header">
	                <h4 class="mb-0">Ficha de Venta</h4>
	            </div>
	            <div class="card-body">
 
					<a href="listadoVentas.jsp?idPag=1">Ir al listado de Ventas</a>
					<form id="form1" name="form1" method="post" action="fichaVenta.jsp" enctype="multipart/form-data" class="form" role="form" autocomplete="off">
						
						<input type="hidden" name="idVenta" value="<%=venta.getId()%>"/>
						
						<!-- Cliente -->
				        <div class="form-group row">
							<label class="col-lg-4 col-form-label form-control-label" for="idCliente">Cliente:</label> 
							<div class="col-lg-8">
					 		<select name="idCliente" id="idCliente" class="form-control">
									<%
										// Inserto los valores del fabricnate y, si el registro tiene un valor concreto, lo establezco
									List<Cliente> cli = ClienteControlador.getControlador().findAll();
									for (Cliente c : cli) {
									%>
									<option value="<%=c.getId()%>" <%=((c.getId() == venta.getCliente().getId()) ? "selected=\"selected\"" : "")%>><%=c.getNombre()%></option>
									<% } %>
								</select>
							</div> 
						</div>
						
						<!-- Concesionario -->
				        <div class="form-group row">
							<label class="col-lg-4 col-form-label form-control-label" for="idConcesionario">Concesionario:</label> 
							<div class="col-lg-8">
					 		<select name="idConcesionario" id="idConcesionario" class="form-control">
									<%
										// Inserto los valores del fabricnate y, si el registro tiene un valor concreto, lo establezco
									List<Concesionario> concs = ConcesionarioControlador.getControlador().findAll();
									for (Concesionario c : concs) {
									%>
									<option value="<%=c.getId()%>" <%=((c.getId() == venta.getConcesionario().getId()) ? "selected=\"selected\"" : "")%>><%=c.getNombre()%></option>
									<% } %>
								</select>
							</div> 
						</div>
						
						<!-- coche -->
				        <div class="form-group row">
							<label class="col-lg-4 col-form-label form-control-label" for="idCoche">Coche:</label> 
							<div class="col-lg-8">
					 		<select name="idCoche" id="idCoche" class="form-control">
									<%
										// Inserto los valores del fabricnate y, si el registro tiene un valor concreto, lo establezco
									List<Coche> cos = CocheControlador.getControlador().findAll();
									for (Coche c : cos) {
									%>
									<option value="<%=c.getId()%>" <%=((c.getId() == venta.getCoche().getId()) ? "selected=\"selected\"" : "")%>><%=c.getBastidor()%></option>
									<% } %>
								</select>
							</div> 
						</div>
						
						<!-- Fecha -->
				        <div class="form-group row">
							<label class="col-lg-4 col-form-label form-control-label" for="fechaNac">Fecha de Venta:</label> 
							<div class="col-lg-8">
							<input name="fecha" class="form-control" type="text"	 id="fecha" value="<%= ((venta.getFecha() != null)? sdfFecha.format(venta.getFecha()) : "") %>" />
							</div> 
						</div>
			
			
						<!-- Precio -->
				        <div class="form-group row">
							<label class="col-lg-4 col-form-label form-control-label" for="nombre">Precio:</label> 
							<div class="col-lg-8">
								<input name="precio" class="form-control" type="text" id="precio"  value="<%=venta.getPrecioVenta()%>" /> 
							</div> 
						</div>
						
												
				        <div class="form-group row">
				        	<div class="col-lg-8">
								<input type="submit" name="guardar" class="btn btn-primary" value="Guardar" /> 
								<input type="submit" name="eliminar" class="btn btn-secondary" value="Eliminar" />
							</div> 
						</div>
					</form>
				</div>
			</div>
		</div>
	</div>
</div> 
</body> 
</html> 
