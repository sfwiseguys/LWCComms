public with sharing class POV_Controller {


  public string lexOrigin {get{ return URL.getOrgDomainUrl().toExternalForm().split('.my.')[0] + '.lightning.force.com';} set;}
  // Expected Format = https://domain.lightning.salesforce.com



  @AuraEnabled
  public static void publishEvent(String message) {
    POV_Platform_Event__e event = new POV_Platform_Event__e(
      Message__c = message
    );

    Database.SaveResult result = EventBus.publish(event);
    if (!result.isSuccess()) {
      for (Database.Error error : result.getErrors()) {
        System.debug(
          'Error returned: ' +
          error.getStatusCode() +
          ' - ' +
          error.getMessage()
        );
      }
    }
  }



  @AuraEnabled(cacheable = true)
  public static string getVFOrigin() {
    string vfOrigin = '';
    string baseURL = URL.getOrgDomainUrl().toExternalForm(); // Expected Format = https://domain.my.salesforce.com

    Organization oOrg = [SELECT InstanceName, IsSandbox FROM Organization LIMIT 1];
    if (oOrg.IsSandbox) {
      // Expected Format for Sandbox = https://domain--c.visualforce.com
      vfOrigin = baseURL.split('.my.')[0] + '--c.' + 'visualforce.com';
    } else {
      // Expected Format for DE Org = https://domain--c.ap4.visual.force.com
      vfOrigin = baseURL.split('.my.')[0] + '--c.' + oOrg.InstanceName.toLowercase() + '.visual.force.com';
    }
    return vfOrigin;
  }
}
