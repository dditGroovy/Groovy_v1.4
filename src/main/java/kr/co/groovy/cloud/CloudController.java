package kr.co.groovy.cloud;

import kr.co.groovy.employee.EmployeeService;
import lombok.extern.slf4j.Slf4j;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;

import java.security.Principal;
import java.util.Map;

@Slf4j
@Controller
@RequestMapping("/cloud")
public class CloudController {

    final EmployeeService employeeService;
    final S3Utils s3Utils;

    public CloudController(EmployeeService employeeService, S3Utils s3Utils) {
        this.employeeService = employeeService;
        this.s3Utils = s3Utils;
    }

    @GetMapping("/main")
    public String cloudMain(Principal principal, Model model) {
        String emplId = principal.getName();
        String deptFolderName = employeeService.loadEmp(emplId).getCommonCodeDept();
        Map<String, Object> map = s3Utils.getAllInfos(deptFolderName);
        Map<String, Object> extensionList = s3Utils.extensionToIcon();
        System.out.println("**map = " + map);
        model.addAttribute("fileList", map.get("fileList"));
        model.addAttribute("folderList", map.get("folderList"));
        model.addAttribute("extensionList", extensionList);
        return "community/cloud";
    }

    @ResponseBody
    @GetMapping("/fileInfo")
    public Map<String, Object> fileInfo(String key) {
        Map<String, Object> fileInfo = s3Utils.getFileInfo(key);
        return fileInfo;
    }
}
