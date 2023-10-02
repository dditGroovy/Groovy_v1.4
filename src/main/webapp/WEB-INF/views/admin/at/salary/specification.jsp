<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<link rel="stylesheet" href="${pageContext.request.contextPath}/resources/css/common.css">
<link rel="stylesheet" href="${pageContext.request.contextPath}/resources/css/commonStyle.css">
<style>
    .h {
        text-align: center;
        font-size: 30px;
    }

    .r, .s {
        text-align: right;
    }

    .n {
        width: 100%;
        border-bottom: 1px solid #000;
    }

    .d {
        display: flex;
    }

    .n th, .f th {
        background: var(--color-bg-sky);
        color: #000;
    }

    .n td, .f td {
        padding-left: 10px;
    }

    .n th, .n td {
        height: 50px;
        border: 1px solid #000;
    }

    .rT {
        border-left: none;
    }

    .f th, .f td {
        border: 1px solid #000;
        border-top: none;
    }

    .f td, .n td {
        width: 230px;
        height: 45px;
    }

    .t {
        text-align: center;
    }

    .p {
        margin: 50px 0 20px;
    }

    .rT {
        border-right: 1px solid #000;
    }

    .f {
        width: 100%;
        border-bottom: 1px solid #000;
    }</style>
<h1 class="h">\${r.month}월 그루비 급여명세서</h1>
<p class="p r" style="text-align: right;">지급일: \${fDate}</p>
<div class="d">
    <table class="n">
        <tr>
            <th>사번</th>
            <td>\${r.salaryEmplId}</td>
        </tr>
        <tr>
            <th>소속</th>
            <td>\${r.deptNm}팀</td>
        </tr>
    </table>
    <table class="n rT">
        <tr>
            <th>성명</th>
            <td>\${r.salaryEmplNm}</td>
        </tr>
        <tr>
            <th>직급</th>
            <td>\${r.clsfNm}</td>
        </tr>
    </table>
</div>
<p class="p">급여내역</p>
<div class="d">
    <table class="n">
        <tr>
            <th colspan="2">지급 내역</th>
        </tr>
        <tr>
            <th>기본급</th>
            <td>\${fBslry}원</td>
        </tr>
        <tr>
            <th>초과근무수당</th>
            <td>\${fOvtimeAllwnc}원</td>
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
            <td>\${fPymntTotamt}원</td>
        </tr>
    </table>
    <table class="n rT">
        <tr>
            <th colspan="2">공제 내역</th>
        </tr>
        <tr>
            <th>국민연금</th>
            <td>\${fSisNp}원</td>
        </tr>
        <tr>
            <th>건강보험</th>
            <td>\${fSisHi}원</td>
        </tr>
        <tr>
            <th>고용보험</th>
            <td>\${fSisEi}원</td>
        </tr>
        <tr>
            <th>산재보험</th>
            <td>\${fSisWci}원</td>
        </tr>
        <tr>
            <th>소득세</th>
            <td>\${fIncmtax}원</td>
        </tr>
        <tr>
            <th>지방소득세</th>
            <td>\${fLocalityIncmtax}원</td>
        </tr>
        <tr>
            <th>총공제액</th>
            <td>\${fDdcTotamt}원</td>
        </tr>
    </table>
</div>
<div class="d">
    <table class="n" style="visibility:hidden;"></table>
    <table class="f rT">
        <tr>
            <th>실수령액</th>
            <td>\${fNetPay}원</td>
        </tr>
    </table>
</div>
<p class="t p">\${r.salaryEmplNm}님의 노고에 감사드립니다</p>
<p class="s">그루비 (인)</p>
