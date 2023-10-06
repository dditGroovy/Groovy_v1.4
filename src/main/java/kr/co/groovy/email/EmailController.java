package kr.co.groovy.email;

import kr.co.groovy.employee.EmployeeService;
import kr.co.groovy.vo.EmailVO;
import kr.co.groovy.vo.EmployeeVO;
import kr.co.groovy.vo.PageVO;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.security.core.parameters.P;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.multipart.MultipartFile;

import javax.mail.AuthenticationFailedException;
import javax.servlet.http.Cookie;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.security.Principal;
import java.util.ArrayList;
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
    private String password;

    @GetMapping("/all")
    public String getMails(Principal principal, EmailVO emailVO, Model model, PageVO pageVO) throws Exception {
        try {
            EmployeeVO employeeVO = employeeService.loadEmp(principal.getName());
            List<EmailVO> list = emailService.inputReceivedEmails(principal, emailVO, this.password);
            pageVO.setRow();
            pageVO.setNum((long) list.size());

            int startIdx = Math.toIntExact(pageVO.getStartRow());
            int endIdx = Math.min(Math.toIntExact(pageVO.getLastRow()), list.size());

            if (startIdx <= endIdx) {
                model.addAttribute("list", list.subList(startIdx, endIdx));
            } else {
                model.addAttribute("list", new ArrayList<>());
            }

            int unreadMailCount = emailService.getUnreadMailCount(principal.getName());
            long allMailCount = emailService.getAllMailCount(employeeVO.getEmplId());
            model.addAttribute("unreadMailCount", unreadMailCount);
            model.addAttribute("allMailCount", allMailCount);
            return "email/allList";
        } catch (AuthenticationFailedException e) {
            e.printStackTrace();
            return "redirect:/signOut";
        }
    }

    @PostMapping("/all")
    public String getAllMailsGet(HttpServletRequest request, HttpServletResponse response, Principal principal, EmailVO emailVO, Model model, @RequestParam String password, PageVO pageVO) throws Exception {
        this.password = password;

        Cookie[] cookies = request.getCookies();
        boolean emailCookieExists = false;

        if (cookies != null) {
            for (Cookie cookie : cookies) {
                if (cookie.getName().equals("email")) {
                    emailCookieExists = true;
                    break;
                }
            }
        }

        if (!emailCookieExists) {
            Cookie emailCookie = new Cookie("email", "groovy-email");
            emailCookie.setPath("/");
            response.addCookie(emailCookie);
        }

        return "redirect:/email/all";
    }

    @GetMapping("/inbox")
    public String getReceivedMails(Principal principal, Model model, PageVO pageVO) throws Exception {
        EmployeeVO employeeVO = employeeService.loadEmp(principal.getName());
        List<EmailVO> list = emailService.getAllReceivedMailList(employeeVO, pageVO);
        for (EmailVO emailVO : list) {
            emailVO.setEmailFromAddr(emailService.getEmplNmByEmplEmail(emailVO));
        }
        model.addAttribute("list", list);

        int unreadMailCount = emailService.getUnreadMailCount(principal.getName());
        long allMailCount = emailService.getAllMailCount(employeeVO.getEmplId());
        model.addAttribute("unreadMailCount", unreadMailCount);
        model.addAttribute("allMailCount", allMailCount);
        return "email/inboxList";
    }

    @GetMapping("/sent")
    public String getAllSentMailsByMe(Principal principal, Model model, PageVO pageVO) {
        EmployeeVO employeeVO = employeeService.loadEmp(principal.getName());
        List<EmailVO> list = emailService.getAllSentMailsByMe(employeeVO, pageVO);
        for (EmailVO emailVO : list) {
            emailVO.setEmailFromAddr(emailService.getEmplNmByEmplEmail(emailVO));
        }
        model.addAttribute("list", list);

        int unreadMailCount = emailService.getUnreadMailCount(principal.getName());
        long allMailCount = emailService.getAllMailCount(employeeVO.getEmplId());
        model.addAttribute("unreadMailCount", unreadMailCount);
        model.addAttribute("allMailCount", allMailCount);
        return "email/sentList";
    }

    @GetMapping("/mine")
    public String getAllSentMailsToMe(Principal principal, Model model, PageVO pageVO) {
        EmployeeVO employeeVO = employeeService.loadEmp(principal.getName());
        List<EmailVO> list = emailService.getSentMailsToMe(employeeVO, pageVO);
        for (EmailVO emailVO : list) {
            emailVO.setEmailFromAddr(emailService.getEmplNmByEmplEmail(emailVO));
        }
        model.addAttribute("list", list);

        int unreadMailCount = emailService.getUnreadMailCount(principal.getName());
        long allMailCount = emailService.getAllMailCount(employeeVO.getEmplId());
        model.addAttribute("unreadMailCount", unreadMailCount);
        model.addAttribute("allMailCount", allMailCount);
        return "email/mineList";
    }

    @GetMapping("/trash")
    public String getAllDeletedMails(Principal principal, EmailVO emailVO, Model model, PageVO pageVO) {
        EmployeeVO employeeVO = employeeService.loadEmp(principal.getName());
        List<EmailVO> list = emailService.setAllEmailList(employeeVO.getEmplEmail(), "Y");
        for (EmailVO mail : list) {
            mail.setEmailFromAddr(emailService.getEmplNmByEmplEmail(mail));
        }

        pageVO.setRow();
        pageVO.setNum((long) list.size());

        int startIdx = Math.toIntExact(pageVO.getStartRow());
        int endIdx = Math.min(Math.toIntExact(pageVO.getLastRow()), list.size());

        if (startIdx <= endIdx) {
            model.addAttribute("list", list.subList(startIdx, endIdx));
        } else {
            model.addAttribute("list", new ArrayList<>());
        }

        int unreadMailCount = emailService.getUnreadMailCount(principal.getName());
        long allMailCount = emailService.getAllMailCount(employeeVO.getEmplId());
        model.addAttribute("unreadMailCount", unreadMailCount);
        model.addAttribute("allMailCount", allMailCount);
        return "email/trashList";
    }

    @PutMapping("/{code}/{emailEtprCode}")
    @ResponseBody
    public String modifyEmailRedngAt(@PathVariable String code, @PathVariable String emailEtprCode, @RequestBody String at) {
        Map<String, String> result = emailService.getEmailAtMap(code, emailEtprCode, at);
        return result.get("at");
    }

    @PutMapping("/permanent/{emailEtprCode}")
    @ResponseBody
    public int deleteMail(@PathVariable String emailEtprCode) {
        return emailService.deleteMails(emailEtprCode);
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

    @GetMapping("/read/{emailEtprCode}")
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
        long allMailCount = emailService.getAllMailCount(employeeVO.getEmplId());

        model.addAttribute("unreadMailCount", unreadMailCount);
        model.addAttribute("allMailCount", allMailCount);
        model.addAttribute("emailVO", emailVO);
        model.addAttribute("toList", toList);
        model.addAttribute("ccList", ccList);
        return "email/read";
    }
}
