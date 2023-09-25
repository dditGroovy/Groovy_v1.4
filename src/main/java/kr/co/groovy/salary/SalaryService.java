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

import java.io.File;
import java.io.FileOutputStream;
import java.net.URI;
import java.time.Instant;
import java.time.LocalDate;
import java.time.ZoneId;
import java.util.*;

@Slf4j
@Service
@EnableScheduling
public class SalaryService {
    final
    SalaryMapper mapper;

    final String uploadHyejin;

    public SalaryService(SalaryMapper mapper, String uploadHyejin) {
        this.mapper = mapper;
        this.uploadHyejin = uploadHyejin;
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
//
//                    Map<String, String> map = new HashMap<>();
//                    LocalDate inputDate = LocalDate.of(Integer.parseInt(year), Integer.parseInt(month), 14);
//                    Instant instant = inputDate.atStartOfDay(ZoneId.systemDefault()).toInstant();
//
//                    for (CommuteAndPaystub commuteAndPaystub : cnpList) {
//                        map.put("salaryEmplId", commuteAndPaystub.getPaystubVO().getSalaryEmplId());
//                        map.put("date", String.valueOf(inputDate));
//                        if (mapper.existsInsertedSalary(map) == 0 && mapper.existsInsertedSalaryDtsmt(map) == 0) {
//                            commuteAndPaystub.getPaystubVO().setSalaryDtsmtIssuDate(Date.from(instant));
//                            commuteAndPaystub.getPaystubVO().setInsertAt("Y");
//                            mapper.inputSalary(commuteAndPaystub.getPaystubVO());
//                            mapper.inputSalaryDtsmt(commuteAndPaystub.getPaystubVO());
//                        }
//                    }
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

    @Scheduled(cron = "0 0 14 * * ?") // 매달 14일에 인서트하는용일뿐. ..
    public List<CommuteAndPaystub> schedulingSalaryExactCalculation() {
        LocalDate localDate = LocalDate.now();
        int year = localDate.getYear();
        int month = localDate.getMonthValue();
        LocalDate inputDate = LocalDate.of(year, month, 14);
        Instant instant = inputDate.atStartOfDay(ZoneId.systemDefault()).toInstant();

        List<CommuteAndPaystub> cnpList = getCommuteAndPaystubList(String.valueOf(year), String.valueOf(month - 1));
        Map<String, String> map = new HashMap<>();
        for (CommuteAndPaystub cnp : cnpList) {
            map.put("salaryEmplId", cnp.getPaystubVO().getSalaryEmplId());
            map.put("date", String.valueOf(inputDate));
            if (mapper.existsInsertedSalary(map) == 0 && mapper.existsInsertedSalaryDtsmt(map) == 0) {
                cnp.getPaystubVO().setSalaryDtsmtIssuDate(Date.from(instant));
                cnp.getPaystubVO().setInsertAt("Y");
                int inputSalary = mapper.inputSalary(cnp.getPaystubVO());
                int inputSalaryDtsmt = mapper.inputSalaryDtsmt(cnp.getPaystubVO());
                if (inputSalary != 0 && inputSalaryDtsmt != 0) {
                    log.info("success");
                }
            }
        }
        return cnpList;
    }

    public String inputSalaryDtsmtPdf(Map<String, String> map) {
        String datauri = map.get("datauri");
        String etprCode = map.get("etprCode");

        try {
            String uploadPath = uploadHyejin + "/salary";
            log.info("salary uploadPath: " + uploadPath);
            File uploadDir = new File(uploadPath);
            if (!uploadDir.exists()) {
                if (uploadDir.mkdirs()) {
                    log.info("폴더 생성 성공");
                } else {
                    log.info("폴더 생성 실패");
                }
            }

            URI uri = new URI(datauri);
            log.info(datauri);
            String path = null;
            if ("data".equals(uri.getScheme())) {
                String dataPart = uri.getRawSchemeSpecificPart();
                String base64Data = dataPart.substring(dataPart.indexOf(',') + 1);
                byte[] decodedData = Base64.getDecoder().decode(base64Data);

                String fileName = etprCode + ".pdf";
                File saveFile = new File(uploadPath, fileName);
                FileOutputStream fos = new FileOutputStream(saveFile);
                fos.write(decodedData);
            } else {
                path = uri.getPath();
                File saveFile = new File(uploadPath, path);
            }

            if (mapper.existsUploadedFile(etprCode) == 0) {
                Map<String, Object> inputMap = new HashMap<>();
                inputMap.put("salaryDtsmtEtprcode", etprCode);
                inputMap.put("originalFileName", "default"); // 저장할거면 블롭으로 바꿀지 상의
                inputMap.put("newFileName", etprCode + ".pdf");
                inputMap.put("fileSize", 0);

                mapper.inputSalaryDtsmtPdf(inputMap);
            }
            log.info("급여명세서 저장 성공");
        } catch (Exception e) {
            log.info("급여명세서 저장 실패");
            e.printStackTrace();
        }
        return "";
    }
}

