#ifndef CHATMESSAGEREACTIONS_H
#define CHATMESSAGEREACTIONS_H

#include <QObject>

class ChatMessageReactions : public QObject
{
    Q_OBJECT
    Q_PROPERTY(int count READ count WRITE setCount NOTIFY chatMessageReactionsChanged)
    Q_PROPERTY(QString reaction READ reaction NOTIFY chatMessageReactionsChanged)

public:
    explicit ChatMessageReactions(QObject *parent = nullptr);
    explicit ChatMessageReactions(int count, QString reaction, QObject *parent = nullptr);

    int count() const;
    void setCount(int newCount);
    const QString &reaction() const;

signals:
    void chatMessageReactionsChanged();

private:
    int m_count;
    QString m_reaction;
};

#endif // CHATMESSAGEREACTIONS_H
