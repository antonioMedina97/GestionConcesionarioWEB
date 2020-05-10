package Servlets_Package;

import java.io.IOException;
import java.util.List;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import modelo.Concesionario;
import modelo.controladores.ConcesionarioControlador;
import utils.FormularioIncorrectoRecibidoException;

/**
 * Servlet implementation class datosConcesionarioServlet
 */
@WebServlet("/datosConcesionarioServlet")
public class datosConcesionarioServlet extends HttpServlet {
	private static final long serialVersionUID = 1L;
       
    /**
     * @see HttpServlet#HttpServlet()
     */
    public datosConcesionarioServlet() {
        super();
        // TODO Auto-generated constructor stub
    }

	/**
	 * @see HttpServlet#doGet(HttpServletRequest request, HttpServletResponse response)
	 */
	protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		// Para plasmar la información de un profesor determinado utilizaremos un parámetro, que debe llegar a este Servlet obligatoriamente
		// El parámetro se llama "idProfesor" y gracias a él podremos obtener la información del profesor y mostrar sus datos en pantalla
		Concesionario con = new Concesionario();
		// Obtengo el profesor a editar, en el caso de que el profesor exista se cargarán sus datos, en el caso de que no exista quedará a null
		try {
			int idConcesionario = getIntParameter(request, "idConcesionario"); // Necesito obtener el id del profesor que se quiere editar. En caso de un alta
			// de profesor obtendríamos el valor 0 como idProfesor
			con = (Concesionario) ConcesionarioControlador.getControlador().find(idConcesionario);
		} catch (Exception e) { }
		
		// Ahora debo determinar cuál es la acción que este página debería llevar a cabo, en función de los parámetros de entrada al Servlet.
		// Las acciones que se pueden querer llevar a cabo son tres:
		//    - "eliminar". Sé que está es la acción porque recibiré un un parámetro con el nombre "eliminar" en el request
		//    - "guardar". Sé que está es la acción elegida porque recibiré un parámetro en el request con el nombre "guardar"
		//    - Sin acción. En este caso simplemente se quiere editar la ficha
		
		// Variable con mensaje de información al usuario sobre alguna acción requerida
		String mensajeAlUsuario = "";
		
		// Primera acción posible: eliminar
		if (request.getParameter("eliminar") != null) {
			// Intento eliminar el registro, si el borrado es correcto redirijo la petición hacia el listado de profesores
			try {
				ConcesionarioControlador.getControlador().remove(con);
				response.sendRedirect(request.getContextPath() + "/concesionarioServlet"); // Redirección del response hacia el listado
			}
			catch (Exception ex) {
				mensajeAlUsuario = "Imposible eliminar. Es posible que existan restricciones.";
			}
		}
		
