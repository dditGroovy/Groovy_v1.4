package kr.co.groovy.vo;

import lombok.Getter;
import lombok.Setter;
import lombok.ToString;

import java.util.Date;

@Getter
@Setter
@ToString
public class PaystubVO {
    private String salaryDtsmtEtprCode; // salary_dtsmt
    private Date salaryDtsmtIssuDate; // salary, salary_dtsmt
    private String salaryEmplId; // salary, salary_dtsmt
    private String salaryEmplNm; // salary, salary_dtsmt
    private int salaryBslry; // 통상임금 | salary
    private int salaryOvtimeAllwnc; // 시간외수당 | salary
    private int salaryDtsmtPymntTotamt; // 지급액계 | salary_dtsmt
    private int salaryDtsmtSisNp; // 국민연금 | salary_dtsmt
    private int salaryDtsmtSisHi; // 건강보험 | salary_dtsmt
    private int salaryDtsmtSisEi; // 고용보험 | salary_dtsmt
    private int salaryDtsmtSisWci; // 산재보험 | salary_dtsmt
    private int salaryDtsmtIncmtax; // 소득세 | salary_dtsmt
    private int salaryDtsmtLocalityIncmtax; // 지방소득세 | salary_dtsmt
    private int salaryDtsmtDdcTotamt; // 공제액계 | salary_dtsmt
    private int salaryDtsmtNetPay; // 실수령액 | salary_dtsmt
    private String insertAt;
    private String month;
    private String DeptNm;
    private String ClsfNm;
}
