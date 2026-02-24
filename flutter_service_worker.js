'use strict';
const MANIFEST = 'flutter-app-manifest';
const TEMP = 'flutter-temp-cache';
const CACHE_NAME = 'flutter-app-cache';

const RESOURCES = {"flutter.js": "24bc71911b75b5f8135c949e27a2984e",
"icons/Icon-512.png": "96e752610906ba2a93c65f8abe1645f1",
"icons/Icon-maskable-512.png": "301a7604d45b3e739efc881eb04896ea",
"icons/Icon-192.png": "ac9a721a12bbc803b44f645561ecb1e1",
"icons/Icon-maskable-192.png": "c457ef57daa1d16f64b27b786ec2ea3c",
"manifest.json": "f2217ab6fd0b100084c8f1799ab7c90e",
"index.html": "9d01bd710e7c123c1798b13240a8b705",
"/": "9d01bd710e7c123c1798b13240a8b705",
"favicon.svg": "2343c654df02898c1541b6a354340041",
"assets/shaders/stretch_effect.frag": "40d68efbbf360632f614c731219e95f0",
"assets/shaders/ink_sparkle.frag": "ecc85a2e95f5e9f53123dcaf8cb9b6ce",
"assets/AssetManifest.bin.json": "8948aa20ecfbfec4f4881ca6e0a37dbd",
"assets/assets/Resume%2520-%2520Marcus%2520Winter.pdf": "e96f3c842e29deefe2329d87e142c016",
"assets/assets/images/projects/urbanize/base_gan.png": "34ba3b0ed280e80e5a480afcf7fe60c4",
"assets/assets/images/projects/urbanize/wealthy_lively_2.png": "19f9636b62a91874222711f25a09d13a",
"assets/assets/images/projects/urbanize/wealthy_lively.png": "5899da16abffea8abecf16addd915a42",
"assets/assets/images/projects/urbanize/algo.png": "70bbc169343acbb650209202f32c40e1",
"assets/assets/images/projects/zombies/pathfinding.png": "e6cde022ee0461eb27d3dc8f94ec9b26",
"assets/assets/images/projects/zombies/alc.png": "b1e0285d262524558a69771bc6cedcc1",
"assets/assets/images/projects/zombies/legs_walk.png": "0f53d2c8ea90064021aff69699984b86",
"assets/assets/images/projects/zombies/nin.png": "53e148bc47b1f3dd72887f7f94470fd9",
"assets/assets/images/projects/zombies/wiz.png": "dd06f725c1ea2381379678540a7a403d",
"assets/assets/images/projects/zombies/head.png": "931a2c6d88a77a27ff04dfdff99965c2",
"assets/assets/images/projects/terrain/finishedDrawing.png": "363541bcaf92d657f6f957c068e658a6",
"assets/assets/images/projects/terrain/toonIsland.png": "63cd269aaf985c52d4bec622d1058355",
"assets/assets/images/projects/terrain/userInterface.png": "861be1f5f428311c99f44ea45d8549b6",
"assets/assets/images/projects/terrain/topIsland.png": "5abb2f6fff91b0f5dbffee5d5b5d58be",
"assets/assets/images/projects/terrain/coolIsland.png": "2a0a808fd9e1cf9640cb08f81f928646",
"assets/assets/images/projects/pngchaser/chaser_lurking.png": "e77c3e2b6adcf3a42afdecbf411c72d8",
"assets/assets/images/projects/pngchaser/explode.gif": "b95900ecad24bff71a84d527ede2a8fc",
"assets/assets/images/projects/collider/skeletal_ui.png": "c7649191e3b5b67bd834eb5719884aeb",
"assets/assets/images/projects/collider/static_ui.png": "33d2c3641807c0a76d8db45b83217a6d",
"assets/assets/images/projects/collider/backflip.gif": "5a0655e82e9d1e24c7dde96a05fe0040",
"assets/assets/images/projects/collider/export.png": "296e4ebe3d23387195aa11e638c5542a",
"assets/assets/images/projects/airobic/plan.png": "5911fef71e59114b0cbce1b6c9d607ef",
"assets/assets/images/projects/airobic/home.png": "a2be258e43bc04f167da457132ad6354",
"assets/assets/images/projects/airobic/workout_generator.png": "377fbf2ef2b84cd1ca1ebbc0e6118ff7",
"assets/assets/images/profile_picture.png": "e81e072bd495f80964901657db0dc001",
"assets/assets/images/fish.jpg": "01093ea4ec5c5989fd8b3f8c597fc97b",
"assets/assets/images/tahoe.jpg": "e6e8a1c1285ea835b59b5662b66a95c6",
"assets/assets/images/banners/collider.png": "4df7bb66238949a1a86e9c691d2032da",
"assets/assets/images/banners/urbanize.png": "14c03dc957ca10c7dd919225c14d4cdd",
"assets/assets/images/banners/terrainpainter.png": "ac9c4392dce429b9ded2bf05baaa0019",
"assets/assets/images/banners/argo.png": "66ef9793fd7619b8d13b34bc80f31e9c",
"assets/assets/images/banners/pngchaser.png": "33dd1efe63f88681a6cc35bee8ce82df",
"assets/assets/images/banners/airobic.png": "a68d30c597f239230ca432928f570f58",
"assets/assets/images/banners/zombies.png": "139c211bdbbb263a7dfd4e056317788f",
"assets/assets/images/banners/pacman.png": "e0fae68bd41be0e240424d965ab014ac",
"assets/assets/images/row.jpg": "3880cdac63f7aa3cd9b92f079c040e9e",
"assets/assets/images/pink.jpg": "bc2311d103f5533aae54c1c6766a5f2e",
"assets/assets/images/grad.jpg": "ff523fe8aa3d8cbf7eef021c40a35896",
"assets/assets/fonts/JetBrainsMono-Regular.ttf": "d09f65145228b709a10fa0a06d522d89",
"assets/assets/fonts/CustomIcons.ttf": "cb3b557dd61fe58479942387b609d25c",
"assets/assets/markdown/collider.md": "8e74a3f3183c05dd08fe007c95288c0a",
"assets/assets/markdown/zombies.md": "d5b70c1b9a027cb8a86272d5bbbfdb33",
"assets/assets/markdown/pngchaser.md": "8d5bded94d5da841d39116d2f29e2200",
"assets/assets/markdown/pacman.md": "288b18c909fa99d0672a48b841a0650e",
"assets/assets/markdown/terrain.md": "b534db8f928f9ed2d8c24d2720396401",
"assets/assets/markdown/urbanize.md": "f8972360e6ceb106512b36daed524bea",
"assets/assets/markdown/argo.md": "4351ec94b89c0dccb461fd7e8657724b",
"assets/assets/markdown/airobic.md": "c657e1bf36f8b1216b0bce00f10f2bc4",
"assets/fonts/MaterialIcons-Regular.otf": "76b841a2db9d3bca25298f2fae9e4b5c",
"assets/NOTICES": "a019d6017516faf406ce54f26246180f",
"assets/packages/cupertino_icons/assets/CupertinoIcons.ttf": "33b7d9392238c04c131b6ce224e13711",
"assets/packages/font_awesome_flutter/lib/fonts/Font-Awesome-7-Free-Solid-900.otf": "a82f3a5e266e6ae4bde63d7ed90c1eb9",
"assets/packages/font_awesome_flutter/lib/fonts/Font-Awesome-7-Brands-Regular-400.otf": "e60e44347a7ae4c0298211902ae45aa7",
"assets/packages/font_awesome_flutter/lib/fonts/Font-Awesome-7-Free-Regular-400.otf": "b2703f18eee8303425a5342dba6958db",
"assets/packages/wakelock_plus/assets/no_sleep.js": "7748a45cd593f33280669b29c2c8919a",
"assets/packages/media_kit/assets/web/hls1.4.10.js": "bd60e2701c42b6bf2c339dcf5d495865",
"assets/FontManifest.json": "5e6b6aa663ffbc652ab7571d9b827594",
"assets/AssetManifest.bin": "4d5182c5768f2668ce5b364c6f66a6d1",
"canvaskit/chromium/canvaskit.wasm": "a726e3f75a84fcdf495a15817c63a35d",
"canvaskit/chromium/canvaskit.js": "a80c765aaa8af8645c9fb1aae53f9abf",
"canvaskit/chromium/canvaskit.js.symbols": "e2d09f0e434bc118bf67dae526737d07",
"canvaskit/skwasm_heavy.wasm": "b0be7910760d205ea4e011458df6ee01",
"canvaskit/skwasm_heavy.js.symbols": "0755b4fb399918388d71b59ad390b055",
"canvaskit/skwasm.js": "8060d46e9a4901ca9991edd3a26be4f0",
"canvaskit/canvaskit.wasm": "9b6a7830bf26959b200594729d73538e",
"canvaskit/skwasm_heavy.js": "740d43a6b8240ef9e23eed8c48840da4",
"canvaskit/canvaskit.js": "8331fe38e66b3a898c4f37648aaf7ee2",
"canvaskit/skwasm.wasm": "7e5f3afdd3b0747a1fd4517cea239898",
"canvaskit/canvaskit.js.symbols": "a3c9f77715b642d0437d9c275caba91e",
"canvaskit/skwasm.js.symbols": "3a4aadf4e8141f284bd524976b1d6bdc",
"favicon.png": "5dcef449791fa27946b3d35ad8803796",
"404.html": "3bf30b760e2f03a2e27e2babf90e2173",
"flutter_bootstrap.js": "f65e0bccba4376d98d705fd6bf1f2b28",
"version.json": "980547175e325fe622a3362b84d55b6a",
"main.dart.js": "1cf85e23481338f12db8eeba2f267d8b"};
// The application shell files that are downloaded before a service worker can
// start.
const CORE = ["main.dart.js",
"index.html",
"flutter_bootstrap.js",
"assets/AssetManifest.bin.json",
"assets/FontManifest.json"];

