package kr.co.groovy.diet;

import java.text.SimpleDateFormat;

import java.util.ArrayList;
import java.util.Calendar;
import java.util.Date;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.springframework.stereotype.Service;

import kr.co.groovy.vo.DietVO;

@Service
public class DietService {

	final DietMapper dietMapper;

	public DietService(DietMapper dietMapper) {
		this.dietMapper = dietMapper;
	}

	public Map<String, Object> insertDiet(List<HashMap<String, String>> apply) {
		Map<String, Object> map = new HashMap<>();

		try {
			for (int i = 0; i < apply.size(); i++) {
				String dateString = apply.get(i).get("cell_0");
				SimpleDateFormat dateFormat = new SimpleDateFormat("yyyy-MM-dd");
				Date date = dateFormat.parse(dateString);

				DietVO dietVO = new DietVO();
				dietVO.setDietDate(date);
				dietVO.setDietRice(apply.get(i).get("cell_1"));
				dietVO.setDietSoup(apply.get(i).get("cell_2"));
				dietVO.setDietDish1(apply.get(i).get("cell_3"));
				dietVO.setDietDish2(apply.get(i).get("cell_4"));
				dietVO.setDietDish3(apply.get(i).get("cell_5"));
				dietVO.setDietDessert(apply.get(i).get("cell_6"));
				
				dietMapper.insertDiet(dietVO);
			}
			map.put("res", "ok");
			map.put("msg", "ok");
		} catch (Exception e) {
			map.put("res", "error");
			map.put("msg", "error");
		}

		return map;
	}

	public List<Map<String, Object>> getDiet() {
		List<DietVO> list = dietMapper.getDiet();
		List<Map<String, Object>> result = new ArrayList<>();
		
		for (DietVO dietVO : list) {
			Calendar calendar = Calendar.getInstance();
			
			HashMap<String, Object> dietMap = new HashMap<>();
			dietMap.put("start", dietVO.getDietDate());
	        dietMap.put("end", dietVO.getDietDate());
	        dietMap.put("title", dietVO.getDietRice() != null ? dietVO.getDietRice() : "");
	        result.add(dietMap);

	        dietMap = new HashMap<>();
			calendar.setTime(dietVO.getDietDate());
			calendar.add(Calendar.HOUR, 1);
	        dietMap.put("start", calendar.getTime());
	        dietMap.put("end", calendar.getTime());
	        dietMap.put("title", dietVO.getDietSoup() != null ? dietVO.getDietSoup() : "");
	        result.add(dietMap);

	        dietMap = new HashMap<>();
			calendar.setTime(dietVO.getDietDate());
			calendar.add(Calendar.HOUR, 2);
	        dietMap.put("start", calendar.getTime());
	        dietMap.put("end", calendar.getTime());
	        dietMap.put("title", dietVO.getDietDish1() != null ? dietVO.getDietDish1() : "");
	        result.add(dietMap);

	        dietMap = new HashMap<>();
	        calendar.setTime(dietVO.getDietDate());
			calendar.add(Calendar.HOUR, 3);
	        dietMap.put("start", calendar.getTime());
	        dietMap.put("end", calendar.getTime());
	        dietMap.put("title", dietVO.getDietDish2() != null ? dietVO.getDietDish2() : "");
	        result.add(dietMap);

	        dietMap = new HashMap<>();
	        calendar.setTime(dietVO.getDietDate());
			calendar.add(Calendar.HOUR, 4);
	        dietMap.put("start", calendar.getTime());
	        dietMap.put("end", calendar.getTime());
	        dietMap.put("title", dietVO.getDietDish3() != null ? dietVO.getDietDish3() : "");
	        result.add(dietMap);

	        dietMap = new HashMap<>();
	        calendar.setTime(dietVO.getDietDate());
			calendar.add(Calendar.HOUR, 5);
	        dietMap.put("start", calendar.getTime());
	        dietMap.put("end", calendar.getTime());
	        dietMap.put("title", dietVO.getDietDessert() != null ? dietVO.getDietDessert() : "");
	        result.add(dietMap);
	    
		}
	    return result;
	}
}
