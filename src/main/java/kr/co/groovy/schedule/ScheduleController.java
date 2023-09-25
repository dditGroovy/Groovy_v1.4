package kr.co.groovy.schedule;


import java.util.List;

import java.util.Map;

import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.DeleteMapping;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.PutMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;

import freemarker.core.ParseException;
import kr.co.groovy.vo.ScheduleVO;


@Controller
@RequestMapping("/schedule")
public class ScheduleController {
		final ScheduleService scheduleService;
	
		public ScheduleController(ScheduleService scheduleService) {
			this.scheduleService = scheduleService;
		}
		
		
		@GetMapping("/emplScheduleMain") 
		public String emplScheduleMain() {
			return "common/schedule";
		}
		
	
		@GetMapping("/scheduleMain")
		public String scheduleMain() {
			return "admin/hrt/schedule/schedule";
		}
	
		
		@GetMapping("/schedule")
		public ResponseEntity<List<Map<String, Object>>> getSchedule(){
			List<Map<String, Object>> result = scheduleService.getSchedule();
			return new ResponseEntity<>(result, HttpStatus.OK); 
		}
	
		
		@GetMapping("/schedule/{schdulSn}")
		public ResponseEntity<ScheduleVO> getOneSchedule(@PathVariable int schdulSn) {
			ScheduleVO scheduleVO = scheduleService.getOneSchedule(schdulSn);
	
			if(scheduleVO != null) {
				return new ResponseEntity<>(scheduleVO, HttpStatus.OK);
			}else{
				return new ResponseEntity<>(HttpStatus.NOT_FOUND);
			}
		}
	
		
		@PostMapping("/schedule")
		public String inputSchedule(@RequestBody List<Map<String, Object>> list) throws ParseException, Exception {
			scheduleService.inputSchedule(list);
			return "schedule/calendar";
		}
		
	
		@PutMapping("/schedule/{schdulSn}")
		@ResponseBody
		public String modifySchedule(@RequestBody List<Map<String, Object>> list, @PathVariable int schdulSn) throws ParseException, Exception {
			int result = scheduleService.modifySchedule(list);
	
			if(result == 1) {
				return "success";
			} else{
				return "fail";
			}
		}
		
		
		@DeleteMapping("/schedule")
		@ResponseBody
		public String deleteSchedule(@RequestBody List<Map<String, Object>> list) {
			int result = scheduleService.deleteSchedule(list);
			
			if(result == 1) {
				return "success";
			} else {
				return "fail";
			}
		}
	}