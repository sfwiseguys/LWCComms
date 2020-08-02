/******* Controller Class for LWC to get Vf origin and for LWC to fire a Platform Event *******/
public with sharing class POV_Controller {
  
  
  // VF Getter Variable for dynamic LEX Origin
  public string lexOrigin {get{ return URL.getOrgDomainUrl().toExternalForm().split('.my.')[0]+'.lightning.force.com';} set;}
  // Expected Format = https://domain.lightning.salesforce.com
  
  
  /******* Method to publish a Platform Event  *******/
  @AuraEnabled
    public static void publishEvent(String message) {
    POV_Platform_Event__e event = new POV_Platform_Event__e(Message__c = message);

    Database.SaveResult result = EventBus.publish(event);

    if (!result.isSuccess()) {
      for (Database.Error error : result.getErrors()) {
        System.debug('Error returned: ' +error.getStatusCode() +' - ' +error.getMessage());
      }
    }
  }



   /******* Method to dynamically obtain VF origin for the iframe VF page in LWC  *******/
   @AuraEnabled(cacheable=true)
    public static string getVFOrigin() {
      string vfOrigin ='';
      string baseURL = URL.getOrgDomainUrl().toExternalForm(); // Expected Format = https://domain.my.salesforce.com
      
      Organization oOrg = [SELECT InstanceName, IsSandbox, OrganizationType FROM Organization LIMIT 1];
      
      /* Important To dynamically form the distinct ORIGIN URL of Sandbox, Production and a Developer Edition Org*/
      if(oOrg.OrganizationType == 'Developer Edition'){
        // Expected Format for DE Org = https://domain--c.ap4.visual.force.com
        vfOrigin = baseURL.split('.my.')[0]+'--c.'+oOrg.InstanceName.toLowercase()+'.visual.force.com'; 
        
      } else {
        // Expected Format for Sandbox & Production = https://domain--c.visualforce.com
        vfOrigin = baseURL.split('.my.')[0]+'--c.'+'visualforce.com'; 
      }       
      
      return vfOrigin;
    }
}
