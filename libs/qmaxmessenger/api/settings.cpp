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

#include "settings.h"

#include <QMutex>
#include <QFile>

static Settings* settingsInstance = 0;

Settings::Settings(QObject* parent)
    : QSettings(parent)
{
    QMutexLocker locker(&m_lock);
}

Settings::~Settings()
{
    sync();
}

Settings *Settings::instance()
{
    static QMutex mutex;
    QMutexLocker locker(&mutex);
    if (!settingsInstance) {
        settingsInstance = new Settings();
    }
    return settingsInstance;
}

QVariant Settings::value(const QString &key, const QVariant defaultValue)
{
    return QSettings::value(key, defaultValue);
}

bool Settings::boolValue(const QString& key, bool defaultValue)
{
    return QSettings::value(key, defaultValue).toBool();
}

void Settings::reset()
{
    QFile::remove(this->fileName());
}

void Settings::setValue(const QString& key, const QVariant& value)
{

    // change the setting and emit a changed signal
    // (we are not checking if the value really changed before emitting for simplicity)
    QSettings::setValue(key, value);
    emit settingChanged(key);
}

void Settings::setValueIfNotSet(const QString& key, const QVariant& value)
{
    // change the setting and emit a changed signal
    if (!QSettings::contains(key)) {
        QSettings::setValue(key, value);
        // (we are not checking if the value really changed before emitting for simplicity)
        emit settingChanged(key);
    }
}


