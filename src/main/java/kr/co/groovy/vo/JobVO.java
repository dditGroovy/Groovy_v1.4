package kr.co.groovy.vo;

import com.fasterxml.jackson.annotation.JsonFormat;
import lombok.Getter;
import lombok.Setter;
import lombok.ToString;

import java.sql.Date;
import java.util.List;

@Getter
@Setter
@ToString
public class JobVO {
    private int jobNo;
    private String jobRequstEmplId;
    private String jobRequstEmplNm;
    private String jobRequstEmplProfl;
    private String jobSj;
    private String jobCn;
    @JsonFormat(shape=JsonFormat.Shape.STRING, pattern="yyyy-MM-dd", timezone = "Asia/Seoul")
    private Date jobBeginDate;
    @JsonFormat(shape=JsonFormat.Shape.STRING, pattern="yyyy-MM-dd", timezone = "Asia/Seoul")
    private Date jobClosDate;
    @JsonFormat(shape=JsonFormat.Shape.STRING, pattern="yyyy-MM-dd", timezone = "Asia/Seoul")
    private Date jobRequstDate;
    private String commonCodeDutyKind;

    private List<String> selectedEmplIds; //수신 사원 리스트
    private List<JobProgressVO> jobProgressVOList;
}
