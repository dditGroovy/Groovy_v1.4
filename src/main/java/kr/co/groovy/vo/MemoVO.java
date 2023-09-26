package kr.co.groovy.vo;

import java.util.Date;

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
	private Date memoWrtngDate;
	private String commonCodeFixingAt;
}
