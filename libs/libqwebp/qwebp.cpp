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

#include "qwebp.h"
#include <QDebug>

QWebP::QWebP(QByteArray data)
    : m_data(data)
    , is_valid(false)
    , m_features()
{
    VP8StatusCode code = WebPGetFeatures(reinterpret_cast<const uint8_t*>(m_data.constData()), m_data.size(), &m_features);
    if(code == VP8StatusCode::VP8_STATUS_OK) {
        qDebug() << "All is well";
        is_valid = true;
    } else {
        qWarning() << "Something was wrong!" << code;
    }
}

QImage QWebP::get()
{
    if(!is_valid) {
        qWarning() << "Image not valid";
        return QImage();
    }
    QImage result(m_features.width, m_features.height, QImage::Format_ARGB32);
    uint8_t *output = result.bits();
    size_t output_size = result.byteCount();
#if Q_BYTE_ORDER == Q_LITTLE_ENDIAN
    WebPDecodeBGRAInto(reinterpret_cast<const uint8_t*>(m_data.constData()), m_data.size(), output, output_size, result.bytesPerLine());
#else
    WebPDecodeARGBInto(reinterpret_cast<const uint8_t*>(m_data.constData()), m_data.size(), output, output_size, result.bytesPerLine());
#endif
    return result;
}
