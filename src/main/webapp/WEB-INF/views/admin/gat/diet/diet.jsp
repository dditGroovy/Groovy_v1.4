<%@ page language="java" contentType="text/html; charset=UTF-8"
         pageEncoding="UTF-8" %>

<style>
    .fc-event-time {
        display: none;
    }

    .fc-daygrid-event-dot {
        display: none;
    }

    #formDiv {
        margin-bottom: var(--vh-40);
    }

    input[type=file]::file-selector-button {
        background-color: var(--color-white);
        border-radius: var(--size-32);
        border: 1px solid var(--color-stroke);
        box-shadow: var(--clay-card);
        outline-color: var(--color-main);
        color: var(--color-main);
        font-size: var(--font-size-14);
        height: var(--vh-56);
        width: calc((100 / var(--vw)) * 100vw);
    }

    .fileButton {
        height: var(--vh-56);
        width: calc((120 / var(--vw)) * 100vw);
        font-size: var(--font-size-14);
        background-color: var(--color-main);
        border: 1px solid var(--color-stroke);
        border-radius: var(--size-32);
        box-shadow: var(--clay-btn);
        color: white;
    }
</style>


<div class="content-container">
    <header id="tab-header">
        <h1><a href="${pageContext.request.contextPath}/diet/dietMain" class="on">식단 관리</a></h1>
    </header>

    <div id="formDiv">
        <form name="inputForm" id="inputForm" method="post" action="dietMain" enctype="multipart/form-data">
            <%-- <input type="hidden" name="${_csrf.parameterName}" value="${_csrf.token}"/> --%>
            <input type="file" name="file" id="file" accept=".xlsx"/>
            <button type="button" class="fileButton" onclick="upload()">파일 등록</button>
        </form>
    </div>

    <div id="calendar"></div>
</div>

<link href="/resources/css/schedule/calendar.css" rel="stylesheet"/>
<script src="https://cdn.jsdelivr.net/npm/sweetalert2@10"></script>
<script src="https://ajax.googleapis.com/ajax/libs/jquery/3.6.0/jquery.min.js"></script>
<script src="https://cdnjs.cloudflare.com/ajax/libs/popper.js/1.16.0/umd/popper.min.js"></script>
<script src="/resources/fullcalendar/main.js"></script>
<script src="/resources/fullcalendar/ko.js"></script>
<script>

    $(document).ready(function () {
        let msg = "${map.msg}";
        if (msg == "ok") {
            Swal.fire({
                title: '파일 업로드 성공',
                showConfirmButton: false,
                timer: 1500
            })
        } else if (msg == "error") {
            Swal.fire({
                title: '파일 업로드 실패',
                showConfirmButton: false,
                timer: 1500
            })
        }
    });

    function upload() {
        let fileInput = $("#file")[0];

        if (fileInput.files.length === 0) {
            Swal.fire({
                title: '파일을 업로드해주세요',
                showConfirmButton: false,
                timer: 1500
            })

            fileInput.focus();
            return;
        }

        $("#inputForm").submit();
    }

    $(document).ready(function () {
        $(function () {
            let request = $.ajax({
                url: "/diet/dietData",
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
                        right: 'dayGridMonth'
                    },
                    initialView: 'dayGridMonth',
                    navLinks: true,
                    selectable: true,
                    showNonCurrentDates: false,
                    events: data,
                    locale: 'ko'
                });
                calendar.render();
            });
        });
    })
</script>