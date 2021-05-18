#ifndef XMLREADER_H
#define XMLREADER_H
#include <QtXml>
#include <QFile>
#include "applicationsmodel.h"

class XmlReader :public QObject
{
    Q_OBJECT
public:
    XmlReader(QString filePath, ApplicationsModel &model);
private:
    QDomDocument m_xmlDoc;  // The QDomDocument class represents an XML document.
    QString m_filePath;     // The string to store the filePath
    ApplicationsModel *m_appModel;  // The model to store data of Application model
    bool ReadXmlFile(QString filePath);         // Read XML file
    void PaserXml(ApplicationsModel &model);    // Convert data in XML file to application model
    QDomDocument parserApplicationList(QList<ApplicationItem> apps);    // Convert application model to XML
public slots:
    void writeXMLFile();    // Save XML data to file
};

#endif // XMLREADER_H
