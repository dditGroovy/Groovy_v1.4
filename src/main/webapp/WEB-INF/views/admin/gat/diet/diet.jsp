<%@ page language="java" contentType="text/html; charset=UTF-8"
         pageEncoding="UTF-8" %>
<link href="/resources/css/schedule/calendar.css" rel="stylesheet"/>


<style>
    .fc-event-time {
        display: none;
    }

    .fc-daygrid-event-dot {
        display: none;
    }
</style>


<div class="content-container">
    <header id="tab-header">
        <h1><a href="${pageContext.request.contextPath}/diet/dietMain" class="on">식단 관리</a></h1>
    </header>

    <div>
        <form name="inputForm" id="inputForm" method="post" action="dietMain" enctype="multipart/form-data">
            <input type="file" name="file" id="file" accept=".xlsx, .xls"/>
            <button type="button" onclick="upload()">엑셀 파일 업로드</button>
        </form>
    </div>

    <div id="calendar"></div>
</div>


<script src="https://ajax.googleapis.com/ajax/libs/jquery/3.6.0/jquery.min.js"></script>
<script src="https://cdnjs.cloudflare.com/ajax/libs/popper.js/1.16.0/umd/popper.min.js"></script>
<script src="/resources/fullcalendar/main.js"></script>
<script src="/resources/fullcalendar/ko.js"></script>
<script>

    $(document).ready(function () {
        let msg = "${map.msg}";
        if (msg != "") alert(msg);
    });

    function upload() {
        let fileInput = $("#file")[0];

        if (fileInput.files.length === 0) {
            alert("파일을 업로드해주세요");
            fileInput.focus();
            return;
        }

        if (!confirm("업로드하시겠습니까?")) {
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