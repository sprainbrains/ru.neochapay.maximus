/*
 * Copyright (C) 2025 Sinyov Nikolay <nikolay.sinyov@gmail.com>
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

function getInitials(title) {
    if (!title) return "";
    var words = title.trim().split(/\s+/);
    if (words.length >= 2) {
        return words[0].charAt(0).toUpperCase() + words[1].charAt(0).toUpperCase();
    } else if (title.length >= 2) {
        return title.substring(0, 2).toUpperCase();
    }
    return title.charAt(0).toUpperCase();
}

function formatTime(dateTimeString) {
    if (!dateTimeString) return "";

    var date = new Date(dateTimeString);
    if (isNaN(date.getTime())) return "";

    var now = new Date();
    var today = new Date(now.getFullYear(), now.getMonth(), now.getDate());
    var yesterday = new Date(today);
    yesterday.setDate(yesterday.getDate() - 1);
    var lastWeek = new Date(today);
    lastWeek.setDate(lastWeek.getDate() - 7);

    if (date >= today) {
        return Qt.formatTime(date, "hh:mm");
    } else if (date >= yesterday) {
        return qsTr("yesterday");
    } else if (date >= lastWeek) {
        var days = [qsTr("Sun"), qsTr("Mon"), qsTr("Tue"), qsTr("Wed"),
                    qsTr("Thu"), qsTr("Fri"), qsTr("Sat")];
        return days[date.getDay()];
    } else {
        return Qt.formatDate(date, "dd.MM.yy");
    }
}

function formatMessageDate(dateTimeString) {
    var messageDate = new Date(dateTimeString);

    if (isNaN(messageDate.getTime())) return "";

    var now = new Date();

    if (messageDate.toDateString() === now.toDateString()) {
        return Qt.formatTime(messageDate, "hh:mm");
    }

    var yesterday = new Date();
    yesterday.setDate(yesterday.getDate() - 1);
    if (messageDate.toDateString() === yesterday.toDateString()) {
        return qsTr("Yesterday") + ", " + Qt.formatTime(messageDate, "hh:mm");
    }

    if (messageDate.getFullYear() === now.getFullYear()) {
        return Qt.formatDate(messageDate, "dd MMM") + ", " + Qt.formatTime(messageDate, "hh:mm");
    }

    return Qt.formatDate(messageDate, "dd MMM yyyy") + ", " + Qt.formatTime(messageDate, "hh:mm");
}

function formatLinks(text) {
    if (!text)
        return ""

    text = text.replace(/(https?:\/\/[^\s<]+|www\.[^\s<]+)/g,
                        function (url) {
                            var href = url.indexOf(
                                        'http') === 0 ? url : 'http://' + url
                            return '<a href="' + href + '">' + url + '</a>'
                        })

    // Форматирование email-адресов
    text = text.replace(
                /([a-zA-Z0-9._-]+@[a-zA-Z0-9._-]+\.[a-zA-Z0-9_-]+)/g,
                '<a href="mailto:$1">$1</a>')
    // Форматирование телефонных номеров (международный формат)
    text = text.replace(/(\+?[\d\s\-\(\)]{7,}\d)/g,
                        function (phone) {
                            var cleanPhone = phone.replace(
                                        /[^\d\+]/g, '')
                            return '<a href="tel:' + cleanPhone + '">' + phone + '</a>'
                        })
    return text
}

function formatMessagePreview(text) {
    var maxLength = 100;
    if (text.length <= maxLength) return text;
    return text.substring(0, maxLength) + '...';
}

function formatText(text) {
    if (!text) return "";

    // Разбиваем текст на абзацы
    var paragraphs = text.split(/\n\s*\n/);
    var htmlOutput = [];

    for (var i = 0; i < paragraphs.length; i++) {
        var para = paragraphs[i].trim();
        if (!para) continue;

        var lines = para.split('\n');
        var isList = false;
        var listType = null; // 'ul' или 'ol'
        var listItems = [];

        // Проверяем, является ли блок списком
        for (var j = 0; j < lines.length; j++) {
            var line = lines[j].trim();

            if (/^\s*[\-\*•]\s+/.test(line)) {
                if (listType !== 'ol') listType = 'ul';
                isList = true;
                listItems.push(line);
            }
            else if (/^\s*\d+\.\s+/.test(line)) {
                if (listType !== 'ul') listType = 'ol';
                isList = true;
                listItems.push(line);
            }
            else {
                // Если хотя бы одна строка не элемент списка - прерываем
                if (listItems.length > 0) {
                    break;
                }
            }
        }

        // Форматируем списки
        if (isList && listItems.length === lines.length) {
            htmlOutput.push('<' + listType + '>');

            for (var j = 0; j < listItems.length; j++) {
                var item = listItems[j].trim();
                var itemText = item
                    .replace(/^\s*[\-\*•]\s+/, '')
                    .replace(/^\s*\d+\.\s+/, '');

                htmlOutput.push('<li>' + formatLinks(itemText) + '</li>');
            }

            htmlOutput.push('</' + listType + '>');
        }
        // Форматируем обычный текст
        else {
            var content = lines.join('<br>');
            // Обрабатываем моноширинные блоки
            content = content.replace(/```([\s\S]*?)```/g, '<pre>$1</pre>');
            // Обрабатываем инлайновый код
            content = content.replace(/`([^`]+)`/g, '<code>$1</code>');
            htmlOutput.push('<p>' + formatLinks(content) + '</p>');
        }
    }

    return htmlOutput.join('');
}
