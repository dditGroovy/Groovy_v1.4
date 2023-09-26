package kr.co.groovy.memo;

import java.util.List;


import org.springframework.stereotype.Service;

import kr.co.groovy.vo.MemoVO;

@Service
public class MemoService {
	final
	MemoMapper memoMapper;
	
	public MemoService(MemoMapper memoMapper) {
		this.memoMapper = memoMapper;
	}
	
	
	public List<MemoVO> getMemo(String memoEmplId) {
		return memoMapper.getMemo(memoEmplId);
	}
	
	public MemoVO getOneMemo(int memoSn) {
		return memoMapper.getOneMemo(memoSn);
	}
	
	public int inputMemo(MemoVO memoVO) {
		return memoMapper.inputMemo(memoVO);
	}
	
	public int modifyMemo(MemoVO memoVO) {
		return memoMapper.modifyMemo(memoVO);
	}
	
	public int deleteMemo(int memoSn) {
		return memoMapper.deleteMemo(memoSn);
	}
	
	public int updateMemoAlarm(int memoSn) {
		return memoMapper.updateMemoAlarm(memoSn);
	}
	
	public MemoVO getFixMemo() {
		return memoMapper.getFixMemo();
	}

}
