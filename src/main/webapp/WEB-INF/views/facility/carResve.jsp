<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%--<%@ page pageEncoding="UTF-8" %>--%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<link rel="stylesheet" href="${pageContext.request.contextPath}/resources/css/employee/reservation.css">

<style>
	.btn-out-sm {
		width: 50px!important; 
		height: var(--vh-32)!important; 
		background-color: var(--color-white)!important; 
		border-radius: var(--size-32)!important; 
		border: 1px solid var(--color-main)!important;  
		color: var(--color-main)!important; 
		outline-color: var(--color-main)!important;
        margin-top: 4px;
	}
	
	.btn-out-sm:hover {
		background-color: var(--color-main)!important; 
		color: white!important;
	}
	
	.btn-fill-wh-sm {
	    width: 100%!important;
	    height: var(--vh-64)!important;
	    background-color: var(--color-white)!important;
	    border-radius: var(--size-32)!important;
	    border: 1px solid var(--color-stroke)!important;
	    box-shadow: var(--clay-card)!important;
	    outline-color: var(--color-main)!important;
	    color: var(--color-main)!important;
	}
	
	.submit-btn {
   		width: 90%!important;
    	margin-top: var(--vw-24)!important;
    	font-size: var(--font-size-14)!important;
	}
	
	.btn-on {
	    background-color: var(--color-main)!important;
	    border: 1px solid var(--color-stroke)!important;
	    box-shadow: var(--clay-btn)!important;
	    outline-color: var(--color-main)!important;
	    color: white!important;
	}
</style>

