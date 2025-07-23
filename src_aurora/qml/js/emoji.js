/*
 * Copyright (C) 2025 Tatiana <0728th61@gmail.com>
 *
 * This library is free software; you can redistribute it and/or
 * modify it under the terms of the GNU Library General Public
 * License as published by the Free Software Foundation; either
 * version 2 of the License, or (at your option) any later version.
 *
 * This library is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
 * Library General Public License for more details.
 *
 * You should have received a copy of the GNU Library General Public License
 * along with this library; see the file COPYING.LIB.  If not, write to
 * the Free Software Foundation, Inc., 51 Franklin Street, Fifth Floor,
 * Boston, MA 02110-1301, USA.
 */

.pragma library  // Remove this if you want per-instance functions

function getCodePoint(chars) {
    if (chars.length === 1) {
        return chars.charCodeAt(0);
    }
    var high = chars.charCodeAt(0);  // Changed `const` → `var`
    var low = chars.charCodeAt(1);   // Changed `const` → `var`
    return (high - 0xD800) * 0x400 + (low - 0xDC00) + 0x10000;
}

function convertToOriginalHtml(textWithEmojis) {
    // Use `var` instead of `const`
    var emojiRegex = /([\uD800-\uDBFF][\uDC00-\uDFFF])|./g;
    var htmlParts = [];
    var match;

    while ((match = emojiRegex.exec(textWithEmojis)) !== null) {
        var charS = match[0];
        var codePoint;

        if (charS.length === 1) {
            codePoint = charS.charCodeAt(0);
        } else {
            codePoint = getCodePoint(charS);
        }

        if (charS.length === 2 ||
            codePoint > 0xFFFF ||
            (codePoint >= 0x2600 && codePoint <= 0x26FF) ||  // Miscellaneous Symbols
            (codePoint >= 0x2700 && codePoint <= 0x27BF)     // Dingbats
        ) {
            var hexCode = codePoint.toString(16);
            htmlParts.push('<img src="file:///usr/share/ru.neochapay.maximus/qml/emojiSvgs/' + hexCode + '.svg" width="40" height="40"/>');
            htmlParts.push(' ');
        } else {
            htmlParts.push(charS);
        }
    }

    // Replaced template literals with string concatenation
    var msg = '<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.0//EN" "http://www.w3.org/TR/REC-html40/strict.dtd">' +
              '<html><head><meta name="qrichtext" content="1" /><style type="text/css">' +
              '</style></head><body style=" font-family:\'ALS Hauss Variable\'; font-size:32px; font-weight:400; font-style:normal;">' +
              '<p style=" margin-top:0px; margin-bottom:0px; margin-left:0px; margin-right:0px; -qt-block-indent:0; text-indent:0px;">' +
              htmlParts.join('') + '</p></body></html>';

    //console.log(msg);
    return msg;
}


function extractTextWithEmojis(htmlString) {
    // Replace const with var
    var decodedString = htmlString.replace('<img src="data:image/png;base64,iVBORw0KGgoAAAANSUhEUgAAAAEAAAABCAQAAAC1HAwCAAAAC0lEQVR42mNkYAAAAAYAAjCB0C8AAAAASUVORK5CYII=" width="5" height="1"/>', '');
    var textMatch = decodedString.match(/<p[^>]*>([\s\S]*?)<\/p>/i);
    if (!textMatch) return '';

    var pContent = textMatch[1];
    var result = '';

    // Process text nodes and img tags
    var lastIndex = 0;
    var imgRegex = /<img[^>]+src="([^"]+)"[^>]*>/gi;
    var imgMatch;

    while ((imgMatch = imgRegex.exec(pContent)) !== null) {
        // Add text before the image
        result += pContent.slice(lastIndex, imgMatch.index);
        lastIndex = imgRegex.lastIndex;

        // Process image
        var src = imgMatch[1];
        var emojiMatch = src.match(/([0-9a-f]+)\.svg$/i);
        if (emojiMatch) {
            var codePoint = parseInt(emojiMatch[1], 16);
            // String.fromCodePoint polyfill for older environments
            if (codePoint <= 0xFFFF) {
                result += String.fromCharCode(codePoint);
            } else {
                // For code points beyond BMP (Basic Multilingual Plane)
                var offset = codePoint - 0x10000;
                result += String.fromCharCode(
                            0xD800 + (offset >> 10),
                            0xDC00 + (offset & 0x3FF)
                            );
            }
        }
    }

    // Add remaining text after last image
    result += pContent.slice(lastIndex);

    // Clean up HTML entities and tags if needed
    return result.replace(/&[^;]+;/g, '').replace(/<[^>]+>/g, '');
}
