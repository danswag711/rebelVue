if(!self.define){const e=e=>{"require"!==e&&(e+=".js");let s=Promise.resolve();return c[e]||(s=new Promise((async s=>{if("document"in self){const c=document.createElement("script");c.src=e,document.head.appendChild(c),c.onload=s}else importScripts(e),s()}))),s.then((()=>{if(!c[e])throw new Error(`Module ${e} didn’t register its module`);return c[e]}))},s=(s,c)=>{Promise.all(s.map(e)).then((e=>c(1===e.length?e[0]:e)))},c={require:Promise.resolve(s)};self.define=(s,r,i)=>{c[s]||(c[s]=Promise.resolve().then((()=>{let c={};const b={uri:location.origin+s.slice(1)};return Promise.all(r.map((s=>{switch(s){case"exports":return c;case"module":return b;default:return e(s)}}))).then((e=>{const s=i(...e);return c.default||(c.default=s),c}))})))}}define("./sw.js",["./workbox-7ce2238d"],(function(e){"use strict";self.addEventListener("message",(e=>{e.data&&"SKIP_WAITING"===e.data.type&&self.skipWaiting()})),e.precacheAndRoute([{url:"assets/404.2ec6e77e.js",revision:"6d857bdfba1b30ffbbdb182f03d3889a"},{url:"assets/404.a9a6e4f2.css",revision:"2bd416b9b908fd1896a32bc6679822c5"},{url:"assets/ConnectWallet.f6f05b03.js",revision:"5837d5bba1f98fbf8fd86b05a16d2e79"},{url:"assets/CrowdsaleComp.0b03018b.js",revision:"0aba97bd208958ba7eb557d43371ba06"},{url:"assets/CrowdsaleComp.e046f00b.css",revision:"0f38c12616f50fc006c21b90d7b44103"},{url:"assets/index.b0bf53cb.css",revision:"9084dec2ef7bdb2638fbb082277f97bc"},{url:"assets/index.cdd6b086.js",revision:"8963a878bfcb81ee748f1cfed6da60e6"},{url:"assets/mdb.umd.min.7e4f5bd1.css",revision:"2e150d966c74722cc2022b0d13cf7470"},{url:"assets/mdb.umd.min.d7fccef1.js",revision:"da300e9245a323bb1c8fbc8aed0d2763"},{url:"assets/VAbout.1a2abd1d.css",revision:"a8a8ef4369e3457c9bb9c5667278bd61"},{url:"assets/VAbout.82381ae6.js",revision:"0b3daf0baf8db6d0a53d0defa2155a49"},{url:"assets/vendor.1b9cd890.css",revision:"b2eda931afa5522db8c5fd4a305f11c7"},{url:"assets/vendor.1cdbe8f5.js",revision:"107369651834218fc3a0d25f8401dfe4"},{url:"assets/VFeed.bc8d7b78.js",revision:"cbbb314071cdaf41ce614a7f64003b83"},{url:"assets/VFeed.f153071c.css",revision:"b0b71c0581bc870cc7c94436dbfc0c40"},{url:"assets/VPost.e279d407.css",revision:"a5080385cb7413c1500a1bd08d48421f"},{url:"assets/VPost.fffb95cb.js",revision:"1af3382ee11c244fb203b29c68920721"},{url:"assets/VUser.56207915.js",revision:"62c2ece9807c7a3349cd604ba76d936a"},{url:"assets/VUser.c61bacf0.css",revision:"36dddceab6365f8f017b0a56650cd4ee"},{url:"index.html",revision:"250ef6b725d46a66fe885727ededc646"},{url:"icons/icon-192x192.png",revision:"7c37ea90faf169cb14418fcbaabf1dcb"},{url:"icons/icon-256x256.png",revision:"b72cae97330e16e885486afcc30eca79"},{url:"icons/icon-384x384.png",revision:"069dfa0bffa10e0a28930ca61a0eec19"},{url:"icons/icon-512x512.png",revision:"291e7f103c832375cbee915d27e6d56d"},{url:"manifest.webmanifest",revision:"d2b1d164d0fee3c9528626922b2b7735"}],{}),e.cleanupOutdatedCaches(),e.registerRoute(new e.NavigationRoute(e.createHandlerBoundToURL("index.html")))}));
//# sourceMappingURL=sw.js.map
