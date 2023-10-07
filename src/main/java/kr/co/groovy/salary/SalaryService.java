package kr.co.groovy.salary;

import com.fasterxml.jackson.core.type.TypeReference;
import com.fasterxml.jackson.databind.ObjectMapper;
import kr.co.groovy.email.EmailService;
import kr.co.groovy.employee.EmployeeMapper;
import kr.co.groovy.enums.ClassOfPosition;
import kr.co.groovy.enums.Department;
import kr.co.groovy.security.CustomUser;
import kr.co.groovy.vo.*;
import lombok.extern.slf4j.Slf4j;
import org.apache.commons.fileupload.FileItem;
import org.apache.commons.fileupload.disk.DiskFileItem;
import org.apache.commons.io.IOUtils;
import org.springframework.scheduling.annotation.EnableScheduling;
import org.springframework.scheduling.annotation.Scheduled;
import org.springframework.security.core.Authentication;
import org.springframework.security.core.context.SecurityContextHolder;
import org.springframework.stereotype.Service;
import org.springframework.web.multipart.MultipartFile;
import org.springframework.web.multipart.commons.CommonsMultipartFile;

import java.io.File;
import java.io.FileInputStream;
import java.io.FileOutputStream;
import java.io.IOException;
import java.net.URI;
import java.net.URLDecoder;
import java.nio.file.Files;
import java.security.Principal;
import java.time.Instant;
import java.time.LocalDate;
import java.time.ZoneId;
import java.util.*;

@Slf4j
@Service
@EnableScheduling
public class SalaryService {
    final String uploadHyejin;
    final
    SalaryMapper salaryMapper;
    final EmployeeMapper employeeMapper;
    final EmailService emailService;


    public SalaryService(SalaryMapper salaryMapper, String uploadHyejin, EmployeeMapper employeeMapper, EmailService emailService) {
        this.salaryMapper = salaryMapper;
        this.uploadHyejin = uploadHyejin;
        this.employeeMapper = employeeMapper;
        this.emailService = emailService;
    }

    List<AnnualSalaryVO> loadSalary() {
        List<AnnualSalaryVO> list = salaryMapper.loadSalary();
        for (AnnualSalaryVO vo : list) {
            vo.setCommonCodeDeptCrsf(Department.valueOf(vo.getCommonCodeDeptCrsf()).label());
        }
        return list;
    }

    List<AnnualSalaryVO> loadBonus() {
        List<AnnualSalaryVO> list = salaryMapper.loadBonus();
        for (AnnualSalaryVO vo : list) {
            vo.setCommonCodeDeptCrsf(ClassOfPosition.valueOf(vo.getCommonCodeDeptCrsf()).label());
        }
        return list;
    }

    List<TariffVO> loadTariff(String year) {
        List<TariffVO> tariffVOList = salaryMapper.loadTariff(year);
        tariffVOList.sort(new Comparator<TariffVO>() {
            @Override
            public int compare(TariffVO o1, TariffVO o2) {
                return o1.getTaratStdrNm().compareTo(o2.getTaratStdrNm());
            }
        });
        return tariffVOList;
    }

    List<EmployeeVO> loadEmpList() {
        List<EmployeeVO> list = salaryMapper.loadEmpList();
        for (EmployeeVO vo : list) {
            vo.setCommonCodeDept(Department.valueOf(vo.getCommonCodeDept()).label());
            vo.setCommonCodeClsf(ClassOfPosition.valueOf(vo.getCommonCodeClsf()).label());
        }
        return list;
    }

    List<PaystubVO> loadPaymentList(String emplId, String year) {
        return salaryMapper.loadPaymentList(emplId, year);
    }

    PaystubVO loadRecentPaystub(String emplId) {
        return salaryMapper.loadRecentPaystub(emplId);
    }

    List<Integer> loadYearsForSortPaystub(String emplId) {
        return salaryMapper.loadYearsForSortPaystub(emplId);
    }

