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
public class VoteRegisterVO {
    private int voteRegistNo;
    private String voteRegistEmpId;
    private String voteRegistTitle;
    @JsonFormat(shape=JsonFormat.Shape.STRING, pattern="yyyy-MM-dd", timezone = "Asia/Seoul")
    private Date voteRegistStartDate;
    @JsonFormat(shape=JsonFormat.Shape.STRING, pattern="yyyy-MM-dd", timezone = "Asia/Seoul")
    private Date voteRegistEndDate;
    private String voteRegistAt;
    private List<VoteOptionVO> voteOptionList;

    private List<String> voteOptionNames;
}
