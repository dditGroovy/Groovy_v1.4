<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>

<div class="content-container">
    <h1 class="tab">기본 급여 및 공제 관리</h1>
    <br/><br/>
    <h2>급여 기본 설정</h2>
    <button id="modifySalary">수정하기</button>
    <table border=" 1">
        <tr>
            <td>(만원)</td>
            <td>사원</td>
            <td>대리</td>
            <td>과장</td>
            <td>차장</td>
            <td>팀장</td>
            <td>부장</td>
        </tr>
        <c:forEach var="salaryItem" items="${salary}" varStatus="salaryStat">
            <tr>
                <td>${salaryItem.commonCodeDeptCrsf}</td>
                <c:forEach var="bonusItem" items="${bonus}">
                    <c:set var="total" value="${salaryItem.anslryAllwnc + bonusItem.anslryAllwnc}"/>
                    <td>${total.toString().substring(0, 4)}</td>
                </c:forEach>
            </tr>
        </c:forEach>
    </table>
    <hr/>
    <br/>

    <!-- TODO ("#modifySalary") 누르면 모달로 열리고 수정 처리 -->
    <div>
        <form action="#">
            <table border="1">
                <tr>
                    <th>부서</th>
                    <th>수당(원)</th>
                </tr>
                <c:forEach var="salaryItem" items="${salary}" varStatus="salaryStat">
                    <tr>
                        <td>${salaryItem.commonCodeDeptCrsf}</td>
                        <td><input type="number" class="salaryValue" name="${salaryItem.originalCode}" value="${salaryItem.anslryAllwnc}"></td>

                    </tr>
                </c:forEach>
                <tr>
                    <th>직급</th>
                    <th>수당(원)</th>
                </tr>
                <c:forEach var="bonusItem" items="${bonus}">
                    <tr>
                        <td>${bonusItem.commonCodeDeptCrsf}</td>
                        <td><input type="number" class="salaryValue" name="${bonusItem.originalCode}" value="${bonusItem.anslryAllwnc}"></td>

                        </td>
                    </tr>
                </c:forEach>

            </table>
            <button id="saveSalary">저장하기</button>
        </form>
    </div>


    <h2>소득세 설정</h2>
    <form action="#">
        <button id="saveIncmtax" type="button">저장하기</button>
        <table border=" 1">
            <c:forEach var="tariffVO" items="${tariffList}" varStatus="stat">
                <c:if test="${tariffVO.taratStdrNm == '소득세' || tariffVO.taratStdrNm == '지방소득세'}">
                    <tr>
                        <th>${tariffVO.taratStdrNm}</th>
                        <td>
                            <input type="text" class="taxValue" name="${tariffVO.taratStdrCode}"
                                   value="${tariffVO.taratStdrValue}">%
                        </td>
                    </tr>
                </c:if>
            </c:forEach>
        </table>
    </form>

    <h2>공제 기본 설정</h2>
    <form action="#">
        <button id="saveSis" type="button">저장하기</button>
        <table border=" 1">
            <c:forEach var="tariffVO" items="${tariffList}" varStatus="stat">
                <c:if test="${tariffVO.taratStdrNm != '소득세' && tariffVO.taratStdrNm != '지방소득세'}">
                    <tr>
                        <th>${tariffVO.taratStdrNm}</th>
                        <td>
                            개인부담분 :
                            <input type="text" class="taxValue" name="${tariffVO.taratStdrCode}"
                                   value="${tariffVO.taratStdrValue}">%
                            회사부담분 :
                            <input type="text" name="${tariffVO.taratStdrCode}"
                                   value="${tariffVO.taratStdrValue}" readonly>%
                        </td>
                    </tr>
                </c:if>
            </c:forEach>
        </table>
    </form>
</div>
<script>

    $(document).ready(function () {
        /* 급여 테이블 수정 */
        let previousSalary = {};
        $("input.salaryValue").each(function () {
            let code = $(this).attr("name");
            let value = $(this).val();
            previousSalary[code] = value;
        });

        $("#saveSalary").on("click", function () {
            $("input.salaryValue").each(function () {
                let code = $(this).attr("name");
                let currentValue = $(this).val();

                if (previousSalary[code] !== currentValue) {
                    saveSalaryData(code, currentValue);
                    previousSalary[code] = currentValue;
                }
            });
        });

        function saveSalaryData(code, value) {
            $.ajax({
                url: '/salary/modify/salary',
                type: 'POST',
                data: {
                    code: code,
                    value: value
                },
                success: function (data) {
                    console.log("급여 업데이트 성공");
                },
                error: function (request, status, error) {
                    console.log("급여 업데이트 실패: " + error);
                }
            });
        }


        /* 세율 기준 수정 */
        let previousValues = {};
        $("input.taxValue").each(function () {
            let code = $(this).attr("name");
            let value = $(this).val();
            previousValues[code] = value;
        });

        $("#saveIncmtax, #saveSis").on("click", function () {
            $("input.taxValue").each(function () {
                let code = $(this).attr("name");
                let currentValue = $(this).val();

                if (previousValues[code] !== currentValue) {
                    saveTaxData(code, currentValue);
                    previousValues[code] = currentValue;
                }
            });
        });

        function saveTaxData(code, value) {
            $.ajax({
                url: '/salary/modify/taxes',
                type: 'POST',
                data: {
                    code: code,
                    value: value
                },
                success: function (data) {
                    console.log("소득세 업데이트 성공");
                },
                error: function (request, status, error) {
                    console.log("소득세 업데이트 실패: " + error);
                }
            });
        }
    });
</script>