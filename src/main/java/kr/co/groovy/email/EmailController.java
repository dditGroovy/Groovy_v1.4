package kr.co.groovy.email;

import kr.co.groovy.employee.EmployeeService;
import kr.co.groovy.vo.EmailVO;
import kr.co.groovy.vo.EmployeeVO;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.multipart.MultipartFile;

import java.security.Principal;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

@Slf4j
@Controller
@RequestMapping("/email")
@RequiredArgsConstructor
public class EmailController {
    private final EmailService emailService;
    private final EmployeeService employeeService;

    @PostMapping("/all")
    public String getAllMailsGet(Principal principal, EmailVO emailVO, Model model, @RequestParam String password) throws Exception {
        List<EmailVO> list = emailService.inputReceivedEmails(principal, emailVO, password);
        model.addAttribute("list", list);
        return "email/allList";
    }

    @GetMapping("/inbox")
    public String getReceivedMails(Principal principal, EmailVO emailVO, Model model) throws Exception {
        EmployeeVO employeeVO = employeeService.loadEmp(principal.getName());
        List<EmailVO> allReceivedMailList = emailService.getAllReceivedMailList(employeeVO);
        for (EmailVO mail : allReceivedMailList) {
            mail.setEmailFromAddr(emailService.getEmplNmByEmplEmail(mail));
        }
        model.addAttribute("list", allReceivedMailList);
        return "email/inboxList";
    }

    @GetMapping("/sent")
    public String getAllSentMailsByMe(Principal principal, EmailVO emailVO, Model model) {
        EmployeeVO employeeVO = employeeService.loadEmp(principal.getName());
        List<EmailVO> allSentMailsByMe = emailService.getAllSentMailsByMe(employeeVO);
        for (EmailVO mail : allSentMailsByMe) {
            mail.setEmailFromAddr(emailService.getEmplNmByEmplEmail(mail));
        }
        model.addAttribute("list", allSentMailsByMe);
        return "email/sentList";
    }

    @GetMapping("/mine")
    public String getAllSentMailsToMe(Principal principal, EmailVO emailVO, Model model) {
        EmployeeVO employeeVO = employeeService.loadEmp(principal.getName());
        List<EmailVO> allSentMailsToMe = emailService.getSentMailsToMe(employeeVO);
        for (EmailVO mail : allSentMailsToMe) {
            mail.setEmailFromAddr(emailService.getEmplNmByEmplEmail(mail));
        }
        model.addAttribute("list", allSentMailsToMe);
        return "email/mineList";
    }

    @GetMapping("/trash")
    public String getAllDeletedMails(Principal principal, EmailVO emailVO, Model model) {
        EmployeeVO employeeVO = employeeService.loadEmp(principal.getName());
        List<EmailVO> list = emailService.setAllEmailList(employeeVO.getEmplEmail(), "Y");
        for (EmailVO mail : list) {
            mail.setEmailFromAddr(emailService.getEmplNmByEmplEmail(mail));
        }
        model.addAttribute("list", list);
        return "email/trashList";
    }

    @PutMapping("/{code}/{emailEtprCode}")
    @ResponseBody
    public String modifyEmailRedngAt(@PathVariable String code, @PathVariable String emailEtprCode, @RequestBody String at) {
        Map<String, String> map = emailService.getEmailAtMap(code, emailEtprCode, at);
        return map.get("at");
    }

    @PutMapping("/{emailEtprCode}")
    @ResponseBody
    public String deleteMail(@PathVariable String emailEtprCode) {
        emailService.deleteMails(emailEtprCode);
        return "success";
    }

    @GetMapping("/send")
    public String loadWritePage() {
        return "email/sendMail";
    }

    @PostMapping("/send")
    @ResponseBody
    public String inputSentEmail(Principal principal, EmailVO emailVO, MultipartFile[] emailFiles) {
        EmployeeVO employeeVO = employeeService.loadEmp(principal.getName());
        return emailService.sentMail(emailVO, emailFiles, employeeVO);
    }

    @GetMapping("/unreadCount")
    @ResponseBody
    public String getUnreadMailCount(Principal principal, Model model) {
        return String.valueOf(emailService.getUnreadMailCount(principal.getName()));
    }

    @GetMapping("/sendMine")
    public String loadWriteMinePage() {
        return "email/sendMine";
    }

    @GetMapping("/{emailEtprCode}")
    public String getEmail(@PathVariable String emailEtprCode, Model model, Principal principal) {
        EmployeeVO employeeVO = employeeService.loadEmp(principal.getName());

        Map<String, String> map = new HashMap<>();
        map.put("emailAtKind", "EMAIL_REDNG_AT");
        map.put("at", "Y");
        map.put("emailEtprCode", emailEtprCode);
        emailService.modifyEmailRedngAt(map);

        EmailVO emailVO = emailService.getEmail(emailEtprCode, employeeVO.getEmplEmail());
        List<EmailVO> toList = emailService.getToPerEmail(emailEtprCode, emailVO.getEmailToAddr());
        List<EmailVO> ccList = emailService.getCcPerEmail(emailEtprCode, emailVO.getEmailCcAddr());
        int unreadMailCount = emailService.getUnreadMailCount(principal.getName());
        int allMailCount = emailService.getAllMailCount(employeeVO.getEmplEmail());

        model.addAttribute("unreadMailCount", unreadMailCount);
        model.addAttribute("allMailCount", allMailCount);
        model.addAttribute("emailVO", emailVO);
        model.addAttribute("toList", toList);
        model.addAttribute("ccList", ccList);
        return "email/read";
    }
}
