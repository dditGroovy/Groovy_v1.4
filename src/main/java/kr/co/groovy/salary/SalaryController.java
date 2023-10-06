package kr.co.groovy.salary;

import kr.co.groovy.vo.*;
import lombok.extern.slf4j.Slf4j;
import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.*;

import java.security.Principal;
import java.time.LocalDate;
import java.util.Comparator;
import java.util.List;
import java.util.Map;

@Slf4j
@Controller
@RequestMapping("/salary")
public class SalaryController {
    final
    SalaryService salaryService;
    final
    PasswordEncoder encoder;

    public SalaryController(SalaryService salaryService, PasswordEncoder encoder) {
        this.salaryService = salaryService;
        this.encoder = encoder;
    }

    // 인사팀의 사원 연봉, 수당 및 세율 관리
    @GetMapping("")
    public String loadSalary(Model model) {
        List<AnnualSalaryVO> salaryList = salaryService.loadSalary(); // 올해 기본급
        List<AnnualSalaryVO> bonusList = salaryService.loadBonus(); // 올해 직책수당
        List<TariffVO> tariffVOList = salaryService.loadTariff(""); // 올해 세율
        model.addAttribute("salary", salaryList);
        model.addAttribute("bonus", bonusList);
        model.addAttribute("tariffList", tariffVOList);
        return "admin/at/salary/salary";
    }

    // 인사팀의 세율 기준 수정
    @PostMapping("/modify/taxes")
    @ResponseBody
    public void modifyIncmtax(String code, double value) {
        salaryService.modifyIncmtax(code, value);
    }

    @PostMapping("/modify/salary")
    @ResponseBody
    public void modifySalary(String code, int value) {
        salaryService.modifySalary(code, value);
    }

    @GetMapping("/taxes/{year}")
    @ResponseBody
    public List<TariffVO> loadTaxes(@PathVariable String year) {
        return salaryService.loadTariff(year);
    }


    @GetMapping("/paystub")
    public String loadPaystub(Principal principal, Model model) {
        String emplId = principal.getName();
        PaystubVO recentPaystub = salaryService.loadRecentPaystub(emplId);
        List<Integer> years = salaryService.loadYearsForSortPaystub(emplId);
        model.addAttribute("paystub", recentPaystub);
        model.addAttribute("years", years);
        return "employee/mySalary";
    }

    @GetMapping("/dstmtForm")
    public String goDstmtForm() {
        return "admin/at/salary/specification";
    }

    @GetMapping("/paystub/{year}")
    @ResponseBody
    public List<PaystubVO> loadPaystubList(Principal principal, @PathVariable String year) {
        String emplId = principal.getName();
        return salaryService.loadPaystubList(emplId, year);
    }

    @GetMapping("/paystub/detail/{paymentDate}")
    public String paystubDetail(Principal principal, @PathVariable String paymentDate, Model model) {
        String emplId = principal.getName();
        PaystubVO paystubDetail = salaryService.loadPaystubDetail(emplId, paymentDate);
        List<Integer> years = salaryService.loadYearsForSortPaystub(emplId);
        model.addAttribute("paystub", paystubDetail);
        model.addAttribute("years", years);
        return "employee/mySalary";
    }

    @PostMapping("/paystub/saveCheckboxState")
    @ResponseBody
    public void saveCheckboxState(@RequestParam("isChecked") boolean isChecked) {
        salaryService.saveCheckboxState(isChecked);
    }

    /* 급여정산 */
    @GetMapping("/calculate")
    public String calculatePage(Model model) {
        LocalDate localDate = LocalDate.now();
        List<CommuteAndPaystub> cnpList = salaryService.getCommuteAndPaystubList(String.valueOf(localDate.getYear()), String.valueOf(localDate.getMonthValue() - 1));
        model.addAttribute("cnpList", cnpList);
        return "admin/at/salary/salaryCalculate";
    }

    @GetMapping("/selectedDate")
    @ResponseBody
    public List<CommuteAndPaystub> getCommuteAndPaystubByYearAndMonth(@RequestParam("year") String year, @RequestParam("month") String month) {
        return salaryService.getCommuteAndPaystubList(year, month);
    }

    /* 급여명세서 - 회원 가져오기 */
    @GetMapping("/list")
    public String loadEmpList(Model model) {
        List<EmployeeVO> list = salaryService.loadEmpList();
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

    /* 급여명세서 - 특정 연도 가져오기 */
    @GetMapping("/years")
    @ResponseBody
    public List<String> getExistYears() {
        return salaryService.getExistsYears();
    }

    /* 급여명세서 - 특정 월 가져오기 */
    @GetMapping("/months")
    @ResponseBody
    public List<String> getExistsMonthPerYears(@RequestParam("year") String year) {
        return salaryService.getExistsMonthPerYears(year);
    }

    /* 특정 연도의 급여명세서 리스트 가져오기 */
    @GetMapping("/payment/list/{emplId}/{year}")
    @ResponseBody
    public List<PaystubVO> loadPaymentList(@PathVariable String emplId, @PathVariable String year) {
        List<PaystubVO> paystubVOS = salaryService.loadPaymentList(emplId, year);
        return paystubVOS;
    }

    @PostMapping("/uploadFile")
    @ResponseBody
    public String inputSalaryDtsmtPdf(@RequestBody Map<String, String> map) {
        String result = salaryService.inputSalaryDtsmtPdf(map);
        if (result.equals("success")) {
            return "success";
        }
        return "fail";
    }

    @PostMapping("/email")
    @ResponseBody
    public String sentEmail(Principal principal, @RequestParam Map<String, String> map) throws Exception {
        return salaryService.sentEmails(principal, map.get("data"), map.get("date"));
    }



}
