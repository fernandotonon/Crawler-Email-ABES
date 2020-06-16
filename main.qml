import QtQuick 2.12
import QtQuick.Window 2.12
import QtWebEngine 1.10

Window {
    visible: true
    width: 640
    height: 480
    title: qsTr("Crawler")
    property var links:[]
    property var emails:[]
    property string initialURL: "http://www.abessoftware.com.br/associados/socios"

    onLinksChanged: console.log(links)
    onEmailsChanged: console.log(emails)

    WebEngineView{
        onFindTextFinished: console.log(result)
        anchors.fill: parent
        url:initialURL
        onJavaScriptConsoleMessage: {console.log(message)
            if(message.startsWith("link:"))
                if(initialURL!=message.substring(5,message.length))
                    links.push(message.substring(5,message.length))
            if(message.startsWith("email:"))
                emails.push(message.substring(6,message.length))
        }
        onLoadingChanged: if(!loading) {
                              if(url == initialURL){
                                  runJavaScript("document.querySelectorAll('a[href^=\"/associados/socios/\"]').forEach(function(item){console.log('link:'+item.href)})")
                              }else{
                                  runJavaScript("console.log('email:'+document.querySelector('a[itemprop=\"email\"]').innerHTML)")
                              }
                              console.log(emails)
                              if(links.length>0)
                                url=links.pop();
                          }
    }
}

