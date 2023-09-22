package kr.co.groovy.diet;

import java.util.List;

import kr.co.groovy.vo.DietVO;

public interface DietMapper {
	public int insertDiet(DietVO dietVO);
	
	public List<DietVO> getDiet();
}
