const SKAPING_LOCATION_URL = 'https://keen-brattain-9e10d9.netlify.app/.netlify/functions/skaping-data?data=picture&location-url=https://www.skaping.com/serrechevalier/coldulautaret';

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
    const canvasHeight = document.documentElement.clientHeight;;
    const canvas = document.getElementById('canvas');
    canvas.width = canvasWidth;
    canvas.height = canvasHeight;

    const speed = 30;
    const scale = 1.05;
    const y = -4.5;

    const dx = 0.75;
    let imgWidth;
    let imgHeight;
    let x = 0;
    let clearX;
    let clearY;
    let ctx;

    let isRefreshing = true;

    img.onload = function() {
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

        ctx = document.getElementById('canvas').getContext('2d');
        const canvas = document.getElementById('canvas');
        let interval = setInterval(draw, speed);
        canvas.onclick = function(el) {
            if (isRefreshing) {
            clearInterval(interval);
            isRefreshing = false;
            } else {
            interval = setInterval(draw, speed);
            isRefreshing = true;
            }

        }
    }

    function draw() {
        ctx.clearRect(0, 0, clearX, clearY); // clear the canvas

        if (imgWidth <= canvasWidth) {
            if (x > canvasWidth) {
                x = -imgWidth + x;
            }
            if (x > 0) {
                ctx.drawImage(img, -imgWidth + x, y, imgWidth, imgHeight);
            }
            if (x - imgWidth > 0) {
                ctx.drawImage(img, -imgWidth * 2 + x, y, imgWidth, imgHeight);
            }
        }

        else {
            if (x > (canvasWidth)) {
                x = canvasWidth - imgWidth;
            }
            if (x > (canvasWidth-imgWidth)) {
                ctx.drawImage(img, x - imgWidth + 1, y, imgWidth, imgHeight);
            }
        }
        ctx.drawImage(img, x, y,imgWidth, imgHeight);
        x += dx;
    }
}

main();