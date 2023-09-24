package kr.co.groovy.salary;

import kr.co.groovy.enums.ClassOfPosition;
import kr.co.groovy.enums.Department;
import kr.co.groovy.security.CustomUser;
import kr.co.groovy.vo.*;
import lombok.extern.slf4j.Slf4j;
import org.springframework.scheduling.annotation.EnableScheduling;
import org.springframework.scheduling.annotation.Scheduled;
import org.springframework.security.core.Authentication;
import org.springframework.security.core.context.SecurityContextHolder;
import org.springframework.stereotype.Service;

import java.time.LocalDate;
import java.util.*;

@Slf4j
@Service
@EnableScheduling
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
        List<TariffVO> tariffVOList = mapper.loadTariff(year);
        tariffVOList.sort(new Comparator<TariffVO>() {
            @Override
            public int compare(TariffVO o1, TariffVO o2) {
                return o1.getTaratStdrNm().compareTo(o2.getTaratStdrNm());
            }
        });
        return tariffVOList;
    }

    List<EmployeeVO> loadEmpList() {
        List<EmployeeVO> list = mapper.loadEmpList();
        for (EmployeeVO vo : list) {
            vo.setCommonCodeDept(Department.valueOf(vo.getCommonCodeDept()).label());
            vo.setCommonCodeClsf(ClassOfPosition.valueOf(vo.getCommonCodeClsf()).label());
        }
        return list;
    }

    List<PaystubVO> loadPaymentList(String emplId, String year) {
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
        log.info(paymentDate);
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


    public List<CommuteAndPaystub> getCommuteAndPaystubList(String year, String month) {
        String date = year + "-" + month;
        List<CommuteAndPaystub> cnpList = new ArrayList<>();
        List<CommuteVO> commute = mapper.getCommuteByYearAndMonth(date);
        List<CommuteVO> wtrmsAbsencEmplList = mapper.getCoWtrmsAbsenc(date);
        List<PaystubVO> salaryBslry = mapper.getSalaryBslry(year);
        List<TariffVO> tariffList = mapper.loadTariff(year);
        for (CommuteVO commuteVO : commute) {
            for (PaystubVO paystubVO : salaryBslry) {
                if (paystubVO.getSalaryEmplId().equals(commuteVO.getDclzEmplId())) {
                    commuteVO.setDclzEmplId(paystubVO.getSalaryEmplId()); // 아이디
                    commuteVO.setDefaulWorkTime(String.valueOf(Integer.parseInt(mapper.getPrescribedWorkingHours(date)) / 60)); // 소정근로시간
                    commuteVO.setRealWorkTime(String.valueOf(Integer.parseInt(commuteVO.getRealWorkTime()) / 60)); // 실제근무
                    commuteVO.setOverWorkTime(String.valueOf(Integer.parseInt(commuteVO.getOverWorkTime()) / 60)); // 초과근무
                    commuteVO.setTotalWorkTime(String.valueOf(Integer.parseInt(commuteVO.getRealWorkTime()) + Integer.parseInt(commuteVO.getOverWorkTime()))); // 총근로시간
                    for (CommuteVO wtrmsAbsencEmpl : wtrmsAbsencEmplList) {
                        if (wtrmsAbsencEmpl.getDclzEmplId().equals(commuteVO.getDclzEmplId()) && wtrmsAbsencEmpl.getCoWtrmsAbsenc() != 0) {
                            paystubVO.setSalaryBslry(paystubVO.getSalaryBslry() - ((paystubVO.getSalaryBslry() / 30) * wtrmsAbsencEmpl.getCoWtrmsAbsenc()));
                        }
                    }
                    paystubVO.setSalaryOvtimeAllwnc((double) paystubVO.getSalaryBslry() / 30 / 8 * 1.5 * Double.parseDouble(commuteVO.getOverWorkTime())); // 초과근무수당
                    paystubVO.setSalaryDtsmtPymntTotamt((int) (paystubVO.getSalaryBslry() + paystubVO.getSalaryOvtimeAllwnc()));
                    for (TariffVO tariffVO : tariffList) {
                        switch (tariffVO.getTaratStdrCode()) {
                            case "TAX_SIS_NP":
                                paystubVO.setSalaryDtsmtSisNp((int) (paystubVO.getSalaryDtsmtPymntTotamt() * tariffVO.getTaratStdrValue() / 100));
                                break;
                            case "TAX_SIS_HI":
                                paystubVO.setSalaryDtsmtSisHi((int) (paystubVO.getSalaryDtsmtPymntTotamt() * tariffVO.getTaratStdrValue() / 100));
                                break;
                            case "TAX_SIS_EI":
                                paystubVO.setSalaryDtsmtSisEi((int) (paystubVO.getSalaryDtsmtPymntTotamt() * tariffVO.getTaratStdrValue() / 100));
                                break;
                            case "TAX_SIS_WCI":
                                paystubVO.setSalaryDtsmtSisWci((int) (paystubVO.getSalaryDtsmtPymntTotamt() * tariffVO.getTaratStdrValue() / 100));
                                break;
                            case "TAX_INCMTAX":
                                paystubVO.setSalaryDtsmtIncmtax((int) (paystubVO.getSalaryDtsmtPymntTotamt() * tariffVO.getTaratStdrValue() / 100));
                                break;
                            case "TAX_LOCALITY_INCMTAX":
                                // 소득세의 10퍼 == 급여의 1퍼
                                paystubVO.setSalaryDtsmtLocalityIncmtax((int) (paystubVO.getSalaryDtsmtIncmtax() * tariffVO.getTaratStdrValue() / 100));
                                break;
                        }
                    }
                    paystubVO.setSalaryDtsmtDdcTotamt(
                            (int) (paystubVO.getSalaryDtsmtSisNp()
                                    + paystubVO.getSalaryDtsmtSisHi()
                                    + paystubVO.getSalaryDtsmtSisEi()
                                    + paystubVO.getSalaryDtsmtSisWci()
                                    + paystubVO.getSalaryDtsmtIncmtax()
                                    + paystubVO.getSalaryDtsmtLocalityIncmtax()));
                    paystubVO.setSalaryDtsmtNetPay(paystubVO.getSalaryDtsmtPymntTotamt() - paystubVO.getSalaryDtsmtDdcTotamt());
                    CommuteAndPaystub cnp = new CommuteAndPaystub(commuteVO, paystubVO);
                    cnpList.add(cnp);

                    Map<String, String> map = new HashMap<>();
                    for (CommuteAndPaystub commuteAndPaystub : cnpList) {
                        map.put("salaryEmplId", commuteAndPaystub.getPaystubVO().getSalaryEmplId());
                        map.put("date", year + "-" + month);
                        if (mapper.isInsertSalary(map) == 0 && mapper.isInsertSalaryDtsmt(map) == 0) {
                            commuteAndPaystub.getPaystubVO().setSalaryDtsmtIssuDate(new Date(Integer.parseInt(year) - 1900, Integer.parseInt(month) - 1, 14));
                            commuteAndPaystub.getPaystubVO().setInsertAt("Y");
                            mapper.inputSalary(commuteAndPaystub.getPaystubVO());
                            mapper.inputSalaryDtsmt(commuteAndPaystub.getPaystubVO());
                        }
                    }
                }
            }
        }

        cnpList.sort(new Comparator<CommuteAndPaystub>() {
            @Override
            public int compare(CommuteAndPaystub o1, CommuteAndPaystub o2) {
                String dclzEmplId1 = o1.getCommuteVO().getDclzEmplId();
                String dclzEmplId2 = o2.getCommuteVO().getDclzEmplId();
                return dclzEmplId1.compareTo(dclzEmplId2);
            }
        });
        return cnpList;
    }

    @Scheduled(cron = "0 0 14 * * ?")
    public List<CommuteAndPaystub> schedulingSalaryExactCalculation() {
        LocalDate localDate = LocalDate.now();
        int year = localDate.getYear();
        int month = localDate.getMonthValue();

        List<CommuteAndPaystub> cnpList = getCommuteAndPaystubList(String.valueOf(year), String.valueOf(month - 1));
        Map<String, String> map = new HashMap<>();
        for (CommuteAndPaystub cnp : cnpList) {
            map.put("salaryEmplId", cnp.getPaystubVO().getSalaryEmplId());
            map.put("date", year + "-" + month);
            if (mapper.isInsertSalary(map) == 0 && mapper.isInsertSalaryDtsmt(map) == 0) {
                cnp.getPaystubVO().setSalaryDtsmtIssuDate(new Date(year - 1900, month - 1, 14));
                cnp.getPaystubVO().setInsertAt("Y");
                mapper.inputSalary(cnp.getPaystubVO());
                mapper.inputSalaryDtsmt(cnp.getPaystubVO());
            }
        }
        return cnpList;
    }
}

