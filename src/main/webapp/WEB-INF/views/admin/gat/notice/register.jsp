<%@ taglib prefix="sec"
		   uri="http://www.springframework.org/security/tags"%>
<%@ page contentType="text/html;charset=UTF-8" language="java"%>
<script src="/resources/ckeditor/ckeditor.js"></script>
<link rel="stylesheet"
	  href="/resources/css/admin/manageNoticeRegister.css">
<div class="content-container">
	<header id="tab-header">
		<h1><a href="${pageContext.request.contextPath}/notice/manage" class="on">공지사항 관리</a></h1>
	</header>

	<div class="noticeRegisterTitle bg-wht">
		<p class="noticeRegisterTitleName color-font-md">공지사항 등록</p>
	</div>

	<div class="noticeCard card-df">
		<form action="#" method="post" enctype="multipart/form-data" id="uploadForm">

			<div class="notiDiv">
				<label class="font-md font-18" for="noti-category">공지사항 분류</label>
				<div class="select-wrapper">
					<select name="notiCtgryIconFileStreNm" id="noti-category" class="selectBox">
						<option value="important.png">중요</option>
						<option value="notice.png">공지</option>
						<option value="event.png">행사</option>
						<option value="obituary.png">부고</option>
					</select><br>
				</div>
			</div>
			<hr>
			<div class="notiDiv">
				<label class="font-md font-18" for="noti-title">제목</label>
				<input type="text" name="notiTitle" id="noti-title" required><br/>
			</div>
			<hr>
			<div class="notiDiv">
				<label class="font-md font-18" for="noti-file">파일 </label>
				<input type="file" name="notiFiles" id="noti-file" multiple><br/>
			</div>
			<hr>
			<div class="notiDiv">
				<label class="notiContentText font-md font-18" for="noti-content">내용</label>
				<textarea cols="50" rows="10" name="notiContent" id="noti-content" required></textarea>
			</div>
			<br><br>
			<div class="divButton">
				<button type="button" class="btn-fill-bl-sm" id="submitBtn">등록하기</button>
			</div>
		</form>
	</div>
</div>
<script>
	let editor = CKEDITOR.replace("noti-content");
	let maxNum;

	$("#submitBtn").on("click", function () {
		let form = $('#uploadForm')[0];
		let formData = new FormData(form);
		formData.append("notiContent", editor.getData());

		$.ajax({
			url: "/notice/input",
			type: 'POST',
			data: formData,
			// dataType: 'text',
			contentType: false,
			processData: false,
			<%--beforeSend : function(xhr) {--%>
			<%--	xhr.setRequestHeader("${_csrf.headerName}","${_csrf.token}");--%>
			<%--},--%>
			success: function (notiEtprCode) {
				// 최대 알람 번호 가져오기
				$.get("/alarm/getMaxAlarm")
						.then(function (maxNum) {
							maxNum = parseInt(maxNum) + 1;

							let url = '/notice/detail/' + notiEtprCode;
							let content = `<div class="alarmListBox">
										<a href="\${url}" class="aTag" data-seq="\${maxNum}">
											<h1>[전체공지]</h1>
											<div class="alarm-textbox">
												<p>관리자로부터 전체 공지사항이 등록되었습니다.</p>
											</div>
										</a>
										<button type="button" class="readBtn">읽음</button>
									</div>`;

							let alarmVO = {
								"ntcnSn": maxNum,
								"ntcnUrl": url,
								"ntcnCn": content,
								"commonCodeNtcnKind": 'NTCN013'
							};

							// 알림 생성 및 페이지 이동
							$.ajax({
								type: 'post',
								url: '/alarm/insertAlarm',
								data: alarmVO,
								success: function (rslt) {
									if (socket) {
										let msg = maxNum + ",noti," + url;
										socket.send(msg);
									}
									location.href = "/notice/manage";
								},
								error: function (xhr) {
									console.log(xhr.status);
								}
							});
						})
						.catch(function (error) {
							console.log("최대 알람 번호 가져오기 오류:", error);
						});
			},
			error: function (xhr) {
				console.log(xhr.status)
			}
		})
	});

</script>