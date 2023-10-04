<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="sec" uri="http://www.springframework.org/security/tags" %>

<style>
    .icon-cloud {
        content:url("/resources/images/icon/cloud.svg");
    }
</style>

<script src="https://cdnjs.cloudflare.com/ajax/libs/sockjs-client/1.6.1/sockjs.min.js"></script>
<div id="floating">
    <ul>
<%--    권한별 아이콘 매핑   --%>
<%--        <sec:authentication property="principal" var="CustomUser"/>--%>
<%--        <c:forEach var="auth" items="${CustomUser.employeeVO.employeeAuthVOList}">--%>
<%--            <c:if test="${auth.authCode eq 'ROLE_CEO'}">--%>
<%--                <li><a href="${pageContext.request.contextPath}/employee/manageEmp"><i class="icon i-manage"></i></a></li>--%>
<%--            </c:if>--%>
<%--            <c:if test="${auth.authCode eq 'ROLE_HRT'}">--%>
<%--                <li><a href="${pageContext.request.contextPath}/employee/manageEmp"><i class="icon i-manage"></i></a></li>--%>
<%--            </c:if>--%>
<%--            <c:if test="${auth.authCode eq 'ROLE_AT'}">--%>
<%--                <li><a href="${pageContext.request.contextPath}/sanction/admin/DEPT011"><i class="icon i-manage"></i></a></li>--%>
<%--            </c:if>--%>
<%--            <c:if test="${auth.authCode eq 'ROLE_GAT'}">--%>
<%--                <li><a href="${pageContext.request.contextPath}/notice/manage"><i class="icon i-manage"></i></a></li>--%>
<%--            </c:if>--%>
<%--        </c:forEach>--%>

        <li><a href="${pageContext.request.contextPath}/employee/manageEmp"><i class="icon i-manage"></i></a></li>
        <li><a href="${pageContext.request.contextPath}/chat"><i class="icon i-send"></i></a></li>
        <li><a href="${pageContext.request.contextPath}/cloud/main"><i class="icon icon-cloud"></i></a></li>
    </ul>
</div>

<div id="floatingAlarm">
    <div id="aTagBox" class="alarmBox"></div>
    <button type="button" id="fReadBtn" class="readBtn btn font-11">읽음</button>
</div>
<script>
    //실시간 알림 읽음 처리
    $("#fReadBtn").on("click", function () {
        let ntcnSn = $("#fATag").attr("data-seq");
        $.ajax({
            type: 'delete',
            url: '/alarm/deleteAlarm?ntcnSn=' + ntcnSn,
            success: function () {
                $("#floatingAlarm").remove();
            },
            error: function (xhr) {
                xhr.status;
            }
        });
    })
</script>