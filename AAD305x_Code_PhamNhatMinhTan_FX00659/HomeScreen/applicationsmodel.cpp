#include "applicationsmodel.h"

ApplicationItem::ApplicationItem(QString title, QString url, QString iconPath)
{
    m_title = title;
    m_url = url;
    m_iconPath = iconPath;
}

QString ApplicationItem::title() const
{
    return m_title;
}

QString ApplicationItem::url() const
{
    return m_url;
}

QString ApplicationItem::iconPath() const
{
    return m_iconPath;
}

ApplicationsModel::ApplicationsModel(QObject *parent)
{
    Q_UNUSED(parent)
}

int ApplicationsModel::rowCount(const QModelIndex &parent) const
{
    Q_UNUSED(parent);
    return m_data.count();
}

QVariant ApplicationsModel::data(const QModelIndex &index, int role) const
{
    if (index.row() < 0 || index.row() >= m_data.count())
        return QVariant();

    const ApplicationItem &item = m_data[index.row()];
    if (role == TitleRole)
        return item.title();
    else if (role == UrlRole)
        return item.url();
    else if (role == IconPathRole)
        return item.iconPath();
    return QVariant();
}

void ApplicationsModel::addApplication(ApplicationItem &item)
{
    beginInsertRows(QModelIndex(), rowCount(), rowCount());
    m_data << item;
    endInsertRows();
}

/// Get applications list after reorder an application
QList<ApplicationItem> ApplicationsModel::getAppsList() {
    return m_reorderData;
}

/// Copy default application list to application list after reorder
void ApplicationsModel::copy() {
    m_reorderData = m_data;
}

QHash<int, QByteArray> ApplicationsModel::roleNames() const
{
    QHash<int, QByteArray> roles;
    roles[TitleRole] = "title";
    roles[UrlRole] = "url";
    roles[IconPathRole] = "iconPath";
    return roles;
}

/// Get application from qml to add to QList
void ApplicationsModel::getApplication(int index, QString title, QString url, QString iconPath) {
    ApplicationItem applicationItem(title, url, iconPath);
    m_reorderData[index] = applicationItem;
}

