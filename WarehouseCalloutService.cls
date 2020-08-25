public with sharing class WarehouseCalloutService {    
    public static void runWarehouseEquipmentSync(){
        Http http = new Http();
        HttpRequest request = new HttpRequest();
        request.setEndpoint('https://th-superbadge-apex.herokuapp.com/equipment');
        request.setMethod('GET');
        HttpResponse response = http.send(request);
        
        // Si la solicitud se realiza correctamente
        // Se entra a analizar la respuesta
        if (response.getStatusCode() == 200) {
            //Se decodifica el resultado en una lista de objetos
            List<Object> equipos = (List<Object>) JSON.deserializeUntyped(response.getBody());
            List<Product2> productos = new List<Product2>();
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
            if(productos.size() > 0){                
                //Se actualizan los productos existentes
                //y si es de caso se crean nuevos productos nuevos faltantes
                upsert productos;
            }
        }
    }
}