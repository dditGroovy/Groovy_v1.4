<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<%@ taglib prefix="sec" uri="http://www.springframework.org/security/tags" %>

<sec:authentication property="principal" var="CustomUser"/>

<link rel="stylesheet" href="/resources/css/community/cloud.css">
<!-- 폴더 생성 모달 -->
<div id="modal" class="modal-dim" style="display: none;">
    <div class="dim-bg"></div>
    <div class="modal-layer card-df sm folderCard" style="display: block">
        <div class="modal-top">
            <div class="modal-title"><i class="icon-folder"></i>폴더 생성</div>
            <button type="button" class="modal-close btn close">
                <i class="icon i-close close">X</i>
            </button>
        </div>
        <div class="modal-container">
            <form action="/cloud/createFolder" name="createFolder" method="post">
                <div class="modal-content">
                    <div class="modal-text">
                        <h1 class="font-24 color-font-md">✅&nbsp;&nbsp;폴더 이름</h1>
                        <input type="hidden" name="folderPath" value="${folderPath}">
                        <input type="text" placeholder="생성할 폴더 이름 작성해주세요." name="folderName" class="font-14">
                    </div>
                    <div class="modal-footer btn-wrapper">
                        <button type="reset" class="btn btn-close close box-btn font-14">취소</button>
                        <button type="submit" id="createFolder" class="btn btn-create box-btn font-14">생성</button>
                    </div>
                </div>
            </form>
        </div>
    </div>
</div>
<div class="content-container">
    <header id="tab-header">
        <div class="header">
            <h1><a href="#" class="on">GROOM</a></h1>
            <p class="font-reg font-18">팀원들과 <span class="font-md span-text">구름</span>에서 만나요 ☁️</p>
        </div>
    </header>
    <div class="cloud">
        <div class="nav-box">
            <div class="path-box">
                <ul class="path-nav">
                </ul>
            </div>
            <div class="button-wrapper">
                <button type="button" class="addFolder btn btn-free-blue btn-cloud font-md font-14 btn-modal" id="createFolderBtn" data-name="folderCard"><i class="icon i-folder"></i>폴더 생성</button>
            </div>
        </div>
        <div class="cloud-wrapper">
            <div class="file-wrapper">
                <c:forEach var="folder" items="${folderList}">
                    <div class="folder-click">
                        <a href="/cloud/main?path=${folder.path}" class="folder-box cursor-box"
                           oncontextmenu="right(event);">
                            <i class="icon-img folder-img"></i>
                            <p class="font-md font-14">${folder.subfolderName}</p>
                        </a>
                        <button class="more-box btn btn-fill-wh-sm font-14" data-path="${folder.path}" data-type="folder" onclick="deleteObject(this)">폴더 삭제
                        </button>
                    </div>
                </c:forEach>
                <c:forEach var="file" items="${fileList}">
                    <c:set var="fileParts" value="${fn:split(file.key, '.')}"/>
                    <c:set var="extension" value="${fileParts[1]}"/>
                    <c:set var="extensionToIcon" value="${extensionList}"/>
                    <c:set var="iconClass" value="${extensionToIcon[extension]}"/>
                    <div style="position: relative">
                        <div class="file-box cursor-box" data-key="${file.storageClass}" onclick="fileInfo(this)" oncontextmenu="right(event);">
                            <c:choose>
                                <c:when test="${empty iconClass}">
                                    <i class="icon-img other-img"></i>
                                </c:when>
                                <c:otherwise>
                                    <i class="icon-img ${iconClass}"
                                       style="background: url('/resources/images/cloud/${iconClass}.png') no-repeat;"></i>
                                </c:otherwise>
                            </c:choose>
                            <p class="font-md font-14">${fileParts[0]}</p>
                        </div>
                        <div class="sub-btn-box btn btn-fill-wh-sm">
                            <a href="/cloud/download?url=${file.storageClass}" class="font-14 sub-btn-download">다운로드</a>
                            <button class="btn sub-btn-delete font-14" data-path="${file.storageClass}" data-type="file" onclick="deleteObject(this)">파일 삭제
                            </button>
                        </div>
                    </div>
                </c:forEach>
            </div>
            <div class="cloud-preview" style="display: none">
                <div class="title-box">
                    <h1 class="content-name font-reg font-24"></h1>
                    <button type="button" class="close-preview font-md font-18">X</button>
                </div>
                <div class="content-preview"></div>
                <div class="info-box">
                    <p class="font-md font-18 preview-title">유형</p>
                    <p class="content-type font-reg font-14 color-font-md"></p>
                </div>
                <div class="info-box">
                    <p class="font-md font-18 preview-title">마지막 수정</p>
                    <p class="last-date font-reg font-14 color-font-md"></p>
                </div>
                <div class="info-box">
                    <p class="font-md font-18 preview-title">크기</p>
                    <p class="content-size font-reg font-14 color-font-md"></p>
                </div>
                <div class="info-box border-none">
                    <p class="font-md font-18 preview-title">공유한 사람</p>
                    <p class="share-name font-reg font-14 color-font-md"></p>
                </div>
                <div class="button-box">
                    <a href="#" class="btn btn-download font-md font-14 color-font-md">다운로드</a>
                    <button type="button" class="btn btn-delete font-md font-14 color-font-md" data-type="file" onclick="deleteObject(this)">삭제</button>
                </div>
            </div>
        </div>
    </div>
