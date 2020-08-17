@isTest(SeeAllData = false)
public class POV_ControllerTest {

    /*
    * @Method Name                    :  getTestingUser
    * @Description                    :  Creates a Test User
    * @Return Type                    :  User
    * @Parameters                     :  None
    */
    public static User getTestingUser() {

        String dateString = String.valueof(Datetime.now()).replace(' ', '').replace(':', '').replace('-', '');
        Integer randomInt = Integer.valueOf(math.rint(math.random() * 1000000));
        String uniqueName = dateString + randomInt;

        User u;
        String pId = [select Id from Profile where Name = 'System Administrator'].Id;
        u = new User(profileId = pId, email = uniqueName + '@test' + uniqueName + '.gmail.com',
                     Username = uniqueName + '@test' + uniqueName +  'gmail.com',
                     alias = 'uqusr', lastname = 'lastname', emailencodingkey = 'UTF-8', localesidkey = 'en_US',
                     languagelocalekey = 'en_US', timezonesidkey = 'GMT');
        insert u;
        system.assertNotEquals(NULL, u);
        return u;
    }



    /*
    * @Method Name                    :  test_All
    * @Description                    :  Method to Test all methods in Class- POV_Controller
    * @Return Type                    :  None
    * @Parameters                     :  None
    */

    static testMethod void test_All() {
        User u = getTestingUser();
        System.runAs(u) {
            Test.StartTest();
            POV_Controller oCon = new POV_Controller();
            // Assert LEX Origin
            system.assertEquals(oCon.lexOrigin.endsWith('.lightning.force.com'), true);


            // Test firing of Platform event
            POV_Controller.publishEvent('Hello World');

            // Assert VF Origin
            system.assertEquals(POV_Controller.getVFOrigin().endsWith('visualforce.com'), true);

            // Assert VF Origin,conditionally, if Trying in a Trailhead Playground
            /* Organization oOrg = [SELECT InstanceName, IsSandbox, OrganizationType FROM Organization LIMIT 1];
              if(oOrg.OrganizationType == 'Developer Edition'){
                system.assertEquals(POV_Controller.getVFOrigin().endsWith('visual.force.com'),true); // For TP
              } else {
                system.assertEquals(POV_Controller.getVFOrigin().endsWith('visualforce.com'),true); // For DE, Sandbox & Prod
              }
            */


            Test.StopTest();
        }
    }





}