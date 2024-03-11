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


    // Variables utilisateur - les personnaliser pour changer l'image qui défile, ses
    // directions, et la vitesse.

    const img = new Image();
    img.src = await getLatestSkapingPictureUrl(SKAPING_LOCATION_URL);

    const canvasWidth = document.documentElement.clientWidth;
    const canvasHeight = document.documentElement.clientHeight;;
    const canvas = document.getElementById('canvas');
    canvas.width = canvasWidth;
    canvas.height = canvasHeight;

    const speed = 30; // plus elle est basse, plus c'est rapide
    const scale = 1.05;
    const y = -4.5; // décalage vertical

    // Programme principal

    let dx = 0.75;
    let imgW;
    let imgH;
    let x = 0;
    let clearX;
    let clearY;
    let ctx;

    let isRefreshing = true;

    img.onload = function() {
        imgW = img.width * scale;
        imgH = img.height * scale;

        if (imgW > canvasWidth) {
            // image plus grande que le canvas
            x = canvasWidth - imgW;
        }
        if (imgW > canvasWidth) {
            // largeur de l'image plus grande que le canvas
            clearX = imgW;
        } else {
            clearX = canvasWidth;
        }
        if (imgH > canvasHeight) {
            // hauteur de l'image plus grande que le canvas
            clearY = imgH;
        } else {
            clearY = canvasHeight;
        }

        // récupérer le contexte du canvas
        ctx = document.getElementById('canvas').getContext('2d');
        const canvas = document.getElementById('canvas');
        // définir le taux de rafraichissement
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

        // si image est <= taille du canvas
        if (imgW <= canvasWidth) {
            // réinitialise, repart du début
            if (x > canvasWidth) {
                console.log('réinitialise, repart du début');
                x = -imgW + x;
            }
            // dessine image1 supplémentaire
            if (x > 0) {
                ctx.drawImage(img, -imgW + x, y, imgW, imgH);
            }
            // dessine image2 supplémentaire
            if (x - imgW > 0) {
                ctx.drawImage(img, -imgW * 2 + x, y, imgW, imgH);
            }
        }

        // image est > taille du canvas
        else {
            // réinitialise, repeart du début
            if (x > (canvasWidth)) {
                x = canvasWidth - imgW;
            }
            // dessine image supplémentaire
            if (x > (canvasWidth-imgW)) {
                ctx.drawImage(img, x - imgW + 1, y, imgW, imgH);
            }
        }
        // dessine image
        ctx.drawImage(img, x, y,imgW, imgH);
        // quantité à déplacer
        x += dx;
    }
}

main();