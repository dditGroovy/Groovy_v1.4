package kr.co.groovy.memo;

import kr.co.groovy.vo.MemoVO;
import org.apache.ibatis.annotations.Param;

import java.util.List;

public interface MemoMapper {
	
	public List<MemoVO> getMemo(String memoEmplId);
	
	public MemoVO getOneMemo(int memoSn);
	
	public int inputMemo(MemoVO memoVO);
	
	public int modifyMemo(MemoVO memoVO);
	
	public int deleteMemo(int memoSn);

	public int updateMemoAlarm(@Param("memoSn") int memoSn, @Param("memoEmplId") String memoEmplId);

	public MemoVO getFixMemo(String memoEmplId);
	
	public int noFix(int memoSn);
}
