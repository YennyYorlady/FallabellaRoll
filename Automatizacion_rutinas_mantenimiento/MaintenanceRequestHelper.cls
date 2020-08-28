public with sharing class MaintenanceRequestHelper {
    //Se recibe el mapa de los casos a evaluar
    public static void updateWorkOrders(Map<Id, Case>  cases){        
        // Se crea una lista para registrar los nuevos casos a crear de tipo rutina de mantenimiento    
        List<Case> maintenance_routineList = new List<Case>();
        
        //Se crea una lista para consultar el valor minimo del ciclo de mantenimiento
        //de los work part que estan asociados a la solicitud       
        List<AggregateResult> listProduct = [SELECT min(Equipment__r.Maintenance_Cycle__c) ciclo, Maintenance_Request__c solicitud
                                             FROM Work_Part__c where Equipment__r.Maintenance_Cycle__c <> 0 
                                             group by Maintenance_Request__c];  
        system.debug('listProduct'+listProduct);
        Map<Id,decimal> mapProduct = new Map<Id, decimal>();
        
        for (AggregateResult producto : listProduct) {
            if (producto != null) { //Se valida si se obtienen resultados de la consulta               
                mapProduct.put((String)producto.get('solicitud'), (Decimal)producto.get('ciclo'));  //Se llena el mapa con la información resultante
                //Se usa el mapa para facilitar la busqueda de los resultados
            }
        }
        System.debug('product: '+mapProduct);
        
        // Se recorre el mapa de casos recibidos 
        for(Case maintenance:cases.values()){
            Case maintenanceNew = new Case();
            //Dado que no se debe permitir solicitud con asunto vacio             
            //Se valida y si el campo asunto de la solicitud origen esta vacio, se llena            
            if(maintenance.Subject != null){
                maintenanceNew.Subject = maintenance.Subject;  
            }else{
                maintenanceNew.Subject ='Solicitud creada automaticamente'; 
            }            
            //Si existe work part asociado a la solicitud 
            //Se obtiene la fecha minina de ciclo de mantenimiento para
            //Asociarlo a la nueva solicitud  
            if (mapProduct.get(maintenance.id) != null) {
                // Se llena la fecha de vencimiento de la solicitud tomando la fecha actual más el ciclo de 
                // mantenimiento minimo obtenido
                maintenanceNew.Date_Due__c = Date.today().addDays(Integer.valueOf(mapProduct.get(maintenance.id)));
            }
            //Se registra en la nueva solictud la información de la solicitud origen
            maintenanceNew.Vehicle__c = maintenance.Vehicle__c;
            maintenanceNew.Product__c = maintenance.Product__c;
            maintenanceNew.ContactId  = maintenance.ContactId;
            maintenanceNew.AccountId  = maintenance.AccountId;
            maintenanceNew.AssetId    = maintenance.AssetId;
            maintenanceNew.Type       = 'Routine Maintenance';
            maintenanceNew.Status     = 'New';
            maintenanceNew.Equipment__c = maintenance.Equipment__c;
            maintenanceNew.Date_Reported__c = Date.today();
            // Se adiciona el registro a la lista            
            maintenance_routineList.add(maintenanceNew);
        }
        //Se crea las solicitudes
        insert maintenance_routineList;                  
    }      
    
}