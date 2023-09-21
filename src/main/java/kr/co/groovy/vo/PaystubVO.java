package kr.co.groovy.vo;

import com.fasterxml.jackson.annotation.JsonFormat;
import lombok.Getter;
import lombok.Setter;
import lombok.ToString;

import java.util.Date;

@Getter
@Setter
@ToString
public class PaystubVO {
    private String salaryDtsmtEtprCode;
    private Date salaryDtsmtIssuDate;
    private String salaryEmplId;
    private int salaryDtsmtDdcTotamt; // 공제액계
    private int salaryDtsmtPymntTotamt; // 지급액계
    private int salaryDtsmtNetPay; // 실수령액
    private int salaryDtsmtSisNp; // 국민연금
    private int salaryDtsmtSisHi; // 건강보험
    private int salaryDtsmtSisEi; // 고용보험
    private int salaryDtsmtSisWci; // 산재보험
    private int salaryDtsmtIncmtax; // 소득세
    private int salaryDtsmtLocalityIncmtax; // 지방소득세
    private int salaryBslry; // 통상임금
    private double salaryOvtimeAllwnc; // 시간외수당
}
