package kr.co.groovy.salary;

import kr.co.groovy.security.CustomUser;
import kr.co.groovy.vo.*;
import lombok.extern.slf4j.Slf4j;
import org.springframework.security.core.Authentication;
import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.*;

import java.security.Principal;
import java.time.LocalDate;
import java.util.*;

@Slf4j
@Controller
@RequestMapping("/salary")
public class SalaryController {
    final
    SalaryService service;
    final
    PasswordEncoder encoder;

    public SalaryController(SalaryService service, PasswordEncoder encoder) {
        this.service = service;
        this.encoder = encoder;
    }

    // 인사팀의 사원 연봉, 수당 및 세율 관리
    @GetMapping("")
    public String loadSalary(Model model) {
        List<AnnualSalaryVO> salaryList = service.loadSalary(); // 올해 기본급
        List<AnnualSalaryVO> bonusList = service.loadBonus(); // 올해 직책수당
        List<TariffVO> tariffVOList = service.loadTariff(""); // 올해 세율
        model.addAttribute("salary", salaryList);
        model.addAttribute("bonus", bonusList);
        model.addAttribute("tariffList", tariffVOList);
        return "admin/at/salary/salary";
    }

    // 인사팀의 세율 기준 수정
    @PostMapping("/modify/taxes")
    @ResponseBody
    public void modifyIncmtax(String code, double value) {
        service.modifyIncmtax(code, value);
    }

    @PostMapping("/modify/salary")
    @ResponseBody
    public void modifySalary(String code, int value) {
        service.modifySalary(code, value);
    }


    // 회계팀의 급여 상세
    @GetMapping("/list")
    public String loadEmpList(Model model) {
        List<EmployeeVO> list = service.loadEmpList();
        list.sort(new Comparator<EmployeeVO>() {
            @Override
            public int compare(EmployeeVO o1, EmployeeVO o2) {
                String emplId1 = o1.getEmplId();
                String emplId2 = o2.getEmplId();
                return emplId1.compareTo(emplId2);
            }
        });
        model.addAttribute("empList", list);
        return "admin/at/salary/detail";
    }

    @GetMapping("/taxes/{year}")
    @ResponseBody
    public List<TariffVO> loadTaxes(@PathVariable String year) {
        return service.loadTariff(year);
    }

    @GetMapping("/payment/list/{emplId}/{year}")
    @ResponseBody
    public List<PaystubVO> loadPaymentList(@PathVariable String emplId, @PathVariable String year) {
        List<PaystubVO> paystubVOS = service.loadPaymentList(emplId, year);
        return paystubVOS;
    }

    @GetMapping("/paystub")
    public String loadPaystub(Principal principal, Model model) {
        String emplId = principal.getName();
        PaystubVO recentPaystub = service.loadRecentPaystub(emplId);
        List<Integer> years = service.loadYearsForSortPaystub(emplId);
        model.addAttribute("paystub", recentPaystub);
        model.addAttribute("years", years);
        return "employee/mySalary";
    }

    @GetMapping("/dstmtForm")
    public String goDstmtForm() {
        return "admin/at/salary/specification";
    }

    @GetMapping("/paystub/checkPassword")
    public String checkPassword() {
        return "employee/checkPassword";
    }

    @PostMapping("/paystub/checkPassword")
    @ResponseBody
    public String checkPassword(Authentication auth, @RequestBody String password) {
        CustomUser user = (CustomUser) auth.getPrincipal();
        String emplPassword = user.getEmployeeVO().getEmplPassword();
        if (encoder.matches(password, emplPassword)) {
            return "success";
        } else {
            return "fail";
        }
    }

    @GetMapping("/paystub/{year}")
    @ResponseBody
    public List<PaystubVO> loadPaystubList(Principal principal, @PathVariable String year) {
        String emplId = principal.getName();
        return service.loadPaystubList(emplId, year);
    }

    @GetMapping("/paystub/detail/{paymentDate}")
    public String paystubDetail(Principal principal, @PathVariable String paymentDate, Model model) {
        String emplId = principal.getName();
        PaystubVO paystubDetail = service.loadPaystubDetail(emplId, paymentDate);
        List<Integer> years = service.loadYearsForSortPaystub(emplId);
        model.addAttribute("paystub", paystubDetail);
        model.addAttribute("years", years);
        return "employee/mySalary";
    }

    @PostMapping("/paystub/saveCheckboxState")
    @ResponseBody
    public void saveCheckboxState(@RequestParam("isChecked") boolean isChecked) {
        service.saveCheckboxState(isChecked);
    }


    @GetMapping("/calculate")
    public String calculatePage(Model model) {
        List<CommuteAndPaystub> cnpList = service.schedulingSalaryExactCalculation();
        model.addAttribute("cnpList", cnpList);
        return "admin/at/salary/salaryCalculate";
    }

    @GetMapping("/selectedDate")
    @ResponseBody
    public List<CommuteAndPaystub> getCommuteAndPaystubByYearAndMonth(@RequestParam("year") String year, @RequestParam("month") String month) {
        return service.getCommuteAndPaystubList(year, month);
    }

    @GetMapping("/years")
    @ResponseBody
    public List<String> getExistYears() {
        return service.getExistsYears();
    }

    @GetMapping("/months")
    @ResponseBody
    public List<String> getExistsMonthPerYears(@RequestParam("year") String year) {
        return service.getExistsMonthPerYears(year);
    }
}
