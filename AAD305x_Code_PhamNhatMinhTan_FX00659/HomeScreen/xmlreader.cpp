#include "xmlreader.h"

XmlReader::XmlReader(QString filePath, ApplicationsModel &model)
{
    m_filePath = PROJECT_PATH + filePath;
    m_appModel = &model;
    ReadXmlFile(m_filePath);
    PaserXml(model);
}

/// Read XML file
bool XmlReader::ReadXmlFile(QString filePath)
{
    // Load xml file as raw data
    QFile f(filePath);
    if (!f.open(QIODevice::ReadOnly ))
    {
        // Error while loading file
        return false;
    }
    // Set data into the QDomDocument before processing
    m_xmlDoc.setContent(&f);
    f.close();
    return true;
}

/// Convert data in XML file to application model
void XmlReader::PaserXml(ApplicationsModel &model)
{
    // Extract the root markup
    QDomElement root = m_xmlDoc.documentElement();

    // Get the first child of the root (Markup COMPONENT is expected)
    QDomElement Component = root.firstChild().toElement();

    // Loop while there is a child
    while(!Component.isNull())
    {
        // Check if the child tag name is COMPONENT
        if (Component.tagName() == "APP")
        {

            // Read and display the component ID
            QString ID = Component.attribute("ID","No ID");

            // Get the first child of the component
            QDomElement Child = Component.firstChild().toElement();

            QString title;
            QString url;
            QString iconPath;

            // Read each child of the component node
            while (!Child.isNull())
            {
                // Read Name and value
                if (Child.tagName() == "TITLE") title = Child.firstChild().toText().data();
                if (Child.tagName() == "URL") url = Child.firstChild().toText().data();
                if (Child.tagName() == "ICON_PATH") iconPath = Child.firstChild().toText().data();

                // Next child
                Child = Child.nextSibling().toElement();
            }
            ApplicationItem item(title,url,iconPath);
            model.addApplication(item);
        }

        // Next component
        Component = Component.nextSibling().toElement();
    }

    // Copy default app list to reorder app list
    model.copy();
}

/// Save XML data to file
void XmlReader::writeXMLFile() {

    // Convert application list to XML
    QDomDocument document = parserApplicationList(m_appModel->getAppsList());

    // Write XML data to file
    QFile file(m_filePath);
    if( !file.open( QIODevice::WriteOnly | QIODevice::Text ) )
    {
        qDebug( "Failed to open file for writing." );
        qDebug() << "ERROR" << file.errorString() << endl;
    }
    QTextStream stream( &file );
    stream << document.toString();
    file.close();
}

/// Convert application model to XML
QDomDocument XmlReader::parserApplicationList(QList<ApplicationItem> apps) {

    int count = 1;

    /********** Create root APPLICATIONS ************/
    // Create a document to write XML
    QDomDocument document;
    // Making the root element
    QDomElement root = document.createElement("APPLICATIONS");
    // Adding the root element to the docuemnt
    document.appendChild(root);

    /********** Create node of APPLICATIONS ************/
    foreach (ApplicationItem item , apps) {

        /********** Create node APP ************/
        // Making the APP element and add
        QDomElement app = document.createElement("APP");
        app.setAttribute("ID", "00" + QString::number(count));
        root.appendChild(app);

        /********** Create child of APP ************/
        // TITLE
        QDomElement title = document.createElement("TITLE");
        title.appendChild(document.createTextNode(item.title()));
        app.appendChild(title);
        // URL
        QDomElement url = document.createElement("URL");
        url.appendChild(document.createTextNode(item.url()));
        app.appendChild(url);
        // ICON_PATH
        QDomElement icon_path = document.createElement("ICON_PATH");
        icon_path.appendChild(document.createTextNode(item.iconPath()));
        app.appendChild(icon_path);

        count++;
    }

    return document;
}
