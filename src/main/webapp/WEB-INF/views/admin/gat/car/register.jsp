<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<link rel="stylesheet" href="${pageContext.request.contextPath}/resources/css/admin/registerVehicle.css">
<div class="content-container">
    <header id="tab-header">
        <h1><a class="on" href="${pageContext.request.contextPath}/reserve/manageVehicle">차량 관리</a></h1>
        <h1><a href="${pageContext.request.contextPath}/reserve/loadVehicle">예약 관리</a></h1>
    </header>
    <div class="cardWrap">
        <div class="card-title card-df">
            <h2 class="font-md font-18 color-font-md">차량 등록</h2>
        </div>
        <div class="card card-df grid-card">
            <form action="${pageContext.request.contextPath}/reserve/inputVehicle" method="post">
                <table border="1">
                    <tr>
                        <th class="font-md font-18 color-font-high">차량 번호</th>
                        <td><input class="input" type="text" name="vhcleNo" id="vhcleNo" placeholder="차량 번호"></td>
                    </tr>
                    <tr>
                        <th class="font-md font-18 color-font-high">차종</th>
                        <td><input class="input" type="text" name="vhcleVhcty" id="vhcleVhcty" placeholder="차종"></td>
                    </tr>
                    <tr>
                        <th class="font-md font-18 color-font-high">차량 정원</th>
                        <td><input class="input" type="number" name="vhclePsncpa" id="vhclePsncpa" placeholder="정원"></td>
                    </tr>
                    <tr>
                        <th class="font-md font-18 color-font-high">하이패스 부착 여부</th>
                        <td>
                            <input type="radio" name="commonCodeHipassAsnAt" id="HIPASS010" class="checkbox-hipass" value="HIPASS010">
                            <label class="label-radio font-14" for="HIPASS010">부착</label>
                            <input type="radio" name="commonCodeHipassAsnAt" id="HIPASS011" class="checkbox-hipass" value="HIPASS011">
                            <label class="label-radio font-14" for="HIPASS011">미부착</label>
                        </td>
                    </tr>
                </table>
                <div class="button-wrap">
                    <button class="btn btn-fill-bl-sm font-14 font-md">등록하기</button>
                </div>
            </form>
        </div>
    </div>
</div>