package conexion;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.SQLException;

public class ConexionBD {
    
    public static void main(String[] args) {
        String url = "jdbc:mysql://127.0.0.1:3306/pruevasemana6"; // direccion de  "pruebaDB" por tu DB
        String usuario = "root"; // tu usuario de MySQL
        String contraseña = ""; // tu contraseña de MySQL

            try (Connection ConexionBD = DriverManager.getConnection(url, usuario, contraseña)) {
                System.out.println("¡Conexión exitosa a la base de datos!");
                // Aquí puedes hacer consultas SQL
                // siempre cerrar la conexión
            }
        catch (SQLException e) {
            System.out.println("Error al conectar: " + e.getMessage());
        }
    }
}