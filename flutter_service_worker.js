'use strict';
const MANIFEST = 'flutter-app-manifest';
const TEMP = 'flutter-temp-cache';
const CACHE_NAME = 'flutter-app-cache';

const RESOURCES = {"flutter_bootstrap.js": "c48f8cc99a60298415d201987e367545",
"version.json": "b019d0646a526d664e08352bbfcd738e",
"index.html": "a3854321f6191a5cf7557b332b02ff06",
"/": "a3854321f6191a5cf7557b332b02ff06",
"main.dart.js": "084a0059d65f964eca1618ccd0e45ce3",
"flutter.js": "76f08d47ff9f5715220992f993002504",
"favicon.png": "5dcef449791fa27946b3d35ad8803796",
"icons/Icon-192.png": "ac9a721a12bbc803b44f645561ecb1e1",
"icons/Icon-maskable-192.png": "c457ef57daa1d16f64b27b786ec2ea3c",
"icons/Icon-maskable-512.png": "301a7604d45b3e739efc881eb04896ea",
"icons/Icon-512.png": "96e752610906ba2a93c65f8abe1645f1",
"manifest.json": "01e582a5fd8a096d1d1bbf2a1bf9b9ee",
"assets/AssetManifest.json": "3ec8721111e9e6b7d565243b067b1486",
"assets/NOTICES": "307742a768c66a9d72a33ebaa4b5b34d",
"assets/FontManifest.json": "dc3d03800ccca4601324923c0b1d6d57",
"assets/AssetManifest.bin.json": "1e8e8d2580565bb0e5599a07b50ed807",
"assets/packages/cupertino_icons/assets/CupertinoIcons.ttf": "33b7d9392238c04c131b6ce224e13711",
"assets/shaders/ink_sparkle.frag": "ecc85a2e95f5e9f53123dcaf8cb9b6ce",
"assets/AssetManifest.bin": "d3520d82812ca0e0cc2cb19479ec4b5c",
"assets/fonts/MaterialIcons-Regular.otf": "f6ee6f9cc7035e8131e2b279daf09ea6",
"assets/assets/images/tile_trampoline.jpg": "ae84f0fcf5cb794fc89fe572fbe1a6f6",
"assets/assets/images/fox_fallen.png": "270f882526f591aee8b8d7b5021e791d",
"assets/assets/images/tile_labyrinth.jpg": "678a42018e997b58b3e1af13761f63ec",
"assets/assets/images/trampoline_idle.png": "57338ed1e1342fbcd0f49a9f4da3f263",
"assets/assets/images/trampoline_releasing.png": "9aca5d4b584f468f4a321e3c847b413d",
"assets/assets/images/fox_falling.png": "05a5a35a545fa0e9ba1e84c6c7257f48",
"assets/assets/images/mascot_fox.jpg": "97aab8edb8fdb3a9152b231c8b2a2dc7",
"assets/assets/images/trampoline_touching.png": "22e2b91c0ad600776d973614450ac887",
"assets/assets/images/tile_number_bonds.jpg": "81f858235e5dfbb01df7c1baf6874130",
"assets/assets/images/fox_touching.png": "439277c02dd7b597256a0fa66dd2f2cd",
"assets/assets/images/fox_flying_up.png": "552053fe0e94d757ec8d4afab20ca55a",
"assets/assets/media/video/labyrinth_door_open.mp4": "a20b668bf92661e382b10ef4b956a281",
"assets/assets/media/video/labyrinth_door_closed.mp4": "e712d350aeb9d50f6cd0f021fff3d8da",
"assets/assets/media/lose_alert.wav": "e2d083facef096e1131841d798f9ff1e",
"assets/assets/media/door_wrong.wav": "058196a80b5b93745f0b8c28bb387d86",
"assets/assets/media/wrong_pick.wav": "f3a6977ac8b8bc5ca5ea9cdfdb325b8c",
"assets/assets/media/trampoline_crash.wav": "62d9d263a41d9b83fe9e45c64d052255",
"assets/assets/media/background_game.wav": "20f543d279a32a96c97db4afa9936147",
"assets/assets/media/success_alert.wav": "0612bb54c2d469ec278e9c4674918a83",
"assets/assets/media/trampoline_jump.wav": "f0392f1d9eaa12a4090da0e076888f8f",
"assets/assets/media/switch_screens.wav": "88bf00fbcc90102ff6812b1907ff6b73",
"assets/assets/media/background_menu.wav": "1f22664c7c394d89f714b97417debba8",
"assets/assets/media/menu_click.wav": "e01a02e5419d63f53ca4a1f172a025aa",
"assets/assets/media/remove_items.wav": "344ced0c22f20c781daa8cbec05d5254",
"assets/assets/media/door_open.wav": "9401aa557ee56297736ab64abcbd9325",
"canvaskit/skwasm_st.js": "d1326ceef381ad382ab492ba5d96f04d",
"canvaskit/skwasm.js": "f2ad9363618c5f62e813740099a80e63",
"canvaskit/skwasm.js.symbols": "80806576fa1056b43dd6d0b445b4b6f7",
"canvaskit/canvaskit.js.symbols": "68eb703b9a609baef8ee0e413b442f33",
"canvaskit/skwasm.wasm": "f0dfd99007f989368db17c9abeed5a49",
"canvaskit/chromium/canvaskit.js.symbols": "5a23598a2a8efd18ec3b60de5d28af8f",
"canvaskit/chromium/canvaskit.js": "ba4a8ae1a65ff3ad81c6818fd47e348b",
"canvaskit/chromium/canvaskit.wasm": "64a386c87532ae52ae041d18a32a3635",
"canvaskit/skwasm_st.js.symbols": "c7e7aac7cd8b612defd62b43e3050bdd",
"canvaskit/canvaskit.js": "6cfe36b4647fbfa15683e09e7dd366bc",
"canvaskit/canvaskit.wasm": "efeeba7dcc952dae57870d4df3111fad",
"canvaskit/skwasm_st.wasm": "56c3973560dfcbf28ce47cebe40f3206"};
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
