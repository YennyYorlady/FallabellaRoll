public with sharing class WarehouseCalloutService {
   private static final String WAREHOUSE_URL = 'https://th-superbadge-apex.herokuapp.com/equipment';
    @future (callout = true)
    public static void runWarehouseEquipmentSync(){
        Http http = new Http();
        HttpRequest request = new HttpRequest();
        request.setEndpoint(WAREHOUSE_URL);
        request.setMethod('GET');
        HttpResponse response = http.send(request);
        
        // Si la solicitud se realiza correctamente
        // Se entra a analizar la respuesta
        if (response.getStatusCode() == 200) {            
            //Se decodifica el resultado en una lista de objetos
            List<Object> equipos = (List<Object>) JSON.deserializeUntyped(response.getBody());
           //Se crea lista del objeto Product2 para recibir y almacenar la información del inventario
            List<Product2> productos = new List<Product2>();
            //Se recorre la lista recibida del sistema externo
            for(Object equipo :  equipos){
                Map<String, Object> mapaProductos = (Map<String, Object>)equipo;
                Product2 producto = new Product2();
                producto.Name = (String)mapaProductos.get('name');
                producto.Cost__c = (Integer)mapaProductos.get('cost');
                producto.Current_Inventory__c = (Integer)mapaProductos.get('quantity');
                producto.Maintenance_Cycle__c = (Integer)mapaProductos.get('maintenanceperiod');
                producto.Replacement_Part__c = (Boolean)mapaProductos.get('replacement');
                producto.Lifespan_Months__c = (Integer)mapaProductos.get('lifespan');
                producto.Warehouse_SKU__c = (String)mapaProductos.get('sku');
                producto.ProductCode = (String)mapaProductos.get('_id');                
                productos.add(producto);                
            }
            //Si se reciben registros del sistema externo            
            if(productos.size() > 0){ 
                try{
                    //Se actualizan los productos existentes
                    //y si es de caso se crean nuevos productos nuevos faltantes
                    //Se indica cual es el id externo
                    upsert productos Product2.Warehouse_SKU__c;
                }catch(Exception e){//Si no es posible actualizar la información se puede hacer seguimiento
                    system.debug('Exception'+ e);
                }
                
            }
        }
    }
}