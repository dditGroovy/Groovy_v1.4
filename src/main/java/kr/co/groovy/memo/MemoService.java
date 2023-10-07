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
		MemoVO memoVO = memoMapper.getOneMemo(memoSn);
		
		if (memoVO.getMemoSj() == null) {
			memoVO.setMemoSj("제목 없음");
    	}
		return memoVO;
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

	public int updateMemoAlarm(int memoSn, String memoEmplId) {
		return memoMapper.updateMemoAlarm(memoSn, memoEmplId);
	}

	public MemoVO getFixMemo(String memoEmplId) {
		MemoVO memoVO = memoMapper.getFixMemo(memoEmplId);

		if (memoVO == null) {
			memoVO = new MemoVO();
			memoVO.setMemoSj(null);
			memoVO.setMemoCn(null);
			memoVO.setMemoWrtngDate(null);
		} else if (memoVO.getMemoSj() == null) {
			memoVO.setMemoSj("제목 없음");
		}

		return memoVO;
	}
	
	
	public int noFix(int memoSn) {
		return memoMapper.noFix(memoSn);
	}
	
}
