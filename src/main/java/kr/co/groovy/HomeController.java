package kr.co.groovy;

import kr.co.groovy.job.JobService;
import kr.co.groovy.vo.JobVO;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;

import java.security.Principal;
import java.text.DateFormat;
import java.util.Date;
import java.util.List;
import java.util.Locale;

@Controller
public class HomeController {
    private static final Logger logger = LoggerFactory.getLogger(HomeController.class);
    private final JobService jobService;

    public HomeController(JobService jobService) {
        this.jobService = jobService;
    }

    @RequestMapping(value = "/", method = RequestMethod.GET)
    public String home() {
        return "signIn";
    }

    @GetMapping("/home")
    public String comebackHome(Principal principal, Model model) {
        List<JobVO> jobVOList = jobService.getReceiveJobToHome(principal.getName());
        model.addAttribute("jobVoList", jobVOList);
        return "main/home";
    }


    @GetMapping("/mail")
    public String allMail() {
        return "mail/allMail";
    }

    @GetMapping("/mail/receiveMail")
    public String receiveMail() {
        return "mail/receiveMail";
    }

    @GetMapping("/mail/sendMail")
    public String sendMail() {
        return "mail/sendMail";
    }

    @GetMapping("/pdf")
    public String toPdf(Locale locale, Model model) {
        logger.info("Welcome home! The client locale is {}.", locale);

        Date date = new Date();
        DateFormat dateFormat = DateFormat.getDateTimeInstance(DateFormat.LONG, DateFormat.LONG, locale);

        String formattedDate = dateFormat.format(date);

        model.addAttribute("serverTime", formattedDate);
        return "sanction/template/pdf";
    }


}
