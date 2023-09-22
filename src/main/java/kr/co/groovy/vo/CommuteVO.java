package kr.co.groovy.vo;

import lombok.Getter;
import lombok.Setter;
import lombok.ToString;

@Getter
@Setter
@ToString
public class CommuteVO {
    private String dclzWorkDe;
    private String dclzEmplId;
    private String dclzAttendTm;
    private String dclzLvffcTm;
    private int dclzDailWorkTime;
    private int dclzWikWorkTime;
    private String commonCodeLaborSttus;
    private String commonCodeClsf;
    private String dclzWorkWik;
    private String emplNm;
    private String deptNm;
    private String clsfNm;
    private int defaulWorkDate;
    private int realWikWorkDate;
    private String defaulWorkTime;
    private String realWorkTime;
    private String overWorkTime;
    private String totalWorkTime;
    private String avgWorkTime;
    private int coWtrmsAbsenc; // 무단결근 개수

}
