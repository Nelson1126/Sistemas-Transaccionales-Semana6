package main;
import java.util.Scanner; //sirve para leer datos del teclado.//
import java.sql.Connection; // conexión con MySQL//
import java.sql.DriverManager; //  crea la conexión//
import java.sql.PreparedStatement; //ejecutar SQL seguro//
import java.sql.ResultSet; //esultados de consultas//
import java.sql.Statement; // ejecutar SQL simple

public class MenuVentas {
    
    private static Scanner scanner = new Scanner(System.in);
    
    public static void main(String[] args) {
        int opcion;
        
        do {
            mostrarMenu(); //Llama al método que imprime el menú.//
            System.out.print("Ingrese la opción: "); //Lectura de opcion//
            
            try {
                opcion = Integer.parseInt(scanner.nextLine());
                
                switch (opcion) { //Llama al método para crear producto.//
                    case 1:
                        crearProducto();
                        break;
                    case 2:
                        venderProducto();
                        break;
                    case 3:
                        eliminarProducto();
                        break;
                    case 4:
                        leerProductoPorID();
                        break;
                    case 5:
                        actualizarProducto();
                        break;
                    case 6:
                        listarProductos();
                        break;
                    case 7:
                        System.out.println(" ¡Hasta luego!");
                        break;
                    default: //el usuario escribe algo incorrecto//
                        System.out.println(" Opción inválida"); 
                }
            } catch (NumberFormatException e) {
                System.out.println(" Debe ingresar solo el número");
                opcion = 0;
            }
        } while (opcion != 7); //se repite hasta que el usuario elija salir.
    }
    
    private static void mostrarMenu() { // Cada línea es una opción.//
        System.out.println("\n----- SISTEMA DE VENTAS -----");
        System.out.println("1. Crear producto");
        System.out.println("2. Vender producto");
        System.out.println("3. Eliminar producto");
        System.out.println("4. Leer producto por ID");
        System.out.println("5. Actualizar producto");
        System.out.println("6. Listar productos");
        System.out.println("7. Salir");
        System.out.println("--------------------------------");
    }
    
    private static void venderProducto() {
        System.out.println("\n VENDER PRODUCTO");
        
        System.out.print("Ingrese el ID del producto: ");
        int id = Integer.parseInt(scanner.nextLine());
        
        System.out.print("Ingrese la cantidad: ");
        int cantidad = Integer.parseInt(scanner.nextLine());
        
        System.out.print("Ingrese el nombre del cliente: ");
        String cliente = scanner.nextLine();
        
        System.out.print("Ingrese el teléfono del cliente: ");
        String telefono = scanner.nextLine();
        
        // Usando TransaccionDistribuida (el que funciona)
        boolean resultado = TransaccionDistribuida.realizarVenta(id, cantidad, cliente, telefono);
        
        if (!resultado) {
            System.out.println(" No se pudo completar la venta");
        }
    }
    // Creacion de producto//
    private static void crearProducto() {
        System.out.println("\n CREAR PRODUCTO");
        
        // abrir conexion de bd INICIA transacción (BEGIN)//
        try (Connection conn = DriverManager.getConnection(
                "jdbc:mysql://127.0.0.1:3306/pruevasemana6", "root", "")) {
            
            System.out.print("Nombre: ");
            String nombre = scanner.nextLine();
            System.out.print("Descripción: ");
            String descripcion = scanner.nextLine();
            System.out.print("Precio: ");
            double precio = Double.parseDouble(scanner.nextLine());
            System.out.print("Stock: ");
            int stock = Integer.parseInt(scanner.nextLine());
            
            // consulta bd para borrar//
            String sql = "INSERT INTO productos (nombre_producto, descripcion_producto, "
                    + "stock, precio, venta) VALUES (?, ?, ?, ?, 0)";
            
            //  consulta, ejecucion, resultado // 
            PreparedStatement ps = conn.prepareStatement(sql);
            ps.setString(1, nombre);
            ps.setString(2, descripcion);
            ps.setInt(3, stock);
            ps.setDouble(4, precio);
            
            //INICIA transacción (COMMIT)//
            int filas = ps.executeUpdate();
            if (filas > 0) {
                System.out.println(" Producto creado");
            }
        } catch (Exception e) {
            System.out.println(" Error: " + e.getMessage());
        }
    }
            //  consulta, ejecucion, resultado // 
    private static void eliminarProducto() {
        System.out.println("\n️ ELIMINAR PRODUCTO");
        System.out.print("ID del producto: ");
        int id = Integer.parseInt(scanner.nextLine());
        
          // abrir conexion de bd  // INICIA transacción (BEGIN)//
        try (Connection conn = DriverManager.getConnection(
                "jdbc:mysql://127.0.0.1:3306/pruevasemana6", "root", "")) {
            
            //INICIA transacción (COMMIT)//
            String sql = "DELETE FROM productos WHERE id_productos = ?";
            PreparedStatement ps = conn.prepareStatement(sql);
            ps.setInt(1, id);
            int filas = ps.executeUpdate();
            
            if (filas > 0) {
                System.out.println(" Producto eliminado");
            } else {
                System.out.println(" Producto no encontrado");
            }
        } catch (Exception e) {
            System.out.println(" Error: " + e.getMessage());
        }
    }
      // busqueda del producto en la bd  //
    private static void leerProductoPorID() {
        System.out.println("\n🔍 BUSCAR PRODUCTO");
        System.out.print("ID del producto: ");
        int id = Integer.parseInt(scanner.nextLine());
        
        // abrir conexion de bd INICIA transacción (BEGIN) //
        try (Connection conn = DriverManager.getConnection(
                "jdbc:mysql://127.0.0.1:3306/pruevasemana6", "root", "")) {
            
            //INICIA transacción (COMMIT)//
            String sql = "SELECT * FROM productos WHERE id_productos = ?";
            PreparedStatement ps = conn.prepareStatement(sql);
            ps.setInt(1, id);
            ResultSet rs = ps.executeQuery();
            
            if (rs.next()) {
                System.out.println("\n Producto encontrado:");
                System.out.println("ID: " + rs.getInt("id_productos"));
                System.out.println("Nombre: " + rs.getString("nombre_producto"));
                System.out.println("Descripción: " + rs.getString("descripcion_producto"));
                System.out.println("Precio: $" + rs.getDouble("precio"));
                System.out.println("Stock: " + rs.getInt("stock"));
            } else {
                System.out.println(" Producto no encontrado");
            }
        } catch (Exception e) {
            System.out.println(" Error: " + e.getMessage());
        }
    }
    
