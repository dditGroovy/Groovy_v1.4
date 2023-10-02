package kr.co.groovy.vo;

import java.util.Date;

import com.fasterxml.jackson.annotation.JsonFormat;
import lombok.Getter;
import lombok.Setter;
import lombok.ToString;

@Getter
@Setter
@ToString
public class MemoVO {
	private int memoSn;
	private String memoEmplId;
	private String memoSj;
	private String memoCn;
	@JsonFormat(shape=JsonFormat.Shape.STRING, pattern="yyyy-MM-dd", timezone = "Asia/Seoul")
	private Date memoWrtngDate;
	private String commonCodeFixingAt;
}
