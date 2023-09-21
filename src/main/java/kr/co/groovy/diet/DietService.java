package kr.co.groovy.diet;

import java.text.SimpleDateFormat;
import java.util.Date;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.springframework.stereotype.Service;

import kr.co.groovy.vo.DietVO;

@Service
public class DietService {

	final
	DietMapper dietMapper;
	
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
            map.put("msg", "파일 업로드 성공");
        } catch (Exception e) {
            map.put("res", "error");
            map.put("msg", "파일 업로드 실패");
        }

        return map;
    }
}
