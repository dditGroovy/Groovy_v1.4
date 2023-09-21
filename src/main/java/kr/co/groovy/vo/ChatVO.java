package kr.co.groovy.vo;

import lombok.Getter;
import lombok.Setter;
import lombok.ToString;

import java.util.Date;

@Getter
@Setter
@ToString
public class ChatVO {
    private Long chttNo;
    private int chttRoomNo;
    private String chttMbrEmplId;
    private String chttMbrEmplNm;
    private String chttCn;
    private Date chttInputDate;
    private String proflPhotoFileStreNm;

}
