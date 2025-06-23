'use strict';
const MANIFEST = 'flutter-app-manifest';
const TEMP = 'flutter-temp-cache';
const CACHE_NAME = 'flutter-app-cache';

const RESOURCES = {"flutter_bootstrap.js": "a77d13401e2453d08530b34656256f97",
"version.json": "3281702eec1b097ef38cee1d83225858",
"index.html": "28182132c070e1f8811a6f6d77a4dc45",
"/": "28182132c070e1f8811a6f6d77a4dc45",
"main.dart.js": "e173994488bd3065794767d6d0ff1a3a",
"flutter.js": "83d881c1dbb6d6bcd6b42e274605b69c",
"favicon.png": "5dcef449791fa27946b3d35ad8803796",
"icons/Icon-192.png": "ac9a721a12bbc803b44f645561ecb1e1",
"icons/Icon-maskable-192.png": "c457ef57daa1d16f64b27b786ec2ea3c",
"icons/Icon-maskable-512.png": "301a7604d45b3e739efc881eb04896ea",
"icons/Icon-512.png": "96e752610906ba2a93c65f8abe1645f1",
"manifest.json": "8405da6548c13d022c3b2b99592dddd1",
"assets/AssetManifest.json": "57e25ba556a5cb1c3c28b87d7975ba40",
"assets/NOTICES": "3c0f86dffde0733c8397ae213f1b6e36",
"assets/FontManifest.json": "dc3d03800ccca4601324923c0b1d6d57",
"assets/AssetManifest.bin.json": "da08ac1c703b6d192225c73fd329e98d",
"assets/packages/cupertino_icons/assets/CupertinoIcons.ttf": "33b7d9392238c04c131b6ce224e13711",
"assets/packages/flutter_map/lib/assets/flutter_map_logo.png": "208d63cc917af9713fc9572bd5c09362",
"assets/shaders/ink_sparkle.frag": "ecc85a2e95f5e9f53123dcaf8cb9b6ce",
"assets/AssetManifest.bin": "755fecdae28a25f91de60c530f6c5d76",
"assets/fonts/MaterialIcons-Regular.otf": "fe4ad141b180fd0041f3837bcf566cc9",
"assets/assets/linkedin.webp": "85f7d3c2bd9268805ad8dfb804d1f9de",
"assets/assets/harrier.webp": "c04be3eaab6af09af55e1abfee01bebb",
"assets/assets/gps.png": "5063a61bd6a9fe76a464175c010e7552",
"assets/assets/logoDM.png": "4fe14bd7de4bc75bfa401a7371ca8eac",
"assets/assets/pump.png": "0249bfb9086d3a8e43b59f429d741fae",
"assets/assets/car_image.png": "38bc2095374b44f40143d7e241daa50f",
"assets/assets/rr.png": "8bbfb058dc79a6b9a532d44041ba9033",
"assets/assets/fortuner.png": "95440497817a237e0bf1c5b2a8a8816c",
"assets/assets/github.png": "0b636211732664fb0a92675a846cd479",
"assets/assets/textlogo.png": "8429247f87d6c89033c785912842dfc1",
"assets/assets/mahindra%2520xuv%2520300.webp": "baa127a5edd3a16092ee42fa09456e01",
"assets/assets/creta.webp": "464aafbb1f4228ea66db9d30bfe3de58",
"assets/assets/white_car.png": "5ae3e1f582d627192781008f847fe6a0",
"assets/assets/user.png": "9d569d3cbd4960846595a23bdbccbfd3",
"assets/assets/maruti%2520suzuki%2520swift.png": "f93f1fd2130ac659bcedd5647bfcdc00",
"assets/assets/maybach%2520gls%2520600.webp": "c94837ca71cadc4bf2622a5fa50a1958",
"assets/assets/nik.png": "d88bcf5a3f89acef185d39e789408240",
"assets/assets/riyansh.png": "05f440e51c1b35e6b0f18302a44f5ada",
"assets/assets/ig.png": "3a0c1157c3e8a9db7a3438a37bc9423c",
"assets/assets/corolla.png": "b866fd3f56b165ff471c16ec34b83b04",
"assets/assets/onboarding.png": "ed23a40e00154811d4b106e0f6466659",
"assets/assets/logoLM.png": "dcd5ab321ecf69192190b10f00c9bd99",
"assets/assets/linkedin.png": "d492efc706db983e74258dbd348f2208",
"assets/assets/ig.webp": "508049c9d444705e92069b69de995c2e",
"assets/assets/ryder.png": "bf0cba7fcbd61ff7631fc26839340a70",
"assets/assets/civic.png": "a51dcf2f2b08590149d97c6ae29b7f48",
"assets/assets/deepak.jpeg": "06ba918cae1aecbe2236c1720377412e",
"assets/assets/maps.png": "9445065358eeeb43ad26af9bcdfd5510",
"canvaskit/skwasm.js": "ea559890a088fe28b4ddf70e17e60052",
"canvaskit/skwasm.js.symbols": "e72c79950c8a8483d826a7f0560573a1",
"canvaskit/canvaskit.js.symbols": "bdcd3835edf8586b6d6edfce8749fb77",
"canvaskit/skwasm.wasm": "39dd80367a4e71582d234948adc521c0",
"canvaskit/chromium/canvaskit.js.symbols": "b61b5f4673c9698029fa0a746a9ad581",
"canvaskit/chromium/canvaskit.js": "8191e843020c832c9cf8852a4b909d4c",
"canvaskit/chromium/canvaskit.wasm": "f504de372e31c8031018a9ec0a9ef5f0",
"canvaskit/canvaskit.js": "728b2d477d9b8c14593d4f9b82b484f3",
"canvaskit/canvaskit.wasm": "7a3f4ae7d65fc1de6a6e7ddd3224bc93"};
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