</div>
<script src="/resources/js/modal.js"></script>
<script>
    let dept = `${CustomUser.employeeVO.deptNm}`;
    let path = `${folderPath}`;
    let previewBox = document.querySelector(".cloud-preview");
    let closePreviewBtn = document.querySelector(".close-preview");
    let pathBox = document.querySelector(".path-nav");
    let preview = document.querySelector(".content-preview");
    let contentSize = document.querySelector(".content-size");
    let contentType = document.querySelector(".content-type");
    let shareName = document.querySelector(".share-name");
    let lastDate = document.querySelector(".last-date");

    function pathMap() {
        code = `
            <li class="path-li"><a href="/cloud/main" class="font-reg font-24 color-font-md">\${dept}팀</a></li>
            `;

        let pathParts = path.split("/");

        let url = `\${pathParts[0]}/`;
        for (i = 1; i < pathParts.length; i++) {
            url += `\${pathParts[i]}/`;
            code += `<li class="path-li"><i class="icon i-arr-rt path-icon"></i><a href="/cloud/main?path=\${url}" class="font-reg font-24 color-font-md">\${pathParts[i]}</a></li>`;
        }
        pathBox.innerHTML = code;
    }

    function deleteObject(deletebtn) {
        let url = deletebtn.getAttribute("data-path");
        let type = deletebtn.getAttribute("data-type");
        if (type == 'folder') {
            Swal.fire({
                text: "폴더를 삭제하시면 폴더의 모든 파일이 삭제됩니다. 정말 삭제하시겠습니까?",
                showCancelButton: true,
                confirmButtonColor: '#5796F3FF',
                cancelButtonColor: '#e1e1e1',
                confirmButtonText: '확인',
                cancelButtonText: '취소'
            }).then((result) => {
                if (result.isConfirmed) {//확인
                    deleteFileOrFolder(deletebtn, url, type);
                }
            })
        } else if(type == 'file') {
            Swal.fire({
                text: "파일을 삭제하시겠습니까?",
                showCancelButton: true,
                confirmButtonColor: '#5796F3FF',
                cancelButtonColor: '#e1e1e1',
                confirmButtonText: '확인',
                cancelButtonText: '취소'
            }).then((result) => {
                if (result.isConfirmed) {//확인
                    deleteFileOrFolder(deletebtn, url, type);
                }
            })
        }
    }

    function deleteFileOrFolder(deletebtn, url, type) {
        $.ajax({
            type: 'delete',
            url: `/cloud/deleteFolder?path=\${url}`,
            success: function () {
                if (type == 'folder') {
                    deletebtn.parentElement.remove();
                } else if(type == 'file') {
                    let files = document.querySelectorAll('.file-box');
                    files.forEach(file => {
                        if (file.getAttribute("data-key") == url) {
                            file.parentElement.remove();
                        }
                    });
                    previewBox.style.display = "none";
                }
            },
            error: function (xhr) {
                console.log(xhr.status);
            }
        });
    }

    function fileInfo(infoBox) {
        let key = infoBox.getAttribute("data-key");
        let filename = infoBox.querySelector("p").innerText;
        $.ajax({
            type: 'get',
            url: `/cloud/fileInfo?key=\${key}`,
            success: function (fileInfo) {
                preview.style.background = '';
                preview.innerText = '';
                document.querySelector(".content-name").innerText = filename;
                contentType.innerText = fileInfo.type;

                let size = fileInfo.size;
                if (size < 1000) {
                    contentSize.innerText = size + "바이트";
                } else if (1000 <= size < 1000 * 1000) {
                    contentSize.innerText = (size / 1000).toFixed(1) + "KB";
                } else if (1000 * 1000 <= size < 1000 * 1000 * 1000) {
                    contentSize.innerText = (size / (1000 * 1000)).toFixed(1) + "MB";
                } else {
                    contentSize.innerText = (size / (1000 * 1000 * 1000)).toFixed(1) + "GB";
                }
                lastDate.innerText = fileInfo.lastDate;
                shareName.innerText = fileInfo.emplNm;
                let extensions = fileInfo.type.split("/");
                let extension = extensions[0];
                if (extension == 'image') {
                    let imgUrl = `https://groovy-dazzi.s3.ap-northeast-2.amazonaws.com/\${key}`;
                    let imageElement = document.createElement("img");
                    imageElement.setAttribute("src", imgUrl);
                    preview.appendChild(imageElement);
                } else {
                    preview.innerHTML = '<p>미리보기를 지원하지 않는 파일입니다.</p>';
                }

                let fileUrl = `/cloud/download?url=\${key}`;
                document.querySelector(".btn-delete").setAttribute("data-path", key);
                document.querySelector(".btn-download").setAttribute("href", fileUrl);
                previewBox.style.display = "block";
            },
            error: function (xhr) {
                console.log(xhr.status);
            }
        })
    }

    function uploadFile(fileName) {
        let form = new FormData();
        form.append("file", fileName);
        form.append("path", path);
        $.ajax({
            url: "/cloud/uploadFile",
            type: "POST",
            data: form,
            contentType: false,
            processData: false,
            success: function () {
                location.reload();
            },
            error: function (error) {
                console.error("파일 업로드 실패", error.status);
            },
        });
    }

    let valid = false;
    const right = (event) => {
        event.preventDefault();
        let deleteBtn = event.target.parentElement.nextElementSibling;
        console.log(event.target.parentElement.nextElementSibling);
        deleteBtn.classList.add("on");
        valid = true;
    }

    document.addEventListener('click', function (e) {
        if (valid == true && !e.target.classList.contains("more-box") && !e.target.classList.contains("sub-btn-box")) {
            let deleteBtns = document.querySelectorAll(".more-box");
            let subBtnBoxs = document.querySelectorAll(".sub-btn-box");

            subBtnBoxs.forEach(btn => {
                btn.classList.remove("on");
            })
            deleteBtns.forEach(btn => {
                btn.classList.remove("on");
            });
            valid = false;
        }
    });

    document.addEventListener('click', function (e) {
        if (valid == true && !e.target.classList.contains(".sub-btn-box")) {
            let deleteBtns = document.querySelectorAll(".sub-btn-box");
            deleteBtns.forEach(btn => {
                btn.classList.remove("on");
            });
            valid = false;
        }
    });

    pathMap();

    closePreviewBtn.addEventListener("click", () => {
        previewBox.style.display = "none";
    });

    /* 파일 드래그 앤 드롭 */
    const fileBox = document.querySelector(".file-wrapper");
    let formData;

    /* 박스 안에 Drag 들어왔을 때 */
    fileBox.addEventListener('dragenter', function (e) {
    });
    /* 박스 안에 Drag를 하고 있을 때 */
    fileBox.addEventListener('dragover', function (e) {
        e.preventDefault();
        const vaild = e.dataTransfer.types.indexOf('Files') >= 0;
        !vaild ? this.style.backgroundColor = '#F5FAFF': this.style.backgroundColor = '#F5FAFF';
        !vaild ? this.style.border = "2px solid #C3D8F5": this.style.border = "3px solid #C3D8F5";
        !vaild ? this.style.borderRadius = "12px" : this.style.borderRadius = "12px";
    });
    /* 박스 밖으로 Drag가 나갈 때 */
    fileBox.addEventListener('dragleave', function (e) {
        this.style.backgroundColor = '#F9FAFB';
        this.style.border = "none";
        this.style.borderRadius = "0";
    });
    /* 박스 안에서 Drag를 Drop했을 때 */
    fileBox.addEventListener('drop', function (e) {
        e.preventDefault();
        this.style.backgroundColor = '#F9FAFB';
        this.style.border = "none";
        this.style.borderRadius = "0";

        const data = e.dataTransfer;
        // 유효성 검사
        if (!isValid(data)) return;
        //파일 이름을 text로 표시
        uploadFile(data.files[0]);
    });

    /*  파일 유효성 검사   */
    function isValid(data) {

        // 파일인지 유효성 검사
        if (data.types.indexOf('Files') < 0)
            return false;

        // 파일의 개수 제한
        if (data.files.length > 1) {
            Swal.fire({
                text: '파일은 하나씩 전송이 가능합니다',
                showConfirmButton: false,
                timer: 1500
            });
            return false;
        }

        // 파일의 사이즈 제한
        if (data.files[0].size >= 1024 * 1024 * 50) {
            Swal.fire({
                text: '50MB 이상인 파일은 업로드할 수 없습니다',
                showConfirmButton: false,
                timer: 1500
            });
            return false;
        }
        return true;
    }
</script>