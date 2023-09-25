package kr.co.groovy.vo;

import com.fasterxml.jackson.annotation.JsonFormat;
import lombok.Getter;
import lombok.Setter;
import lombok.ToString;

import java.sql.Date;

@Getter
@Setter
@ToString
public class VacationUseVO {
    private int yrycUseDtlsSn;
    @JsonFormat(shape=JsonFormat.Shape.STRING, pattern="yyyy-MM-dd", timezone = "Asia/Seoul")
    private Date yrycUseDtlsBeginDate;
    @JsonFormat(shape=JsonFormat.Shape.STRING, pattern="yyyy-MM-dd", timezone = "Asia/Seoul")
    private Date yrycUseDtlsEndDate;
    private String yrycUseDtlsRm;
    private String commonCodeYrycUseKind;
    private String commonCodeYrycUseSe;
    private String yrycUseDtlsEmplId;
    private String yrycUseDtlsEmplNm;
    private String elctrnSanctnEtprCode;
    private String commonCodeYrycState;
    private String profileFileName;
    private int generatedKey;

}
