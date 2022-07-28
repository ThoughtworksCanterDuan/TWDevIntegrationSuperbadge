/**
 * Description: Test for AcceptTalentInfoService class
 * 
 * CHANGE HISTORY
 * =========================================
 * Date         Developer       Description
 * 2022-7-21    Xueqiang Duan   Create
 */

@isTest(seeAllData=false)
public class AcceptTalentInfoServiceTest {
    
    @isTest
    public static void talentInfoServiceTestSuccess() {
        AcceptTalentInfoService.TalentInfo talentInfo = new AcceptTalentInfoService.TalentInfo();
        talentInfo.talentSource = '猎头公司';

        Lead leadInsert = new Lead();
        leadInsert.External_ID__c = '0004';
        leadInsert.LastName = 'Diana wu';
        leadInsert.Phone = '77777777';
        leadInsert.Email = 'Diana.wu@gmail.com';
        leadInsert.Education__c = '本科';
        leadInsert.Certification__c = 'PMP;Salesforce Admin';
        leadInsert.Project_Experience__c = '项目经验';
        leadInsert.Skill_Set__c = 'Salesforce;English';
        leadInsert.Company = '猎头公司';
        insert leadInsert;

        List<Lead> talentList = new List<Lead>();
        
        Lead leadFirst = new Lead();
        leadFirst.External_ID__c = '0010';
        leadFirst.LastName = 'Grace Li';
        leadFirst.Phone = '88888888';
        leadFirst.Email = 'Grace.Li@gmail.com';
        leadFirst.Education__c = '本科';
        leadFirst.Certification__c = 'PMP;Salesforce Admin';
        leadFirst.Project_Experience__c = '项目经验';
        leadFirst.Skill_Set__c = 'Salesforce;English';
        talentList.add(leadFirst);

        Lead leadSecond = new Lead();
        leadSecond.External_ID__c = '0004';
        leadSecond.Phone = '99999999';
        talentList.add(leadSecond);

        Lead leadThird = new Lead();
        leadThird.External_ID__c = '0011';
        leadThird.LastName = 'Vincent Li';
        leadThird.Phone = '1010101010';
        leadThird.Email = 'Vincent.Li@gmail.com';
        leadThird.Education__c = '本科';
        leadThird.Certification__c = 'PMP;Salesforce Admin';
        leadThird.Project_Experience__c = '项目经验';
        leadThird.Skill_Set__c = 'Salesforce;Jave';
        talentList.add(leadThird);

        talentInfo.talentList = talentList;

        WebServiceEntityClass.Response resp = new WebServiceEntityClass.Response();
        resp = AcceptTalentInfoService.talentInfoService(talentInfo);

        System.assertEquals('候选人信息已经录入, 感谢您对Thoughtworks招聘的支持! 存在部分技能不符合Thoughtworks招聘要求的候选人没有录入系统, 请查收: 0011 - Vincent Li;', resp.statusMsg, 'AcceptTalentInfoService return message wrong!');
        System.assertEquals('200', resp.statusCode , 'AcceptTalentInfoService return statusCode wrong!');
        System.assertEquals('Success', resp.status , 'AcceptTalentInfoService return status wrong!');

    }
    
    @isTest
    public static void talentInfoServiceTestFail() {
        AcceptTalentInfoService.TalentInfo talentInfo = new AcceptTalentInfoService.TalentInfo();
        talentInfo.talentSource = '猎头公司';
        
        WebServiceEntityClass.Response resp = new WebServiceEntityClass.Response();
        resp = AcceptTalentInfoService.talentInfoService(talentInfo);

        System.assertEquals('没有获取到任何Talent信息, 请确认请求参数是否合理!', resp.statusMsg, 'AcceptTalentInfoService return message wrong!');
        System.assertEquals('400', resp.statusCode , 'AcceptTalentInfoService return statusCode wrong!');
        System.assertEquals('Failed', resp.status , 'AcceptTalentInfoService return status wrong!');
    }
}