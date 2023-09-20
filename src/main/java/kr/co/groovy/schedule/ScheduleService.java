package kr.co.groovy.schedule;

import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.time.LocalDateTime;
import java.time.ZoneId;
import java.time.format.DateTimeFormatter;
import java.util.ArrayList;
import java.util.Date;
import java.util.HashMap;
import java.util.List;
import java.util.Locale;
import java.util.Map;

import org.springframework.stereotype.Service;

import kr.co.groovy.vo.ScheduleVO;

@Service
public class ScheduleService {
	final
	ScheduleMapper scheduleMapper;

	
	public ScheduleService(ScheduleMapper scheduleMapper) {
		this.scheduleMapper = scheduleMapper;
	}

	
    public List<Map<String, Object>> getSchedule() {
    	List<ScheduleVO> list = scheduleMapper.getSchedule();
    	
    	List<Map<String, Object>> result = new ArrayList<>();
    	
		for(ScheduleVO scheduleVO : list) {
			HashMap<String, Object> scheduleMap = new HashMap<>();	
			scheduleMap.put("id", scheduleVO.getSchdulSn());
			scheduleMap.put("title", scheduleVO.getSchdulNm());
			scheduleMap.put("start", scheduleVO.getSchdulBeginDate());
			scheduleMap.put("end", scheduleVO.getSchdulClosDate());
			result.add(scheduleMap);
		}
    	
    	return result;
    }
    
    
	public ScheduleVO getOneSchedule(int schdulSn) {
		return scheduleMapper.getOneSchedule(schdulSn);
	}
    
	
	public void inputSchedule(List<Map<String, Object>> list) throws ParseException {
		 DateTimeFormatter dateTimeFormatter = DateTimeFormatter.ofPattern("yyyy-MM-dd'T'HH:mm:ss.SSS'Z'", Locale.KOREA);

	     	for(Map<String, Object> map : list) {
	            String title = (String) map.get("title");
	            String start = (String) map.get("start");
	            String end = (String) map.get("end");
	            
	            LocalDateTime startDateUTC = LocalDateTime.parse(start, dateTimeFormatter);
	            LocalDateTime endDateUTC = LocalDateTime.parse(end, dateTimeFormatter);
	            
	            LocalDateTime startDate = startDateUTC.plusHours(9);
	            
	            ScheduleVO scheduleVO = new ScheduleVO();
	            scheduleVO.setSchdulNm(title);
	            Date startDateAsDate = Date.from(startDate.atZone(ZoneId.systemDefault()).toInstant());
	            scheduleVO.setSchdulBeginDate(startDateAsDate);
	            Date endDateAsDate = Date.from(endDateUTC.atZone(ZoneId.systemDefault()).toInstant());
	            scheduleVO.setSchdulClosDate(endDateAsDate);

	            scheduleMapper.inputSchedule(scheduleVO);
	     	}
	}
    
	
    public int modifySchedule(List<Map<String, Object>> list) throws ParseException {
    	int result = 0;
        for (Map<String, Object> map : list) {
            String id = (String) map.get("id");
            String title = (String) map.get("title");
            String start = (String) map.get("start");
            String end = (String) map.get("end");

            ScheduleVO scheduleVO = new ScheduleVO();

            Integer idInt = Integer.valueOf(id);
            scheduleVO.setSchdulSn(idInt);

            scheduleVO.setSchdulNm(title);

            SimpleDateFormat dateFormat = new SimpleDateFormat("yyyy-MM-dd");

            Date startdate = dateFormat.parse(start);
            Date enddate = dateFormat.parse(end);

            scheduleVO.setSchdulBeginDate(startdate);
            scheduleVO.setSchdulClosDate(enddate);

            result = scheduleMapper.modifySchedule(scheduleVO);
        }
        
        return result;
    }
    
    
    public int deleteSchedule(List<Map<String, Object>> list) {
    	int result = 0;
		
		for(Map<String, Object> map : list) {
			String id = (String) map.get("id");
			
			ScheduleVO scheduleVO = new ScheduleVO();
			
			Integer idInt = Integer.valueOf(id);
			scheduleVO.setSchdulSn(idInt);
			
			result = scheduleMapper.deleteSchedule(idInt);
		}
    	
    	return result;
    }
    
}
