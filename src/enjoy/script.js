const SKAPING_LOCATION_URL = 'https://scapin.netlify.app/.netlify/functions/skaping-data?data=picture&location-url=https://www.skaping.com/serrechevalier/coldulautaret';

async function getLatestSkapingPictureUrl(skapingLocationUrl) {
    const response = await fetch(skapingLocationUrl, {
        method: 'GET'
    });
    const bodyJson = await response.json();
    let url = bodyJson.data.url;
    url = url.replace('http:', 'https:');
    return url;
}

async function main() {
    const spinner = document.getElementById('spinner');
    spinner.style.display = 'block';

    const img = new Image();
    img.src = await getLatestSkapingPictureUrl(SKAPING_LOCATION_URL);

    const canvasWidth = document.documentElement.clientWidth;
    const canvasHeight = document.documentElement.clientHeight;
    const canvas = document.getElementById('canvas');
    canvas.width = canvasWidth;
    canvas.height = canvasHeight;

    const scale = 1.1;
    const y = -4.5;

    const dx = 0.75;
    let imgWidth;
    let imgHeight;
    let x = 0;
    let clearX;
    let clearY;
    let ctx;
    let offscreenCanvas;
    let offscreenCtx;

    let isRefreshing = true;

    img.onload = function () {
        spinner.style.display = 'none';

        imgWidth = img.width * scale;
        imgHeight = img.height * scale;

        if (imgWidth > canvasWidth) {
            x = canvasWidth - imgWidth;
        }
        if (imgWidth > canvasWidth) {
            clearX = imgWidth;
        } else {
            clearX = canvasWidth;
        }
        if (imgHeight > canvasHeight) {
            clearY = imgHeight;
        } else {
            clearY = canvasHeight;
        }

        ctx = canvas.getContext('2d');
        offscreenCanvas = document.createElement('canvas');
        offscreenCanvas.width = canvasWidth;
        offscreenCanvas.height = canvasHeight;
        offscreenCtx = offscreenCanvas.getContext('2d');

        window.requestAnimationFrame(draw);
        canvas.addEventListener('touchstart', preventDefaultTouch, { passive: false });

        canvas.onclick = function (_) {
            if (isRefreshing) {
                isRefreshing = false;
            } else {
                isRefreshing = true;
                window.requestAnimationFrame(draw);
            }
        }
    }

    function preventDefaultTouch(e) {
        e.preventDefault();
    }

    function draw() {
        offscreenCtx.clearRect(0, 0, clearX, clearY); // clear the off-screen canvas

        if (imgWidth <= canvasWidth) {
            if (x > canvasWidth) {
                x = -imgWidth + x;
            }
            if (x > 0) {
                offscreenCtx.drawImage(img, -imgWidth + x, y, imgWidth, imgHeight);
            }
            if (x - imgWidth > 0) {
                offscreenCtx.drawImage(img, -imgWidth * 2 + x, y, imgWidth, imgHeight);
            }
        } else {
            if (x > (canvasWidth)) {
                x = canvasWidth - imgWidth;
            }
            if (x > (canvasWidth - imgWidth)) {
                offscreenCtx.drawImage(img, x - imgWidth + 1, y, imgWidth, imgHeight);
            }
        }
        offscreenCtx.drawImage(img, x, y, imgWidth, imgHeight);

        ctx.clearRect(0, 0, canvas.width, canvas.height); // clear the visible canvas
        ctx.drawImage(offscreenCanvas, 0, 0); // draw the off-screen canvas to the visible canvas

        x += dx;

        if (isRefreshing) {
            window.requestAnimationFrame(draw);
        }
    }

}

main();