
function getWindowSize() {
    let ratio = 1;
    let width = 210 * 3.78 * ratio;
    let height = 297 * 3.78 * ratio;
    let left = (window.innerWidth - width) / 2;
    let top = (window.innerHeight - height) / 2;

    // 팝업 창 열기
    const size = `width=${width},height=${height},left=${left},top=${top}`;
    return size;
}

function refreshParent() {
    location.reload();
}

