package kr.co.groovy.salary;

import kr.co.groovy.enums.ClassOfPosition;
import kr.co.groovy.enums.Department;
import kr.co.groovy.security.CustomUser;
import kr.co.groovy.vo.*;
import lombok.extern.slf4j.Slf4j;
import org.springframework.security.core.Authentication;
import org.springframework.security.core.context.SecurityContextHolder;
import org.springframework.stereotype.Service;

import java.util.Comparator;
import java.util.List;

@Slf4j
@Service
public class SalaryService {
    final
    SalaryMapper mapper;

    public SalaryService(SalaryMapper mapper) {
        this.mapper = mapper;
    }

    List<AnnualSalaryVO> loadSalary() {
        List<AnnualSalaryVO> list = mapper.loadSalary();
        for (AnnualSalaryVO vo : list) {
            vo.setCommonCodeDeptCrsf(Department.valueOf(vo.getCommonCodeDeptCrsf()).label());
        }
        return list;
    }

    List<AnnualSalaryVO> loadBonus() {
        List<AnnualSalaryVO> list = mapper.loadBonus();
        for (AnnualSalaryVO vo : list) {
            vo.setCommonCodeDeptCrsf(ClassOfPosition.valueOf(vo.getCommonCodeDeptCrsf()).label());
        }
        return list;
    }

    List<TariffVO> loadTariff(String year) {
        return mapper.loadTariff(year);
    }

    List<EmployeeVO> loadEmpList() {
        List<EmployeeVO> list = mapper.loadEmpList();
        for (EmployeeVO vo : list) {
            vo.setCommonCodeDept(Department.valueOf(vo.getCommonCodeDept()).label());
            vo.setCommonCodeClsf(ClassOfPosition.valueOf(vo.getCommonCodeClsf()).label());
        }
        return list;
    }

    List<SalaryVO> loadPaymentList(String emplId, String year) {
        return mapper.loadPaymentList(emplId, year);
    }

    PaystubVO loadRecentPaystub(String emplId) {
        return mapper.loadRecentPaystub(emplId);
    }

    List<Integer> loadYearsForSortPaystub(String emplId) {
        return mapper.loadYearsForSortPaystub(emplId);
    }

    List<PaystubVO> loadPaystubList(String emplId, String year) {
        return mapper.loadPaystubList(emplId, year);
    }

    public void modifyIncmtax(String code, double value) {
        mapper.modifyIncmtax(code, value);
    }

    public void modifySalary(String code, int value) {
        mapper.modifySalary(code, value);
    }

    public PaystubVO loadPaystubDetail(String emplId, String paymentDate) {
        return mapper.loadPaystubDetail(emplId, paymentDate);
    }

    public void saveCheckboxState(boolean isChecked) {
        Authentication authentication = SecurityContextHolder.getContext().getAuthentication();
        CustomUser customUser = (CustomUser) authentication.getPrincipal();
        EmployeeVO employeeVO = customUser.getEmployeeVO();
        employeeVO.setHideAmount(isChecked);
    }

    public List<String> getExistsYears() {
        return mapper.getExistsYears();
    }

    public List<String> getExistsMonthPerYears(String year) {
        return mapper.getExistsMonthByYear(year);
    }

    public List<CommuteVO> getCommuteByYearAndMonth(int year, int month) {
        String date = year + "-" + month;
        List<CommuteVO> commute = mapper.getCommuteByYearAndMonth(date);
        for (CommuteVO commuteVO : commute) {
            commuteVO.setClsfNm(ClassOfPosition.valueOf(commuteVO.getCommonCodeClsf()).label());
            commuteVO.setDefaulWorkTime(String.valueOf(Integer.parseInt(mapper.getPrescribedWorkingHours(date)) / 60)); // 소정근로시간
            commuteVO.setRealWorkTime(String.valueOf(Integer.parseInt(commuteVO.getRealWorkTime()) / 60)); // 실제근무
            commuteVO.setOverWorkTime(String.valueOf(Integer.parseInt(commuteVO.getOverWorkTime()) / 60)); // 초과근무
            commuteVO.setTotalWorkTime(String.valueOf(Integer.parseInt(commuteVO.getRealWorkTime()) + Integer.parseInt(commuteVO.getOverWorkTime()))); // 총합
        }
        return commute;
    }

    public List<PaystubVO> getSalaryBslry(int year, int month) {
        String date = year + "-" + month;
        List<CommuteVO> commute = mapper.getCommuteByYearAndMonth(date);
        List<PaystubVO> salaryBslry = mapper.getSalaryBslry(String.valueOf(year));
        for (CommuteVO commuteVO : commute) {
            for (PaystubVO paystubVO : salaryBslry) {
                if (paystubVO.getSalaryEmplId().equals(commuteVO.getDclzEmplId())) {
                    paystubVO.setSalaryEmplId(commuteVO.getDclzEmplId());
                    paystubVO.setSalaryOvtimeAllwnc((double) paystubVO.getSalaryBslry() / 30 / 8 * 1.5 * Integer.parseInt(commuteVO.getOverWorkTime()));
                }
            }
        }
        return salaryBslry;
    }
}
