<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<link rel="stylesheet" href="/resources/css/admin/manageSalary.css">
<div class="content-container">
    <header id="tab-header">
        <h1><a href="${pageContext.request.contextPath}/salary" class="on">기본 급여 및 공제 관리</a></h1>
    </header>
    <div class="side-header-wrap">
        <h1 class="font-md font-18 color-font-md">급여 기본 설정</h1>
        <button type="button" id="modifySalary" class="btn btn-free-white btn-sm color-font-md font-14 font-md btn-modal" data-name="salaryCard">수정하기</button>
    </div>

    <table border=" 1" class="salaryTable">
        <tr class="tableHeader">
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

    <div class="side-header-wrap">
        <h1 class="font-md font-18 color-font-md">공제 기본 설정</h1>
        <button id="saveSis" type="button" class="btn btn-free-white btn-sm color-font-md font-14 font-md">저장하기</button>
    </div>
    <form action="#">
        <table border=" 1" class="sisTable">
            <c:forEach var="tariffVO" items="${tariffList}" varStatus="stat">
                <c:if test="${tariffVO.taratStdrNm != '소득세' && tariffVO.taratStdrNm != '지방소득세'}">
                    <tr>
                        <th class="tableHeader font-14 font-md">${tariffVO.taratStdrNm}</th>
                        <td class="tableData">
                            <span class="dataTitle">개인부담분:</span>
                            <input type="text" class="taxValue input-data" name="${tariffVO.taratStdrCode}"
                                   value="${tariffVO.taratStdrValue}">%
                            <span class="dataTitle dataTitleTwo">회사부담분:</span>
                            <input type="text" name="${tariffVO.taratStdrCode}" class="input-data"
                                   value="${tariffVO.taratStdrValue}" readonly>%
                        </td>
                    </tr>
                </c:if>
            </c:forEach>
        </table>
    </form>

    <div class="side-header-wrap">
        <h1 class="font-md font-18 color-font-md">소득세 설정</h1>
        <button id="saveIncmtax" type="button" class="btn btn-free-white btn-sm color-font-md font-14 font-md">저장하기</button>
    </div>

    <form action="#">
        <table border=" 1" class="incomeTaxTable">
            <c:forEach var="tariffVO" items="${tariffList}" varStatus="stat">
                <c:if test="${tariffVO.taratStdrNm == '소득세' || tariffVO.taratStdrNm == '지방소득세'}">
                    <tr>
                        <th class="tableHeader font-14 font-md">${tariffVO.taratStdrNm}</th>
                        <td class="tableData">
                            <input type="text" class="taxValue input-data" name="${tariffVO.taratStdrCode}"
                                   value="${tariffVO.taratStdrValue}">%
                        </td>
                    </tr>
                </c:if>
            </c:forEach>
        </table>
    </form>

    <!-- modal -->
    <div id="modal" class="modal-dim" style="display: none">
        <div class="dim-bg"></div>
        <div class="modal-layer card-df sm salaryCard" style="display: block">
            <div class="modal-top">
                <div class="modal-title"><i class="icon-user"></i>급여 기본 설정</div>
                <button type="button" class="modal-close btn close">
                    <i class="icon i-close close">X</i>
                </button>
            </div>
            <div class="modal-container">
                <form action="#">
                    <div class="modalTable">
                        <table>
                            <tr class="modal-header">
                                <th>부서</th>
                                <th>수당(원)</th>
                            </tr>
                            <c:forEach var="salaryItem" items="${salary}" varStatus="salaryStat">
                                <tr class="modal-data">
                                    <td>${salaryItem.commonCodeDeptCrsf}</td>
                                    <td><input type="number" class="salaryValue input-data" name="${salaryItem.originalCode}" value="${salaryItem.anslryAllwnc}"></td>
                                </tr>
                            </c:forEach>
                        </table>
                        <table>
                            <tr class="modal-header">
                                <th>직급</th>
                                <th>수당(원)</th>
                            </tr>
                            <c:forEach var="bonusItem" items="${bonus}">
                                <tr class="modal-data">
                                    <td>${bonusItem.commonCodeDeptCrsf}</td>
                                    <td><input type="number" class="salaryValue input-data" name="${bonusItem.originalCode}" value="${bonusItem.anslryAllwnc}"></td>
                                    </td>
                                </tr>
                            </c:forEach>
                        </table>
                    </div>
                    <div class="modal-footer btn-wrapper">
                        <button type="button" class="btn btn-fill-wh-sm close">취소</button>
                        <button type="button" id="saveSalary" class="btn btn-fill-bl-sm">저장하기</button>
                    </div>
                </form>
            </div>
        </div>
    </div>
</div>
<script src="/resources/js/modal.js"></script>
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
                    Swal.fire({
                        text: '연봉 수정을 완료했습니다',
                        showConfirmButton: false,
                        timer: 1500
                    })
                },
                error: function (request, status, error) {
                    Swal.fire({
                        text: '연봉 수정을 실패했습니다 다시 시도해주세요',
                        showConfirmButton: false,
                        timer: 1500
                    })
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
                    Swal.fire({
                        text: '소득세 수정을 완료했습니다',
                        showConfirmButton: false,
                        timer: 1500
                    })
                },
                error: function (request, status, error) {
                    Swal.fire({
                        text: '소득세 수정을 실패했습니다 다시 시도해주세요',
                        showConfirmButton: false,
                        timer: 1500
                    })
                }
            });
        }
    });



</script>