<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<link rel="stylesheet" href="${pageContext.request.contextPath}/resources/css/employee/reservation.css">

<div class="content-container">
    <header id="tab-header">
        <h1><a href="${pageContext.request.contextPath}/facility/meeting">회의실 예약</a></h1>
        <h1><a href="${pageContext.request.contextPath}/facility/rest" class="on">자리 예약</a></h1>
        <h1><a href="${pageContext.request.contextPath}/facility/vehicle">차량 예약</a></h1>
    </header>

    <div class="reserve-wrap">
        <div class="left">
            <div class="content">
                <div class="roomInfo rest">
                    <div class="restType">
                        <c:forEach var="bed" items="${bedList}">
                            <button type="button" onclick="setRoomNumber(this);loadReservedList(this);"
                                    class="reserve-btn rest-btn card-df"><i class="icon icon-heart"></i>
                                <h3 class="no facility-no">${bed.commonCodeFcltyKind}</h3></button>
                        </c:forEach>
                    </div>
                    <div class="restType">
                        <c:forEach var="sofa" items="${sofaList}">
                            <button type="button" onclick="setRoomNumber(this);loadReservedList(this);"
                                    class="reserve-btn rest-btn card-df"><i class="icon icon-sofa"></i>
                                <h3 class="no facility-no">${sofa.commonCodeFcltyKind}</h3></button>
                        </c:forEach>
                    </div>
                </div>

            </div>
        </div>
        <div class="right">
            <div id="reserveBox" class="card-df rest">
                <input type="hidden" name="facltyNo" id="facltyNo"/>
                <h3 id="today"></h3>
                <p id="time"></p>
                <p>🕐 대여시간</p>
                <div class="reserve-time">
                    <select name="selectResveBeginTime" id="selectResveBeginTime" class="btn-fill-wh-sm select-time ">
                        <option value="9:00" selected>9:00</option>
                        <option value="10:00">10:00</option>
                        <option value="11:00">11:00</option>
                        <option value="12:00">12:00</option>
                        <option value="13:00">13:00</option>
                        <option value="14:00">14:00</option>
                        <option value="15:00">15:00</option>
                        <option value="16:00">16:00</option>
                        <option value="17:00">17:00</option>
                        <option value="18:00">18:00</option>
                    </select>
                </div>
                <p>🕒 반납시간</p>
                <div class="reserve-time">
                    <select name="selectResveEndTime" id="selectResveEndTime" class="btn-fill-wh-sm select-time "
                            required>
                        <option value="10:00" selected>10:00</option>
                        <option value="11:00">11:00</option>
                        <option value="12:00">12:00</option>
                        <option value="13:00">13:00</option>
                        <option value="14:00">14:00</option>
                        <option value="15:00">15:00</option>
                        <option value="16:00">16:00</option>
                        <option value="17:00">17:00</option>
                        <option value="18:00">18:00</option>
                        <option value="19:00">19:00</option>
                        <option value="20:00">20:00</option>
                        <option value="21:00">21:00</option>
                        <option value="22:00">22:00</option>
                    </select>
                </div>
                <div class="btn-wrap">
                    <button onclick="createReservation()" type="button" class="btn btn-fill-bl-sm submit-btn">예약하기
                    </button>
                </div>
            </div>
            <div id="myReserve" class="card-df">
                <div id="myReserveList">


                </div>
            </div>
        </div>
    </div>