    private static void actualizarProducto() {
        System.out.println("\n️ ACTUALIZAR PRODUCTO");
        System.out.print("ID del producto: ");
        int id = Integer.parseInt(scanner.nextLine());
        
        //INICIA transacción (BEGIN)//
        try (Connection conn = DriverManager.getConnection(
                "jdbc:mysql://127.0.0.1:3306/pruevasemana6", "root", "")) {
            
            System.out.print("Nuevo nombre: ");
            String nombre = scanner.nextLine();
            System.out.print("Nueva descripción: ");
            String descripcion = scanner.nextLine();
            System.out.print("Nuevo precio: ");
            double precio = Double.parseDouble(scanner.nextLine());
            System.out.print("Nuevo stock: ");
            int stock = Integer.parseInt(scanner.nextLine());
            
            //INICIA transacción (COMMIT)//
            String sql = "UPDATE productos SET nombre_producto=?, "
                    + "descripcion_producto=?, precio=?, "
                    + "stock=? WHERE id_productos=?";
            
            PreparedStatement ps = conn.prepareStatement(sql);
            ps.setString(1, nombre);
            ps.setString(2, descripcion);
            ps.setDouble(3, precio);
            ps.setInt(4, stock);
            ps.setInt(5, id);
            
            int filas = ps.executeUpdate();
            if (filas > 0) {
                System.out.println(" Producto actualizado");
            } else {
                System.out.println(" Producto no encontrado");
            }
        } catch (Exception e) {
            System.out.println(" Error: " + e.getMessage());
        }
    }
    
    private static void listarProductos() {
        System.out.println("\n---LISTADO DE PRODUCTOS----");
        
        try (Connection conn = DriverManager.getConnection(
                "jdbc:mysql://127.0.0.1:3306/pruevasemana6", "root", "")) {
            
            Statement stmt = conn.createStatement();
            ResultSet rs = stmt.executeQuery("SELECT * FROM productos");
            
            boolean hayProductos = false;
            while (rs.next()) {
                hayProductos = true;
                System.out.println("─────────────────────────────────");
                System.out.println("ID: " + rs.getInt("id_productos"));
                System.out.println("Nombre: " + rs.getString("nombre_producto"));
                System.out.println("Descripción: " + rs.getString("descripcion_producto"));
                System.out.println("Precio: $" + rs.getDouble("precio"));
                System.out.println("Stock: " + rs.getInt("stock"));
            }
            //INICIA transacción (ROLLBACK)//
            if (!hayProductos) {
                System.out.println("No hay productos");
            }
        } catch (Exception e) {
            System.out.println(" Error: " + e.getMessage());
        }
    }
} 