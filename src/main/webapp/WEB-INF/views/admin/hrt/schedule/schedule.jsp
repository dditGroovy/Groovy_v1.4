<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<link href="/resources/css/schedule/calendar.css" rel="stylesheet"/>

<style>
    .modal-content {
        border: 1px solid red;
    }

    #calendar {
        margin-top: var(--vh-64);
    }

    #eventModal {
        position: fixed;
        top: 50%;
        left: 50%;
        -webkit-transform: translate(-50%, -50%);
        -moz-transform: translate(-50%, -50%);
        -ms-transform: translate(-50%, -50%);
        -o-transform: translate(-50%, -50%);
        transform: translate(-50%, -50%);
        z-index: 500;
    }

    .fc-event-time {
        display: none;
    }
</style>

<div class="content-container">

    <div class="modal fade" id="eventModal" tabindex="-1" role="dialog"
         aria-labelledby="eventModalLabel" aria-hidden="true" style="display: none;">
        <div class="modal-dialog" role="document">
            <div class="modal-content">
                <div class="modal-header">
                    <button type="button" class="close" data-dismiss="modal"
                            aria-label="Close">
                        <span aria-hidden="true">&times;</span>
                    </button>
                </div>
                <div class="modal-body">
                    <form id="eventForm">
                        <div class="form-group">
                            <label for="eventTitle"><strong>제목:</strong></label>
                            <input type="text" class="form-control" id="eventTitle" name="title">
                        </div>
                        <div class="form-group">
                            <label for="eventStart"><strong>시작 날짜:</strong></label>
                            <input type="text" class="form-control" id="eventStart" name="start">
                        </div>
                        <div class="form-group">
                            <label for="eventEnd"><strong>종료 날짜:</strong></label>
                            <input type="text" class="form-control" id="eventEnd" name="end">
                        </div>
                    </form>
                </div>
                <div class="modal-footer">
                    <button type="button" class="btn btn-primary" id="saveEvent">수정</button>
                    <button type="button" class="btn btn-primary" id="deleteEvent">삭제</button>
                </div>
            </div>
        </div>
    </div>

    <div id="calendar"></div>
</div>


<script
		src="https://ajax.googleapis.com/ajax/libs/jquery/3.6.0/jquery.min.js"></script>
<script
		src="https://cdnjs.cloudflare.com/ajax/libs/popper.js/1.16.0/umd/popper.min.js"></script>
<script
		src="https://maxcdn.bootstrapcdn.com/bootstrap/4.5.2/js/bootstrap.min.js"></script>

<script src="/resources/fullcalendar/main.js"></script>
<script src="/resources/fullcalendar/ko.js"></script>

<script>
	$(document).ready(function () {

		$("#eventModal").modal("hide");

		$(function () {
			let request = $.ajax({
				url: "/schedule/schedule",
				method: "GET",
				dataType: "json"
			});

			request.done(function (data) {
				let calendarEl = document.getElementById('calendar');
				calendar = new FullCalendar.Calendar(calendarEl, {
					height: '700px',
					slotMinTime: '08:00',
					slotMaxTime: '20:00',
					headerToolbar: {
						left: 'today prev,next',
						center: 'title',
						right: 'dayGridMonth,listWeek'
					},
					initialView: 'dayGridMonth',
					navLinks: true,
					selectable: true,
					events: data,
					locale: 'ko',
					select: function (arg) {

						let title = prompt('일정을 입력해주세요');
						if (title !== null) {
							if (title.trim() !== '') {
								calendar.addEvent({
									title: title,
									start: arg.start,
									end: arg.end,
									allDay: arg.allDay
								});
							} else {
								alert('일정이 입력되지 않았습니다');
							}
						} else {
						}

						let events = new Array();
						let obj = new Object();

						obj.title = title;
						obj.start = arg.start;
						obj.end = arg.end;
						events.push(obj);

						let jsondata = JSON.stringify(events);

						$(function saveData(jsonData) {
							$.ajax({
								url: "/schedule/schedule",
								method: "POST",
								dataType: "json",
								data: JSON.stringify(events),
								contentType: 'application/json'
							});
							location.reload();
							calendar.unselect();
						});
					},


					eventClick: function (info) {

						$("#eventModal").modal("show");

						let schdulSn = info.event.id;

						$.ajax({
							url: `/schedule/schedule/\${schdulSn}`,
							method: "GET",
							dataType: "json",
							success: function (response) {
								let schdulBeginDate = new Date(response.schdulBeginDate);
							    let schdulClosDate = new Date(response.schdulClosDate);

							    $("#eventTitle").val(response.schdulNm);
							    $("#eventStart").val(schdulBeginDate.toISOString().slice(0, 10));
							    $("#eventEnd").val(schdulClosDate.toISOString().slice(0, 10));

								$("#saveEvent").on("click", function () {

									let schdulSn = info.event.id;

									let dataType = /^[0-9]{4}-[0-9]{2}-[0-9]{2}$/;
									if (!dataType.test($('#eventStart').val()) || !dataType.test($('#eventEnd').val())) {
										alert("날짜는 2000-01-01 형식으로 입력해주세요");
										return false;
									}


									let events = new Array();
									let obj = new Object();

									obj.id = info.event.id;
									obj.title = $("#eventTitle").val();
									obj.start = $("#eventStart").val();
									obj.end = $("#eventEnd").val();

									events.push(obj);

									$.ajax({
										url: `/schedule/schedule/\${schdulSn}`,
										method: "PUT",
										dataType: "text",
										data: JSON.stringify(events),
										contentType: 'application/json',
										success: function (response) {
											if (response == "success") {
												location.href = location.href;
											} else {
												alert("일정 수정에 실패했습니다");
											}
										},
										error: function (request, status, error) {
											console.log("code: " + request.status)
											console.log("message: " + request.responseText)
											console.log("error: " + error);
										}
									})
								})


								$("#deleteEvent").on("click", function () {

									let schdulSn = info.event.id;

									let events = new Array();
									let obj = new Object();

									obj.id = info.event.id;

									events.push(obj);

									$.ajax({
										url: "/schedule/schedule",
										method: "DELETE",
										dataType: "text",
										data: JSON.stringify(events),
										contentType: 'application/json',
										success: function (response) {
											if (response == "success") {
												location.href = location.href;
											} else {
												alert("일정 삭제에 실패했습니다");
											}
										},
										error: function (request, status, error) {
											console.log("code: " + request.status)
											console.log("message: " + request.responseText)
											console.log("error: " + error);
										}
									});
								})
							},
							error: function (request, status, error) {
								console.log("code: " + request.status)
								console.log("message: " + request.responseText)
								console.log("error: " + error);
							}
						});
					}
				});
				calendar.render();
			});
		});
	});
</script>