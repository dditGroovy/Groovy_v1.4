package kr.co.groovy;

import java.security.Principal;
import java.util.ArrayList;
import java.util.List;

import kr.co.groovy.job.JobService;
import kr.co.groovy.vo.JobVO;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
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
		return "main/home" ;
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
	public String toPdf(Model model){
	List<String> list = new ArrayList<String>();
	list.add("Java");
	list.add("파이썬");
	list.add("R");
	list.add("C++");
	list.add("자바스크립트");
	list.add("Ruby");
	list.add("스칼라");
	list.add("클로져");
	list.add("자바");

	//뷰에게 전달할 데이터 저장
	model.addAttribute("list",list);

	//출력할 뷰 이름 리턴
	return "pdf";
	}



}