// During install, the TEMP cache is populated with the application shell files.
self.addEventListener("install", (event) => {
  self.skipWaiting();
  return event.waitUntil(
    caches.open(TEMP).then((cache) => {
      return cache.addAll(
        CORE.map((value) => new Request(value, {'cache': 'reload'})));
    })
  );
});
// During activate, the cache is populated with the temp files downloaded in
// install. If this service worker is upgrading from one with a saved
// MANIFEST, then use this to retain unchanged resource files.
self.addEventListener("activate", function(event) {
  return event.waitUntil(async function() {
    try {
      var contentCache = await caches.open(CACHE_NAME);
      var tempCache = await caches.open(TEMP);
      var manifestCache = await caches.open(MANIFEST);
      var manifest = await manifestCache.match('manifest');
      // When there is no prior manifest, clear the entire cache.
      if (!manifest) {
        await caches.delete(CACHE_NAME);
        contentCache = await caches.open(CACHE_NAME);
        for (var request of await tempCache.keys()) {
          var response = await tempCache.match(request);
          await contentCache.put(request, response);
        }
        await caches.delete(TEMP);
        // Save the manifest to make future upgrades efficient.
        await manifestCache.put('manifest', new Response(JSON.stringify(RESOURCES)));
        // Claim client to enable caching on first launch
        self.clients.claim();
        return;
      }
      var oldManifest = await manifest.json();
      var origin = self.location.origin;
      for (var request of await contentCache.keys()) {
        var key = request.url.substring(origin.length + 1);
        if (key == "") {
          key = "/";
        }
        // If a resource from the old manifest is not in the new cache, or if
        // the MD5 sum has changed, delete it. Otherwise the resource is left
        // in the cache and can be reused by the new service worker.
        if (!RESOURCES[key] || RESOURCES[key] != oldManifest[key]) {
          await contentCache.delete(request);
        }
      }
      // Populate the cache with the app shell TEMP files, potentially overwriting
      // cache files preserved above.
      for (var request of await tempCache.keys()) {
        var response = await tempCache.match(request);
        await contentCache.put(request, response);
      }
      await caches.delete(TEMP);
      // Save the manifest to make future upgrades efficient.
      await manifestCache.put('manifest', new Response(JSON.stringify(RESOURCES)));
      // Claim client to enable caching on first launch
      self.clients.claim();
      return;
    } catch (err) {
      // On an unhandled exception the state of the cache cannot be guaranteed.
      console.error('Failed to upgrade service worker: ' + err);
      await caches.delete(CACHE_NAME);
      await caches.delete(TEMP);
      await caches.delete(MANIFEST);
    }
  }());
});
// The fetch handler redirects requests for RESOURCE files to the service
// worker cache.
self.addEventListener("fetch", (event) => {
  if (event.request.method !== 'GET') {
    return;
  }
  var origin = self.location.origin;
  var key = event.request.url.substring(origin.length + 1);
  // Redirect URLs to the index.html
  if (key.indexOf('?v=') != -1) {
    key = key.split('?v=')[0];
  }
  if (event.request.url == origin || event.request.url.startsWith(origin + '/#') || key == '') {
    key = '/';
  }
  // If the URL is not the RESOURCE list then return to signal that the
  // browser should take over.
  if (!RESOURCES[key]) {
    return;
  }
  // If the URL is the index.html, perform an online-first request.
  if (key == '/') {
    return onlineFirst(event);
  }
  event.respondWith(caches.open(CACHE_NAME)
    .then((cache) =>  {
      return cache.match(event.request).then((response) => {
        // Either respond with the cached resource, or perform a fetch and
        // lazily populate the cache only if the resource was successfully fetched.
        return response || fetch(event.request).then((response) => {
          if (response && Boolean(response.ok)) {
            cache.put(event.request, response.clone());
          }
          return response;
        });
      })
    })
  );
});
self.addEventListener('message', (event) => {
  // SkipWaiting can be used to immediately activate a waiting service worker.
  // This will also require a page refresh triggered by the main worker.
  if (event.data === 'skipWaiting') {
    self.skipWaiting();
    return;
  }
  if (event.data === 'downloadOffline') {
    downloadOffline();
    return;
  }
});
// Download offline will check the RESOURCES for all files not in the cache
// and populate them.
async function downloadOffline() {
  var resources = [];
  var contentCache = await caches.open(CACHE_NAME);
  var currentContent = {};
  for (var request of await contentCache.keys()) {
    var key = request.url.substring(origin.length + 1);
    if (key == "") {
      key = "/";
    }
    currentContent[key] = true;
  }
  for (var resourceKey of Object.keys(RESOURCES)) {
    if (!currentContent[resourceKey]) {
      resources.push(resourceKey);
    }
  }
  return contentCache.addAll(resources);
}
// Attempt to download the resource online before falling back to
// the offline cache.
function onlineFirst(event) {
  return event.respondWith(
    fetch(event.request).then((response) => {
      return caches.open(CACHE_NAME).then((cache) => {
        cache.put(event.request, response.clone());
        return response;
      });
    }).catch((error) => {
      return caches.open(CACHE_NAME).then((cache) => {
        return cache.match(event.request).then((response) => {
          if (response != null) {
            return response;
          }
          throw error;
        });
      });
    })
  );
}
