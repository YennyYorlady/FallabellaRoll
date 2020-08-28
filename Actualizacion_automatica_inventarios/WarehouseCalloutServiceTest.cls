@IsTest
private class WarehouseCalloutServiceTest {
    @isTest
    static void WarehouseEquipmentSync(){
        Test.startTest();
        //Clase de llamada simulada
        Test.setMock(HttpCalloutMock.class, new WarehouseCalloutServiceMock()); 
        //Esto hace que se envíe una respuesta falsa desde la clase que implementa HttpCalloutMock.
        WarehouseCalloutService.runWarehouseEquipmentSync();
        Test.stopTest();        
        System.assertEquals(1, [SELECT count() FROM Product2]); 
    }
}