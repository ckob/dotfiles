// // an example to create a new mapping `ctrl-y`
// api.mapkey('<ctrl-y>', 'Show me the money', function() {
//     Front.showPopup('a well-known phrase uttered by characters in the 1996 film Jerry Maguire (Escape to close).');
// });

// // an example to replace `T` with `gt`, click `Default mappings` to see how `T` works.
// api.map('gt', 'T');

// // an example to remove mapkey `Ctrl-i`
// api.unmap('<ctrl-i>');

// set theme
settings.theme = `
.sk_theme {
    font-family: Input Sans Condensed, Charcoal, sans-serif;
    font-size: 10pt;
    background: #24272e;
    color: #abb2bf;
}
.sk_theme tbody {
    color: #fff;
}
.sk_theme input {
    color: #d0d0d0;
}
.sk_theme .url {
    color: #61afef;
}
.sk_theme .annotation {
    color: #56b6c2;
}
.sk_theme .omnibar_highlight {
    color: #528bff;
}
.sk_theme .omnibar_timestamp {
    color: #e5c07b;
}
.sk_theme .omnibar_visitcount {
    color: #98c379;
}
.sk_theme #sk_omnibarSearchResult ul li:nth-child(odd) {
    background: #303030;
}
.sk_theme #sk_omnibarSearchResult ul li.focused {
    background: #3e4452;
}
#sk_status, #sk_find {
    font-size: 20pt;
}`;

// Custom
settings.verticalTabs = false;
settings.smoothScroll = false;

api.unmap('H');
api.map('H', 'E'); // Go to left tab
api.unmap('L');
api.map('L', 'R'); // Go to right tab

api.addSearchAlias('o', 'Raindrop', 'https://app.raindrop.io/my/0/', 's', 'https://api.raindrop.io/v1/raindrops/0?sort=-created&perpage=10&search=', function(response) {
    var res = JSON.parse(response.text);
    return res.items.map(item => ({title:item.title, url:item.link}));
}, {favicon_url:'https://raindrop.io/favicon.ico', skipMaps:false});

api.addSearchAlias('rd', 'Raindrop', 'https://app.raindrop.io/my/0/', 's', 'https://api.raindrop.io/v1/raindrops/0?sort=-created&perpage=10&search=', function(response) {
    var res = JSON.parse(response.text);
    return res.items.map(item => ({title:item.title, url:item.link}));
}, {favicon_url:'https://raindrop.io/favicon.ico', skipMaps:false});