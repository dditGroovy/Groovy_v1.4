<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<link rel="stylesheet" href="${pageContext.request.contextPath}/resources/css/common.css">
<link rel="stylesheet" href="${pageContext.request.contextPath}/resources/css/commonStyle.css">

<style>
    h1 {
        text-align: center;
        font-size: 36px;
    }

    .dtsmtDate, .sign {
        text-align: right;
    }

    .notFake {
        width: 100%;
        border-bottom: 1px solid black;
    }

    .display {
        display: flex;
    }

    th {
        background: var(--color-bg-sky);
        color: black;
    }

    .notFake th, .notFake td {
        height: 50px;
        border-top: 1px solid black;
        border-left: 1px solid black;
    }

    #faker th, #faker td {
        border-left: 1px solid black;
    }

    #faker td, .notFake td {
        width: 230px;
        height: 50px;
    }

    .thanks {
        text-align: center;
    }

    .pMargin {
        margin-top: 50px;
        margin-bottom: 20px;
    }

    .rightTable {
        border-right: 1px solid black;
    }

    pre {
        width: 50%;
    }

    #faker {
        width: 100%;
        border: none;
        border-bottom: 1px solid black;
        border-right: 1px solid black;
    }
</style>
<h1>\${result.month}월 그루비 급여명세서</h1>
<p class="dtsmtDate pMargin">지급일: \${formattedDate}</p>
<div class="display">
    <table class="notFake">
        <tr>
            <th>사번</th>
            <td>\${result.salaryEmplId}</td>
        </tr>
        <tr>
            <th>소속</th>
            <td>\${result.deptNm}팀</td>
        </tr>
    </table>
    <table class="notFake rightTable">
        <tr>
            <th>성명</th>
            <td>\${result.salaryEmplNm}</td>
        </tr>
        <tr>
            <th>직급</th>
            <td>\${result.clsfNm}</td>
        </tr>
    </table>
</div>
<p class="pMargin">급여내역</p>
<div class="display">
    <table class="notFake">
        <tr>
            <th colspan="2">지급 내역</th>
        </tr>
        <tr>
            <th>기본급</th>
            <td>\${formattedBslry}원</td>
        </tr>
        <tr>
            <th>초과근무수당</th>
            <td>\${formattedOvtimeAllwnc}원</td>
        </tr>
        <tr>
            <th></th>
            <td></td>
        </tr>
        <tr>
            <th></th>
            <td></td>
        </tr>
        <tr>
            <th></th>
            <td></td>
        </tr>
        <tr>
            <th></th>
            <td></td>
        </tr>
        <tr>
            <th>총지급액</th>
            <td>\${formattedPymntTotamt}원</td>
        </tr>
    </table>
    <table class="notFake rightTable">
        <tr>
            <th colspan="2">공제 내역</th>
        </tr>
        <tr>
            <th>국민연금</th>
            <td>\${formattedSisNp}원</td>
        </tr>
        <tr>
            <th>건강보험</th>
            <td>\${formattedSisHi}원</td>
        </tr>
        <tr>
            <th>고용보험</th>
            <td>\${formattedSisEi}원</td>
        </tr>
        <tr>
            <th>산재보험</th>
            <td>\${formattedSisWci}원</td>
        </tr>
        <tr>
            <th>소득세</th>
            <td>\${formattedIncmtax}원</td>
        </tr>
        <tr>
            <th>지방소득세</th>
            <td>\${formattedLocalityIncmtax}원</td>
        </tr>
        <tr>
            <th>총공제액</th>
            <td>\${formattedDdcTotamt}원</td>
        </tr>
    </table>

</div>
<div class="display">
    <table class="notFake" style="visibility: hidden;"></table>
    <table id="faker" class="rightTable">
        <tr>
            <th>실수령액</th>
            <td>\${formattedNetPay}원</td>
        </tr>
    </table>
</div>
<p class="thanks pMargin">\${result.salaryEmplNm}님의 노고에 감사드립니다</p>
<p class="sign">그루비 (인)</p>