package kr.co.groovy.salary;

import kr.co.groovy.vo.*;
import org.apache.ibatis.annotations.Param;

import java.util.List;
import java.util.Map;

public interface SalaryMapper {

    List<AnnualSalaryVO> loadSalary();

    List<AnnualSalaryVO> loadBonus();

    List<TariffVO> loadTariff(@Param("year") String year);

    List<EmployeeVO> loadEmpList();

    List<PaystubVO> loadPaymentList(@Param("emplId") String emplId, @Param("year") String year);

    PaystubVO loadRecentPaystub(String emplId);

    List<Integer> loadYearsForSortPaystub(String emplId);

    List<PaystubVO> loadPaystubList(@Param("emplId") String emplId, @Param("year") String year);

    void modifyIncmtax(@Param("code") String code, @Param("value") double value);

    void modifySalary(@Param("code") String code, @Param("value") double value);

    PaystubVO loadPaystubDetail(@Param("emplId") String emplId, @Param("paymentDate") String paymentDate);

    List<String> getExistsYears();

    List<String> getExistsMonthByYear(String year);

    List<CommuteVO> getCommuteByYearAndMonth(String date);

    String getPrescribedWorkingHours(String date);

    List<PaystubVO> getSalaryBslry(String date);

    List<CommuteVO> getCoWtrmsAbsenc(String date);

    int inputSalary(PaystubVO vo);

    int inputSalaryDtsmt(PaystubVO vo);

    int existsInsertedSalary(Map<String, String> map);

    int existsInsertedSalaryDtsmt(Map<String, String> map);

    int existsUploadedFile(String salaryDtsmtEtprCode);

    int inputSalaryDtsmtPdf(Map<String, Object> map);

    UploadFileVO getDtsmtFileByDateAndEmplId(Map<String, String> map);

}
