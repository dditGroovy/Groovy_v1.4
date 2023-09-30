package kr.co.groovy.cloud;

import kr.co.groovy.employee.EmployeeService;
import lombok.extern.slf4j.Slf4j;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.multipart.MultipartFile;

import java.io.IOException;
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
    public String cloudMain(Principal principal, Model model, String path) {
        System.out.println("path = " + path);
        String deptFolderName = null;
        if (path == null) {
            String emplId = principal.getName();
            deptFolderName = employeeService.loadEmp(emplId).getCommonCodeDept();
        } else {
            deptFolderName = path.substring(0, path.length() - 1);
        }
        Map<String, Object> map = s3Utils.getAllInfos(deptFolderName);
        Map<String, Object> extensionList = s3Utils.extensionToIcon();
        model.addAttribute("folderPath", deptFolderName);
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

    @ResponseBody
    @DeleteMapping("/deleteFolder")
    public void deleteFolder(String path) {
        s3Utils.deleteFolder(path);
    }

    @ResponseBody
    @PostMapping("/uploadFile")
    public void uploadFile(@RequestParam("file") MultipartFile file, String path, Principal principal) throws IOException {
        System.out.println("file = " + file);
        s3Utils.uploadFile(file, path, principal.getName());
    }
}
