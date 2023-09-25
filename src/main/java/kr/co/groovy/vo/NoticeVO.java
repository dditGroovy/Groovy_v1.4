package kr.co.groovy.vo;

import com.fasterxml.jackson.annotation.JsonFormat;
import lombok.Getter;
import lombok.Setter;
import lombok.ToString;

import java.sql.Date;

@Getter
@Setter
@ToString
public class NoticeVO {
    private String notiEtprCode;
    private String notiTitle;
    private String notiContent;
    @JsonFormat(shape=JsonFormat.Shape.STRING, pattern="yyyy-MM-dd", timezone = "Asia/Seoul")
    private Date notiDate;
    private int notiRdcnt;
    private String notiCtgryIconFileStreNm;
    private String commonCodeNotiKind;
}
