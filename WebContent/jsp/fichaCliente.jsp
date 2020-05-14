
<%@ page language="java" contentType="text/html; charset=ISO-8859-1" pageEncoding="ISO-8859-1"%>
<%@ page import="java.util.List, 
	java.util.HashMap,
	utils.RequestUtils,
	java.util.Date,
	java.text.SimpleDateFormat,
	modelo.Cliente,
	modelo.controladores.ClienteControlador" %>

<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
  <meta name="viewport" content="width=device-width, initial-scale=1">
  <link rel="stylesheet" href="https://maxcdn.bootstrapcdn.com/bootstrap/4.3.1/css/bootstrap.min.css">
  <script src="https://ajax.googleapis.com/ajax/libs/jquery/3.4.0/jquery.min.js"></script>
  <script src="https://cdnjs.cloudflare.com/ajax/libs/popper.js/1.14.7/umd/popper.min.js"></script>
  <script src="https://maxcdn.bootstrapcdn.com/bootstrap/4.3.1/js/bootstrap.min.js"></script>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">

<title>Ficha de Cliente</title>
</head>
	<%
	//Simple date format to parse
	SimpleDateFormat sdfFechaNac = new SimpleDateFormat("dd/MM/yyyy");
	// Obtengo una HashMap con todos los parámetros del request, sea este del tipo que sea;
	HashMap<String, Object> hashMap = RequestUtils.requestToHashMap(request);
	
	// Para plasmar la información de un profesor determinado utilizaremos un parámetro, que debe llegar a este Servlet obligatoriamente
	// El parámetro se llama "idProfesor" y gracias a él podremos obtener la información del profesor y mostrar sus datos en pantalla
	Cliente cliente = null;
	// Obtengo el profesor a editar, en el caso de que el profesor exista se cargarán sus datos, en el caso de que no exista quedará a null
	try {
		int idCliente = RequestUtils.getIntParameterFromHashMap(hashMap, "idCliente"); // Necesito obtener el id del profesor que se quiere editar. En caso de un alta
		// de profesor obtendríamos el valor 0 como idProfesor
		if (idCliente != 0) {
			cliente = (Cliente) ClienteControlador.getControlador().find(idCliente);
		}
	} catch (Exception e) {
		e.printStackTrace();
	}
	// Inicializo unos valores correctos para la presentación del profesor
	if (cliente == null) {
		cliente = new Cliente();
	}
	
	if (cliente.getNombre() == null) cliente.setNombre("");
	if (cliente.getApellidos() == null) cliente.setApellidos("");
	if (cliente.getLocalidad() == null) cliente.setLocalidad("");
	if (cliente.getDniNie() == null) cliente.setDniNie("");
	if (cliente.getFechaNac() == null) cliente.setFechaNac(null);
	if (cliente.getActivo() == false) cliente.setActivo(false);

	
	
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
			ClienteControlador.getControlador().remove(cliente);
			response.sendRedirect(request.getContextPath() + "/jsp/listadoClientes.jsp?idPag=1"); // Redirección del response hacia el listado
		}
		catch (Exception ex) {
			mensajeAlUsuario = "ERROR - Imposible eliminar. Es posible que existan restricciones.";
		}
	}
	
	// Segunda acción posible: guardar
	if (RequestUtils.getStringParameterFromHashMap(hashMap, "guardar") != null) {
		// Obtengo todos los datos del profesor y los almaceno en BBDD
		try {

			cliente.setNombre(RequestUtils.getStringParameterFromHashMap(hashMap, "nombre"));
			cliente.setApellidos(RequestUtils.getStringParameterFromHashMap(hashMap, "apellidos"));
			cliente.setLocalidad(RequestUtils.getStringParameterFromHashMap(hashMap, "localidad"));
			cliente.setDniNie(RequestUtils.getStringParameterFromHashMap(hashMap, "dni"));
	
			try {
				cliente.setFechaNac(sdfFechaNac.parse(RequestUtils.getStringParameterFromHashMap(hashMap, "fechaNac")));
			}
			catch (Exception e) {
				e.printStackTrace();
			}			
			cliente.setActivo(Boolean.parseBoolean(RequestUtils.getStringParameterFromHashMap(hashMap, "activo")));
			

			// Finalmente guardo el objeto de tipo profesor 
			ClienteControlador.getControlador().save(cliente);
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
	                <h4 class="mb-0">Ficha de Cliente</h4>
	            </div>
	            <div class="card-body">
 
					<a href="listadoClientes.jsp?idPag=1">Ir al listado de Clientes</a>
					<form id="form1" name="form1" method="post" action="fichaCliente.jsp" enctype="multipart/form-data" class="form" role="form" autocomplete="off">
						
						<input type="hidden" name="idCliente" value="<%=cliente.getId()%>"/>
						
						<!-- Nombre -->
				        <div class="form-group row">
							<label class="col-lg-3 col-form-label form-control-label" for="nombre">Nombre:</label> 
							<div class="col-lg-9">
								<input name="nombre" class="form-control" type="text" id="nombre"  value="<%=cliente.getNombre()%>" /> 
							</div> 
						</div>

						
						<!-- Apellidos -->
				        <div class="form-group row">
							<label class="col-lg-3 col-form-label form-control-label" for="apellidos">Apellidos:</label> 
							<div class="col-lg-9">
								<input name="apellidos" class="form-control" type="text" id="apellidos"  value="<%=cliente.getApellidos()%>" /> 
							</div> 
						</div>
						
						<!-- Localidad -->
				        <div class="form-group row">
							<label class="col-lg-3 col-form-label form-control-label" for="localidad">Localidad:</label> 
							<div class="col-lg-9">
								<input name="localidad" class="form-control" type="text" id="localidad"  value="<%=cliente.getLocalidad()%>" /> 
							</div> 
						</div>
						
						<!-- Dni -->
				        <div class="form-group row">
							<label class="col-lg-3 col-form-label form-control-label" for="dni">Dni:</label> 
							<div class="col-lg-9">
								<input name="dni" class="form-control" type="text" id="dni"  value="<%=cliente.getDniNie()%>" /> 
							</div> 
						</div>

						<!-- Fecha -->
				        <div class="form-group row">
							<label class="col-lg-3 col-form-label form-control-label" for="fechaNac">Fecha de Nacimiento:</label> 
							<div class="col-lg-9">
							<input name="fechaNac" class="form-control" type="text"	 id="fechaNac" value="<%= ((cliente.getFechaNac() != null)? sdfFechaNac.format(cliente.getFechaNac()) : "") %>" />
							</div> 
						</div>
						
						<!-- Fecha -->
				        <div class="form-group row">
							<label class="col-lg-3 col-form-label form-control-label" for="fechaNac">Activo:</label> 
							<div class="col-lg-2">
								<input class="form-check-input form-control" type="checkbox" <%= (cliente.getActivo()) ? "checked" : ""%> name="activo" id="activo">
							</div> 
						</div>
						
												
				        <div class="form-group row">
				        	<div class="col-lg-9">
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
