@isTest
public class MaintenanceRequestTest {
    static testmethod void test_Closing_300_Routine_Maintenance_should_create_300_New_Maint(){
    	//Se crean datos de prueba
    	List<Vehicle__c> vehiculos = TestDataFactory.crearVehiculo();
    	List<Product2> productosCreados = TestDataFactory.crearProducto();       
    	List<Case> solicitudWorkPart = TestDataFactory.crearNumeroSolicitudes(1);//Se crea solicitud a usar en crearWorkpPart
        List<Work_Part__c> partesTrabajo = TestDataFactory.crearWorkpPart(productosCreados,solicitudWorkPart);
        List<Case> solicitudesCarga = TestDataFactory.clonarSolicitudes(299, solicitudWorkPart[0]);
            	
    	//Se da inicio a la prueba
    	Test.startTest();
        //Se actualizan las solicitudes clonadas.
    	for(Case solicitud : solicitudesCarga){
    		solicitud.status = 'Closed';
    	}
    	update solicitudesCarga;
        //Se actualiza la solicitud donde el asunto esta vacio
        solicitudWorkPart[0].status='Closed';
        update solicitudWorkPart;
    	Test.stopTest();			
    	//Se finaliza prueba 
    	//Assert    	
    	List<Case> allCases = [SELECT ID,Date_Due__c FROM Case WHERE status = 'New'];
    	System.assertEquals(300,allCases.size());	
    	
    }
}