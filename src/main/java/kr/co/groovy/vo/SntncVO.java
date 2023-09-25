package kr.co.groovy.vo;

import com.fasterxml.jackson.annotation.JsonFormat;
import lombok.Getter;
import lombok.Setter;
import lombok.ToString;

import java.sql.Date;


@Getter
@Setter
@ToString
public class SntncVO {
    private String sntncEtprCode;
    private String sntncWrtingEmplId;
    private String sntncWrtingEmplNm;
    private String sntncSj;
    private String sntncCn;
    @JsonFormat(shape=JsonFormat.Shape.STRING, pattern="yyyy-MM-dd", timezone = "Asia/Seoul")
    private Date sntncWrtingDate;
    private String commonCodeSntncCtgry;
    private int recomendCnt;
    private int uploadFileSn;
    private String uploadFileOrginlNm;
    private int uploadFileSize;
    private String proflPhotoFileStreNm;
    private String proflEtprCode;

}