		// Segunda acción posible: guardar
		if (request.getParameter("guardar") != null) {
			// Obtengo todos los datos del profesor y los almaceno en BBDD
			try {
				con.setCif(getStringParameter(request, "cif"));
				con.setNombre(getStringParameter(request, "nombre"));
				con.setLocalidad(getStringParameter(request, "localidad"));

				ConcesionarioControlador.getControlador().save(con);
				mensajeAlUsuario = "Guardado correctamente";
			} catch (FormularioIncorrectoRecibidoException e) {
				throw new ServletException(e);
			}
		}
		
		
		
		
		// Ahora muestro la pantalla de respuesta al usuario
		response.getWriter().append("<!DOCTYPE html PUBLIC \"-//W3C//DTD XHTML 1.0 Transitional//EN\" \"http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd\">\r\n" + 
				"<html xmlns=\"http://www.w3.org/1999/xhtml\">\r\n" + 
				"<head>\r\n" + 
				"<meta http-equiv=\"Content-Type\" content=\"text/html; charset=UTF-8\" />\r\n" + 
				"<title>Gestion de Concesionarios</title>\r\n" + 
				//Validation Script
				"<script>\r\n" + 
				"function validateForm() {\r\n" + 
				"  var x = document.forms[\"form1\"][\"cif\"].value;\r\n" + 
				"  var y = document.forms[\"form1\"][\"nombre\"].value;\r\n" + 
				"  var z = document.forms[\"form1\"][\"localidad\"].value;\r\n" + 
				"  if (y == \"\" || x ==\"\" || z==\"\") {\r\n" + 
				"    alert(\"Debes de escribir algo\");\r\n" + 
				"    return false;\r\n" + 
				"  }\r\n" + 
				"}\r\n" + 
				"</script> \r\n" + 
				
				"</head>\r\n" + 
				"\r\n" + 
				"<body " +((mensajeAlUsuario != null && mensajeAlUsuario != "")? "onLoad=\"alert('" + mensajeAlUsuario + "');\"" : "")  + " >\r\n" + 
				"<h1>Ficha de Concesionario</h1>\r\n" + 
				"<a href=\"concesionarioServlet\">Ir al listado de Concesionarios</a>" +
				//Form start
				"<form id=\"form1\" name=\"form1\" onsubmit=\"return validateForm()\" method=\"post\" action=\"datosConcesionarioServlet\" >\r\n" + 
				" <input type=\"hidden\" name=\"idConcesionario\" value=\"" + ((con != null)? con.getId() : "") + "\"\\>" +
				//Formulario para el CIF
				"  <p>\r\n" + 
				"    <label for=\"cif\">CIF:</label>\r\n" + 
				"    <input name=\"cif\" type=\"text\" id=\"cif\" value=\"" + ((con != null)? con.getCif() : "") + "\" />\r\n" + 
				"  </p>\r\n" +
				//Formulario para el Nombre
				"  <p>\r\n" + 
				"    <label for=\"nombre\">Nombre:</label>\r\n" + 
				"    <input name=\"nombre\" type=\"text\" id=\"nombre\"  value=\"" + ((con != null)? con.getNombre() : "") + "\" />\r\n" + 
				"  </p>\r\n" + 
				//Formulario para la localidad
				"  <p>\r\n" + 
				"    <label for=\"localidad\">Localidad:</label>\r\n" + 
				"    <input name=\"localidad\" type=\"text\" id=\"localidad\" value=\"" + ((con != null)? con.getLocalidad() : "") + "\" />\r\n" + 
				"  </p>\r\n" + 
				//Botones
				"  <p>\r\n" + 
				"    <input type=\"submit\" name=\"guardar\" value=\"Guardar\" />\r\n" + 
				"    <input type=\"submit\" name=\"eliminar\" value=\"Eliminar\" />\r\n" + 
				"  </p>\r\n" + 
				"</form>" + 
				"</body>\r\n" + 
				"</html>\r\n" + 
				"");

	}

	/**
	 * @see HttpServlet#doPost(HttpServletRequest request, HttpServletResponse response)
	 */
	protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		doGet(request, response);
	}

	
	/**
	 * 
	 * @param request
	 * @param nombreParametro
	 * @return
	 * @throws FormularioIncorrectoRecibidoException
	 */
	public int getIntParameter (HttpServletRequest request, String nombreParametro) throws FormularioIncorrectoRecibidoException {
		try {
			return Integer.parseInt(request.getParameter(nombreParametro));
		} catch (Exception e) {
			throw new FormularioIncorrectoRecibidoException("No se ha recibido valor entero para el parámetro " + nombreParametro);
		}
	}

	/**
	 * 
	 * @param request
	 * @param nombreParametro
	 * @return
	 * @throws FormularioIncorrectoRecibidoException
	 */
	public String getStringParameter (HttpServletRequest request, String nombreParametro) throws FormularioIncorrectoRecibidoException {
		if (request.getParameter(nombreParametro) != null) {
			return request.getParameter(nombreParametro);
		}
		throw new FormularioIncorrectoRecibidoException("No se ha recibido valor para el parámetro " + nombreParametro);
	}

}