    List<PaystubVO> loadPaystubList(String emplId, String year) {
        return salaryMapper.loadPaystubList(emplId, year);
    }

    public void modifyIncmtax(String code, double value) {
        salaryMapper.modifyIncmtax(code, value);
    }

    public void modifySalary(String code, int value) {
        salaryMapper.modifySalary(code, value);
    }

    public PaystubVO loadPaystubDetail(String emplId, String paymentDate) {
        return salaryMapper.loadPaystubDetail(emplId, paymentDate);
    }

    public void saveCheckboxState(boolean isChecked) {
        Authentication authentication = SecurityContextHolder.getContext().getAuthentication();
        CustomUser customUser = (CustomUser) authentication.getPrincipal();
        EmployeeVO employeeVO = customUser.getEmployeeVO();
        employeeVO.setHideAmount(isChecked);
    }

    public List<String> getExistsYears() {
        return salaryMapper.getExistsYears();
    }

    public List<String> getExistsMonthPerYears(String year) {
        return salaryMapper.getExistsMonthByYear(year);
    }


    public List<CommuteAndPaystub> getCommuteAndPaystubList(String year, String month) {
        // 8월 선택하면 지급일자는 9월
        String date = year + "-" + month;
        List<CommuteAndPaystub> cnpList = new ArrayList<>();
        List<CommuteVO> commute = salaryMapper.getCommuteByYearAndMonth(date);
        List<CommuteVO> wtrmsAbsencEmplList = salaryMapper.getCoWtrmsAbsenc(date);
        List<PaystubVO> salaryBslry = salaryMapper.getSalaryBslry(year);
        List<TariffVO> tariffList = salaryMapper.loadTariff(year);
        for (CommuteVO commuteVO : commute) {
            for (PaystubVO paystubVO : salaryBslry) {
                if (paystubVO.getSalaryEmplId().equals(commuteVO.getDclzEmplId())) {
                    commuteVO.setDclzEmplId(paystubVO.getSalaryEmplId()); // 아이디
                    commuteVO.setDefaulWorkTime(String.valueOf(Integer.parseInt(salaryMapper.getPrescribedWorkingHours(date)) / 60)); // 소정근로시간
                    commuteVO.setRealWorkTime(String.valueOf(Integer.parseInt(commuteVO.getRealWorkTime()) / 60)); // 실제근무
                    commuteVO.setOverWorkTime(String.valueOf(Integer.parseInt(commuteVO.getOverWorkTime()) / 60)); // 초과근무
                    commuteVO.setTotalWorkTime(String.valueOf(Integer.parseInt(commuteVO.getRealWorkTime()) + Integer.parseInt(commuteVO.getOverWorkTime()))); // 총근로시간
                    for (CommuteVO wtrmsAbsencEmpl : wtrmsAbsencEmplList) {
                        if (wtrmsAbsencEmpl.getDclzEmplId().equals(commuteVO.getDclzEmplId()) && wtrmsAbsencEmpl.getCoWtrmsAbsenc() != 0) {
                            paystubVO.setSalaryBslry(paystubVO.getSalaryBslry() - ((paystubVO.getSalaryBslry() / 30) * wtrmsAbsencEmpl.getCoWtrmsAbsenc()));
                        }
                    }
                    paystubVO.setSalaryOvtimeAllwnc((int) Math.round(paystubVO.getSalaryBslry() / 30 / 8 * 1.5 * Integer.parseInt(commuteVO.getOverWorkTime()))); // 초과근무수당
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

    @Scheduled(cron = "0 0 14 * * ?") // 매달 14일에 인서트
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
            if (salaryMapper.existsInsertedSalary(map) == 0 && salaryMapper.existsInsertedSalaryDtsmt(map) == 0) {
                cnp.getPaystubVO().setSalaryDtsmtIssuDate(Date.from(instant));
                cnp.getPaystubVO().setInsertAt("Y");
                salaryMapper.inputSalary(cnp.getPaystubVO());
                salaryMapper.inputSalaryDtsmt(cnp.getPaystubVO());
            }
        }
        return cnpList;
    }

    public String inputSalaryDtsmtPdf(Map<String, String> map) {
        String datauri = map.get("datauri");
        String etprCode = map.get("etprCode");

        try {
            String uploadPath = this.uploadHyejin + "/salary";
            File uploadDir = new File(uploadPath);
            if (uploadDir.exists() == false) {
                if (uploadDir.mkdirs()) {
                    log.info("폴더 생성 성공");
                } else {
                    log.info("폴더 생성 실패");
                }
            }
            URI uri = new URI(datauri);
            String path = null;
            File saveFile = null;
            if ("data".equals(uri.getScheme())) {
                String dataPart = uri.getRawSchemeSpecificPart();
                String base64Data = dataPart.substring(dataPart.indexOf(',') + 1);
                byte[] decodedData = Base64.getDecoder().decode(base64Data);

                String fileName = etprCode + ".pdf";
                saveFile = new File(uploadPath, fileName);
                FileOutputStream fos = new FileOutputStream(saveFile);
                fos.write(decodedData);
            } else {
                path = uri.getPath();
                saveFile = new File(uploadPath, path);
            }

            if (salaryMapper.existsUploadedFile(etprCode) == 0) {
                Map<String, Object> inputMap = new HashMap<>();
                inputMap.put("salaryDtsmtEtprcode", etprCode);
                inputMap.put("originalFileName", "default");
                inputMap.put("newFileName", etprCode + ".pdf");
                inputMap.put("fileSize", 0);

                salaryMapper.inputSalaryDtsmtPdf(inputMap);
            }
            return "success";
        } catch (Exception e) {
            e.printStackTrace();
            return "fail";
        }
    }

    public String sentEmails(Principal principal, String data, String date) throws IOException {
        data = URLDecoder.decode(data, "UTF-8");
        ObjectMapper objectMapper = new ObjectMapper();
        List<String> emplIdArray = objectMapper.readValue(data, new TypeReference<List<String>>() {
        });

        EmployeeVO nowEmployee = employeeMapper.loadEmp(principal.getName());
        EmailVO emailVO = new EmailVO();
        Map<String, String> map = new HashMap<>();
        String filePath = null;
        String result = null;
        map.put("date", date);
        for (String emplId : emplIdArray) {
            map.put("emplId", emplId);
            UploadFileVO vo = salaryMapper.getDtsmtFileByDateAndEmplId(map);
            if (vo != null) {
                String originalName = new String(vo.getUploadFileStreNm().getBytes("utf-8"), "iso-8859-1");
                String fileName = vo.getUploadFileStreNm();
                filePath = uploadHyejin + "/salary";

                File file = new File(filePath, fileName);
                if (!file.isFile()) {
                    log.info("파일 없음");
                }

                FileItem fileItem = new DiskFileItem("file", Files.probeContentType(file.toPath()), false, file.getName(), (int) file.length(), file.getParentFile());
                IOUtils.copy(new FileInputStream(file), fileItem.getOutputStream());
                MultipartFile multipartFile = new CommonsMultipartFile(fileItem);

                EmployeeVO toEmployee = employeeMapper.loadEmp(emplId);
                emailVO.setEmailToAddr(toEmployee.getEmplEmail());
                emailVO.setEmailFromSj(date.substring(0, 2) + "년 " + date.substring(2) + "월 " + toEmployee.getEmplNm() + "님 급여명세서 보내드립니다.");
                emailVO.setEmailFromSendDate(new Date());
                emailVO.setEmailFromCn("");
                result = emailService.sentMail(emailVO, new MultipartFile[]{multipartFile}, nowEmployee);
            }
        }
        return result;
    }
}