</div>
<script>
    //날짜
    let today = document.querySelector("#today");

    const currentDate = new Date();
    const year = currentDate.getFullYear();
    const month = currentDate.getMonth() + 1;
    const day = currentDate.getDate();
    const now = `\${year}/\${month}/\${day}`;
    const daysOfWeek = ["일", "월", "화", "수", "목", "금", "토"];
    const dayOfWeek = daysOfWeek[currentDate.getDay()];

    let todayCode = `🗓️ \${month}.\${day}(\${dayOfWeek})`;
    today.innerText = todayCode;

    loadMyReserveList()

    $(".reserve-btn").on("click", function () {
        $(".reserve-btn").removeClass("btn-on");
        $(this).addClass("btn-on");
    })

    const selectResveBeginTime = document.getElementById("selectResveBeginTime");

    //좌석 번호
    function setRoomNumber(seat) {
        restNo = $(seat).find("h3").html();
        $("#facltyNo").attr("value", restNo);
    }

    // function goReservation() {
    //     if (reserveBox.style.display === "none") {
    //         reserveBox.style.display = "block";
    //         myReserveList.style.display = "none";
    //     }
    // }
    //
    // function getMyReserveList() {
    //     if (myReserveList.style.display === "none") {
    //         myReserveList.style.display = "block";
    //         reserveBox.style.display = "none";
    //         loadMyReserveList();
    //     }
    // }

    function loadReservedList(seat) {
        roomNo = $(seat).find("h3").html();
        let xhr = new XMLHttpRequest();
        xhr.open("get", `/facility/rest/reserved/\${roomNo}`, true);
        xhr.setRequestHeader("ContentType", "application/json;charset=utf-8");
        xhr.onreadystatechange = function () {
            if (xhr.status == 200 && xhr.readyState == 4) {
                const selectBeginTimeList = selectResveBeginTime.querySelectorAll('option');
                for (let i = 0; i < selectBeginTimeList.length; i++) {
                    selectBeginTimeList[i].removeAttribute("disabled");
                }
                let result = JSON.parse(xhr.responseText);
                for (let i = 0; i < result.length; i++) {
                    const reservedDate = new Date(result[i].fcltyResveBeginTime);
                    let reservedYear = reservedDate.getFullYear();
                    let reservedMonth = reservedDate.getMonth() + 1;
                    let reservedDay = reservedDate.getDate();
                    let reservedTime = reservedDate.getHours();

                    const reservedStr = `\${reservedYear}/\${reservedMonth}/\${reservedDay}`;
                    for (let j = 0; j < selectBeginTimeList.length; j++) {
                        let selectBeginTime = selectBeginTimeList[j].value;
                        let selectBeginHour = selectBeginTime.substring(0, selectBeginTime.indexOf(":"));
                        if (reservedStr == now && reservedTime == selectBeginHour) {
                            let option = selectResveBeginTime.querySelector(`option[value='\${selectBeginTime}']`);
                            option.disabled = true;
                        }
                    }
                }
            }
        }
        xhr.send(roomNo);
    }

    function loadMyReserveList(seat) {
        restNo = $(seat).find("h3").html();
        let tableStr = `<h2 class="table-title">내 예약 현황</h2><table border=1 class="reserve-table"><thead><tr><th>휴게실 번호</th><th>예약시간</th><th>취소</th></tr></thead><tbody>`;
        let xhr = new XMLHttpRequest();
        xhr.open("get", "/facility/rest/myReservations", true);
        xhr.onreadystatechange = function () {
            if (xhr.readyState == 4 && xhr.status == 200) {
                let myReservedList = JSON.parse(xhr.responseText);
                if (myReservedList.length > 0) {
                    for (let i = 0; i < myReservedList.length; i++) {
                        let beginHour = new Date(myReservedList[i].fcltyResveBeginTime).getHours().toString() + ":00";
                        let endHour = new Date(myReservedList[i].fcltyResveEndTime).getHours().toString() + ":00";
                        let newTr = document.createElement("tr");
                        tableStr += `
                            <tr>
                                <td>\${myReservedList[i].commonCodeFcltyKind}</td>
                                <td>\${beginHour} - \${endHour}</td>
                                <td><button onclick="cancelReservation('\${myReservedList[i].fcltyResveSn}')" class="btn btn-out-sm cancelBtn">취소</button></td>
                             </tr>`;
                    }
                } else {
                    tableStr += '<tr><td colspan="3">예약 내역이 없습니다.</td></tr>'
                }

                tableStr += '</tbody></table>'
                document.querySelector("#myReserveList").innerHTML = tableStr;
            }

        }
        xhr.send();
    }

    $(".reserve-btn").on("click", function () {
        $(".reserve-btn").removeClass("btn-on");
        $(this).addClass("btn-on");
    })

    function createReservation() {
        let $selectResveBeginTime = $("select[name='selectResveBeginTime'] option:selected").val();
        $selectResveBeginTime = new Date(`\${now} \${$selectResveBeginTime}`);
        let $selectResveEndTime = $("select[name='selectResveEndTime'] option:selected").text();
        $selectResveEndTime = new Date(`\${now} \${$selectResveEndTime}`);

        let facilityVO = {
            fcltyResveBeginTime: $selectResveBeginTime,
            fcltyResveEndTime: $selectResveEndTime,
            commonCodeFcltyKind: $("input[name='facltyNo']").val(),
            commonCodeResveAt: 'RESVE011',
            fcltyResveRequstMatter: ""
        }

        $.ajax({
            url: "/facility/room",
            type: "post",
            data: JSON.stringify(facilityVO),
            contentType: "application/json;charset=utf-8",
            dataType: 'json',
            success: function (result) {
                if (result) {
                    Swal.fire({
                        text: '예약이 완료되었습니다',
                        showConfirmButton: false,
                        timer: 1500
                    })
                    loadMyReserveList();
                }
            },
            error: function (xhr, status, error) {
                console.log("code: " + xhr.status);
                console.log("message: " + xhr.responseText);
                console.log("error: " + xhr.error);
                if (xhr.responseText === "fcltyKind is null") {
                    Swal.fire({
                        text: '좌석을 선택해주세요',
                        showConfirmButton: false,
                        timer: 1500
                    })
                } else if (xhr.responseText === "beginTime is null") {
                    Swal.fire({
                        text: '대여시간을 선택해주세요',
                        showConfirmButton: false,
                        timer: 1500
                    })
                } else if (xhr.responseText === "endTime is null") {
                    Swal.fire({
                        text: '반납시간을 선택해주세요',
                        showConfirmButton: false,
                        timer: 1500
                    })
                }

                if (xhr.responseText === "same time") {
                    Swal.fire({
                        text: '대여시간과 반납시간을 다르게 선택해주세요',
                        showConfirmButton: false,
                        timer: 1500
                    })
                } else if (xhr.responseText === "end early than begin") {
                    Swal.fire({
                        text: '반납시간이 대여시간보다 이르게 선택되었습니다 다시 시도해주세요',
                        showConfirmButton: false,
                        timer: 1500
                    })
                }
            }
        });
    }

    function cancelReservation(fcltyResveSn) {
        $.ajax({
            url: `/facility/\${fcltyResveSn}`,
            type: "delete",
            dataType: 'json',
            success: function (result) {
                loadMyReserveList();
            },
            error: function (xhr, status, error) {
                console.log("code: " + xhr.status);
                console.log("message: " + xhr.responseText);
                console.log("error: " + xhr.error);
            }
        });
    }
</script>
