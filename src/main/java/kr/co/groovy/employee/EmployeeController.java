package kr.co.groovy.employee;

import kr.co.groovy.security.CustomUser;
import kr.co.groovy.vo.EmployeeVO;
import kr.co.groovy.vo.NotificationVO;
import kr.co.groovy.vo.PageVO;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.security.core.Authentication;
import org.springframework.security.crypto.bcrypt.BCryptPasswordEncoder;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.multipart.MultipartFile;
import org.springframework.web.servlet.ModelAndView;

import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.UUID;

@RequestMapping("/employee")
@Controller
public class EmployeeController {
    private static final Logger log = LoggerFactory.getLogger(EmployeeController.class);
    final EmployeeService service;
    final
    BCryptPasswordEncoder encoder;

    public EmployeeController(EmployeeService service, BCryptPasswordEncoder encoder) {
        this.service = service;
        this.encoder = encoder;
    }


    /* 사원 로그인 */
    @GetMapping("/signIn")
    public String singInForm(Authentication auth) {
        return auth != null ? "main/home" : "signIn";
    }

    @GetMapping("/signInFail")
    public ModelAndView signInFail(ModelAndView mav, String exception) {
        mav.addObject("message", exception);
        mav.setViewName("signIn");
        return mav;
    }

    @GetMapping("/findPassword")
    public String findPasswordForm() {
        return "findPassword";
    }

    @PostMapping("/findTelNo")
    @ResponseBody
    public String findTelNoByEmplId(@RequestBody String emplId) {
        return service.findTelNoByEmplId(emplId.substring(emplId.indexOf('=') + 1));
    }

    @PostMapping("/findPassword")
    @ResponseBody
    public String findPassword(@RequestBody String emplId) {
        emplId = emplId.substring(emplId.indexOf('=') + 1);
        String findTelNoResponse = service.findTelNoByEmplId(emplId);
        if (findTelNoResponse.equals("exists")) {
            // 문자보내기
            EmployeeVO employeeVO = service.loadEmp(emplId);
            String password = UUID.randomUUID().toString().substring(0, 8);
            String[] splitTelNo = employeeVO.getEmplTelno().split("-");
            String emplTelno = splitTelNo[0] + splitTelNo[1] + splitTelNo[2];
            service.sendMessage(emplTelno, password);
            service.modifyPassword(emplId, password);
            return "success";
        }
        return "fail";
    }

    /* 사원 - 비밀번호 수정*/
    @GetMapping("/initPassword")
    public String initPasswordForm() {
        return "initPassword";
    }

    @PostMapping("/initPassword")
    public String initPassword(@RequestParam("emplId") String emplId, @RequestParam("emplPassword") String emplPassword) {
        this.service.initPassword(emplId, emplPassword);
        return "main/home";
    }

    @GetMapping("/myInfo")
    public String myInfo() {
        return "employee/myInfo";
    }

    @GetMapping("/confirm")
    public String confirmPassword() {
        return "employee/confirmPassword";
    }

    @PostMapping("/modifyProfile")
    @ResponseBody
    public String modifyProfile(String emplId, @RequestPart(value = "profileFile") MultipartFile profileFile) {
        return service.modifyProfile(emplId, profileFile);
    }


    @PostMapping("/modifySign")
    @ResponseBody
    public String modifySign(String emplId, MultipartFile signPhotoFile) {
        return service.modifySign(emplId, signPhotoFile);
    }

    @PostMapping("/modifyNoticeAt/{emplId}")
    @ResponseBody
    public void modifyNoticeAt(@RequestBody NotificationVO notificationVO, @PathVariable("emplId") String emplId) {
        service.modifyNoticeAt(notificationVO, emplId);
    }

    /* 관리자 - 사원 관리 */
    @GetMapping("/manageEmp")
    public String manageEmp(PageVO pageVO, Model model) {
        model.addAttribute("pageVO", pageVO);
        return "admin/hrt/employee/manage";
    }

    @ResponseBody
    @GetMapping("/countEmp")
    public String countEmp() {
        int result = this.service.countEmp();
        return Integer.toString(this.service.countEmp());
    }

    @PostMapping("/inputEmp")
    public String inputEmp(EmployeeVO vo) {
        this.service.inputEmp(vo);
        return "redirect:/employee/manageEmp";
    }

    @ResponseBody
    @GetMapping("/loadEmpList")
    public Map<String, Object> loadEmpList(PageVO pageVO) {
        Map map = new HashMap();
        List<EmployeeVO> empList = service.pageEmpList(pageVO);
        map.put("pageVO", pageVO);
        map.put("empList", empList);
        return map;
    }

    @ResponseBody
    @GetMapping("/findEmp")
    public Map<String, Object> findEmp(String depCode, String emplNm, String sortBy, long page) {
        Map<String, Object> map = service.findEmp(depCode, emplNm, sortBy, page);
        return map;
    }

    @GetMapping("/loadEmp/{emplId}")
    public ModelAndView loadEmp(ModelAndView mav, @PathVariable String emplId) {
        EmployeeVO vo = this.service.loadEmp(emplId);
        mav.addObject("empVO", vo);
        mav.setViewName("admin/hrt/employee/detail");
        return mav;
    }

    @PostMapping("/modifyEmp")
    @ResponseBody
    public void modifyEmp(EmployeeVO vo) {
        service.modifyEmp(vo);
    }
    @PostMapping("/modifyInfo")
    @ResponseBody
    public void modifyInfo(EmployeeVO vo) {
        service.modifyInfo(vo);
    }

    @PostMapping("/modifyPassword")
    @ResponseBody
    public String modifyPassword(@RequestParam("currentPassword") String currentPassword,
                                 @RequestParam("newPassword") String newPassword, Authentication authentication) {
        CustomUser customUser = (CustomUser) authentication.getPrincipal();
        EmployeeVO vo = customUser.getEmployeeVO();

        if (encoder.matches(currentPassword, vo.getEmplPassword())) {
            vo.setEmplPassword(encoder.encode(newPassword));
            service.modifyPassword(vo.getEmplId(), newPassword);
            return "correct";
        }
        return "incorrect";
    }


    @GetMapping("/commute")
    public String jobMain() {
        return "employee/commute";
    }

    /* 다시 매핑~ */

    @ResponseBody
    @GetMapping("/loadBirthday")
    public List<EmployeeVO> loadBirthday() {
        return service.loadBirthday();
    }

    @GetMapping("/videoConferencing")
    public String videoConferencing() {
        return "videoConferencing";
    }

    @GetMapping("/confirm/{page}")
    public String getConfirmPassword(@PathVariable String page, Model model) {
        model.addAttribute("page", page);
        return "employee/confirmPassword";

    }

    @PostMapping("/confirm/{currentPage}")
    @ResponseBody
    public String confirmPassword(Authentication auth, @RequestBody Map<String, String> map, @PathVariable String currentPage) {
        String password = map.get("password");
        log.info(password);
        CustomUser user = (CustomUser) auth.getPrincipal();
        String emplPassword = user.getEmployeeVO().getEmplPassword();
        if (encoder.matches(password, emplPassword)) {
            return "correct";
        } else {
            return "incorrect";
        }
    }
}

