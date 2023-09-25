<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<h1 style="text-align: center;">\${result.month}월 그루비 급여명세서</h1>
<p style="text-align: right;">
    지급일: \${formattedDate}
</p>
<table border="1">
    <tr>
        <th>사번</th>
        <td>\${result.salaryEmplId}</td>
        <th>성명</th>
        <td>\${result.salaryEmplNm}</td>
    </tr>
    <tr>
        <th>소속</th>
        <td>\${result.deptNm}팀</td>
        <th>직급</th>
        <td>\${result.clsfNm}</td>
    </tr>
</table>
급여내역
<table border="1">
    <tr>
        <th colspan="2">지급 내역</th>
        <th colspan="2">공제 내역</th>
    </tr>
    <tr>
        <th>기본급</th>
        <td>\${formattedBslry}원</td>
        <th>국민연금</th>
        <td>\${formattedSisNp}원</td>
    </tr>
    <tr>
        <th>초과근무수당</th>
        <td>\${formattedOvtimeAllwnc}원</td>
        <th>건강보험</th>
        <td>\${formattedSisHi}원</td>
    </tr>
    <tr>
        <th></th>
        <td></td>
        <th>고용보험</th>
        <td>\${formattedSisEi}원</td>
    </tr>
    <tr>
        <th></th>
        <td></td>
        <th>산재보험</th>
        <td>\${formattedSisWci}원</td>
    </tr>
    <tr>
        <th></th>
        <td></td>
        <th>소득세</th>
        <td>\${formattedIncmtax}원</td>
    </tr>
    <tr>
        <th></th>
        <td></td>
        <th>지방소득세</th>
        <td>\${formattedLocalityIncmtax}원</td>
    </tr>
    <tr>
        <th>총지급액</th>
        <td>\${formattedPymntTotamt}원</td>
        <th>총공제액</th>
        <td>\${formattedDdcTotamt}원</td>
    </tr>
    <tr>
        <th></th>
        <td></td>
        <th>실수령액</th>
        <td>\${formattedNetPay}원</td>
    </tr>
</table>
<p>\${result.salaryEmplNm}님의 노고에 감사드립니다</p>
<p>그루비 (인)</p>