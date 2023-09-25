package kr.co.groovy.vo;

import com.fasterxml.jackson.annotation.JsonFormat;
import lombok.Getter;
import lombok.Setter;
import lombok.ToString;

import java.util.Date;
import java.util.List;

@Getter
@Setter
@ToString
public class AlarmVO {
    private int ntcnSn;
    private String ntcnEmplId;
    private String ntcnCn;
    private String ntcnUrl;
    @JsonFormat(shape=JsonFormat.Shape.STRING, pattern="yyyy-MM-dd", timezone = "Asia/Seoul")
    private Date ntcnDate;
    private String commonCodeNtcnKind;

    private List<String> selectedEmplIds;
}
