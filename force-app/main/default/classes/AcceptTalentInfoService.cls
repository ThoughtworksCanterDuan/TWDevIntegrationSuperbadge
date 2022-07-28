/**
 * Description: accept talent info from head-hunting company
 * 
 * CHANGE HISTORY
 * =========================================
 * Date         Developer       Description
 * 2022-7-11    Xueqiang Duan   Create
 */
@SuppressWarnings('PMD.ApexCRUDViolation')
@RestResource(urlMapping='/accept/AcceptTalentInfoService' )
global without sharing class AcceptTalentInfoService {

    global class TalentInfo {
        public String talentSource;
        public List<Lead> talentList;
    }
    /**
     * Description create/update talent info from head-hunting company
     */
    @HttpPost
    global static WebServiceEntityClass.Response talentInfoService(AcceptTalentInfoService.TalentInfo talentInfo) {

        System.debug('talentInfo: ' + talentInfo);
        WebServiceEntityClass.Response resp;
        String companyInfo = talentInfo.talentSource;
        List<Lead> talentList = new List<Lead>();
        talentList = talentInfo.talentList;
        // Process talent info to salesforce database
        if (talentList == null || !(talentList.size() > 1) || companyInfo == '' || companyInfo == null){
            return resp = WebServiceEntityClass.responseMethod(WebServiceEntityClass.errorCode, '必填信息缺失,请检查 talentSource / talentList 是否有值!' , WebServiceEntityClass.failureStatus);
        }
        List<Lead> leadUpsertList = new List<Lead>();
        String mismatchTalentInfo = '';
        try{
            // Check talent skill meet mdt condition
            for (Lead talentDetail : talentList) {
                String talentSkill = talentDetail.Skill_Set__c;
                if (talentSkill != null && talentSkill != '') {
                    Boolean meetSkillCondition = checkTalentSkillMeetMDTCondition(talentSkill);
                    if (meetSkillCondition) {
                        talentDetail.Company = companyInfo;
                        talentDetail.Data_Provider__c = companyInfo;
                        leadUpsertList.add(talentDetail);
                    } else {
                        mismatchTalentInfo += talentDetail.External_ID__c + ' - ' + talentDetail.LastName + ';' ;
                    }
                } else {
                    leadUpsertList.add(talentDetail);
                }
            }
            System.debug('leadUpsertList: ' + leadUpsertList);
            if (leadUpsertList.size() > 0){
                upsert leadUpsertList External_ID__c;
            }
        }catch(Exception e){
            System.debug('Error Message: ' + e);
            return WebServiceEntityClass.responseMethod(WebServiceEntityClass.errorCode, e.getMessage() , WebServiceEntityClass.failureStatus);
        }

        String returnSuccessMessage = '候选人信息已经录入, 感谢您对Thoughtworks招聘的支持! ';
        if (mismatchTalentInfo != '') {
            returnSuccessMessage += '存在部分技能不符合Thoughtworks招聘要求的候选人没有录入系统, 请查收: ' + mismatchTalentInfo;
        }

        resp = WebServiceEntityClass.responseMethod(WebServiceEntityClass.successCode, returnSuccessMessage, WebServiceEntityClass.successStatus);
        return resp;
    }

    /********************************************************************************************************
    *  @description  checkTalentSkillMeetMDTCondition - This is the main method to check the talent skill meet custom metadata type configuration 
    *  @return WebServiceEntityClass.response : this is a return statement and having return result as failure or success  
    *  @param talentSkill - Talent skill info from request param
    *********************************************************************************************************/
    private static Boolean checkTalentSkillMeetMDTCondition(String talentSkill) {
        Boolean meetMDTCondition = true;
        // get talent sync condition from custom metadata type
        List<Talent_Sync_Condition__mdt> talentConditionMdt = Talent_Sync_Condition__mdt.getAll().values();
        System.debug('Talent sync condition mdt:' + talentConditionMdt);
        List<String> skillConditionList = talentConditionMdt[0].Skill_Set__c.split(';');

        for(String skillInfo: skillConditionList){
            if (!talentSkill.contains(skillInfo)){
                meetMDTCondition = false;
                break;
            }
        }

        return meetMDTCondition;
    }

}