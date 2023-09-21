<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="sec" uri="http://www.springframework.org/security/tags" %>
<sec:authentication property="principal" var="CustomUser"/>

<script src="https://cdnjs.cloudflare.com/ajax/libs/sockjs-client/1.4.0/sockjs.min.js"></script>
<script src="https://cdnjs.cloudflare.com/ajax/libs/stomp.js/2.3.3/stomp.min.js"></script>

<style>
    .rooms {
        cursor: pointer;
    }

    .myroom {
        overflow-y: auto;
        height: 300px;
    }

    #inviteBtn, #inviteEmplBtn {
        display: none;
    }

</style>
<div class="content-container">
    <h1>채팅방 개설</h1>
    <div>
        <ul id="employeeList">

        </ul>
        <button type="button" id="createRoomBtn" style="background-color: lightsteelblue">채팅방 생성</button>
        <button type="button" id="inviteEmplBtn" style="background-color: darkseagreen">채팅방 초대</button>
        <button type="button" id="cancelBtn">취소</button>
    </div>

    <hr>

    <h1>채팅방 목록</h1>
    <div id="chatRoomList">

    </div>

    <hr>

    <h1>채팅창</h1>
    <div id="chatRoom">
        <button type="button" id="inviteBtn">초대</button>
        <div id="msgArea">

        </div>
        <input type="text" id="msg">
        <button type="button" id="sendBtn">전송</button>
    </div>
