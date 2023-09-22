package kr.co.groovy.diet;


import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.naming.spi.DirStateFactory.Result;

import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.multipart.MultipartFile;
import org.springframework.web.multipart.MultipartHttpServletRequest;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;


@Controller
@RequestMapping("/diet")
public class DietController {
	final DietService dietService;
	final String uploadSuin;
	
	public DietController(DietService dietService, String uploadSuin) {
		this.dietService = dietService;
		this.uploadSuin = uploadSuin;
	}

	
	@GetMapping("/dietMain")
	public String dietMain() {
		return "admin/gat/diet/diet";
	}
	
	
	@GetMapping("/dietData")
	public ResponseEntity<List<Map<String, Object>>> getDiet() {
		List<Map<String, Object>> result = dietService.getDiet();
		return new ResponseEntity<>(result, HttpStatus.OK);
	}
	
	
	@PostMapping("/dietMain")
	public String insertDiet(MultipartHttpServletRequest multipartHttpServletRequest, 
							 RedirectAttributes redirectAttributes) {
		Map<String, Object> map;
		
		try {
            ExcelRequest excelRequest = new ExcelRequest(uploadSuin);
            final Map<String, MultipartFile> files = multipartHttpServletRequest.getFileMap();
            List<HashMap<String, String>> apply = excelRequest.parseExcelMultiPart(files, "diet", 0, "", "");

            map = dietService.insertDiet(apply);
            
            map.put("res", "ok");
    		map.put("msg", "파일 업로드 성공");
            
        } catch (Exception e) {
            System.out.println(e.toString());
            map = new HashMap<>();
            map.put("res", "error");
            map.put("msg", "파일 업로드 실패");
        }

        redirectAttributes.addFlashAttribute("map", map);
        return "redirect:dietMain";
    }
}
