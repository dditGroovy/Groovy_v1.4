<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>

<link href="${pageContext.request.contextPath}/resources/css/alarm/alarm.css" rel="stylesheet"/>
<div class="alarmWrapper">
    <section class="alarmContainer">
        <h2 class="alarm-title">알림</h2>
        <header id="alarm-header">
            <a href="/employee/confirm/info" class="setting"><i class="icon i-setting"></i>알림 관리</a>
            <button id="allReadAlarm" class="btn">모두 읽기</button>
        </header>
        <div class="alarm-area"></div>
    </section>
    <section class="memoContainer">
        <div class="fixed-memo"></div>
    </section>
    <div class="service-tab">

    </div>


</div>

<script>
    getList();
    var socket = null;
    $(document).ready(function () {
        connectWs();
    });

    function connectWs() {
        // 웹소켓 연결
        sock = new SockJS("/echo-ws");
        socket = sock;

        sock.onmessage = function (event) {
            getList();
            let $socketAlarm = $("#aTagBox");
            $("#floatingAlarm").addClass("on");
            setTimeout(function () {
                $("#floatingAlarm").removeClass("on");
            }, 3000);

            $socketAlarm.html(event.data);
        }

        sock.onerror = function (err) {
            console.log("ERROR: ", err);
        }
    }

    document.querySelector(".alarmContainer").addEventListener("click", (e) => {
        const target = e.target;
        if (target.classList.contains("readBtn")) {
            var ntcnSn = target.previousElementSibling.getAttribute("data-seq");
            $.ajax({
                type: 'delete',
                url: '/alarm/deleteAlarm?ntcnSn=' + ntcnSn,
                success: function () {
                    target.parentElement.remove();
                    getList();
                },
                error: function (xhr) {
                    xhr.status;
                }
            });

        }
    })

    function getList() {
        $.ajax({
            type: 'get',
            url: '/alarm/getAllAlarm',
            dataType: 'json',
            success: function (list) {
                $(".alarm-area").empty();
                $(".alarm-area").removeClass("alarmListBox");
                if (list.length == 0) {
                    $(".alarm-area").addClass("alarmListBox");
                    $(".alarm-area").html("<p class='font-11 none-alarm color-font-md'>최근 알림내역이 없습니다.</p>");
                } else {
                    for (let i = 0; i < list.length; i++) {
                        $(".alarm-area").append(list[i].ntcnCn);
                    }
                }
            }
        });
    }

    document.querySelector("#allReadAlarm").addEventListener("click", () => {
        $.ajax({
            type: 'delete',
            url: '/alarm/deleteAllAlarm',
            success: function () {
                getList();
            },
            error: function (xhr) {
                console.log(xhr.status);
            }
        })
    })

    $(document).ready(function () {
        $(".fixed-memo").on("click", ".fixMemoCn", function () {
            let number = $(this).parent("div").attr("data-fix-memo-sn");
            let memoSn = parseInt(number, 10);

            $.ajax({
                type: 'put',
                url: '/alarm/noFix/' + memoSn,
                success: function (res) {
                    $("#memoTitleData").text(null);
                    $("#memoDetailDataTitle").text(null);
                    $("#memoDetailDataContent").text(null);
                    $("#memoDetailDataDate").text(null);
                    $(".fixed-memo").removeClass("on");

                    loadAllMemo();

                }
            });
        });

        $(".fixed-memo").on("click", ".memoCn", function () {
            let number = $(this).parent("div").attr("data-memo-sn");
            let memoSn = parseInt(number, 10);
            const target = $(this);
            $.ajax({
                type: 'put',
                url: '/alarm/updateMemoAlarm/' + memoSn,
                success: function (res) {
                    $.ajax({
                        type: 'get',
                        url: '/alarm/updateMemoAlarm/' + memoSn,
                        success: function (data) {
                            let memoDate = data.memoWrtngDate;
                            let date = new Date(memoDate);
                            let formattedDate = date.getFullYear() + '-' + ('0' + (date.getMonth() + 1)).slice(-2) + '-' + ('0' + date.getDate()).slice(-2);

                            /*$("#memoTitleData").text(data.memoCn);

                            $("#memoDetailDataTitle").text(data.memoSj);
                            $("#memoDetailDataContent").text(data.memoCn);
                            $("#memoDetailDataDate").text(formattedDate);*/

                            $(".fixMemoCn").on("click", function () {
                                let memoSn = data.memoSn;

                                $("div[data-fix-memo-sn]").attr("data-fix-memo-sn", memoSn);

                                $.ajax({
                                    type: 'put',
                                    url: '/alarm/noFix/' + memoSn,
                                    success: function (res) {
                                        $(".fixMemoCn").text(null);
                                        $("#memoDetailDataTitle").text(null);
                                        $("#memoDetailDataContent").text(null);
                                        $("#memoDetailDataDate").text(null);
                                        $(".fixed-memo").removeClass("on")
                                    }
                                });
                            });
                            /*target.on("click",function(){
                                let cn = target.text();
                                $.ajax({
                                    type: 'put',
                                    url: '/alarm/noFix/' + memoSn,
                                    success: function(res) {
                                        $(".fixMemoCn").text(cn);
                                        $(".fixed-memo").removeClass("on");
                                        loadAllMemo();
                                    }
                                });
                            })*/
                        }
                    });
                }
            });
            let cn = target.text();
            $.ajax({
                type: 'put',
                url: '/alarm/noFix/' + memoSn,
                success: function (res) {
                    $(".fixMemoCn").text(cn);
                    $(".fixed-memo").removeClass("on");
                    loadAllMemo();
                }
            });
        });

        function loadAllMemo() {
            $.ajax({
                url: `/alarm/all`,
                type: 'GET',
                success: function (map) {
                    let code = "";
                    if (map.memoVO.memoEmplId != null) {
                        code += `
					<header id="memo-header">
								<button id="settingMemo" class="btn addMemo"><i class="icon i-memo"></i>고정 메모 변경</button>
					</header>
					<div class="flip-memo fixed-memo-list front">
						<p id="memoDetailDataTitle">\${map.memoVO.memoSj}</p>
						<p id="memoDetailDataContent">\${map.memoVO.memoCn}</p>
						<p id="memoDetailDataDate">\${map.memoVO.memoWrtngDate}</p>
					</div>`;
                    } else {
                        code += `
						<div class="no-memo front">
							<button id="addMemo" class="btn addMemo"></button>
						</div>`;
                    }
                    code += `
				<div class="fixed-memo-list back">
					<div id="memoTitleData">
						<h3 class="title">고정 메모</h3>
					`;
                    if (map.memoVO.memoSn != 0) {
                        code += `
							<div data-fix-memo-sn="\${map.memoVO.memoSn}">
								<div class="fixMemoCn">\${map.memoVO.memoSj}</div>
							</div></div>`;
                    } else {
                        code += `<p class="text">고정된 메모가 없습니다.</p></div>`;
                    }
                    code += `<div class="memo-list-wrap">
						<h3 class="title">고정할 메모 선택</h3>
						<div class="memo-list">
						`;
                    if (map.list != null) {
                        map.list.forEach(item => {
                            const memoSj = item.memoSj !== null ? item.memoSj : '제목 없음';
                            code += `
						<div data-memo-sn="\${item.memoSn}">
							<div class="memoCn">\${memoSj}</div>
						</div>`
                        });
                        code += "</div></div></div>";
                    } else {
                        code += "<p class='no-data'>등록된 메모가 없습니다.</p></div></div></div>"
                    }
                    document.querySelector(".fixed-memo").innerHTML = code;
                }
            });
        }

        loadAllMemo();
    });
    const serviceTab = document.querySelector(".service-tab");
    const alarmWrapper = document.querySelector(".alarmWrapper");

    serviceTab.addEventListener("click", function () {
        alarmWrapper.classList.toggle("on");
    });

    /*	메[모	*/
    document.querySelector(".fixed-memo").addEventListener("click", e => {
        const target = e.target;
        if (target.classList.contains("addMemo")) {
            target.closest(".fixed-memo").classList.toggle("on");
        }
        ;

    })

</script>