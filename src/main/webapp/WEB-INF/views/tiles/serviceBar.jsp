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
	<!-- 화면에 안 보여서 div에 margin을 줬어용 번거롭게 해서 미안합니당 지우고 써주셔용!!! -->
	<section class="memoContainer">
		<!-- 리스트에서 고정할 메모 클릭하면 고정되어요~ -->
		<div class="fixed-memo">

				</div>



	</section>
  	<div class="service-tab">

	</div>

  
</div>

<script>
	getList();
  var socket = null;
  $(document).ready(function() {
    connectWs();
  });

  function connectWs() {
    // 웹소켓 연결
    sock = new SockJS("<c:url value='http://125.138.66.183:8080//echo-ws'/>");
    socket = sock;

    sock.onopen = function () {
      console.log("info: connection opened");
    };

    sock.onmessage = function(event) {
      getList();
		console.log("event.data-floating", event.data);
		let $socketAlarm = $("#aTagBox");
		$("#floatingAlarm").css("display", "block");

	$socketAlarm.html(event.data);
    }

    sock.onclose = function () {
      console.log("close");
    }

    sock.onerror = function (err) {
      console.log("ERROR: ", err);
    }
  }
document.querySelector(".alarmContainer").addEventListener("click",(e)=>{
   const target = e.target;
   if(target.classList.contains("readBtn")){
     var ntcnSn = target.previousElementSibling.getAttribute("data-seq");
     $.ajax({
       type: 'delete',
       url: '/alarm/deleteAlarm?ntcnSn=' + ntcnSn,
       success: function () {
         target.parentElement.remove();
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
      console.log(list);
      $(".alarm-area").empty();
      for (let i = 0; i < list.length; i++) {
        $(".alarm-area").append(list[i].ntcnCn);
      }
    }
  });
}

	$(document).ready(function() {
		$("td.fixMemoCn").on("click", function() {
			let number = $(this).closest("tr").data("fix-memo-sn");
			let memoSn = parseInt(number, 10);

			console.log(memoSn);

			$.ajax({
				type: 'put',
				url: '/alarm/noFix/' + memoSn,
				success: function(res) {
					$("#memoTitleData").text(null);

					$("#memoDetailDataTitle").text(null);
					$("#memoDetailDataContent").text(null);
					$("#memoDetailDataDate").text(null);
				}
			});
		});

		$("td.memoCn").on("click", function() {
			let number = $(this).closest("tr").data("memo-sn");
			let memoSn = parseInt(number, 10);

			console.log(memoSn);

			$.ajax({
				type: 'put',
				url: '/alarm/updateMemoAlarm/' + memoSn,
				success: function(res) {
					$.ajax({
						type: 'get',
						url: '/alarm/updateMemoAlarm/' + memoSn,
						success: function(data) {
							let memoDate = data.memoWrtngDate;
							let date = new Date(memoDate);
							let formattedDate = date.getFullYear() + '-' + ('0' + (date.getMonth() + 1)).slice(-2) + '-' + ('0' + date.getDate()).slice(-2);

							$("#memoTitleData").text(data.memoCn);

							$("#memoDetailDataTitle").text(data.memoSj);
							$("#memoDetailDataContent").text(data.memoCn);
							$("#memoDetailDataDate").text(formattedDate);

							$("#memoTitleData").on("click", function() {
								let memoSn = data.memoSn;

								$("tr[data-fix-memo-sn]").attr("data-fix-memo-sn", memoSn);

								$.ajax({
									type: 'put',
									url: '/alarm/noFix/' + memoSn,
									success: function(res) {
										$("#memoTitleData").text(null);
										$("#memoDetailDataTitle").text(null);
										$("#memoDetailDataContent").text(null);
										$("#memoDetailDataDate").text(null);
									}
								});
							});
						}
					});
				}
			});
		});

		$.ajax({
			url: `/alarm/all`,
			type: 'GET',
			success: function (map) {
				let code = "";
				code += `
                <div class="flip-memo front">
                    <p id="memoDetailDataTitle">\${map.memoVO.memoSj}</p>
                    <p id="memoDetailDataContent">\${map.memoVO.memoCn}</p>
                    <p id="memoDetailDataDate">\${map.memoVO.memoWrtngDate}</p>
                </div>
                <div class="no-memo front">
                    <button id="addMemo" class="btn"></button>
                </div>
                <div class="no-memo front">
                    <button id="addMemo" class="btn"></button>
                </div>
                <div id="memoTitleData">
                    <div data-fix-memo-sn="\${map.memoVO.memoSn}">
                        <td class="fixMemoCn">\${map.memoVO.memoCn}</td>
                    </div>
                </div>`;

				map.list.forEach(item => {
					code += `
                <div data-memo-sn="\${item.memoSn}">
                    <div class="memoCn">\${item.memoCn}</div>
                </div>`;
				});

				console.log(code);
			}
		});
	});
  const serviceTab = document.querySelector(".service-tab");
  const alarmWrapper = document.querySelector(".alarmWrapper");

  serviceTab.addEventListener("click", function() {
	  alarmWrapper.classList.toggle("on");
  });

  /*	메[모	*/
	/*const addMemoBtn = document.querySelector("#addMemo");
  addMemoBtn.addEventListener("click".function(){

  })*/

</script>