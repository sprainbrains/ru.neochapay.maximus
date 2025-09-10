/*
 * Copyright (C) 2025 Chupligin Sergey <neochapay@gmail.com>
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

#include "webpimageprovider.h"
#include "qwebp.h"

#include <QFile>
#include <QDebug>

WebpImageProvider::WebpImageProvider()
    : QQuickImageProvider(QQuickImageProvider::Image)
{
}

QImage WebpImageProvider::requestImage(const QString &id, QSize *size, const QSize &requestedSize)
{
    QByteArray imageData = formatData(id);
    QWebP* wpImage = new QWebP(imageData);
    QImage requestedImage = wpImage->get();

    if(size) {
        *size = QSize(requestedImage.width(), requestedImage.height());
    }

    if(requestedSize.width() > 0 && requestedSize.height() > 0 ){
        return requestedImage.scaled(requestedSize.width(), requestedSize.height(), Qt::KeepAspectRatio);
    }
    return requestedImage;
}

QPixmap WebpImageProvider::requestPixmap(const QString &id, QSize *size, const QSize &requestedSize)
{
    QWebP* wpImage = new QWebP(id.toLatin1());
    QImage requestedImage = wpImage->get();
    if(size) {
        *size = QSize(requestedImage.width(), requestedImage.height());
    }

    if(requestedSize.width() > 0 && requestedSize.height() > 0 ){
        return QPixmap::fromImage(requestedImage.scaled(requestedSize.width(), requestedSize.height(), Qt::KeepAspectRatio));
    }
    return QPixmap::fromImage(requestedImage);
}

QByteArray WebpImageProvider::formatData(QString id)
{
    if(id.startsWith("base64")) {
        QByteArray base64 = id.toUtf8();
        base64.replace("base64,", "");

        qDebug() << Q_FUNC_INFO << id;
        qDebug() << Q_FUNC_INFO << base64;

        return QByteArray::fromBase64(base64);
    } else {
        QFile imageFile(id);
        if(!imageFile.exists()) {
            return QByteArray();
        }
        return imageFile.readAll();;
    }
    return QByteArray();
}
