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

#ifndef RAWAPIMESSAGE_H
#define RAWAPIMESSAGE_H

#include <QJsonObject>
#include <QObject>

class RawApiMessage : public QObject
{
    Q_OBJECT
    Q_PROPERTY(Type type READ type WRITE setType NOTIFY rawMessageChanged)
    Q_PROPERTY(int opcode READ opcode WRITE setOpcode NOTIFY rawMessageChanged)
    Q_PROPERTY(int seq READ seq WRITE setSeq NOTIFY rawMessageChanged)
    Q_PROPERTY(int ver READ ver)
    Q_PROPERTY(QJsonObject payload READ payload WRITE setPayload NOTIFY rawMessageChanged)

public:
    enum Type{
        out = 0,
        in = 1
    };

    explicit RawApiMessage(QObject *parent = nullptr);
    RawApiMessage(QString jsonString, QObject *parent = nullptr);
    RawApiMessage(const RawApiMessage& other, QObject *parent = nullptr);
    RawApiMessage& operator=(const RawApiMessage&other);

    Type type() const;
    void setType(Type newType);

    int opcode() const;
    void setOpcode(int newOptcode);

    int seq() const;
    void setSeq(int newSeq);

    int ver() { return 11;}

    const QJsonObject &payload() const;
    void setPayload(const QJsonObject &newPayload);

    QString toJsonString();
    void formJsonString(QString jsonString);

signals:
    void rawMessageChanged();

private:
    Type m_type;
    int m_opcode;
    int m_seq;
    int m_ver;
    QJsonObject m_payload;
};

#endif // RAWAPIMESSAGE_H
