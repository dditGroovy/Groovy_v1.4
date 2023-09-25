package kr.co.groovy.vo;


import com.fasterxml.jackson.annotation.JsonFormat;
import lombok.Getter;
import lombok.Setter;
import lombok.ToString;

import java.sql.Date;

@Getter
@Setter
@ToString
public class AnswerVO {
    private int answerNo;
    private String sntncEtprCode;
    private String answerWrtingEmplId;
    private String answerWrtingEmplNm;
    private String answerCn;
    @JsonFormat(shape=JsonFormat.Shape.STRING, pattern="yyyy-MM-dd", timezone = "Asia/Seoul")
    private Date answerDate;
    private String proflPhotoFileStreNm;

}
