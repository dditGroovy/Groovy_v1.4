<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<div class="content-container">
    <div>
        <h2>법인카드 신청 기록</h2>
        <table border="1">
            <tr>
                <td id="sanctionNum">${detailVO.cprCardResveSn}</td>
                <td>기간: ${detailVO.cprCardResveBeginDate} - ${detailVO.cprCardResveClosDate}</td>
                <td>사용처 : ${detailVO.cprCardUseLoca}</td>
                <td>사용목적 : ${detailVO.cprCardUsePurps}</td>
                <td>사용예상금액 : <fmt:formatNumber type="number" value="${detailVO.cprCardUseExpectAmount}"
                                               pattern="#,##0"/>원
                </td>
            </tr>
        </table>
        <c:choose>
            <c:when test="${detailVO.commonCodeYrycState == 'YRYC030'}">
                <button type="button" id="modifyRequest">수정하기</button>
                <button type="button" id="startSanction">결재하기</button>
            </c:when>
            <%--    결재 했을 때     --%>
            <c:otherwise>
                <a href="${pageContext.request.contextPath}/card/record">목록으로</a>
            </c:otherwise>
        </c:choose>
    </div>
</div>
<script>
    $("#startSanction").on("click", function () {
        $("#modifyVacation").prop("disabled", true)
        window.open('/sanction/format/DEPT011/SANCTN_FORMAT010', "결재", "width = 1200, height = 1200")
    })

    function refreshParent() {
        window.location.reload(); // 새로고침
    }

</script>