</div>
<script>

    const emplId = ${CustomUser.employeeVO.emplId};
    const emplNm = "${CustomUser.employeeVO.emplNm}";
    const msg = $("#msg");
    const chatRoomMessages = {};
    const subscribedRooms = new Set();

    let sockJS = new SockJS("/chat");
    let client = Stomp.over(sockJS);

    let currentRoomNo;
    let currentRoomNm;

    let emplsToInvite = []
    let chttRoomMem = []

    function connectToStomp() {
        return new Promise(function (res, rej) {
            client.connect({}, function () {
                res();
            });
        });
    }

    connectToStomp().then(function () {
        $("#msg").on("keyup", function (event) {
            if (event.keyCode === 13) {
                sendMessage();
            }
        });

        $("#sendBtn").on("click", function () {
            sendMessage();
        });

        function sendMessage() {
            let message = msg.val();
            let date = new Date();

            if (message.length == 0) return;

            let chatVO = {
                chttNo: 0,
                chttRoomNo: currentRoomNo,
                chttMbrEmplId: emplId,
                chttMbrEmplNm: emplNm,
                chttCn: message,
                chttInputDate: date,
                proflPhotoFileStreNm : "${CustomUser.employeeVO.proflPhotoFileStreNm}"
            }

            client.send('/public/chat/message', {}, JSON.stringify(chatVO));
            console.log("chatVO", chatVO);
            $.ajax({
                url: "/chat/inputMessage",
                type: "post",
                data: JSON.stringify(chatVO),
                contentType: "application/json;charset:utf-8",
                success: function (result) {

                },
                error: function (request, status, error) {
                    alert("채팅 전송 실패")
                }
            })
            msg.val('');
        }

        function enterRoom(currentRoomNo, currentRoomNm) {
            emplsToInvite = [];
            chttRoomMem = [];
            $("input[type='checkbox'][name='employees']").prop("disabled", false).prop("checked", false);
            $("#inviteEmplBtn").hide();
            $("#createRoomBtn").show();

            $("#msgArea").html('');
            $("#msgArea").append(`<div class="myroom" id="room\${currentRoomNo}" style="border: 2px solid green"></div>`)

            $.ajax({
                url: `/chat/loadRoomMessages/\${currentRoomNo}`,
                type: "get",
                dataType: "json",
                success: function (messages) {
                    $.each(messages, function (idx, obj) {
                        if (obj.chttMbrEmplId == emplId) {
                            let code = `<div style="border: 1px solid blue" id="\${obj.chttNo}">
                                            <img src="/uploads/profile/\${obj.proflPhotoFileStreNm}" width="50px;" />
                                            <p>\${obj.chttMbrEmplNm} : \${obj.chttCn}</p>
                                        </div>`;
                            $(`#room\${currentRoomNo}`).append(code);
                        } else {
                            let code = `<div style='border: 1px solid red' id='\${obj.chttNo}'>
                                            <img src="/uploads/profile/\${obj.proflPhotoFileStreNm}" width="50px;" />
                                            <p>\${obj.chttMbrEmplNm} : \${obj.chttCn}</p>
                                        </div>`;
                            $(`#room\${currentRoomNo}`).append(code);
                        }
                    });
                    scrollToBottom();
                },
                error: function (request, status, error) {
                    alert("채팅 로드 실패")
                }
            })

            $.ajax({
                url: `/chat/loadRoomMembers/\${currentRoomNo}`,
                type: "get",
                success: function (members) {
                    $.each(members, function (idx, obj) {
                        chttRoomMem.push(obj);
                    })
                },
                error: function (request, status, error) {
                    alert("채팅방 멤버 로드 실패")
                }
            })

            msg.val('');

        }

        $("#inviteBtn").on("click", function () {
            $("#createRoomBtn").hide();
            $("#inviteEmplBtn").show();

            $('input[type="checkbox"][name="employees"]').each(function () {
                let memId = $(this).val().split("/")[0];
                if (chttRoomMem.includes(memId)) {
                    $(this).prop('disabled', true);
                }
            });
        })

        $("#inviteEmplBtn").on("click", function () {

            $("input[name='employees']:checked").each(function () {
                let employees = $(this).val();
                let splitResult = employees.split("/");
                if (splitResult.length === 2) {
                    let emplId = splitResult[0];
                    emplsToInvite.push(emplId);
                }
            });

            let newMem = {
                chttRoomNo: currentRoomNo,
                chttRoomNm: currentRoomNm,
                employees: emplsToInvite
            }

            if (emplsToInvite.length > 0) {
                $.ajax({
                    url: "/chat/inviteEmpls",
                    type: "post",
                    data: JSON.stringify(newMem),
                    contentType: "application/json;charset:utf-8",
                    success: function (result) {
                        if (result == 1) {
                            loadRoomList();
                            alert("초대 성공");
                        } else {
                            alert("초대 실패")
                        }
                    },
                    error: function (request, status, error) {
                        alert("오류로 인한 초대 실패")
                    }
                });
                $("input[name='employees']:checked").prop("checked", false);
            } else {
                alert("초대할 사원을 선택해주세요.")
            }
        });

        function scrollToBottom() {
            const scrollRoom = document.getElementById("room" + currentRoomNo);
            scrollRoom.scrollTop = scrollRoom.scrollHeight;
        }

        $("#chatRoomList").on("click", ".rooms", function () {

            let selectedRoom = $(this);
            let chttRoomNo = selectedRoom.find("#chttRoomNo").val();
            let chttRoomTy = selectedRoom.find("#chttRoomTy").val();
            let chttRoomNm = selectedRoom.find("#chttRoomNm").text();

            currentRoomNo = chttRoomNo;
            currentRoomNm = chttRoomNm;

            enterRoom(currentRoomNo, currentRoomNm);

            if (chttRoomTy == '1') {
                $("#inviteBtn").show();
            } else {
                $("#inviteBtn").hide();
            }

        });

        function subscribeToChatRoom(chttRoomNo) {
            if(!subscribedRooms.has(chttRoomNo)) {
                client.subscribe("/subscribe/chat/room/" + chttRoomNo, function (chat) {
                    let content = JSON.parse(chat.body);

                    let chttRoomNo = content.chttRoomNo;
                    let chttMbrEmplId = content.chttMbrEmplId;
                    let chttMbrEmplNm = content.chttMbrEmplNm;
                    let chttCn = content.chttCn;
                    let chttInputDate = content.chttInputDate;
                    let proflPhotoFileStreNm = content.proflPhotoFileStreNm;

                    if (chttMbrEmplId == emplId) {
                        let code = `<div style="border: 1px solid blue">
                                        <img src="/uploads/profile/\${proflPhotoFileStreNm}" width="50px;" />
                                        <p>\${chttMbrEmplNm} : \${chttCn}</p>
                                    </div>`;
                        $(`#room\${chttRoomNo}`).append(code);
                        scrollToBottom();
                    } else {
                        let code = `<div style="border: 1px solid red">
                                        <img src="/uploads/profile/\${proflPhotoFileStreNm}" width="50px;" />
                                        <p>\${chttMbrEmplNm} : \${chttCn}</p>
                                    </div>`;
                        $(`#room\${chttRoomNo}`).append(code);
                        scrollToBottom();
                    }

                    updateLatestChttCn(chttRoomNo, chttCn, chttInputDate);
                    updateChatRoomList(chttRoomNo, chttCn);
                });
                subscribedRooms.add(chttRoomNo);
            }
        }

        function updateLatestChttCn(chttRoomNo, chttCn, chttInputDate) {
            for (let i = 0; i < chatRoomList.length; i++) {
                if (chatRoomList[i].chttRoomNo === chttRoomNo) {
                    chatRoomList[i].latestChttCn = chttCn;
                    chatRoomList[i].latestInputDate = chttInputDate;
                    break;
                }
            }
            renderChatRoomList();
        }

        function updateChatRoomList(chttRoomNo, latestChttCn) {
            let chatRoom = $("#chatRoomList" + chttRoomNo);
            chatRoom.find("#latestChttCn").text(latestChttCn);
        }

        let groupedEmployees = {};
        let deptNm
        <c:forEach items="${emplListForChat}" var="employee">
        deptNm = "${employee.deptNm}";
        if (!groupedEmployees[deptNm]) {
            groupedEmployees[deptNm] = [];
        }
        groupedEmployees[deptNm].push({
            emplId: "${employee.emplId}",
            emplNm: "${employee.emplNm}",
            clsfNm: "${employee.clsfNm}"
        });
        </c:forEach>

        let ul = $("#employeeList");
        for (let deptNm in groupedEmployees) {
            let li = $("<li>").text(deptNm);
            ul.append(li);

            let ulSub = $("<ul>");
            groupedEmployees[deptNm].forEach(function (employee) {
                let liSub = $("<li>");
                let label = $("<label>");
                let input = $("<input>").attr({
                    type: "checkbox",
                    name: "employees",
                    value: employee.emplId + "/" + employee.emplNm
                });
                label.append(input);
                label.append(document.createTextNode(employee.emplNm + " " + employee.clsfNm));
                liSub.append(label);
                ulSub.append(liSub);
            });
            li.append(ulSub);
        }

        $("#createRoomBtn").click(function () {
            let roomMemList = [];

            $("input[name='employees']:checked").each(function () {
                let employees = $(this).val()
                let splitResult = employees.split("/");

                if (splitResult.length === 2) {
                    let emplId = splitResult[0];
                    let emplNm = splitResult[1];

                    let EmployeeVO = {
                        emplId: emplId,
                        emplNm: emplNm
                    };

                    roomMemList.push(EmployeeVO);
                }
            });

            if(roomMemList.length > 0) {
                $.ajax({
                    url: "/chat/createRoom",
                    type: "post",
                    data: JSON.stringify(roomMemList),
                    contentType: "application/json;charset:utf-8",
                    success: function (result) {
                        if (result == 1) {
                            loadRoomList();
                            alert("채팅방 개설 성공");
                        } else {
                            alert("이미 존재하는 1:1 채팅방입니다")
                        }
                    },
                    error: function (request, status, error) {
                        alert("채팅방 개설 실패")
                    }
                });

                $("input[name='employees']:checked").prop("checked", false);
            } else {
                alert("채팅방 개설을 위한 최소 인원 미달")
            }

        });

        loadRoomList();

        function loadRoomList() {
            $.ajax({
                url: "/chat/loadRooms",
                type: "get",
                dataType: "json",
                success: function (result) {
                    result.sort((a, b) => b.latestInputDate - a.latestInputDate);

                    chatRoomList = result;

                    for (let i = 0; i < chatRoomList.length; i++) {
                        let chttRoomNo = chatRoomList[i].chttRoomNo;
                        subscribeToChatRoom(chttRoomNo);
                    }
                    renderChatRoomList();
                },
                error: function (request, status, error) {
                    alert("채팅방 목록 로드 실패")
                }
            })
        }

        let chatRoomList = [];

        function renderChatRoomList() {
            $("#chatRoomList").html('');

            chatRoomList.forEach(room => room.latestInputDate = new Date(room.latestInputDate));
            chatRoomList.sort((a, b) => b.latestInputDate - a.latestInputDate);

            code = "";
            $.each(chatRoomList, function (idx, obj) {
                code += `<button class="rooms" id="chatRoom\${obj.chttRoomNo}">
            <img src="/uploads/profile/\${obj.chttRoomThumbnail}" alt="\${obj.chttRoomThumbnail}"/>
            <p id="chttRoomNm">\${obj.chttRoomNm}</p>
            <p id="latestChttCn">\${obj.latestChttCn}</p>
            <input id="chttRoomNo" type="hidden" value="\${obj.chttRoomNo}">
            <input id="chttRoomTy" type="hidden" value="\${obj.chttRoomTy}">
            </button>`;
            });
            $("#chatRoomList").html(code);
        }

        $("#cancelBtn").on("click", function () {
            $("input[type='checkbox'][name='employees']").prop("disabled", false).prop("checked", false);
            $("#inviteEmplBtn").hide();
            $("#createRoomBtn").show();
            emplsToInvite = [];
        });

    });
</script>