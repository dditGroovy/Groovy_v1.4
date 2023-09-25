package kr.co.groovy.vo;

import com.fasterxml.jackson.annotation.JsonFormat;
import lombok.Getter;
import lombok.Setter;
import lombok.ToString;

import java.sql.Date;

@Getter
@Setter
@ToString
public class CardReservationVO {
    private int cprCardResveSn;
    @JsonFormat(shape=JsonFormat.Shape.STRING, pattern="yyyy-MM-dd", timezone = "Asia/Seoul")
    private Date cprCardResveBeginDate;
    @JsonFormat(shape=JsonFormat.Shape.STRING, pattern="yyyy-MM-dd", timezone = "Asia/Seoul")
    private Date cprCardResveClosDate;
    private String cprCardResveEmplId;
    private String cprCardResveEmplNm;
    private String commonCodeResveAt; // RESVE010: 비예약, RESVE011: 예약
    private String cprCardNo;
    private String cprCardNm;
    private int cprCardResveRturnAt; // 0: 반납X / 1: 반납O
    private String cprCardUseLoca;
    private String cprCardUsePurps;
    private int cprCardUseExpectAmount;
    private String commonCodeYrycState;
    private int generatedKey;
    private String emplNm;
    private String commonCodeDept;
    private String commonCodeClsf;
    private String elctrnSanctnEtprCode;
}
