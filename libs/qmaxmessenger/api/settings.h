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

#ifndef SETTINGS_H
#define SETTINGS_H

#include <QMutex>
#include <QObject>
#include <QSettings>

class Settings : public QSettings {
    Q_OBJECT
public:
    Settings(QObject* parent = 0);
    virtual ~Settings();
    static Settings *instance();

    Q_INVOKABLE void setValue(const QString& key, const QVariant& value);
    Q_INVOKABLE void setValueIfNotSet(const QString& key, const QVariant& value);
    Q_INVOKABLE QVariant value(const QString& key, const QVariant defaultValue = QVariant());
    Q_INVOKABLE bool boolValue(const QString& key, const bool defaultValue);

signals:
    void settingChanged(const QString& key);

private:
    QMutex m_lock;
};

#endif // SETTINGS_H
