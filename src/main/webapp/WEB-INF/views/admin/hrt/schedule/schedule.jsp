<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<script src="https://cdn.jsdelivr.net/npm/sweetalert2@11"></script>
<link href="/resources/css/schedule/calendar.css" rel="stylesheet"/>

<style>
    #eventTitle {
        margin-left: 41px;

    }

    .modal-content {
        font-weight: bold;
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

    .close {
        left: 95%;
        position: relative;
        width: 10%;
        height: 25px;
        border: 1px solid white;
        background-color: white;
        font-size: 24px;
    }

    .form-group {
        margin-bottom: 10px;
    }

    .btn-primary {
        height: var(--vh-56);
        background-color: var(--color-main);
        border-radius: var(--size-32);
        border: 1px solid var(--color-stroke);
        box-shadow: var(--clay-btn);
        outline-color: var(--color-main);
        color: white;
        text-align: center;
    }

    #deleteEvent {
        margin-right: 15px;
    }

    #saveEvent {
        margin-right: 10px;
        margin-left: 20px;
    }

    .modal-footer > button {
        width: 150px;
        padding: 10px;
        margin-top: 3%;
    }

    .form-control {
        border-radius: var(--size-24);
        border: 2px solid gray;
        height: var(--vh-40);
        text-align: center;
        width: 69%;
        font-weight: bold;
    }

    #eventStart, #eventEnd {
        margin-left: 10px;
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
<script src='https://cdn.jsdelivr.net/npm/moment@2.27.0/min/moment.min.js'></script>

<script>
    const isSameDate = (date1, date2) => {
        return date1.getFullYear() === date2.getFullYear()
            && date1.getMonth() === date2.getMonth()
            && date1.getDate() === date2.getDate();
    }

    $(document).ready(function () {
        $("#eventModal").modal("hide");

        $(function () {
            let request = $.ajax({
                url: "/schedule/schedule",
                method: "GET",
                dataType: "json",
            });

            request.done(function (datas) {
                datas.forEach((data) => {
                    startDate = new Date(data.start);

                    dataYear = new Date(data.end).getFullYear();
                    dataMonth = new Date(data.end).getMonth();
                    dataDay = new Date(data.end).getDate();
                    dataDate = new Date(dataYear, dataMonth, dataDay);
                    if (!isSameDate(startDate, dataDate)) {
                        dataDate.setDate(dataDate.getDate() + 1)
                        data.end = dataDate.getTime();
                    }
                });

                let calendarEl = document.getElementById('calendar');
                let calendar = new FullCalendar.Calendar(calendarEl, {
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
                    events: datas,
                    locale: 'ko',
                    select: function (arg) {
                        Swal.fire({
                            title: '일정을 입력해주세요',
                            input: 'text',
                            inputPlaceholder: '일정을 입력하세요',
                            showCancelButton: true,
                            confirmButtonText: '확인',
                            cancelButtonText: '취소',
                            confirmButtonColor: '#3085d6',
                            cancelButtonColor: '#d33',
                            inputValidator: (value) => {
                                if (!value.trim()) {
                                    return '일정이 입력되지 않았습니다';
                                }
                            }
                        }).then((result) => {
                            if (result.isConfirmed) {
                                const userInput = result.value;

                                let events = new Array();
                                let obj = new Object();

                                obj.title = userInput;
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
                            }
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
                                console.log(response)
                                let schdulBeginDate = new Date(response.schdulBeginDate);
                                let schdulClosDate = new Date(response.schdulClosDate);

                                $("#eventTitle").val(response.schdulNm);
                                $("#eventStart").val(schdulBeginDate.toISOString().slice(0, 10));
                                $("#eventEnd").val(schdulClosDate.toISOString().slice(0, 10));

                                $("#saveEvent").on("click", function () {

                                    let schdulSn = info.event.id;

                                    let dataType = /^[0-9]{4}-[0-9]{2}-[0-9]{2}$/;
                                    if (!dataType.test($('#eventStart').val()) || !dataType.test($('#eventEnd').val())) {
                                        Swal.fire({
                                            title: '날짜는 2000-01-01 형식으로 입력해주세요',
                                            showConfirmButton: false,
                                            timer: 1500
                                        })
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
                                                Swal.fire({
                                                    title: '일정 수정에 실패했습니다',
                                                    showConfirmButton: false,
                                                    timer: 1500
                                                })
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
                                                Swal.fire({
                                                    title: '일정 삭제에 실패했습니다',
                                                    showConfirmButton: false,
                                                    timer: 1500
                                                })
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