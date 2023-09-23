<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<link rel="stylesheet" href="${pageContext.request.contextPath}/resources/css/admin/manageVehicle.css">
<style>
    /*ul {*/
    /*    list-style: none;*/
    /*    padding-left: 0;*/
    /*}*/

    /*.wrap ul {*/
    /*    display: flex;*/
    /*    gap: 10px*/
    /*}*/

    /*.header, .titleWrap {*/
    /*    display: flex;*/
    /*    align-items: center;*/
    /*    gap: 10px;*/
    /*}*/

    /*table tr {*/
    /*    display: flex;*/
    /*}*/

    /*table tr td, table tr th {*/
    /*    flex: 1;*/
    /*}*/

    /*.carInfo ul {*/
    /*    border: 1px solid black*/
    /*}*/

    /*.carInfo ul, .carInfo ul li {*/
    /*    display: flex;*/
    /*    align-items: center;*/
    /*    gap: 20px;*/
    /*}*/

    /*.content > ul {*/
    /*    display: flex;*/
    /*    flex-direction: column;*/
    /*}*/
</style>
<div class="content-container">
    <header id="tab-header">
        <h1><a class="on" href="${pageContext.request.contextPath}/reserve/manageVehicle">차량 관리</a></h1>
        <h1><a href="${pageContext.request.contextPath}/reserve/loadVehicle">예약 관리</a></h1>
    </header>
    <div class="cardWrap">
        <div class="card card-df grid-card">
            <div class="header">
                <h2 class="font-b font-24">오늘 예약 현황</h2>
                <c:set var="reservedList" value="${todayReservedVehicles}"/>
                <c:set var="listSize" value="${fn:length(reservedList)}"/>
                <p class="current-resve">
                    <a href="${pageContext.request.contextPath}/reserve/loadVehicle" class="totalResve font-18 font-md"><span class="font-md font-36 count">${listSize}</span>건</a>
                </p>
                <a href="${pageContext.request.contextPath}/reserve/loadVehicle" class="more font-11 font-md">더보기 <i class="icon i-arr-rt" style="fill: red"></i></a>
            </div>
            <div class="content">
                <div class="table-container">
                    <table border="1">
                        <thead>
                        <tr>
                            <th>순번</th>
                            <th>차량 번호</th>
                            <th>시작 시간</th>
                            <th>끝 시간</th>
                            <th>예약 사원(사번)</th>
                            <th></th>
                        </tr>
                        </thead>
                        <tbody>
                        <c:forEach var="vehicleVO" items="${todayReservedVehicles}">
                            <tr>
                                <td>${vehicleVO.vhcleResveNoRedefine}</td>
                                <td>${vehicleVO.vhcleNo}</td>
                                <c:set var="beginTimeStr" value="${vehicleVO.vhcleResveBeginTime}"/>
                                <fmt:formatDate value="${beginTimeStr}" pattern="HH:mm" var="beginTime"/>
                                <td>${beginTime}</td>
                                <c:set var="endTimeStr" value="${vehicleVO.vhcleResveEndTime}"/>
                                <fmt:formatDate value="${endTimeStr}" pattern="HH:mm" var="endTime"/>
                                <td>${endTime}</td>
                                <td>${vehicleVO.vhcleResveEmplNm}(${vehicleVO.vhcleResveEmplId})</td>
                                <td>
                                    <c:if test="${vehicleVO.vhcleResveReturnAt == 'N'}">
                                        <button class="returnCarBtn" id="\${params.value}">반납 확인</button>
                                        <p class="btn returnStatus" style="display: none;">반납완료</p>
                                    </c:if>
                                    <c:if test="${vehicleVO.vhcleResveReturnAt == 'Y'}">
                                        <p class="returnStatus">반납완료</p>
                                    </c:if>
                                </td>
                            </tr>
                        </c:forEach>
                        </tbody>
                    </table>
                </div>
            </div>
        </div>

        <div class="card card-df grid-card">
            <div class="header" id="vehicles">
                <div class="titleWrap">
                    <h3 class="manage-header font-b font-24">등록된 차량</h3>
                    <c:set var="vehicleList" value="${allVehicles}"/>
                    <c:set var="listSize" value="${fn:length(vehicleList)}"/>
                    <p><span class="font-md font-36 count">${listSize}</span>건</p>
                </div>
                <div class="btnWrap">
                    <button class="btn btn-fill-bl-sm"><a class="font-18 font-md font-wh" href="/reserve/inputVehicle">차량 등록 +</a></button>
                </div>
            </div>
            <div class="content">
                <ul>
                    <c:forEach var="vehicle" items="${allVehicles}">
                        <li>
                            <div class="carInfo">
                                <ul>
                                    <li class="carInfoList">
                                        <i class="icon i-vehicle"></i>
                                        <h4>${vehicle.vhcleVhcty}</h4>
                                        <span>${vehicle.vhcleNo}</span>
                                    </li>
                                    <li class="carInfoList">
                                        <h5>정원</h5>
                                        <span>${vehicle.vhclePsncpa}명</span>
                                    </li>
                                    <li class="carInfoList">
                                        <h5>하이패스</h5>
                                        <span>${vehicle.commonCodeHipassAsnAt}</span>
                                    </li>
                                </ul>
                            </div>
                        </li>
                    </c:forEach>
                </ul>
            </div>
        </div>
    </div>
</div>
<script>
    let btnReturn = document.querySelectorAll(".returnCarBtn");
    let returnStatus = document.querySelector(".returnStatus");

    function modifyReturnAt() {
        let vhcleResveNo = rowData.pop().chk;
        let xhr = new XMLHttpRequest();
        xhr.open("put", "/reserve/return", true);
        xhr.onreadystatechange = () => {
            if (xhr.status == 200 && xhr.readyState == 4) {
                if (xhr.responseText == 1) {
                    this.btnReturn.style.display = 'none';
                    this.returnStatus.style.display = 'block';
                }
            }
        }
        xhr.send(vhcleResveNo);
    }
</script>