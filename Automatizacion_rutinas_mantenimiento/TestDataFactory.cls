@isTest
public class TestDataFactory {
    //Metodo para crear vehiculo
    public static testmethod List<Vehicle__c> crearVehiculo(){
        //Se crea lista con el fin de que sea más facil agregar nuevos productos
        //y para que solo se ejecute una inserción
        //Teniendo encuenta la restriccion SOQL Query
        List<Vehicle__c> vehiculos = new List<Vehicle__c>();
        //Se crea un registro de vehiculo
        Vehicle__c vehiculo = new Vehicle__c();
        vehiculo.name = 'Caravana';
        vehiculos.add(vehiculo);
        insert vehiculos; 
        //Se retorna le vehiculo creado
        return vehiculos;
    }
    //Metodo para crear Producto
    public static testmethod List<Product2> crearProducto(){
        //Se crea lista con el fin de que sea más facil agregar nuevos productos
        //y para que solo se ejecute una inserción
        //Teniendo encuenta la restriccion SOQL Query
        list<Product2> productos = new list<Product2>();
        //Se crea un registro para producto
        Product2 producto = new Product2();
        producto.Maintenance_Cycle__c = 170;
        producto.Cost__c=300;
        producto.Name='Fuse 17A';
        producto.ProductCode='GC7777';
        productos.add(producto);
        //Se registra las lista de productos
        insert productos;
        //Se devuelve el producto creado
        return productos;               
    }
    //Metodo para crear Work part
    //Se recibe los productos y las solicitudes que son campos requeridos
    public static List<Work_Part__c> crearWorkpPart(List<Product2> productosCreados, List<Case> solicitudes){
        //Se creo producto que va ir relacionado en work part
       // List<Product2> productos= crearProducto();
        //Se crea solicitud que va ir relacionada en work part
        //No se usan datos 
        //List<Case> solicitudes = crearNumeroSolicitudes(1);
       
        List<Work_Part__c> worksPart = new List<Work_Part__c>(); 
        Work_Part__c workPart = new Work_Part__c();
        
        for(Product2 product:productosCreados){
           workPart = new Work_Part__c();  
           system.debug('product'+product.Id); 
           workPart.Equipment__c = '01t4W00000BX6JjQAL';
           workPart.Maintenance_Request__c = solicitudes[0].Id;//Solo se usa un caso, se recibe lista para pruebas futuras
           worksPart.add(workPart);
        }
        insert worksPart;
        return worksPart;
    }
   //Metodo para crear un número recibido de solicitudes
   public static List<Case> crearNumeroSolicitudes(Integer numeroSolicitudes){
       List<Case> solicitudes = new List<Case>();
       Case solicitud = new Case();
       for(Integer i = 1; i <= numeroSolicitudes; i++){
           solicitud.Status='New';
           solicitud.Type = 'Routine Maintenance';
           solicitud.Origin= 'Phone';
           solicitud.Date_Reported__c = Date.today().addDays(i);// Para que las solicitudes no qden identicas y se permita su creación
           solicitudes.add(solicitud);           
       }
       insert solicitudes;
       return solicitudes;       
   }
    
   //Metodo para clonar solicitudes
    public static List<Case> clonarSolicitudes(Integer numeroSolicitudes, case solicitud){
       List<Case> solicitudes = new List<Case>();
       Case solicitudClonada = new Case();       
       for(Integer i = 1; i <= numeroSolicitudes; i++){
           solicitudClonada = new Case(); 
           solicitudClonada.Subject= 'TestII';
           solicitudClonada.Status='New';
           solicitudClonada.Type = 'Routine Maintenance';
           solicitudClonada.Origin= 'Email';
           solicitudClonada.Date_Reported__c = Date.today().addDays(i);
           solicitudes.add(solicitudClonada);
       }
       upsert solicitudes;
       return solicitudes;       
   } 
    
}