package kr.co.groovy.common;

import kr.co.groovy.employee.EmployeeService;
import kr.co.groovy.enums.ClassOfPosition;
import kr.co.groovy.enums.Department;
import kr.co.groovy.vo.*;
import lombok.extern.slf4j.Slf4j;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.multipart.MultipartFile;
import org.springframework.web.servlet.ModelAndView;

import javax.servlet.http.HttpServletResponse;
import java.io.File;
import java.io.FileInputStream;
import java.io.IOException;
import java.io.OutputStream;
import java.util.Arrays;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

@Slf4j
@RequestMapping("/common")
@Controller
public class CommonController {
    final
    CommonService service;
    final
    String uploadPath;

    public CommonController(CommonService service, EmployeeService employeeService, String uploadPath) {
        this.service = service;
        this.uploadPath = uploadPath;
    }

    @GetMapping("/orgChart")
    public ModelAndView loadOrgChart(ModelAndView mav, String depCode) {
        List<String> departmentCodes = Arrays.asList("DEPT010", "DEPT011", "DEPT012", "DEPT013", "DEPT014", "DEPT015");
        for (String deptCode : departmentCodes) {
            List<EmployeeVO> deptEmployees = service.loadOrgChart(deptCode);
            for (EmployeeVO vo : deptEmployees) {
                vo.setCommonCodeDept(Department.valueOf(vo.getCommonCodeDept()).label());
                vo.setCommonCodeClsf(ClassOfPosition.valueOf(vo.getCommonCodeClsf()).label());
            }
            mav.addObject(deptCode + "List", deptEmployees);
        }
        mav.setViewName("common/orgChart");
        return mav;
    }

    @GetMapping(value = "/{today}")
    @ResponseBody
    public DietVO loadMenu(@PathVariable String today) {
        return service.loadDiet(today);
    }

    @GetMapping("/home")
    public String comebackHome() {
        return "main/home" ;
    }

    @PostMapping("/uploadFile")
    public String uploadFile(MultipartFile defaultFile) {
        try {
            // 혹시 쓸 거면 경로 꼭 수정하기~
            String path = uploadPath + "/profile" ;
            File uploadDir = new File(path);
            if (!uploadDir.exists()) {
                if (uploadDir.mkdirs()) {
                    log.info("폴더 생성 성공");
                } else {
                    log.info("폴더 생성 실패");
                }
            }

            String originalFileName = defaultFile.getOriginalFilename();
            File saveFile = new File(path, originalFileName);
            defaultFile.transferTo(saveFile);

            log.info("사진 저장 성공");
            return "redirect:/home" ;
        } catch (Exception e) {
            log.info("사진 저장 실패");
            return null;
        }
    }

    @GetMapping("/notice")
    @ResponseBody
    public List<NoticeVO> loadNotice() {
        return service.loadNotice();
    }
    @GetMapping("/sanction/{emplId}")
    @ResponseBody
    List<SanctionVO> loadSanction(@PathVariable String emplId){
        return service.loadSanction(emplId);
    }

    @GetMapping("/line")
    public String line(){
        return "sanction/line/line";
    }
}

