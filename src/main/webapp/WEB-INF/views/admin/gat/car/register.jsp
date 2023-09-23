<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<style>
    ul {
        list-style: none;
        padding-left: 0;
    }

    .wrap ul {
        display: flex;
        gap: 10px
    }

    input[type=text], input[type=number] {
        width: 95%
    }
</style>
<div class="content-container">
    <div class="wrap">
        <ul>
            <li><a href="/reserve/manageVehicle" class="tab">차량 관리</a></li>
            <li><a href="/reserve/loadVehicle" class="tab">예약 현황</a></li>
        </ul>
    </div>
    <div class="cardWrap">
        <div class="cardTitle">
            <h2>차량 등록</h2>
        </div>
        <div class="card">
            <form action="${pageContext.request.contextPath}/reserve/inputVehicle" method="post">
                <table border="1" style="width: 100%">
                    <tr>
                        <th>차량 번호</th>
                        <td><input type="text" name="vhcleNo" id="vhcleNo"></td>
                    </tr>
                    <tr>
                        <th>차종</th>
                        <td><input type="text" name="vhcleVhcty" id="vhcleVhcty"></td>
                    </tr>
                    <tr>
                        <th>차량 정원</th>
                        <td><input type="number" name="vhclePsncpa" id="vhclePsncpa"></td>
                    </tr>
                    <tr>
                        <th>하이패스 부착 여부</th>
                        <td style="display: flex; gap: 24px;">
                            <div>
                                <input type="radio" name="commonCodeHipassAsnAt" id="HIPASS010" value="HIPASS010"
                                       checked>
                                <label for="HIPASS010">부착</label>
                            </div>
                            <div>
                                <input type="radio" name="commonCodeHipassAsnAt" id="HIPASS011" value="HIPASS011">
                                <label for="HIPASS011">미부착</label>
                            </div>
                        </td>
                    </tr>
                </table>
                <button>등록하기</button>
            </form>
        </div>
    </div>
</div>