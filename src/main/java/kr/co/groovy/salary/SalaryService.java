package kr.co.groovy.salary;

import kr.co.groovy.enums.ClassOfPosition;
import kr.co.groovy.enums.Department;
import kr.co.groovy.security.CustomUser;
import kr.co.groovy.utils.ParamMap;
import kr.co.groovy.vo.*;
import lombok.extern.slf4j.Slf4j;
import org.springframework.security.core.Authentication;
import org.springframework.security.core.context.SecurityContextHolder;
import org.springframework.stereotype.Service;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

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

    public PaystubVO loadPaystubDetail(String emplId, String paymentDate){
        return mapper.loadPaystubDetail(emplId, paymentDate);
    }

    public void saveCheckboxState(boolean isChecked) {
        Authentication authentication = SecurityContextHolder.getContext().getAuthentication();
        CustomUser customUser = (CustomUser) authentication.getPrincipal();
        EmployeeVO employeeVO = customUser.getEmployeeVO();
        employeeVO.setHideAmount(isChecked);
    }
}
