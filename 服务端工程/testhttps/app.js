const Koa = require('koa');
const https = require('https');
const fs = require('fs');
const router = require('koa-router')();

const app = new Koa();

//路由
router.get('/', (ctx, next) => {
    ctx.response.body = 'this is a simple node js https server response';
})
app.use(router.routes());

//https
https.createServer({
    key: fs.readFileSync('./server-private-key.pem'),
    cert: fs.readFileSync('./server-cert.pem'),
    requestCert: true,
    ca:[fs.readFileSync('./client-cert.pem')]
}, app.callback()).listen(3000);

console.log(`https app started at port 3000`)