<div class="content-container">
    <header id="tab-header">
        <h1><a href="${pageContext.request.contextPath}/facility/meeting">회의실 예약</a></h1>
        <h1><a href="${pageContext.request.contextPath}/facility/rest">자리 예약</a></h1>
        <h1><a href="${pageContext.request.contextPath}/facility/vehicle" class="on">차량 예약</a></h1>
    </header>
    <div class="reserve-wrap">
        <div class="left">
            <div class="content">
                <div class="roomInfo rest">
                    <c:forEach var="vehicleVO" items="${vehicles}">
                        <button type="button" onclick="setRoomNumber(this); loadReservedList(this);"
                                class="reserve-btn car-btn card-df">
                            <div class="carInfo">
                                <i class="icon icon-car"></i>
                                <div class="car-div">
                                    <div class="carNum">
                                        <h3>${vehicleVO.vhcleVhcty}</h3>
                                        <p class="no">${vehicleVO.vhcleNo}</p>
                                    </div>
                                    <div class="carDetail" style="display: flex">
                                        <h4>하이패스</h4>
                                        <p>${vehicleVO.commonCodeHipassAsnAt}</p>
                                        <h4>인원</h4>
                                        <p><span>${vehicleVO.vhclePsncpa}</span>명</p>
                                    </div>
                                </div>
                            </div>
                        </button>
                    </c:forEach>
                </div>
            </div>
        </div>
        <div class="right">
            <div id="reserveBox" class="card-df rest">
                <input type="hidden" name="vhcleNo" id="vhcleNo"/>
                <h3 id="today"></h3>
                <p id="time"></p>
                <p>🕐 대여시간</p>
                <div class="reserve-time">
                    <select name="selectVhcleResveBeginTime" id="selectVhcleResveBeginTime"
                            class="btn-fill-wh-sm select-time ">
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

                    <select name="selectVhcleResveEndTime" id="selectVhcleResveEndTime"
                            class="btn-fill-wh-sm select-time " required>
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
                <div id="myReserveList"></div>
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

    $(".reserve-btn").on("click", function () {
        $(".reserve-btn").removeClass("btn-on");
        $(this).addClass("btn-on");
    })

    $(function () {
        loadMyReserveList()
    })

    //차량 번호
    function setRoomNumber(vhcle) {
        vhcleNo = $(vhcle).find(".no").html();
        $("#vhcleNo").attr("value", vhcleNo);
    }

    const selectVhcleResveBeginTime = document.getElementById("selectVhcleResveBeginTime");

    function loadReservedList(vhcle) {
        vhcleNo = $(vhcle).find(".no").html();
        let xhr = new XMLHttpRequest();
        xhr.open("get", `/facility/vehicle/reserved/\${vhcleNo}`, true);
        xhr.setRequestHeader("ContentType", "application/json;charset=utf-8");
        xhr.onreadystatechange = function () {
            if (xhr.status == 200 && xhr.readyState == 4) {
                const selectBeginTimeList = selectVhcleResveBeginTime.querySelectorAll('option');
                for (let i = 0; i < selectBeginTimeList.length; i++) {
                    selectBeginTimeList[i].removeAttribute("disabled");
                }
                let result = JSON.parse(xhr.responseText);
                for (let i = 0; i < result.length; i++) {
                    const reservedDate = new Date(result[i].vhcleResveBeginTime);
                    let reservedYear = reservedDate.getFullYear();
                    let reservedMonth = reservedDate.getMonth() + 1;
                    let reservedDay = reservedDate.getDate();
                    let reservedTime = reservedDate.getHours();

                    const reservedStr = `\${reservedYear}/\${reservedMonth}/\${reservedDay}`;
                    for (let j = 0; j < selectBeginTimeList.length; j++) {
                        let selectBeginTime = selectBeginTimeList[j].value;
                        let selectBeginHour = selectBeginTime.substring(0, selectBeginTime.indexOf(":"));
                        if (reservedStr == now && reservedTime == selectBeginHour) {
                            let option = selectVhcleResveBeginTime.querySelector(`option[value='\${selectBeginTime}']`);
                            option.disabled = true;
                        }
                    }
                }
            }
        }
        xhr.send(vhcleNo);
    }

    const myReserveList = document.querySelector("#myReserveList");
    const reserveBox = document.querySelector("#reserveBox");

    // function getMyReserveList() {
    //     if (myReserveList.style.display === "none") {
    //         // myReserveList.style.display = "block";
    //         // reserveBox.style.display = "none";
    //         loadMyReserveList();
    //     }
    // }

    function loadMyReserveList() {
        let tableStr = `<h2 class="table-title">내 예약 현황</h2><table border=1 class="reserve-table"><thead><tr><th>차 번호</th><th>예약시간</th><th>취소</th></tr></thead><tbody>`;
        let xhr = new XMLHttpRequest();
        xhr.open("get", "/facility/vehicle/myReservations", true);
        xhr.onreadystatechange = function () {
            if (xhr.readyState == 4 && xhr.status == 200) {
                let myReservedList = JSON.parse(xhr.responseText);
                if (myReservedList.length > 0) {
                    for (let i = 0; i < myReservedList.length; i++) {
                        let beginHour = new Date(myReservedList[i].vhcleResveBeginTime).getHours().toString() + ":00";
                        let endHour = new Date(myReservedList[i].vhcleResveEndTime).getHours().toString() + ":00";
                        let newTr = document.createElement("tr");

                        tableStr += `
                            <tr>
                                <td>\${myReservedList[i].vhcleNo}</td>
                                <td>\${beginHour} - \${endHour}</td>
                                <td><button onclick="cancelReservation('\${myReservedList[i].vhcleResveNo}')" class="btn btn-out-sm cancelBtn">취소</button></td>
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

    // function goReservation() {
    //     if (reserveBox.style.display === "none") {
    //         // reserveBox.style.display = "block";
    //         // myReserveList.style.display = "none";
    //     }
    // }

    function createReservation() {
        let $vhcleResveBeginTime = $("select[name='selectVhcleResveBeginTime'] option:selected").val();
        $vhcleResveBeginTime = new Date(`\${now} \${$vhcleResveBeginTime}`);
        let $vhcleResveEndTime = $("select[name='selectVhcleResveEndTime'] option:selected").text();
        $vhcleResveEndTime = new Date(`\${now} \${$vhcleResveEndTime}`);

        let vehicleVO = {
            vhcleResveBeginTime: $vhcleResveBeginTime,
            vhcleResveEndTime: $vhcleResveEndTime,
            vhcleNo: $("input[name='vhcleNo']").val(),
            commonCodeResveAt: 'RESVE011',
            vhcleResveReturnAt: 'N'
        }

        $.ajax({
            url: "/facility/vehicle",
            type: "post",
            data: JSON.stringify(vehicleVO),
            contentType: "application/json;charset=utf-8",
            dataType: 'json',
            success: function (result) {
                if (result) {
                    Swal.fire({
                        text: '예약이 완료되었습니다 총무팀에서 차키를 받을 수 있습니다',
                        showConfirmButton: false,
                        timer: 1500
                    })
                    loadMyReserveList()
                }
            },
            error: function (xhr, status, error) {
                console.log("code: " + xhr.status);
                console.log("message: " + xhr.responseText);
                console.log("error: " + xhr.error);
                if (xhr.responseText === "vhcleNo is null") {
                    Swal.fire({
                        text: '차량을 선택해주세요',
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
                        text: '반납시간이 대여시간보다 이르게 선택되었습니다. 다시 시도해주세요',
                        showConfirmButton: false,
                        timer: 1500
                    })
                }
            }
        });
    }

    function cancelReservation(vhcleResveNo) {
        $.ajax({
            url: `/facility/vehicle/\${vhcleResveNo}`,
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
