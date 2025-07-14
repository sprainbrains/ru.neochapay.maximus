#include "chatmessagereactions.h"

ChatMessageReactions::ChatMessageReactions(QObject *parent)
    : QObject(parent)
{
}

ChatMessageReactions::ChatMessageReactions(int count, QString reaction, QObject *parent)
    : QObject(parent)
    , m_count(count)
    , m_reaction(reaction)
{
}

int ChatMessageReactions::count() const
{
    return m_count;
}

void ChatMessageReactions::setCount(int newCount)
{
    if (m_count == newCount)
        return;
    m_count = newCount;
    emit chatMessageReactionsChanged();
}

const QString &ChatMessageReactions::reaction() const
{
    return m_reaction;
}
